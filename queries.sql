--- Q1 ---
drop table temp1;
drop table temp2;
drop table cidades_com_mais_vendas;
create temp table temp1 as (select num_concelho, quant, preco from instituicao natural join venda_farmacia where (instituicao.nome = venda_farmacia.inst and current_date = venda_farmacia.data_registo));
create temp table temp2 as (select num_concelho, sum(quant * preco) from temp1 group by num_concelho);
create temp table cidades_com_mais_vendas as (select nome from concelho where num_concelho = (select num_concelho from temp2 where sum = (select max(sum) from temp2)));
select * from cidades_com_mais_vendas;

--- Q2 ---
drop table temp1 cascade;
create temp table temp1 as 
    (select num_cedula, num_regiao from prescricao natural join consulta natural join instituicao where 
        (prescricao.num_cedula = consulta.num_cedula and 
        prescricao.data_ = consulta.data_ and 
        prescricao.num_doente = consulta.num_doente and 
        instituicao.nome = consulta.nome_instituicao and
        prescricao.data_ >= '2019-01-01' and 
        prescricao.data_ <= '2021-06-30')); ----- no fim de testarmos temos de alterar a data
drop table temp2 cascade;
create temp table temp2 as (select num_regiao, num_cedula, count(num_cedula) from temp1 group by num_cedula, num_regiao);
drop table temp3 cascade;
create temp table temp3 as (select num_regiao, max(count) as maxcount from temp2 group by num_regiao);
drop table medicos_em_regioes cascade;
select medico.nome, temp2.num_regiao from temp2, temp3, medico where(temp2.num_regiao = temp3.num_regiao and temp2.count = temp3.maxcount and medico.num_cedula = temp2.num_cedula);
select * from medicos_em_regioes;

--- Q3 ---

