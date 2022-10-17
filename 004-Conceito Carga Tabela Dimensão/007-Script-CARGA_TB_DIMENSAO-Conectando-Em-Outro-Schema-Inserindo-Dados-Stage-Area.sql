-- PASSO 1: CRIAR A SEQUENCE PARA A SURROGATE KEY
drop sequence TABELA_DIM_ID_SEQ cascade;

create sequence TABELA_DIM_ID_SEQ
increment by 1
minvalue 1
maxvalue 9223372036854775807
start 1;


select NEXTVAL('TABELA_DIM_ID_SEQ');


-- PASSO 2: CRIAR A TABELA DIMENSÃO 
drop table TABELA_DIMENSAO cascade;

create table TABELA_DIMENSAO(
	SK_CLIENTE INTEGER primary key not null default NEXTVAL('TABELA_DIM_ID_SEQ'), -- CHAVE ARTIFICIAL AUTO-INCREMENTAL.
	COD_CLIENTE VARCHAR(60) not null,
	NOME_CLIENTE VARCHAR(100) not null,
	EMAIL_CLIENTE VARCHAR(100) not null)
;

select * from TABELA_DIMENSAO;

-- PASSO 3: TRUCAR A TABELA DIMENSÃO
truncate table TABELA_DIMENSAO cascade;

-- PASSO 4: INSERIR OS DADOS NA TABELA DIMENSÃO COM BASE NA STAGE AREA.
insert into TABELA_DIMENSAO
	select	nextval('TABELA_DIM_ID_SEQ'),
			cd_cliente,
			upper( nome_cliente) as "Nome do Cliente",
			email_cliente
	from dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=st_biacademy',
			'select * from st_cliente') tabela (cd_cliente int4,nome_cliente varchar, email_cliente varchar)
;

-- PASSO 5: VALIDAR OS DADOS
select * from TABELA_DIMENSAO;

Select	    cd_cliente,
			upper( nome_cliente) as "Nome do Cliente",
			email_cliente
	from dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=st_biacademy',
			'select * from st_cliente') tabela (cd_cliente int4,nome_cliente varchar, email_cliente varchar)
;

