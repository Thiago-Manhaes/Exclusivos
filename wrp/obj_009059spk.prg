* Cria��o ***********************************************************************************************************
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
*********************************************************************************************************************
* CLIENTE..:                                                                                                        *
* OBJETIVO.: 					                                                                                    *
*********************************************************************************************************************

* Altera��o *********************************************************************************************************
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
*********************************************************************************************************************
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
*********************************************************************************************************************


*********************************************************************************************************************
*- Programa Base de Cria��o de Objeto de Entrada                                                                    *
*********************************************************************************************************************
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
*********************************************************************************************************************
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execu��o para facilitar o desenvolvimento *
*********************************************************************************************************************
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
*********************************************************************************************************************

Define Class obj_entrada As Custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.

	Procedure metodo_usuario
	*- Parametros do metodo:
	*- Xmetodo= nome do metodo
	*- Xobjeto= variavel com a referencia ao objeto
	*- Xnome_obj  = nome do objeto
	Lparam xmetodo, xobjeto ,xnome_obj

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


	******************** Metodo chamado pelos Objetos na Valida��o
	*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

	******************** Metodo chamado pelos PageFrames
	*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

	*- Inicio dos procedimentos do Usuario
	*- Testando qual o metodo que esta chamando o metodo entrada

	*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

	Do Case

		Case Upper(xmetodo) == 'USR_INIT'


			xalias=Alias()

				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_faturamento_05 
				sele v_ctb_acompanhamento_00_consulta 
				xalias_consulta=alias()

  				oCur = getcursoradapter(xalias_consulta)
  				oCur.addbufferfield("FILIAL", "C(19)",.T., "Filial","W_CTB_ACOMPANHAMENTO.FILIAL")
  				oCur.addbufferfield("MATRIZ_FISCAL", "C(19)",.T., "Matriz Fiscal","W_CTB_ACOMPANHAMENTO.MATRIZ_FISCAL")
  				oCur.addbufferfield("MATRIZ_CONTABIL", "C(19)",.T., "Matriz Cont�bil","W_CTB_ACOMPANHAMENTO.MATRIZ_CONTABIL")
				oCur.addbufferfield("CNPJ_CLIFOR", "C(19)",.T., "Cnpj Clifor","W_CTB_ACOMPANHAMENTO.CNPJ_CLIFOR")				
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 	
	
			If !f_vazio(xalias)
				Sele &xalias
			Endif
			
			thisformset.l_limpa()
			o_toolbar.Botao_limpa.Click() 
			
			*** WALLACE PACHECO - 19/09/2016 - PROJETO TI N� 234035 ***
			** incluir o bot�o **
		     with thisformset.lx_form1
			.addobject("CmdImportar","bt")
			.CmdImportar.Height = 24
			.CmdImportar.Top = 22
			.CmdImportar.Left = 250

		     endwith
			*** FIM - WALLACE PACHECO - 19/09/2016 - PROJETO TI N� 234035  ***

		Otherwise
		Return .T.
	Endcase


	Endproc
Enddefine
*** WALLACE PACHECO - 19/09/2016 - PROJETO TI N� 234035 ***
define class bt as botao
	visible = .T.
	caption = "Importar Excel"
	width = 100


	PROCEDURE refresh
		this.Left = 250
		this.top = 22
	endproc


	PROCEDURE CLICK
		if this.parent.parent.p_tool_status $ 'I,A'
			f_msg(['Para importar a planilha n�o pode estar em modo de Inclus�o ou Altera��o',16,'Aten��o'])
			return .f.	
		else 
			xarquivo = GETFILE('XLS','Arquivo:','Importar')
			if len(xarquivo) > 0 and file(xarquivo)
				create cursor xcur_tmp (matriz_contabil C(25), filial C(25), nome_clifor C(50), lancamento I, fatura C(10), vencimento D,;
					valor_original N(16,2), status c(1))
					
									
				sele xcur_tmp
				VLC_MAcro = "append FROM '" + ALLTRIM(xarquivo)  +"' type xls "
				&VLC_MAcro
				
					SELECT xcur_tmp 
					*BROWSE normal
					
					SELECT v_ctb_acompanhamento_00_consulta
					*BROWSE normal
				
				SELECT v_ctb_acompanhamento_00_consulta.lancamento FROM v_ctb_acompanhamento_00_consulta ;
				JOIN xcur_tmp ON v_ctb_acompanhamento_00_consulta.lancamento=xcur_tmp.lancamento ;
				WHERE xcur_tmp.status = '1' INTO CURSOR xcur
				
				if RECCOUNT() > 0
					GO top
					
					SELECT xcur
					*BROWSE normal
					GO top
					SCAN
					
					TEXT to	xupdt noshow
					
							insert into CTB_ACOMPANHAMENTO ( DATA_ACOMPANHAMENTO, DATA_DIGITACAO, EMPRESA, ID_PARCELA, ITEM, LANCAMENTO, OBS, OCORRENCIA, STATUS, SUB_ITEM, USUARIO )
						
							select CONVERT(date, getdate()) as DATA_ACOMPANHAMENTO, getdate() as DATA_DIGITACAO, EMPRESA, ID_PARCELA, ITEM, LANCAMENTO, '' as OBS, '999' as OCORRENCIA, STATUS, SUB_ITEM, ?wUsuario as USUARIO
							from CTB_ACOMPANHAMENTO where OCORRENCIA=900 
							and LANCAMENTO=?xcur.lancamento and rtrim(ltrim(str(?xcur.lancamento)))+rtrim(ltrim(str(999))) not in ( select rtrim(ltrim(str(LANCAMENTO)))+rtrim(ltrim(str(OCORRENCIA))) from CTB_ACOMPANHAMENTO where LANCAMENTO=?xcur.lancamento and 
							OCORRENCIA=999 )

					ENDTEXT
					
						If !f_update(xupdt)
*!*							Messagebox("N�o foi poss�vel Inserir o Acompanhamento")
*!*						ELSE
*!*							Messagebox("Acompanhamento gerado com sucesso!!!")
						Endif

					Release xupdt
					
					ENDSCAN
					
					Messagebox("Grava��o dos Aconpanhamento Conclu�da!!!")

*!*						If	!f_vazio(xalias)
*!*							Sele &xalias
*!*						Endif
				endif
*
			endif 
		ENDIF
	
*						
*
*
	endproc 


enddefine 
*** FIM - WALLACE PACHECO - 19/09/2016 - PROJETO TI N� 234035 ***
