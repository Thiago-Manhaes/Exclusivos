

text to xsel noshow textmerge

	declare @data_ini datetime
	declare @data_fim datetime

	select @data_ini='20100101'
	select @data_fim='20120831'



	select vendas.ano_venda,vendas.mes_venda,
	case when vendas.mes_venda =1  then 'JANEIRO' 
	when vendas.mes_venda =2  then 'FEVEREIRO' 
	when vendas.mes_venda =3  then 'MARCO' 
	when vendas.mes_venda =4  then 'ABRIL' 
	when vendas.mes_venda =5  then 'MAIO' 
	when vendas.mes_venda =6  then 'JUNHO' 
	when vendas.mes_venda =7  then 'JULHO' 
	when vendas.mes_venda =8  then 'AGOSTO' 
	when vendas.mes_venda =9  then 'SETEMBRO' 
	when vendas.mes_venda =10  then 'OUTUBRO' 
	when vendas.mes_venda =11  then 'NOVEMBRO' 
	when vendas.mes_venda =12  then 'DEZEMBRO' 
	end as desc_mes_venda,
	vendas.codigo_filial,
	lojas.filial,
	vendas.valor_venda_liq,
	custos.custo_liq 
	from 
	(select year(a.data_venda) as ano_venda,month(a.data_venda) as mes_venda,a.codigo_filial,
	sum(valor_ticket_sem_vale) as valor_venda_liq 
	from wanm_vendas_loja_full  a 
	where a.data_venda between @data_ini and  @data_fim 
	and a.codigo_filial not in ('999998') 
	group by year(a.data_venda),month(a.data_venda),a.codigo_filial) vendas 

	left join 
	(
	select a.ano_venda,a.mes_venda,a.codigo_filial,
	isnull(b.custo_venda,0) as custo_venda , 
	isnull(c.custo_troca,0) as custo_troca ,
	isnull(b.qtde_venda,0) as qtde_venda , 
	isnull(c.qtde_troca,0) as qtde_troca ,
	isnull(b.total_venda,0) as total_venda , 
	isnull(c.total_troca,0) as total_troca ,
	isnull(b.total_venda,0)-isnull(c.total_troca,0) as venda_liq,
	isnull(b.custo_venda,0)-isnull(c.custo_troca,0) as custo_liq,
	isnull(b.qtde_venda,0)-isnull(c.qtde_troca,0) as qtde_liq,
	(isnull(b.custo_venda,0)-isnull(c.custo_troca,0)) / case when (isnull(b.qtde_venda,0)-isnull(c.qtde_troca,0)) =0 then 1 else (isnull(b.qtde_venda,0)-isnull(c.qtde_troca,0)) end as custo_medio



	from 


		(select 
		distinct lojas_com_venda.ano_venda,lojas_com_venda.mes_venda,  
		lojas_com_venda.codigo_filial 
		from 


			((select distinct year(Loja_venda_produto.data_venda) as ano_venda,month(Loja_venda_produto.data_venda) as mes_venda,
			Loja_venda_produto.codigo_filial
			FROM Loja_venda_produto  
			join PRODUTOS Produtos  
			on Loja_venda_produto.PRODUTO = Produtos.PRODUTO 
			join Lojas_varejo Lojas_varejo 
			on Loja_venda_produto.CODIGO_FILIAL = Lojas_varejo.CODIGO_FILIAL 
			and   Lojas_varejo.codigo_filial!='999998'
			join FILIAIS Filiais 
			on Lojas_varejo.FILIAL = Filiais.FILIAL 
			join Cadastro_cli_for 
			on Filiais.FILIAL = Cadastro_cli_for.NOME_CLIFOR 
			join Loja_venda Loja_venda 
			on Loja_venda.CODIGO_FILIAL = Loja_venda_produto.CODIGO_FILIAL 
			and Loja_venda_produto.TICKET = Loja_venda.TICKET 
			and Loja_venda_produto.DATA_VENDA = Loja_venda.DATA_VENDA 
			join WANM_PRECOS WANM_PRECOS
			on WANM_PRECOS.PRODUTO = Loja_venda_produto.PRODUTO 	
			left join Loja_venda_pgto Loja_venda_pgto 
			on Loja_venda_pgto.CODIGO_FILIAL = Loja_venda.CODIGO_FILIAL
			and Loja_venda.DATA_VENDA = Loja_venda_pgto.DATA 
			and Loja_venda.LANCAMENTO_CAIXA = Loja_venda_pgto.LANCAMENTO_CAIXA
			and Loja_venda.TERMINAL_PGTO = Loja_venda_pgto.TERMINAL

			where LOJA_VENDA_PRODUTO.DATA_VENDA between @data_ini and  @data_fim  )

			union all 

			(select distinct year(Loja_venda_troca.data_venda) as ano_venda,month(Loja_venda_troca.data_venda) as mes_venda,
			Loja_venda_troca.codigo_filial 
			FROM Loja_venda_troca 
			join PRODUTOS Produtos  
			on Loja_venda_troca.PRODUTO = Produtos.PRODUTO 
			join Lojas_varejo Lojas_varejo 
			on Loja_venda_troca.CODIGO_FILIAL = Lojas_varejo.CODIGO_FILIAL 
			and   Lojas_varejo.codigo_filial!='999998'
			join FILIAIS Filiais 
			on Lojas_varejo.FILIAL = Filiais.FILIAL 
			join Cadastro_cli_for 
			on Filiais.FILIAL = Cadastro_cli_for.NOME_CLIFOR 
			join Loja_venda Loja_venda 
			on Loja_venda.CODIGO_FILIAL = Loja_venda_troca.CODIGO_FILIAL 
			and Loja_venda_troca.TICKET = Loja_venda.TICKET 
			and Loja_venda_troca.DATA_VENDA = Loja_venda.DATA_VENDA 
			join WANM_PRECOS WANM_PRECOS
			on WANM_PRECOS.PRODUTO = Loja_venda_TROCA.PRODUTO 	
			left join Loja_venda_pgto Loja_venda_pgto 
			on Loja_venda_pgto.CODIGO_FILIAL = Loja_venda.CODIGO_FILIAL
			and Loja_venda.DATA_VENDA = Loja_venda_pgto.DATA 
			and Loja_venda.LANCAMENTO_CAIXA = Loja_venda_pgto.LANCAMENTO_CAIXA
			and Loja_venda.TERMINAL_PGTO = Loja_venda_pgto.TERMINAL

			where LOJA_VENDA_TROCA.DATA_VENDA between @data_ini and  @data_fim   )) lojas_com_venda ) a

	left join 

		(select year(Loja_venda_produto.data_venda) as ano_venda,month(Loja_venda_produto.data_venda) as mes_venda,
		Loja_venda_produto.codigo_filial,sum(Loja_venda_produto.qtde*WANM_PRECOS.PRECO_CUSTO) as custo_venda
		,sum(Loja_venda_produto.qtde) as qtde_venda
		, CONVERT(NUMERIC(14,2),SUM(Loja_venda_produto.QTDE*Loja_venda_produto.PRECO_LIQUIDO*(1-ISNULL(Loja_venda_produto.FATOR_DESCONTO_VENDA,1)))) AS TOTAL_VENDA  
		
		
		FROM Loja_venda_produto  
		join PRODUTOS Produtos  
		on Loja_venda_produto.PRODUTO = Produtos.PRODUTO 
		join Lojas_varejo Lojas_varejo 
		on Loja_venda_produto.CODIGO_FILIAL = Lojas_varejo.CODIGO_FILIAL 
		and   Lojas_varejo.codigo_filial!='999998'
		join FILIAIS Filiais 
		on Lojas_varejo.FILIAL = Filiais.FILIAL 
		join Cadastro_cli_for 
		on Filiais.FILIAL = Cadastro_cli_for.NOME_CLIFOR 
		join Loja_venda Loja_venda 
		on Loja_venda.CODIGO_FILIAL = Loja_venda_produto.CODIGO_FILIAL 
		and Loja_venda_produto.TICKET = Loja_venda.TICKET 
		and Loja_venda_produto.DATA_VENDA = Loja_venda.DATA_VENDA 
		join WANM_PRECOS WANM_PRECOS
		on WANM_PRECOS.PRODUTO = Loja_venda_produto.PRODUTO 	

		where LOJA_VENDA_PRODUTO.DATA_VENDA between @data_ini and  @data_fim
	 
		group by year(Loja_venda_produto.data_venda),month(Loja_venda_produto.data_venda),Loja_venda_produto.codigo_filial)  b 

		on a.codigo_filial=b.codigo_filial 
		and a.ano_venda=b.ano_venda
		and a.mes_venda=b.mes_venda


	left join 

		(select year(Loja_venda_troca.data_venda) as ano_venda,month(Loja_venda_troca.data_venda) as mes_venda,
		Loja_venda_troca.codigo_filial,sum(Loja_venda_troca.qtde*WANM_PRECOS.PRECO_CUSTO) as custo_troca
		,sum(Loja_venda_troca.qtde) as qtde_troca
		,CONVERT(NUMERIC(14,2),SUM(Loja_venda_troca.QTDE*Loja_venda_troca.PRECO_LIQUIDO*(1-ISNULL(Loja_venda_troca.FATOR_DESCONTO_VENDA,0)))) AS TOTAL_TROCA
		
		
		FROM Loja_venda_troca 
		join PRODUTOS Produtos  
		on Loja_venda_troca.PRODUTO = Produtos.PRODUTO 
		join Lojas_varejo Lojas_varejo 
		on Loja_venda_troca.CODIGO_FILIAL = Lojas_varejo.CODIGO_FILIAL 
		and   Lojas_varejo.codigo_filial!='999998'
		join FILIAIS Filiais 
		on Lojas_varejo.FILIAL = Filiais.FILIAL 
		join Cadastro_cli_for 
		on Filiais.FILIAL = Cadastro_cli_for.NOME_CLIFOR 
		join Loja_venda Loja_venda 
		on Loja_venda.CODIGO_FILIAL = Loja_venda_troca.CODIGO_FILIAL 
		and Loja_venda_troca.TICKET = Loja_venda.TICKET 
		and Loja_venda_troca.DATA_VENDA = Loja_venda.DATA_VENDA 
		join WANM_PRECOS WANM_PRECOS
		on WANM_PRECOS.PRODUTO = Loja_venda_TROCA.PRODUTO 	

		where LOJA_VENDA_TROCA.DATA_VENDA between @data_ini and  @data_fim 
		group by year(Loja_venda_troca.data_venda) ,month(Loja_venda_troca.data_venda) ,Loja_venda_troca.codigo_filial) c 
		
		on  a.codigo_filial=c.codigo_filial 
		and a.ano_venda=c.ano_venda
		and a.mes_venda=c.mes_venda ) custos 

		on  vendas.codigo_filial=custos.codigo_filial 
		and vendas.ano_venda=custos.ano_venda
		and vendas.mes_venda=custos.mes_venda 

		join lojas_varejo lojas 
		on vendas.codigo_filial=lojas.codigo_filial

		
		order by vendas.ano_venda,vendas.mes_venda,vendas.codigo_filial

endtext 

f_select(xsel)
copy to c:\temp\explucrfarm.xls xls
