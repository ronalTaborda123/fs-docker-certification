#!/bin/bash
set -e

POSTGRES="psql --username ${POSTGRES_USER} -v ON_ERROR_STOP=1"

$POSTGRES --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE orders;
    CREATE DATABASE keycloak;
EOSQL

$POSTGRES --dbname "orders" <<-EOSQL
    CREATE TABLE ORDERS(
        idorders SERIAL PRIMARY KEY,
        total DECIMAL NOT NULL,
        discount DECIMAL NOT NULL,
        status VARCHAR NOT NULL
    );
    CREATE TABLE PRODUCTS(
        id SERIAL PRIMARY KEY,
        name VARCHAR NOT NULL,
        description VARCHAR NOT NULL,
        base_price DECIMAL NOT NULL,
        tax_rate DECIMAL NOT NULL,
        status VARCHAR NOT NULL,
        inventory_quantity INT NOT NULL
    );
    CREATE TABLE PRODUCTS_ORDERS(
        idproduct_orders SERIAL PRIMARY KEY,
        idorders INTEGER NOT NULL,
        id INTEGER NOT NULL,
        FOREIGN KEY(idorders) REFERENCES ORDERS(idorders),
        FOREIGN KEY(id) REFERENCES PRODUCTS(id)
    );
    CREATE TABLE IMAGES(
        idimages SERIAL PRIMARY KEY,
        id INTEGER NOT NULL,
        name VARCHAR NOT NULL,
        type VARCHAR NOT NULL,
        picByte BYTEA NOT NULL,
        FOREIGN KEY(id) REFERENCES PRODUCTS(id)
    );
EOSQL