****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select a.codigo_cliente,b.cliente_varejo,b.ddd,b.telefone,b.ddd_cel,b.celular,a.soma_das_vendas,a.qtde_vendas  
from  
	(select a.codigo_cliente,sum(a.valor_pago) soma_das_vendas,
	--count(ticket+codigo_filial+convert(varchar(13),a.data_venda,112))  as qtde_vendas   
	count(ticket) as qtde_vendas  
	from loja_venda a 
	where  a.vendedor='1340' 
	and a.codigo_cliente is not null 
	and a.data_venda between '20110101' and '20111231'
	group by a.codigo_cliente ) a
join clientes_varejo b 
on a.codigo_cliente=b.codigo_cliente
order by qtde_vendas desc 

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "c:\temp\1340 cristine.XLS" XLS 
