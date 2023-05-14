#!bin/bash

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	SET pljava.libjvm_location TO '/usr/lib/jvm/default-java/lib/server/libjvm.so';
	CREATE EXTENSION pljava;
	GRANT USAGE ON LANGUAGE java TO postgres;
EOSQL