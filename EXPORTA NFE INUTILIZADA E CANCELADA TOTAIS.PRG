

****EXPORTA NFE INUTILIZADA E CANCELADA TOTAIS****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select a.codigo_filial,a.filial,isnull(inutilizada.inutilizada,0) as inutilizada,
isnull(inutilizada.valor_total_inu,0) as valor_total_inu,
isnull(cancelada.cancelada,0) as cancelada,isnull(cancelada.valor_total_canc,0) as valor_total_canc 
from lojas_varejo a 

left join
(select a.codigo_filial,b.filial,count(nf_numero) as inutilizada, sum(valor_cancelado) as valor_total_inu 
from loja_nota_fiscal a
join lojas_varejo b
on a.codigo_filial = b.codigo_filial
where status_nfe = '59'
and serie_nf = '5'
and emissao between '20120101' and '20120131'
group by a.codigo_filial,b.filial) inutilizada
on a.codigo_filial = inutilizada.codigo_filial

left join
(select a.codigo_filial,b.filial,count(nf_numero) as cancelada, sum(valor_cancelado) as valor_total_canc 
from loja_nota_fiscal a
join lojas_varejo b
on a.codigo_filial = b.codigo_filial
where status_nfe = '49'
and serie_nf = '5'
and emissao between '20120101' and '20120131'
group by a.codigo_filial,b.filial) cancelada
on a.codigo_filial = cancelada.codigo_filial

where a.codigo_filial > 001 and a.codigo_filial < 100 and  a.codigo_filial <> 017
order by a.codigo_filial



ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\NFE_INU_CANC.XLS XLS 