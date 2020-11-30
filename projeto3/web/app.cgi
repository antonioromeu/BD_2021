#!/usr/bin/python3

import html
import cgi
import cgitb; cgitb.enable()
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request

## Libs postgres
import psycopg2
import psycopg2.extras

app = Flask(__name__)

## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="ist192427"
DB_DATABASE=DB_USER
DB_PASSWORD="gpmi9572"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

## Runs the function once the root page is requested.
## The request comes with the folder structure setting ~/web as the root
@app.route('/')
def main_menu():
    try:
        return render_template("index.html")
    except Exception as e:
        return str(e)

@app.route('/instituicoes')
def list_instituicoes_edit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM instituicao;"
        cursor.execute(query)
        return render_template("instituicoes.html", cursor = cursor) #, params = request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/instituicoes_editar', methods=["POST"])
def edit_instituicoes():
    try:
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        return render_template("instituicoes_editar.html", params = form)
    except Exception as e:
        return str(e)

@app.route('/instituicoes_editar_submit', methods=["POST"])
def edit_update_instituicoes():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        nome = form["nome"].value
        # tipo = form["tipo"].value
        # novo_nome = form["novo_nome"].value
        novo_num_regiao = form["novo_num_regiao"].value
        novo_num_concelho = form["novo_num_concelho"].value
        # query = "WITH \
        # new_venda_farmacia AS ( \
        # UPDATE venda_farmacia \
        #     SET inst = %s \
        # WHERE inst = %s), \
        # new_consulta AS ( \
        # UPDATE consulta \
        #     SET nome_instituicao = %s \
        # WHERE nome_instituicao = %s), \
        # new_analise AS ( \
        # UPDATE analise \
        #     SET inst = %s \
        # WHERE inst = %s) \
        # UPDATE instituicao \
        #     SET nome = %s, num_regiao = %s, num_concelho = %s \
        # WHERE nome = %s;"
        # data = (novo_nome, nome, novo_nome, nome, novo_nome, nome, novo_nome, novo_num_regiao, novo_num_concelho, nome)
        query = "UPDATE instituicao \
        SET num_regiao = %s, num_concelho = %s \
        WHERE nome = %s;"
        data = (novo_num_regiao, novo_num_concelho, nome)
        cursor.execute(query, data)
        return render_template("instituicoes_editar_submit.html", params = form)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/instituicoes_remover', methods=["POST"])
def remove_instituicoes():
    try:
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        nome = form["nome"].value
        query = "DELETE FROM instituicoes \
            WHERE nome = %s cascade;"
        data = (nome)
        cursor.execute(query, data)
        return render_template("instituicoes_remover.html", params = form)
        # DELETE FROM some_child_table WHERE some_fk_field IN (SELECT some_id FROM some_Table);
        # DELETE FROM some_table;
    except Exception as e:
        return str(e)

@app.route('/instituicoes_adicionar', methods=["POST"])
def add_instituicoes():
    try:
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        return render_template("instituicoes_adicionar.html", params = form)
    except Exception as e:
        return str(e)

@app.route('/instituicoes_adicionar_submit', methods=["POST"])
def add_update_instituicoes():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        nome = form["novo_nome"].value
        tipo = form["novo_tipo"].value
        num_regiao = form["novo_num_regiao"].value
        num_concelho = form["novo_num_concelho"].value
        query = "INSERT INTO instituicao VALUES (%s, %s, %s, %s);"
        data = (nome, tipo, num_regiao, num_concelho)
        cursor.execute(query, data)
        return render_template("instituicoes_adicionar_submit.html", params = form)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/medicos')
def list_medicos():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM medico;"
        cursor.execute(query)
        return render_template("medicos.html", cursor = cursor) #, params = request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/medicos_adicionar', methods=["POST"])
def add_medicos():
    try:
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        return render_template("medicos_adicionar.html", params = form)
    except Exception as e:
        return str(e)

@app.route('/medicos_adicionar_submit', methods=["POST"])
def add_update_medicos():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        num_cedula = form["novo_num_cedula"].value
        nome = form["novo_nome"].value
        especialidade = form["nova_especialidade"].value
        query = "INSERT INTO medico VALUES (%s, %s, %s);"
        data = (num_cedula, nome, especialidade)
        cursor.execute(query, data)
        return render_template("medicos_adicionar_submit.html", params = form)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/medicos_editar', methods=["POST"])
def edit_medicos():
    try:
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        return render_template("medicos_editar.html", params = form)
    except Exception as e:
        return str(e)

@app.route('/medicos_editar_submit', methods=["POST"])
def edit_update_medicos():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        nome = form["nome"].value
        num_cedula = form["num_cedula"].value
        novo_num_cedula = form["novo_num_cedula"].value
        novo_nome = form["novo_nome"].value
        nova_especialide = form["nova_especialidade"].value
        query = "UPDATE medico \
            SET nome = %s, especialidade = %s \
        WHERE num_cedula = %s;"
        data = (novo_num_cedula, novo_nome, nova_especialide, num_cedula)
        cursor.execute(query, data)
        return render_template("medicos_editar_submit.html", params = form)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/prescricoes')
def list_prescricoes():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM prescricao;"
        cursor.execute(query)
        return render_template("prescricoes.html", cursor = cursor) #, params = request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/prescricoes_adicionar', methods=["POST"])
def add_prescricoes():
    try:
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        return render_template("prescricoes_adicionar.html", params = form)
    except Exception as e:
        return str(e)

@app.route('/prescricoes_adicionar_submit', methods=["POST"])
def add_update_prescricoes():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        num_cedula = form["novo_num_cedula"].value
        num_doente = form["novo_num_doente"].value
        data = form["nova_data"].value
        substancia = form["nova_substancia"].value
        quantidade = form["nova_quantidade"].value
        query = "INSERT INTO prescricao VALUES (%s, %s, %s, %s, %s);"
        data = (num_cedula, num_doente, data, substancia, quantidade)
        cursor.execute(query, data)
        return render_template("prescricoes_adicionar_submit.html", params = form)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route('/prescricoes_filtrar', methods=["POST"])
def add_prescricoes_filtrar():
    try:
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        return render_template("prescricoes_filtrar.html", params = form)
    except Exception as e:
        return str(e)

@app.route('/prescricoes_filtrar_submit', methods=["POST"])
def list_prescricoes_filtrar_submit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        num_cedula = form["num_cedula"].value
        mes = form["mes"].value
        query = "SELECT * FROM prescricao \
            WHERE num_cedula = %s \
            AND (SELECT EXTRACT(MONTH FROM data_)) = %s;"
        data = (num_cedula, mes)
        cursor.execute(query, data)
        return render_template("prescricoes_filtrar_submit.html", cursor = cursor) #, params = request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/analises')
def list_analises():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        query = "SELECT * FROM analise;"
        cursor.execute(query)
        return render_template("analises.html", cursor = cursor) #, params = request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route('/analises_glicemia', methods=["POST"])
def analises_glicemia():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        form = cgi.FieldStorage(environ={'REQUEST_METHOD':'POST'})
        return render_template("analises_glicemia.html", params = form, cursor = cursor)
    except Exception as e:
        return str(e)

CGIHandler().run(app)