DROP TABLE IF EXISTS prescricao_venda CASCADE;
DROP TABLE IF EXISTS prescricao CASCADE;
DROP TABLE IF EXISTS venda_farmacia CASCADE;
DROP TABLE IF EXISTS analise CASCADE;
DROP TABLE IF EXISTS consulta CASCADE;
DROP TABLE IF EXISTS instituicao CASCADE;
DROP TABLE IF EXISTS concelho CASCADE;
DROP TABLE IF EXISTS regiao CASCADE;
DROP TABLE IF EXISTS medico CASCADE;

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
        REFERENCES regiao(num_regiao) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE instituicao (
    nome VARCHAR(80) NOT NULL,
    tipo VARCHAR(20) NOT NULL CONSTRAINT RI_instituicao_1
        CHECK (tipo IN ('farmacia', 'laboratorio', 'clinica', 'hospital')),
    num_regiao INT NOT NULL,
    num_concelho INT NOT NULL,
    PRIMARY KEY (nome),
    FOREIGN KEY (num_concelho, num_regiao)
        REFERENCES concelho(num_concelho, num_regiao) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE medico (
    num_cedula INT NOT NULL,
    nome VARCHAR(80) NOT NULL,
    especialidade VARCHAR(60) NOT NULL,
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
        REFERENCES medico(num_cedula) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (nome_instituicao)
        REFERENCES instituicao(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(num_doente, data_, nome_instituicao) -- RI_consulta_2
);

CREATE TABLE prescricao (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_ DATE NOT NULL,
    substancia VARCHAR(60) NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_, substancia),
    FOREIGN KEY (num_cedula, num_doente, data_)
        REFERENCES consulta(num_cedula, num_doente, data_) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE analise (
    num_analise INT NOT NULL,
    especialidade VARCHAR(60),
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_ DATE NOT NULL,
    data_registo DATE NOT NULL,
    nome VARCHAR(60) NOT NULL,
    quant INT NOT NULL,
    inst VARCHAR(60) NOT NULL,
    PRIMARY KEY (num_analise),
    FOREIGN KEY (num_cedula, num_doente, data_)
        REFERENCES consulta(num_cedula, num_doente, data_) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (inst)
        REFERENCES instituicao(nome) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(num_analise)
);

CREATE TABLE venda_farmacia (
    num_venda INT NOT NULL,
    data_registo DATE NOT NULL,
    substancia VARCHAR(60) NOT NULL,
    quant INT NOT NULL,
    preco DECIMAL NOT NULL,
    inst VARCHAR(80) NOT NULL,
    PRIMARY KEY (num_venda),
    FOREIGN KEY (inst)
        REFERENCES instituicao(nome) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE prescricao_venda (
    num_cedula INT NOT NULL,
    num_doente INT NOT NULL,
    data_ DATE NOT NULL,
    substancia VARCHAR(60) NOT NULL,
    num_venda SERIAL NOT NULL,
    PRIMARY KEY (num_cedula, num_doente, data_, substancia, num_venda),
    FOREIGN KEY (num_venda)
        REFERENCES venda_farmacia(num_venda) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (num_cedula, num_doente, data_, substancia)
        REFERENCES prescricao(num_cedula, num_doente, data_, substancia) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE(num_venda)
);