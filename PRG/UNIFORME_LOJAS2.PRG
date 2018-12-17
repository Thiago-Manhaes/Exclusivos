TEXT TO CriaCursorVazio TEXTMERGE NOSHOW

SELECT A.NF_ENTRADA,A.RECEBIMENTO,A.NOME_CLIFOR,A.FILIAL,B.CODIGO_ITEM AS PRODUTO,QTDE_ITEM AS QTDE_NF,
B.PRECO_UNITARIO,B.PRECO_UNITARIO AS TAXA_IMPOSTO,
B.PRECO_UNITARIO AS VALOR_IMPOSTO,A.NF_ENTRADA AS NF_LOJA,A.FILIAL AS LOJA,QTDE_ITEM AS QTDE_RETIRADA
FROM ENTRADAS A
JOIN ENTRADAS_ITEM B
ON A.NF_ENTRADA = B.NF_ENTRADA
AND A.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA
AND A.NOME_CLIFOR = B.NOME_CLIFOR
WHERE 1 = 2

ENDTEXT

f_select(CriaCursorVazio,"Cur_Uni_loja")

TEXT TO xSelUniLoja TEXTMERGE NOSHOW

SELECT B.PRODUTO,C.DESC_PRODUTO,B.QTDE_SAIDA,A.FILIAL,A.NUMERO_NF_TRANSFERENCIA AS NF_SAIDA
FROM LOJA_SAIDAS A
JOIN LOJA_SAIDAS_PRODUTO B
ON A.ROMANEIO_PRODUTO = B.ROMANEIO_PRODUTO
AND A.FILIAL = B.FILIAL
JOIN PRODUTOS C
ON B.PRODUTO = C.PRODUTO 
JOIN LOJAS_VAREJO LV
ON A.FILIAL = LV.FILIAL
LEFT JOIN LOJA_NOTA_FISCAL D
ON A.NUMERO_NF_TRANSFERENCIA = D.NF_NUMERO
AND D.CODIGO_FILIAL = LV.CODIGO_FILIAL
AND D.SERIE_NF = '5'
WHERE A.FILIAL_DESTINO = 'UNIFORME LOJAS' AND A.SAIDA_CANCELADA = 0
ORDER BY B.PRODUTO


ENDTEXT

f_select(xSelUniLoja,"x_Uni_loja")

sele x_Uni_loja
go top
Scan
sele x_Uni_loja

TEXT TO SelEntrada TEXTMERGE NOSHOW

SELECT TOP 1 A.NF_ENTRADA,A.RECEBIMENTO,A.NOME_CLIFOR,A.FILIAL,B.CODIGO_ITEM AS PRODUTO,B.QTDE_ITEM,B.PRECO_UNITARIO,C.TAXA_IMPOSTO,
CONVERT(NUMERIC(14,2),ROUND(('<<x_Uni_loja.qtde_saida>>'*B.PRECO_UNITARIO)*(C.TAXA_IMPOSTO/100),2)) AS VALOR_IMPOSTO
FROM ENTRADAS A
JOIN ENTRADAS_ITEM B
ON A.NF_ENTRADA = B.NF_ENTRADA
AND A.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA
AND A.NOME_CLIFOR = B.NOME_CLIFOR
JOIN ENTRADAS_IMPOSTO C
ON C.NF_ENTRADA = B.NF_ENTRADA
AND C.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA
AND C.NOME_CLIFOR = B.NOME_CLIFOR
WHERE A.NOME_CLIFOR NOT IN (SELECT FILIAL FROM FILIAIS WHERE TIPO_FILIAL = 'LOJA VAREJO')
AND A.FILIAL IN ('ESTOQUE CENTRAL','RBX DISTRIBUIDORA') AND ID_IMPOSTO = '1'
AND A.NOME_CLIFOR IN (SELECT DISTINCT NOME_CLIFOR FROM PRODUCAO_RECURSOS UNION ALL SELECT 'RBX FABRICA'  UNION ALL SELECT 'TRIMIX') 
AND A.SERIE_NF_ENTRADA <> 'E1'
AND B.QTDE_ITEM >= '<<x_Uni_loja.qtde_saida>>'
AND B.CODIGO_ITEM = '<<x_Uni_loja.produto>>'
ORDER BY A.RECEBIMENTO,B.QTDE_ITEM DESC 
ENDTEXT

f_select(SelEntrada,"Tmp_Cur_Uni_loja")

sele Cur_Uni_loja
appe blank
replace nf_entrada         with Tmp_Cur_Uni_loja.nf_entrada
replace recebimento       with Tmp_Cur_Uni_loja.recebimento
replace nome_clifor         with Tmp_Cur_Uni_loja.nome_clifor
replace filial                     with Tmp_Cur_Uni_loja.filial
replace produto              with x_Uni_loja.produto
replace qtde_nf              with Tmp_Cur_Uni_loja.qtde_item
replace preco_unitario    with Tmp_Cur_Uni_loja.preco_unitario
replace taxa_imposto     with Tmp_Cur_Uni_loja.taxa_imposto
replace valor_imposto    with Tmp_Cur_Uni_loja.valor_imposto
replace nf_loja                with x_Uni_loja.nf_saida
replace loja                     with x_Uni_loja.filial
replace qtde_retirada     with x_Uni_loja.qtde_saida

