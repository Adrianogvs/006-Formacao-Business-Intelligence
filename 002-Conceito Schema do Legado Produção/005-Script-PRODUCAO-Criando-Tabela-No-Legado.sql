-- CRIANDO TABELA EXEMPLO DO LEGADO (PRODUÇÃO)
create table if not exists CADASTRO_CLIENTE(
	CDCLI INT not null,
	NOMECLI VARCHAR(100) not null,
	EMAILCLI VARCHAR(100) not null,
	constraint CADASTRO_CLIENTE_PK primary key (CDCLI)
);

-- INSERINDO DADOS FICTICIOS NO LEGADO
insert into cadastro_cliente values (1001, 'PITON', 'SUPORT@ALGO.COM.BR');
insert into cadastro_cliente values (1002, 'DORIVA', 'DORIA@ALGO.COM.BR');
insert into cadastro_cliente values (1003, 'RIGO', 'RIGO@ALGO.COM.BR');
insert into cadastro_cliente values (1004, 'PYTHON', 'PYTHON@ALGO.COM.BR');
insert into cadastro_cliente values (1005, 'PITHON', 'PITHON@ALGO.COM.BR');

select 	*
from cadastro_cliente cc ;