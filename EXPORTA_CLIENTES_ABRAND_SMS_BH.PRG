

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select distinct 
convert(VARchar(16),convert(char(2),case 
	when len(convert(char(4),replace(a.ddd ,'nulo','21')))=2 
	then convert(char(2),replace(a.ddd ,'nulo','21'))
	else (select convert(int,ddd1) from cadastro_cli_for where nome_clifor=a.filial)	 
end )
+
replace(a.celular,'-','')) as celular,
a.cliente

 
from 
	(--- clientes que compraram na loja Abrand
	select 
	case 	
		when a.ddd_cel is null or a.ddd_cel='' or a.ddd_cel like '%nulo%' 
		then case	
				 when a.ddd is null  or a.ddd=''  or a.ddd like '%nulo%'
				 then (select ddd1 from cadastro_cli_for where nome_clifor=a.filial)	
				 else a.ddd
			 end	
		else a.ddd_cel	
	end as ddd
	,
	ltrim(rtrim(a.celular)) as celular,
	upper( left( ltrim(a.cliente_varejo), charindex(' ', ltrim(a.cliente_varejo)) ) ) as cliente  ,
	a.filial 
	from clientes_varejo a 
	where a.filial='ABRAND SAVASSI' 
	and a.celular not like '%ñ%'	
	and a.celular is not null 
	and a.celular<>''
	and a.celular not like '%A%'
	and a.celular not like '%.%'

	UNION ALL 

	--seleciona clientes que compraram Abrand
	select distinct 
	case 	
		when a.ddd_cel is null or a.ddd_cel='' or a.ddd_cel like '%nulo%' 
		then case	
				 when a.ddd is null  or a.ddd=''  or a.ddd like '%nulo%'
				 then (select ddd1 from cadastro_cli_for where nome_clifor=a.filial)	
				 else a.ddd
			 end	
		else a.ddd_cel	
	end as ddd
	,
	a.celular,
	upper( left( ltrim(a.cliente_varejo), charindex(' ', ltrim(a.cliente_varejo)) ) ) as cliente ,
	a.filial  
	from clientes_varejo a 
	join loja_venda b 
	on a.codigo_cliente=b.codigo_cliente 
	join loja_venda_produto c 
	on b.codigo_filial=c.codigo_filial 
	and b.data_venda=c.data_venda 
	and b.ticket=c.ticket 
	join produtos d 
	on c.produto=d.produto
	where a.filial!='ABRAND SAVASSI' 
	and a.celular is not null 
	and a.celular<>''
	and a.celular not like '%A%'
	and a.celular not like '%.%'
	and upper(a.cidade) in ('BH','BELO HORIZONTE')
	and (d.linha='A. BRAND' or d.colecao like '%ABRAND%')) a

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\ABRAND_SMS_SOMENTE_BH.XLS XLS 