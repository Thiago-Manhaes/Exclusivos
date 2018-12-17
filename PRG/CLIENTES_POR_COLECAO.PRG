

****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select * from cadastro_cli_for where nome_clifor in
(select cliente_atacado from vendas where colecao = 'inv11' and cliente_atacado not in 
(select cliente_atacado from vendas where colecao <> 'inv11'))
order by nome_clifor

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "c:\temp\clientes_inv11.XLS" XLS 