EndScan

sele Cur_Uni_loja
go top
brow normal

return .f.
Scan
sele Cur_Uni_loja
if  empty(Cur_Uni_loja.nf_entrada)

TEXT TO SelEntrada TEXTMERGE NOSHOW

SELECT TOP 1 A.NF_ENTRADA,A.NOME_CLIFOR,A.FILIAL,B.CODIGO_ITEM AS PRODUTO,QTDE_ITEM,B.PRECO_UNITARIO,A.RECEBIMENTO
FROM ENTRADAS A
JOIN ENTRADAS_ITEM B
ON A.NF_ENTRADA = B.NF_ENTRADA
AND A.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA
AND A.NOME_CLIFOR = B.NOME_CLIFOR
WHERE A.NOME_CLIFOR NOT IN (SELECT FILIAL FROM FILIAIS WHERE TIPO_FILIAL = 'LOJA VAREJO')
AND A.FILIAL IN ('ATACADO FA')
AND A.NOME_CLIFOR IN (SELECT DISTINCT NOME_CLIFOR FROM PRODUCAO_RECURSOS UNION ALL SELECT 'K3X FABRICA') 
AND A.SERIE_NF_ENTRADA <> 'E1'
AND B.QTDE_ITEM >= '<<Cur_Uni_loja.qtde_retirada>>'
AND B.CODIGO_ITEM = '<<Cur_Uni_loja.produto>>'
ORDER BY B.QTDE_ITEM,A.RECEBIMENTO DESC

ENDTEXT

f_select(SelEntrada,"Tmp_Cur_Uni_loja")

sele Cur_Uni_loja
replace nf_entrada         with Tmp_Cur_Uni_loja.nf_entrada
replace nome_clifor         with Tmp_Cur_Uni_loja.nome_clifor
replace filial                     with Tmp_Cur_Uni_loja.filial
replace qtde_nf              with Tmp_Cur_Uni_loja.qtde_item
replace preco_unitario    with Tmp_Cur_Uni_loja.preco_unitario
replace recebimento       with Tmp_Cur_Uni_loja.recebimento

ENDIF
 sele Cur_Uni_loja
EndScan

Scan
sele Cur_Uni_loja
if  empty(Cur_Uni_loja.nf_entrada)

TEXT TO SelEntrada TEXTMERGE NOSHOW

SELECT TOP 1 A.NF_SAIDA,A.NOME_CLIFOR AS FILIAL,A.FILIAL AS NOME_CLIFOR,
QTDE_ITEM,B.PRECO_UNITARIO,A.SERIE_NF,A.EMISSAO,A.EMISSAO AS RECEBIMENTO
FROM FATURAMENTO A
JOIN FATURAMENTO_ITEM B
ON A.NF_SAIDA = B.NF_SAIDA
AND A.SERIE_NF = B.SERIE_NF
AND A.FILIAL = B.FILIAL
WHERE A.FILIAL IN ('RBX FABRICA','K3X FABRICA','TRIMIX FILIAL')
AND A.NOME_CLIFOR IN ('ESTOQUE CENTRAL','RBX DISTRIBUIDORA','ESTOQUE CENTRAL FA','TRIMIX')
AND A.SERIE_NF IN ('5','55')  
AND B.QTDE_ITEM >= '<<Cur_Uni_loja.qtde_retirada>>'
AND B.CODIGO_ITEM = '<<Cur_Uni_loja.produto>>'
ORDER BY B.QTDE_ITEM,A.EMISSAO DESC

ENDTEXT

f_select(SelEntrada,"Tmp_Cur_Uni_loja")

sele Cur_Uni_loja
replace nf_entrada         with Tmp_Cur_Uni_loja.nf_saida
replace nome_clifor         with Tmp_Cur_Uni_loja.nome_clifor
replace filial                     with Tmp_Cur_Uni_loja.filial
replace qtde_nf              with Tmp_Cur_Uni_loja.qtde_item
replace preco_unitario    with Tmp_Cur_Uni_loja.preco_unitario
replace recebimento       with Tmp_Cur_Uni_loja.recebimento

ENDIF
 sele Cur_Uni_loja
EndScan

sele  nf_entrada,nome_clifor as emitente,filial as destino,produto,qtde_retirada,qtde_nf,preco_unitario,recebimento from Cur_Uni_loja;
where !empty(nf_entrada) into cursor ANM_UNIFORMES_LOJA

SELE ANM_UNIFORMES_LOJA
COPY TO "c:\temp\UNIFORME_LOJAS.XLS" XLS 