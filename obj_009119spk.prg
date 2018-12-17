* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Wallace Pacheco                                                                                 *
* DATA...........:  04/04/2016                                                                                      *
* HORÁRIO........:  18:00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Botão de exportar cursor para Excel						                    *
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

	**	=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
				
				case upper(xmetodo) == 'USR_INIT' 
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					THISFORMSET.lx_FORM1.pg_assistente.page2.tx_check_data_liberacao.value=1
					THISFORMSET.lx_FORM1.pg_assistente.page2.tx_verifica_parcial.value=1
					THISFORMSET.lx_FORM1.pg_assistente.page2.tx_somente_baixa.value=1
					
					addnewobject(THISFORMSET.lx_FORM1.pg_assistente.page3,"bt_comissao_exportar","bt_comissao_exportar")
					addnewobject(THISFORMSET.lx_FORM1.pg_assistente.page4.LX_PAGEFRAME1.page1,"bt_exportar_final","bt_exportar_final")	
					addnewobject(THISFORMSET.lx_FORM1.pg_assistente.page4.LX_PAGEFRAME1.page2,"bt_cria_pedido","bt_cria_pedido")				
					Bindevent(THISFORMSET.lx_FORM1.pg_assistente.page4.LX_PAGEFRAME1.page2, "Activate", This, "TravaBotao", 1)


					
				otherwise
				return .t.				
			endcase

	ENDPROC

	
	Procedure TravaBotao
		SELECT v_lotes
		IF RECCOUNT()=0 then
			THISFORMSET.lx_FORM1.pg_assistente.page4.LX_PAGEFRAME1.page2.bt_cria_pedido.enabled = .F.
		ELSE 
			THISFORMSET.lx_FORM1.pg_assistente.page4.LX_PAGEFRAME1.page2.bt_cria_pedido.enabled = .T.
		ENDIF 

	Endproc


ENDDEFINE	

**************************************************
*-- Class:        bt_exportar ()
*-- ParentClass:  botao ()
*-- BaseClass:    commandbutton
*-- Time Stamp:   02/12/15 05:58:05 PM
*
DEFINE CLASS bt_comissao_exportar AS botao


	Top = 48
	Left = 720
	Height = 27
	Width = 148
	Caption = "\<Exporta Tela p/Excel"
	Name = "bt_comissao_exportar"
	Visible = .t.
	Enabled = .t.

	PROCEDURE CLICK

		xResp = MESSAGEBOX("Deseja Exportar  ?",4+32)
		f_wait("Pesquisando ... AGUARDE !")  
		
		IF xResp = 6
		
		SELECT * FROM v_ctb_processa_comissao_01 INTO CURSOR xExporta readwrite
		
		ELSE
		f_wait()
		RETURN .f.
		endif
		
		f_wait()
			
		sele xExporta
	
		IF MESSAGEBOX("Exportando Relatório de Comissão, Salvar como ?",0+46)=1

			xFile = "'"+PUTFILE('','','xls')+"'"

			COPY TO &xFile XLS
			MESSAGEBOX("Exportado com Sucesso Para:"+CHR(13)+xFile,64) 
			RETURN .F.

		ENDIF

	ENDPROC

ENDDEFINE
*
*-- EndDefine: bt_exportar
**************************************************

**************************************************
*-- Class:        bt_exportar ()
*-- ParentClass:  botao ()
*-- BaseClass:    commandbutton
*-- Time Stamp:   02/12/15 05:58:05 PM
*
DEFINE CLASS bt_exportar_final AS botao


	Top = 3
	Left = 585
	Height = 27
	Width = 132
	Caption = "\<Exporta Tela p/Excel"
	Name = "bt_exportar_final"
	Visible = .t.
	Enabled = .t.

	PROCEDURE CLICK

		xResp = MESSAGEBOX("Deseja Exportar  ?",4+32)
		f_wait("Pesquisando ... AGUARDE !")  
		
		IF xResp = 6
		
		SELECT * FROM V_TOTAIS_REPRE INTO CURSOR xExporta readwrite
		
		ELSE
		f_wait()
		RETURN .f.
		endif
		
		f_wait()
			
		sele xExporta
	
		IF MESSAGEBOX("Exportando Relatório de Comissão, Salvar como ?",0+46)=1

			xFile = "'"+PUTFILE('','','xls')+"'"

			COPY TO &xFile XLS
			MESSAGEBOX("Exportado com Sucesso Para:"+CHR(13)+xFile,64) 
			RETURN .F.

		ENDIF

	ENDPROC

ENDDEFINE
*
*-- EndDefine: bt_exportar
**************************************************
**************************************************
*-- Class:        bt_exportar ()
*-- ParentClass:  botao ()
*-- BaseClass:    commandbutton
*-- Time Stamp:   02/12/15 05:58:05 PM
*
DEFINE CLASS bt_cria_pedido AS botao

	Top = 55
	Left = 645
	Height = 27
	Width = 96
	Caption = "\<Criar Pedidos"
	Name = "bt_cria_pedido"
	Visible = .t.
	Enabled = .t.

	PROCEDURE CLICK
	Local xRepre as String, xLote as string, Msg as String, xsql as String
	
	Msg = ""
	SELECT V_LOTES
    SCAN
    	xRepre = ALLTRIM(V_LOTES.REPRESENTANTE) 
    	xLote  = ALLTRIM(STR(V_LOTES.LOTE_LANCAMENTO))
    	xsql = "EXEC GS_CRIA_PEDIDO_COMISSAO '" + xRepre + "', " + xLote
		If !f_execute(xsql)
			f_wait()
		ELSE
			F_SELECT("SELECT MENSAGEM FROM GS_PEDIDO","V_MSG")
			Msg  =  Msg + V_MSG.MENSAGEM +CHR(10)+CHR(13)
		ENDIF 
	ENDSCAN
	
	messagebox(Msg , 64, "Aviso")
	
	ENDPROC

ENDDEFINE
*
*-- EndDefine: bt_exportar
**************************************************