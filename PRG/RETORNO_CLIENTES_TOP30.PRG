

****EXPORTA VENDAS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

SELECT A.CODIGO_CLIENTE,C.CLIENTE_VAREJO,C.FILIAL AS FILIAL_PREFERENCIA,C.DDD,C.TELEFONE,C.CELULAR,C.ANIVERSARIO,
LIMITE_CREDITO = CASE WHEN (D.QTD_CHQ_DEVOL+D.QTD_CHQ_PROBLEMA) <> '0' THEN '0' ELSE D.LIMITE_CREDITO END,
(D.QTD_CHQ_DEVOL+D.QTD_CHQ_PROBLEMA) AS QTD_CHQ_DEV,
(D.VAL_CHQ_DEVOL+D.VAL_CHQ_PROBLEMA) AS VAL_CHE_DEV,
A.COMPRA_TOTAL_2009, ISNULL(B.COMPRA_TOTAL_2010,0) AS COMPRA_TOTAL_2010
FROM(SELECT TOP 30 CODIGO_CLIENTE,sum(valor_pago) as COMPRA_TOTAL_2009 
FROM wanm_vendas_loja_full
WHERE CODIGO_CLIENTE != '77777777777' AND
DATA_VENDA BETWEEN '20090101' AND '20091130'
GROUP BY CODIGO_CLIENTE
ORDER BY COMPRA_TOTAL_2009 DESC) A
LEFT JOIN
(SELECT CODIGO_CLIENTE, SUM(valor_pago) AS COMPRA_TOTAL_2010
FROM wanm_vendas_loja_full
WHERE CODIGO_CLIENTE IN 
(SELECT A.CODIGO_CLIENTE 
FROM(select TOP 30 CODIGO_CLIENTE,sum(valor_pago) as COMPRA_TOTAL 
FROM wanm_vendas_loja_full WHERE CODIGO_CLIENTE != '77777777777' 
AND DATA_VENDA BETWEEN '20090101' AND '20091130' 
GROUP BY CODIGO_CLIENTE ORDER BY COMPRA_TOTAL DESC) A)
AND DATA_VENDA BETWEEN '20100101' AND '20101130'
GROUP BY CODIGO_CLIENTE) B
ON A.CODIGO_CLIENTE = B.CODIGO_CLIENTE
JOIN CLIENTES_VAREJO C
ON A.CODIGO_CLIENTE = C.CODIGO_CLIENTE
JOIN TAB_CLIENTES_CREDITO D
ON A.CODIGO_CLIENTE = D.COD_CLI
ORDER BY A.COMPRA_TOTAL_2009 DESC

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO P:\DEBORA_MKT\RETORNO_CLIENTES_TOP30_2009_2010.XLS XLS 