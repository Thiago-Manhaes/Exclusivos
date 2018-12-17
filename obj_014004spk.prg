* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  15/01/2017                                                                                      *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao campo CPF					                    												*
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
		*	
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

						*** Inclusão da coluna CPF na view ***
						Sele V_USERS_00
						xalias_pai=alias()
						oCur = getcursoradapter(xalias_pai)
						oCur.addbufferfield("ANM_CPF", "C(14)" ,.T., "CPF", "ANM_CPF")
						oCur.confirmstructurechanges()	
						
						Thisformset.DAtaEnvironment.Cur_v_users_00.UpdatableFieldList = ;
						Thisformset.DAtaEnvironment.Cur_v_users_00.UpdatableFieldList + ",ANM_CPF"
						Thisformset.DAtaEnvironment.Cur_v_users_00.UpdateNameList = ;
						Thisformset.DAtaEnvironment.Cur_v_users_00.UpdateNameList+ ",ANM_CPF USERS.ANM_CPF"
						
						with thisformset.lx_form1
							.addobject("lb_cpf","lb_cpf")
							.addobject("tx_cpf","tx_cpf") 
						endwith	
						
						Thisformset.l_limpa()
					
				    if	!f_vazio(xalias)	
					  sele &xalias 
				    ENDIF
										
			otherwise
			return .t.				
		endcase
	endproc

ENDDEFINE
**************************************************
*-- Class:        tx_cpf (c:\users\julio.cesar\onedrive\1.grupo soma\aplicacoes\classes\tx_cpf.vcx)
*-- ParentClass:  lx_textbox_base (c:\linx grupo soma\aaf\exclusivos\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   01/15/17 03:34:09 PM
*
DEFINE CLASS tx_cpf AS lx_textbox_base


	ControlSource = "V_USERS_00.ANM_CPF"
	Visible = .t.
	Height = 19
	Left = 492
	Top = 44
	Width = 222
	Name = "tx_CPF"
	p_tipo_dado = 'EDITA'

ENDDEFINE
*
*-- EndDefine: tx_cpf
**************************************************
**************************************************
*-- Class:        lb_cpf (c:\users\julio.cesar\onedrive\1.grupo soma\aplicacoes\classes\lb_cpf.vcx)
*-- ParentClass:  lx_label (c:\linx grupo soma\aaf\exclusivos\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   01/15/17 03:35:00 PM
*
DEFINE CLASS lb_cpf AS lx_label
	
	Visible = .t.
	FontBold = .T.
	FontSize = 10
	Caption = "CPF:"
	Height = 18
	Left = 458
	Top = 45
	Width = 29
	TabIndex = 18
	ZOrderSet = 10
	Name = "lb_cpf"

ENDDEFINE
*
*-- EndDefine: lb_cpf
**************************************************