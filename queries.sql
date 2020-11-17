CREATE FUNCTION q1 (
    CREATE TEMP TABLE venda_concelho AS 
    (SELECT concelho(nome), venda_farmacia(quant), venda_farmacia(preco) FROM
        (concelho NATURAL JOIN (instituicao INNER JOIN venda_farmacia USING (nome, inst))))
    data_registo = GETDATE()
);

1) ter uma tabela com os concelhos, vendas_farmacia e instituicao
2) temos de ter a soma das vendas de hoje nesse concelho
3) devolver o max


lisboa 20  
lisboa 5
centro 30
porto 30
porto 20

select num_concelho, quant, preco from instituicao natural join venda_farmacia where instituicao.nome = venda_farmacia.inst;