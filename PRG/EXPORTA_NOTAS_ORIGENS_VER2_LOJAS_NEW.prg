

XLOJA='PRAIA'
XDATA_INI='20110101'
XDATA_FIM='20110131'
XDIASNOTA=240


text to xsel noshow textmerge
		
		SELECT 

		convert(datetime,null) as DATA_ENTRADA_NA_LOJA,
		convert(varchar(14),'') as CNPJ_EMISSOR_NOTA,
		convert(char(10),'') as NUMERO_NF_ENTRADA,
		convert(numeric(14,2),0) as QUANTIDADE,
		a.produto AS CODIGO_PRODUTO, 
		convert(numeric(14,2),0) as PRECO_UNIT_PRODUTO,
		convert(numeric(14,2),0) as VALOR_PRODUTO,
		CONVERT(NUMERIC(14,2),0) AS BASE_CALCULO,
		CONVERT(NUMERIC(14,2),0) AS ICMS_ENTRADA,
		convert(varchar(14),'') as IE,
		convert(char(4),'') as codigo_fiscal_operacao,
		convert(char(15),'') as natureza_operacao,
		convert(varchar(25),'') as filial,

		A.DATA_VENDA AS DATA_SAIDA,
		A.numero_cupom_fiscal AS CUPOM_FISCAL,
		A.QTDE AS QTDE_VENDIDA,
		a.produto AS CODIGO_PRODUTO, 
		pd.desc_produto AS DESCRICAO_PRODUTO,
		a.preco_liquido as preco_vendido_loja,
		(a.preco_liquido*A.QTDE  ) AS VALOR_VENDIDO_LOJA,
		CONVERT(NUMERIC(14,2),0) AS BASE_CALCULO_SAIDA,
		CONVERT(NUMERIC(14,2),0) AS ICMS_SAIDA,
		CONVERT(NUMERIC(14,2),0) AS DIFERENCA_DA_BC,
		CONVERT(NUMERIC(14,2),0) AS DIFERENCA_DE_ICMS


		from 
			
			
			(select  c.numero_cupom_fiscal,a.data_venda,b.produto,b.preco_liquido,sum(qtde) as qtde 
			from loja_venda a 
			join loja_venda_produto b 
			on  a.ticket=b.ticket 
			and a.codigo_filial=b.codigo_filial 
			and a.data_venda=b.data_venda 
			join loja_venda_pgto c 
			on c.codigo_filial=a.codigo_filial_pgto 
			and c.terminal=a.terminal_pgto
			and c.lancamento_caixa=a.lancamento_caixa
			where a.codigo_filial=(select codigo_filial from lojas_varejo where filial='<<XLOJA>>') 
			and   a.data_venda between '<<XDATA_INI>>' and '<<XDATA_FIM>>' 
			and   a.ticket not like 'p%'
			group by c.numero_cupom_fiscal,a.data_venda,b.produto,b.preco_liquido) a
			join produtos pd 
			on a.produto=pd.produto 
			left join (select produto,preco1 from produtos_precos where codigo_tab_preco='V' ) b 
			on a.produto=b.produto 
			left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') c 
			on a.produto=c.produto 
			where a.produto<>'99.99.9999' 	


endtext 



f_select(xsel,"curVendas")

sele curvendas 

go top
Scan

       
        f_prog_bar("Selecionando Registros de Venda "+ allt(str(recno(),15)) + " de " + allt(str(reccount(),15)) + chr(13)+curvendas.CODIGO_PRODUTO,recno(),reccount())
       
        text to xsel noshow textmerge

			select top 1
			convert(varchar(12),b.codigo_item) as produto,b.nf_entrada,a.recebimento,
			convert(numeric(14,2) ,b.preco_unitario) as preco_unit_entrada ,
			convert(numeric(14,2) ,(b.qtde_item) ) as qtde_unit_entrada ,
			convert(numeric(14,2) ,(b.valor_item) ) as valor_entrada ,
			b.codigo_fiscal_operacao,a.filial,
			a.natureza,C.CGC_CPF
			from entradas a 
			join entradas_item b 
			on  a.nf_entrada=b.nf_entrada 
			and a.nome_clifor=b.nome_clifor 
			and a.serie_nf_entrada=b.serie_nf_entrada 
			JOIN CADASTRO_CLI_FOR C 
			ON A.NOME_CLIFOR=C.NOME_CLIFOR
			where a.filial='<<XLOJA>>' 
			--and   a.filial in ('RBX DISTRIBUIDORA','TRIMIX','GX NORTE DISTRIBUIDORA')
			and   a.natureza like '221%'
			and   a.recebimento between (SELECT CONVERT(DATETIME,'<<XDATA_INI>>')-<<XDIASNOTA>>)  and '<<XDATA_FIM>>'
			and   convert(varchar(50),b.codigo_item)=convert(varchar(50),'<<curvendas.CODIGO_PRODUTO>>') 
		    order by a.recebimento desc 

        endtext
        
       
         f_select(xsel,"curEntradasItem")

         sele curEntradasItem
         go top
         xreg=0
         scan 

                 f_prog_bar("Selecionando Notas de Entrada",recno(),reccount())

                  sele curvendas  
				  REPLA DATA_ENTRADA_NA_LOJA WITH curEntradasItem.recebimento
				  REPLA CNPJ_EMISSOR_NOTA	 WITH curEntradasItem.CGC_CPF
				  REPLA NUMERO_NF_ENTRADA	 WITH curEntradasItem.nf_entrada
				  REPLA QUANTIDADE			 WITH curEntradasItem.qtde_unit_entrada
				  REPLA PRECO_UNIT_PRODUTO	 WITH curEntradasItem.preco_unit_entrada
				  REPLA VALOR_PRODUTO		 WITH curEntradasItem.valor_entrada
                  repla codigo_fiscal_operacao with curEntradasItem.codigo_fiscal_operacao
                  repla filial with curEntradasItem.filial
                  repla natureza_operacao with curEntradasItem.natureza


         endscan 
        
         f_prog_bar()    

Endscan

sele curVendas 
copy to "c:\temp\notas_origens_"+ALLT(XLOJA)+"_"+SUBSTR(xdata_ini,5,2)+".xls" xls