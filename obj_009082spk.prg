* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Inclusão de Baixas de Solicitação de Verba                                                                                                   *
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
			
			case UPPER(xmetodo) == 'USR_INIT' 				
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 

				public xProcessadoSVM
				xProcessadoSVM=.F.
				
				addnewobject(thisformset.lx_FORM1.lx_pageframe1.page2,"ck_processa_solicitacao_verba","ck_processa_solicitacao_verba")	
				addnewobject(thisformset.lx_FORM1.lx_pageframe1.page2,"bt_fecha_lanc","bt_fecha_lanc")


			case UPPER(xmetodo) == 'USR_SEARCH_AFTER' 
			
				if thisformset.lx_FORM1.lx_pageframe1.page2.ck_processa_solicitacao_verba.value
					
					xalias=alias()
					
					xFiltroSolicitacao=(strtran(strtran(strtran(strtran(thisformset.p_clausula_where,"W_CTB_A_PAGAR_PARCELA_MOV","WANM_CTB_SOLICITACAO_VERBA_MOV")," E "," AND ")," CONTENDO "," LIKE ")," OU "," OR "))
					text to xselSolicitacao noshow textmerge	
						select * from wanm_ctb_solicitacao_verba_mov 
						where <<xFiltroSolicitacao>>  
					endtext
					
					f_select(xselSolicitacao , "curSVM")	
					
					sele curSVM
					go top	
					scan	
						f_prog_bar("Inserindo Solicitações de Verba...",recno(),reccount())
						scatter to xmemvar	
						sele v_ctb_a_pagar_parcela_mov_01						
						appe blank	
						gather from xmemvar	
						sele curSVM	
					endscan					
					f_prog_bar()
					
					sele v_ctb_a_pagar_parcela_mov_01	
					
					xProcessadoSVM=.T.
					
					if f_vazio(xalias)
						sele &xalias
					endif	

				endif	

				
					
					

			case UPPER(xmetodo) == 'USR_VALID' and upper(xnome_obj) == 'CK_PROCESSA_SOLICITACAO_VERBA'
					

				If thisformset.p_tool_status='P'
				
					if xProcessadoSVM	
						xOldValue=iif(thisformset.lx_FORM1.lx_pageframe1.page2.ck_processa_solicitacao_verba.value=.f.,.t.,.f.)
						messagebox("Você Já Processou as Solicitações de Verba!",48,"Atenção!!!")
						thisformset.lx_FORM1.lx_pageframe1.page2.ck_processa_solicitacao_verba.value=xOldValue
						retu .f.
					endif	
					
					xalias=alias()
					
					xFiltroSolicitacao=(strtran(strtran(strtran(strtran(thisformset.p_clausula_where,"W_CTB_A_PAGAR_PARCELA_MOV","WANM_CTB_SOLICITACAO_VERBA_MOV")," E "," AND ")," CONTENDO "," LIKE ")," OU "," OR "))
					*xFiltroSolicitacao=thisformset.p_comando_where 
					text to xselSolicitacao noshow textmerge	
						select * from wanm_ctb_solicitacao_verba_mov 
						where <<xFiltroSolicitacao>>  
					endtext
					
					f_select(xselSolicitacao , "curSVM")	
					
					sele curSVM
					go top	
					scan	
						f_prog_bar("Inserindo Solicitações de Verba...",recno(),reccount())						
						scatter to xmemvar	
						sele v_ctb_a_pagar_parcela_mov_01						
						appe blank	
						gather from xmemvar	
						sele curSVM	
					endscan					
					f_prog_bar()
					
		
					sele v_ctb_a_pagar_parcela_mov_01	

					xProcessadoSVM=.T.

					if f_vazio(xalias)
						sele &xalias
					endif	

				Endif	




			case UPPER(xmetodo) == 'USR_CLEAN_AFTER' 	
					
					if type("xProcessadoSVM")<>"U"
						xProcessadoSVM=.F.
					endif	
					
					if	type("thisformset.lx_FORM1.lx_pageframe1.page2.ck_processa_solicitacao_verba") <> "U"
						thisformset.lx_FORM1.lx_pageframe1.page2.ck_processa_solicitacao_verba.value=.f.
					endif			
	
	
	
			otherwise
				return .t.				
		endcase
	endproc
enddefine

**************************************************
*-- Class:        ck_processa_solicitacao_verba (c:\linx_sql\linx\exclusivos\ck_processa_solicitacao_verba.vcx)
*-- ParentClass:  lx_checkbox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   02/22/11 04:01:03 PM
*
DEFINE CLASS ck_processa_solicitacao_verba AS lx_checkbox


	Top = 247
	Left = 185
	Height = 15
	Width = 151
	Alignment = 0
	BackStyle = 1
	Caption = "Processa Solicitação Verba"
	Value = .F.
	TabIndex = 39
	BackColor = RGB(247,247,239)
	ZOrderSet = 31
	p_muda_size = .F.
	Name = "ck_processa_solicitacao_verba"
	Visible = .T.
	Enabled = .T.


ENDDEFINE
*
*-- EndDefine: ck_processa_solicitacao_verba
**************************************************

**************************************************
*-- Class:        bt_fecha_lanc (c:\temp\rbx\bt_fecha_lanc.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:14 PM
*
DEFINE CLASS bt_fecha_lanc AS botao


	Top = 275
	Left = 320
	Height = 23
	Width = 151
	Caption = "Fechar Lançamento"
	TabIndex = 48
	Name = "bt_fecha_lanc"
	Visible = .T.
 

PROCEDURE Click

	SELECT v_ctb_a_pagar_parcela_mov_01
	GO TOP

	SCAN
		SELECT v_ctb_a_pagar_parcela_mov_01
		f_prog_bar("Fechando Lançamento: "+STR(v_ctb_a_pagar_parcela_mov_01.lancamento_mov),recno(),reccount())
		
		TEXT TO xRec NOSHOW TEXTMERGE 
			EXECUTE LX_CTB_INTEGRAR_FECHAMENTO 1,<<v_ctb_a_pagar_parcela_mov_01.lancamento_mov>>
		ENDTEXT 	
	
		f_update(xRec)	
	ENDSCAN

	SELECT v_ctb_a_pagar_parcela_mov_01
	GO TOP

	f_prog_bar()
	
ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_fecha_lanc
**************************************************