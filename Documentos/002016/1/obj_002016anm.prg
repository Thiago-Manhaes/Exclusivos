* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  09/03/2005                                                                                                *
* HORÁRIO........:  18:00                                                                                                *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                      *
* OBJETIVO.: Melhorar o desempenho na impressão de etiquetas de código de barras  *
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
				
					
				case UPPER(xmetodo)=='USR_INIT' 
				
				
				
				WITH thisform.lx_pageframe1
					.pagecount=.pagecount+1
						FOR i=1 TO .pagecount
							IF UPPER(LEFT(.objects(i).caption,4))='PAGE'
								strnamepage='.'+.objects(i).name
								WITH &strnamepage
									.name='pg_AAF'
									.caption='AAF'
									.fontname='Tahoma'
									.fontsize=8
									.addobject('shape2', 'shape2')
									.addobject("imprime_etiq","imprime_etiq")
									.addobject("imprime_datamax_ata","imprime_datamax_ata")
									.addobject("imprime_datamax_FYI","imprime_datamax_FYI")
									.addobject("imprime_allegro_var","imprime_allegro_var")
									.addobject("imprime_allegro_joia","imprime_allegro_joia")
									.addobject("imprime_datamax_anm","imprime_datamax_farm")
									.refresh()
								ENDWITH
							ENDIF
						ENDFOR
					ENDWITH
						*thisform.l_limpa()
						thisform.refresh()
									
						
				WITH thisform.lx_pageframe1
					.pagecount=.pagecount+1
						FOR i=1 TO .pagecount
							IF UPPER(LEFT(.objects(i).caption,4))='PAGE'
								strnamepage='.'+.objects(i).name
								WITH &strnamepage
									.name='pg_FFF'
									.caption='FFF'
									.fontname='Tahoma'
									.fontsize=8
									.addobject('shape3', 'shape3')
									.addobject("imprime_datamax_anm","imprime_datamax_farm")
									.addobject("imprime_datamax_animale","imprime_datamax_animale") 
									.addobject("imprime_datamax_atacado","imprime_datamax_atacado")
									.addobject("imprime_datamax_foxton","imprime_datamax_foxton")
									.refresh()
								ENDWITH
							ENDIF
						ENDFOR
					ENDWITH
						*thisform.l_limpa()
						thisform.refresh()
					
*!*						MESSAGEBOX(thisform.lx_PAGEFRAME1.page1.lx_grid_filha1.top)
*!*						MESSAGEBOX(thisform.lx_PAGEFRAME1.page1.lx_grid_filha1.width)
					
*!*						WITH thisform.lx_PAGEFRAME1.page1.lx_grid_filha1
*!*							
*!*							.parent.parent.parent.height=475
*!*							.parent.parent.height=470
*!*							.top=thisform.lx_PAGEFRAME1.page1.lx_grid_filha1.top+60
*!*							.height=thisform.lx_PAGEFRAME1.page1.lx_grid_filha1.height-20
*!*								
*!*						
*!*						ENDWITH 
					
*!*						thisform.lx_PAGEFRAME1.page1.addobject("imprime_etiq","imprime_etiq") 
*!*						thisform.lx_PAGEFRAME1.page1.addobject("imprime_datamax_ata","imprime_datamax_ata")
*!*						thisform.lx_PAGEFRAME1.page1.addobject("imprime_datamax_FYI","imprime_datamax_FYI")  
*!*						thisform.lx_PAGEFRAME1.page1.addobject("imprime_allegro_var","imprime_allegro_var") 	
*!*						thisform.lx_PAGEFRAME1.page1.addobject("imprime_allegro_joia","imprime_allegro_joia") 	
*!*						thisform.lx_PAGEFRAME1.page1.addobject("imprime_datamax_anm","imprime_datamax_farm") 				
									
*!*						WITH thisform.lx_PAGEFRAME1.page1.imprime_etiq 
*!*						
*!*							.Top = 2
*!*							.Left = 56
*!*							.Height = 27
*!*							.Width = 144
*!*							.Caption = "Etiqueta Animale"
*!*							.Name = "imprime_etiq"
*!*							.visible=.t.
*!*							.enabled=.t.
*!*						
*!*						ENDWITH												
					
												
				otherwise
				return .t.				
			endcase

	endproc
ENDDEFINE



**************************************************

DEFINE CLASS shape2 AS lx_shape

Visible = .T.
Name = "shape2"
top=4
left=4
width=695
height=390
specialeffect=0

ENDDEFINE

**************************************************

**************************************************

DEFINE CLASS shape3 AS lx_shape

Visible = .T.
Name = "shape3"
top=4
left=4
width=695
height=390
specialeffect=0

ENDDEFINE

**************************************************


