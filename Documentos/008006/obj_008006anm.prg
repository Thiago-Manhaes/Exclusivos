* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: inclui checkbox para matar saldo nas programacoes - por produto ou total			                    *
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
				
					xalias=alias()
				
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
					sele v_producao_programa_00   
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("ANM_ZERAR_SALDOS", "L",.T., "Saldos Zerados", "PRODUCAO_PROGRAMA.ANM_ZERAR_SALDOS")				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 


					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- v_producao_programa_00_prod  
					sele v_producao_programa_00_prod   
					xalias_filha=alias()

	  				oCur = getcursoradapter(xalias_filha)
					oCur.addbufferfield("ANM_MATAR_SALDO", "L",.T., "Matar Saldo", "PRODUCAO_PROG_PROD.ANM_MATAR_SALDO")	
					oCur.addbufferfield("ANM_OP_LIBERADA", "L",.T., "Bloqueia", "PRODUCAO_PROG_PROD.ANM_OP_LIBERADA")
					** #1 - LUCAS MIRANDA - 16/05/2016 - ADIÇÃO DAS COLUNAS DE PRODUTO ACABADO							
					oCur.addbufferfield("'' AS DESC_PRODUTO_SEGMENTO", "C(25)",.F., "DESC_PRODUTO_SEGMENTO", "DESC_PRODUTO_SEGMENTO")
					oCur.addbufferfield("'' AS DESC_CATEGORIA", "C(25)",.F., "DESC_PRODUTO_SEGMENTO", "DESC_CATEGORIA")
					oCur.addbufferfield("'' AS DESC_SUBCATEGORIA", "C(25)",.F., "DESC_SUBCATEGORIA", "DESC_SUBCATEGORIA")	
					oCur.addbufferfield("'' AS DESC_PRODUTO_SOLUCAO", "C(25)",.F., "DESC_PRODUTO_SOLUCAO", "DESC_PRODUTO_SOLUCAO")		
					** #1 - LUCAS MIRANDA - 16/05/2016 - ADIÇÃO DAS COLUNAS DE PRODUTO ACABADO				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha 

					WITH Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1
		                        .AddColumn(1)
		                        .Column1.Name='col_op_liberada'
		                 WITH .col_op_liberada
                            .RemoveObject("text1") 
				            .Header1.Name='h_check_libera'
				            .h_check_libera.Caption='Bloqueia'
			                .AddObject('ck_Liberar_op','CheckBox')
				            .Sparse= .F.
				            .CurrentControl = 'ck_Liberar_op'
				            .ck_Liberar_op.Caption=""
				            .ck_Liberar_op.Visible = .T.
                            .Width=60
                            .BackColor = 15399423
                            .ck_Liberar_op.DisabledBackColor= 15399423
                            .ck_Liberar_op.BackColor = 15399423
                            .h_check_libera.FontName = "Tahoma"
                            .h_check_libera.FontSize = 8
                            .h_check_libera.Alignment= 2
				            .FontName = "Tahoma"
				            .FontSize = 8
                            .ControlSource="v_producao_programa_00_prod.anm_op_liberada"
		                ENDWITH	
                    ENDWITH	
				
					with thisform
						.addobject("ck_matar_saldo_total","ck_matar_saldo_total")
						.lx_PAGEFRAME1.page2.addobject("ck_matar_saldo_produto","ck_matar_saldo_produto")		
		
					endwith
					
							** #1 - LUCAS MIRANDA - 16/05/2016 - ADIÇÃO DAS COLUNAS DE PRODUTO ACABADO					
							with	thisformset.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1
											xcColumnCount = .columncount
																xcColumnCount = xcColumnCount + 1 
																.addcolumn(xcColumnCount)
																.columns[xcColumnCount].name = 'col_anm_desc_segmento'
																.col_anm_desc_segmento.width = 100
																.col_anm_desc_segmento.columnorder = 41
																.col_anm_desc_segmento.header1.caption = 'Desc. Segmento'
																.col_anm_desc_segmento.header1.alignment = 2
																.col_anm_desc_segmento.header1.FONTSIZE = 8
																.col_anm_desc_segmento.refresh()
																.col_anm_desc_segmento.ControlSource='v_producao_programa_00_prod.desc_produto_segmento'
							endwith
											
							with	thisformset.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1
											xcColumnCount = .columncount
																xcColumnCount = xcColumnCount + 1 
																.addcolumn(xcColumnCount)
																.columns[xcColumnCount].name = 'col_anm_desc_solucao'
																.col_anm_desc_solucao.width = 100
																.col_anm_desc_solucao.columnorder = 42
																.col_anm_desc_solucao.header1.caption = 'Desc. Solução'
																.col_anm_desc_solucao.header1.alignment = 2
																.col_anm_desc_solucao.header1.FONTSIZE = 8
																.col_anm_desc_solucao.refresh()
																.col_anm_desc_solucao.ControlSource='v_producao_programa_00_prod.DESC_PRODUTO_SOLUCAO'
							endwith
							
							with	thisformset.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1
											xcColumnCount = .columncount
																xcColumnCount = xcColumnCount + 1 
																.addcolumn(xcColumnCount)
																.columns[xcColumnCount].name = 'col_anm_desc_categoria'
																.col_anm_desc_categoria.width = 100
																.col_anm_desc_categoria.columnorder = 43
																.col_anm_desc_categoria.header1.caption = 'Desc. Categoria'
																.col_anm_desc_solucao.header1.alignment = 2
																.col_anm_desc_categoria.header1.FONTSIZE = 8
																.col_anm_desc_categoria.refresh()
																.col_anm_desc_categoria.ControlSource='v_producao_programa_00_prod.DESC_CATEGORIA'
							endwith
							
							with	thisformset.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1
											xcColumnCount = .columncount
																xcColumnCount = xcColumnCount + 1 
																.addcolumn(xcColumnCount)
																.columns[xcColumnCount].name = 'col_anm_desc_subcategoria'
																.col_anm_desc_subcategoria.width = 100
																.col_anm_desc_subcategoria.columnorder = 44
																.col_anm_desc_subcategoria.header1.caption = 'Desc. SubCategoria'
																.col_anm_desc_subcategoria.header1.alignment = 2
																.col_anm_desc_subcategoria.header1.FONTSIZE = 8
																.col_anm_desc_subcategoria.refresh()
																.col_anm_desc_subcategoria.ControlSource='v_producao_programa_00_prod.DESC_SUBCATEGORIA'
							endwith
							** #1 - LUCAS MIRANDA - 16/05/2016 - ADIÇÃO DAS COLUNAS DE PRODUTO ACABADO
							
					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha-- curfiliais
					sele curfiliais
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
	  				oCur.addbufferfield("FILIAIS.CTRL_PRODUCAO_PRODUTO", "L",.T., "CTRL_PRODUCAO_PRODUTO", "FILIAIS.CTRL_PRODUCAO_PRODUTO")
					oCur.addbufferfield("CADASTRO_CLI_FOR.INATIVO", "L",.T., "CADASTRO_CLI_FOR.INATIVO", "CADASTRO_CLI_FOR.INATIVO")
					oCur.confirmstructurechanges()
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha


					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
										
					Thisformset.L_Limpa()
					
					
				case upper(xmetodo) == 'USR_REFRESH' 
				
					xalias=alias()	
					
						If Type("Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP")<>"U"
							If Thisformset.p_tool_status $ 'I,A' 
									Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP.Enabled= .T.
							Else
									Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_OP_LIBERADA.CK_LIBERAR_OP.Enabled= .F.
							Endif			
						Endif
						
						sele curfiliais
						IF Thisformset.p_tool_status $ "IA"
							SET FILTER TO inativo = .f. AND CTRL_PRODUCAO_PRODUTO = .t.
						ELSE 
							SET FILTER TO
						ENDIF
						GO top
						
						** #1 - LUCAS MIRANDA - 16/05/2016 - ADIÇÃO DAS COLUNAS DE PRODUTO ACABADO
							If type("thisformset.lx_form1.lx_pageframe1.page2.lX_GRID_FILHA1.COL_ANM_DESC_SEGMENTO") <> "U" AND ;
							   type("thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_solucao") <> "U" AND ;
							   type("thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_categoria") <> "U" AND ;
							   type("thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_subcategoria") <> "U"		
								
								If Thisformset.P_TOOL_STATUS = 'P'
																	
									sele v_producao_programa_00_prod
										GO TOP
										SCAN
											
											TEXT TO XSEL TEXTMERGE NOSHOW
											
												select A.PRODUTO, ISNULL(B.DESC_PRODUTO_SEGMENTO,'') AS DESC_PRODUTO_SEGMENTO, 
												ISNULL(C.CATEGORIA_PRODUTO,'') AS DESC_CATEGORIA,
												ISNULL(D.SUBCATEGORIA_PRODUTO,'') AS DESC_SUBCATEGORIA,
												ISNULL(E.DESC_PRODUTO_SOLUCAO,'') AS DESC_PRODUTO_SOLUCAO
												from PRODUTOS (NOLOCK) A
												LEFT JOIN PRODUTOS_SEGMENTO (NOLOCK) B
												ON A.COD_PRODUTO_SEGMENTO = B.COD_PRODUTO_SEGMENTO
												LEFT JOIN PRODUTOS_CATEGORIA (NOLOCK) C
												ON A.COD_CATEGORIA = C.COD_CATEGORIA
												LEFT JOIN PRODUTOS_SUBCATEGORIA (NOLOCK) D
												ON C.COD_CATEGORIA = D.COD_CATEGORIA
												LEFT JOIN PRODUTOS_SOLUCAO (NOLOCK) E
												ON A.COD_PRODUTO_SOLUCAO = E.COD_PRODUTO_SOLUCAO
												WHERE A.PRODUTO = '<<v_producao_programa_00_prod.produto>>'
												
											ENDTEXT

											f_select(xsel,"xTempSelect",ALIAS())
											
											sele v_producao_programa_00_prod
											
											replace DESC_PRODUTO_SEGMENTO  	WITH xTempSelect.DESC_PRODUTO_SEGMENTO
											replace DESC_PRODUTO_SOLUCAO	WITH xTempSelect.DESC_PRODUTO_SOLUCAO
											replace DESC_CATEGORIA  		WITH xTempSelect.DESC_CATEGORIA
											replace DESC_SUBCATEGORIA  		WITH xTempSelect.DESC_SUBCATEGORIA
											
										ENDSCAN	
									
									thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.COL_ANM_DESC_SEGMENTO.Enabled = .f.
									thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_solucao.Enabled = .f.
									thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_categoria.Enabled = .f.
									thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_subcategoria.Enabled = .f.
								Else
									thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.COL_ANM_DESC_SEGMENTO.Enabled = .T.
									thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_solucao.Enabled = .T.
									thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_categoria.Enabled = .T.
									thisformset.lx_form1.lx_pageframe1.page2.lx_GRID_FILHA1.col_anm_desc_subcategoria.Enabled = .T.
								Endif
							Endif
						** #1 - LUCAS MIRANDA - 16/05/2016 - ADIÇÃO DAS COLUNAS DE PRODUTO ACABADO
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
						
				case upper(xmetodo) == 'USR_SAVE_BEFORE'				
					xalias=alias()	
						
						sele v_producao_programa_00
						
						IF f_vazio(v_producao_programa_00.filial)
							MESSAGEBOX("Favor colocar a Filial !!!",0+48)
							RETURN .f.
						ENDIF 
						
						f_select("select COUNT(*) as xTesteFil from filiais where CTRL_PRODUCAO_PRODUTO = 1 and filial = ?v_producao_programa_00.filial","xTesteFil")
						if  xTesteFil.xTesteFil = 0
							MESSAGEBOX("Filial não autorizada para produção ou Compra !!!",0+48)
							RETURN .f.
						ENDIF 
				
																
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE



