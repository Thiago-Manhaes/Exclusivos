**-- Cliente : Animale
**-- Conteudo: Programação Para Impressora Datamax Allegro
**-------------------------------------------------------------------------------------------------------------------------**
**   1 2 11 002 0070 0010 DADO ENTER

**   | |  |   |    |    |
**   | |  |   |    |    +--> Coluna
**   | |  |   |    +-------> Linha
**   | |  |   +------------> Largura da Fonte
**   | |  +----------------> Altura  da Fonte
**   | +-------------------> Fonte
**   +---------------------> Rotação

Procedure Detalhe_Etiqueta

TEXT TO xsel NOSHOW TEXTMERGE
   SELECT 
   P.PRODUTO,
   CASE WHEN FX.VALOR_ATUAL IS NULL THEN '' 
   ELSE PS.DESC_PRODUTO_SEGMENTO 
   END SITUACAO_USO
   FROM PRODUTOS P 
   JOIN PRODUTOS_SEGMENTO PS 
   ON P.COD_PRODUTO_SEGMENTO = PS.COD_PRODUTO_SEGMENTO
   LEFT JOIN FX_ANM_PARAMETROS_REDE_LOJAS('ANM_ETIQ_BARRA_RL') FX
   ON P.REDE_LOJAS = FX.REDE_LOJAS 
   AND FX.VALOR_ATUAL = 1
   WHERE P.REDE_LOJAS = 1
   and P.PRODUTO=?vtmp_tabelas_preco_barra_00.PRODUTO
ENDTEXT
f_select(xsel, 'cur_segmento')


xCtrlB   = '' 
*xCtrlB   = CHR(128)
*xini     = xCtrlB + "L" + chr(13) + chr(10) + "SK" + chr(13) + chr(10) + "PG" + chr(13) + chr(10) + "D11" + chr(13) + chr(10) + "H14" + chr(13) + chr(10)
xini     = "SK" + chr(13) + chr(13) +  chr(10) + "PG" + chr(13) + chr(10) + "D11" + chr(13) +  chr(13) + chr(13) + chr(10) + "H14" + chr(13) + chr(10)
xfim     = "E" + chr(13) + chr(10)
xQtdeEti = "Q"+xqtdeetiq + chr(13) + chr(10)
xArqBmp  = "ANIMALE"  && Arquivo BMP (nome fixo, sua imagem deve ser ANIMALE.BMP)


*!*	*xCtrlB   = ''
*!*	xCtrlB   = CHR(128) 
*!*	xini     = xCtrlB + "L" + chr(13) + chr(10) + "SK" + chr(13) + chr(10) + "PG" + chr(13) + chr(10) + "D11" + chr(13) + chr(10) + "H14" + chr(13) + chr(10)
*!*	xfim     = "E" + chr(13) + chr(10)
*!*	xQtdeEti = "Q0001" + chr(13) + chr(10) 
*!*	xArqBmp  = "ANIMALE"  && Arquivo BMP (nome fixo, sua imagem deve ser ANIMALE.BMP)

store '' to x_Allegro

sele vtmp_tabelas_preco_barra_00
go top

xColA = 001
xColB = 187

xQtde = 0

do while !eof()

	store '' to xA1,xA2,xA3,xA4,xA5,xA6,xA7,xA8,xA9,xA10,xA11,xA12,xA13,xA14,xA15,xA16,xA17,xA18,xA19,xA20,xA21,xA22,xA23,;
				xB1,xB2,xB3,xB4,xB5,xB6,xB7,xB8,xB9,xB10,xB11,xB12,xB13,xB14,xB15,xB16,xB17,xB18,xB19,xB20,xB21,xB22,xB23,xB24
	
	for k = 65 to 66

		K_ = chr(k)
		xQtde = xQtde + 1
		xBarra = allt(vtmp_tabelas_preco_barra_00.codigo_barra)
		xSegmento = ALLTRIM(cur_segmento.situacao_uso)
		
		x&K_.1  = "1Y110400240"+f_StrZero(xCol&K_+005,4) + xArqBmp + chr(13) + chr(10)
 		x&K_.2  = "1X110010196"+f_StrZero(xCol&K_+005,4) + "B150033002002" + chr(13) + chr(10)
	*!* x&K_.3  = "19010010235"+f_StrZero(xCol&K_+020,4) + "DATA DA VENDA:" + chr(13) + chr(10)
	*!* x&K_.4  = "19010010225"+f_StrZero(xCol&K_+020,4) + "NUMERO DA VEND:" + chr(13) + chr(10)
		x&K_.5  = "19010010217"+f_StrZero(xCol&K_+029,4) + "TROCA SOMENTE COM" + chr(13) + chr(10)
		x&K_.6  = "19010010207"+f_StrZero(xCol&K_+043,4) + "ESTA ETIQUETA" + chr(13) + chr(10)
		x&K_.7  = "19010010198"+f_StrZero(xCol&K_+028,4) + "PRAZO MAXIMO 15 DIAS" + chr(13) + chr(10)
		x&K_.8  = "19010010185"+f_StrZero(xCol&K_+002,4) + subs(allt(vtmp_tabelas_preco_barra_00.desc_produto),01,20) + chr(13) + chr(10)
		x&K_.9  = "19010010177"+f_StrZero(xCol&K_+002,4) + left(vtmp_tabelas_preco_barra_00.desc_cor_produto,10) + "   " + left(vtmp_tabelas_preco_barra_00.nome_tamanho,2) + "   " + subs(allt(vtmp_tabelas_preco_barra_00.codigo_barra),01,14) + chr(14) + chr(10)
		x&K_.10 = "1E120200147"+f_StrZero(xCol&K_+002,4) + 'C' + subs(xBarra,1,12) + '&E' + subs(xBarra,13,len(xBarra)) + chr(13) + chr(10)
		x&K_.11 = "49010010155"+f_StrZero(xCol&K_+165,4) + xSegmento + chr(13)

		x&K_.12 = "19010010134"+f_StrZero(xCol&K_+002,4) + subs(allt(vtmp_tabelas_preco_barra_00.desc_produto),01,20) + chr(13) + chr(10)
		x&K_.13 = "19010010124"+f_StrZero(xCol&K_+002,4) + left(vtmp_tabelas_preco_barra_00.desc_cor_produto,10) + "   " + left(vtmp_tabelas_preco_barra_00.nome_tamanho,2) + "   " + subs(allt(vtmp_tabelas_preco_barra_00.codigo_barra),01,14) + chr(14) + chr(10)
		x&K_.14 = "1E120200096"+f_StrZero(xCol&K_+002,4) + 'C' + subs(xBarra,1,12) + '&E' + subs(xBarra,13,len(xBarra)) + chr(13) + chr(10)
	    x&K_.15 = "49010010001"+f_StrZero(xCol&K_+150,4) + 'R$'+transf(vtmp_tabelas_preco_barra_00.preco1,' 9999.99') + chr(13)
