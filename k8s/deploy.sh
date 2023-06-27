#!/bin/bash

namespace="pega"
pega_dump_file=$1

wait_for_pods() {
    echo "Waiting for pods to be up and running"
    while [[ $(kubectl get pods -n $namespace -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') == *"False"* ]]; do
        sleep 1
    done
}

create_pega_db() {
    
    for pod in $(kubectl get pods -n $namespace -o=jsonpath={.items..metadata.name}); do

        if [[ $pod == postgres* ]]; then
            # Copy .psqlrc into the pod
            kubectl cp .psqlrc $namespace/$pod:/root
            pega_schemas=(`kubectl exec -it $pod -n $namespace -- psql -U postgres -d postgres -c "SELECT * FROM information_schema.schemata WHERE schema_name = 'data' or schema_name ='rules';" | grep rows`)
                
            if [[ "${pega_schemas:1:1}" == "2" ]]; then
                echo "Pega database already exists!"
                    
            else
                echo "Attempting to create a new pega database..."
                if [ -f "$pega_dump_file" ]; then
                    echo "Copying pega.dump to pod: $pod"
                    kubectl cp $pega_dump_file $namespace/$pod:/var/lib/postgresql/data
                    echo "Generating data and rules schemas..."
                    kubectl exec -it $pod -n $namespace -- pg_restore -U postgres -d postgres /var/lib/postgresql/data/pega.dump
                else
                    echo "pega.dump file not found."
                    exit 1
                fi            
            fi
        fi
    done
}

build_pega_docker_image() {
    docker build -t pega-pe:monitoring ../pega
}

start_node_exporter() {
    for pod in $(kubectl get pods -n $namespace -o=jsonpath={.items..metadata.name}); do

        if [[ $pod == pega* ]]; then
        echo "Starting node_exporter service in pod: $pod"
            kubectl exec -it $pod -n $namespace -- systemctl --user start node_exporter
        fi
    done  
}

create_kube_resources() {

    kubectl apply -f 1-postgres-pvc.yml
    kubectl apply -f 2-postgres-config.yml
    kubectl apply -f 3-postgres-deployment.yml
    wait_for_pods
    kubectl apply -f 4-postgres-service.yml
    create_pega_db
    kubectl apply -f 5-pega-backing-services-pvc.yml
    kubectl apply -f 6-pega-config.yml
    build_pega_docker_image
    kubectl apply -f 7-pega-deployment.yml
    wait_for_pods
    kubectl apply -f 8-pega-service.yml
    kubectl apply -f 9-pega-web-ingress-service.yml
    start_node_exporter
    kubectl apply -f 10-pega-monitors.yml
    echo "Deployment finished!" 
}

# Check if the namespace exists
if kubectl get namespace "$namespace" >/dev/null 2>&1; then
    echo "Namespace '$namespace' exists, reconfiguring resources..."
    create_kube_resources
else
    echo "Namespace '$namespace' does not exist, creating..."
    kubectl create ns $namespace
    create_kube_resources
fi
