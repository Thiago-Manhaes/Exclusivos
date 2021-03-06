USE [SOMA]
GO
/****** Object:  Trigger [dbo].[LXU_ANM_FATURAMENTO]    Script Date: 15/06/2016 10:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Trigger [dbo].[LXU_ANM_FATURAMENTO] 
On [dbo].[FATURAMENTO]
For UPDATE NOT FOR REPLICATION
As 
-- UPDATE Trigger On FATURAMENTO
-- 30-11-2015 - ANM.LEONARDO.ROVEDO	- TRATAMENTO PARA NÃO PERMITIR CANCELAMENTO DE NOTAS INUTILIZADAS OU AGUARDANDO INUTILIZAÇÃO 
-- #1 - ANM.LUCAS MIRANDA - 21/03/2016 - DELETAR LOJA_ENTRADAS AO CANCELAR NF
-- #2 - ANM.LUCAS MIRANDA - 15/06/2016 - INCLUIDO O STATUS AGUARDANDO CANCELAMENTO E INUTILIZAÇÃO
Begin

	Declare	@errno   Int,
			@errmsg  varchar(255)


		IF ( SELECT COUNT(*)
		 FROM inserted A JOIN deleted B
			ON A.NF_SAIDA = B.NF_SAIDA
			AND A.SERIE_NF = B.SERIE_NF
			AND A.FILIAL = B.FILIAL
		WHERE A.MOTIVO_CANCELAMENTO_NFE <> B.MOTIVO_CANCELAMENTO_NFE
		AND LEN(A.MOTIVO_CANCELAMENTO_NFE) < 15  AND ISNULL(A.MOTIVO_CANCELAMENTO_NFE,'') <> ''
		AND A.NOTA_CANCELADA = 1 AND A.STATUS_NFE > 0 ) > 0
		
		BEGIN
			SELECT 	@ERRNO=30002,
				@ERRMSG = 'NÃO É PERMITIDO MOTIVO DO CANCELAMENTO COM MENOS DE 15 CARACTERES, FAVOR ALTERAR A O MOTIVO DO CANCELAMENTO'
			GOTO ERROR
		END				
		
		
		
		IF ( SELECT COUNT(*) FROM inserted WHERE ISNULL(DATEDIFF(MINUTE,DATA_AUTORIZACAO_NFE,GETDATE()),0) > 
			 (SELECT (ISNULL(VALOR_ATUAL,0)*24)*60 FROM PARAMETROS WHERE PARAMETRO = 'DIAS_CANCELAMENTO_NFE') 
			 AND NOTA_CANCELADA = 1 AND STATUS_NFE > 0) > 0
		
		BEGIN
			SELECT 	@ERRNO=30002,
				@ERRMSG = 'PRAZO DE CANCELAMENTO DA NFE VENCIDO, IMPOSSÍVEL CANCELAR NF-E'
			GOTO ERROR
		END		

--AF_BRANDS - 09/04/14 - NÃO PERMITIR SALVAR NOTAS SEM RATEIO CENTRO DE CUSTO E RATEIO FILIAL
		IF ( SELECT COUNT(*) FROM inserted WHERE  RATEIO_CENTRO_CUSTO is null) > 0
		
		BEGIN
			SELECT 	@ERRNO=30002,
				@ERRMSG = 'NÃO É PERMITIDO SALVAR NOTA SEM RATEIO CENTRO DE CUSTO.'
			GOTO ERROR
		END		

		IF ( SELECT COUNT(*) FROM inserted WHERE RATEIO_FILIAL is null) > 0
		BEGIN
			SELECT 	@ERRNO=30002,
				@ERRMSG = 'NÃO É PERMITIDO SALVAR NOTA SEM RATEIO FILIAL.'
			GOTO ERROR
		END		

		IF ( SELECT COUNT(*) FROM INSERTED 
			 WHERE NOME_CLIFOR = (SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_FABRICA')) 
			   AND COD_TRANSACAO = 'FATURAMENTO_028'
			   AND FILIAL IN (SELECT FILIAL FROM FILIAIS WHERE MATRIZ_FISCAL <> MATRIZ)    
			   AND NATUREZA_SAIDA <> '123.01' ) > 0
		
		BEGIN
			SELECT 	@ERRNO=30002,
				@ERRMSG = 'NATUREZA DA NF INCORRETA PARA FILIAL MATRIZ'
			GOTO ERROR
		END	
		
	-----------------------------------------------------------------------------------------------------


--AF_BRANDS - ISMARA - 21/01/2015 - ESTÃO USANDO NATUREZA DE TRANSFERENCIA PARA MOVIMENTAR MERCADORIA DO DEPOSITO FECHADO... TRAVAR PARA SÓ EMITIR E SÓ RECEBER POR NATUREZA DE REMESSA E RETORNO DE ARMAZEM 
	IF(
		SELECT COUNT(*)
		FROM INSERTED A
		JOIN CADASTRO_CLI_FOR DESTINO ON A.NOME_CLIFOR=DESTINO.NOME_CLIFOR
		WHERE NATUREZA_SAIDA NOT IN ('132.03') AND DESTINO.INDICADOR_FISCAL_TERCEIRO='9'
		AND A.FILIAL <> 'ALMOXARIFADO'
	)>0 OR
	(
		SELECT COUNT(*)
		FROM INSERTED A
		JOIN CADASTRO_CLI_FOR ORIGEM ON A.FILIAL=ORIGEM.NOME_CLIFOR
		WHERE NATUREZA_SAIDA NOT IN ('146.01','199.01') AND ORIGEM.INDICADOR_FISCAL_TERCEIRO='9'
		AND A.FILIAL <> 'ALMOXARIFADO'
	)>0
	BEGIN
		SELECT  @ERRNO=30002,
			@ERRMSG='FILIAL ORIGEM OU DESTINO ARMAZEM SÓ PODE TRANSITAR MERCADORIA PELAS NATUREZAS DE DEPOSITO FECHADO. VERIFIQUE COM O SETOR FISCAL.'
		GOTO ERROR
	END


--AF_BRANDS -14/01/2015 - NÃO PERMITIR SALVAR NOTAS COM RATEIO FILIAL E FILIAL DE MATRIZES CONTABEIS DIFERENTES
	IF (
		SELECT COUNT(*)
		FROM INSERTED A
		JOIN FILIAIS FIL ON A.FILIAL=FIL.FILIAL
		JOIN (SELECT RATEIO_FILIAL,DESC_RATEIO_FILIAL,B.MATRIZ MATRIZ FROM CTB_FILIAL_RATEIO A JOIN FILIAIS B ON A.COD_MATRIZ_CONTABIL=B.COD_FILIAL) RAT ON A.RATEIO_FILIAL=RAT.RATEIO_FILIAL
		WHERE FIL.MATRIZ<>RAT.MATRIZ 
		-- ACRESCENTADO A CLAUSULA ABAIXO PARA NAO TRAVAR IMPORTAÇÃO DAS NOTAS DE 2014 -- JULIO -- 14-01-2015
		AND A.TIPO_FATURAMENTO <> 'IMPORTADO UNIF'
	) > 0
	BEGIN
		  SELECT  @ERRNO=30002,
		   @ERRMSG='RATEIO DE FILIAL DA NOTA COM MATRIZ CONTÁBIL DIFERENTE DA FILIAL DO CABEÇALHO. OPERAÇÃO CANCELADA.'
		   GOTO ERROR
	END
	

-- 30-11-2015 - ANM.LEONARDO.ROVEDO	- TRATAMENTO PARA NÃO PERMITIR CANCELAMENTO DE NOTAS INUTILIZADAS OU AGUARDANDO INUTILIZAÇÃO 
--IF (SELECT STATUS_NFE FROM INSERTED ) = '49'
if (select COUNT(*) from inserted where STATUS_NFE='49')>0             -- --ismara - 26/04/2016 - sempre que faço acerto em mais de uma nota este IF dá erro de agrupamento, desta forma funcionou!!
            BEGIN
                IF EXISTS    (
                            SELECT 1 
                            FROM INSERTED A 
                            WHERE ISNULL(RTRIM(LTRIM(REGISTRO_DPEC)),'') <> '' 
                            AND RTRIM(LTRIM(REGISTRO_DPEC)) <> '0'
                            AND PROTOCOLO_AUTORIZACAO_NFE IS NULL
							and STATUS_NFE IN('52','59')
                            )
                            BEGIN
                                Select @errno=30002,
                                       @errmsg='Não é permitido CANCELAR nota fiscal, aguardando retorno EPEC ou em EPEC.'
                                GoTo Error
                            END
            END

-- #1 - ANM.LUCAS MIRANDA
-- #2 - ANM.LUCAS MIRANDA
if Exists (Select 1 
			From Inserted a 
			Join Loja_Entradas b
			On A.Nf_Saida = B.Numero_Nf_Transferencia
			and A.Serie_Nf = B.Serie_Nf_Entrada
			and A.Filial = B.Filial_Origem
			Where (A.Status_Nfe = '42' or A.Status_Nfe = '52')
			and (B.Entrada_Conferida = 1 or B.Entrada_Encerrada = 1)) 
			begin
				Select @errno=30002,
                       @errmsg='Não é permitido Cancelar Nota Fiscal, Existe Entrada Física Conferida/Confirmada !'
                GoTo Error
			end

if (select COUNT(*) from inserted where STATUS_NFE ='49' or STATUS_NFE = '59')>0 --ismara - 26/04/2016 - sempre que faço acerto em mais de uma nota este IF dá erro de agrupamento, desta forma funcionou!!
--	IF (SELECT STATUS_NFE FROM INSERTED ) = '49'
            BEGIN
				DELETE A 
				FROM LOJA_ENTRADAS A
				JOIN INSERTED B
				ON A.NUMERO_NF_TRANSFERENCIA = B.NF_SAIDA
				AND A.SERIE_NF_ENTRADA = B.SERIE_NF
				AND A.FILIAL_ORIGEM = B.FILIAL          
            END
-- #FIM - 1 - ANM.LUCAS MIRANDA	

		
		
	IF UPDATE(STATUS_NFE)
	BEGIN
	
	DECLARE @Nf_Saida char(15),@Serie_nf varchar(6), @Filial  varchar(25)
	Select @Nf_Saida=NF_SAIDA,@Serie_nf=SERIE_NF,@Filial=FILIAL From Inserted
	
		IF ((SELECT COUNT(*) FROM inserted WHERE STATUS_NFE = '5') > 0) OR
		   (UPDATE(DATA_CONTINGENCIA) AND (SELECT COUNT(*) FROM inserted WHERE ISNULL(DATA_CONTINGENCIA,'')<>'') > 0)
		     
			BEGIN
			
				-- ENVIA XML PARA GOFRETE ---
				
				
				INSERT INTO LX_ANM_PROCESSA_XML_GOFRETE_LOG
				(PROCESSO,COMANDO,ORIGEM,STATUS,DATA_LOG,LOG_PROCESSO,DATA_PROCESSADO)
				VALUES
				('LX_ANM_ENVIA_XML_EMAIL','LX_ANM_ENVIA_XML_EMAIL 
					@Nf_numero='+''''+@Nf_Saida+''''+','+
				   '@Serie_nf='+''''+@Serie_nf+''''+','+
				   '@Filial='+''''+@Filial+''''+',@status_nfe=5','LXU_ANM_FATURAMENTO',0,GETDATE(),NULL,NULL) 

			
			END
		
		IF (SELECT COUNT(*) FROM inserted WHERE STATUS_NFE = '49') > 0 		
			
			BEGIN
			
				-- ENVIA XML PARA GOFRETE ---
				
				INSERT INTO LX_ANM_PROCESSA_XML_GOFRETE_LOG
				(PROCESSO,COMANDO,ORIGEM,STATUS,DATA_LOG,LOG_PROCESSO,DATA_PROCESSADO)
				VALUES
				('LX_ANM_ENVIA_XML_EMAIL','LX_ANM_ENVIA_XML_EMAIL 
					@Nf_numero='+''''+@Nf_Saida+''''+','+
				   '@Serie_nf='+''''+@Serie_nf+''''+','+
				   '@Filial='+''''+@Filial+''''+',@status_nfe=49','LXU_ANM_FATURAMENTO',0,GETDATE(),NULL,NULL) 
			
			END		
			
	END
	
	
		IF UPDATE(VALOR_TOTAL) 
		AND
			(SELECT dbo.FX_ANM_PARAMETRO_USER('ANM_LIMITE_FAT_FABULA')) >= 0 
		AND
			( SELECT 1 FROM INSERTED A	
				JOIN FILIAIS B ON A.FILIAL = B.FILIAL
			  WHERE MATRIZ='FABULA - MATRIZ' AND SUBSTRING(NATUREZA_SAIDA,1,3)='100') = 1
		
		BEGIN
			
			DECLARE @TravaFaturamento NUMERIC(14,2) =
			(SELECT SUM(TOTAL) FROM
			(
			-- LOJAS FABULA -- 2015
			SELECT SUM(VALOR_PAGO) AS TOTAL
			FROM LOJA_VENDA (NOLOCK)
			WHERE YEAR(DATA_VENDA)='2015' 
			AND CODIGO_FILIAL IN (SELECT B.COD_FILIAL 
								  FROM LOJAS_VAREJO A (NOLOCK)
									JOIN FILIAIS  (NOLOCK) B ON A.FILIAL = B.FILIAL 
								  WHERE MATRIZ='FABULA - MATRIZ')	
			Union ALL

			-- FATURAMENTO FABULA -- 2015
			SELECT SUM(VALOR_TOTAL) AS TOTAL
			FROM FATURAMENTO  (NOLOCK)
			WHERE FILIAL IN (SELECT FILIAL FROM FILIAIS WHERE MATRIZ='FABULA - MATRIZ') 
			AND YEAR(EMISSAO)='2015'  AND STATUS_NFE NOT IN ('49','59') AND SUBSTRING(NATUREZA_SAIDA,1,3)='100'
			Union ALL

			-- ENTRADAS FABULA -- 2015
			SELECT SUM(-VALOR_TOTAL) AS TOTAL
			FROM ENTRADAS (NOLOCK)
			WHERE FILIAL IN (SELECT FILIAL FROM FILIAIS WHERE MATRIZ='FABULA - MATRIZ')
			AND YEAR(RECEBIMENTO)='2015'  AND STATUS_NFE NOT IN ('49','59') AND SUBSTRING(NATUREZA,1,3)='250'

			) A ) 
		
			IF @TravaFaturamento+(SELECT VALOR_TOTAL FROM INSERTED) > (SELECT dbo.FX_ANM_PARAMETRO_USER('ANM_LIMITE_FAT_FABULA'))
		
				BEGIN
					SELECT  @ERRNO=30002,
						@ERRMSG=CHAR(13)+'FILIAL FABULA ULTRAPASSOU LIMITE DE FATURAMENTO ANUAL. '+char(13)+
										 'FAVOR PROCURAR O SETOR FISCAL\CONTROLADORIA.'+CHAR(13)+CHAR(13)+
								         'LIMITE: '+RTRIM(CONVERT(VARCHAR(20),(SELECT dbo.FX_ANM_PARAMETRO_USER('ANM_LIMITE_FAT_FABULA'))))+CHAR(13)+
								         'FATURADO: '+CONVERT(VARCHAR(20),@TravaFaturamento-(SELECT VALOR_TOTAL FROM INSERTED))
					GOTO ERROR
				END			
		END	
	


--ismara - 22/01/2016 - não podemos permitir o cancelamento de uma nota se houver movimentação financeira dela. Precisam excluir antes a movimentação feita
declare @lancamento_mov int 
IF ((SELECT COUNT(*)  FROM INSERTED where STATUS_NFE = '42' or isnull(MOTIVO_CANCELAMENTO_NFE,'')<>'')>0) and
	(select COUNT(*)
	from inserted a
	left join CTB_AVISO_LANCAMENTO_MOV w on w.LANCAMENTO_MOV =a.CTB_LANCAMENTO and w.ITEM_MOV=a.CTB_ITEM
	left join CTB_BORDERO_PARCELA_CMD x on x.LANCAMENTO_MOV =a.CTB_LANCAMENTO and x.ITEM_MOV=a.CTB_ITEM
	left join CTB_A_RECEBER_MOV y on y.LANCAMENTO_MOV =a.CTB_LANCAMENTO and y.ITEM_MOV=a.CTB_ITEM) >0 
BEGIN
		
		SELECT @lancamento_mov = lancamento from (
		select top 1 w.LANCAMENTO
		from inserted a
		join CTB_AVISO_LANCAMENTO_MOV w on w.LANCAMENTO_MOV =a.CTB_LANCAMENTO and w.ITEM_MOV=a.CTB_ITEM)a
		if @lancamento_mov is not null 
		begin
			SELECT  @ERRNO=30002,
			@ERRMSG=CHAR(13)+'Não é permitido cancelar notas com aviso movimentado. Favor revisar a baixa '+cast(@lancamento_mov as char(20))
			GOTO ERROR
		end

		SELECT @lancamento_mov = lancamento from (
		select top 1 y.LANCAMENTO
		from inserted a
		left join CTB_A_RECEBER_MOV y on y.LANCAMENTO_MOV =a.CTB_LANCAMENTO and y.ITEM_MOV=a.CTB_ITEM)a
		if @lancamento_mov is not null 
		begin
			SELECT  @ERRNO=30002,
			@ERRMSG=CHAR(13)+'Não é permitido cancelar notas com titulo movimentado. Favor revisar a baixa '+cast(@lancamento_mov as char(20))
			GOTO ERROR
		end
		
		SELECT @lancamento_mov = lancamento from (
		select top 1 x.LANCAMENTO
		from inserted a
		left join CTB_BORDERO_PARCELA_CMD x on x.LANCAMENTO_MOV =a.CTB_LANCAMENTO and x.ITEM_MOV=a.CTB_ITEM)a
		if @lancamento_mov is not null 
		begin
			SELECT  @ERRNO=30002,
			@ERRMSG=CHAR(13)+'Não é permitido cancelar notas com borderô. Favor revisar o layout '+cast(@lancamento_mov as char(20))
			GOTO ERROR
		end
END			



	
	return
Error:
	raiserror (@errmsg, 16, 1)
	rollback transaction
End
















