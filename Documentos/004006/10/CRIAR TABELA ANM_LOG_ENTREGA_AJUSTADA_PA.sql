
/****** Object:  Table [dbo].[MIT_LOG_ENTREGA_AJUSTADA]    Script Date: 28/10/2016 10:07:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ANM_LOG_ENTREGA_AJUSTADA_PA](
	[TIPO_TRANSACAO] [varchar](1) NOT NULL,
	[PEDIDO] [char](8) NOT NULL,
	[PRODUTO] [char](12) NOT NULL,
	[COR_PRODUTO] [char](10) NOT NULL,
	[LIMITE_ENTREGA_NOVO] [varchar](70) NULL,
	[LIMITE_ENTREGA_ANTERIOR] [varchar](70) NULL,
	[DATA_CONFIRMACAO_NOVO] [varchar](70) NULL,
	[DATA_CONFIRMACAO_ANTERIOR] [varchar](70) NULL,
	[DATA_TRANSACAO] [datetime] NOT NULL,
	[USUARIO] [nvarchar](128) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


