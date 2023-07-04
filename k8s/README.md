# Pega Personal Edition deployment on k8s
### Prerequisities
- `pega.dump` file <br>
- `prweb.war` file <br>
  Put it into the `pega` directory.
- NGINX Ingress Controller <br>
  Make sure that you have NGINX Ingress Controller for Kubernetes installed. Also, edit your `hosts` file to add `127.0.0.1       my-pega-personal.internal`

### Deployment
Swtich to the `k8s` folder and run `./deploy.sh <path to the pega.dump file>`. <br>

Check running pods.

![image](https://github.com/engncnyldz/pega-docker-compose/assets/18334895/ef5b6290-a756-4ea8-b12c-1c1021bdea53)
<br>

Go to http://my-pega-personal.internal/prweb
![image](https://github.com/engncnyldz/pega-docker-compose/assets/18334895/396622df-7f18-4f92-a92b-ed51c7a95b60)


### Monitoring Support
This deployments installs Prometheus `node_exporter` into Pega nodes, so if you have `kube-prometheus-stack` installed on your k8s cluster, you can monitor your Pega nodes on Grafana. <br>


![image](https://github.com/engncnyldz/pega-docker-compose/assets/18334895/a0223401-26d3-4a6f-bab1-2e56fdfa0aa0)

![image](https://github.com/engncnyldz/pega-docker-compose/assets/18334895/42e6d1b6-2470-4405-b2f2-29ed41aa29be)
