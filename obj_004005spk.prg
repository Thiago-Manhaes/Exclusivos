* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).: SIDNEI STELLET                                                                                                 *
* DATA...........: 14/10/2015                                                                                                 *
* HOR�RIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: OR�AMENTO E DESEMPENHO                                                                                                       *
* OBJETIVO.: VALIDA��O DO TIPO DE COMPRA A PARTIR DA COMBINA��O DA CONTA_CONTABIL E CENTRO DE CUSTO DO ITEM                                                                                                       *
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

define class obj_entrada as custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.

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


		******************** Metodo chamado pelos Objetos na Valida��o
		*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada
		
		* =messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		
		do CASE 
		
			
			
			
			CASE UPPER(xmetodo)=='USR_INIT' 
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
								
				** In�cio Verifica se parametro para Valida��o de consum�veis est� ligado
				public xValida_Aprov , xProcessou
				xValida_Aprov=.f.							
				xProcessou=.f.

				text to xParam noshow textmerge

					SELECT VALOR_ATUAL FROM PARAMETROS WHERE PARAMETRO='ANM_VALIDA_APROV_CONS'

				endtext
				
				f_select(xParam , 'curParam')
				SELE curParam		
				
				if	curParam.valor_atual='.T.'
					xValida_Aprov=.T.
				else	
					xValida_Aprov=.f.
				endif		
				** Fim Verifica se parametro para Valida��o de consum�veis est� ligado
	
			   

			CASE UPPER(xmetodo)=='USR_INCLUDE_AFTER' 
			
		
			**** IN�CIO #12 - BLOQUEIO DO CAMPO CONDI��O PGTO - SILVIO LUIZ - 22/11/2016 ****
				if thisformset.p_tool_status $ 'IA'	
						If thisformset.pp_anm_blq_cond_pgto_004005 = .f.
								thisformset.lx_form1.lx_pageframe1.page1.TV_CONDICAO_PGTO.Enabled= .F.
						ENDIF
				ENDIF 
			**** FIM #12	
		
			
			*** Lucas Miranda - Inclus�o do par�metro para trazer uma natureza por padr�o 
			xNaturezaPadrao = Thisformset.pp_ANM_NAT_COMPRA_PADRAO
			Thisformset.lx_FORM1.lx_pageframe1.page1.LX_Textbox_valida1.Value = xNaturezaPadrao   
			
			f_select("SELECT CTB_TIPO_OPERACAO FROM NATUREZAS_ENTRADAS WHERE NATUREZA= ?xNaturezaPadrao","CurTipoOpe",ALIAS())
			Thisformset.lx_FORM1.lx_pageframe1.page1.tx_ctb_Tipo_Operacao.Value = CurTipoOpe.CTB_TIPO_OPERACAO 
			USE IN CurTipoOpe
			RELEASE xNaturezaPadrao 
			*** Lucas Miranda - Inclus�o do par�metro para trazer uma natureza por padr�o 
			
			
				if type("xProcessou")<>"U" &&*** garante valor como falso antes de iniciar a tela
					xProcessou=.f.
				endif	

			
			CASE UPPER(xmetodo)=='USR_CLEAN_AFTER' 
			
				if type("xProcessou")<>"U" &&*** garante valor como falso antes de iniciar a tela
					xProcessou=.f.
				ENDIF
				
				if type("o_004005.lx_FORM1.lx_pageframe1.page1.tv_TIPO_COMPRA")<>"U"	
					o_004005.lx_FORM1.lx_pageframe1.page1.tv_TIPO_COMPRA.Enabled=.T. &&*** habilita campo tipo de compra para pesquisa			
				endif	
			
			CASE UPPER(xmetodo)=='USR_REFRESH' AND (thisformset.p_tool_status = 'I' OR thisformset.p_tool_status = 'L' OR thisformset.p_tool_status = 'A' OR thisformset.p_tool_status = 'P')
				
				Thisformset.LX_FORM1.LX_PAgeframe1.PAGE1.TX_REQUERIDO_POR.TOP=105
			
			  
			CASE UPPER(xmetodo)=='USR_ALTER_BEFORE' 
			
				if type("xProcessou")<>"U" &&*** garante valor como verdadeiro antes de alterar
					xProcessou=.t.
				endif	
			
			
			CASE UPPER(xmetodo)=='USR_VALID' 
			
			
			* IN�CIO - #11 - SILVIO LUIZ - 23/11/2016 - CORRE��O DE VALIDA��O DA CONDI��O DE PAGAMENTO DO FORNECEDOR	
						  IF UPPER(xnome_obj)=='TV_FORNECEDOR'
						  	TEXT TO XSEL NOSHOW TEXTMERGE
								SELECT DISTINCT COND_ENT_PGTOS.CONDICAO_PGTO, COND_ENT_PGTOS.DESC_COND_PGTO, COND_ENT_PGTOS.TIPO_CONDICAO
								FROM COND_ENT_PGTOS
								LEFT join FORNECEDORES
								on FORNECEDORES.CONDICAO_PGTO=COND_ENT_PGTOS.CONDICAO_PGTO	
								where fornecedores.FORNECEDOR='<<V_COMPRAS_01.FORNECEDOR>>'
						  	ENDTEXT

							F_SELECT(XSEL, 'CUR_PGTO',ALIAS())
							
							SELECT CUR_PGTO
							SELECT V_COMPRAS_01
								REPLACE CONDICAO_PGTO WITH CUR_PGTO.CONDICAO_PGTO
								REPLACE DESC_COND_PGTO WITH CUR_PGTO.DESC_COND_PGTO
								REPLACE TIPO_CONDICAO WITH CUR_PGTO.TIPO_CONDICAO
							
						  ENDIF
						 * IN�CIO - #11

				
				IF 	xValida_Aprov	&&*** Verifica se o parametro est� ligado		
						
					xalias=alias()
					
					o_004005.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.col_tv_CONTA_CONTABIL.Enabled=.F. &&*** Desabilita o campo conta_contabil
					o_004005.lx_FORM1.lx_pageframe1.page1.tv_TIPO_COMPRA.Enabled =.F. &&*** Desabilita o campo tipo de compra						
					
						If upper(xnome_obj) = 'TV_RATEIO_CENTRO_CUSTO' &&*** start ap�s sele��o do centro de custo
							
							text to	xSelTipo noshow textmerge	&&*** seleciona na tabela  anm_rc_compras_aprov o tipo de compra conforme conta_contabil e centro de custo do item
								select tipo_compra from anm_rc_compras_aprov
								where conta_contabil='<<v_compras_01_consumivel.conta_contabil>>'
								and centro_custo='<<v_compras_01_consumivel.rateio_centro_custo>>'
							endtex
							
							f_select(xSelTipo ,'curTipo')
							
							if	xProcessou=.f. &&*** garante que � o primeiro item e ainda n�o h� valida��o
								
								sele v_compras_01 &&*** seleciona o tipo de compra conforme relacionamento do item
								repla tipo_compra with curTipo.tipo_compra
								
								xProcessou=.t.  &&*** marca como j� inserido algum item anterior , portanto deve conferir se n�o h� conflito com mais um tipo
								
							else	
							
								if curTipo.tipo_compra <> v_compras_01.tipo_compra &&*** bloqueia a duplicidade de itens 
									messagebox("N�o � poss�vel inserir este item !!!"+chr(10)+chr(13)+"J� existe outra sequencia de aprova��o selecionada.","Aten��o!",48)		
									o_004005.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.col_tv_RATEIO_CENTRO_CUSTO.tv_RATEIO_CENTRO_CUSTO.Value=''
									o_004005.lx_FORM1.lx_pageframe1.page2.LX_GRID_FILHA1.col_tv_RATEIO_CENTRO_CUSTO.tv_RATEIO_CENTRO_CUSTO.Refresh()
									return .f.
								endif	
									
							endif	
			
						Endif
						
					if !f_vazio(xalias)	
						sele &xalias
					endif

				ENDIF 

			


			otherwise
				return .t.				
		endcase
	ENDPROC 
ENDDEFINE


