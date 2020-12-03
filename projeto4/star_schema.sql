-- DROP TABLE IF EXISTS d_tempo CASCADE;
-- DROP TABLE IF EXISTS d_instituicao CASCADE;
-- DROP TABLE IF EXISTS f_presc_venda CASCADE;
-- DROP TABLE IF EXISTS f_analise CASCADE;

CREATE TABLE d_tempo (
    id_tempo SERIAL NOT NULL,
    dia INT NOT NULL,
    dia_da_semana INT NOT NULL,
    semana INT NOT NULL,
    mes INT NOT NULL,
    trimestre INT NOT NULL,
    ano INT NOT NULL,
    PRIMARY KEY (id_tempo),
    UNIQUE(dia, mes, ano)
);

CREATE TABLE d_instituicao (
    id_inst SERIAL NOT NULL,
    nome VARCHAR(60) NOT NULL,
    tipo VARCHAR(60) NOT NULL,
    num_regiao INT NOT NULL,
    num_concelho INT NOT NULL,
    PRIMARY KEY (id_inst),
    FOREIGN KEY (nome)
        REFERENCES instituicao(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (num_concelho, num_regiao)
        REFERENCES concelho(num_concelho, num_regiao) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE f_presc_venda (
    id_presc_venda INT NOT NULL,
    id_medico INT NOT NULL,
    num_doente INT NOT NULL,
    id_data_registo INT NOT NULL,
    id_inst INT NOT NULL,
    substancia VARCHAR(60) NOT NULL,
    quant INT NOT NULL,
    PRIMARY KEY (id_presc_venda),
    FOREIGN KEY (id_presc_venda)
        REFERENCES prescricao_venda(num_venda) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_medico)
        REFERENCES medico(num_cedula) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_data_registo)
        REFERENCES d_tempo(id_tempo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_inst)
        REFERENCES d_instituicao(id_inst) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE f_analise (
    id_analise SERIAL NOT NULL,
    id_medico INT NOT NULL,
    num_doente INT NOT NULL,
    id_data_registo INT NOT NULL,
    id_inst INT NOT NULL,
    nome VARCHAR(60) NOT NULL,
    quant INT NOT NULL,
    PRIMARY KEY (id_analise),
    FOREIGN KEY (id_analise)
        REFERENCES analise(num_analise) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_medico)
        REFERENCES medico(num_cedula) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_data_registo)
        REFERENCES d_tempo(id_tempo) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_inst)
        REFERENCES d_instituicao(id_inst) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO d_tempo (dia, dia_da_semana, semana, mes, trimestre, ano)
    SELECT EXTRACT(DAY FROM data_) AS dia,
        EXTRACT(DOW FROM data_) AS dia_da_semana,
        EXTRACT(WEEK FROM data_) AS semana,
        EXTRACT(MONTH FROM data_) AS mes,
        FLOOR((EXTRACT(MONTH FROM data_) - 1) / 4) + 1 AS trimestre,
        EXTRACT(YEAR FROM data_) AS ano
    FROM prescricao
    ORDER BY dia, dia_da_semana, semana, mes, trimestre, ano;

INSERT INTO d_tempo (dia, dia_da_semana, semana, mes, trimestre, ano)
    SELECT EXTRACT(DAY FROM data_) AS dia,
        EXTRACT(DOW FROM data_) AS dia_da_semana,
        EXTRACT(WEEK FROM data_) AS semana,
        EXTRACT(MONTH FROM data_) AS mes,
        FLOOR((EXTRACT(MONTH FROM data_) - 1) / 4) + 1 AS trimestre,
        EXTRACT(YEAR FROM data_) AS ano
    FROM analise
    ORDER BY dia, dia_da_semana, semana, mes, trimestre, ano;

INSERT INTO d_instituicao (nome, tipo, num_regiao, num_concelho)
    SELECT nome, tipo, num_regiao, num_concelho FROM instituicao;

INSERT INTO f_presc_venda (id_medico, num_doente, id_data_registo, id_inst, substancia, quant)
    SELECT id_medico, num_doente, id_data_registo, id_inst, substancia, quant
    FROM (SELECT
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