* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao coluna 1ª Reserva e Filiais Estoque					                    *
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
					
					
					PUBLIC xReservaAnterior
					PUBLIC xOldFilial,xFilConsumo

					xReservaAnterior = 0
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_ordem_01
					sele v_producao_ordem_01
					xalias_pai=alias()
					
	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("FILIAL_PRODUCAO", "C(25)",.T., "FILIAL_PRODUCAO", "PRODUCAO_ORDEM.FILIAL_PRODUCAO")		
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 	
					sele v_filiais_00
					xalias_pai=alias()
					
					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("FILIAIS.CTRL_PRODUCAO_PRODUTO", "L",.T., "CTRL_PRODUCAO_PRODUTO", "FILIAIS.CTRL_PRODUCAO_PRODUTO")
					oCur.addbufferfield("CADASTRO_CLI_FOR.INATIVO", "L",.T., "INATIVO", "CADASTRO_CLI_FOR.INATIVO")
					oCur.confirmstructurechanges()
					
				
					f_select("select ltrim(rtrim(depto)) as depto,usuario from users where UPPER(usuario)=UPPER(?wusuario)","curUser",alias())
					
					IF ALLTRIM(UPPER(curUser.depto)) == ALLTRIM('FINANCEIRO')
						*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_ordem_01
						sele v_producao_ordem_01
						xalias_pai=alias()
						
		  				oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("ANM_CK_FINANC", "LOGICAL(1)" ,.T., "ANM_CK_FINANC", "PRODUCAO_ORDEM.ANM_CK_FINANC")	
						oCur.addbufferfield("ANM_OBS_FIN", "CHARACTER(250)",.T., "ANM_OBS_FIN", "PRODUCAO_ORDEM.ANM_OBS_FIN")			
						oCur.confirmstructurechanges() 	
						**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 	
						
						WITH THISFORMSET.lx_FORM1.lx_pageframe1.Page11
							.addobject("obs_fin","obs_fin")
							.addobject("bt_conf_fin","bt_conf_fin")		
							.addobject("ck_finaliza_fin","ck_finaliza_fin")				
						ENDWITH
						
						THISFORMSET.lx_FORM1.addobject("lb_Finaliza_Fin","lb_Finaliza_Fin")
					ENDIF	

					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha  -- v_producao_ordem_01_materiais  
					sele v_producao_ordem_01_materiais 
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("PRIMEIRA_RESERVA", "N(9,3)",.T., "PRIMEIRA_RESERVA", "PRODUCAO_RESERVA.PRIMEIRA_RESERVA")				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha  				
				
				
				    *adicao da coluna na grid de materiais 
					WITH THISFORMSET.lx_form1.lx_PAGEFRAME1.page3.LX_PAGEFRAME1.Page1.lx_GRID_FILHA1 				
						.addColumn(7)
						.Columns(40).name="col_Primeira_reserva"
						.col_Primeira_reserva.Header1.Caption="Primeira Reserva"
						.col_Primeira_reserva.ControlSource='v_producao_ordem_01_materiais.primeira_reserva'
						.col_Primeira_reserva.enabled=.f.
						
					ENDWITH
					
										
					WITH THISFORMSET.lx_form1.lx_PAGEFRAME1.page2 	
						.Lx_label8.visible=.f.
						.lx_textbox_base5.visible=.f.
						.Lx_label8.enabled=.f.
						.lx_textbox_base5.enabled=.f.
						.addobject("lb_filial_producao","lb_filial_producao")	
						.addobject("cmb_filial_producao","cmb_filial_producao")							
					ENDWITH

				thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.addobject("bt_mata_reserva","bt_mata_reserva")
				thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.addobject("bt_altera_reserva","bt_altera_reserva")				


					THISFORMSET.L_LIMPA() 

				case upper(xmetodo) == 'USR_ALTER_AFTER'  
					
					F_select("SELECT COUNT(*) AS OK FROM W_PRODUCAO_ORDEM_HIST_OS WHERE ORDEM_PRODUCAO = ?V_PRODUCAO_ORDEM_01.ordem_producao","xOP_Corte")
					
					If xOP_Corte.OK = 0
						Thisformset.lx_fORM1.cmb_status.Value = 'S'
					ENDIF
					
