#!/bin/bash
set -e

echo "=== Iniciando configuración PostgreSQL para ChirpStack ==="

# Si POSTGRES_USER es chirpstack, no necesitamos crear el rol
if [ "$POSTGRES_USER" != "chirpstack" ]; then
    echo "Creando usuario chirpstack..."
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        CREATE ROLE IF NOT EXISTS chirpstack WITH LOGIN PASSWORD 'chirpstack';
        CREATE DATABASE IF NOT EXISTS chirpstack WITH OWNER chirpstack;
EOSQL
else
    echo "Usuario chirpstack ya existe (es el superusuario)"
fi

# Crear extensiones (usar el usuario correcto)
echo "Creando extensiones en base de datos $POSTGRES_DB..."
psql -v ON_ERROR_STOP=1 --username="$POSTGRES_USER" --dbname="$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    CREATE EXTENSION IF NOT EXISTS hstore;
    
    -- Verificar que se crearon
    SELECT 'Extensiones creadas:' as status;
    SELECT extname, extversion FROM pg_extension WHERE extname IN ('pg_trgm', 'hstore');
EOSQL

echo "=== Configuración PostgreSQL completada ==="