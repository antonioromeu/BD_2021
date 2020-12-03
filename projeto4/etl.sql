INSERT INTO d_tempo (dia, dia_da_semana, semana, mes, trimestre, ano)
    SELECT EXTRACT(DAY FROM data_) AS dia,
        EXTRACT(DOW FROM data_) AS dia_da_semana,
        EXTRACT(WEEK FROM data_) AS semana,
        EXTRACT(MONTH FROM data_) AS mes,
        FLOOR((EXTRACT(MONTH FROM data_) - 1) / 4) + 1 AS trimestre,
        EXTRACT(YEAR FROM data_) AS ano
    FROM prescricao;

INSERT INTO d_tempo (dia, dia_da_semana, semana, mes, trimestre, ano)
    SELECT EXTRACT(DAY FROM data_) AS dia,
        EXTRACT(DOW FROM data_) AS dia_da_semana,
        EXTRACT(WEEK FROM data_) AS semana,
        EXTRACT(MONTH FROM data_) AS mes,
        FLOOR((EXTRACT(MONTH FROM data_) - 1) / 4) + 1 AS trimestre,
        EXTRACT(YEAR FROM data_) AS ano
    FROM analise
    ON CONFLICT (dia, mes, ano) DO NOTHING;

INSERT INTO d_instituicao (nome, tipo, num_regiao, num_concelho)
    SELECT nome, tipo, num_regiao, num_concelho FROM instituicao;

INSERT INTO f_presc_venda (id_presc_venda, id_medico, num_doente, id_data_registo, id_inst, substancia, quant)
    SELECT id_presc_venda, id_medico, num_doente, id_data_registo, id_inst, substancia, quant
    FROM (SELECT
        venda_farmacia.num_venda AS id_presc_venda,
        num_cedula AS id_medico,
        num_doente,
        id_tempo AS id_data_registo,
        venda_farmacia.substancia AS substancia,
        venda_farmacia.quant AS quant,
        d_instituicao.id_inst AS id_inst
        FROM (SELECT d_tempo.id_tempo, prescricao_venda.data_, prescricao_venda.num_venda
            FROM d_tempo, prescricao_venda
            WHERE (dia = (SELECT(EXTRACT(day FROM prescricao_venda.data_)))
                AND mes = (SELECT (EXTRACT(month FROM prescricao_venda.data_)))
                AND ano = (SELECT (EXTRACT(year FROM prescricao_venda.data_))))) AS temp1
            INNER JOIN prescricao_venda
            ON temp1.data_ = prescricao_venda.data_
            INNER JOIN venda_farmacia
            ON temp1.num_venda = venda_farmacia.num_venda
            INNER JOIN d_instituicao
            ON d_instituicao.nome = venda_farmacia.inst) AS temp2;

INSERT INTO f_analise (id_analise, id_medico, num_doente, id_data_registo, id_inst, nome, quant)
        SELECT analise.num_analise AS id_analise, 
        analise.num_cedula AS id_medico,
        num_doente,
        temp.id_tempo AS id_data_registo,
        id_inst,
        analise.nome AS nome,
        analise.quant AS quant    
        FROM analise
        INNER JOIN (SELECT id_tempo, make_date(ano, mes, dia) 
            FROM d_tempo) AS temp
        ON analise.data_ = temp.make_date
        INNER JOIN d_instituicao 
        ON analise.inst = d_instituicao.nome;