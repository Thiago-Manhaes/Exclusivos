
text to xsel noshow textmerge 


	declare @data_ini datetime
	declare @data_fim datetime

	select @data_ini='20080101'
	select @data_fim='20120831'

	SELECT EXP_FAT.* 
	FROM 
	
		(select a.*,
		isnull(b.valor_dev_contabil,0) as valor_dev_contabil, 
		isnull(b.valor_dev_full,0) as valor_dev_full,
		isnull(b.valor_dev_dsk,0) as valor_dev_dsk

		from 
		(SELECT year(w.emissao) as ano_faturamento,w.filial,
		case 
			when year(w.emissao) between 2008 and 2009 and w.filial_faturamento='ATACADO' 
			then 'TRIMIX' 
			when year(w.emissao) =2012 and w.filial_faturamento='ATACADO' 
			then 'GX NORTE DISTRIBUIDORA' 		
			when year(w.emissao) =2012 and w.filial_faturamento='ATACADO FA' 
			then 'K3X DISTRIBUIDORA' 		
			when year(w.emissao) =2012 and w.filial_faturamento='ESTOQUE CENTRAL' 
			then 'RBX DISTRIBUIDORA' 				
			else w.filial_faturamento
		end as filial_faturamento,
		sum(w.valor_nf) as valor_fat_contabil,
		sum(w.valor_total_producao) as valor_fat_full,
		sum(w.dif_producao) as valor_fat_dsk
		FROM WANM_FATURAMENTO_PRODUCAO w 
		INNER JOIN FATURAMENTO F   
		ON W.FILIAL_FATURAMENTO = F.FILIAL 
		AND      W.NF_SAIDA = F.NF_SAIDA 
		AND      W.SERIE_NF = F.SERIE_NF 
		WHERE W.FILIAL IN ('ATACADO', 'ATACADO FA')  
		AND  W.TIPO_OPERACAO = 'V'  AND  W.NOTA_CANCELADA = 0  
		AND  W.EMISSAO >= @data_ini AND  W.EMISSAO <= @data_fim
		group by year(w.emissao),w.filial,
		case 
			when year(w.emissao) between 2008 and 2009 and w.filial_faturamento='ATACADO' 
			then 'TRIMIX' 
			when year(w.emissao) =2012 and w.filial_faturamento='ATACADO' 
			then 'GX NORTE DISTRIBUIDORA' 		
			when year(w.emissao) =2012 and w.filial_faturamento='ATACADO FA' 
			then 'K3X DISTRIBUIDORA' 		
			when year(w.emissao) =2012 and w.filial_faturamento='ESTOQUE CENTRAL' 
			then 'RBX DISTRIBUIDORA' 				
			else w.filial_faturamento
		end) a 

		left join 

		(SELECT year(a.data_digitacao) as ano_devolucao,
		isnull(case when b.filial_estoque like 'GX NORTE%' then 'ATACADO' else  b.filial_estoque end,'ATACADO') as filial,
		case 
				when year(a.data_digitacao) between 2008 and 2009 and b.filial='ATACADO' 
				then 'TRIMIX' 
				when year(a.data_digitacao) between 2011 and 2012 and b.filial='ATACADO' 
				then 'GX NORTE DISTRIBUIDORA' 		
				when year(a.data_digitacao) =2012 and b.filial='ATACADO FA' 
				then 'K3X DISTRIBUIDORA' 		
				when year(a.data_digitacao) =2012 and b.filial='ESTOQUE CENTRAL' 
				then 'RBX DISTRIBUIDORA' 				
				else b.filial
		end as filial_devolucao,
		sum(case when a.serie_nf_entrada='E1' then 0 else a.valor_item end) as valor_dev_contabil,
		sum(a.valor_producao) as valor_dev_full,
		sum((a.valor_producao-case when a.serie_nf_entrada='E1' then 0 else a.valor_item end)) as valor_dev_dsk  
		FROM WANM_ENTRADAS_DEVOLUCAO (nolock) a 
		join entradas (nolock) b 
		on a.nf_entrada=b.nf_entrada  
		and a.serie_nf_entrada=b.serie_nf_entrada 
		and a.nome_clifor=b.nome_clifor 
		WHERE a.DATA_DIGITACAO >= @data_ini AND  a.DATA_DIGITACAO <= @data_fim AND a.NOME_CLIFOR <> 'AGASB' 
		group by year(a.data_digitacao),
		isnull(case when b.filial_estoque like 'GX NORTE%' then 'ATACADO' else  b.filial_estoque end,'ATACADO'),
		case 
				when year(a.data_digitacao) between 2008 and 2009 and b.filial='ATACADO' 
				then 'TRIMIX' 
				when year(a.data_digitacao) between 2011 and 2012 and b.filial='ATACADO' 
				then 'GX NORTE DISTRIBUIDORA' 		
				when year(a.data_digitacao) =2012 and b.filial='ATACADO FA' 
				then 'K3X DISTRIBUIDORA' 		
				when year(a.data_digitacao) =2012 and b.filial='ESTOQUE CENTRAL' 
				then 'RBX DISTRIBUIDORA' 				
				else b.filial
		end) b 

		on  a.ano_faturamento=b.ano_devolucao 
		and a.filial=b.filial 
		and a.filial_faturamento=b.filial_devolucao 

		union all 

		select b.ano_devolucao,b.filial,b.filial_devolucao,
		0 as valor_fat_contabil,
		0 as valor_fat_full,
		0 as valor_fat_dsk,
		isnull(b.valor_dev_contabil,0) as valor_dev_contabil, 
		isnull(b.valor_dev_full,0) as valor_dev_full,
		isnull(b.valor_dev_dsk,0) as valor_dev_dsk
		from 
		(SELECT year(a.data_digitacao) as ano_devolucao,
		isnull(case when b.filial_estoque like 'GX NORTE%' then 'ATACADO' else  b.filial_estoque end,'ATACADO') as filial,
		case 
				when year(a.data_digitacao) between 2008 and 2009 and b.filial='ATACADO' 
				then 'TRIMIX' 
				when year(a.data_digitacao) between 2011 and 2012 and b.filial='ATACADO' 
				then 'GX NORTE DISTRIBUIDORA' 		
				when year(a.data_digitacao) =2012 and b.filial='ATACADO FA' 
				then 'K3X DISTRIBUIDORA' 		
				when year(a.data_digitacao) =2012 and b.filial='ESTOQUE CENTRAL' 
				then 'RBX DISTRIBUIDORA' 				
				else b.filial
		end as filial_devolucao,
		sum(case when a.serie_nf_entrada='E1' then 0 else a.valor_item end) as valor_dev_contabil,
		sum(a.valor_producao) as valor_dev_full,
		sum((a.valor_producao-case when a.serie_nf_entrada='E1' then 0 else a.valor_item end)) as valor_dev_dsk  
		FROM WANM_ENTRADAS_DEVOLUCAO (nolock) a 
		join entradas (nolock) b 
		on a.nf_entrada=b.nf_entrada  
		and a.serie_nf_entrada=b.serie_nf_entrada 
		and a.nome_clifor=b.nome_clifor 
		WHERE a.DATA_DIGITACAO >= @data_ini AND  a.DATA_DIGITACAO <= @data_fim AND a.NOME_CLIFOR <> 'AGASB' 
		group by year(a.data_digitacao),
		isnull(case when b.filial_estoque like 'GX NORTE%' then 'ATACADO' else  b.filial_estoque end,'ATACADO'),
		case 
				when year(a.data_digitacao) between 2008 and 2009 and b.filial='ATACADO' 
				then 'TRIMIX' 
				when year(a.data_digitacao) between 2011 and 2012 and b.filial='ATACADO' 
				then 'GX NORTE DISTRIBUIDORA' 		
				when year(a.data_digitacao) =2012 and b.filial='ATACADO FA' 
				then 'K3X DISTRIBUIDORA' 		
				when year(a.data_digitacao) =2012 and b.filial='ESTOQUE CENTRAL' 
				then 'RBX DISTRIBUIDORA' 				
				else b.filial
		end) b

		left join 

		(SELECT year(w.emissao) as ano_faturamento,w.filial,
		case 
			when year(w.emissao) between 2008 and 2009 and w.filial_faturamento='ATACADO' 
			then 'TRIMIX' 
			when year(w.emissao) =2012 and w.filial_faturamento='ATACADO' 
			then 'GX NORTE DISTRIBUIDORA' 		
			when year(w.emissao) =2012 and w.filial_faturamento='ATACADO FA' 
			then 'K3X DISTRIBUIDORA' 		
			when year(w.emissao) =2012 and w.filial_faturamento='ESTOQUE CENTRAL' 
			then 'RBX DISTRIBUIDORA' 				
			else w.filial_faturamento
		end as filial_faturamento,
		sum(w.valor_nf) as valor_fat_contabil,
		sum(w.valor_total_producao) as valor_fat_full,
		sum(w.dif_producao) as valor_fat_dsk
		FROM WANM_FATURAMENTO_PRODUCAO w 
		INNER JOIN FATURAMENTO F   
		ON W.FILIAL_FATURAMENTO = F.FILIAL 
		AND      W.NF_SAIDA = F.NF_SAIDA 
		AND      W.SERIE_NF = F.SERIE_NF 
		WHERE W.FILIAL IN ('ATACADO', 'ATACADO FA')  
		AND  W.TIPO_OPERACAO = 'V'  AND  W.NOTA_CANCELADA = 0  
		AND  W.EMISSAO >= @data_ini AND  W.EMISSAO <= @data_fim
		group by year(w.emissao),w.filial,
		case 
			when year(w.emissao) between 2008 and 2009 and w.filial_faturamento='ATACADO' 
			then 'TRIMIX' 
			when year(w.emissao) =2012 and w.filial_faturamento='ATACADO' 
			then 'GX NORTE DISTRIBUIDORA' 		
			when year(w.emissao) =2012 and w.filial_faturamento='ATACADO FA' 
			then 'K3X DISTRIBUIDORA' 		
			when year(w.emissao) =2012 and w.filial_faturamento='ESTOQUE CENTRAL' 
			then 'RBX DISTRIBUIDORA' 				
			else w.filial_faturamento
		end) a


		on  a.ano_faturamento=b.ano_devolucao 
		and a.filial=b.filial 
		and a.filial_faturamento=b.filial_devolucao 

		where a.filial_faturamento is null ) EXP_FAT
	
	ORDER BY ANO_FATURAMENTO,FILIAL_FATURAMENTO	 
	
endtext 

f_select(xsel,"curFat")

sele curFat 
copy to c:\temp\Fat_Animale.xls xls	