*AAF
**************************************************
*-- Class:        imprime_datamax_ata (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_datamax_FYI.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_FYI AS commandbutton


	*Top = 2
	Top = 6
	Left = 385
	Height = 27
	Width = 150
	Caption = "Etiqueta DataMAx FYI"
	Name = "imprime_datamax_FYI"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE	
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr1 impressão de etiqueta termica datamax fyi.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1 

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_FYI 
**************************************************



**************************************************
*-- Class:        imprime_etiq (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_etiq.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_etiq AS commandbutton



	*Top = 2
	Top = 6
	Left = 56
	Height = 27
	Width = 150
	Caption = "Etiqueta Allegro Atacado"
	Name = "imprime_etiq"
	visible=.t.
	enabled=.t.


	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\U002016CR IMPRESSÃO DE ETIQUETA TERMICA GENERICA ANIMALE.FRX' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_etiq
**************************************************






**************************************************
*-- Class:        imprime_datamax_ata (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_datamax_ata.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_ata AS commandbutton


	*Top = 2
	Top = 6
	Left = 220
	Height = 27
	Width = 150
	Caption = "Etiqueta DataMAx Atacado"
	Name = "imprime_datamax_ata"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impressão de etiqueta termica datamax atacado.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_ata 
**************************************************




**************************************************
*-- Class:        imprime_allegro_var (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_allegro_var.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_allegro_var AS commandbutton


	*Top = 30
	Top = 34
	Left = 56
	Height = 27
	Width = 150
	Caption = "Etiqueta Allegro Varejo"
	Name = "imprime_datamax_ata"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'Linx\REPORT\USER\u002016cr impressão de etiqueta termica allegro varejo.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_allegro_var 
**************************************************






**************************************************
*-- Class:        imprime_allegro_joia (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_allegro_joia.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_allegro_joia AS commandbutton


	*Top = 30
	Top = 34
	Left = 220
	Height = 27
	Width = 150
	Caption = "Etiqueta Allegro Jóias"
	Name = "imprime_allegro_joia"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impressão de etiqueta termica allegro Joias.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_allegro_joia 
**************************************************

**************************************************
*-- Class:        imprime_datamax_farm (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_datamax_farm.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_farm AS commandbutton


	*Top = 30
	Top = 34
	Left = 380
	Height = 27
	Width = 150
	Caption = "Etiqueta Varejo Farm"
	Name = "imprime_datamax_farm"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			thisformset.Refresh()
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impressão de etiqueta termica datamax farm.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_farm
**************************************************

**FFF
**************************************************
*-- Class:        imprime_datamax_farm (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_datamax_farm.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_farm AS commandbutton


	*Top = 2
	Top = 6
	Left = 220
	Height = 27
	Width = 150
	Caption = "Etiqueta Varejo Farm"
	Name = "imprime_datamax_farm"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			thisformset.Refresh()
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impressão de etiqueta termica datamax farm.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_farm
**************************************************




**************************************************
*-- Class:        imprime_datamax_animale (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_datamax_animale.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_animale AS commandbutton

	*Top = 2
	Top = 6
	Left = 56
	Height = 27
	Width = 150
	Caption = "Etiqueta Mostruario"
	Name = "imprime_datamax_animale"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			thisformset.Refresh()
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impressão de etiqueta termica datamax animale.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_animale 
**************************************************


**************************************************
*-- Class:        imprime_datamax_animale (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_datamax_animale.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_atacado AS commandbutton

	*Top = 2
	Top = 6
	Left = 385
	Height = 27
	Width = 150
	Caption = "Etiqueta Atacado"
	Name = "imprime_datamax_atacado"
	visible=.t.
	enabled=.t.



	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			thisformset.Refresh()
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impressão de etiqueta termica datamax atacado.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_animale 
**************************************************




**************************************************
*-- Class:        imprime_datamax_animale (l:\implantação-linx\impressao_cod_barra_allegro_velha\imprime_datamax_animale.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_datamax_foxton AS commandbutton

	
	Top = 34
	Left = 56
	Height = 27
	Width = 150
	Caption = "Etiqueta Foxton"
	Name = "imprime_datamax_foxton"
	visible=.t.
	enabled=.t.


	PROCEDURE Click
		
		IF thisformset.p_tool_status = 'L'
			PUBLIC xImpressora 
			
			this.Parent.Parent.page3.tx_impressora_escolhida.Caption = this.Caption 
			this.Parent.Parent.page3.tx_botao_name.Caption = this.Name
			thisformset.Refresh()
			*this.Parent.Parent.page1.shape_alerta.Visible= .F.
			this.Parent.Parent.page3.SetFocus()
			RETURN .f.
		ELSE
		
			PUBLIC xqtdeetiq
			LOCAL XX AS Integer, XQTDE AS INTEGER 

			SELECT * from V_TABELAS_PRECO_BARRA_00 WHERE 1=2 INTO CURSOR cur_tabelas_preco READWRITE 

			SELECT V_TABELAS_PRECO_BARRA_00
			SCAN FOR QTDE_ETIQUETAS > 0 
				SCATTER NAME obarras memo
				SELECT cur_tabelas_preco
				APPEND BLANK
				GATHER NAME obarras MEMO 
				SELECT V_TABELAS_PRECO_BARRA_00
			ENDSCAN 

			SELECT V_TABELAS_PRECO_BARRA_00
			DELETE ALL 

			LOCAL xcodigo
			Xx = 1
			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				xqtde = QTDE_ETIQUETAS
			*	replace qtde_etiquetas WITH 1
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND BLANK 
				GATHER NAME obarras MEMO 

					SELECT V_TABELAS_PRECO_BARRA_00
					xqtdeetiq=PADL(ALLTRIM(STR(ROUND((qtde_etiquetas/2),0))),4,'0')
					replace qtde_etiquetas WITH 2
					REPORT FORM wdir+'LINX\REPORT\USER\u002016cr impressão de etiqueta termica datamax foxton.frx' NOCONSOLE TO PRINTER 

					*WAIT WINDOW 'Imprimido....: '+ALLTRIM(STR(i,4,0))+' / '+ALLTRIM(STR(xqtde,4,0)) nowait

				DELETE 
				XX = 1

			ENDSCAN

			SELECT cur_tabelas_preco 
			SCAN 
				SCATTER NAME obarras memo
				SELECT V_TABELAS_PRECO_BARRA_00
				APPEND blank 
				GATHER NAME obarras MEMO 
			ENDSCAN 

			WAIT WINDOW 'Etiquetas Impressas...' nowait 
		ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: imprime_datamax_foxton
**************************************************





