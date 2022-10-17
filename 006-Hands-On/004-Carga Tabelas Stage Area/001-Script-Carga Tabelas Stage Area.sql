--CRIAR CONEXÃO COM OUTRSO SCHEMA PARA TRAZER OS DADOS DO LEGADO PARA A STAGE AREA
create extension dblink;


-- MODELO DE SELECT PARA CONEXÃO COM OUTROS SCHEMA
select * from dblink('host=localhost  user=usuario password=senha  dbname=nome_do_schema','select * from tablea') t (camp1 tipo dado, camp2 tipo dado, ...)


-- ANTES DE INSERIR DEVE ZERAR A TABELA DE STAGE AREA 
truncate table ST_CLIENTE;


-- INSERT NA STAGE ST_CLIENTE
insert into ST_CLIENTE 
	select  cd_cliente,
			nome_cliente,
			email_cliente,
			current_date
	from dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=legado ',
				'select * from cliente') TABELA (cd_cliente int, nome_cliente varchar, email_cliente varchar)
;

-- VALIDAR OS DADOS
select 	*
from ST_CLIENTE;


-- ANTES DE INSERIR DEVE ZERAR A TABELA DE STAGE AREA 
truncate table ST_VENDA;


-- CRIAR UMA VIWE NO LEGADO PARA JUNTAS AS DUAS TABELAS ITENS_PEDIO E PEDIDO
create view VW_ITENS_PEDIDO_PEDIDO as
	select 	pedido.data_pedido,
       		pedido.numero_pedido,
       		itens_pedido.codigo_produto,
       		pedido.numero_cliente,
       		itens_pedido.quantidade_pedido,
       		itens_pedido.preco_unitario,
       		pedido.status_pedido
	from itens_pedido 
	inner join pedido on pedido.numero_pedido = itens_pedido.numero_pedido

-- VALIDANDO OS DADOS DA VIEW 
select 	*
from VW_ITENS_PEDIDO_PEDIDO;
	

-- TRUNCANDO A STAGE AREA ST_VENDA
truncate ST_VENDA cascade;


-- INSERT NA STAGE ST_VENDA
INSERT INTO ST_VENDA
	SELECT data_pedido,
	       numero_pedido,
	       codigo_produto,
	       numero_cliente,
	       quantidade_pedido,
	       preco_unitario,
	       status_pedido,
	       CURRENT_DATE
	FROM dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=legado ', 
				'select * from VW_ITENS_PEDIDO_PEDIDO') TABELA (data_pedido date, numero_pedido int, codigo_produto varchar, numero_cliente int, quantidade_pedido int, preco_unitario numeric, status_pedido varchar) ;
;

-- VALIDANDO OS DADOS 
select 	*
from ST_VENDA;



-- ANTES DE INSERIR DEVE ZERAR A TABELA DE STAGE AREA 
truncate table ST_PRODUTO;


-- INSERIR DADOS NA DIMENSÃO PRODUTO
insert into st_produto 
	select 	cod_produto,
			nome_produto,
			categoria_produto,
			preco_produto,
			status_produto,
			current_date
	from dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=legado',
				'select * from produto') Tabela (cod_produto varchar, nome_produto varchar, categoria_produto varchar, medida_produto varchar, fornecedor_produto varchar, descricao_produto text, qtd_estoque_produto int, preco_produto numeric, status_produto varchar);
;

-- VALIDANDO OS DADOS
select * from st_produto;
select * from st_cliente;
select * from st_venda ;
