**************************************************
*-- Class:        ck_matar_saldo_total (c:\temp\v7\ck_matar_saldo_total.vcx)
*-- ParentClass:  lx_checkbox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   05/20/09 06:31:00 PM
**
DEFINE CLASS ck_matar_saldo_total AS lx_checkbox


	Top = 44
	Left = 582
	Height = 15
	Width = 102
	FontName = "Tahoma"
	FontSize = 8
	WordWrap = .F.
	Alignment = 0
	Caption = "Matar Saldo Total"
	Value = .F.
	ControlSource = "v_producao_programa_00.anm_zerar_saldos"
	TabIndex = 5
	p_tipo_dado = "EDITA"
	Name = "ck_matar_saldo_total"
	Visible = .T.
	Enabled = .T.

	PROCEDURE l_desenhista_recalculo
		IF this.Value=.f.
			This.Parent.lx_combobox1.Value =2 
			This.Parent.lx_combobox1.Refresh() 
		endif 
	ENDPROC


	*PROCEDURE Refresh
	*	This.L_DESENHISTA_RECALCULO
	*ENDPROC


ENDDEFINE
*
*-- EndDefine: ck_matar_saldo_total
**************************************************


**************************************************
*-- Class:        ck_matar_saldo_produto (c:\temp\v7\ck_matar_saldo_produto.vcx)
*-- ParentClass:  lx_checkbox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   05/20/09 06:31:05 PM
*
*
DEFINE CLASS ck_matar_saldo_produto AS lx_checkbox


	Top = 7
	Left = 690
	Height = 28
	Width = 101
	FontName = "Tahoma"
	FontSize = 8
	WordWrap = .T.
	Alignment = 0
	Caption = "Matar Saldo Reserva Produto"
	Value = .F.
	ControlSource = "v_producao_programa_00_prod.anm_matar_saldo"
	TabIndex = 5
	p_tipo_dado = "EDITA"
	Name = "ck_matar_saldo_produto"
	Visible = .T.
	Enabled = .T.


	PROCEDURE Refresh
		*This.L_DESENHISTA_RECALCULO
	ENDPROC


	PROCEDURE l_desenhista_recalculo
		*This.Parent.LX_GRID_FILHA1.L_ESCONDE_COLUNA('Column61',This.Value)
	ENDPROC


ENDDEFINE
*
*-- EndDefine: ck_matar_saldo_produto
**************************************************