****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************
 			case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TX_CUSTO_TAREFA'  
				 						
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
		
						SELECT v_producao_ordem_01_tarefas
						
						TEXT TO XCUSTO NOSHOW TEXTMERGE
							select CUSTO_TAREFA from PRODUCAO_TAREFAS 
							where ORDEM_PRODUCAO=?v_producao_ordem_01.ORDEM_PRODUCAO
							and RECURSO_PRODUTIVO =?v_producao_ordem_01_tarefas.RECURSO_PRODUTIVO
						ENDTEXT
							
						F_SELECT(XCUSTO, 'CUR_CUSTO_ANTERIOR')
					
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_producao_ordem_01_tarefas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_producao_ordem_01.produto
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						SELECT CUR_CUSTO_ANTERIOR
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'   
								MESSAGEBOX("O USUÁRIO NÃO TEM PERMISSÃO PARA ALTERAR O CUSTO DESTA FASE!!",48) 
				    			thisform.LX_FORM1.LX_pageframe1.PAge5.LX_pageframe1.PAge1.LX_GRID_FILHA1.COL_tx_CUSTO_EFETIVO.TX_CUSTO_EFETIVO.Enabled= .F.
				    			REPLACE v_producao_ordem_01_tarefas.CUSTO_TAREFA WITH CUR_CUSTO_ANTERIOR.CUSTO_TAREFA
				    			*RETURN .f.
							ENDIF
					ENDIF	
					
									
			case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_RECURSO_PRODUTIVO'

				IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
			
					SELECT v_producao_ordem_01_tarefas
			
					TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_producao_ordem_01_tarefas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
					TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_producao_ordem_01.produto
					ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'  
								SELECT v_producao_ordem_01_tarefas
									IF v_producao_ordem_01_tarefas.recurso_produtivo<>'99'
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										RETURN .f.
									ENDIF 
							ENDIF                                                       
					ENDIF	
					
					
					
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'TV_FASE_PRODUCAO'	
					
					IF THISFORMSET.pp_ANM_BLOQUEIO_RECURSO=.T.
			
						SELECT v_producao_ordem_01_tarefas
			
						TEXT TO XFASE NOSHOW TEXTMERGE
							SELECT FASE_PRODUCAO, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_FASE
							WHERE PROPRIEDADE='00210'
							AND FASE_PRODUCAO=?v_producao_ordem_01_tarefas.Fase_Producao
						ENDTEXT
						
						F_SELECT(XFASE, 'CUR_FASE')
						
						TEXT TO XPRODUTO NOSHOW TEXTMERGE
							SELECT PRODUTO, VALOR_PROPRIEDADE FROM PROP_PRODUTOS
							WHERE PROPRIEDADE='50016'
							AND PRODUTO=?v_producao_ordem_01.produto
						ENDTEXT
						
						F_SELECT(XPRODUTO, 'CUR_PRODUTO')
					
						SELECT CUR_FASE
						SELECT CUR_PRODUTO
						
							IF CUR_FASE.VALOR_PROPRIEDADE='MÃO DE OBRA' AND CUR_PRODUTO.VALOR_PROPRIEDADE='INTERNO'  
								SELECT v_producao_ordem_01_tarefas
									IF v_producao_ordem_01_tarefas.recurso_produtivo<>'99'
										MESSAGEBOX("O USUÁRIO TEM PERMISSÃO PARA INCLUIR NESTA FASE SOMENTE O RECURSO '99' - 'AGUARDANDO DEFINIÇAO'!!",48) 
										REPLACE recurso_produtivo WITH '99'
										REPLACE desc_recurso WITH 'AGUARDANDO DEFINIÇAO'
										RETURN .f.
									ENDIF 
							ENDIF                                                       
					ENDIF	    				
