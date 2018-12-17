

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select a.codigo_cliente as Cpf,b.cliente_varejo as Nome,b.email,b.tipo_logradouro,b.endereco,b.numero,b.complemento,
	   b.bairro,b.cep,b.cidade,b.uf,b.ddd,b.celular,b.telefone,b.aniversario,b.filial as 'filial de cadastro',a.qtde_pecas,a.soma_das_vendas  
from  
	(select a.codigo_cliente,sum(c.qtde) as qtde_pecas ,sum(c.qtde*c.preco_liquido) soma_das_vendas 
	 
		from clientes_varejo a 
			join loja_venda b 
			on a.codigo_cliente=b.codigo_cliente 
			join loja_venda_produto c 
			on b.codigo_filial=c.codigo_filial 
			and b.data_venda=c.data_venda 
			and b.ticket=c.ticket 
			join produtos d 
			on c.produto=d.produto
		where d.linha='A. BRAND'
			and a.codigo_cliente!='77777777777'
			and a.filial!='estoque central'
            and b.codigo_filial!='038'

			 
	group by a.codigo_cliente) a
	
	join clientes_varejo b 
		on a.codigo_cliente=b.codigo_cliente

order by soma_das_vendas desc


ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\ABRAND_CLI_ANIMALE_COMPLETO_COM_VALORES.XLS XLS 