
CREATE TABLE public.DIM_DATA (
                SK_DATA INTEGER NOT NULL,
                DATA DATE NOT NULL,
                DESC_DATA_COMPLETA VARCHAR(60) NOT NULL,
                NR_ANO INTEGER NOT NULL,
                NR_TRIMESTRE VARCHAR(20) NOT NULL,
                NR_ANO_TRIMESTRE VARCHAR(20) NOT NULL,
                NR_MES INTEGER NOT NULL,
                NM_MES VARCHAR(20) NOT NULL,
                ANO_MES VARCHAR(20) NOT NULL,
                NR_SEMANA INTEGER NOT NULL,
                ANO_SEMANA VARCHAR(20) NOT NULL,
                NR_DIA INTEGER NOT NULL,
                NR_DIA_ANO INTEGER NOT NULL,
                NM_DIA_SEMANA VARCHAR(20) NOT NULL,
                FLAG_FINAL_SEMANA CHAR(3) NOT NULL,
                FLAG_FERIADO CHAR(3) NOT NULL,
                NM_FERIADO VARCHAR(60) NOT NULL,
                DT_CARGA TIMESTAMP NOT NULL,
                CONSTRAINT dim_data_pk PRIMARY KEY (SK_DATA)
);


CREATE SEQUENCE public.dim_geografia_sk_geografia_seq;

CREATE TABLE public.DIM_GEOGRAFIA (
                SK_GEOGRAFIA INTEGER NOT NULL DEFAULT nextval('public.dim_geografia_sk_geografia_seq'),
                NK_GEOGRAFIA VARCHAR(60) NOT NULL,
                NOME_PAIS VARCHAR(60) NOT NULL,
                NOME_ESTADO VARCHAR(60) NOT NULL,
                UF CHAR(2) NOT NULL,
                NOME_CIDADE VARCHAR(60) NOT NULL,
                CONSTRAINT dim_geografia_pk PRIMARY KEY (SK_GEOGRAFIA)
);
COMMENT ON COLUMN public.DIM_GEOGRAFIA.NK_GEOGRAFIA IS 'É o CEP.';


ALTER SEQUENCE public.dim_geografia_sk_geografia_seq OWNED BY public.DIM_GEOGRAFIA.SK_GEOGRAFIA;

CREATE SEQUENCE public.dim_produto_sk_produto_seq;

CREATE TABLE public.DIM_PRODUTO (
                SK_PRODUTO INTEGER NOT NULL DEFAULT nextval('public.dim_produto_sk_produto_seq'),
                CD_CATEGORIA INTEGER NOT NULL,
                NOME_CATEGORIA VARCHAR(60) NOT NULL,
                CD_SUB_CATEGORIA VARCHAR(60) NOT NULL,
                NOME_SUB_CATEGORIA VARCHAR(60) NOT NULL,
                CD_PRODUTO VARCHAR(120) NOT NULL,
                NOME_PRODUTO VARCHAR(60) NOT NULL,
                MARCA_PRODUTO VARCHAR(60) NOT NULL,
                PRECO_UNITARIO NUMERIC(12,4) NOT NULL,
                CONSTRAINT dim_produto_pk PRIMARY KEY (SK_PRODUTO)
);
COMMENT ON COLUMN public.DIM_PRODUTO.CD_PRODUTO IS 'Código do produto do legado (Sistema).';
COMMENT ON COLUMN public.DIM_PRODUTO.NOME_PRODUTO IS 'Nome do produto.';
COMMENT ON COLUMN public.DIM_PRODUTO.MARCA_PRODUTO IS 'Marca do Produto.';


ALTER SEQUENCE public.dim_produto_sk_produto_seq OWNED BY public.DIM_PRODUTO.SK_PRODUTO;

CREATE SEQUENCE public.dim_cliente_sk_cliente_seq;

CREATE TABLE public.DIM_CLIENTE (
                SK_CLIENTE INTEGER NOT NULL DEFAULT nextval('public.dim_cliente_sk_cliente_seq'),
                NK_CLIENTE VARCHAR(60) NOT NULL,
                NOME_CLIENTE VARCHAR(60) NOT NULL,
                EMAIL_CLIENTE VARCHAR(60) NOT NULL,
                CONSTRAINT dim_cliente_pk PRIMARY KEY (SK_CLIENTE)
);
COMMENT ON TABLE public.DIM_CLIENTE IS 'Dimensão para cadastro dos clientes.';
COMMENT ON COLUMN public.DIM_CLIENTE.SK_CLIENTE IS 'Chave Artificial.

Sequence.

Não reutilizar.';
COMMENT ON COLUMN public.DIM_CLIENTE.NK_CLIENTE IS 'É o CPF do Cliente.';
COMMENT ON COLUMN public.DIM_CLIENTE.NOME_CLIENTE IS 'Nome completo do cliente.';
COMMENT ON COLUMN public.DIM_CLIENTE.EMAIL_CLIENTE IS 'E-mail do Cliente.';


ALTER SEQUENCE public.dim_cliente_sk_cliente_seq OWNED BY public.DIM_CLIENTE.SK_CLIENTE;

CREATE TABLE public.FAT_VENDA (
                SK_CLIENTE INTEGER NOT NULL,
                SK_PRODUTO INTEGER NOT NULL,
                SK_GEOGRAFIA INTEGER NOT NULL,
                SK_DATA INTEGER NOT NULL,
                VALOR_VENDA_DERIVADA NUMERIC(12,4) NOT NULL,
                VALOR_VENDA NUMERIC(12,4) NOT NULL,
                QTD_VENDIDA INTEGER NOT NULL
);
COMMENT ON TABLE public.FAT_VENDA IS 'Não esta utilizando PK na fato.';
COMMENT ON COLUMN public.FAT_VENDA.SK_CLIENTE IS 'Chave Artificial.

Sequence.

Não reutilizar.';
COMMENT ON COLUMN public.FAT_VENDA.VALOR_VENDA_DERIVADA IS 'Valor da Venda = Quantidade Vendida * Preço Unitário do Produto.';
COMMENT ON COLUMN public.FAT_VENDA.VALOR_VENDA IS 'Valor sem o cálculo da métrica derivada.';


ALTER TABLE public.FAT_VENDA ADD CONSTRAINT dim_data_fat_venda_fk
FOREIGN KEY (SK_DATA)
REFERENCES public.DIM_DATA (SK_DATA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.FAT_VENDA ADD CONSTRAINT dim_geografia_fat_venda_fk
FOREIGN KEY (SK_GEOGRAFIA)
REFERENCES public.DIM_GEOGRAFIA (SK_GEOGRAFIA)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.FAT_VENDA ADD CONSTRAINT dim_produto_fat_venda_fk
FOREIGN KEY (SK_PRODUTO)
REFERENCES public.DIM_PRODUTO (SK_PRODUTO)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.FAT_VENDA ADD CONSTRAINT dim_cliente_fat_venda_fk
FOREIGN KEY (SK_CLIENTE)
REFERENCES public.DIM_CLIENTE (SK_CLIENTE)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
