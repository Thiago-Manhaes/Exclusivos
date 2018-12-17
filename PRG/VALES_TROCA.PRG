

****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE



declare @data_ini datetime
declare @data_fim datetime
select @data_ini='20100601'
select @data_fim='20100630'


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
and a.valor_troca > '0.00' 
order by a.codigo_filial,b.codigo_barra 
  

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "C:\TEMP\Vales_Vendidos_junho.XLS" XLS 