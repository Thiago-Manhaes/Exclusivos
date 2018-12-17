

****EXPORTA VALES EMITIDOS***************************

TEXT TO XSEL NOSHOW TEXTMERGE

declare @data_ini datetime
declare @data_fim datetime
select @data_ini='20150701'
select @data_fim='20150816'


select a.codigo_filial,b.codigo_barra as numero_vale,b.preco_liquido as valor,a.data_venda
from loja_venda a 
join loja_venda_produto b 
on a.codigo_filial=b.codigo_filial 
and a.data_venda=b.data_venda 
and a.ticket=b.ticket 
join lojas_varejo c 
on a.codigo_filial=c.codigo_filial 
where 
b.produto='99.99.9999' 
and a.data_venda between @data_ini and @data_fim 
order by a.codigo_filial,b.codigo_barra 
 

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "M:\Administrativo e Financeiro\Vales Emitidos\Vales_Emitidos_01072015_a_16082015.XLS" XLS 