****** Bloqueio de alocação de recursos - Silvio Luiz - 27042016 ***********************

				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj)=='TX_RESERVA_ORIGINAL' AND thisformset.p_tool_status $'IA'
						
						f_select("select 1 as permite from PARAMETROS_USERS where parametro = 'ALTERA_RESERVA_PARA_MENOS' and valor_atual_user = '.T.' and usuario =?WUSUARIO","xTestaParamRes")
                        f_select("select 1 as permite from PARAMETROS where parametro = 'ALTERA_RESERVA_PARA_MENOS' and valor_atual = '.F.'","xParamRes")
                        xVerifParamRes =(IIF(xTestaParamRes.permite = 1,1,0))
						
						IF xParamRes.PERMITE = 1
							IF xVerifParamRes = 0
						       SELECT V_PRODUCAO_ORDEM_01_MATERIAIS 
							   IF xReservaAnterior > V_PRODUCAO_ORDEM_01_MATERIAIS.RESERVA_ORIGINAL AND thisformset.p_tool_status $'A'
							   	 MESSAGEBOX("NÃO É PERMITIDO ALTERAR UMA RESERVA PARA MENOS, FAVOR SOLICITAR AO OPERACIONAL",0+48)
							   	 replace reserva_original WITH xReservaAnterior	
							     RETURN .F.
							   ENDIF
						    ENDIF
					    ENDIF
					    
					IF thisformset.p_tool_status $'I'
						SELECT V_PRODUCAO_ORDEM_01_MATERIAIS
						   replace primeira_reserva WITH reserva_original 
					ENDIF 
				
				case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj)=='BOTAO1' AND thisformset.p_tool_status $'IA'
							SELECT V_PRODUCAO_ORDEM_01_MATERIAIS
							SCAN 							
								
								TEXT TO xsel NOSHOW TEXTMERGE
											select primeira_reserva 
											from producao_reserva 
											where ordem_producao='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.ordem_producao)>>' 
											and material='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.material)>>'  
											and cor_material='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.cor_material)>>' 
								ENDTEXT

								f_select(xsel,'cur_reserva',ALIAS())
								
								replace primeira_reserva WITH cur_reserva.primeira_reserva IN V_PRODUCAO_ORDEM_01_MATERIAIS
								
								RELEASE cur_reserva
							ENDSCAN

