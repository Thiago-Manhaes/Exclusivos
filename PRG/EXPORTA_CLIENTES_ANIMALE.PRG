

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select convert(varchar(35),lower(ltrim(rtrim(a.email)))) as email ,a.cliente_varejo as cliente/*,
isnull(a.ddd,'  ') as ddd,isnull(a.telefone,'        ') as telefone,isnull(a.celular,'        ') as celular*/
from clientes_varejo a 
left join 
	(select codigo_cliente 
	from clientes_varejo 
	where email is not null 
	and email<>'' 
	and email like '%@%'
	and email like '%.com%'
	and email not like '%nfe@%'
	and 
	(cartao_afinidade is not null 
	and cartao_afinidade <>''
	and cartao_afinidade not like '%CANC%' 
	and len(cartao_afinidade)=12)) b 
on a.codigo_cliente=b.codigo_cliente 
where a.email is not null 
and a.email<>'' 
and a.email like '%@%'
and a.email like '%.com%'
and a.email not like '%nfe@%'
and b.codigo_cliente is null 


ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\CLIENTES_ANIMALE.XLS XLS 