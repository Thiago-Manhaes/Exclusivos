********************************************************************************************************************* 
* MIT - Diana C. Figueiredo - 15/07/2014
* Desenvolvimento de importação de planilha de excel para incluir solicitação de verba.
* Cada planilha define uma solicitação de verba e pode ter varios itens um item por linha
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

		*=messagebox('Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
				
				case upper(xmetodo) == 'USR_INIT'  

				     ** redução do botão nativo para incluir o outro do lado **
				     with thisformset.lx_form1
					.cmdDuplicar.Caption = "Duplicar Sol. Verba"
					.cmdDuplicar.Width = 100
					.cmdDuplicar.Left = 116

					.addobject("CmdImportar","bt")
					.CmdImportar.Height = 24
					.CmdImportar.Top = 114

				     endwith
			

				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE

define class bt as botao
	visible = .T.
	caption = "Importar Excel"
	width = 100
	Left = 10
	top = 93

	PROCEDURE CLICK
		if this.parent.parent.p_tool_status $ 'I,A'
			f_msg(['Para importar a planilha não pode estar em modo de Inclusão ou Alteração',16,'Atenção'])
			return .f.	
		else 
			f_msg(['Confirma importação de arquivo formato :'])
			xarquivo = GETFILE('XLS','Arquivo:','Importar')
			if len(xarquivo) > 0 and file(xarquivo)
				create cursor xcur (Emitente C(25),	Tipo_Lancamento C(3), Desc_Solicitacao C(50), Vencimento D,;
					Terceiro C(6), Conta_Contabil c(20), Centro_Custo c(15), Rateio_Filial c(15),Beneficiario C(50),;
					Banco C(4),	Agencia C(6), Conta C(20),	Valor N(16,2), desc_item c(50), filial c(6))
				sele xcur
				append FROM &xarquivo. type xls 
				
				if RECCOUNT() > 0
					GO top

					o_toolbar.botao_inclui.click()
					thisformset.lx_form1.tv_verba_emitente.value = xcur.emitente
					thisformset.lx_form1.tx_desc_solicitacao_verba.value = xcur.desc_solicitacao
					
					scan

						o_009029.lx_FORM1.lx_pageframe1.page1.LX_TOOL_GRID_FILHA1.CMDINCLUIRFILHA.Click()

						** adiciona os itens
						thisformset.lx_form1.lx_pageframe1.page1.tv_lx_tipo_lancamento.value = xcur.tipo_lancamento
						thisformset.lx_form1.lx_pageframe1.page1.tv_lx_tipo_lancamento.l_desenhista_recalculo()
						thisformset.lx_form1.lx_pageframe1.page1.tx_desc_solicitacao_verba_item.value = xcur.desc_item
						thisformset.lx_form1.lx_pageframe1.page1.tx_vencimento.value = xcur.vencimento
						thisformset.lx_form1.lx_pageframe1.page1.tx_vencimento_real = xcur.vencimento
						thisformset.lx_form1.lx_pageframe1.page1.tv_cod_clifor.value = xcur.terceiro
						thisformset.lx_form1.lx_pageframe1.page1.tv_cod_clifor.l_desenhista_recalculo()
						thisformset.lx_form1.lx_pageframe1.page1.tv_cod_filial.value = xcur.filial
						thisformset.lx_form1.lx_pageframe1.page1.tv_cod_filial.l_desenhista_recalculo()
						thisformset.lx_form1.lx_pageframe1.page1.tv_conta_contabil.value = xcur.conta_contabil
						thisformset.lx_form1.lx_pageframe1.page1.tv_conta_contabil.l_desenhista_recalculo()
						thisformset.lx_form1.lx_pageframe1.page1.tv_rateio_centro_custo.value = xcur.centro_custo
						thisformset.lx_form1.lx_pageframe1.page1.tv_rateio_centro_custo.l_desenhista_recalculo()
						thisformset.lx_form1.lx_pageframe1.page1.tv_rateio_filial.value = xcur.rateio_filial
						thisformset.lx_form1.lx_pageframe1.page1.tv_rateio_filial.l_desenhista_recalculo()
						thisformset.lx_form1.lx_pageframe1.page1.tx_beneficiario.value = xcur.beneficiario
						thisformset.lx_form1.lx_pageframe1.page1.tx_beneficiario_banco.value = xcur.banco
						thisformset.lx_form1.lx_pageframe1.page1.tx_beneficiario_agencia.value = xcur.agencia
						thisformset.lx_form1.lx_pageframe1.page1.tx_benefiliario_conta_corrente.value = xcur_conta
						thisformset.lx_form1.lx_pageframe1.page1.tx_valor_solicitado.value = xcur.valor
						
						thisformset.refresh
						
					endscan
				endif
*
			endif 
		ENDIF
	
*						
*
*
	endproc 


enddefine 