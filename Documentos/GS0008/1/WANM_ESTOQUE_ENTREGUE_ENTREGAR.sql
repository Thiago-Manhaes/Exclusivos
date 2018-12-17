
/****** Object:  View [dbo].[WANM_ESTOQUE_ENTREGUE_ENTREGAR]    Script Date: 04/10/2016 10:17:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/* 
============================================================
=============== LUCAS MIRANDA ==============================
--- VIEW UTILIZADA PARA A TELA GS0008,
--- PEGA TODOS OS PEDIDOS QUE TEM PRA RECEBER / RECEBIDO
============================================================
*/


CREATE VIEW [dbo].[WANM_ESTOQUE_ENTREGUE_ENTREGAR] AS 

select PRODUTO, DESC_PRODUTO, COR_PRODUTO, TIPO_PRODUTO, COLECAO, DESC_COLECAO, TIPO_PROGRAMACAO, GRADE, REDE_LOJAS, DESC_REDE_LOJAS,
SUM(QTDE_ENTREGUE) AS QTDE_ENTREGUE,
SUM(EN_1) AS EN_1,
SUM(EN_2) AS EN_2,
SUM(EN_3) AS EN_3,
SUM(EN_4) AS EN_4,
SUM(EN_5) AS EN_5,
SUM(EN_6) AS EN_6,
SUM(EN_7) AS EN_7,
SUM(EN_8) AS EN_8,
SUM(EN_9) AS EN_9,
SUM(EN_10) AS EN_10,
SUM(QTDE_A_ENTREGAR) AS QTDE_A_ENTREGAR,
SUM(AEN_1) AS AEN_1,
SUM(AEN_2) AS AEN_2,
SUM(AEN_3) AS AEN_3,
SUM(AEN_4) AS AEN_4,
SUM(AEN_5) AS AEN_5,
SUM(AEN_6) AS AEN_6,
SUM(AEN_7) AS AEN_7,
SUM(AEN_8) AS AEN_8,
SUM(AEN_9) AS AEN_9,
SUM(AEN_10) AS AEN_10
from (
select B.PRODUTO, C.DESC_PRODUTO, B.COR_PRODUTO, C.TIPO_PRODUTO, C.COLECAO, D.DESC_COLECAO,
ISNULL(F.VALOR_PROPRIEDADE,'') AS TIPO_PROGRAMACAO, C.GRADE, C.REDE_LOJAS,lojas_rede.DESC_REDE_LOJAS,
SUM(ISNULL(E.QTDE,0)) AS QTDE_ENTREGUE,
SUM(ISNULL(E.EN_1,0)) AS EN_1,
SUM(ISNULL(E.EN_2,0)) AS EN_2,
SUM(ISNULL(E.EN_3,0)) AS EN_3,
SUM(ISNULL(E.EN_4,0)) AS EN_4,
SUM(ISNULL(E.EN_5,0)) AS EN_5,
SUM(ISNULL(E.EN_6,0)) AS EN_6,
SUM(ISNULL(E.EN_7,0)) AS EN_7,
SUM(ISNULL(E.EN_8,0)) AS EN_8,
SUM(ISNULL(E.EN_9,0)) AS EN_9,
SUM(ISNULL(E.EN_10,0)) AS EN_10,
SUM(B.QTDE_ENTREGAR) AS QTDE_A_ENTREGAR,
SUM(B.CE1) AS AEN_1,
SUM(B.CE2) AS AEN_2,
SUM(B.CE3) AS AEN_3,
SUM(B.CE4) AS AEN_4,
SUM(B.CE5) AS AEN_5,
SUM(B.CE6) AS AEN_6,
SUM(B.CE7) AS AEN_7,
SUM(B.CE8) AS AEN_8,
SUM(B.CE9) AS AEN_9,
SUM(B.CE10) AS AEN_10
from compras a 
join compras_produto b
on a.pedido = b.pedido
join produtos c
on b.produto = c.produto
join colecoes d
on c.colecao = d.colecao
join lojas_rede lojas_rede
on c.rede_lojas = lojas_rede.REDE_LOJAS
left join (select estoque_prod.pedido as pedido_compra, estoque_prod1.*  from estoque_prod_ent estoque_prod 
			join estoque_prod1_ent estoque_prod1 
			on estoque_prod.ROMANEIO_PRODUTO = estoque_prod1.ROMANEIO_PRODUTO
			and estoque_prod.FILIAL = estoque_prod1.FILIAL 
			where pedido is not null) e
on b.pedido = e.pedido_compra
and b.produto = e.produto
and b.cor_produto = e.cor_produto
left join (select programacao, valor_propriedade from PROP_PRODUCAO_PROGRAMA where propriedade = '00038') f
on a.PROGRAMACAO = f.PROGRAMACAO
where a.FORNECEDOR not in (select filial from filiais)
--and d.colecao in ('AV17','VER17')
--AND A.PEDIDO = '0108131'
GROUP BY B.PRODUTO, C.DESC_PRODUTO, B.COR_PRODUTO, C.TIPO_PRODUTO, C.COLECAO, D.DESC_COLECAO,
ISNULL(F.VALOR_PROPRIEDADE,''), C.GRADE, C.REDE_LOJAS,lojas_rede.DESC_REDE_LOJAS
union all
select B.PRODUTO, C.DESC_PRODUTO, B.COR_PRODUTO, C.TIPO_PRODUTO, C.COLECAO, D.DESC_COLECAO,
ISNULL(F.VALOR_PROPRIEDADE,'') AS TIPO_PROGRAMACAO, C.GRADE,  C.REDE_LOJAS,lojas_rede.DESC_REDE_LOJAS,
SUM(ISNULL(E.QTDE,0)) AS QTDE_ENTREGUE,
SUM(ISNULL(E.EN_1,0)) AS EN_1,
SUM(ISNULL(E.EN_2,0)) AS EN_2,
SUM(ISNULL(E.EN_3,0)) AS EN_3,
SUM(ISNULL(E.EN_4,0)) AS EN_4,
SUM(ISNULL(E.EN_5,0)) AS EN_5,
SUM(ISNULL(E.EN_6,0)) AS EN_6,
SUM(ISNULL(E.EN_7,0)) AS EN_7,
SUM(ISNULL(E.EN_8,0)) AS EN_8,
SUM(ISNULL(E.EN_9,0)) AS EN_9,
SUM(ISNULL(E.EN_10,0)) AS EN_10,
SUM(B.QTDE_P) AS QTDE_A_ENTREGAR,
SUM(B.P1) AS AEN_1,
SUM(B.P2) AS AEN_2,
SUM(B.P3) AS AEN_3,
SUM(B.P4) AS AEN_4,
SUM(B.P5) AS AEN_5,
SUM(B.P6) AS AEN_6,
SUM(B.P7) AS AEN_7,
SUM(B.P8) AS AEN_8,
SUM(B.P9) AS AEN_9,
SUM(B.P10) AS AEN_10
from producao_ordem a 
join producao_ordem_cor b
on a.ordem_producao = b.ordem_producao
join produtos c
on b.produto = c.produto
join colecoes d
on c.colecao = d.colecao
join lojas_rede lojas_rede
on c.rede_lojas = lojas_rede.REDE_LOJAS
left join (select estoque_prod1.ordem_producao as ordem_producao_est, estoque_prod1.*  from estoque_prod_ent estoque_prod 
			join estoque_prod1_ent estoque_prod1 
			on estoque_prod.ROMANEIO_PRODUTO = estoque_prod1.ROMANEIO_PRODUTO
			and estoque_prod.FILIAL = estoque_prod1.FILIAL 
			where estoque_prod1.ordem_producao is not null) e
on a.ordem_producao = e.ordem_producao_est
and b.produto = e.produto
and b.cor_produto = e.cor_produto
left join (select programacao, valor_propriedade from PROP_PRODUCAO_PROGRAMA where propriedade = '00038') f
on a.PROGRAMACAO = f.PROGRAMACAO
--where rede_lojas IN (2,5,7)
--and d.colecao in ('AV17','VER17')
--and a.obs not like '%OP cancelada e gerado pedido de compras numero:%'
--AND A.PEDIDO = '0108131'
GROUP BY B.PRODUTO, C.DESC_PRODUTO, B.COR_PRODUTO, C.TIPO_PRODUTO, C.COLECAO, D.DESC_COLECAO,
ISNULL(F.VALOR_PROPRIEDADE,''), C.GRADE, C.REDE_LOJAS,lojas_rede.DESC_REDE_LOJAS
) a
--where a.produto = '241095'
GROUP BY PRODUTO, DESC_PRODUTO, COR_PRODUTO, TIPO_PRODUTO, COLECAO, DESC_COLECAO, TIPO_PROGRAMACAO, GRADE, REDE_LOJAS, DESC_REDE_LOJAS
--order by a.PRODUTO, a.COR_PRODUTO,a.TIPO_PROGRAMACAO

GO


