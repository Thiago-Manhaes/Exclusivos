	--- CRIACAO TABELA

	-- TABELA CRIADA
		--/****** Object:  Table [dbo].[ANM_PARAMETROS_LOJA_LOG]    Script Date: 13/05/2016 10:04:01 ******/
		--SET ANSI_NULLS ON
		--GO

		--SET QUOTED_IDENTIFIER ON
		--GO

		--SET ANSI_PADDING ON
		--GO

		--CREATE TABLE [dbo].[ANM_FILIAIS_PERMIT_EST_NEGATIVO_LOG](
		--	[SEQUENCIAL] [bigint] IDENTITY(1,1) NOT NULL,			
		--	[COD_FILIAL] [char](6) NOT NULL,
		--	[FILIAL] [varchar](25) NOT NULL,
		--	[PERMITE_EST_NEGATIVO] [char](5) NULL,
		--	[PERMITE_EST_NEGATIVO_ANTERIOR] [char](5) NULL,
		--	[DATA_ALTERACAO] [datetime] NOT NULL,
		--	[USUARIO] [varchar](50) NOT NULL,
		--	[HOST] [varchar](50) NOT NULL,
		--	[TRIGGER_ORIGEM] [char](1) NULL,
		-- CONSTRAINT [XPKANM_FILIAIS_PERMIT_EST_NEGATIVO_LOG] PRIMARY KEY NONCLUSTERED 
		--(
		--	[SEQUENCIAL] ASC
		--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
		--) ON [PRIMARY]

		--GO

		--SET ANSI_PADDING OFF
		--GO



	
	--- TRIGGER INSERT
	-- #1 - LUCAS.MIRANDA - 13/05/2016 - LOG DE PERMITE ESTOQUE NEGATIVO PARA ESTA FILIAL
	USE [SOMA]
GO
/****** Object:  Trigger [dbo].[LXI_ANM_FILIAIS]    Script Date: 13/05/2016 15:49:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER trigger [dbo].[LXI_ANM_FILIAIS] 
on [dbo].[FILIAIS]
  for INSERT NOT FOR REPLICATION
  as

			begin
			  declare  @errno   int,
					   @errmsg  varchar(255)

				/*============================================================================================
				LUCAS MIRANDA- 26/05/2014 - BLOQUEIO SALVAR SEM INFORMAR REDE LOJAS
				============================================================================================*/

				--NÃO PERMITIR SALVAR FILIAL SEM DEFINIÇÃO DE REDE LOJAS
				if ( select count(*) from inserted where REDE_LOJAS is null ) > 0
				begin
				  select @errno  = 30002,
						 @errmsg = 'Impossível Incluir Filiais Sem Informar Rede Lojas'
				  goto error
				end


				-- #1 - LUCAS.MIRANDA - 13/05/2016 - LOG DE PERMITE ESTOQUE NEGATIVO PARA ESTA FILIAL
				IF APP_NAME() = 'VISUAL LINX'

					Begin
		
						INSERT INTO ANM_FILIAIS_PERMIT_EST_NEGATIVO_LOG(COD_FILIAL,FILIAL,PERMITE_EST_NEGATIVO,PERMITE_EST_NEGATIVO_ANTERIOR,DATA_ALTERACAO,USUARIO,HOST,TRIGGER_ORIGEM)
						SELECT COD_FILIAL,FILIAL,case when INS.PERMITE_EST_NEGATIVO = 1 then 'SIM' ELSE 'NAO' END,ISNULL(NULL,''),GETDATE(),SYSTEM_USER,HOST_NAME(),'I'
						FROM inserted

					end

			  return
			error:
				raiserror @errno @errmsg
				rollback transaction
			end


	-- trigger update
	-- #1 - LUCAS.MIRANDA - 13/05/2016 - LOG DE PERMITE ESTOQUE NEGATIVO PARA ESTA FILIAL
	USE [SOMA]
GO
/****** Object:  Trigger [dbo].[LXU_ANM_FILIAIS]    Script Date: 13/05/2016 15:50:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER Trigger [dbo].[LXU_ANM_FILIAIS] 
On [dbo].[FILIAIS]  
For UPDATE NOT FOR REPLICATION  
As   
-- UPDATE Trigger On FILIAIS  
Begin  
 Declare @numrows Int,  
  @nullcnt Int,  
  @validcnt Int,  
  @insFILIAL varchar(25)  ,   
  @insCLIFOR char(6)  ,   
  @insCOD_FILIAL char(6) ,  
  @delFILIAL varchar(25)  ,   
  @delCLIFOR char(6)  ,   
  @delCOD_FILIAL char(6) ,  
  @errno   Int,  
  @errmsg  varchar(255)  
  
 Select @numrows = @@rowcount  
  
-- PERMITE_EST_NEGATIVO - Child Update Restrict  
 --IF UPDATE(PERMITE_EST_NEGATIVO)  
 --Begin  
 -- SELECT @NullCnt = 0  
 -- SELECT @ValidCnt = count(*)  
 -- FROM Inserted, EMPRESA  
 -- WHERE INSERTED.EMPRESA = 4  
  
 -- If @validcnt + @nullcnt != @numrows  
 -- Begin  
 --  Select @errno  = 30002,  
 --   @errmsg = 'FALE COM O SIDNEI !!! NÃO É PARA ALTERAR PERMISSÃO DE ESTOQUE !!!!!! CHEGA DE MERDA!!!!'  
 --  GoTo Error  
 -- End  
 --End  
  
	/*============================================================================================
	LUCAS MIRANDA- 26/05/2014 - BLOQUEIO SALVAR SEM INFORMAR REDE LOJAS
	============================================================================================*/

	--NÃO PERMITIR SALVAR FILIAL SEM DEFINIÇÃO DE REDE LOJAS
    if ( select count(*) from inserted where REDE_LOJAS is null ) > 0
    begin
      select @errno  = 30002,
             @errmsg = 'Impossível Incluir Filiais Sem Informar Rede Lojas'
      goto error
    end
	
	
	IF APP_NAME() = 'VISUAL LINX'


		Begin
			INSERT INTO ANM_FILIAIS_PERMIT_EST_NEGATIVO_LOG(COD_FILIAL,FILIAL,PERMITE_EST_NEGATIVO,PERMITE_EST_NEGATIVO_ANTERIOR,DATA_ALTERACAO,USUARIO,HOST,TRIGGER_ORIGEM)
			SELECT INS.COD_FILIAL,INS.FILIAL,case when INS.PERMITE_EST_NEGATIVO = 1 then 'SIM' ELSE 'NAO' END,case when DEL.PERMITE_EST_NEGATIVO = 1 then 'SIM' ELSE 'NAO' END,GETDATE(),SYSTEM_USER,HOST_NAME(),'U'
			FROM INSERTED INS, DELETED DEL
			WHERE INS.FILIAL = DEL.FILIAL
			AND INS.COD_FILIAL = DEL.COD_FILIAL
			AND INS.PERMITE_EST_NEGATIVO <> DEL.PERMITE_EST_NEGATIVO
		End

  return
error:
    raiserror @errno @errmsg
    rollback transaction
end

