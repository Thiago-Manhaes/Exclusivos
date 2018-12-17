text to xsel noshow textmerge 

select a.* from 
	(select b.vendedor,b.nome_vendedor,sum(valor_ticket_sem_vale) as valor_venda_julho2012 
	from WANM_VENDAS_LOJA_FULL a 
	join loja_vendedores b 
	on a.vendedor=b.vendedor 
	where data_venda between '20120701' and '20120731'
	group by b.vendedor,b.nome_vendedor) a 
where a.valor_venda_julho2012 > 0	


endtext 


f_select(xsel,"curteste")

sele curteste 
copy to c:\temp\VendasVA.xls xls 