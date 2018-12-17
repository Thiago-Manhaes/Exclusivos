* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Marco Banaggia                                                                                 *
* DATA...........:  19/03/2018                                                                                      *
* HOR��RIO........:  15:30                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Bot�o de agendamento para JOB						                    *
********************************************************************************************************************* 

* Altera��o ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HOR��RIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Cria��oo de Objeto de Entrada                                                                    *
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
					addnewobject(THISFORMSET.lx_FORM1,"bt_agenda_job","bt_agenda_job")
					
					
				CASE UPPER(xmetodo) == 'USR_ALTER_AFTER'
					THISFORMSET.lx_FORM1.bt_agenda_job.enabled=.t.
					
				CASE UPPER(xmetodo) == 'USR_REFRESH'
					IF thisformset.P_TOOL_STATUS == "P"
						THISFORMSET.lx_FORM1.bt_agenda_job.enabled=.f.
					ENDIF
									
				otherwise
				return .t.				
			endcase

	ENDPROC

ENDDEFINE

**************************************************
*-- Class:        bt_agenda_job ()
*-- ParentClass:  botao ()
*-- BaseClass:    commandbutton
*-- Time Stamp:   02/12/15 05:58:05 PM
**************************************************

DEFINE CLASS bt_agenda_job AS botao

	Top = 80
	Left = 528
	Height = 27
	Width = 144
	Caption = "\<Agendar JOB"
	Name = "bt_agenda_job"
	Visible = .t.
	Enabled = .f.

	PROCEDURE CLICK
	LOCAL resposta as Date, dtIni as Date, dtFim as Date , a as Integer, xCusto as string, xComando as String, Retorno as String
	
	
		xCusto = LEFT(thisformset.lx_FORM1.tv_COD_CUSTO_MEDIO.Value,6)
		
		*MESSAGEBOX(xComando)
		
		SET MARK TO "/"
		
		ddate=DTOS(date())
		ddate=RIGHT(ddate,2)+"/"+SUBSTR(ddate,5,2)+"/"+LEFT(ddate,4)

		Retorno = INPUTBOX("Digite a data para agendamento","Informa��o",ddate,0,'Timed Out','Cancelado')
		IF Retorno <> "Cancelado"
			resposta = ddate

			dtIni = DATE()
			dtFim = CTOD(resposta)
			resposta=RIGHT(resposta,4)+SUBSTR(resposta,4,2)+LEFT(resposta,2)
			
			a = (dtFim-DtIni)
			
			IF (a < 0)
				MESSAGEBOX("Data menor que o dia corretente, n�o agendando!",16,"Aten��o")
			ELSE
				xComando = ""	
				TEXT TO xComando TEXTMERGE noshow
					EXEC msdb.dbo.sp_update_jobstep  @job_name = N'DISABLE_000_2315_ATUALIZAR_CUSTO_MEDIO',  @step_id = 1, @command = N'EXEC LX_GS_AJUSTA_ENTRADA_VIRADA_MES_CUSTO_MEDIO';
				ENDTEXT
				f_execute(xComando)
				
				xComando = ""
				TEXT TO xComando TEXTMERGE NOSHOW 
					EXEC msdb.dbo.sp_update_jobstep @job_name = N'DISABLE_000_2315_ATUALIZAR_CUSTO_MEDIO', @step_id = 2, @command = N'UPDATE CM_DATA_FECHAMENTO SET DATA_SALDO_MP = ''20171231''
						GO
						UPDATE CM_DATA_FECHAMENTO SET DATA_SALDO_PA = ''20171231''
						GO
						UPDATE PARAMETROS SET VALOR_ATUAL=''31/12/2015'' WHERE PARAMETRO = ''DATA_BLOQUEIO_MOV_MP''
						go
						UPDATE PARAMETROS SET VALOR_ATUAL=''31/12/2015'' WHERE PARAMETRO = ''DATA_BLOQUEIO_MOV_PA''
						go
						EXEC LX_CM_FECHAMENTO_CUSTO_MEDIO ''<<xCusto>>'',1
						go';			
				ENDTEXT				
				f_execute(xComando)
				
				f_execute("exec MSDB..sp_update_Jobschedule @job_id='68AEC64A-0516-4693-9280-B65B55D99B2E',@name='ATUALIZAR_CUSTO_MEDIO', @enabled=1, @active_start_date='"+ resposta +"', @active_end_date='"+ resposta +"'")
				MESSAGEBOX("Agendamento realizado!",64,"Informa��o")
			ENDIF
		ENDIF 	


	ENDPROC

ENDDEFINE