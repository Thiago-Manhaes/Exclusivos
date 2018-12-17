

****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select b.codigo_filial,b.data_venda,b.vendedor,c.nome_vendedor,e.cliente_varejo,a.produto,a.cor_produto,d.desc_cor_produto, sum(qtde) as quantidade_vendida 
from LOJA_VENDA_TROCA a
join
loja_venda b
on a.codigo_filial = b.codigo_filial
and a.ticket = b.ticket
and a.data_venda = b.data_venda
join loja_vendedores c
on b.vendedor = c.vendedor
join produto_cores d
on a.produto = d.produto
and a.cor_produto  = d.cor_produto
join clientes_varejo e
on b.codigo_cliente = e.codigo_cliente
where b.data_venda between '20100922' and '20101007'
group by b.codigo_filial,b.data_venda,b.vendedor,c.nome_vendedor,e.cliente_varejo,a.produto,a.cor_produto,d.desc_cor_produto

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA_TROCA")

TEXT TO XSEL1 NOSHOW TEXTMERGE

select b.codigo_filial,b.data_venda,b.vendedor,c.nome_vendedor,e.cliente_varejo,a.produto,a.cor_produto,d.desc_cor_produto, sum(qtde) as quantidade_vendida 
from loja_venda_produto a
join
loja_venda b
on a.codigo_filial = b.codigo_filial
and a.ticket = b.ticket
and a.data_venda = b.data_venda
join loja_vendedores c
on b.vendedor = c.vendedor
join produto_cores d
on a.produto = d.produto
and a.cor_produto  = d.cor_produto
join clientes_varejo e
on b.codigo_cliente = e.codigo_cliente
where b.data_venda between '20100922' and '20101007'
group by b.codigo_filial,b.data_venda,b.vendedor,c.nome_vendedor,e.cliente_varejo,a.produto,a.cor_produto,d.desc_cor_produto

ENDTEXT 

F_SELECT(XSEL1,"CUR_EXPORTA_VENDA")

SELE CUR_EXPORTA_VENDA
COPY TO "P:\WILLISAN\CORRIDA\VENDAS_POR_PERIODO.XLS" XLS 

SELE CUR_EXPORTA_TROCA
COPY TO "P:\WILLISAN\CORRIDA\TROCAS_POR_PERIODO.XLS" XLS 