-- O ​número de análises de glicémia ​realizadas por especialidade médica, por mês e
-- por ano, ​com totais parciais em cada especialidade cada mês e cada ano,​ em 2017-2020
SELECT especialidade, mes, ano, COUNT(*)
FROM f_analise
INNER JOIN d_tempo ON f_analise.id_data_registo = d_tempo.id_tempo
INNER JOIN medico ON f_analise.id_medico = medico.num_cedula
WHERE f_analise.nome = 'Analise de glicemia'
AND ano BETWEEN '2017' AND '2020'
GROUP BY ROLLUP(especialidade, mes, ano);

-- A ​ quantidade total e ​ no médio de prescrições diário ​ de cada substância registados em cada dia
-- da semana, ​ cada mês e em cada concelho​ , ​ com rollup no espaço (concelho) e no tempo (dia da
-- semana e mês) num determinado trimestre e região, mostrando o resultado para a região de
-- Lisboa durante o 1o trimestre de 2020.
SELECT SUM (quant),
    SUM(id_data_registo) / 7 AS media,
    d_tempo.mes, dia_da_semana
FROM f_presc_venda
INNER JOIN d_instituicao
on f_presc_venda.id_inst = d_instituicao.id_inst
INNER JOIN d_tempo
ON f_presc_venda.id_data_registo = d_tempo.id_tempo
WHERE num_regiao = 2 AND trimestre = 3 AND ano = 2020
GROUP BY ROLLUP (num_concelho, mes, dia_da_semana)