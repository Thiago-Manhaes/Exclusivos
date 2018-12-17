USE [TESTE_SOMA]
GO

/****** Object:  View [dbo].[W_ENTRADAS_MATERIAIS]    Script Date: 19/07/2016 18:08:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [dbo].[W_ENTRADAS_MATERIAIS]

AS

-- 27/11/2008 - Fabiano Banin - Altera��o da tabela de condi��o de pagamentos, estava pegando a de vendas no lugar da de compras.

-- 29/06/2007 - Fabiano Banin - Cria��o da view para agilizar n�o sobrecarregar a view do fox.

SELECT ENTRADAS.NF_ENTRADA, ENTRADAS.SERIE_NF_ENTRADA, ENTRADAS.PORC_DESCONTO, ENTRADAS.PORC_ENCARGO, ENTRADAS.MOEDA, ENTRADAS.DESCONTO, 

       ENTRADAS.VALOR_TOTAL, ENTRADAS.DESCONTO_BRUTO, VENDAS.DESCONTO_COND_PGTO, ENTRADAS.EMISSAO,

       -- INCLUIDO DATA_DIGITACAO - #ANIMALE

       ENTRADAS.DATA_DIGITACAO, 

       ENTRADAS.CONDICAO_PGTO, ENTRADAS.NATUREZA, 

       ENTRADAS.RECEBIMENTO, ENTRADAS.TRANSPORTADORA_A_PAGAR, ENTRADAS.EMPRESA, ENTRADAS.TIPO_ENTRADAS, 

       ( CASE WHEN ENTRADAS.SERIE_NF_ENTRADA <> DBO.FX_PARAMETRO('TIPO_PRODUCAO') 

            THEN ESTOQUE_RET1_MAT.VALOR 

            ELSE CONVERT(NUMERIC(14, 2), 0) 

         END ) AS MPADRAO_VALOR, 

       CONVERT(NUMERIC(14, 2), ( CASE WHEN ENTRADAS.SERIE_NF_ENTRADA <> DBO.FX_PARAMETRO('TIPO_PRODUCAO') 

                                    THEN ( ESTOQUE_RET1_MAT.VALOR - 

                                           ( ESTOQUE_RET1_MAT.VALOR * ENTRADAS.PORC_DESCONTO / 100 ) + 

                                           ( ESTOQUE_RET1_MAT.VALOR * ENTRADAS.PORC_ENCARGO / 100 ) ) 

                                    ELSE 0 

                                 END )) AS MPADRAO_VALOR_LIQUIDO, ESTOQUE_RET_MAT.NOME_CLIFOR, ESTOQUE_RET_MAT.FILIAL AS FILIAL_ARMAZEM, 

       ESTOQUE_RET1_MAT.ENTREGA_PEDIDO, MATERIAIS.DESC_MATERIAL, ESTOQUE_RET1_MAT.PEDIDO, ESTOQUE_RET1_MAT.MATERIAL, ESTOQUE_RET1_MAT.COR_MATERIAL, 

       ESTOQUE_RET1_MAT.ITEM, ESTOQUE_RET1_MAT.QTDE, ESTOQUE_RET1_MAT.DESCONTO_ITEM AS MPADRAO_DESCONTO_ITEM, 

       ESTOQUE_RET1_MAT.CUSTO_MATERIA_PRIMA AS MPADRAO_PRECO, MATERIAIS.COLECAO, MATERIAIS.GRUPO, MATERIAIS.SUBGRUPO, MATERIAIS.REVENDA, 

       MATERIAIS.FABRICANTE, MATERIAIS.REF_FABRICANTE, MATERIAIS.REF_FABRICANTE AS REFER_FABRICANTE, MATERIAIS_CORES.DESC_COR_MATERIAL, 

       COND_ENT_PGTOS.DESC_COND_PGTO, NATUREZAS_ENTRADAS.DESC_NATUREZA, NATUREZAS_ENTRADAS.CTB_TIPO_OPERACAO, 

       CTB_LX_TIPO_OPERACAO.DESC_TIPO_OPERACAO, CTB_LX_TIPO_OPERACAO.TIPO_OPERACAO, VENDAS.COLECAO AS COLECAO_VENDA, VENDAS.TIPO, 

       SERIES_NF.DESCRICAO AS DESCRICAO_SERIE_NF, CTB_LX_GRUPO_TIPO_OPERACAO.DESC_GRUPO_TIPO_OPERACAO, 

       FILIAIS_ARMAZEM.COD_FILIAL AS COD_FILIAL_ARMAZEM, CADASTRO_CLI_FOR.CLIFOR, COLECOES.DESC_COLECAO, 

       COLECAO_VENDAS.DESC_COLECAO AS DESC_COLECAO_VENDA, ENTRADAS.CAMBIO_NA_DATA, 

       CONVERT(NUMERIC(14, 2), ( ESTOQUE_RET1_MAT.CUSTO_MATERIA_PRIMA * 

                                 POWER(CONVERT(REAL, ( CASE WHEN ISNULL(ENTRADAS.CAMBIO_NA_DATA, 0) = 0 

                                                          THEN 1 

                                                          ELSE ENTRADAS.CAMBIO_NA_DATA 

                                                       END )), ( W_MOEDAS_CONVERSAO.FATOR_CAMBIO * -1 )))) AS CUSTO, 

       CONVERT(NUMERIC(14, 2), ( ESTOQUE_RET1_MAT.DESCONTO_ITEM * 

                                 POWER(CONVERT(REAL, ( CASE WHEN ISNULL(ENTRADAS.CAMBIO_NA_DATA, 0) = 0 

                                                          THEN 1 

                                                          ELSE ENTRADAS.CAMBIO_NA_DATA 

                                                       END )), ( W_MOEDAS_CONVERSAO.FATOR_CAMBIO * -1 )))) AS DESCONTO_ITEM, 

       CONVERT(NUMERIC(14, 2), ( CASE WHEN ENTRADAS.SERIE_NF_ENTRADA <> DBO.FX_PARAMETRO('TIPO_PRODUCAO') 

                                    THEN ESTOQUE_RET1_MAT.VALOR 

                                    ELSE CONVERT(NUMERIC(14, 2), 0) 

                                 END ) * POWER(CONVERT(REAL, ( CASE WHEN ISNULL(ENTRADAS.CAMBIO_NA_DATA, 0) = 0 

                                                                  THEN 1 

                       ELSE ENTRADAS.CAMBIO_NA_DATA 

                                                               END )), ( W_MOEDAS_CONVERSAO.FATOR_CAMBIO * -1 ))) AS VALOR, 

       CONVERT(NUMERIC(14, 2), ( CASE WHEN ENTRADAS.SERIE_NF_ENTRADA <> DBO.FX_PARAMETRO('TIPO_PRODUCAO') 

                                    THEN CONVERT(NUMERIC(14, 2), ( ( ESTOQUE_RET1_MAT.VALOR - 

                                                                     ( ESTOQUE_RET1_MAT.VALOR * ENTRADAS.PORC_DESCONTO / 100 ) + 

                                                                     ( ESTOQUE_RET1_MAT.VALOR * ENTRADAS.PORC_ENCARGO / 100 ) ) * 

                                                                   POWER(CONVERT(REAL, ( CASE WHEN ISNULL(ENTRADAS.CAMBIO_NA_DATA, 0) = 0 

                                                                                            THEN 1 

                                                                                            ELSE ENTRADAS.CAMBIO_NA_DATA

                                                                                         END )), ( W_MOEDAS_CONVERSAO.FATOR_CAMBIO * -1 )) ))

                                    ELSE 0 

                                 END )) AS VALOR_LIQUIDO, MATERIAIS.SETOR_PRODUCAO, MATERIAIS.FASE_PRODUCAO, MATERIAIS.TIPO AS TIPO_MATERIAL, 

       ESTOQUE_RET1_MAT.REQ_MATERIAL, VENDAS.TRANSPORTADORA, ENTRADAS.FILIAL AS FILIAL_ENTRADA, FILIAL_ENTRADA.COD_FILIAL AS COD_FILIAL_ENTRADA, 

       CONVERT(NUMERIC(14, 2), 0) AS VALOR_PRODUCAO, CONVERT(NUMERIC(14, 2), 0) AS VALOR_VQ 

	   -- #1 - ANM.LUCAS MIRANDA -- 18/07/2016
	   -- INCLUIDA NOVO CAMPO PUXANDO A COLECAO DO PEDIDO DE COMPRA DE MP PARA A TELA 005114 - CONSULTA ENTRADA NOTAS FISCAIS DE MATERIAIS
	   , ISNULL(COMPRAS.COLECAO,'') AS COLECAO_COMPRA
FROM ENTRADAS 

     INNER JOIN ESTOQUE_RET_MAT ON ENTRADAS.NF_ENTRADA = ESTOQUE_RET_MAT.NF_ENTRADA AND 

                                   ENTRADAS.SERIE_NF_ENTRADA = ESTOQUE_RET_MAT.SERIE_NF_ENTRADA AND 

                                   ENTRADAS.NOME_CLIFOR = ESTOQUE_RET_MAT.NOME_CLIFOR 

     INNER JOIN ESTOQUE_RET1_MAT ON ESTOQUE_RET_MAT.FILIAL = ESTOQUE_RET1_MAT.FILIAL AND 

                                    ESTOQUE_RET_MAT.REQ_MATERIAL = ESTOQUE_RET1_MAT.REQ_MATERIAL 

     LEFT JOIN MATERIAIS ON ESTOQUE_RET1_MAT.MATERIAL = MATERIAIS.MATERIAL 

     LEFT JOIN MATERIAIS_CORES ON ESTOQUE_RET1_MAT.MATERIAL = MATERIAIS_CORES.MATERIAL AND 

                                  ESTOQUE_RET1_MAT.COR_MATERIAL = MATERIAIS_CORES.COR_MATERIAL 

     LEFT JOIN COND_ENT_PGTOS ON ENTRADAS.CONDICAO_PGTO = COND_ENT_PGTOS.CONDICAO_PGTO 

     LEFT JOIN NATUREZAS_ENTRADAS ON ENTRADAS.NATUREZA = NATUREZAS_ENTRADAS.NATUREZA 

     LEFT JOIN CTB_LX_TIPO_OPERACAO ON NATUREZAS_ENTRADAS.CTB_TIPO_OPERACAO = CTB_LX_TIPO_OPERACAO.CTB_TIPO_OPERACAO 

     LEFT JOIN CTB_LX_GRUPO_TIPO_OPERACAO ON CTB_LX_TIPO_OPERACAO.TIPO_OPERACAO = CTB_LX_GRUPO_TIPO_OPERACAO.TIPO_OPERACAO 

     LEFT JOIN VENDAS ON ESTOQUE_RET1_MAT.PEDIDO = VENDAS.PEDIDO 

     LEFT JOIN SERIES_NF ON ENTRADAS.SERIE_NF_ENTRADA = SERIES_NF.SERIE_NF 

     LEFT JOIN FILIAIS AS FILIAIS_ARMAZEM ON ESTOQUE_RET_MAT.FILIAL = FILIAIS_ARMAZEM.FILIAL 

     LEFT JOIN CADASTRO_CLI_FOR ON ENTRADAS.NOME_CLIFOR = CADASTRO_CLI_FOR.NOME_CLIFOR 

     LEFT JOIN COLECOES ON MATERIAIS.COLECAO = COLECOES.COLECAO 

     LEFT JOIN COLECOES COLECAO_VENDAS ON VENDAS.COLECAO = COLECAO_VENDAS.COLECAO 

     LEFT JOIN W_MOEDAS_CONVERSAO ON ENTRADAS.MOEDA = W_MOEDAS_CONVERSAO.MOEDA 

     INNER JOIN FILIAIS AS FILIAL_ENTRADA ON ENTRADAS.FILIAL = FILIAL_ENTRADA.FILIAL

	 -- #1 - ANM.LUCAS MIRANDA -- 18/07/2016
	 -- INCLUIDA NOVO CAMPO PUXANDO A COLECAO DO PEDIDO DE COMPRA DE MP PARA A TELA 005114 - CONSULTA ENTRADA NOTAS FISCAIS DE MATERIAIS
	 LEFT JOIN COMPRAS ON ESTOQUE_RET1_MAT.PEDIDO = COMPRAS.PEDIDO AND COMPRAS.TABELA_FILHA = 'COMPRAS_MATERIAL'

GO


