* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Seleção por Acompanhamento					                    *
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
				
					public xPai_Filtro,xTempACP	
					xPai_Filtro=thisformset.p_pai_filtro
					xTempACP=0
					xalias=alias()
					
						thisform.dataEnvironment.cUR_V_CTB_ACOMPANHAMENTO_00.KeyFieldList="EMPRESA, LANCAMENTO, ITEM, SUB_ITEM, DATA_DIGITACAO, DATA_ACOMPANHAMENTO, OCORRENCIA"    
					
						text to xsel_ocorrencia noshow textmerge	
							select convert(varchar(50),'') as desc_ocorrencia,'' as ocorrencia
							union all
							select desc_ocorrencia,ocorrencia from ctb_ocorrencia
						endtext
					

						f_select(xsel_ocorrencia ,"curOcorrencias",alias())
					

			             with thisformset.lx_form1.lx_PAGEFRAME1.page2 	
								
								.addObject("cmb_acompanhamento","lx_combobox")
								.cmb_acompanhamento.visible=.t.
								.cmb_acompanhamento.top=265
								.cmb_acompanhamento.left=400
								.cmb_acompanhamento.width=225
								.cmb_acompanhamento.controlsource=curOcorrencias.desc_ocorrencia 
								.cmb_acompanhamento.rowsource='curOcorrencias.desc_ocorrencia'
								.cmb_acompanhamento.enabled=.t.
								.cmb_acompanhamento.rowsourcetype=2
								.cmb_acompanhamento.value='' 
								.cmb_acompanhamento.Anchor=0
							
			              endwith	

					 with thisformset.lx_forM1.lx_pageframe1.page2.Cnt_LANC_AUXILIAR	 	
						

								.addObject("lb_consumidor","lb_consumidor")
								.lb_consumidor.Height = thisformset.lx_forM1.lx_pageframe1.page2.Cnt_LANC_AUXILIAR.Lx_label1.Height
								.lb_consumidor.Left  = thisformset.lx_forM1.lx_pageframe1.page2.Cnt_LANC_AUXILIAR.Lx_label1.left
								.lb_consumidor.Top = thisformset.lx_forM1.lx_pageframe1.page2.Cnt_LANC_AUXILIAR.Lx_label1.top
								.lb_consumidor.Width = thisformset.lx_forM1.lx_pageframe1.page2.Cnt_LANC_AUXILIAR.Lx_label1.width
								.lb_consumidor.Caption = thisformset.lx_forM1.lx_pageframe1.page2.Cnt_LANC_AUXILIAR.Lx_label1.Caption 
								.Lx_label1.visible=.f.								
								.Lx_label1.top=-1000	
					endwith
					
					if !f_vazio(xalias)
						sele &xalias
					endif	




				case upper(xmetodo) == 'USR_SEARCH_BEFORE'  
					
					xalias=alias()

					If type("thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento")<>"U"
						
						if 	!f_vazio(thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento.value)
							
							text to xFiltroObj noshow textmerge	
								and ctb_lancamento.lancamento in		
								(select lancamento from ctb_acompanhamento where ocorrencia in 
								(select ocorrencia from ctb_ocorrencia where desc_ocorrencia='<<thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento.value>>'))						
							endtext	
							
							thisformset.p_pai_filtro=thisformset.p_pai_filtro+xFiltroObj 
								
						endif	
						
					Endif	


					if !f_vazio(xalias)
						sele &xalias
					endif	

				


				case upper(xmetodo) == 'USR_CLEAN_AFTER'  

					If type("thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento")<>"U"
						thisformset.lx_form1.lx_PAGEFRAME1.page2.cmb_acompanhamento.value=""
						thisformset.p_pai_filtro=xPai_Filtro
					Endif	

			***** Julio - Ajusta para zerar a tela de acompanhamento na hora que inclui um item no lancamento ********	
				case upper(xmetodo) == 'USR_ITEN_INCLUDE_AFTER'  
					
					xalias=alias()
	
						xTempACP = 1

					if !f_vazio(xalias)
						sele &xalias
					endif
				
					
				case upper(xmetodo) == 'USR_VALID'  and upper(xnome_obj) == 'CMDACOMPANHAMENTO' 
					
					xalias=alias()
					
					
						If xTempACP = 1
								thisformset.lx_forM1.Lx_pageframe1.page2.Cnt_LANC_AUXILIAR.Lx_tool_filhas1.Botao_proximo.Click()
								xTempACP = 0
								Thisformset.lx_acompanhamento12.Refresh()									
						Else
								Thisformset.lx_acompanhamento12.Refresh()
						EndIf
					
					
					if !f_vazio(xalias)
						sele &xalias
					endif	
				**** Julio - Fim do Ajuste


				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE

**************************************************
*-- Class:        label_conta_contabil (c:\temp\label_conta_contabil.vcx)
*-- ParentClass:  lx_label (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/13/11 01:48:13 PM
*
DEFINE CLASS lb_consumidor AS lx_label


	Name = "lb_consumidor"
	Enabled = .t.
	Visible = .t.

	PROCEDURE DblClick
		
		dodefault()
		
		IF thisformset.p_tool_status='P'		

			xalias=alias()
						
			
			if upper(wusuario)='SA' OR upper(wusuario)='DAYENNE'
			
				if f_vazio(thisformset.lx_forM1.lx_pageframe1.page2.Cnt_LANC_AUXILIAR.tv_codigo_consumidor.value)
				
					If messagebox("Deseja Cadastrar o Cpf?",4+32+256,"Atenção!!!")=6 
			
						xnewCont=inputbox("Digite o Cpf.","")	
								
				
							text to	xUpdt noshow textmerge	
								
								update ctb_cheque_cartao
								set codigo_consumidor = '<<allt(xnewCont)>>'
								where lancamento = '<<v_ctb_lancamento_01_item.lancamento>>'
								and   empresa='<<v_ctb_lancamento_01_item.empresa>>'					
							
							endtext	
						
						if !f_vazio(xnewCont)

							if !f_update(xUpdt)
								messagebox("Não foi possível Cadastrar o Cpf!",48,"Atenção!")
								retu .f.
							endif	
					
							o_toolbar.Botao_refresh.Click()  
							
							messagebox("Cpf Cadastrado com Sucesso!",48,"Atenção!")
								
						endif		
					
					endif
				endif
			Endif	
			
			

			if !f_vazio(xalias)
				sele &xalias
			endif	

		ENDIF 		
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: label_conta_contabil
**************************************************

