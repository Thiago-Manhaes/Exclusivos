text to xsel noshow textmerge



select a.produto,
a.preco_liquido as preco_vendido_loja
,a.qtde as qtde_vendida_por_preco
,isnull(b.preco1,0) as preco_varejo
,isnull(c.preco1,0) as preco_varejo_original,
d.nf_entrada,d.recebimento,d.preco_unit_entrada  
,isnull(qtde_unit_entrada,0) as qtde_unit_entrada
,isnull(valor_entrada,0) as valor_entrada,
d.codigo_fiscal_operacao,d.natureza,d.filial
from 
	(select  b.produto,b.preco_liquido,sum(qtde) as qtde 
	from loja_venda a 
	join loja_venda_produto b 
	on  a.ticket=b.ticket 
	and a.codigo_filial=b.codigo_filial 
	and a.data_venda=b.data_venda 
	where a.codigo_filial='003' 
	and   a.data_venda between '20111001' and '20111031' 
	and   a.ticket not like 'p%'
	group by b.produto,b.preco_liquido) a
left join (select produto,preco1 from produtos_precos where codigo_tab_preco='V' ) b 
on a.produto=b.produto 
left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') c 
on a.produto=c.produto 
left join 
	(select 
	convert(varchar(12),b.codigo_item) as produto,b.nf_entrada,a.recebimento,
	convert(numeric(14,2) ,(valor_total/qtde_total) ) as preco_unit_entrada ,
	convert(numeric(14,2) ,(qtde_total) ) as qtde_unit_entrada ,
	convert(numeric(14,2) ,(valor_total) ) as valor_entrada ,
	b.codigo_fiscal_operacao,a.filial,
	a.natureza
	from entradas a 
	join entradas_item b 
	on  a.nf_entrada=b.nf_entrada 
	and a.nome_clifor=b.nome_clifor 
	and a.serie_nf_entrada=b.serie_nf_entrada 
	where a.nome_clifor='PLAZA' 
	--and   a.filial in ('RBX DISTRIBUIDORA','TRIMIX','GX NORTE DISTRIBUIDORA')
	and   a.natureza like '222%'
	and   a.recebimento between '20110201'  and '20111031'
	 ) d
on a.produto=d.produto
order by a.produto,d.nf_entrada,d.recebimento



endtext


f_select(xsel,"curteste")


sele curteste

copy to c:\temp\notas_Renato_plaza.xls xls


