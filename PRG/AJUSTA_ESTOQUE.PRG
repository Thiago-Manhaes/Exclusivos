xFilial = 'LOJA COMPARATIVA'

f_select("select * from estoque_produtos where  filial = ?xFilial","xProduto")

sele xProduto
go top

scan
                f_prog_bar("Recalculando Estoque "+allt(xFilial)+" \ Produto: "+allt(xProduto.Produto)+" Cor: "+xProduto.cor_produto,RECNO(),RECCOUNT())
	sele xProduto
	f_select("SELECT ISNULL(SUM( TT_MOV),0) AS ESTOQUE FROM FX_MONTA_CARDEX_PA(?xProduto.Produto,?xProduto.cor_produto,?xFilial, 0)","xEstoque")
	f_update("update estoque_produtos set estoque = ?xEstoque.Estoque where filial = ?xFilial and produto =?xProduto.Produto and cor_produto = ?xProduto.cor_produto and estoque <> ?xEstoque.Estoque")  
endscan
f_prog_bar()
messagebox("Ajuste de Estoque finalizado com Sucesso !!!")