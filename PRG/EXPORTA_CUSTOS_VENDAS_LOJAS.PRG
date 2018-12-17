
XDATA_INI='20120601'
XDATA_FIM='20120630' 


TEXT TO XSEL NOSHOW TEXTMERGE 

	SELECT DISTINCT CODIGO_FILIAL FROM LOJA_VENDA 
	WHERE DATA_VENDA BETWEEN '<<XDATA_INI>>' AND '<<XDATA_FIM>>' 
	AND	CODIGO_FILIAL NOT IN ('985','991','988','989')	
	
ENDTEXT 

F_SELECT(XSEL,"CURDATASSQL")

SELE CURDATASSQL 
GO TOP
SCAN 
	
	XLOJA=CURDATASSQL.CODIGO_FILIAL


	WAIT WINDOW XLOJA NOWAIT 

	text to xsel noshow textmerge
			
		select vendas_loja.*,isnull(custos.preco1,0) as custo,qtde_venda*isnull(custos.preco1,0) as valor_custo from  

			(select vendas.produto,vendas.qtde-isnull(trocas.qtde,0) as qtde_venda 
			from

			(select b.produto,sum(qtde) as qtde from loja_venda a 
			join loja_venda_produto b 
			on a.codigo_filial=b.codigo_filial 
			and a.data_venda=b.data_venda 
			and a.ticket=b.ticket 
			where a.codigo_filial='<<XLOJA>>' 
			and a.data_venda between '<<XDATA_INI>>' and '<<XDATA_FIM>>'
			group by b.produto) vendas

			left join 

			(select b.produto,sum(qtde) as qtde from loja_venda a 
			join loja_venda_troca b 
			on a.codigo_filial=b.codigo_filial 
			and a.data_venda=b.data_venda 
			and a.ticket=b.ticket 
			where a.codigo_filial='<<XLOJA>>' 
			and a.data_venda between '<<XDATA_INI>>' and '<<XDATA_FIM>>'
			group by b.produto) trocas 

			on vendas.produto=trocas.produto 

			union all 


			select trocas.produto,trocas.qtde*-1 
			from 
			(select b.produto,sum(qtde) as qtde from loja_venda a 
			join loja_venda_troca b 
			on a.codigo_filial=b.codigo_filial 
			and a.data_venda=b.data_venda 
			and a.ticket=b.ticket 
			where a.codigo_filial='<<XLOJA>>' 
			and a.data_venda between '<<XDATA_INI>>' and '<<XDATA_FIM>>'
			group by b.produto) trocas

			left join 

			(select b.produto,sum(qtde) as qtde from loja_venda a 
			join loja_venda_produto b 
			on a.codigo_filial=b.codigo_filial 
			and a.data_venda=b.data_venda 
			and a.ticket=b.ticket 
			where a.codigo_filial='<<XLOJA>>' 
			and a.data_venda between '<<XDATA_INI>>' and '<<XDATA_FIM>>'
			group by b.produto)  vendas 

			on vendas.produto=trocas.produto 

			where vendas.produto is null) vendas_loja

			left join 
			(select produto,preco1 from produtos_precos where codigo_tab_preco='CT') custos 

		on vendas_loja.produto=custos.produto


	endtext 



	f_select(xsel,"curVendasExp")

	sele curVendasExp 

	select curVendasExp
	copy to "c:\temp\Custo_Vendas_"+ALLT(XLOJA)+"_"+xdata_ini+"_"+xdata_fim+".xls" xls



ENDSCAN 	