*--Ronald -- retirado replace em atualização 

			  	    				
                
				case upper(xmetodo) == 'USR_REFRESH' && AND thisformset.p_tool_status $'IA'
						
						if type("THISFORMSET.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin")<>"U"
							IF v_producao_ordem_01.ANM_CK_FINANC = .T.	
								THISFORMSET.lx_FORM1.lb_Finaliza_Fin.visible = .t.
							ELSE	
								THISFORMSET.lx_FORM1.lb_Finaliza_Fin.visible = .f.
							ENDIF
						
						
							if thisformset.p_tool_status $'P'	
								WITH THISFORMSET.lx_FORM1.lx_pageframe1.Page11
								.obs_fin.enabled = .f.
								.bt_conf_fin.caption = "Conf. Financ."		
								.ck_finaliza_fin.enabled = .f.				
								ENDWITH
							endif
						endif
					
					
					
						if type("thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.bt_altera_reserva")<>"U"
							if thisformset.p_tool_status='A'
								thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.bt_altera_reserva.visible=.t.
							else		
								thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.bt_altera_reserva.visible=.f.
							endif	
						endif
						
						
						
							SELECT V_PRODUCAO_ORDEM_01_MATERIAIS
							SCAN 							

								IF f_vazio(primeira_reserva)
									replace primeira_reserva WITH reserva_original 
									
									TEXT TO xupdate	NOSHOW TEXTMERGE
										UPDATE  producao_reserva  SET 
										 primeira_reserva=reserva_original 
											where ordem_producao='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.ordem_producao)>>' 
											and material='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.material)>>'  
											and cor_material='<<ALLTRIM(V_PRODUCAO_ORDEM_01_MATERIAIS.cor_material)>>' 
									ENDTEXT

									
									f_update(xupdate)
											
								ENDIF 	
							ENDSCAN			  	    									
						
						
							IF thisformset.p_tool_status $ "IA"
							 
	
							 	 if type("thisformset.lx_form1.lx_pageframe1.page2.cmb_filial_producao")<>"U"
								  	 f_select("select LTRIM(RTRIM(valor_propriedade)) as TIPO from prop_produtos where propriedade = '00036' and produto = ?V_PRODUCAO_ORDEM_01.produto","xTipoProd")
								     If (thisformset.pp_anm_val_cons_filial_op = .t. AND  xTipoProd.TIPO = 'PRODUTO ACABADO') OR xTipoProd.TIPO = 'PRODUÇAO'
										 SELECT V_PRODUCAO_ORDEM_01_MOV_MAT
										 Go Top

										 xOldFilial = v_producao_ordem_01.filial
										 xFilConsumo= V_PRODUCAO_ORDEM_01_MOV_MAT.filial
									
										 f_select("Select matriz from filiais where filial = ?xFilConsumo","curTemp_mfil_op","v_filiais_00")
										 *f_select("Select filial, inativo from filiais (nolock) a join cadastro_cli_for b (nolock) on a.filial = b.nome_clifor where inativo = 0","xFiliaisAt")
																			 
										 *Sele v_filiais_00	
										 IF !f_vazio(curTemp_mfil_op.matriz) AND v_producao_ordem_01.tipo_processo <> 1 
										  SET FILTER TO (MATRIZ = curTemp_mfil_op.matriz AND CTRL_PRODUCAO_PRODUTO = .t. and INATIVO = .F.);
										  OR filial = xOldFilial   
										 ELSE
										  SET FILTER TO (CTRL_PRODUCAO_PRODUTO = .t. and INATIVO = .F.) 
										 ENDIF
										  
										 thisformset.lx_form1.lx_pageframe1.page2.cmb_filial_producao.Enabled = .F.
										 thisformset.lx_form1.lx_pageframe1.page2.Cmb_FILIAL.Enabled = ;
										  iif(thisformset.pp_anm_per_alt_filial_op,.t.,(v_producao_ordem_01.tipo_processo <> 1 and f_vazio(v_producao_ordem_01.filial_producao)))
										ELSE

										 SELECT v_filiais_00
										 SET FILTER TO
										  
										 thisformset.lx_form1.lx_pageframe1.page2.cmb_filial_producao.Enabled = .t.
										 thisformset.lx_form1.lx_pageframe1.page2.Cmb_FILIAL.Enabled = .t. 

										ENDIF
									ENDIF 
								Endif
					
				case upper(xmetodo) == 'USR_SAVE_BEFORE' 


					xalias=alias()
					
					sele v_producao_ordem_01_tarefas  
					go top	
					loca for fase_producao='021'		
					if !found()
						messagebox("É necessário inserir a Fase 021-Recebimento antes da Revisão ",48,"Atenção!!")
						retu .f.		 
					endif	


					if !f_vazio(xalias)	
						sele &xalias
					endif	




				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE




