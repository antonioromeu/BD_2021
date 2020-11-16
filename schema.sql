CREATE TABLE regiao (
    num_regiao INT NOT NULL,
    nome VARCHAR(40) NOT NULL
    num_habitantes INT NOT NULL,
    PRIMARY KEY (num_regiao)
    CONSTRAINT RI-regiao-1
        CHECK nome IN {'Norte', 'Centro', 'Lisboa', 'Alentejo', 'Algarve'},
    -- CONSTRAINT pk_regiao PRIMARY KEY(num_regiao)
);

CREATE TABLE concelho (
    num_concelho INT NOT NULL,
    num_regiao INT NOT NULL,
    nome VARCHAR(40) NOT NULL,
    num_habitantes INT NOT NULL,
    PRIMARY KEY (num_concelho),
    FOREIGN KEY (num_regiao) REFERENCES regiao(num_regiao)
);

CREATE TABLE instituicao (
    nome VARCHAR(40) NOT NULL,
    tipo VARCHAR(40) NOT NULL,
    num_regiao INT NOT NULL,
    num_concelho INT NOT NULL,
    FOREIGN KEY (num_regiao, num_concelho) REFERENCES concelho(num_regiao, num_concelho)
    CONSTRAINT RI-instituicao-1
        CHECK tipo IN {'farmacia', 'laboratorio', 'clinica', 'hospital'}
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
    FOREIGN KEY (num_cedula) REFERENCES medico(num_cedula),
    FOREIGN KEY (num_doente) REFERENCES instituicao(num_doente),
    CONSTRAINT RI-consulta-1
        CHECK EXTRACT(DOW FROM data_consulta) IN (1, 2, 3, 4, 5)
    CONSTRAINT RI-consulta-2
        CHECK (SELECT COUNT(num_doente) FROM consulta WHERE
        SELECT COUNT(*) FROM (
            -- SELECT (num_doente = consulta(num_doente), data_consulta = consulta(data_consulta), nome_instituicao = ) FROM consulta
        )


);


CREATE TABLE prescricao (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_prescricao DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    quantidade DECIMAL NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_prescricao, substancia),
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
    FOREIGN KEY (num_cedula, num_doente, data_analise) REFERENCES consulta(num_cedula, num_analise, data_consulta),
    FOREIGN KEY (inst) REFERENCES instituicao(nome)
    CONSTRAINT RI-analise DEFAULT
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