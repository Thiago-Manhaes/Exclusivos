USE [TESTE_SOMA]
GO

/****** Object:  View [dbo].[WANM_ESTOQUE_MAT_DISP_PEDIDO_PILOT]    Script Date: 08/09/2016 09:25:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- VIEW UTILIZADA PARA A TELA GS0005 - LUCAS MIRANDA 08/09/2016

CREATE VIEW [dbo].[WANM_ESTOQUE_MAT_DISP_PEDIDO_PILOT] AS 

SELECT CASE WHEN FILIAL_DIGITACAO='SOMA FABRICA FARM SC' THEN 'FABRICA SOMA FARM' ELSE FILIAL_DIGITACAO END AS FILIAL, A.PEDIDO, MATERIAL,COR_MATERIAL,SUM(QTDE_ENTREGAR) QTDE_ENTREGAR   
FROM VENDAS  (NOLOCK) A JOIN VENDAS_MATERIAL  (NOLOCK) B   
ON A.PEDIDO = B.PEDIDO WHERE A.STATUS = 'A' AND B.QTDE_ENTREGAR > 0   
GROUP BY CASE WHEN FILIAL_DIGITACAO='SOMA FABRICA FARM SC' THEN 'FABRICA SOMA FARM' ELSE FILIAL_DIGITACAO END , A.PEDIDO, MATERIAL,COR_MATERIAL		 
	




















GO


