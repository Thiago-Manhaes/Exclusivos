text to xsel noshow textmerge 

 
select b.codigo_filial, b.filial,month(a.emissao) as mes_nota,
sum (valor_cancelado)  as valor_cancelado,
convert(numeric(14,2),
sum((a.valor_cancelado * d.aliq_icms)/100 ) ) as val_icms,
d.uf,d.aliq_icms 
from loja_nota_fiscal a 
join lojas_varejo b 
on  a.codigo_filial = b.codigo_filial 
join cadastro_cli_for c 
on b.filial=c.nome_clifor     
join 
	(select uf,case when icms_saida=0 then icms_entrada else icms_saida end as aliq_icms 
	from unidades_federacao_icms
	where uf=uf_destino) d 
on c.uf=d.uf 
where a.emissao between '20120101' and '20120630'
and a.natureza_operacao_codigo in ('1202','1202.1','1202.2','1202.3','2202', '2202.02')
and a.valor_total = '0.00'
and a.status_nfe in (52,56,59) 
group by  b.codigo_filial, b.filial , month(a.emissao),d.uf,d.aliq_icms 

endtext


f_select(xsel,"curTeste")

sele curTeste 
copy to  c:\temp\Notas_Animale_Inutilizadas.xls xls
