DROP TABLE IF EXISTS prescricao_venda cascade;
DROP TABLE IF EXISTS prescricao cascade;
DROP TABLE IF EXISTS venda_farmacia cascade;
DROP TABLE IF EXISTS analise cascade;
DROP TABLE IF EXISTS consulta cascade;
DROP TABLE IF EXISTS instituicao cascade;
DROP TABLE IF EXISTS concelho cascade;
DROP TABLE IF EXISTS regiao cascade;
DROP TABLE IF EXISTS medico cascade;

DROP TABLE IF EXISTS prescricoes_arouca;
DROP TABLE IF EXISTS prescricoes_aviadas_ultimo_ano;
DROP TABLE IF EXISTS farmacia_arouca;
DROP TABLE IF EXISTS cidades_com_mais_vendas;
DROP TABLE IF EXISTS todas_farmacias;
DROP TABLE IF EXISTS todas_medicos;
DROP TABLE IF EXISTS temp0;
DROP TABLE IF EXISTS temp1;
DROP TABLE IF EXISTS temp2;
DROP TABLE IF EXISTS temp3;

CREATE TABLE regiao (
    num_regiao INT NOT NULL,
    nome VARCHAR(80) NOT NULL CONSTRAINT RI_regiao_1
        CHECK (nome IN ('Norte', 'Centro', 'Lisboa', 'Alentejo', 'Algarve')),
    num_habitantes INT NOT NULL,
    PRIMARY KEY (num_regiao)
);

CREATE TABLE concelho (
    num_regiao INT NOT NULL,
    num_concelho INT NOT NULL,
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
    data_ DATE NOT NULL CONSTRAINT RI_consulta_1
        CHECK (EXTRACT(DOW FROM data_) IN (1, 2, 3, 4, 5)),
    nome_instituicao VARCHAR(80) NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_),
    FOREIGN KEY (num_cedula)
        REFERENCES medico(num_cedula),
    FOREIGN KEY (nome_instituicao)
        REFERENCES instituicao(nome)
);

CREATE TABLE prescricao (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_ DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    quantidade DECIMAL NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_, substancia),
    FOREIGN KEY (num_cedula, num_doente, data_)
        REFERENCES consulta(num_cedula, num_doente, data_)
);

CREATE TABLE analise (
    num_analise INT NOT NULL,
    especialidade VARCHAR(40),
    -- CONSTRAINT RI_analise
    --     CHECK (especialidade IN (SELECT medico(especialidade) FROM medico WHERE num_cedula = medico(num_cedula))),
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_ DATE NOT NULL,
    data_registo DATE NOT NULL,
    nome VARCHAR(40) NOT NULL,
    quant DECIMAL NOT NULL,
    inst VARCHAR(40) NOT NULL,
    PRIMARY KEY (num_analise),
    FOREIGN KEY (num_cedula, num_doente, data_) REFERENCES consulta(num_cedula, num_doente, data_),
    FOREIGN KEY (inst) REFERENCES instituicao(nome)
);

CREATE TABLE venda_farmacia (
    num_venda INT NOT NULL,
    data_registo DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    quant INT NOT NULL,
    preco DECIMAL NOT NULL,
    inst VARCHAR(80) NOT NULL,
    PRIMARY KEY (num_venda),
    FOREIGN KEY (inst)
        REFERENCES instituicao(nome)
);


CREATE TABLE prescricao_venda (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_ DATE NOT NULL,
    substancia VARCHAR(40) NOT NULL,
    num_venda INT NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_, substancia, num_venda),
    FOREIGN KEY (num_venda)
        REFERENCES venda_farmacia(num_venda),
    FOREIGN KEY (num_cedula, num_doente, data_, substancia)
        REFERENCES prescricao(num_cedula, num_doente, data_, substancia)
);


    -- CONSTRAINT RI_consulta_2
    --     CHECK (SELECT COUNT(*) FROM
    --         (SELECT (num_doente = consulta(num_doente), data_consulta = consulta(data_consulta),
    --         nome_instituicao = consulta(nome_instituicao)) FROM consulta)) < 1;
