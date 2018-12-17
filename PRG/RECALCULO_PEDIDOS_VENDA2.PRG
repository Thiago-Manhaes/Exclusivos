f_select("select pedido from vendas where COLECAO = 'AB V16' AND FILIAL = 'ATACADO' AND TIPO = 'MULTIMARCA A.BRAND'","tmpPed")
SELECT tmpPed
SCAN
 TEXT TO xRec NOSHOW TEXTMERGE 
  EXECUTE Lx_MOVIMENTA_VENDAS_PA <<tmpped.pedido>>
 ENDTEXT 
 
 f_update(xrec)
 
ENDSCAN
MESSAGEBOX("RECALCULO CONCLUIDO")