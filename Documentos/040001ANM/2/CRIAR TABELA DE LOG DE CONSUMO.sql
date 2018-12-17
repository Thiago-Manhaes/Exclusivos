

/****** Object:  Table [dbo].[PRODUTOS_FICHA_LOG]    Script Date: 23/08/2016 15:41:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ANM_LOG_CONSUMO_FT](
	[PRODUTO] [char](12) NOT NULL,
	[MATERIAL] [char](11) NOT NULL,
	[ITEM] [char](4) NOT NULL,
	[DATA_ALTERACAO] [datetime] NOT NULL,
	[RESPONSAVEL] [varchar](40) NOT NULL,
	[C1_NOVO] [numeric](9, 3) NULL,	[C1_ANTIGO] [numeric](9, 3) NULL,	
	[C2_NOVO] [numeric](9, 3) NULL,	[C2_ANTIGO] [numeric](9, 3) NULL,	
	[C3_NOVO] [numeric](9, 3) NULL,	[C3_ANTIGO] [numeric](9, 3) NULL,
	[C4_NOVO] [numeric](9, 3) NULL,	[C4_ANTIGO] [numeric](9, 3) NULL,	
	[C5_NOVO] [numeric](9, 3) NULL,	[C5_ANTIGO] [numeric](9, 3) NULL,	
	[C6_NOVO] [numeric](9, 3) NULL,	[C6_ANTIGO] [numeric](9, 3) NULL,
	[C7_NOVO] [numeric](9, 3) NULL, [C7_ANTIGO] [numeric](9, 3) NULL,
	[C8_NOVO] [numeric](9, 3) NULL,	[C8_ANTIGO] [numeric](9, 3) NULL,	
	[C9_NOVO] [numeric](9, 3) NULL,	[C9_ANTIGO] [numeric](9, 3) NULL,	
	[C10_NOVO] [numeric](9, 3) NULL,	[C10_ANTIGO] [numeric](9, 3) NULL,
	[C11_NOVO] [numeric](9, 3) NULL,	[C11_ANTIGO] [numeric](9, 3) NULL,	
	[C12_NOVO] [numeric](9, 3) NULL,	[C12_ANTIGO] [numeric](9, 3) NULL,	
	[C13_NOVO] [numeric](9, 3) NULL,	[C13_ANTIGO] [numeric](9, 3) NULL,
	[C14_NOVO] [numeric](9, 3) NULL,	[C14_ANTIGO] [numeric](9, 3) NULL,	
	[C15_NOVO] [numeric](9, 3) NULL,	[C15_ANTIGO] [numeric](9, 3) NULL,	
	[C16_NOVO] [numeric](9, 3) NULL,	[C16_ANTIGO] [numeric](9, 3) NULL,
	[C17_NOVO] [numeric](9, 3) NULL,	[C17_ANTIGO] [numeric](9, 3) NULL,	
	[C18_NOVO] [numeric](9, 3) NULL,	[C18_ANTIGO] [numeric](9, 3) NULL,	
	[C19_NOVO] [numeric](9, 3) NULL,	[C19_ANTIGO] [numeric](9, 3) NULL,
	[C20_NOVO] [numeric](9, 3) NULL,	[C20_ANTIGO] [numeric](9, 3) NULL,	
	[C21_NOVO] [numeric](9, 3) NULL,	[C21_ANTIGO] [numeric](9, 3) NULL,	
	[C22_NOVO] [numeric](9, 3) NULL,	[C22_ANTIGO] [numeric](9, 3) NULL,
	[C23_NOVO] [numeric](9, 3) NULL,	[C23_ANTIGO] [numeric](9, 3) NULL,	
	[C24_NOVO] [numeric](9, 3) NULL,	[C24_ANTIGO] [numeric](9, 3) NULL,
	[TRIGGER_ORIGEM] [VARCHAR] (2) NULL
 CONSTRAINT [XPKANM_LOG_CONSUMO_FT] PRIMARY KEY CLUSTERED 
(
	[PRODUTO] ASC,
	[MATERIAL] ASC,
	[ITEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


