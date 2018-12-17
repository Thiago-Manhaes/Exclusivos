


TEXT TO XSEL NOSHOW TEXTMERGE 


	declare @data_ini datetime
	declare @data_fim datetime

	select @data_ini='20080101'
	select @data_fim='20120831'


	SELECT VENDAS_TIPO_PGTO.ANO_VENDA, 
	VENDAS_TIPO_PGTO.MES_VENDA,
	VENDAS_TIPO_PGTO.DESC_MES_VENDA,
	VENDAS_TIPO_PGTO.ANMTIPO_PGTO_CONSOLIDADO,
	VENDAS_TIPO_PGTO.ANMDESC_TIPO_PGTO_CONSOLIDADO,
	VENDAS_TIPO_PGTO.SUM_VALOR AS VALOR_TIPO_PGTO,
	ISNULL(PRAZOS_MEDIOS.PRAZO_MEDIO,0) AS PRAZO_MEDIO
	FROM 

		(select 
		year(Loja_venda.data_venda) as ano_venda,
		month(Loja_venda.data_venda) as mes_venda,
		case 
			when month(Loja_venda.data_venda) =1  then 'JANEIRO' 
			when month(Loja_venda.data_venda) =2  then 'FEVEREIRO' 
			when month(Loja_venda.data_venda) =3  then 'MARCO' 
			when month(Loja_venda.data_venda) =4  then 'ABRIL' 
			when month(Loja_venda.data_venda) =5  then 'MAIO' 
			when month(Loja_venda.data_venda) =6  then 'JUNHO' 
			when month(Loja_venda.data_venda) =7  then 'JULHO' 
			when month(Loja_venda.data_venda) =8  then 'AGOSTO' 
			when month(Loja_venda.data_venda) =9  then 'SETEMBRO' 
			when month(Loja_venda.data_venda) =10  then 'OUTUBRO' 
			when month(Loja_venda.data_venda) =11  then 'NOVEMBRO' 
			when month(Loja_venda.data_venda) =12  then 'DEZEMBRO' 
		end as desc_mes_venda,
		Tipos_pgto.ANMTIPO_PGTO_CONSOLIDADO, Tipos_pgto.ANMDESC_TIPO_PGTO_CONSOLIDADO,  
		SUM(Loja_venda_parcelas.VALOR) AS sum_valor,  
		SUM(Loja_venda_parcelas.VALOR_CANCELADO) AS valor_cancelado,  
		SUM(1) AS no_vendas, 
		convert(numeric(5,0),0) AS prazo_medio,  
		convert(numeric(5,2),0) AS porc,  
		convert(numeric(5,2),0) AS porc_acumulada, 
		convert(numeric(14,2),0) AS valor_liq_sem_vale, 
		convert(numeric(14,2),0) AS vales_recebidos 
		FROM dbo.LOJA_VENDA Loja_venda
		join dbo.LOJA_VENDA_PARCELAS Loja_venda_parcelas
		on  Loja_venda.LANCAMENTO_CAIXA = Loja_venda_parcelas.LANCAMENTO_CAIXA 
		and Loja_venda.TERMINAL_PGTO = Loja_venda_parcelas.TERMINAL
		and Loja_venda.CODIGO_FILIAL_PGTO = Loja_venda_parcelas.CODIGO_FILIAL
		join 
		dbo.TIPOS_PGTO Tipos_pgto 
		on Tipos_pgto.TIPO_PGTO = Loja_venda_parcelas.TIPO_PGTO
		join dbo.LOJAS_VAREJO Lojas_varejo
		on Loja_venda.CODIGO_FILIAL = Lojas_varejo.CODIGO_FILIAL 
		join dbo.FILIAIS Filiais 
		on Lojas_varejo.FILIAL = Filiais.FILIAL 
		join dbo.CADASTRO_CLI_FOR Cadastro_cli_for 
		on Lojas_varejo.FILIAL = Cadastro_cli_for.NOME_CLIFOR 
		join dbo.LOJA_VENDA_PGTO Loja_venda_pgto  
		on Loja_venda.CODIGO_FILIAL = Loja_venda_pgto.CODIGO_FILIAL 
		and Loja_venda.LANCAMENTO_CAIXA = Loja_venda_pgto.LANCAMENTO_CAIXA 
		and Loja_venda.TERMINAL_PGTO = Loja_venda_pgto.TERMINAL 
		and Loja_venda.DATA_VENDA = Loja_venda_pgto.DATA  
		where Tipos_pgto.ANMTIPO_PGTO_CONSOLIDADO is not null 
		and Tipos_pgto.tipo_pgto not in ('R','V','X') 
		and Loja_venda.codigo_filial not in ('985','991','988','989') 
		and Loja_venda.data_venda between @data_ini and @data_fim
		GROUP BY year(Loja_venda.data_venda),month(Loja_venda.data_venda),
		Tipos_pgto.ANMTIPO_PGTO_CONSOLIDADO, Tipos_pgto.ANMDESC_TIPO_PGTO_CONSOLIDADO ) VENDAS_TIPO_PGTO 


	LEFT JOIN 

		(SELECT 
		ano_financeiro,
		mes_financeiro,
		ANMTIPO_PGTO_CONSOLIDADO,
		CASE 
			WHEN ANMTIPO_PGTO_CONSOLIDADO IN ('X','F','D','R') THEN 0
			ELSE PRAZO_MEDIO
		END AS PRAZO_MEDIO 

		FROM

		(SELECT 

		year(CTB_CHEQUE_CARTAO.data_emissao) as ano_financeiro,
		month(CTB_CHEQUE_CARTAO.data_emissao) as mes_financeiro,
		TIPOS_PGTO.ANMTIPO_PGTO_CONSOLIDADO, CONVERT(NUMERIC(16,2), SUM(CONVERT(NUMERIC(16,2), 
		CASE when DATEDIFF(DAY,DATA_EMISSAO,VENCIMENTO) = 0 THEN 1 ELSE 
		DATEDIFF(DAY,data_EMISSAO,VENCIMENTO) END) * 

		CONVERT(NUMERIC(16,2), VALOR_ORIGINAL)) /  
		case when SUM(CONVERT(NUMERIC(16,2), VALOR_ORIGINAL)) =0 then 1 else SUM(CONVERT(NUMERIC(16,2), VALOR_ORIGINAL)) end   ) AS PRAZO_MEDIO 
		FROM CTB_CHEQUE_CARTAO JOIN filiais on CTB_CHEQUE_CARTAO.cod_filial=filiais.cod_filial 
		join LOJAS_VAREJO ON filiais.FILIAL = LOJAS_VAREJO.FILIAL 
		JOIN CADASTRO_CLI_FOR ON FILIAIS.FILIAL = 
		CADASTRO_CLI_FOR.NOME_CLIFOR  
		JOIN TIPOS_PGTO ON CTB_CHEQUE_CARTAO.LOJA_TIPO_PGTO=TIPOS_PGTO.TIPO_PGTO
		OR TIPOS_PGTO.TIPO_PGTO IN ('X','F','D')
		WHERE ORIGEM = 'L'   
		and LOJAS_VAREJO.codigo_filial not in ('985','991','988','989') 
		and Tipos_pgto.tipo_pgto not in ('R','V','X') 
		And CTB_CHEQUE_CARTAO.data_emissao between @data_ini and @data_fim 
		AND LANCAMENTO NOT IN (SELECT LANCAMENTO FROM CTB_ACOMPANHAMENTO WHERE OCORRENCIA IN ('4','2'))
		GROUP BY 
		year(CTB_CHEQUE_CARTAO.data_emissao) ,
		month(CTB_CHEQUE_CARTAO.data_emissao) ,
		TIPOS_PGTO.ANMTIPO_PGTO_CONSOLIDADO ) A ) PRAZOS_MEDIOS


	ON  VENDAS_TIPO_PGTO.ANO_VENDA=PRAZOS_MEDIOS.ANO_FINANCEIRO 
	AND VENDAS_TIPO_PGTO.MES_VENDA=PRAZOS_MEDIOS.MES_FINANCEIRO 
	AND VENDAS_TIPO_PGTO.ANMTIPO_PGTO_CONSOLIDADO=PRAZOS_MEDIOS.ANMTIPO_PGTO_CONSOLIDADO 

	ORDER BY 
	VENDAS_TIPO_PGTO.ANO_VENDA, 
	VENDAS_TIPO_PGTO.MES_VENDA,
	VENDAS_TIPO_PGTO.ANMDESC_TIPO_PGTO_CONSOLIDADO

ENDTEXT 

F_SELECT(XSEL,"CUR_VENDAS_TIPO_PGTO")

SELE CUR_VENDAS_TIPO_PGTO
COPY TO C:\TEMP\VENDASPGTO.XLS XLS
