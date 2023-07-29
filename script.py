# 5.
import psycopg2

# O seguinte import seria para realizar requisições HTTP e assim conseguir consumir apis
#import requests

import datetime

import pandas

connection = psycopg2.connect(
    database="postgres",
    user="postgres",
    password="4dmin@%",
    host="127.0.0.1",
    port="5432",
)

connection.autocommit = True

cursor = connection.cursor()

sql1 = """create table if not exists stg_prontuario.copia_sigtap(\
id serial PRIMARY KEY,\
procedimento varchar(50) not null,\
medicamento varchar(50) not null,\
opm varchar(50) not null);"""

cursor.execute(sql1)

sql2 = """copy stg_prontuario.copia_sigtap(\
procedimento, medicamento, opm)\
from 'C:\git\eds-avaliacao-data-engineer\data.csv'\
delimiter ','\
csv header;"""

cursor.execute(sql2)

# 6.
# As próximas duas linhas exemplificam o consumo de uma api em um determinado endpoint
#api_url = "https://sigtap.api/registros"
#response = requests.get(api_url).json()

# Essa seria a consulta do problema 5 adaptada para o uso de objetos do tipo JSON
#sql3 = """insert into stg_prontuario.copia_sigtap\
#select procedimento, medicamento, opm\
#from json_populate_recordset(null::stg_prontuario.copia_sigtap, %s);"""

# E essa seria a forma de executar o script sql passando o objeto salvo na variável response
#cursor.execute(sql3, response)


# 9.
def is_prescicao_possivel(prescricao, estoque):
    is_possivel = True
    aux = prescricao
    while is_possivel and aux:
        ch = aux[0]
        if estoque.count(ch) < aux.count(ch):
            is_possivel = False
        aux = aux.replace(ch, "")
    return is_possivel


print(is_prescicao_possivel("a", "b"))

print(is_prescicao_possivel("aa", "b"))

print(is_prescicao_possivel("aa", "aab"))

print(is_prescicao_possivel("aba", "cbaa"))

# 10.
datas = [
    datetime.datetime(2020, 5, 17),
    datetime.datetime(2020, 5, 18),
    datetime.datetime(2020, 5, 18),
    datetime.datetime(2020, 5, 17),
    datetime.datetime(2020, 5, 17),
    datetime.datetime(2020, 5, 19),
]

datas_df = pandas.DataFrame(list(map(lambda x: x.strftime("%m/%d/%Y"), datas)))

datas_grafico = datas_df.value_counts().plot(kind="bar")

datas_grafico.set_xlabel("Data")

datas_grafico.set_ylabel("Atendimentos")

connection.commit()

connection.close()
