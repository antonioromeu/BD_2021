# !/usr/bin/python3
# coding: utf-8

from​ wsgiref.handlers ​import​ CGIHandler
from​ flask ​import​ Flask
## Bibliotecas postgres
import​ psycopg2
import​ psycopg2.extras


# SGBD configs
DB_HOST="db.tecnico.ulisboa.pt”
DB_USER="istXXXXX" 
DB_PASSWORD="ZZZZZ" DB_DATABASE=DB_USER
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)
app = Flask(__name__)

@app.route('/') # <test.cgi>
def medicos_insert():
    title = "medicos insert"
    if request.method == "POST":
        ced = request.form("cedula")
        nome = request.form("nome")
        esp = request.form("especialidade")
        return nome
        

# @app.route('/')   # <test.cgi>
# def list_accounts():

#     dbConn = None
#     cursor = None
    # try:
    #     dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    #     cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    #     cursor.execute("SELECT * FROM account;")html = #TODO ..... A completar.....
    #     # return html #Renders the html string
    #     return render_template("index.html", cursor = cursor)  # index.htmlè~/web/templates/ /index.htm
    #     return render_template("accounts.html", cursor = cursor) # index.htmlè~/web/templates/ /index.htm
    # except Exception as e:
    #     # return e #Renders a page with the error.
    #     return str(e) #Renders a page with the error.
    # finally:
    #     cursor.close()
    #     dbConn.close()


# @app.route('/balance')
# def alter_balance():
#     try:
#         return render_template("balance.html", params=request.args)
#     except Exception as e:
#         return str(e)