**************************************************
*-- Class:        lb_filial (c:\temp\lb_filial.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS lb_filial_producao AS lx_label


	Caption = "Filial Ent."
	Height = 15
	Left = 350
	Top = 76
	Width = 20
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_FILIAL_producao"
	Visible = .t.
	Enabled = .t.	
	Alignment=0
	

ENDDEFINE
*
*-- EndDefine: lb_filial
**************************************************



**************************************************
*-- Class:        cmb_filial (c:\temp\cmb_filial.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   10/22/08 05:05:01 PM
*
DEFINE CLASS cmb_filial_producao AS lx_combobox

	RowSource = "v_filiais_001.filial"
	ControlSource = "v_producao_ordem_01.filial_producao"
	Height = 22
	Left = 395
	TabIndex = 1
	Top = 74
	Width = 146
	ZOrderSet = 5
	Name = "cmb_FILIAL_producao"
	Visible = .t.
	Enabled = .t.	

ENDDEFINE
*
*-- EndDefine: cmb_filial
**************************************************





**************************************************
*-- Class:        obs_fin(c:\temp\lb_mata_reserva.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS obs_fin AS editbox


	Caption = "obs_fin"
	Height = 87
	Left = 24
	Top = 226
	Width = 704
	TabIndex = 10
	ZOrderSet = 6
	ControlSource = "v_producao_ordem_01.ANM_OBS_FIN"
	*p_muda_size = .F.
	Name = "obs_fin"
	Visible = .t.
	Enabled = .t.	
	Alignment=0

	
ENDDEFINE
*
*-- EndDefine: obs_fin
**************************************************

**************************************************
*-- Class:        bt_conf_fin (c:\temp\bt_treina.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/30/09 05:21:00 PM
*
DEFINE CLASS bt_conf_fin AS botao


	Top = 207
	Left = 24
	Height = 20 
	Width = 80
	FontBold = .F.
	FontSize = 8
	Caption = "Conf. Financ."
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_conf_fin"
	Visible=.t.
	Enabled=.t.	

	PROCEDURE Click

		IF this.Caption == "Conf. Financ." AND thisformset.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin.value = .F.
			this.Caption = "Salvar"
			thisformset.lx_FORM1.lx_pageframe1.Page11.obs_fin.enabled = .t.
			thisformset.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin.enabled = .t.
		ELSE
			IF thisformset.lx_FORM1.lx_pageframe1.Page11.obs_fin.enabled = .t.
				TEXT TO xUpdFin TEXTMERGE NOSHOW
				
					UPDATE PRODUCAO_ORDEM 
					SET ANM_CK_FINANC = REPLACE(REPLACE('<<THISFORMSET.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin.value>>','.F.',0),'.T.',1),
					ANM_OBS_FIN= LTRIM(RTRIM('<<THISFORMSET.lx_FORM1.lx_pageframe1.Page11.obs_fin.value>>')) 
					WHERE ORDEM_PRODUCAO = '<<v_producao_ordem_01.ordem_producao>>'
				
				ENDTEXT
				
				f_update(xUpdFin)
				
				this.Caption = "Conf. Financ."
				thisformset.lx_FORM1.lx_pageframe1.Page11.obs_fin.enabled = .f.
				thisformset.lx_FORM1.lx_pageframe1.Page11.ck_finaliza_fin.enabled = .f.
				
				IF v_producao_ordem_01.ANM_CK_FINANC = .T.	
					THISFORMSET.lx_FORM1.lb_Finaliza_Fin.visible = .t.
				ELSE	
					THISFORMSET.lx_FORM1.lb_Finaliza_Fin.visible = .f.
				ENDIF
				
			ENDIF	
		ENDIF		 
	

	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_conf_fin 
**************************************************




**************************************************
*-- Class:        ck_finaliza_fin(c:\temp\bt_treina.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/30/09 05:21:00 PM
*
DEFINE CLASS ck_finaliza_fin AS Lx_checkbox


	Top = 210
	Left = 120
	Height = 20 
	Width = 80
	FontBold = .F.
	FontSize = 8
	Alignment = 0
	BackStyle = 0
	Caption = "Finalizado"
	TabIndex = 13
	ControlSource = "v_producao_ordem_01.ANM_CK_FINANC"
	p_muda_size = .F.
	Name = "ck_finaliza_fin"
	Visible=.t.
	Enabled=.f.	
	 


ENDDEFINE
*
*-- EndDefine: ck_finaliza_fin
**************************************************


**************************************************
*-- Class:        lb_Finaliza_Fin(c:\temp\lb_mata_reserva.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS lb_Finaliza_Fin AS lx_label


	Caption = "OP FINALIZADA"
	Height = 15
	Left = 480
	Top = 103
	Width = 22
	TabIndex = 10
	ForeColor = RGB(255,0,0)
	BackColor = RGB(0,0,0)
	FontBold=.t.
	FontSize=15
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_Finaliza_Fin"
	Visible = .f.
	Enabled = .t.	
	Alignment=0
	

ENDDEFINE
*
*-- EndDefine: lb_Finaliza_Fin
**************************************************



**************************************************
*-- Class:        bt_mata_reserva (c:\temp\bt_treina.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/30/09 05:21:00 PM
*
DEFINE CLASS bt_mata_reserva AS botao


	Top = 64
	Left = 300
	Height = 22 
	Width = 94
	FontBold = .F.
	FontSize = 8
	Caption = "Mata Reserva"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_mata_reserva"
	Visible=.t.
	Enabled=.t.	

	PROCEDURE Click


			If V_PRODUCAO_ORDEM_01.STATUS<>'E'
			
				messagebox("A OP não está Encerrada !",48,"Atenção!")
				retu .f. 
				
			Else	

				if messagebox("Deseja Matar Saldo de Reserva desta OP?",4,"Atenção!!!") = 6
				
					text to xupdt noshow textmerge	
						update producao_reserva 
						set diferenca_previsao=reserva,
						reserva=0 
						where ordem_producao='<<V_PRODUCAO_ORDEM_01.ORDEM_PRODUCAO>>' 
						and reserva>0
					endtext
					
					
					if !f_update(xupdt)  
						messagebox("Não foi possível matar saldo desta OP",48,"Atenção!!!")
					endif	
					
					o_toolbar.Botao_refresh.Click()  	
				
				endif	


			Endif


	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_mata_reserva
**************************************************





**************************************************
*-- Class:        bt_altera_reserva (c:\temp\bt_treina.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/30/09 05:21:00 PM
*
DEFINE CLASS bt_altera_reserva AS botao


	Top = 64
	Left = 500
	Height = 22 
	Width = 94
	FontBold = .F.
	FontSize = 8
	Caption = "Altera Reserva"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_altera_reserva"
	Visible=.t.
	Enabled=.t.	

	PROCEDURE Click


			If V_PRODUCAO_ORDEM_01.STATUS='E'
			
				messagebox("A OP está Encerrada !",48,"Atenção!")
				retu .f. 
				
			Else	

				if messagebox("Deseja Alterar Reserva desta OP?",4,"Atenção!!!") = 6 

					sele v_producao_ordem_01_materiais
					repla tipo_reserva with 2 

					thisformset.Lx_form1.lx_PAGEFRAME1.page3.lX_PAGEFRAME1.page1.lx_GRID_FILHA1.Refresh()
					xReservaAnterior = V_PRODUCAO_ORDEM_01_MATERIAIS.RESERVA_ORIGINAL

				endif	


			Endif


	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_mata_reserva
**************************************************


**************************************************
*-- Class:        lb_filial (c:\temp\lb_mata_reserva.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS lb_mata_reserva AS lx_label


	Caption = "Mata Reserva"
	Height = 15
	Left = 300
	Top = 64
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_mata_reserva"
	Visible = .t.
	Enabled = .t.	
	Alignment=0
	
	Procedure DblClick	
	
		MESSAGEBOX("aprendendo!!",48,"atenção!")
	
	Endproc
	

ENDDEFINE
*
*-- EndDefine: lb_mata_reserva
**************************************************







