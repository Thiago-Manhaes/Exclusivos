define class obj_entrada as custom
	procedure metodo_usuario
		lparam xmetodo, xobjeto ,xnome_obj
	*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
			do case
				CASE UPPER(xmetodo) == 'USR_INIT'
					
					Thisformset.p_auditoria = ''
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					xalias = alias()
					
						with thisformset.lx_form1
							.lx_pageframe1.page2.addobject("tx_codigo_barras","tx_codigo_barras")
							.lx_pageframe1.page2.addobject("lb_codigo_barra","lb_codigo_barra")  
							.Cnt_Tipo_Digitacao.Ck_op_por_digitacao.Value=1
						endwith	

					if !f_vazio(xalias)
						sele &xalias
					endif				
				
				case upper(xmetodo) == 'USR_TX_ORDEM_PRODUCAO' AND UPPER(xnome_obj)=='TX_ORDEM_PRODUCAO'
					
					xalias = alias()
						
						f_select("Select FILIAL From PRODUCAO_ORDEM Where ORDEM_PRODUCAO = ?v_producao_os_02_anterior.ORDEM_PRODUCAO","CurFilOP",ALIAS())
						SELECT v_producao_os_02_anterior
						GO TOP
						SCAN
							Replace FILIAL WITH CurFilOP.FILIAL
						ENDSCAN
						GO TOP	
						
						IF thisformset.pp_ANM_OS_CODIGO_BARRA
							IF thisformset.lx_FORM1.Cnt_Tipo_Digitacao.Ck_op_por_digitacao.Value=1 
								thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.Visible = .T.
								thisformset.lx_FORM1.lx_pageframe1.page2.lb_codigo_barra.Visible = .T. 
								thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.Col_tx_QTDE_A.Lx_grade48_1.Enabled= .F. 
								thisformset.lx_FORM1.lx_pageframe1.page1.LX_grid_filha1.Col_tx_QTDE_O.Lx_grade48_1.Enabled= .F.
							ELSE
								thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.Visible = .F. 
							ENDIF
							
							sele v_producao_os_02_anterior
							GO TOP
							SCAN

								FOR i=1 TO 48
									xGrade = "A"+ALLTRIM(STR(i))
									REPLACE &xGrade WITH 0
								NEXT

							sele v_producao_os_02_anterior
							ENDSCAN
							
							sele v_producao_os_02_anterior
							GO TOP	
							
							Thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.setfocus()
							
							RETURN .T.
						ENDIF
						
					if !f_vazio(xalias)
						sele &xalias
					endif	
					
					
				case upper(xmetodo) == 'USR_VALID' AND UPPER(xnome_obj)=='TX_CODIGO_BARRAS'
			
					IF !EMPTY(thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.value)
						
						xCodigoBarra = ALLTRIM(thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.value)
						f_select("SELECT PRODUTO,COR_PRODUTO,'A'+RTRIM(CONVERT(CHAR(2),TAMANHO)) AS GRADE FROM PRODUTOS_BARRA WHERE CODIGO_BARRA =?xCodigoBarra","xTmpGrade")

						IF RECCOUNT() > 0 
						sele v_producao_os_02_anterior
						LOCATE FOR COR_PRODUTO = xTmpGrade.cor_produto AND PRODUTO = xTmpGrade.produto
							IF !EOF()
														
								xComando = "v_producao_os_02_anterior."+xTmpGrade.grade
								xGrade = xTmpGrade.grade
								sele v_producao_os_02_anterior
								REPLACE &xGrade WITH evaluate(xComando)+1
								
								If !ThisFormSet.Lx_Valida_Qtde_Op()
									REPLACE &xGrade WITH evaluate(xComando)-1
									Thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.value=""
									Thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.Col_tx_QTDE_A.Lx_grade48_1.l_desenhista_recalculo()
									return .f.
								EndIf
							ELSE
								MESSAGEBOX("Produto\Cor não encontrado na Ordem de serviço!",48)
								RETURN .F.
							ENDIF	
						ELSE
							MESSAGEBOX("Código de Barras não encontrado no cadastro de Produtos!",48)
							RETURN .F.
						ENDIF	
					
						thisformset.lx_FORM1.lx_pageframe1.page2.tx_codigo_barras.value = ""
						thisformset.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.Col_tx_QTDE_A.Lx_grade48_1.L_desenhista_recalculo()
						
						RETURN .F.
										
					ENDIF		
					
					
						
				otherwise
				return .t.				
			endcase
	endproc
ENDDEFINE

**************************************************
*-- Class:        tx_codigo_barras(c:\temp\tx_codigo_barras.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_codigo_barras AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 254
	TabIndex = 11
	Top = 62
	Width = 250
	ZOrderSet = 8
	Name = "tx_codigo_barras"
	Enabled=.T.
	Visible=.F.


ENDDEFINE
*
*-- EndDefine: tx_codigo_barras
**************************************************

**************************************************
*-- Class:        lb_codigo_barra (p:\tmpsid\entradas_rbx\lb_codigo_barra .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_codigo_barra AS lx_label


	Caption = "Cod. Barra"
	Height = 15
	Left = 197
	Top = 63
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_codigo_barra "
	Visible = .F.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_codigo_barra 
**************************************************