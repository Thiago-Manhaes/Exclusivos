
f_select("select distinct pedido from vendas_produto where qtde_embalada<>0","curPedidos")

sele curPedidos
go top
scan 

     f_prog_bar("Ajustando Pedidos... "+curPedidos.pedido,recno(),reccount())

       text to xCorrige noshow textmerge
           LX_MOVIMENTA_VENDAS_PA '<<curPedidos.pedido>>'
      endtext 
    
     if !f_update(xCorrige)
         messagebox("Não foi possível recalcular pedido "+curPedidos.pedido,48,"Atenção!")
     endif


endscan 
f_prog_bar()