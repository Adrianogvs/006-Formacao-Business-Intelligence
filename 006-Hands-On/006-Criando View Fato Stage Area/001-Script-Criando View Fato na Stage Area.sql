-- Após todas as dimensões carregadas, deve-se carregar a Tabela Fato.
-- Para carregar a Tabela Fato, deve-se fazer o cruzamento das tabelas que estão no schema da Stage Area (ST) com as tabelas que estão no schema Data Warehouse (DW). 
-- Esse cruzamento usa-se os joins. 
-- Para fazer os jons deve-se usar o dblink, em que deve-se estar conectado na ST e referenciado o DW
-- Vamos usar a VIEW vw_st_venda e left join dblink com as Dimensões Cliente e Produto.


-- CRIAR VIEW STAGE AREA FATO VENDAS
create view  vw_st_fato_venda AS
	select 	to_number(to_char(vw_st_venda.dt_venda,'yyyymmdd'),'99999999') as sk_data,
			coalesce (d_cliente.sk_cliente, - 1) as sk_cliente ,
			coalesce (d_produto.sk_produto, -1) as sk_produto,
		    qtd_venda,
			vl_venda as vl_venda_uni,
			qtd_venda * vl_venda as vl_venda_total,
			current_date as dt_carga
	from vw_st_venda 
	left join  dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=dw_biacademy',
				      'select * from dim_cliente') d_cliente (sk_cliente int, nk_cliente varchar, nm_cliente varchar, nm_email varchar, dt_carga timestamp) 
				  on d_cliente.nk_cliente = vw_st_venda.cod_cliente
	left  join dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=dw_biacademy',
				      'select * from dim_produto') d_produto (sk_produto int, nk_produto varchar, nm_produto varchar, cat_produto varchar, vl_produto numeric, status_produto varchar,dt_carga timestamp) 
				  on d_produto.nk_produto = vw_st_venda.cod_produto
	order by 1 asc ;
	
-- VALIDADNO OS DADOS STAGE AREA VIEW FATO VENDAS
select * from vw_st_fato_venda vsfv ;