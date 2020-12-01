-- RI-100 --
CREATE OR REPLACE FUNCTION
medico_sup_100_procedure()
RETURNS TRIGGER
AS $$
BEGIN
    IF
        ((SELECT COUNT(num_cedula) FROM consulta
        WHERE num_cedula = NEW.num_cedula AND
        (SELCT EXTRACT(WEEK FROM NEW.data_)) = (SELECT EXTRACT(WEEK FROM data_)) AND
        (SELCT EXTRACT(YEAR FROM NEW.data_)) = (SELECT EXTRACT(YEAR FROM data_)) AND
        nome_instituicao = NEW.nome_instituicao) = 100)
        THEN RAISE EXCEPTION 'Medico ja tem 100 consultas nesta semana nesta instituicao';
    END IF;
    RETURN new;
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS medico_sup_100_procedure ON consulta;

CREATE TRIGGER medico_sup_100_procedure BEFORE UPDATE ON consulta
FOR EACH ROW EXECUTE PROCEDURE medico_sup_100_procedure();

-- RI-analise --
CREATE OR REPLACE FUNCTION
analise_consulta_omissa_procedure()
RETURNS TRIGGER
AS $$
BEGIN
    IF
        (NOT EXISTS (SELECT * FROM consulta WHERE num_cedula = NEW.num_cedula AND
        num_doente = NEW.num_doente AND data_ = NEW.data_))
        THEN RAISE EXCEPTION 'A especilidade da consulta tem de ser igual à do
        medico com numero de cedula %', NEW.num_cedula;
    END IF;
    RETURN new;
END;
$$ LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS analise_consulta_omissa_procedure ON analise;

CREATE TRIGGER analise_consulta_omissa_procedure BEFORE UPDATE ON analise
FOR EACH ROW EXECUTE PROCEDURE analise_consulta_omissa_procedure();