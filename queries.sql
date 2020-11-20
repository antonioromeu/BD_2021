--- Q1 --- Qual o concelho onde se fez o maior volume de vendas hoje?
DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 AS
(SELECT num_concelho,
        num_regiao,
        quant,
        preco
FROM    instituicao
        NATURAL JOIN venda_farmacia
WHERE   (instituicao.nome = venda_farmacia.inst AND
        current_date = venda_farmacia.data_registo));

DROP TABLE IF EXISTS temp2;
CREATE TABLE temp2 AS
(SELECT num_concelho,
        num_regiao,
        SUM(quant * preco)
FROM    temp1
GROUP BY num_concelho, num_regiao);

DROP TABLE IF EXISTS cidades_com_mais_vendas;
CREATE TABLE cidades_com_mais_vendas AS
(SELECT nome
FROM concelho
WHERE num_concelho = (SELECT num_concelho
                    FROM temp2
                    WHERE SUM = (SELECT MAX(SUM) FROM temp2)) AND
                        num_regiao = (SELECT num_regiao FROM temp2
                                    WHERE SUM = (SELECT MAX(SUM) FROM temp2)));

SELECT * FROM cidades_com_mais_vendas;

--- Q2 --- Qual o médico que mais prescreveu no 1º semestre de 2019 em cada região?
DROP TABLE IF EXISTS temp3 cascade;
CREATE TABLE temp3 AS
(SELECT num_regiao,
        num_cedula,
        count,
        MAX(count) OVER (PARTITION BY num_regiao)
FROM
    (SELECT num_regiao, 
            num_cedula, 
            COUNT(num_cedula)
    FROM 
        (SELECT num_cedula,
                num_regiao
        FROM prescricao
        NATURAL JOIN consulta
        NATURAL JOIN instituicao
        WHERE   (prescricao.num_cedula = consulta.num_cedula AND
                prescricao.data_ = consulta.data_ AND
                prescricao.num_doente = consulta.num_doente AND
                instituicao.nome = consulta.nome_instituicao AND
                prescricao.data_ >= '2019-01-01' AND
                prescricao.data_ <= '2019-06-30'))
        AS prescricoes_data_ok
    GROUP BY num_cedula, num_regiao)
AS cedula_counter);


SELECT  regiao.nome AS regiao,
        regiao_medicos.nome AS medico,
        regiao_medicos.count AS num_prescricoes
FROM    
    (SELECT temp3.num_regiao,
            medico.nome,
            temp3.count
    FROM    temp3,
            medico
    WHERE   temp3.count = temp3.max AND
            medico.num_cedula = temp3.num_cedula)
    AS  regiao_medicos, 
    regiao 
WHERE   regiao.num_regiao = regiao_medicos.num_regiao;

--- Q3 --- Quais são os médicos que já prescreveram aspirina em receitas aviadas em todas as farmácias do concelho de Arouca este ano?
DROP TABLE IF EXISTS farmacia_arouca;
--- todas as farmacias em arouca
CREATE TABLE farmacia_arouca AS (SELECT DISTINCT nome FROM instituicao
    WHERE instituicao.num_concelho = (SELECT num_concelho
        FROM concelho
        WHERE concelho.nome = 'AROUCA')
    AND instituicao.num_regiao = (SELECT num_regiao
        FROM concelho
        WHERE concelho.nome = 'AROUCA')
    AND instituicao.tipo = 'farmacia');

DROP TABLE IF EXISTS prescricoes_aviadas_ultimo_ano;
--- todas as prescricoes de aspirina aviadas no ultimo ano
CREATE TABLE prescricoes_aviadas_ultimo_ano AS (SELECT num_cedula, inst
    FROM (prescricao_venda INNER JOIN venda_farmacia
    ON venda_farmacia.num_venda = prescricao_venda.num_venda)
    WHERE prescricao_venda.substancia = 'aspirina' AND 
        venda_farmacia.data_registo > (venda_farmacia.data_registo - interval '1 year'));

DROP TABLE IF EXISTS prescricoes_arouca; 
--- todas as prescricoes de aspirina levantadas em arouca no ultimo ano
CREATE TABLE prescricoes_arouca AS (SELECT num_cedula, inst
    FROM (farmacia_arouca
        INNER JOIN prescricoes_aviadas_ultimo_ano
        ON farmacia_arouca.nome = prescricoes_aviadas_ultimo_ano.inst));

DROP TABLE IF EXISTS medicos_prescricao;
create table medicos_prescricao AS
    (SELECT num_cedula FROM 
        (SELECT num_cedula, COUNT(num_cedula) FROM 
            (SELECT num_cedula FROM prescricoes_arouca
            GROUP BY num_cedula, inst) 
            AS medicos_prescricao GROUP BY num_cedula) 
        AS temp2
        WHERE COUNT = (SELECT COUNT(*) FROM farmacia_arouca));

DROP TABLE IF EXISTS todos_medicos;
CREATE TABLE todos_medicos AS 
    (SELECT nome FROM medico, medicos_prescricao
    WHERE medico.num_cedula IN (SELECT num_cedula FROM medicos_prescricao));

SELECT * FROM todos_medicos;
        
--- Q4 --- Quais são os doentes que já fizeram análises mas ainda não aviaram prescrições este mês?
SELECT DISTINCT num_doente FROM analise WHERE
    (EXTRACT(month FROM current_date) = EXTRACT(month FROM analise.data_) AND
    EXTRACT(year FROM current_date) = EXTRACT(year FROM analise.data_) AND
    num_doente NOT IN
        (SELECT num_doente FROM prescricao WHERE
        (EXTRACT(month FROM current_date) = EXTRACT(month FROM prescricao.data_) AND
        EXTRACT(year FROM current_date) = EXTRACT(year FROM prescricao.data_))));