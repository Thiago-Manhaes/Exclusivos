* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  07/02/2012                                                                                      *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: 
*						                    *
********************************************************************************************************************* 
******************************************************
*- Programa Base de Criação de Objeto de Entrada
********************************************************************
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos 
*******************************************************************************
*- Existem 2 parametros que influem nos objetos de Entrada:  
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento
*********************************************************************************


*********************************************************************************
* - Atencao !!!!!!!!!!!														   -*
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP -*
*********************************************************************************

*
*                 Abaixo segue Programa objeto sem Codigo 
*
*
*- Definindo a classe do objeto de entrada que sera criado na Form.
define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.
	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT
		*	USR_ALTER_BEFORE  ->Return .f. Para o Metodo
		*	USR_ALTER_AFTER    
		*	USR_INCLUDE_AFTER
		*	USR_SEARCH_BEFORE ->Return .f. Para o Metodo
		*	USR_SEARCH_AFTER
		*	USR_CLEAN_AFTER
		*	USR_REFRESH
		*	USR_SAVE_BEFORE   ->Return .f. Para o Metodo 
		*	USR_SAVE_AFTER
		*	USR_ITEN_DELETE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_DELETE_AFTER
		*	USR_ITEN_INCLUDE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_INCLUDE_AFTER
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Validação
		*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		do case
			*- metodo do inicio da form
				


			   case UPPER(xmetodo) == 'USR_INIT'
			   
			   	xalias=alias()
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
					Sele cur_ctb_lx_metodo_pagamento
					xalias_pai=Alias()
					oCur = Getcursoradapter(xalias_pai)
					oCur.addbufferfield("CTB_LX_METODO_PAGAMENTO.ANM_N_VALIDA_PAGAMENTO", "L",.F., "Não Valida Pagamento", "CTB_LX_METODO_PAGAMENTO.ANM_N_VALIDA_PAGAMENTO")
					oCur.confirmstructurechanges()
					

					WITH Thisformset.lx_form1.lx_grid_filha
							.AddColumn(1)
							.Column1.Name='cl_n_valida_pgto'
							WITH .cl_n_valida_pgto
									.BackColor = RGB(251,245,220)
									.Header1.Name='h_n_valida_pgto'
									.h_n_valida_pgto.Caption='Não Valida Pgto'
									.h_n_valida_pgto.FontName ='tahoma'
									.h_n_valida_pgto.FontSize = 8
									.h_n_valida_pgto.Alignment = 2
									.AddObject('ck_n_valida_pgto','CheckBox')
									.Sparse= .F.
									.CurrentControl = 'ck_n_valida_pgto'
									.ck_n_valida_pgto.Caption=""
									.ColumnOrder = 1
									.ck_n_valida_pgto.BackStyle = 0
									.ck_n_valida_pgto.Visible = .T.
									.ck_n_valida_pgto.Enabled = .F.
									.RemoveObject("text1")
									.ControlSource="cur_ctb_lx_metodo_pagamento.ANM_N_VALIDA_PAGAMENTO"
							ENDWITH	
					ENDWITH						
					
			      if	!f_vazio(xalias)	
						  sele &xalias 
					ENDIF
					  
			       case UPPER(xmetodo)=='USR_REFRESH' 
			       
			       xalias=alias()
				       If TYPE('Thisformset.lx_form1.lx_grid_filha.cl_n_valida_pgto.ck_n_valida_pgto')<>'U'
							If THISFORMSET.P_tool_status == 'A'
								Thisformset.lx_form1.lx_grid_filha.cl_n_valida_pgto.ck_n_valida_pgto.Enabled=.t.
							Else	
								Thisformset.lx_form1.lx_grid_filha.cl_n_valida_pgto.ck_n_valida_pgto.Enabled=.F.
							Endif	
						Endif 

				    if	!f_vazio(xalias)	
						  sele &xalias 
					endif
					    

			    
			   
				
				otherwise
					return .t.				
		endcase
	endproc
enddefine

*!*	**************************************************
*-- Class:        ck_n_valida_pgto(c:\users\lucas.miranda\desktop\ck_n_valida_pgto.vcx)
*-- ParentClass:  lx_checkbox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   04/08/16 02:20:05 PM
DEFINE CLASS ck_liberar_grade_web AS lx_checkbox


	Top = 10
	Left = 18
	Height = 15
	Width = 88
	AutoSize = .T.
	Alignment = 0
	Caption = "Não Valida Pgto"
	ControlSource = ""
	Name = "ck_n_valida_pgto"


ENDDEFINE
*
*-- EndDefine: ck_n_valida_pgto
**************************************************