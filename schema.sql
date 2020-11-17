drop table prescricao_venda cascade;
drop table prescricao cascade;
drop table venda_farmacia cascade;
drop table analise cascade;
drop table consulta cascade;
drop table instituicao cascade;
drop table concelho cascade;
drop table regiao cascade;
drop table medico cascade;

CREATE TABLE regiao (
    num_regiao INT NOT NULL,
    nome VARCHAR(80) NOT NULL CONSTRAINT RI_regiao_1
        CHECK (nome IN ('Norte', 'Centro', 'Lisboa', 'Alentejo', 'Algarve')),
    num_habitantes INT NOT NULL,
    PRIMARY KEY (num_regiao)
);

CREATE TABLE concelho (
    num_concelho INT NOT NULL,
    num_regiao INT NOT NULL,
    nome VARCHAR(80) NOT NULL,
    num_habitantes INT NOT NULL,
    PRIMARY KEY (num_concelho, num_regiao),
    FOREIGN KEY (num_regiao)
        REFERENCES regiao(num_regiao)
);

CREATE TABLE instituicao (
    nome VARCHAR(80) NOT NULL,
    tipo VARCHAR(20) NOT NULL CONSTRAINT RI_instituicao_1
        CHECK (tipo IN ('farmacia', 'laboratorio', 'clinica', 'hospital')),
    num_regiao INT NOT NULL,
    num_concelho INT NOT NULL,
    PRIMARY KEY (nome),
    FOREIGN KEY (num_concelho, num_regiao)
        REFERENCES concelho(num_concelho, num_regiao)
);

CREATE TABLE medico (
    num_cedula INT NOT NULL,
    nome VARCHAR(80) NOT NULL,
    especialidade VARCHAR(40) NOT NULL,
    PRIMARY KEY (num_cedula)
);

CREATE TABLE consulta (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_consulta DATE NOT NULL CONSTRAINT RI_consulta_1
        CHECK (EXTRACT(DOW FROM data_consulta) IN (1, 2, 3, 4, 5)),
    nome_instituicao VARCHAR(80) NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_consulta),
    FOREIGN KEY (num_cedula)
        REFERENCES medico(num_cedula),
    FOREIGN KEY (nome_instituicao)
        REFERENCES instituicao(nome)
);

CREATE TABLE prescricao (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_prescricao DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    quantidade DECIMAL NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_prescricao, substancia),
    FOREIGN KEY (num_cedula, num_doente, data_prescricao)
        REFERENCES consulta(num_cedula, num_doente, data_consulta)
);

CREATE TABLE analise (
    num_analise INT NOT NULL,
    especialidade VARCHAR(40),
    -- CONSTRAINT RI_analise
    --     CHECK (especialidade IN (SELECT medico(especialidade) FROM medico WHERE num_cedula = medico(num_cedula))),
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_analise DATE NOT NULL,
    data_registo DATE NOT NULL,
    nome VARCHAR(40) NOT NULL,
    quant DECIMAL NOT NULL,
    inst VARCHAR(40) NOT NULL,
    PRIMARY KEY (num_analise),
    FOREIGN KEY (num_cedula, num_doente, data_analise) REFERENCES consulta(num_cedula, num_doente, data_consulta),
    FOREIGN KEY (inst) REFERENCES instituicao(nome)
);

CREATE TABLE venda_farmacia (
    num_venda INT NOT NULL,
    data_registo DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    quant DECIMAL NOT NULL,
    preco DECIMAL NOT NULL,
    inst VARCHAR(80) NOT NULL,
    PRIMARY KEY (num_venda),
    FOREIGN KEY (inst)
        REFERENCES instituicao(nome)
);

CREATE TABLE prescricao_venda (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_prescricao_venda DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    num_venda INT NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_prescricao_venda, substancia, num_venda),
    FOREIGN KEY (num_venda)
        REFERENCES venda_farmacia(num_venda),
    FOREIGN KEY (num_cedula, num_doente, data_prescricao_venda, substancia)
        REFERENCES prescricao(num_cedula, num_doente, data_prescricao, substancia)
);


    -- CONSTRAINT RI_consulta_2
    --     CHECK (SELECT COUNT(*) FROM
    --         (SELECT (num_doente = consulta(num_doente), data_consulta = consulta(data_consulta),
    --         nome_instituicao = consulta(nome_instituicao)) FROM consulta)) < 1;
