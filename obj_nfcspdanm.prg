* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao Filtros Custom	/ Pesquisa por Vale vendido					                    *
********************************************************************************************************************* 

* Alteração ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Criação de Objeto de Entrada                                                                    *
********************************************************************************************************************* 
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
********************************************************************************************************************* 
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento *
********************************************************************************************************************* 
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
********************************************************************************************************************* 

define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.

	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT  												=> NA INICIALIZACAO DA TELA 
		*	USR_ALTER_BEFORE  -> Return .f. Para o Metodo 			=> ANTES DA ALTERACAO ,AO CLICKAR ANTES DE LIBERAR OS CAMPOS
		*	USR_ALTER_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO   
		*	USR_INCLUDE_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO
		*	USR_SEARCH_BEFORE -> Return .f. Para o Metodo PESQUISA	=> ANTES DE FAZER A PESQUISA NO BANCO
		*	USR_SEARCH_AFTER										=> APOS FAZER A PESQUISA NO BANCO
		*	USR_CLEAN_AFTER 										=> APOS LIMPAR A TELA 
		*	USR_REFRESH                                             => 
		*	USR_SAVE_BEFORE   -> Return .f. Para o Metodo 			=> SALVAR ANTES DE JOGAR INFORMACOES NO BANCO
		*	USR_SAVE_AFTER                                          => APOS SALVAR AS INFORMACOES    NO BANCO
		*	USR_ITEN_DELETE_BEFORE -> Return .f. Para o Metodo 		=> ANTES DE EXCLUIR ITEN NA TABELA FILHA '+'
		*	USR_ITEN_DELETE_AFTER                                   => APOS DELETAR UM ITEM NA TABELA FILHA '-' 
		*	USR_ITEN_INCLUDE_BEFORE -> Return .f. Para o Metodo 	=> ANTES DE INCLUIR ITEM NA TABELA FILHA
		*	USR_ITEN_INCLUDE_AFTER									=> APOS INCLUIR ITEM NA TABELA FILHA 
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback ANTES DE EXECUTAR UMA TRIGGER
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Validação
		*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada

		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
				
				case upper(xmetodo) == 'USR_INIT'
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 

				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_loja_venda_02
				sele v_loja_venda_02
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("LOJA_VENDA_PGTO.NUMERO_CUPOM_FISCAL AS NUMERO_CONTROLE", "C(8)",.F., "NUMERO_CONTROLE", "LOJA_VENDA_PGTO.NUMERO_CUPOM_FISCAL")				
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 		
					
					
					public	xpai_filtro,xdata_ini,xdata_fim,xvale 
					xpai_filtro = thisformset.p_pai_filtro
					xdata_ini   = ctod('')
					xdata_fim   = ctod('') 
					xvale       = "     "   
					
					with thisform.lx_PAGEFRAME1.page1	
						.addobject("lb_data_venda","lb_data_venda")
						.addobject("tx_data_ini","tx_data_ini")						
						.addobject("tx_data_fim","tx_data_fim")						
						.addobject("lb_vale","lb_vale")		
						.addobject("tx_vale","tx_vale")	
						.addobject("tx_cupom","tx_cupom")
						.addobject("ck_cartoes_pos","ck_cartoes_pos") 													
					endwith	

					
					with thisformset.lx_form1.lx_PAGEFRAME1 
						.PageCount=thisform.lx_PAGEFRAME1.PageCount+1
						.page5.FontName =thisform.lx_PAGEFRAME1.page1.FontName
						.page5.FontSize =thisform.lx_PAGEFRAME1.page1.FontSize
						.page5.Caption="Filtros Custom"
						.page5.addobject("lb_filial","lb_filial")
						.page5.addobject("cmdadd","cmdadd")
						.page5.addobject("cmdaddall","cmdaddall")						
						.page5.addobject("cmdremove","cmdremove")
						.page5.addobject("cmdremoveall","cmdremoveall")						
					endwith	


					addnewobject(thisformset.lx_form1.lx_PAGEFRAME1.page5,"lstsource","lstsource")		
					addnewobject(thisformset.lx_form1.lx_PAGEFRAME1.page5,"lstSelected","lstSelected")	
					addnewobject(thisformset.lx_form1.lx_PAGEFRAME1.page5,"line1","line1")					



					with thisformset.lx_form1.lx_PAGEFRAME1.page5
						if .lstSelected.listcount = 0
							if f_select("select filial,codigo_filial from lojas_varejo order by codigo_filial","curSelect")
								.lstsource.clear
								.lstSelected.clear
								scan
									.lstsource.additem(codigo_filial+" - "+filial, recno(), 1)
									.lstsource.addlistitem(codigo_filial, recno(), 2)
								endscan
								.refresh()
								use
							endif
						endif
					endwith	
					

					THISFORMSET.L_LIMPA()




				case upper(xmetodo) == 'USR_SEARCH_BEFORE' 

					xfiltro_filial=""


					if thisformset.lx_form1.lx_PAGEFRAME1.page5.lstSelected.listcount>0

						for i = 1 to thisformset.lx_form1.lx_PAGEFRAME1.page5.lstSelected.listcount
							xfiltro_filial= xfiltro_filial + "'"+allt(thisformset.lx_form1.lx_PAGEFRAME1.page5.lstSelected.list(i,2))+"',"
						next
						xfiltro_filial = left(xfiltro_filial, len(xfiltro_filial)-1)
						
						if	f_vazio(Thisformset.p_pai_filtro)
							thisformset.p_pai_filtro =thisformset.p_pai_filtro +" LOJA_VENDA.CODIGO_FILIAL in ("+xfiltro_filial+") "
						else	
							thisformset.p_pai_filtro =thisformset.p_pai_filtro +" and LOJA_VENDA.CODIGO_FILIAL in ("+xfiltro_filial+") "
						endif	
							
					endif	


					if	!f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_ini.value) and f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_fim.value)
						messagebox("A data Fim não pode ser Vazia!",48,"Atenção!")
						retu .f.
					endif
					

					if	!f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_fim.value) and f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_ini.value)
						messagebox("A data Início não pode ser Vazia!",48,"Atenção!")
						retu .f.
					endif	
										
					
					if	!f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_ini.value) and !f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_fim.value)

						if	f_vazio(Thisformset.p_pai_filtro)
							thisformset.p_pai_filtro =thisformset.p_pai_filtro +" LOJA_VENDA.DATA_VENDA BETWEEN '"+dtos(xdata_ini)+"' and '"+dtos(xdata_fim)+"'"
						else	
							thisformset.p_pai_filtro =thisformset.p_pai_filtro +" and LOJA_VENDA.DATA_VENDA BETWEEN '"+dtos(xdata_ini)+"' and '"+dtos(xdata_fim)+"'"
						endif	
							
					endif	


					if	!f_vazio(thisform.lx_PAGEFRAME1.page1.tx_vale.value) 

						if	f_vazio(Thisformset.p_pai_filtro)
							thisformset.p_pai_filtro =thisformset.p_pai_filtro +" LOJA_VENDA.TICKET+LOJA_VENDA.CODIGO_FILIAL+CONVERT(VARCHAR(13),LOJA_VENDA.DATA_VENDA,112) IN " + ;
							"( select distinct ticket+codigo_filial+convert(varchar(13),data_venda,112) from loja_venda_produto where codigo_barra='"+xvale+"' )"
						else	
							thisformset.p_pai_filtro =thisformset.p_pai_filtro +" AND LOJA_VENDA.TICKET+LOJA_VENDA.CODIGO_FILIAL+CONVERT(VARCHAR(13),LOJA_VENDA.DATA_VENDA,112) IN " + ;
							"( select distinct ticket+codigo_filial+convert(varchar(13),data_venda,112) from loja_venda_produto where codigo_barra='"+xvale+"' )" 
						endif	
							
					endif	




				case upper(xmetodo) == 'USR_SEARCH_AFTER' 
					
					*PROCEDIMENTO ALTERACAO NUMERO VALE
					thisformset.lx_form1.lx_PAGEFRAME1.page2.LX_grid_filha1.Col_tx_CODIGO_BARRA.Tx_CODIGO_BARRA.Enabled =.T.

					*FIM PROCEDIMENTO ALTERACAO NUMERO VALE




				case upper(xmetodo) == 'USR_VALID' 
					
					xalias=alias()

					*PROCEDIMENTO ALTERACAO NUMERO VALE					
					IF upper(xnome_obj) =='TX_CODIGO_BARRA' 	
						
						If messagebox("Deseja Corrigir o nº do vale ?",4+32+256,"Atenção!")=6
							
							if v_loja_venda_02_produto.produto !='99.99.9999' 
								messagebox("Esta Alteração é permitida somente para Vales!",48,"Atenção!!!")
								retu .f.	
							endif	
							

							text to	xsel noshow textmerge	
								
								select codigo_barra from produtos_barra where produto='99.99.9999' 
								and codigo_barra='<<v_loja_venda_02_produto.codigo_barra>>'	

							endtext		
							
							f_select(xsel,"curValeExist")
							
							sele curValeExist 
							if reccount()=0

								messagebox("Não Existe Vale com este nº no Banco de Dados!",48,"Atenção!!!")
								retu .f.	
							
							else	

								text to	xupdate noshow textmerge	

									update a 
									set a.codigo_barra='<<v_loja_venda_02_produto.codigo_barra>>' 
									from loja_venda_produto a 
									join loja_venda b 
									on a.codigo_filial=b.codigo_filial 
									and a.data_venda=b.data_venda 
									and a.ticket=b.ticket 
									where a.codigo_filial='<<v_loja_venda_02_produto.codigo_filial>>' 
									and a.ticket='<<v_loja_venda_02_produto.ticket>>' 
									and a.data_venda='<<v_loja_venda_02_produto.data_venda>>'
									and a.item='<<v_loja_venda_02_produto.item>>'
								
								endtext								
								
								if !f_update(xupdate) 
									messagebox("Não foi possível corrigir nº do Vale")
								endif	

							
							endif	
						
						Else	

							text to xsel noshow	textmerge	
							 						
								select a.codigo_barra from loja_venda_produto a 
								join loja_venda b 
								on a.codigo_filial=b.codigo_filial 
								and a.data_venda=b.data_venda 
								and a.ticket=b.ticket 
								where a.codigo_filial='<<v_loja_venda_02_produto.codigo_filial>>'  
								and a.ticket='<<v_loja_venda_02_produto.ticket>>'  
								and a.data_venda='<<v_loja_venda_02_produto.data_venda>>' 
								and a.item='<<v_loja_venda_02_produto.item>>' 

							endtext		
							
							f_select(xsel,"curValeOld")
							
							thisformset.lx_form1.lx_PAGEFRAME1.page2.LX_grid_filha1.Col_tx_CODIGO_BARRA.Tx_CODIGO_BARRA.value=curValeOld.codigo_barra
												
						Endif	
					
					ENDIF
					*FIM PROCEDIMENTO ALTERACAO NUMERO VALE


					if !f_vazio(xalias)
						sele &xalias
					endif	


				case upper(xmetodo) == 'USR_CLEAN_AFTER' 

					if type("thisform.lx_PAGEFRAME1.page1.tx_data_ini")<>"U"
					
						thisformset.p_pai_filtro=xpai_filtro
						xdata_ini   = ctod('')
						xdata_fim   = ctod('') 
						xvale       = "     "   						
						
						with thisformset.lx_form1.lx_PAGEFRAME1.page5
							.cmdRemoveAll.Click() 
							if .lstSelected.listcount = 0
								if f_select("select filial,codigo_filial from lojas_varejo order by codigo_filial","curSelect")
									.lstsource.clear
									.lstSelected.clear
									scan
										.lstsource.additem(codigo_filial+" - "+filial, recno(), 1)
										.lstsource.addlistitem(codigo_filial, recno(), 2)
									endscan
									.refresh()
									use
								endif
							endif
						endwith	
						
					endif	

					


										
					
				otherwise
				return .t.				
			endcase

	endproc
