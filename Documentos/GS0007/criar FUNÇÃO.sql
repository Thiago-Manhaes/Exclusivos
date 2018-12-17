

/****** Object:  UserDefinedFunction [dbo].[FX_ANM_BLOQ_LIMITE_CLIENTE]    Script Date: 16/09/2016 16:26:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---- AUTOR: LUCAS MIRANDA
---- DATA: 16/09/2016
---- FUN��O UTILIZADA PARA LINXWEB



CREATE FUNCTION [dbo].[FX_ANM_BLOQ_LIMITE_CLIENTE](@REDE_LOJAS AS CHAR(6), @COLECAO AS CHAR(6), @COD_CLIENTE AS CHAR(6), @PRODUTO CHAR(12) = ' ')
RETURNS @RET_TABLE TABLE ( REDE_LOJAS CHAR(6) COLLATE DATABASE_DEFAULT,COLECAO CHAR(6) COLLATE DATABASE_DEFAULT, COD_CLIENTE CHAR(6) COLLATE DATABASE_DEFAULT, BLOQUEIA INT,
							PERC_LIMITE NUMERIC(13,10), LIMITE_DISPONIVEL NUMERIC(14,2), LIMITE_LINXWEB NUMERIC(14,2))
AS
BEGIN

	Declare @bloqueia_limite CHAR(1) 

			SELECT @bloqueia_limite = CASE WHEN RTRIM(ISNULL(B.VALOR_ATUAL_USER,A.VALOR_ATUAL)) = '0' THEN LTRIM(RTRIM('0'))
										     WHEN RTRIM(ISNULL(B.VALOR_ATUAL_USER,A.VALOR_ATUAL)) = '1' THEN LTRIM(RTRIM('1'))
								        ELSE RTRIM(ISNULL(B.VALOR_ATUAL_USER,A.VALOR_ATUAL)) END 
			FROM PARAMETROS A 
				LEFT JOIN ( SELECT A.* FROM PARAMETROS_USERS A
							JOIN USERS B ON A.USUARIO = B.USUARIO
							WHERE LX_SYSTEM_USER = SYSTEM_USER  ) B
				ON A.PARAMETRO = B.PARAMETRO	            
			WHERE A.PARAMETRO = 'ANM_INTERNET_BLOQ_LIMITE'
			
	IF @bloqueia_limite = '1'
	BEGIN
	
		INSERT INTO @RET_TABLE ( REDE_LOJAS, COLECAO, COD_CLIENTE, BLOQUEIA, PERC_LIMITE, LIMITE_DISPONIVEL,LIMITE_LINXWEB)
		SELECT A.REDE_LOJAS, A.COLECAO, A.COD_CLIENTE, 
		CASE WHEN SUM(VALOR_ORIGINAL)/B.LIMITE*100 >= 0 AND SUM(VALOR_ORIGINAL)/B.LIMITE*100 <= 49 THEN 0
			 WHEN SUM(VALOR_ORIGINAL)/B.LIMITE*100 >= 50 AND SUM(VALOR_ORIGINAL)/B.LIMITE*100 <= 79 THEN 0
			 WHEN SUM(VALOR_ORIGINAL)/B.LIMITE*100 >= 80 AND SUM(VALOR_ORIGINAL)/B.LIMITE*100 <= 99 THEN 0
			 WHEN SUM(VALOR_ORIGINAL)/B.LIMITE*100 >= 100 THEN 1 END AS BLOQUEIA
		
		,SUM(VALOR_ORIGINAL)/B.LIMITE*100 AS PORC_LIMITE 
		,B.LIMITE - SUM(VALOR_ORIGINAL) AS LIMITE_DISPONIVEL,
		(B.LIMITE - SUM(VALOR_ORIGINAL))+SUM(ISNULL(VALOR_ORIGINAL_PROD,0)) AS LIMITE_LINXWEB
		FROM
		(
		SELECT LEFT(B.REDE_LOJAS,1) AS REDE_LOJAS, A.COLECAO, C.COD_CLIENTE, SUM(TOT_VALOR_ORIGINAL) AS VALOR_ORIGINAL
		FROM VENDAS (NOLOCK) A
		JOIN FILIAIS (NOLOCK) B
		ON A.FILIAL = B.FILIAL
		JOIN CLIENTES_ATACADO (NOLOCK) C
		ON A.CLIENTE_ATACADO = C.CLIENTE_ATACADO
		WHERE A.APROVACAO IN ('A','E')
		GROUP BY LEFT(B.REDE_LOJAS,1), A.COLECAO, C.COD_CLIENTE
		UNION ALL

		select LEFT(B.REDE_LOJAS,1) AS REDE_LOJAS, A.COLECAO, C.COD_CLIENTE, SUM(TOT_VALOR_ORIGINAL) AS VALOR_ORIGINAL  
		from vendas_lote A
		JOIN FILIAIS (NOLOCK) B
		ON A.FILIAL = B.FILIAL
		JOIN CLIENTES_ATACADO (NOLOCK) C
		ON A.CLIENTE_ATACADO = C.CLIENTE_ATACADO
		GROUP BY LEFT(B.REDE_LOJAS,1), A.COLECAO, C.COD_CLIENTE
		) A 
		JOIN ANM_CLIENTE_ATAC_LIMITE_CREDITO B 
		ON A.REDE_LOJAS = B.REDE_LOJAS
		AND A.COLECAO = B.COLECAO
		AND A.COD_CLIENTE =  B.COD_CLIENTE
		
		LEFT JOIN (select LEFT(B.REDE_LOJAS,1) AS REDE_LOJAS, A.COLECAO, C.COD_CLIENTE, SUM(LOTE_PROD.VALOR_ORIGINAL) AS VALOR_ORIGINAL_PROD  
		from vendas_lote A
		join VENDAS_LOTE_PROD lote_prod
		on a.PEDIDO_EXTERNO = lote_prod.PEDIDO_EXTERNO
		JOIN FILIAIS (NOLOCK) B
		ON A.FILIAL = B.FILIAL
		JOIN CLIENTES_ATACADO (NOLOCK) C
		ON A.CLIENTE_ATACADO = C.CLIENTE_ATACADO
		--and a.EMISSAO = '20160920'
		and LEFT(B.REDE_LOJAS,1) = @REDE_LOJAS
		AND LOTE_PROD.PRODUTO = @PRODUTO 
		GROUP BY LEFT(B.REDE_LOJAS,1), A.COLECAO, C.COD_CLIENTE) C
		ON A.REDE_LOJAS = C.REDE_LOJAS
		AND A.COLECAO = C.COLECAO
		AND A.COD_CLIENTE = C.COD_CLIENTE
		
		
		WHERE A.COLECAO = @COLECAO
		AND A.COD_CLIENTE = @COD_CLIENTE
		AND A.REDE_LOJAS = @REDE_LOJAS
		GROUP BY A.REDE_LOJAS, A.COLECAO, A.COD_CLIENTE, B.LIMITE
		

	END
	ELSE
	BEGIN

		RETURN

	END

	RETURN

END


GO


