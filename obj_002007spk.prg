* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesae                                                                                                *
* DATA...........:  07/02/2011                                                                                               *
* HORÁRIO........:  12:16                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Retirar espaços antes do nome clifor e bloquear cadastro sem conta contabil					                    *
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
						
						thisformset.lx_FORM1.lx_pageframe1.PageCount=7
						thisformset.lx_FORM1.lx_pageframe1.page6.Caption="Alterar Preços"
						thisformset.lx_form1.lx_pageframe1.page6.addobject("data_job","data_job")
						thisformset.lx_form1.lx_pageframe1.page6.addobject("bt_busca_arq","bt_busca_arq")
						thisformset.lx_form1.lx_pageframe1.page6.addobject("bt_agenda","bt_agenda")
						thisformset.lx_form1.lx_pageframe1.page6.addobject("lb_busca_arq","lb_busca_arq")
						
						f_select("SELECT * FROM ANM_LOG_JOB_PRECO","xLogJob",ALIAS())
						
						thisformset.lx_form1.lx_pageframe1.page6.addobject("lb_process","lb_process")
						thisformset.lx_form1.lx_pageframe1.page6.lb_process.caption = xLogJob.processo+TTOC(xLogJob.data_hora)
						thisformset.lx_FORM1.lx_pageframe1.page6.enabled = .F.
								
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
					
					
					case upper(xmetodo) == 'USR_REFRESH'
				
					xalias=alias()
						
						f_select("select valor_propriedade from propriedade_valida where propriedade = '00170' and valor_propriedade =?wusuario","xValidaUser",ALIAS())
					
						sele xValidaUser	
						IF RECCOUNT() > 0
							If type('thisformset.lx_form1.lx_pageframe1.page6.lb_process')<>'U'	
								
								f_select("SELECT * FROM ANM_LOG_JOB_PRECO_FARM","xLogJob",ALIAS())	
								thisformset.lx_form1.lx_pageframe1.page6.lb_process.caption = xLogJob.processo+TTOC(xLogJob.data_hora)
							
								IF thisformset.p_tool_status = 'P'
									thisformset.lx_FORM1.lx_pageframe1.page6.enabled = .T.
								ELSE
									thisformset.lx_FORM1.lx_pageframe1.page6.enabled = .F.
								ENDIF
							
							Endif	
						ENDIF

					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
					
					
					case upper(xmetodo) == 'USR_ALTER_BEFORE'
				
					xalias=alias()
									
						sele xValidaUser
						IF RECCOUNT() = 0
							MESSAGEBOX("NÃO TEM PERMISSÃO PARA ALTERAR PREÇO NESSA TELA",0+64)
							RETURN .F.	
						ENDIF
					
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
					
					
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE



