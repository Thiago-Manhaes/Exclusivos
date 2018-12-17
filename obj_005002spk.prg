* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  01-03-2014                                                                                      *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                               			*
* OBJETIVO.: 					                    																*
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
					
						xVersao = '01.1'
						f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
						f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
						WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 	
						
						Sele v_series_nf_00
						xalias_pai=alias()
						
						oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("SERIES_NF.GS_OBS", "M",.T., "SERIES_NF.GS_OBS", "SERIES_NF.GS_OBS")
						oCur.confirmstructurechanges() 
						
						with thisformset.lx_form1.lx_pageframe1
							 .PageCount = Thisformset.lx_form1.lx_pageframe1.PageCount+1
							 .Page4.FontSize = 8
							 .Page4.FontName = "Tahoma"		
							 .Page4.Caption = "Observação"			
							 .Page4.AddObject("gs_label_obs","gs_label_obs")	
							 .Page4.AddObject("ed_obs","ed_obs")
							 .Page4.ed_obs.controlsource="v_series_nf_00.gs_obs"
						endwith
						
						Thisformset.L_limpa()	
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
				case upper(xmetodo) == 'USR_REFRESH'
					if type("thisformset.lx_form1.lx_pageframe1.page4.ed_obs")<>"U"
						if thisformset.p_tool_status $ 'IAL'
							thisformset.lx_form1.lx_pageframe1.page4.ed_obs.enabled=.T.
						else
							thisformset.lx_form1.lx_pageframe1.page4.ed_obs.enabled=.F.
						endif				
					endif	
				
				
				
									
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE

**************************************************
*-- Class:        gs_label_obs (e:\linx_sql_fontecompleta\class pessoal\gs_label_obs.vcx)
*-- ParentClass:  lx_label (e:\linx spk 2018 novo\exclusivos\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   07/24/18 08:52:03 AM
*
DEFINE CLASS gs_label_obs AS lx_label


	AutoSize = .T.
	FontBold = .T.
	FontSize = 8
	Alignment = 0
	Caption = "Observações gerais sobre série"
	Height = 15
	Left = 9
	Top = 9
	Width = 179
	TabIndex = 3
	p_fixa_left = .T.
	Name = "gs_label_obs"
	Visible = .T.


ENDDEFINE
*
*-- EndDefine: gs_label_obs
**************************************************
**************************************************
*-- Class:        ed_obs (e:\linx_sql_fontecompleta\class pessoal\ed_obs.vcx)
*-- ParentClass:  lx_editbox (e:\linx spk 2018 novo\exclusivos\lx_class.vcx)
*-- BaseClass:    editbox
*-- Time Stamp:   07/24/18 08:52:07 AM
*
DEFINE CLASS ed_obs AS lx_editbox


	FontSize = 8
	Height = 171
	Left = 9
	TabIndex = 1
	Top = 29
	Width = 493
	*ControlSource = "V_CLIENTES_01.OBS"
	Name = "ed_obs"
	Visible = .T.


ENDDEFINE
*
*-- EndDefine: ed_obs
**************************************************