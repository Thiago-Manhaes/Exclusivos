

****EXPORTA SMS ABRAND****************************


TEXT TO XSEL NOSHOW TEXTMERGE
 
declare @data_ini datetime
declare @data_fim datetime
select @data_ini='20120101'
select @data_fim='20120630'

select case when a.filial = 'ESTOQUE CENTRAL' then 'RBX DISTRIBUIDORA' else a.filial end as filial,
a.nome_clifor,b.uf,'6152' as CFOP,a.nf_saida,emissao,sum(valor_imposto) as imposto,valor_total 
from faturamento a
join faturamento_imposto c
on a.nf_saida = c.nf_saida
and a.serie_nf = c.serie_nf
and a.filial = c.filial
join cadastro_cli_for b
on a.nome_clifor = b.nome_clifor
join filiais d
on a.nome_clifor = d.filial
where b.uf in ('MG','SP')
and a.natureza_saida in ('120.01','121.01')
and emissao between @data_ini and @data_fim
and valor_total > 0 and a.filial in ('RBX DISTRIBUIDORA','ESTOQUE CENTRAL','TRIMIX')
group by a.filial,a.nome_clifor,b.uf,a.nf_saida,emissao,valor_total
order by filial,emissao,nf_saida


ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")
SELE CUR_EXPORTA

COPY TO "C:\FATURAMENTO_6152_ANIMALE_2012.XLS" XLS 