*!*     x&K_.14 = "49010010002"+f_StrZero(xCol&K_+155,4) + 'ATA' + chr(13)

		x&K_.16 = "19010010084"+f_StrZero(xCol&K_+002,4) + subs(allt(vtmp_tabelas_preco_barra_00.desc_produto),01,20) + chr(13) + chr(10)
		x&K_.17 = "19010010074"+f_StrZero(xCol&K_+002,4) + left(vtmp_tabelas_preco_barra_00.desc_cor_produto,10) + "   " + left(vtmp_tabelas_preco_barra_00.nome_tamanho,2) + "   " + subs(allt(vtmp_tabelas_preco_barra_00.grupo_produto),01,10) + chr(13) + chr(10)
		x&K_.18 = "1E120200046"+f_StrZero(xCol&K_+002,4) + 'C' + subs(xBarra,1,12) + '&E' + subs(xBarra,13,len(xBarra)) + chr(13) + chr(10)
	    x&K_.19 = "49010010050"+f_StrZero(xCol&K_+150,4) + 'R$'+transf(vtmp_tabelas_preco_barra_00.preco1,' 9999.99') + chr(13)
 *!*    x&K_.18 = "49010010053"+f_StrZero(xCol&K_+155,4) + 'ATA' + chr(13)

		x&K_.20 = "19010010034"+f_StrZero(xCol&K_+002,4) + subs(allt(vtmp_tabelas_preco_barra_00.desc_produto),01,20) + chr(13) + chr(10)
		x&K_.21 = "19010010026"+f_StrZero(xCol&K_+002,4) + left(vtmp_tabelas_preco_barra_00.desc_cor_produto,10) + "   " + left(vtmp_tabelas_preco_barra_00.nome_tamanho,2) + "   " + subs(allt(vtmp_tabelas_preco_barra_00.grupo_produto),01,10) + chr(13) + chr(10)

		x&K_.22 = "1E120200000"+f_StrZero(xCol&K_+002,4) + 'C' + subs(xBarra,1,12) + '&E' + subs(xBarra,13,len(xBarra)) + chr(13) + chr(10)
        x&K_.23 = "49010010103"+f_StrZero(xCol&K_+150,4) + 'R$'+transf(vtmp_tabelas_preco_barra_00.preco1,' 9999.99') + chr(13)
   *!*  x&K_.22 = "49010010106"+f_StrZero(xCol&K_+165,4) + 'ATA' + chr(13)
	    x&K_.24 = "19010010101"+f_StrZero(xCol&K_+110,4) + '' + chr(13)


		if xQtde >= vtmp_tabelas_preco_barra_00.qtde_etiquetas
			skip
			xQtde = 0
		endif

		if eof()
			exit
		endif

	endfor

	x_Allegro = x_Allegro + xini +xA1+xA2+xA3+xA4+xA5+xA6+xA7+xA8+xA9+xA10+xA11+xA12+xA13+xA14+xA15+xA16+xA17+xA18+xA19+xA20+xA21+xA22+xA23+xA24+;
								 +xB1+xB2+xB3+xB4+xB5+xB6+xB7+xB8+xB9+xB10+xB11+xB12+xB13+xB14+xB15+xB16+xB17+xB18+xB19+xB20+xB21+xB22+xB23+xB24;
	                			 +xQtdeEti+xfim
               
enddo

Return(allt(x_Allegro))
*---------------------------------------------------------------------------------------------------------------------------*
