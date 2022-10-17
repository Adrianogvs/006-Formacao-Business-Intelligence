-- PASSO 1: CRIAR A FATO VENDA
create table FATO_VENDA(
	SK_DATA INTEGER not null,
	SK_CLIENTE INTEGER not null,
	QTD_VENDA INTEGER not null,
	VL_VENDA_UNI NUMERIC(12,4) not null,
	VL_VENDA_TOTAL numeric(12,4) not NULL
);

truncate fato_venda;

-- PASSO 2: INSERIR DADOS NA FATO
INSERT INTO FATO_VENDA(SK_DATA, SK_CLIENTE, QTD_VENDA, VL_VENDA_UNI, VL_VENDA_TOTAL)
SELECT to_number(to_char(dt_venda, 'YYYYMMDD'), '99999999') as dt_venda,
  (SELECT coalesce (sk_cliente, -1)
   FROM dim_cliente) AS sk_cliente,
       qtd_vendida,
       vl_vendido,
       qtd_vendida * vl_vendido AS total
FROM 
   (SELECT *
    FROM dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=st_biacademy', 'select * from st_venda ') 
         tabela (dt_venda date, cd_venda integer, cd_produto varchar, qtd_vendida integer, vl_vendido numeric, cd_cliente varchar, status_venda varchar)) tab_fato
left JOIN dim_cliente ON dim_cliente.nk_cliente = tab_fato.cd_cliente;



select * from fato_venda;



-- PASSO 3: 
