

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE


		select 
	a.cpf_cgc,a.cliente_varejo,a.email,a.tipo_logradouro,a.endereco,a.numero,a.complemento,a.bairro,a.cep,a.cidade,a.uf,
	a.ddd,a.celular,a.telefone,a.aniversario,a.filial 
	from clientes_varejo a 
	where a.filial LIKE '%FYI%' 

	union all

	select distinct 

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
	where a.filial NOT LIKE '%FYI%' 
    and d.anm_marca = 'F.Y.I'
	order by a.filial

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO P:\DEBORA_MKT\branding\FYI\CLIENTES_FYI_COMPLETO.XLS XLS 