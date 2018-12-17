

****EXPORTA VENDAS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE


declare @data_ini datetime
declare @data_fim datetime

select @data_ini='20080401'
select @data_fim='20101031'



select vendas_full.*,
convert(numeric(14,2),isnull(vendas_abrand.valor_venda_produto,0)) as vendas_abrand ,
convert(numeric(14,2),isnull(trocas_abrand.valor_troca_produto,0)) as trocas_abrand ,
convert(numeric(14,2),isnull(vendas_abrand.valor_venda_produto,0)-isnull(trocas_abrand.valor_troca_produto,0)) as valor_liq_abrand,
convert(numeric(14,2),((isnull(vendas_abrand.valor_venda_produto,0)-isnull(trocas_abrand.valor_troca_produto,0))/vendas_full.valor_venda_loja)*100) as perc_venda
from 
	(select a.codigo_filial,b.filial,month(data_venda) as mes,year(data_venda) as ano,
	convert(numeric(14,2),sum(valor_ticket_sem_vale)) as valor_venda_loja 
	from WANM_VENDAS_LOJA_FULL a 
	join lojas_varejo b
	on a.codigo_filial=b.codigo_filial
	where data_venda between @data_ini and @data_fim
	and   a.codigo_filial in ('007','016','014','013' ,'031')       
	group by a.codigo_filial,b.filial,month(data_venda) ,year(data_venda) ) vendas_full  
left join 
	(select a.codigo_filial,month(data_venda) as mes,year(data_venda) as ano,
	(SUM((A.Qtde * A.Preco_Liquido) - (A.Qtde * A.Preco_Liquido * A.Fator_Desconto_Venda))) valor_venda_produto
	from loja_venda_produto a 
	join produtos b 
	on a.produto=b.produto 
	where a.data_venda between @data_ini and @data_fim 
	and b.linha='A. BRAND' 
	and   a.codigo_filial in ('007','016','014','013' ,'031')   
	group by a.codigo_filial,month(data_venda) ,year(data_venda)) vendas_abrand 
	on  vendas_full.codigo_filial=vendas_abrand.codigo_filial
	and vendas_full.mes=vendas_abrand.mes
	and vendas_full.ano=vendas_abrand.ano
left join 
	(select a.codigo_filial,month(data_venda) as mes,year(data_venda) as ano,
	(SUM((A.Qtde * A.Preco_Liquido) - (A.Qtde * A.Preco_Liquido * A.Fator_Desconto_Venda))) valor_troca_produto
	from loja_venda_troca a 
	join produtos b 
	on a.produto=b.produto 
	where a.data_venda between @data_ini and @data_fim
	and b.linha='A. BRAND'
	and   a.codigo_filial in ('007','016','014','013' ,'031')   
	group by a.codigo_filial,month(data_venda) ,year(data_venda)) trocas_abrand 
	on  vendas_full.codigo_filial=trocas_abrand.codigo_filial
	and vendas_full.mes=trocas_abrand.mes
	and vendas_full.ano=trocas_abrand.ano 
order by vendas_full.codigo_filial,vendas_full.ano,vendas_full.mes

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\VENDAS_ABRAND.XLS XLS 