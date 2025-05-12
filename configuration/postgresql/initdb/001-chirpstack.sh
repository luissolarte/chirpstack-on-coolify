#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    create role chirpstack with login password 'root';
    create database chirpstack with owner chirpstack;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname="chirpstack" <<-EOSQL
    create extension pg_trgm;
    create extension hstore;
EOSQL