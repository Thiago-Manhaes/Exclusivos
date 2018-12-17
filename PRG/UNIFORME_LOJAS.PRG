TEXT TO CriaCursorVazio TEXTMERGE NOSHOW

SELECT A.NF_ENTRADA,A.NOME_CLIFOR,A.FILIAL,B.CODIGO_ITEM AS PRODUTO,CONVERT(INT,'') AS QTDE_RETIRADA,QTDE_ITEM AS QTDE_NF,
B.PRECO_UNITARIO,A.RECEBIMENTO
FROM ENTRADAS A
JOIN ENTRADAS_ITEM B
ON A.NF_ENTRADA = B.NF_ENTRADA
AND A.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA
AND A.NOME_CLIFOR = B.NOME_CLIFOR
WHERE 1 = 2

ENDTEXT

f_select(CriaCursorVazio,"Cur_Uni_loja")

TEXT TO xSelUniLoja TEXTMERGE NOSHOW

SELECT A.PRODUTO,B.DESC_PRODUTO,SUM(A.QTDE_ENTRADA) AS TOTAL_ENTRADA
FROM LOJA_ENTRADAS_PRODUTO A 
JOIN PRODUTOS B
ON A.PRODUTO = B.PRODUTO 
WHERE A.FILIAL = 'UNIFORME LOJAS'
GROUP BY A.PRODUTO,B.DESC_PRODUTO

ENDTEXT

f_select(xSelUniLoja,"x_Uni_loja")

sele x_Uni_loja
go top
Scan
sele x_Uni_loja

TEXT TO SelEntrada TEXTMERGE NOSHOW

SELECT TOP 1 A.NF_ENTRADA,A.NOME_CLIFOR,A.FILIAL,B.CODIGO_ITEM AS PRODUTO,QTDE_ITEM,B.PRECO_UNITARIO,A.RECEBIMENTO
FROM ENTRADAS A
JOIN ENTRADAS_ITEM B
ON A.NF_ENTRADA = B.NF_ENTRADA
AND A.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA
AND A.NOME_CLIFOR = B.NOME_CLIFOR
WHERE A.NOME_CLIFOR NOT IN (SELECT FILIAL FROM FILIAIS WHERE TIPO_FILIAL = 'LOJA VAREJO')
AND A.FILIAL IN ('ESTOQUE CENTRAL','RBX DISTRIBUIDORA')
AND A.NOME_CLIFOR IN (SELECT DISTINCT NOME_CLIFOR FROM PRODUCAO_RECURSOS UNION ALL SELECT 'RBX FABRICA'  UNION ALL SELECT 'TRIMIX') 
AND A.SERIE_NF_ENTRADA <> 'E1'
AND B.QTDE_ITEM >= '<<x_Uni_loja.total_entrada>>'
AND B.CODIGO_ITEM = '<<x_Uni_loja.produto>>'
ORDER BY B.QTDE_ITEM,A.RECEBIMENTO DESC

ENDTEXT

f_select(SelEntrada,"Tmp_Cur_Uni_loja")

sele Cur_Uni_loja
appe blank
replace nf_entrada         with Tmp_Cur_Uni_loja.nf_entrada
replace nome_clifor         with Tmp_Cur_Uni_loja.nome_clifor
replace filial                     with Tmp_Cur_Uni_loja.filial
replace produto              with x_Uni_loja.produto
replace qtde_retirada     with x_Uni_loja.total_entrada
replace qtde_nf              with Tmp_Cur_Uni_loja.qtde_item
replace preco_unitario    with Tmp_Cur_Uni_loja.preco_unitario
replace recebimento       with Tmp_Cur_Uni_loja.recebimento

EndScan

sele Cur_Uni_loja
go top

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