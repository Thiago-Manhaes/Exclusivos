


text to xsel noshow textmerge 

--select db_name()

	declare @dataini datetime 
	declare @datafim datetime 

	select @dataini='20120601'
	select @datafim='20120630'


	select a.codigo_filial,a.filial,a.total_venda_produto ,
	isnull(b.venda_abaixo_transf,0) as venda_abaixo_transf ,
	isnull(b.preco_transf,0) as preco_transf ,
	isnull(b.dif_transf_venda,0) as dif_transf_venda ,
	c.aliq_icms as aliq_icms,
	case 
		when c.aliq_icms=0 
		then 999999999999
		else convert(numeric(14,2),(isnull(b.dif_transf_venda,0)*isnull(c.aliq_icms,0))/100) 
	end as valor_estorno_icms 
	from 

		(select a.codigo_filial,d.filial,sum(a.qtde*preco_liquido) as total_venda_produto  
		from loja_venda_produto a 
		join loja_venda b 
		on  a.codigo_filial=b.codigo_filial
		and a.data_venda=b.data_venda 
		and a.ticket=b.ticket 
		join loja_venda_pgto c 
		on  b.codigo_filial=c.codigo_filial 
		and b.terminal=c.terminal 
		and b.lancamento_caixa=c.lancamento_caixa 
		join lojas_varejo d 
		on a.codigo_filial=d.codigo_filial 
		where c.numero_cupom_fiscal is not null 
		and a.data_venda between @dataini and @datafim
		group by a.codigo_filial,d.filial) a 
		
	left join 
			
		(select a.codigo_filial,sum(a.qtde*a.preco_liquido) as venda_abaixo_transf ,
		sum(a.qtde*a.preco_transf) as preco_transf ,
		sum(a.qtde*(a.preco_transf-a.preco_liquido)) as dif_transf_venda 
		from 	
		(select e.preco_vo,e.preco_transf,a.* from loja_venda_produto a 
		join loja_venda b 
		on  a.codigo_filial=b.codigo_filial
		and a.data_venda=b.data_venda 
		and a.ticket=b.ticket 
		join loja_venda_pgto c 
		on  b.codigo_filial=c.codigo_filial 
		and b.terminal=c.terminal 
		and b.lancamento_caixa=c.lancamento_caixa 
		left join (	select a.produto,convert(numeric(14,2),isnull((b.preco1*70)/100,0)) as preco_transf,
					isnull(b.preco1,0) as preco_vo from produtos a 
					left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') b 
					on a.produto=b.produto ) e 
		on a.produto=e.produto 	
		where c.numero_cupom_fiscal is not null 
		and a.data_venda between @dataini and @datafim
		and a.preco_liquido<e.preco_transf) a  
		group by a.codigo_filial ) b 
		
	on a.codigo_filial=b.codigo_filial 

	left join 

		(select 
		a.codigo_filial,a.filial,
		case 
			when isnull(c.icms_entrada,0)=0 
			then isnull(c.icms_saida,0) 
			else isnull(c.icms_entrada,0)
		end as aliq_icms 
		from lojas_varejo a 
		join cadastro_cli_for b 
		on a.filial=b.nome_clifor 
		left join
		(select * from UNIDADES_FEDERACAO_ICMS where uf='RJ' ) c 
		on b.uf=c.uf_destino 
		) c 

	on 	a.codigo_filial=c.codigo_filial 
    order by a.codigo_filial 


endtext	

f_select(xsel,"curDifIcms")

copy to c:\temp\Dif_Icms.xls xls
