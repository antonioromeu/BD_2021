--- Q1 --- Qual o concelho onde se fez o maior volume de vendas hoje?
DROP TABLE IF EXISTS temp1;
DROP TABLE IF EXISTS temp2;
DROP TABLE IF EXISTS cidades_com_mais_vendas;

CREATE TABLE temp1 AS (SELECT num_concelho, quant, preco
    FROM instituicao NATURAL JOIN venda_farmacia
    WHERE (instituicao.nome = venda_farmacia.inst
    AND current_date = venda_farmacia.data_registo));

CREATE TABLE temp2 AS (SELECT num_concelho, SUM(quant * preco)
    FROM temp1 GROUP BY num_concelho);

CREATE TABLE cidades_com_mais_vendas AS (SELECT nome FROM concelho
    WHERE num_concelho = (SELECT num_concelho FROM temp2
    WHERE SUM = (SELECT MAX(SUM) FROM temp2)));

SELECT * FROM cidades_com_mais_vendas;

--- Q2 --- Qual o médico que mais prescreveu no 1º semestre de 2019 em cada região?
DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 AS
    (SELECT num_cedula, num_regiao FROM prescricao NATURAL JOIN consulta
    NATURAL JOIN instituicao WHERE
    (prescricao.num_cedula = consulta.num_cedula AND
    prescricao.data_ = consulta.data_ AND
    prescricao.num_doente = consulta.num_doente AND
    instituicao.nome = consulta.nome_instituicao AND
    prescricao.data_ >= '2019-01-01' AND
    prescricao.data_ <= '2021-06-30')); ----- no fim de testarmos temos de alterar a data

DROP TABLE IF EXISTS temp2;
CREATE TABLE temp2 AS (SELECT num_regiao, num_cedula, COUNT(num_cedula)
    FROM temp1 GROUP BY num_cedula, num_regiao);

DROP TABLE IF EXISTS temp3 cascade;
CREATE TABLE temp3 AS (SELECT num_regiao, MAX(COUNT) AS maxcount
    FROM temp2 GROUP BY num_regiao);

DROP TABLE IF EXISTS medicos_em_regioes cascade;
SELECT medico.nome, temp2.num_regiao FROM temp2, temp3, medico
    WHERE (temp2.num_regiao = temp3.num_regiao AND
    temp2.COUNT = temp3.maxcount AND
    medico.num_cedula = temp2.num_cedula);

SELECT * FROM medicos_em_regioes;

--- Q3 --- Quaissãoosmédicosquejáprescreveramaspirinaemreceitasaviadasemtodasasfarmáciasdo concelho de Arouca este ano?



--- Q4 --- Quais são os doentes que já fizeram análises mas ainda não aviaram prescrições este mês?

SELECT num_doente FROM analise WHERE
    (EXTRACT(month FROM current_date) = EXTRACT(month FROM analise.data_) AND
    EXTRACT(year FROM current_date) = EXTRACT(year FROM analise.data_) AND
    num_doente NOT IN
        (SELECT num_doente FROM prescricao WHERE
        (EXTRACT(month FROM current_date) = EXTRACT(month FROM prescricao.data_) AND
        EXTRACT(year FROM current_date) = EXTRACT(year FROM prescricao.data_))));