
text to xsel noshow textmerge

	declare @Data_Ini datetime
	declare @Data_Fim datetime

	select @Data_Ini='20111001'
	select @Data_Fim='20111031'


	select fat_periodo.*,
	isnull(devol_periodo.qtde_devol,0)  as qtde_devol,
	isnull(devol_periodo.valor_devol,0)  as valor_devol,
	case 
		when fat_periodo.qtde-isnull(devol_periodo.qtde_devol,0)<0 
		then fat_periodo.qtde-isnull(devol_periodo.qtde_devol,0)
		else fat_periodo.qtde-isnull(devol_periodo.qtde_devol,0) 
	end as qtde_liq,
	case 
		when fat_periodo.valor-isnull(devol_periodo.valor_devol,0)<0 
		then fat_periodo.valor-isnull(devol_periodo.valor_devol,0)
		else fat_periodo.valor-isnull(devol_periodo.valor_devol,0) 
	end as valor_liq
	from 

	(select a.filial,b.classif_fiscal,c.desc_classificacao,
	sum(a.qtde) as qtde,sum(a.valor) as valor 
	from W_FATURAMENTO_PROD_02 a 
	join produtos b 
	on a.produto=b.produto 
	join classif_fiscal c 
	on b.classif_fiscal=c.classif_fiscal
	join 
		(select * from classif_fiscal 
		where classif_fiscal in ('39262000','48185000','68129100','42021100','42022100',
		'42023100','42029100','42050000','63090000') 
		or classif_fiscal like '4015%'
		or classif_fiscal like '4203%'
		or classif_fiscal like '4303%'
		or classif_fiscal like '61%'
		or classif_fiscal like '62%'
		or classif_fiscal like '6301%'
		or classif_fiscal like '6305%'
		or classif_fiscal like '6401%'
		or classif_fiscal like '6406%'
		or classif_fiscal like '9401%'
		or classif_fiscal like '9402%'
		or classif_fiscal like '9403%'
		or classif_fiscal like '9404%'
		or classif_fiscal like '9000%') d 
	on c.classif_fiscal=d.classif_fiscal
	where a.emissao between @Data_Ini and @Data_Fim 
	and   a.tipo_operacao='V' 
	and   a.serie_nf<>'e1' 
	group by a.filial,b.classif_fiscal,c.desc_classificacao) fat_periodo 

	left join 

	(select a.filial,b.classif_fiscal,e.desc_classificacao,
	sum(qtde_item) as qtde_devol,
	sum(valor_item) as valor_devol 
	from entradas a 
	join entradas_item b 
	on  a.nf_entrada=b.nf_entrada 
	and a.nome_clifor=b.nome_clifor 
	and a.serie_nf_entrada=b.serie_nf_entrada  
	join naturezas_entradas c 
	on a.natureza=c.natureza
	join ctb_lx_tipo_operacao d 
	on c.ctb_tipo_operacao=d.ctb_tipo_operacao 
	join classif_fiscal e 
	on b.classif_fiscal=e.classif_fiscal 
	join 
		(select * from classif_fiscal 
		where classif_fiscal in ('39262000','48185000','68129100','42021100','42022100',
		'42023100','42029100','42050000','63090000') 
		or classif_fiscal like '4015%'
		or classif_fiscal like '4203%'
		or classif_fiscal like '4303%'
		or classif_fiscal like '61%'
		or classif_fiscal like '62%'
		or classif_fiscal like '6301%'
		or classif_fiscal like '6305%'
		or classif_fiscal like '6401%'
		or classif_fiscal like '6406%'
		or classif_fiscal like '9401%'
		or classif_fiscal like '9402%'
		or classif_fiscal like '9403%'
		or classif_fiscal like '9404%'
		or classif_fiscal like '9000%') f 
	on b.classif_fiscal=f.classif_fiscal
	where a.recebimento between @Data_Ini and @Data_Fim
	and d.tipo_operacao='D'  
	and a.serie_nf_entrada<>'E1'
	group by a.filial,b.classif_fiscal,e.desc_classificacao) devol_periodo

	on  fat_periodo.filial=devol_periodo.filial 
	and fat_periodo.classif_fiscal=devol_periodo.classif_fiscal 

	order by fat_periodo.filial,fat_periodo.classif_fiscal

endtext	

f_select(xsel,"curExp")

sele curExp 
copy to c:\temp\Exp_Clssif_sem_Lojas.xls xls 






