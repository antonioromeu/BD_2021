-- 1.
    -- Foi criada uma hash table para a coluna num_doente para tornar mais eficiente a 
    -- procura de um doente pelo seu num_doente um vez que índices de dispersão são os 
    -- melhores para seleção por igualdade.
CREATE INDEX num_doente_index ON consulta 
    USING HASH(num_doente)

-- 2.
    -- Consulta sem índice, como apenas existem 6 especialidades não é muito vantajoso
    -- criar uma tabela de indexação para estes indices, em comparação com fazer um 
    -- varrimento pelas possibilidades uma vez que inicializar e percorrer a tabela irá 
    -- demorar mais do que percorrer só as possbilidades

-- 3.
    -- Como existem poucos valores diferentes para a especialidade (cardinalidade reduzida),
    -- o bitmap para cada tuplo da tabela vai ter tambem um tamanho reduzido (6 bits).
    -- Assim as operações com bitmaps vão res extremamente rapidas, particularmente para 
    -- igualdades como a query acima descrita.
CREATE INDEX medico_index ON medico
    USING BITMAP(especialidade);

-- 4.
    -- Os hash indexes só funcionam para igualdade, como nesta pergunta 
    -- temos um betwenn usamos uma BTREE uma vez que de todas, é a mais
    -- ideal para betweens 
    -
CREATE INDEX consulta_index ON consulta
    USING BTREE(data, num_cedula)