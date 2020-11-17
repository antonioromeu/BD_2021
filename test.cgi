#!/usr/bin/python3
import psycopg2
import psycopg2.extras



## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="" 
DB_DATABASE=DB_USER
DB_PASSWORD=""
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)
