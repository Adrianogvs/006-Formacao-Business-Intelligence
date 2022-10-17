create table DIM_DATA(
		SK_DATA INTEGER not null, -- 20160101
		"DATA" DATE not null,
		DESC_DATA_COMPLETA VARCHAR(60) not null, -- 01 JANEIRO DE 2017
		NR_ANO INTEGER not null, -- 2017
		NR_TRIMESTRE VARCHAR(20) not null, -- 1T
		NR_ANO_TRIMESTRE VARCHAR(20) not null, -- 2017/1T
		NR_MES INTEGER not null, -- 01
		NM_MES VARCHAR(20) not null, -- JANEIRO
		ANO_MES VARCHAR(20) not null, -- 2017/01
		NR_SEMANA INTEGER not null, -- 34
		ANO_SEMANA VARCHAR(20) not null, -- 2017/34
		NR_DIA INTEGER not null, -- 01
		NR_DIA_ANO INTEGER not null, -- 2017/31
		NM_DIA_SEMANA VARCHAR(20) not null, -- QUINTA-FEIRA
		FLAG_FINAL_SEMANA CHAR(3) not null, -- SIM/NÃO
		FLAG_FERIADO CHAR(3) not null, -- SIM/NÃO
		NM_FERIADO VARCHAR(60) not null, -- NATAL, ANO NOVO, PASCOA, CARNAVAL, ETC, ...
		DT_CARGA TIMESTAMP not null, -- 01/01/2017 23:59:00
		constraint SK_DATA_PK primary key (SK_DATA)
);

select * from DIM_DATA;

