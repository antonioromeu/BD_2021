DROP TABLE IF EXISTS d_tempo CASCADE;
DROP TABLE IF EXISTS d_instituicao CASCADE;
DROP TABLE IF EXISTS f_presc_venda CASCADE;
DROP TABLE IF EXISTS f_analise CASCADE;

CREATE TABLE d_tempo (
    id_tempo SERIAL NOT NULL,
    dia INT NOT NULL,
    dia_da_semana INT NOT NULL,
    semana INT NOT NULL,
    mes INT NOT NULL,
    trimestre INT NOT NULL,
    ano INT NOT NULL,
    PRIMARY KEY (id_tempo)
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
    FOREIGN KEY (num_regiao)
        REFERENCES regiao(num_regiao) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (num_concelho)
        REFERENCES concelho(num_concelho) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE f_presc_venda (
    id_presc_venda INT NOT NULL,
    id_medico INT NOT NULL,
    num_doente INT NOT NULL,
    id_data_registo INT NOT NULL,
    id_inst_substancia INT NOT NULL,
    quant INT NOT NULL,
    PRIMARY KEY (id_presc_venda),
    FOREIGN KEY (id_presc_venda)
        REFERENCES prescricao_venda(num_venda) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_medico)
        REFERENCES medico(num_cedula) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_data_registo)
        REFERENCES d_tempo(???????) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_inst)
        REFERENCES d_instituicao(id_inst) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE f_analise (
    id_analise INT NOT NULL,
    id_medico INT NOT NULL,
    num_doente INT NOT NULL,
    id_data_registo INT NOT NULL,
    id_inst INT NOT NULL,
    nome VARCHAR(60) NOT NULL,
    quant INT NOT NULL,
    PRIMARY KEY (id_analise)
    FOREIGN KEY (id_analise)
        REFERENCES analise(num_analise) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_medico)
        REFERENCES medico(num_cedula) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_data_registo)
        REFERENCES d_tempo(??????) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_inst)
        REFERENCES instituicao(??????) ON DELETE CASCADE ON UPDATE CASCADE
);