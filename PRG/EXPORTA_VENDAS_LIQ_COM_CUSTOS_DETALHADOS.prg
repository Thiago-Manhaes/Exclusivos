	

text to xsel noshow textmerge 
		
	declare @data_ini datetime 
	declare @data_fim datetime 

	select @data_ini='20080101' 
	select @data_fim='20081231' 

	select vendas_liq.*,
	custos.preco_aquisicao as custo_faccao,custos.preco_custo as custo_total, 
	case 
		when custos.preco_custo-custos.preco_aquisicao<0 
			 then 0 
			 else custos.preco_custo-custos.preco_aquisicao 
		end as custo_materiais ,
	vendas_liq.qtde_liq*custos.preco_aquisicao as valor_custo_faccao,	
	(vendas_liq.qtde_liq*
	case 
		when custos.preco_custo-custos.preco_aquisicao<0 
			 then 0 
			 else custos.preco_custo-custos.preco_aquisicao 
		end) as valor_custo_materiais,
	vendas_liq.qtde_liq*custos.preco_custo as valor_custo_total		
	from
		
		(select vendas.produto,vendas.qtde_vendida,isnull(trocas.qtde_trocada,0) as qtde_trocada,
		vendas.qtde_vendida-isnull(trocas.qtde_trocada,0) as qtde_liq 
		from 	
		(select b.produto,sum(b.qtde) as qtde_vendida 
		from loja_venda a 
		join loja_venda_produto b 
		on a.codigo_filial=b.codigo_filial 
		and a.data_venda=b.data_venda 
		and a.ticket=b.ticket 
		where a.data_venda between @data_ini and @data_fim
		and a.codigo_filial not in ('985','991','988','989')
		group by b.produto) vendas
		left join 
		(select b.produto,sum(b.qtde) as qtde_trocada
		from loja_venda a 
		join loja_venda_troca b 
		on a.codigo_filial=b.codigo_filial 
		and a.data_venda=b.data_venda 
		and a.ticket=b.ticket 
		where a.data_venda between @data_ini and @data_fim
		and a.codigo_filial not in ('985','991','988','989')
		group by b.produto) trocas 
		on vendas.produto=trocas.produto
		
		union all
		
		select trocas.produto,0 as qtde_vendida,trocas.qtde_trocada ,
		0-trocas.qtde_trocada as qtde_liq 
		from 
		(select b.produto,sum(b.qtde) as qtde_trocada
		from loja_venda a 
		join loja_venda_troca b 
		on a.codigo_filial=b.codigo_filial 
		and a.data_venda=b.data_venda 
		and a.ticket=b.ticket 
		where a.data_venda between @data_ini and @data_fim
		and a.codigo_filial not in ('985','991','988','989')
		group by b.produto) trocas 
		left join 
		(select b.produto,sum(b.qtde) as qtde_vendida 
		from loja_venda a 
		join loja_venda_produto b 
		on a.codigo_filial=b.codigo_filial 
		and a.data_venda=b.data_venda 
		and a.ticket=b.ticket 
		where a.data_venda between @data_ini and @data_fim
		and a.codigo_filial not in ('985','991','988','989')
		group by b.produto) vendas 
		on vendas.produto=trocas.produto 
		where vendas.produto is null) vendas_liq
		
		join 
		
		(select a.produto,a.colecao,
		isnull(b.preco1,0) as preco_aquisicao,
		isnull(c.preco1,0) as preco_custo 
		from produtos a 
		left join 
			(select produto,preco1 from produtos_precos where codigo_tab_preco='ca') as b 
			on a.produto=b.produto
		left join 
			(select produto,preco1 from produtos_precos where codigo_tab_preco='ct') as c 
			on a.produto=c.produto) custos 
		
		on vendas_liq.produto=custos.produto	
		where vendas_liq.produto<>'99.99.9999' 

endtext 		

f_select(xsel,"curVendas")

sele curVendas
copy to c:\temp\expVendas.xls xls