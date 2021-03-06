USE [TESTE_SOMA]
GO
/****** Object:  Trigger [dbo].[LXU_ANM_PROP_MATERIAIS]    Script Date: 29/03/2016 18:01:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER Trigger [dbo].[LXU_ANM_PROP_MATERIAIS] 
On [dbo].[PROP_MATERIAIS]
For UPDATE NOT FOR REPLICATION
As 

Begin
	
	Declare	@numrows	Int,
		@nullcnt	Int,
		@validcnt	Int,
		@insTIPO varchar(25) , 
		@errno   Int,
		@errmsg  varchar(255)
	--#2 -- ANM.LUCAS MIRANDA --29/03/2016 - CTRL_PARTIDAS SENDO DESMARCADA AO SALVAR     
		--Update b Set CTRL_PARTIDAS = 0,CTRL_PECAS = 0,CTRL_PECAS_PARCIAL = 0
		--from inserted a
		--	join MATERIAIS b
		--	on a.MATERIAL = b.MATERIAL
		--where a.PROPRIEDADE = '01004' and 
		--	  a.VALOR_PROPRIEDADE in ('2','5')	 
	--FIM #2 -- ANM.LUCAS MIRANDA --29/03/2016 - CTRL_PARTIDAS SENDO DESMARCADA AO SALVAR


	return
Error:
	raiserror @errno @errmsg
	rollback transaction
End

