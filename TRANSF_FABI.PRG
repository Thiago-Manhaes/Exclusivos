

****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

declare @data_ini datetime
declare @data_fim datetime
select @data_ini='20100601'
select @data_fim='20100722'

select A.EMISSAO,b.FILIAL AS SAIDA,a.FILIAL_DESTINO AS ENTRADA,B.PRODUTO,C.DESC_PRODUTO,B.COR_PRODUTO,D.DESC_COR_PRODUTO,C.LINHA,
C.GRUPO_PRODUTO AS GRUPO,C.COLECAO,C.GRADE,B.QTDE_SAIDA,
B.EN1 AS 'T1',B.EN2 AS 'T2',B.EN3 AS 'T3',B.EN4 AS 'T4',B.EN5 AS 'T5',B.EN6 AS 'T6',B.EN7 AS 'T7'

from loja_saidas a
join
loja_saidas_produto b
on a.romaneio_produto = b.romaneio_produto
join
produtos c
on b.produto = c.produto
join
produto_cores d
on b.produto = d.produto
where b.filial = 'estoque central'
and a.filial_destino='atacado'
and c.griffe='lu werneck'
and a.emissao between @data_ini and @data_fim
ORDER BY A.EMISSAO 

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "P:\fabiana santos\TRANSF_FABI_LINHA_LU.XLS" XLS 