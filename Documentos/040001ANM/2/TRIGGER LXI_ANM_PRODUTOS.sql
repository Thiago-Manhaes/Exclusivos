
/****** Object:  Trigger [dbo].[LXI_ANM_PRODUTOS]    Script Date: 13/08/2016 09:32:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER trigger [dbo].[LXI_ANM_PRODUTOS] 
on [dbo].[PRODUTOS]
  for INSERT NOT FOR REPLICATION
  as

begin
  declare  @errno   int,
           @errmsg  varchar(255)

 -- Proibido salvar Produto sem informar o Produto Solução -- Lucas Miranda - 15/04/2014
    if ( select COUNT(*) from inserted where Rede_Lojas = '2' and Cod_Produto_Solucao is null ) > 0
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Incluir Produto Sem PRODUTO SOLUÇÃO'
      goto error
    end

----o produto não pode estar marcado como revenda
--	If ( Select count(*) from inserted where REVENDA=1 ) > 0
--			begin
--			  select @errno  = 30002,
--					 @errmsg = 'CheckBox Revenda esta marcado, Favor desmarcar !!!!'
--			  goto error
--		end
	

--garantir que todos os produtos estão com dados em Rede_lojas
	if ( select count(*) from inserted where REDE_LOJAS is null ) > 0
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Incluir Produto Sem REDE DE LOJAS'+CHAR(13)+CHAR(13)+
                       '1  : ANIMALE'+CHAR(13)+
                       '2  : FARM'+CHAR(13)+
                       '3  : ABRAND'+CHAR(13)+
                       '4  : F.Y.I'+CHAR(13)+
                       '5  : FABULA'
      goto error
    end
	
	
	/*============================================================================================
	LUCAS MIRANDA - 15/08/2016 - SALVAR TABELA DE PRODUTOS PARA BLOQUEIO DE FICHA TECNICA 
	============================================================================================*/
		INSERT INTO ANM_TB_BLOQ_FICHA_TECNICA_PA
		(PRODUTO, DATA_FINALIZACAO)
			SELECT A.PRODUTO, NULL 
			FROM INSERTED A
			LEFT JOIN ANM_TB_BLOQ_FICHA_TECNICA_PA B
			ON A.PRODUTO = B.PRODUTO
			WHERE B.PRODUTO IS NULL

	/*============================================================================================
	ISMARA- 09/04/2014 - SALVAR TABELA DE LOG PARA COLEÇOES 
	============================================================================================*/
	insert into ANM_PRODUTOS_COLECAO_LOG
		(COLECAO, PRODUTO, DATA_INICIAL, DATA_FIM, RESPONSAVEL)
	
	SELECT COLECAO, PRODUTO, GETDATE(), NULL, SYSTEM_USER FROM INSERTED	

	--NÃO PERMITIR SALVAR PRODUTOS SEM DEFINIÇÃO DE ITEM SPED
    if ( select count(*) from inserted where tipo_item_sped is null ) > 0
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Incluir Produto Sem Item Sped'+CHAR(13)+CHAR(13)+
                       'Para produto COMPRADO  : MERCADORIA PARA REVENDA'+CHAR(13)+
                       'Para produto FACCIONADO: PRODUTO ACABADO'
      goto error
    end


	/* ISMARA - 14/02/2014 - SALVAR NA PROPRIEDADE A COLECAO DE CRIACAO QUNDO NA PRIMEIRA INCLUSÃO DO PRODUTO */
		DECLARE @PROP VARCHAR(5)
		SELECT @PROP=NULL
		SELECT @PROP=PROPRIEDADE FROM PROPRIEDADE WHERE DESC_PROPRIEDADE LIKE '%COLE%CRIA%'
		
		IF @PROP IS NOT NULL
		BEGIN
			INSERT INTO PROP_PRODUTOS
			SELECT @PROP,1,COLECAO,GETDATE(),PRODUTO
			FROM inserted
		END
	/**/


	--/* ISMARA - 14/02/2014 - SALVAR NA PROPRIEDADE A COLECAO DE CRIACAO QUNDO NA PRIMEIRA INCLUSÃO DO PRODUTO */
	--	DECLARE @PROP VARCHAR(5)
	--	SELECT @PROP=NULL
	--	SELECT @PROP=PROPRIEDADE FROM PROPRIEDADE WHERE DESC_PROPRIEDADE LIKE '%COLE%CRIA%'
		
	--	IF @PROP IS NOT NULL
	--	BEGIN
	--		INSERT INTO PROP_PRODUTOS
	--		SELECT @PROP,PRODUTO,1,COLECAO,GETDATE()
	--		FROM inserted
	--	END
	--/**/

	/*============================================================================================
	LUCAS MIRANDA- 11/07/2014 - SALVAR TABELA DE LOG PARA CONTABILIDADE 
	============================================================================================*/	
	--INSERT INTO ANM_PRODUTOS_CONTABIL_LOG(PRODUTO, DESC_PRODUTO, DATA_CADASTRAMENTO,TIPO_PRODUTO, GRUPO_PRODUTO, CLASSIF_FISCAL, CONTA_CONTABIL, 
	--				CONTA_CONTABIL_COMPRA, CONTA_CONTABIL_VENDA, CONTA_CONTABIL_DEV_COMPRA, CONTA_CONTABIL_DEV_VENDA,DATA_ALTERACAO, RESPONSAVEL, TRIGGER_ORIGEM)
	--SELECT PRODUTO, DESC_PRODUTO, DATA_CADASTRAMENTO,TIPO_PRODUTO, GRUPO_PRODUTO, CLASSIF_FISCAL, CONTA_CONTABIL, 
	--				CONTA_CONTABIL_COMPRA, CONTA_CONTABIL_VENDA, CONTA_CONTABIL_DEV_COMPRA, CONTA_CONTABIL_DEV_VENDA,
	--				GETDATE(),upper(host_name())+'-'+upper(SYSTEM_USER),'I'
	--FROM inserted
	
	---- Insere no Custo operações extras o custo do produto utilizado na OP de transformação
	--Declare @ProdTran char(12) = (Select PRODUTO from inserted)
	--Exec LX_ANM_GERA_CUSTO_OP_TRANSFORMACAO @ProdTran
	---- fim -- Julio #Animale - 02-06-2015
			
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end


