

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE


select convert(varchar(35),lower(ltrim(rtrim(a.email)))) as email ,a.cliente_varejo as cliente/*,
isnull(a.ddd,'  ') as ddd,isnull(a.telefone,'        ') as 'telefone residencial',isnull(a.celular,'        ') as 'telefone celular'*/
from clientes_varejo a 
left join (select convert(varchar(35),email) as email from tmp_cli1_email_ruin
		   union all 
		   select convert(varchar(35),email) as email from tmp_cli2_email_ruin) c 
on a.email=c.email  
where a.email is not null 
and a.email<>'' 
and a.email like '%@%'
and a.email like '%.com%'
and 
(a.cartao_afinidade is not null 
and a.cartao_afinidade <>''
and a.cartao_afinidade not like '%CANC%' 
and len(a.cartao_afinidade)=12)
and c.email is null 



ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\CLIENTES_UNIQUE.XLS XLS 