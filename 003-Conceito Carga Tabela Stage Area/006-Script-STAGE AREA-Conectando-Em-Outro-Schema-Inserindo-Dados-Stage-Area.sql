-- TABELA EXEMPLO STAGE AREA
create table if not exists ST_CLIENTE( -- SEMPRE UTILIZAR O PREFIXO ST_
	CD_CLIENTE INTEGER,               -- PODE USAR UM VARCHAR TAMBÉM .. NÃO SABEMOS O QUE VAI VIR ... DEPOIS É SO CONVERTER
	NOME_CLIENTE VARCHAR(255),        -- RESERVA UM ESPAÇO MAIOR SEMPRE! E GERALMENTE USA VARCHAR PARA MANIPULAR ISSO DEPOIS;
	EMAIL_CLIENTE VARCHAR(255)
);

-- PODEMOS CRIAR INDICES NA TABELA DE STAGE AREA PARA MELHORAR A PERFORMANCE DO ETL E O PROCESSAMENTO NO BANCO
create index ST_CLIENTE_CD_CLIENTE_IDX on ST_CLIENTE (CD_CLIENTE);


-- ANTES DE INSERIR DEVE ZERAR A TABELA DE STAGE
truncate table ST_CLIENTE; -- STAGE AREA É SEMPRE LIMPA! TRUNCA A TABELA ANTES DE CARREGAR ELA. SEMPRE!


-- CRIAR CONEXÃO COM OUTROS SCHEMAS
-- PERMITE FAZER SELECT DENTRO DE OUTROS SCHEMAS
create extension dblink;

-- INSAERT NA STAGE AREA
-- EXEMPLO DE UM INSERT NA STAGE AREA (NA UNHA) FAZENDO CONEXÃO EM OUTRO SCHEMA
insert into st_cliente 
	select cdcli,nomecli,emailcli
	from dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=producao',
				'select cdcli,nomecli,emailcli from cadastro_cliente') TABELEA (cdcli int4,nomecli varchar,emailcli varchar );


select	*
from dblink('host=localhost user=dw_biacademy password=dw_biacademy dbname=st_biacademy',
			'select * from st_cliente') tabela (cd_cliente int4,nome_cliente varchar, email_cliente varchar) ;