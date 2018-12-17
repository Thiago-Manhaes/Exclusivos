USE [TESTE_SOMA]
GO
/****** Object:  Trigger [dbo].[LXU_ANM_TB_BLOQ_FICHA_TECNICA_PA]    Script Date: 23/09/2016 09:11:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[LXU_ANM_CLIENTE_ATAC_LIMITE_CREDITO] 
ON [dbo].[ANM_CLIENTE_ATAC_LIMITE_CREDITO]
FOR UPDATE NOT FOR REPLICATION
AS

begin


declare  @numrows int,
           @nullcnt int,
           @validcnt int, 
           @errno   int,
           @errmsg  varchar(255)

	 IF UPDATE(LIMITE)
		BEGIN 
			INSERT INTO ANM_LOG_CLIENTE_ATAC_LIMITE_CREDITO
			 
			 SELECT A.REDE_LOJAS,
					A.COLECAO,
					A.COD_CLIENTE,
					B.LIMITE								AS LIMITE_ANTES,
					A.LIMITE								AS LIMITE_NOVO,
					GETDATE()								AS DATA_HORA_ALTERAÇÃO,
					CONVERT(VARCHAR(240),SYSTEM_USER)		AS USUARIO_LINX,
					CONVERT(VARCHAR(30),host_name())  		AS NOME_COMPUTADOR,
					'U'										AS TRIGGER_ORIGEM
			 FROM inserted A  JOIN deleted B  ON A.REDE_LOJAS = B.REDE_LOJAS AND A.COLECAO = B.COLECAO AND A.COD_CLIENTE = B.COD_CLIENTE
			 WHERE A.LIMITE <> B.LIMITE
		END
	return
error:
    raiserror (@errmsg, 16, 1)
    rollback transaction

end






