

****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

declare @data_ini DATETIME
declare @data_fim DATETIME
declare @filial INT

select @filial = '041'
select @data_ini='20110701'
select @data_fim='20110722'

select troca.data_venda as data,lojas.filial,reducao_z.reducao_z,
troca.total_troca,(reducao_z.reducao_z-troca.total_troca) as total_liquido 
from
(select data_fiscal,codigo_filial, 
sum(total_bruto-(total_cancelado+total_desconto))  as reducao_z
from loja_controle_fiscal 
where data_fiscal between @data_ini and @data_fim 
and codigo_filial =  @filial
group by data_fiscal,codigo_filial) reducao_z

left join
(select data_venda,codigo_filial, isnull(sum(valor_troca),0) as total_troca
from loja_venda 
where  codigo_filial = @filial
and data_venda between @data_ini and @data_fim  
and ticket not like '%p%'
and ticket not like '%v%'
group by data_venda,codigo_filial ) troca
on reducao_z.codigo_filial=troca.codigo_filial
and reducao_z.data_fiscal = troca.data_venda

join
(select a.codigo_filial,a.filial 
from lojas_varejo a 
where a.codigo_filial in (@filial) ) lojas
on troca.codigo_filial = lojas.codigo_filial

order by reducao_z.data_fiscal


ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "C:\TEMP\REDUCAO_Z_POR_DATA" XLS