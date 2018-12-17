

****EXPORTA NCM DO PEDIDO***************************

TEXT TO XSEL NOSHOW TEXTMERGE

declare @pedido char(10)
select @pedido=032899


select distinct a.produto as PRODUTO, a.pedido as PEDIDO, c.classif_fiscal as NCM, c.desc_classificacao as DESC_NCM
from vendas_produto a
join produtos b  
on a.produto = b.produto
join CLASSIF_FISCAL c
on b.classif_fiscal = c.classif_fiscal
join vendas d
on a.pedido = d.pedido
where a.pedido = @pedido
order by a.produto
 

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "C:\Temp\NCM_032899.XLS" XLS 