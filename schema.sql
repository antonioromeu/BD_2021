CREATE TABLE regiao (
    num_regiao INT NOT NULL,
    nome VARCHAR(40) NOT NULL
    num_habitantes INT NOT NULL,
    PRIMARY KEY (num_regiao)
    CONSTRAINT nome
        CHECK nome IN {'Norte', 'Centro', 'Lisboa', 'Alentejo', 'Algarve'},
    -- CONSTRAINT pk_regiao PRIMARY KEY(num_regiao)
);

CREATE TABLE concelho (
    num_concelho INT NOT NULL,
    num_regiao INT NOT NULL,
    nome VARCHAR(40) NOT NULL,
    num_habitantes INT NOT NULL,
    PRIMARY KEY (num_concelho),
    CONSTRAINT fk_concelho
        FOREIGN KEY (num_regiao)
        REFERENCES regiao(num_regiao)
);

CREATE TABLE instituicao (
    nome VARCHAR(40) NOT NULL,
    tipo VARCHAR(40) NOT NULL,
    num_regiao INT NOT NULL,
    num_concelho INT NOT NULL,
    CONSTRAINT fk_instituicao
        FOREIGN KEY (num_regiao, num_concelho)
        REFERENCES concelho(num_regiao, num_concelho)
);

CREATE TABLE medico (
    num_cedula INT NOT NULL,
    nome VARCHAR(40) NOT NULL,
    especialidade VARCHAR(40) NOT NULL,
    PRIMARY KEY (num_cedula)
);

CREATE TABLE consulta (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_consulta INT NOT NULL, 
    nome_instituicao VARCHAR(40) NOT NULL,
    PRIMARY KEY(data_consulta),
    CONSTRAINT fk_consulta
        FOREIGN KEY (num_cedula)
        REFERENCES medico(num_cedula),
    CONSTRAINT fk_consulta
        FOREIGN KEY (num_doente)
        REFERENCES instituicao(num_doente),
    -- CONSTRAINT data_consulta CHECK DATEPART(weekday, data_consulta) != 7
    CONSTRAINT data_consulta
        CHECK EXTRACT(WEEKDAY FROM data_consulta) IN (1, 2, 3, 4, 5)
);

-- lucia
-- https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions

-- https://www.w3schools.com/sql/sql_check.asp

-- https://stackoverflow.com/questions/9570087/how-to-check-if-datetime-happens-to-be-saturday-or-sunday-in-sql-server-2008


CREATE TABLE prescricao (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_prescricao DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    quantidade DECIMAL NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_prescricao, substancia),
    CONSTRAINT fk_prescricao
        FOREIGN KEY (num_cedula, num_doente, data_prescricao)
        REFERENCES consulta(num_cedula, num_doente, data_prescricao)
);

CREATE TABLE analise (
    num_analise INT NOT NULL,
    especialide VARCHAR(40),
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_analise DATE NOT NULL,
    data_registo DATE NOT NULL,
    nome VARCHAR(40) NOT NULL,
    quant DECIMAL NOT NULL,
    inst VARCHAR(40) NOT NULL,
    PRIMARY KEY (num_analise),
    CONSTRAINT fk_analise_consulta
        FOREIGN KEY (num_cedula, num_doente, data_analise)
        REFERENCES consulta(num_cedula, num_analise, data_consulta),
    CONSTRAINT fk_analise_instituicao
        FOREIGN KEY (inst)
        REFERENCES instituicao(nome)
    CONSTRAINT analise_especialidade DEFAULT
        SELECT especialidade FROM medico WHERE num_cedula = medico(num_cedula)
);

-- RI-analise: a consulta associada pode estar omissa; não estando, a especialidade da consulta tem de ser
-- igual à do médico.


CREATE TABLE venda_farmacia (
    num_venda INT NOT NULL,
    data_registo DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    quant DECIMAL NOT NULL,
    preco DECIMAL NOT NULL,
    inst VARCHAR(40) NOT NULL,
    PRIMARY KEY (num_venda),
    CONSTRAINT fk_venda_farmacia
        FOREIGN KEY (inst)
        REFERENCES instituicao(nome)
);

CREATE TABLE prescricao_venda (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_prescricao_venda DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    num_venda INT NOT NULL,
    -- PRIMARY KEY (num_cedula),
    -- PRIMARY KEY (num_doente),
    -- PRIMARY KEY (data_prescricao_venda),
    -- PRIMARY KEY (substancia),
    -- PRIMARY KEY (num_venda),
    PRIMARY KEY (num_cedula, num_doente, data_prescricao_venda, substancia, num_venda),
    CONSTRAINT fk_prescricao_venda_venda_farmacia
        FOREIGN KEY (num_venda)
        REFERENCES venda_farmacia(num_venda),
    CONSTRAINT fk_prescricao_venda_prescricao
        FOREIGN KEY (num_cedula, num_doente, data_prescricao_venda, substancia)
        REFERENCES prescricao(num_cedula, num_doente, data_prescricao, substancia)
);