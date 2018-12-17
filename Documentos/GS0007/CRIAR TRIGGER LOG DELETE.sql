USE [TESTE_SOMA]
GO

/****** Object:  Trigger [dbo].[LXD_PRODUTOS_PRECO_LOG]    Script Date: 23/09/2016 09:29:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[LXD_ANM_CLIENTE_ATAC_LIMITE_CREDITO] ON [dbo].[ANM_CLIENTE_ATAC_LIMITE_CREDITO]
FOR DELETE NOT FOR REPLICATION
AS
/* DELETE trigger on PRODUTOS_PRECO_LOG */
begin

declare  @numrows int,
           @nullcnt int,
           @validcnt int, 
           @errno   int,
           @errmsg  varchar(255)

	-- IF UPDATE(LIMITE)
		BEGIN 
			INSERT INTO ANM_LOG_CLIENTE_ATAC_LIMITE_CREDITO
			 
			 SELECT b.REDE_LOJAS,
					b.COLECAO,
					b.COD_CLIENTE,
					NULL									AS LIMITE_ANTES,
					B.LIMITE								AS LIMITE_NOVO,
					GETDATE()								AS DATA_HORA_ALTERAÇÃO,
					CONVERT(VARCHAR(240),SYSTEM_USER)		AS USUARIO_LINX,
					CONVERT(VARCHAR(30),host_name())  		AS NOME_COMPUTADOR,
					'D'										AS TRIGGER_ORIGEM
			 FROM deleted B  --ON A.REDE_LOJAS = B.REDE_LOJAS AND A.COLECAO = B.COLECAO AND A.COD_CLIENTE = B.COD_CLIENTE
			-- WHERE A.LIMITE <> B.LIMITE
		END
	return
error:
    raiserror @errno @errmsg
    rollback transaction
end
GO


