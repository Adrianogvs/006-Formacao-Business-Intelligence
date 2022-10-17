-- PASSO 1: CRIAR UMA TABELA DE PEDIDO NO LEGADO (SCHEMA PRODUCAO)

drop table PEDIDOS;

create table PEDIDOS(
	NUMERO_PEDIDO INTEGER not null,
	DATA_PEDIDO TIMESTAMP not null,
	DATA_PAGAMENTO_PEDIDO TIMESTAMP not null,
	DATA_ENTREGA_PEDIDO TIMESTAMP not null,
	STATUS_PEDIDO VARCHAR(100) not null,
	COMENTARIOS text,
	NUMERO_CLIENTE INTEGER not null,
	primary key (NUMERO_PEDIDO)
);

-- PASSO 2: CRIAR UMA TABELA DE ITENS DE PEDIDO NO LEGADO (SCHEMA PRODUCAO)
drop table ITENS_PEDIDO;

create table ITENS_PEDIDO(
	NUMERO_PEDIDO INTEGER not null,
	CODIGO_PRODUTO VARCHAR(50) not null,
	QUANTIDADE_PEDIDO INTEGER not null,
	PRECO_UNITARIO DOUBLE precision not null,
	NUMERO_LINHA_PEDIDO smallint not null,
	primary key (NUMERO_PEDIDO, CODIGO_PRODUTO)
);



alter table ITENS_PEDIDO
    	add constraint FK_NUMERO_PEDIDO 
    	foreign key (NUMERO_PEDIDO) 
    	references PEDIDOS (NUMERO_PEDIDO);

-- PASSO 3: CRIAR UMA VIEW NO LEGADO (SCHEMA PRODUCAO)

create view VW_PEDIDOS_ITENS_PEDIDO as 
	select 	PEDIDOS.data_pedido ,
			PEDIDOS.numero_pedido ,	
			ITENS_PEDIDO.codigo_produto ,
			ITENS_PEDIDO.quantidade_pedido ,
			ITENS_PEDIDO.preco_unitario ,
			PEDIDOS.numero_cliente ,
			PEDIDOS.status_pedido 
	from PEDIDOS
	inner join ITENS_PEDIDO on ITENS_PEDIDO.NUMERO_PEDIDO = PEDIDOS.NUMERO_PEDIDO;


select 	*
from VW_PEDIDOS_ITENS_PEDIDO;

drop view VW_PEDIDOS_ITENS_PEDIDO cascade;


-- PASSO4: CRIAR TABELA ST_VENDA NO SCHEMA DA STAGE AREA
-- LEVAR SOMENBTE O QUE É NECESSARIO PARA A STAGE AREA
create table ST_VENDA(
	DT_VENDA DATE,            -- data do pedido
	CD_VENDA INTEGER,         -- numero do pedido
	CD_PRODUTO VARCHAR(255),  -- codigo do produto
	QTD_VENDIDA INTEGER,      -- quantidade do pedido
	VL_VENDIDO NUMERIC(12,4), -- preço unitário
	CD_CLIENTE VARCHAR(255),  -- numero do cliente
	STATUS_VENDA VARCHAR(50)  -- status do pedido
);


-- PASSO 5: CARRAGAR OS DADOS NA TABELA ST_VENDA
-- USAR A VIEW CRIADA
-- USAR DBLINK PARA CONECTAR EM OUTRO SCHEMA E INSERIR OS DADOS NA ST_VENDA


--TRUNCANDO A TABELA ST_VENDA
truncate table st_venda cascade;


-- INSERIDO OS DADOS NA ST_VENDA, USANDO O CONECTOR DBLINK 
-- ESSE SCRIPT É PRA SER USADO QUANDO ESTIVER CONECTADO NO SCHEMA ST_BIACADEMY, EM QUE ELE USA O CONECTOR DBLINK PARA CONECTAR NO SCHEMA PRODUCAO E LEVAR OS DADOS DA VIEW PARA A ST_VENDA
INSERT INTO ST_VENDA 
SELECT data_pedido,
       numero_pedido,
       codigo_produto,
       quantidade_pedido,
       preco_unitario,
       numero_cliente,
       status_pedido
FROM dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=producao', 'select * 
             from vw_pedidos_itens_pedido') tabela (data_pedido date, numero_pedido integer, codigo_produto varchar, quantidade_pedido integer, preco_unitario numeric, numero_cliente varchar, status_pedido varchar) ;

;




 