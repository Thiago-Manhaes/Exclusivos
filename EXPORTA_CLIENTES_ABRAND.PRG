

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE



select distinct 

	/*a.cpf_cgc,*/upper(a.cliente_varejo) as cliente,LOWER(a.email) as  email/*,a.tipo_logradouro,a.endereco,a.numero,a.complemento,a.bairro,a.cep,a.cidade,a.uf,
	a.ddd,a.celular,a.telefone,a.aniversario,a.filial*/

 
from 
	(--- clientes que compraram na loja Abrand
	select 
	a.cpf_cgc,a.cliente_varejo,a.email,a.tipo_logradouro,a.endereco,a.numero,a.complemento,a.bairro,a.cep,a.cidade,a.uf,
	a.ddd,a.celular,a.telefone,a.aniversario,
	a.filial 
	from clientes_varejo a 
	where a.filial='ABRAND' 
	and a.email<>'' 
               and a.email not like '%@animale.com.br' 
	and a.email like '%@%'
	and a.email like '%.com%'


	UNION ALL 

	--seleciona clientes que compraram Abrand
	select --distinct 

	a.cpf_cgc,a.cliente_varejo,a.email,a.tipo_logradouro,a.endereco,a.numero,a.complemento,a.bairro,a.cep,a.cidade,a.uf,
	a.ddd,a.celular,a.telefone,a.aniversario,
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
	where a.filial!='ABRAND' 
	and a.email<>'' 
               and a.email not like '%@animale.com.br' 
	and a.email like '%@%'
	and a.email like '%.com%'
	and ( d.anm_marca = 'A.BRAND') ) a


ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\ABRAND_EMAIL.XLS XLS 