ENDDEFINE	



**************************************************
*-- Class:        lb_data_venda (c:\work\desenv\filtros_data\lb_data_venda.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/15/08 10:28:09 AM
*
DEFINE CLASS lb_data_venda AS lx_label


	AutoSize = .T.
	FontSize = 10
	Alignment = 2
	Caption = "Filtro Data Venda                     a"
	Height = 20
	Left = 10
	Top = 270
	Width = 200
	TabIndex = 3
	ForeColor = RGB(0,0,160)
	Name = "lb_data"
	Visible = .T.
	Fontbold = .T.

ENDDEFINE
*
*-- EndDefine: lb_data_venda
**************************************************



**************************************************
*-- Class:        tx_data_ini (c:\work\desenv\filtros_data\tx_data_ini.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_data_ini AS lx_textbox_base


	ControlSource = "xdata_ini"
	Height = 22
	Left = 125
	TabIndex = 108
	Top = 272
	Width = 76
	p_tipo_dado = "edita"
	Name = "tx_data_ini"
	Visible = .T.
	Enabled = .T.	

ENDDEFINE
*
*-- EndDefine: tx_data_ini
**************************************************


**************************************************
*-- Class:        tx_data_fim (c:\work\desenv\filtros_data\tx_data_fim.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_data_fim AS lx_textbox_base


	ControlSource = "xdata_fim"
	Height = 22
	Left = 220
	TabIndex = 109
	Top = 272
	Width = 76
	p_tipo_dado = "edita"
	Name = "tx_data_fim"
	Visible = .T.
	Enabled = .T.	

ENDDEFINE
*
*-- EndDefine: tx_data_fim
**************************************************








**************************************************
*-- Class:        lb_filial (c:\work\desenv\120007\lb_filial.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/10/08 05:34:04 PM
*
DEFINE CLASS lb_filial AS lx_label


	AutoSize = .F.
	FontBold = .T.
	Caption = "Filiais"
	Height = 15
	Left = 6
	Top = 10
	Width = 78
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,0)
	ZOrderSet = 20
	Name = "lb_filial"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lb_filial
**************************************************



**************************************************
*-- Class:        line1 (c:\work\desenv\120007\line1.vcx)
*-- ParentClass:  lx_shape (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    shape
*-- Time Stamp:   10/10/08 05:37:08 PM
*
DEFINE CLASS line1 AS lx_shape


	Top = 25
	Left = 10
	Height = 0
	Width = 350
	BorderColor = RGB(127,157,185)
	ZOrderSet = 26
	Name = "line1"
	Visible = .t.

ENDDEFINE
*
*-- EndDefine: line1
**************************************************


**************************************************
*-- Class:        cmdadd (c:\work\desenv\120007\cmdadd.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/10/08 04:41:11 PM
*
DEFINE CLASS cmdadd AS commandbutton


	Top = 30
	Left = 169
	Name = "cmdAdd"
	Visible = .T.
	Enabled = .T.
	Fontname="webdings"
	Caption="4"	
	height=25
	width=25	

	PROCEDURE Click
		With This.Parent
			For nCnt = .lstSource.ListCount To 1 Step -1
				If .lstSource.Selected(nCnt)
					.lstSelected.AddItem(.lstSource.List(nCnt, 1), .lstSelected.ListCount+1, 1)
					.lstSelected.AddListItem(.lstSource.List(nCnt, 2), .lstSelected.ListCount, 2)
					.lstSource.RemoveItem(nCnt)
				Endif
			Next
		Endwith
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdadd
**************************************************

**************************************************
*-- Class:        cmdaddall (c:\work\desenv\120007\cmdaddall.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/10/08 04:42:07 PM
*
DEFINE CLASS cmdaddall AS commandbutton


	Top = 58
	Left = 169
	Name = "cmdAddAll"
	Visible = .T.
	Enabled = .T.
	Fontname="webdings"
	Caption="8"	
	height=25
	width=25	


	PROCEDURE Click
		Thisform.LockScreen = .T.
		For i = 1 To This.Parent.lstSource.ListCount
			This.Parent.lstSelected.AddItem(This.Parent.lstSource.List(i, 1), i, 1)
			This.Parent.lstSelected.AddListItem(This.Parent.lstSource.List(i, 2), i, 2)
		Endfor
		This.Parent.lstSource.Clear
		Thisform.LockScreen = .F.
	ENDPROC

ENDDEFINE
*
*-- EndDefine: cmdaddall
**************************************************


**************************************************
*-- Class:        cmdremove (c:\work\desenv\120007\cmdremove.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/10/08 04:43:02 PM
*
DEFINE CLASS cmdremove AS commandbutton


	Top = 86
	Left = 169
	Name = "cmdRemove"
	Visible = .T.
	Enabled = .T.
	Fontname="webdings"
	Caption="3"	
	height=25
	width=25	

	PROCEDURE Click
		With This.Parent
			For nCnt = .lstSelected.ListCount To 1 Step -1
				If .lstSelected.Selected(nCnt)
					.lstSource.AddItem(.lstSelected.List(nCnt, 1), .lstSource.ListCount+1, 1)
					.lstSource.AddListItem(.lstSelected.List(nCnt, 2), .lstSource.ListCount, 2)
					.lstSelected.RemoveItem(nCnt)
				Endif
			Next
		Endwith
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdremove
**************************************************

**************************************************
*-- Class:        cmdremoveall (c:\work\desenv\120007\cmdremoveall.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/10/08 04:43:07 PM
*
DEFINE CLASS cmdremoveall AS commandbutton


	Top = 114
	Left = 169
	Name = "cmdRemoveAll"
	Visible = .T.
	Enabled = .T.
	Fontname="webdings"
	Caption="7"	
	height=25
	width=25	

	PROCEDURE Click
		Thisform.LockScreen = .T.
		For i = 1 To This.Parent.lstSelected.ListCount
			This.Parent.lstSource.AddItem(This.Parent.lstSelected.List(i, 1), i, 1)
			This.Parent.lstSource.AddListItem(This.Parent.lstSelected.List(i, 2), i, 2)
		Endfor
		This.Parent.lstSelected.Clear
		Thisform.LockScreen = .F.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmdremoveall
**************************************************

**************************************************
*-- Class Library:  c:\work\desenv\120007\lst_source.vcx
**************************************************


**************************************************
*-- Class:        lst_source (c:\work\desenv\120007\lst_source.vcx)
*-- ParentClass:  listbox
*-- BaseClass:    listbox
*-- Time Stamp:   10/10/08 04:40:08 PM
*
DEFINE CLASS lstSource AS listbox


	FontName = "Tahoma"
	Height = 139
	Left = 10
	SpecialEffect = 1
	Top = 30
	Width = 156
	BorderColor = RGB(127,157,185)
	Name = "lstSource"
	Visible = .T.
	Enabled = .T.
	Fontsize = 8	
	Fontbold = .T.	

	PROCEDURE DblClick
		This.Parent.cmdAdd.Click()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: lst_source
**************************************************

**************************************************
*-- Class:        lst_selected (c:\work\desenv\120007\lst_selected.vcx)
*-- ParentClass:  listbox
*-- BaseClass:    listbox
*-- Time Stamp:   10/10/08 04:41:00 PM
*
DEFINE CLASS lstSelected AS listbox


	FontName = "Tahoma"
	Height = 138
	Left = 197
	MoverBars = .F.
	SpecialEffect = 1
	Top = 30
	Width = 155
	BorderColor = RGB(127,157,185)
	Name = "lstSelected"
	Visible = .T.
	Enabled = .T.
	Fontsize = 8	
	Fontbold = .T.		

	PROCEDURE DblClick
		This.Parent.cmdRemove.Click()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: lst_selected
**************************************************






**************************************************
*-- Class:        lb_vale (c:\work\desenv\120007\lb_filial.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/10/08 05:34:04 PM
*
DEFINE CLASS lb_vale AS lx_label


	AutoSize = .F.
	FontBold = .F.
	Caption = "Vale(s)"
	Height = 15
	Left = 85
	Top = 415
	Width = 40
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,0)
	ZOrderSet = 20
	Name = "lb_vale"
	Visible = .T.
	Alignment = 2

ENDDEFINE
*
*-- EndDefine: lb_vale 
************************************************** 



**************************************************
*-- Class:        tx_vale (c:\work\desenv\filtros_data\tx_data_ini.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_vale AS lx_textbox_base


	ControlSource = "xvale"
	Height = 22
	Left = 125
	TabIndex = 4
	Top = 413
	Width = 180
	p_tipo_dado = "edita"
	Name = "tx_vale"
	Visible = .T.
	Enabled = .T.	

ENDDEFINE
*
*-- EndDefine: tx_vale
**************************************************

**************************************************
*-- Class:        tx_cupom (c:\work\desenv\filtros_data\tx_cupom.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_cupom AS lx_textbox_base


	ControlSource = "v_loja_venda_02.numero_controle"
	Height = 22
	Left = 344
	TabIndex = 7
	Top = 262
	Width = 76
	p_tipo_dado = "edita"
	Name = "tx_cupom"
	Visible = .F.
	Enabled = .T.	

ENDDEFINE
*
*-- EndDefine: tx_cupom 
**************************************************



**************************************************
*-- Class:        ck_cartoes_pos (c:\temp\cont\ck_cartoes_pos.vcx)
*-- ParentClass:  lx_checkbox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   08/26/09 11:31:13 AM
*
*#INCLUDE "c:\linx_sql\desenv\formtool\lx_const.h"
*
DEFINE CLASS ck_cartoes_pos AS lx_checkbox


	Top = 286
	Left = 565
	Height = 15
	Width = 102
	FontName = "Tahoma"
	FontSize = 8
	WordWrap = .F.
	Alignment = 0
	Caption = "Cartões POS"
	Value = .F.
	ControlSource = "xCartaoPOs"
	TabIndex = 50
	p_tipo_dado = "EDITA"
	Name = "ck_cartoes_pos"
	Visible = .T.
	Enabled = .T.



ENDDEFINE
*
*-- EndDefine: ck_cartoes_pos
**************************************************