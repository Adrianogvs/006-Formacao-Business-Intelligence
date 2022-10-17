-- Após todas as dimensões carregadas, deve-se carregar a Tabela Fato.
-- Para carregar a Tabela Fato, deve-se fazer o cruzamento das tabelas que estão no schema da Stage Area (ST) com as tabelas que estão no schema Data Warehouse (DW). 
-- Esse cruzamento usa-se os joins. 
-- Para fazer os jons deve-se usar o dblink, em que deve-se estar conectado na ST e referenciado o DW
-- Vamos usar a VIEW vw_st_venda e left join dblink com as Dimensões Cliente e Produto.

-- Após criar o Script para carregar a fato, deve- se ir na Tabela Dimensão Cliente e Dimensão Produto e criar o Cliente com código "-1" e Código do Produto -2, pois se não fizer isso, irá apresentar o seguinte erro:
/*
SQL Error [23503]: ERROR: insert or update on table "fato_venda" violates foreign key constraint "fato_venda_dim_cliente_fk"
  Detail: Key (sk_cliente)=(-1) is not present in table "dim_cliente".
*/
-- Esse erro informa que não existem nenhum cliente de código “-1” cadastrado na Tabela Dimensão Cliente, então é necessário criar esse cliente antes de fazer o INSERT na Fato Venda.
-- Essa técnica deve ser utilizada em todas as Dimensões.

-- INSERINDO O CLIENTE "-1" NA DIMENSÃO CLIENTE
insert into dim_cliente 
values (-1, '**Não Identificado**','**Não Identificado**','**Não Identificado**', current_date);

-- INSERINDO O CLIENTE "-2" NA DIMENSÃO CLIENTE
insert into dim_cliente 
values (-2, '**Não Se Aplica**','**Não Se Aplica**','**Não Se Aplica**', current_date);
               
-- VALIDANDO OS DADOS DIMENSÃO CLIENTE
select * from dim_cliente dc ;


-- INSERINDO O CLIENTE "-1" NA DIMENSÃO PRODUTO
insert into dim_produto 
values (-1, '**Não Identificado**','**Não Identificado**','**Não Identificado**', -1,'**Não Identificado**', current_date);

-- INSERINDO O CLIENTE "-2" NA DIMENSÃO PRODUTO
insert into dim_produto 
values (-2,  '**Não Se Aplica**','**Não Se Aplica**','**Não Se Aplica**', -1,'**Não Se Aplica**', current_date);
          
-- VALIDANDO OS DADOS DIMENSAO PRODUTO
select * from dim_produto dp ;

-- TRUNCANDO A TABELA FATO VENDA
truncate table fato_venda cascade;


-- INSERINDO DADOS NA TABELA FATO DO DW
insert into fato_venda 
	select 	sk_data,
			sk_cliente,
			sk_produto,
			qtd_venda,
			vl_venda_uni,
			vl_venda_total,
			dt_carga
	from dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=st_biacademy',
				'select * from vw_st_fato_venda') vw_fato_venda (sk_data int, sk_cliente int, sk_produto int, qtd_venda int,vl_venda_uni numeric, vl_venda_total numeric, dt_carga timestamp);
	

-- VALIDANDO DOS DADOS DA TABELA FATO VENDA
select 	dim_data.nr_ano ,
		dim_data.nr_mes,
		dim_data.nm_mes,
		sum(fato_venda.qtd_venda) as qtd_venda,
		sum(fato_venda.vl_venda_total) as vl_venda_toptal,
		dim_produto.nm_produto 
from fato_venda
	inner join dim_data on fato_venda.sk_data = dim_data.sk_data 
	inner join dim_cliente on fato_venda.sk_cliente = dim_cliente.sk_cliente 
	inner join dim_produto on fato_venda.sk_produto = dim_produto.sk_produto 
	group by 	dim_produto.nm_produto , 
				dim_data.nr_ano,
				dim_data.nm_mes,
				dim_data.nr_mes
	order by dim_data.nr_mes ;

select * from fato_venda fv ;

