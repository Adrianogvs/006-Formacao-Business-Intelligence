-- TRUNCAR A TABELA DIMENSÃO CLIENTE
TRUNCATE TABLE DIM_CLIENTE CASCADE;


-- INSEREIR DADOS NA DIMENSÃO CLIENTE
INSERT INTO DIM_CLIENTE
SELECT nextval('dim_cliente_id_seq') AS sk_cliente,
       cd_cliente,
       nome_cliente,
       email_cliente,
       CURRENT_DATE AS data_carga
FROM dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=st_biacademy', 'select * from st_cliente') t (cd_cliente int, nome_cliente varchar, email_cliente varchar, dt_carga TIMESTAMP);


-- VALIDANDO OS DADOS
SELECT *
FROM dim_cliente dc ;


-- TRUNCAR A TABELA DIMENSÃO PRODUTO
TRUNCATE TABLE DIM_PRODUTO CASCADE;


-- INSERINDO DADOS NA DIMENSÃO PRODUTO
INSERT INTO dim_produto
SELECT NEXTVAL('dim_produto_id_seq') AS sk_produto,
       cod_produto,
       nome_produto,
       cat_produto,
       preco_produto,
       status_produto,
       current_date AS data_carga
FROM   dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=st_biacademy', 'select * from st_produto') t (cod_produto VARCHAR, nome_produto VARCHAR, cat_produto VARCHAR, preco_produto NUMERIC, status_produto VARCHAR, dt_carga timestamp);

;

--VALIDANDO OS DADOS
SELECT *
FROM dim_produto dp ;


-- TRUNCANDO A TABELA DIMENSAO DATA
TRUNCATE TABLE DIM_DATA CASCADE ;


-- SET O IDIOMA DOS DIAS E MESES
set LC_TIME = 'PT_BR.UTF8';
set LC_MESSAGES = 'PT_BR.UTF8';


-- CRIAR FUNÇÃO PARA TRAZER A MENOR DATA NA TABELA PEDIDO DO LEGADO
CREATE FUNCTION fc_min_data() returns DATE AS  $$
  DECLARE
    primeiro_dia DATE;
  BEGIN
    primeiro_dia =
    ( SELECT to_char(min(data_pedido), 'YYYY-MM-DD')
           FROM   dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=legado', 'select * from pedido')t(numero_pedido INT, data_pedido timestamp, data_pagamento_pedido timestamp, data_entrega_pedido timestamp, status_pedido VARCHAR, comentario text, numero_cliente INT));
    RETURN primeiro_dia;
  END;
  $$ LANGUAGE plpgsql;


-- CRIAR FUNÇÃO PARA BUSCAR A ULTIMA DATA LANÇADA NA TABELA PEDIDO DO LEGADO
CREATE FUNCTION fc_numero_dias() returns INTEGER AS  $$
  DECLARE
    nr INTEGER;
  BEGIN
    nr =
    (SELECT to_number( to_char(max(data_entrega_pedido), 'YYYY-MM-DD'),'9999999999') - to_number(to_char(min(data_pedido), 'YYYY-MM-DD'),'9999999999') AS total
           FROM   dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=legado', 'select * from pedido')t(numero_pedido INT, data_pedido timestamp, data_pagamento_pedido timestamp, data_entrega_pedido timestamp, status_pedido VARCHAR, comentario text, numero_cliente INT));
    RETURN nr;
  END;
  $$ LANGUAGE plpgsql;

-- INSERINDO DADOS NA TABELA DIMENSÃO DATA
INSERT INTO dim_data
SELECT To_number(To_char(datum, 'YYYYMMDD'), '99999999') AS sk_data,
       datum                                             AS data,
       To_char(datum, 'dd/mm/yyyy')                      AS desc_data_completa,
       Extract (year FROM datum)                         AS nr_ano,
       'T'|| To_char(datum, 'q')     AS nr_trimestre,
       To_char(datum, '"T"q/yyyy')   AS nr_ano_trimestre,
       Extract(month FROM datum)     AS nr_mes,
       To_char(datum, 'tmMonth')     AS nm_mes,
       To_char(datum, 'yyyy/mm')     AS ano_mes,
       Extract(week FROM datum)      AS nr_semana,
       To_char(datum, 'iyyy/iw')     AS ano_semana,
       Extract(day FROM datum)       AS nr_dia,
       Extract(doy FROM datum)       AS nr_dia_ano,
       To_char(datum, 'tmDay')       AS nm_dia_semana,
       CASE
              WHEN Extract(isodow FROM datum) IN (6,7) THEN 'Sim'
              ELSE 'Não'
       END AS flag_final_semana,
       CASE
              WHEN To_char(datum, 'mmdd') IN ('0101','1225') THEN 'Sim'
              ELSE 'Não'
       END AS flag_feriado,
       case -- INSERIR OS FERIADOS QUE EXSITEM no ANO
              WHEN To_char(datum, 'mmdd') = '0101' THEN 'Ano Novo' 
              WHEN To_char(datum, 'mmdd') = '1225' THEN 'Natal' 
              ELSE 'Não é Feriado'
       END AS nn_feriado,
       current_date AS dt_carga
FROM   ( SELECT
                         ( SELECT To_char(Min_data(),'YYYY-MM-DD'))::DATE + SEQUENCE.day AS datum
                FROM     generate_series(0,numero_dias()+30) AS SEQUENCE(day)
                GROUP BY SEQUENCE.day
                ORDER BY 1 ASC) tabela_calendario;


-- VALIDANDO OS DADOS DA DIMENSÃO CALENDARIO
select * from DIM_PRODUTO;




      