**************************************************
*-- Class:        data_job (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:14 PM
*
DEFINE CLASS data_job AS textbox

	Top = 100
	Left = 50
	Width = 125
	TabIndex = 48
	Name = "data_job"
	InputMask = "99/99/9999T99:99:99"
	*value = STR(CTOD(''))+"T"+STR(CTOT(''))
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: data_job 
**************************************************



**************************************************
*-- Class:        data_job (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:14 PM
*
DEFINE CLASS lb_busca_arq AS textbox

	Top = 50
	Left = 50
	Width = 450
	TabIndex = 48
	Name = "lb_busca_arq"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: data_job 
**************************************************


**************************************************
*-- Class:        lb_anm_frete_adicional (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_process AS lx_label


	*Caption = ""
	Top = 80
	Left = 50
	Width = 450
	TabIndex = 48
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	*ZOrderSet = 6
	*p_muda_size = .F.
	Name = "lb_process"
	Visible = .t.
	*Anchor = 1
	FontBold = .T.


ENDDEFINE
*
*-- EndDefine: lb_anm_frete_adicional 
**************************************************



**************************************************
*-- Class:        hora_job(c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:14 PM
*
DEFINE CLASS bt_busca_arq AS botao


	Top = 47
	Left = 505
	*Height = 23
	Width = 55
	*FontBold = .T.
	Caption = "Procurar"
	TabIndex = 48
	Name = "bt_busca_arq"
	Visible = .T.


	PROCEDURE Click
	
		MM=GETFILE("dbf")
		thisformset.lx_form1.lx_pageframe1.page6.lb_busca_arq.value=MM
		
		IF MESSAGEBOX("Todos os Produtos já importados serão deletados antes de efetuar a importação. Deseja continuar?",4+48) = 6
			f_update("DELETE PRODUTOS_PRECOS WHERE CODIGO_TAB_PRECO = 'LZ'")
					
			SELECT 0
			USE (MM) ALIAS TAB
			GO TOP
			DO WHILE !EOF()

			   @08,20 say RECNO()
			   
			   xProduto = Produto
			   xPreco =  Novo_Preco
				
			   f_update("INSERT INTO PRODUTOS_PRECOS (CODIGO_TAB_PRECO,PRODUTO,PRECO1,DATA_PARA_TRANSFERENCIA) VALUES ('LZ',?xProduto,?xPreco,getdate())")
			   
			   SELECT TAB
			   SKIP
			   
			ENDDO
			
			o_toolbar.Botao_refresh.Click()
		ENDIF	
	ENDPROC

ENDDEFINE
*
*-- EndDefine: hora_job
**************************************************



**************************************************
*-- Class:        bt_copia_dados (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:14 PM
*
DEFINE CLASS bt_agenda AS botao


	Top = 97
	Left = 180
	Width = 55
	Caption = "Agendar"
	TabIndex = 48
	Name = "bt_agenda"
	Visible = .T.


	PROCEDURE Click
	
			xData = RIGHT(STRTRAN(LEFT(thisformset.lx_form1.lx_pageframe1.page6.data_job.value,10),'/',''),4)+;
					LEFT(RIGHT(STRTRAN(LEFT(thisformset.lx_form1.lx_pageframe1.page6.data_job.value,10),'/',''),6),2)+;
					LEFT(STRTRAN(LEFT(thisformset.lx_form1.lx_pageframe1.page6.data_job.value,10),'/',''),2)
				
			xHora = STRTRAN(RIGHT(thisformset.lx_form1.lx_pageframe1.page6.data_job.value,8),':','')
	
	
	f_select("SELECT * FROM ANM_LOG_JOB_PRECO","xLogJob",ALIAS())
	
	IF xLogJob.processo = ALLTRIM('Processo agendado para')
		IF MESSAGEBOX("Já existe um agendamento para "+TTOC(xLogJob.data_hora)+", Deseja alterar o agendamento ?",4+32)=7
			RETURN .F.
		ENDIF
	ENDIF		
	
	IF LEN(ALLTRIM(thisformset.lx_form1.lx_pageframe1.page6.data_job.value)) = 19 		
		
		TEXT TO xDelJob TEXTMERGE NOSHOW
		
			EXECUTE msdb.dbo.sp_delete_JOBSCHEDULE  @JOB_name = N'ALTERACAO_PRECO_LIQUIDACAO' ,@name = N'ALTERACAO_PRECO_LIQUIDACAO'
		
		ENDTEXT
		
			f_update(xDelJob)
		
		TEXT TO xExeJob TEXTMERGE NOSHOW

			DECLARE @JOBID BINARY(16)
			DECLARE @RETURNCODE INT
			SELECT @RETURNCODE = 0
			SELECT @JOBID=JOB_ID FROM msdb.dbo.sysjobs where (name = N'ALTERACAO_PRECO_LIQUIDACAO')
			EXECUTE @RETURNCODE = msdb.dbo.sp_add_JOBschedule
			@JOB_id = @JOBID, 
			@name = N'ALTERACAO_PRECO_LIQUIDACAO',
			@enabled = 1,
			@freq_type = 1,
			@active_start_date =  <<xData>>,
			@active_start_time = <<xHora>>,
			@freq_interval = 1,
			@freq_subday_type = 0,
			@freq_subday_interval =0,
			@freq_relative_interval = 0,
			@freq_recurrence_factor = 1,
			@active_end_date = <<xData>>
		ENDTEXT
		
		wCodPreco = INPUTBOX('',"Qual tabela deseja alterar?",'V')
		IF !EMPTY(wCodPreco)
			f_select("select RTRIM(tabela) tabela from TABELAS_PRECO where CODIGO_TAB_PRECO = ?wCodPreco","xCodPreco")
 			
 			IF ALLTRIM(wCodPreco)='VO'
				MESSAGEBOX("Tabela de Preço VO - VENDA ORIGINAL, Não permitida!",64)
				RETURN .F.
			ENDIF
			
			sele xCodPreco
			IF RECCOUNT()=0
				MESSAGEBOX("Tabela de Preço não encontrada!",64)
				RETURN .F.
			ELSE
				IF MESSAGEBOX("Confirma a alteração da tabela "+ALLTRIM(xCodPreco.tabela)+" ?",36)=7
					RETURN .F.
				ENDIF	
			ENDIF
				 
		ELSE
			MESSAGEBOX("Tabela de Preço não informada!",64)
			RETURN .F.
		ENDIF

					
		TEXT TO xLogJob TEXTMERGE NOSHOW
		
			UPDATE ANM_LOG_JOB_PRECO
			SET PROCESSO = 'Processo agendado para ',
			DATA_HORA = ('<<xData>> '+RIGHT('<<thisformset.lx_form1.lx_pageframe1.page6.data_job.value>>',8)),
			CODIGO_TAB_PRECO = '<<wCodPreco>>'
		
		ENDTEXT
		
		f_update(xLogJob)
		
		f_select("SELECT * FROM ANM_LOG_JOB_PRECO","xLogJob",ALIAS())
		
		IF f_update(xExeJob)
			MESSAGEBOX("Agendado com sucesso para "+TTOC(xLogJob.data_hora),0+64)
			thisformset.lx_form1.lx_pageframe1.page6.lb_process.caption = xLogJob.processo+TTOC(xLogJob.data_hora)
		ENDIF
								
	ELSE
		MESSAGEBOX("ATENÇAO !! Campo Data e Hora Inválido",0+58)
	ENDIF	
	
	
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_copia_dados
**************************************************