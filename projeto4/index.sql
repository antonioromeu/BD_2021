-- -- INDICES -- --

-- 1
-- select data from consulta where num_doente = <um_valor>
    -- Foi criada uma hash table para a coluna num_doente para tornar mais eficiente a 
    -- procura de um doente pelo seu num_doente um vez que índices de dispersão são os 
    -- melhores para seleção por igualdade.
CREATE INDEX num_doente_index ON consulta 
    USING HASH(num_doente)

-- 2
-- select​ count​ (*)​ from​ medico where​ especialidade = “Ei”
    -- Consulta sem índice, como apenas existem 6 especialidades não é muito vantajoso
    -- criar uma tabela de indexação para estes indices, em comparação com fazer um 
    -- varrimento pelas possibilidades uma vez que inicializar e percorrer a tabela irá 
    -- demorar mais do que percorrer só as possbilidades


-- 3
-- select​ nome ​from​ medico ​where​ especialidade = ‘Ei’
    -- 1) Os blocos do disco são de 2K bytes e cada registo na tabela ocupa 1K bytes.
    -- 2) Os médicos estão uniformemente distribuídos pelas 6 especialidades.

    -- Como cada bloco apenas pode comportar a informação de 2 registos na tabela, 
    -- é mais vantajoso ter as ligações feitas por apontadores, em vez de ter os blocos
    -- fisicamente juntos ao disco. Para além disso, TO DO
CREATE INDEX medico_index ON medico
    USING BTREE(especialidade)

-- 4
-- select nome from medico, consulta
-- where consulta.num_celula=medico.num_celula AND
-- consulta.data BETWEEN ‘data_1’ AND ‘data_2’
    -- O índice começa por data porque numa estimativa de seletividade,
    -- assumimos que num_cedula tem menos valores distintos de que data
CREATE INDEX consulta_index ON consulta
    USING BTREE(data, num_cedula)
