text to xsel noshow textmerge 

select a.codigo_filial,a.filial,month(a.emissao) as mes_emissao , 
count(a.nf_numero) as qtde_notas,sum(a.valor_nota) as valor_tot_nota_problema,sum(a.val_icms) as valor_tot_icms_problema ,
sum(case 
		when month(getdate()) = month(a.emissao) and a.status_nfe in (1,2,3) 
		then a.valor_nota 
		else 0 
	end ) as valor_nota_recuperavel	,
sum(case 
		when month(getdate()) = month(a.emissao) and a.status_nfe in (1,2,3) 
		then a.val_icms  
		else 0 
	end ) as val_icms_recuperavel	

from (

select a.codigo_filial,b.filial,a.nf_numero,a.emissao, 
case when a.valor_total=0 then a.valor_cancelado else a.valor_total end as valor_nota ,
convert(numeric(14,2),
(case when a.valor_total=0 then a.valor_cancelado else a.valor_total end * e.aliq_icms)/100  ) as val_icms,
d.uf,e.aliq_icms ,
a.status_nfe
from loja_nota_fiscal a 
join lojas_varejo b 
on a.codigo_filial=b.codigo_filial 
join loja_venda_pgto c
on  a.nf_numero=c.numero_fiscal_troca 
and a.serie_nf=c.serie_nf_entrada
and a.codigo_filial=c.codigo_filial 
join cadastro_cli_for d 
on b.filial=d.nome_clifor     
join 
	(select uf,case when icms_saida=0 then icms_entrada else icms_saida end as aliq_icms 
	from unidades_federacao_icms
	where uf=uf_destino) e 
on d.uf=e.uf 
where a.emissao between '20120101' and '20120731' 
and a.recebimento=1 
and a.status_nfe not in (5,0,42,49) 

) a
group by a.codigo_filial,a.filial,month(a.emissao) 
order by a.codigo_filial,month(a.emissao) 

endtext 

f_select(xsel,"curNotas")

sele curNotas 
copy to c:\temp\valor_notas_problema_animale.xls xls