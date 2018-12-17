* Criação ***********************************************************************************************************
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
*********************************************************************************************************************
* CLIENTE..:                                                                                                        *
* OBJETIVO.: 					                                                                                    *
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

Define Class obj_entrada As Custom
	*- Nome do metodo/função que os objetos linx vão chamar.

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


	******************** Metodo chamado pelos Objetos na Validação
	*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

	******************** Metodo chamado pelos PageFrames
	*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

	*- Inicio dos procedimentos do Usuario
	*- Testando qual o metodo que esta chamando o metodo entrada

	*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

	Do Case

		Case Upper(xmetodo) == 'USR_INIT'


			xalias=Alias()

				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_faturamento_05 
*!*					sele v_ctb_acompanhamento_00_consulta 
*!*					xalias_consulta=alias()

*!*	  				oCur = getcursoradapter(xalias_consulta)
*!*	  				oCur.addbufferfield("FILIAL", "C(19)",.T., "Filial","W_CTB_ACOMPANHAMENTO.FILIAL")
*!*	  				oCur.addbufferfield("MATRIZ_FISCAL", "C(19)",.T., "Matriz Fiscal","W_CTB_ACOMPANHAMENTO.MATRIZ_FISCAL")
*!*	  				oCur.addbufferfield("MATRIZ_CONTABIL", "C(19)",.T., "Matriz Contábil","W_CTB_ACOMPANHAMENTO.MATRIZ_CONTABIL")
*!*					oCur.addbufferfield("CNPJ_CLIFOR", "C(19)",.T., "Cnpj Clifor","W_CTB_ACOMPANHAMENTO.CNPJ_CLIFOR")				
*!*					oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 	
	
*!*				If !f_vazio(xalias)
*!*					Sele &xalias
*!*				Endif
			
			thisformset.l_limpa()
			o_toolbar.Botao_limpa.Click() 
			
			*** WALLACE PACHECO - 19/09/2016 - PROJETO TI Nº 392588 ***
			** incluir o botão **
		     with thisformset.lx_form1
			.addobject("CmdImportar","ImportLanc")
			.CmdImportar.Height = 25
			.CmdImportar.Top = 75
			.CmdImportar.Left = 380
			*** FIM - WALLACE PACHECO - 19/09/2016 - PROJETO TI Nº 392588 ***
			

		     endwith

			

		Otherwise
		Return .T.
	Endcase


	Endproc
Enddefine
*** WALLACE PACHECO - 19/09/2016 - PROJETO TI Nº 392588 ***
define class ImportLanc as botao
	visible = .T.
	caption = "Importa Lançamentos"
	width = 120


	PROCEDURE refresh
		this.Left = 380
		this.top = 75
	endproc


	PROCEDURE CLICK
		if this.parent.parent.p_tool_status $ 'I,A'
			f_msg(['Para importar a planilha não pode estar em modo de Inclusão ou Alteração',16,'Atenção'])
			return .f.	
		else 
			xarquivo = GETFILE('XLS','Arquivo:','Importar')
			if len(xarquivo) > 0 and file(xarquivo)
				create cursor xcur_tmp (data_lancamento D, lx_tipo_lancamento C(3), id_imposto I,	id_sub_item_apuracao I,	conta_contabil C(20), ;
				cod_historico C(4), historico C(250), cod_filial C(6), rateio_centro_custo C(15), rateio_filial C(15), valor N(16,2), lancamento C(10))
									
				sele xcur_tmp
				VLC_MAcro = "append FROM '" + ALLTRIM(xarquivo)  +"' type xls "
				&VLC_MAcro
				
					SELECT xcur_tmp 
					*BROWSE normal
					
				
				SELECT * FROM xcur_tmp WHERE lx_tipo_lancamento <> 'lx_' INTO CURSOR xcur readwrite

*!*				* melhoria futura* implementação das mensagerias caso arquivo não carregue com os valores esperados				
*!*				xerro=0
*!*					
*!*				SELECT xcur 
*!*				GO top
*!*						SCAN
*!*						
*!*							IF xcur.data_lancamento == '0' 
*!*								xerro= xerro+1
*!*							ENDIF
*!*							IF NVL(xcur.data_lancamento,0) = '0'
*!*								xerro= xerro+1
*!*							ENDIF
*!*							  
*!*						ENDSCAN
*!*				
*!*				IF 	xerro > 0
*!*					Messagebox("Erro no Processamento do Arquivo - verificar!!!",0,"Informação!!!")
*!*					RETURN .f.
*!*				endif
				
				if RECCOUNT() > 0
					GO top
					
					
				
					SELECT xcur
					*BROWSE normal
					GO top
					SCAN
					
						TEXT to	xupdt_lancamento noshow
					
							
							  declare @n_lancamento varchar(10)

							  EXEC LX_SEQUENCIAL 'CTB_LANCAMENTO.LANCAMENTO','1' , @n_lancamento OUTPUT, 1,''
							  select @n_lancamento as wrp_lancamento

						ENDTEXT
					
						f_select(xupdt_lancamento,"sequencial")
					
					wait wind 'Gravando o lançamento '+sequencial.wrp_lancamento+' ...' nowait

					*MESSAGEBOX(sequencial.wrp_lancamento)
					
					*RETURN .f.
					
				sele xcur && Insere lançamentos
				replace lancamento WITH sequencial.wrp_lancamento
				
				text to xInsertLancamento noshow textmerge

						INSERT INTO ctb_lancamento (EMPRESA,LANCAMENTO,LOTE_LANCAMENTO,COD_FILIAL,DATA_LANCAMENTO,DATA_DIGITACAO,LANCAMENTO_PADRAO,TIPO_MOVIMENTO) VALUES (1,?sequencial.wrp_lancamento,NULL,?xcur.cod_filial,?xcur.data_lancamento,?xcur.data_lancamento,NULL,1)

						INSERT INTO ctb_lancamento_item (ITEM,EMPRESA,LANCAMENTO,CONTA_CONTABIL,CREDITO,DEBITO,HISTORICO,CODIGO_HISTORICO,RATEIO_CENTRO_CUSTO,MOEDA,DATA_DIGITACAO,LX_TIPO_LANCAMENTO,PERMITE_ALTERACAO,DEBITO_MOEDA,CREDITO_MOEDA,CAMBIO_NA_DATA,RATEIO_FILIAL,ID_CONTRAPARTIDA) VALUES (1,1,?sequencial.wrp_lancamento,?xcur.conta_contabil,0,?xcur.valor,?xcur.historico,?xcur.cod_historico,?xcur.rateio_centro_custo,'R$',?xcur.data_lancamento,?xcur.lx_tipo_lancamento,1,?xcur.valor,0,1.000000,?xcur.cod_filial,1)

						INSERT INTO ctb_lancamento_item (ITEM,EMPRESA,LANCAMENTO,CONTA_CONTABIL,CREDITO,DEBITO,HISTORICO,CODIGO_HISTORICO,RATEIO_CENTRO_CUSTO,MOEDA,DATA_DIGITACAO,LX_TIPO_LANCAMENTO,PERMITE_ALTERACAO,DEBITO_MOEDA,CREDITO_MOEDA,CAMBIO_NA_DATA,RATEIO_FILIAL,ID_CONTRAPARTIDA) VALUES (2,1,?sequencial.wrp_lancamento,?xcur.conta_contabil,?xcur.valor,0,'CREDITO REF.:','LMC',?xcur.rateio_centro_custo,'R$',?xcur.data_lancamento,'LMC',1,0,?xcur.valor,1.000000,?xcur.cod_filial,1)

						INSERT INTO ctb_imposto_lancamento (EMPRESA,LANCAMENTO,VALOR_IMPOSTO,ITEM,ID_IMPOSTO,ID_SUB_ITEM_APURACAO) VALUES (1,?sequencial.wrp_lancamento,?xcur.valor,1,?xcur.id_imposto,?xcur.id_sub_item_apuracao)


						EXEC LX_CTB_GERA_VINCULO_COMISSAO 1,?sequencial.wrp_lancamento

						EXEC LX_CTB_MOVIMENTO_FINANCEIRO 1,?sequencial.wrp_lancamento
						
				endtext	
	
				IF !f_insert(xInsertLancamento) && Insere lançamento
					messagebox("Não foi possível inserir o lançamento!!!",16,"Atenção!!!")
					*return .f.
				ENDIF
				

					*Release xupdt
					
					ENDSCAN
					
					wait wind 'Processamento Concluído!!!' nowait
					
					Messagebox("Processamento Concluído!!!",0,"Informação!!!")
					
					SELECT xcur 
					*BROWSE normal
					
					SELECT data_lancamento, lx_tipo_lancamento, id_imposto, id_sub_item_apuracao, cod_filial, rateio_centro_custo, valor, lancamento FROM xcur INTO CURSOR  xcuror_tela_relatorio
					
					SELECT xcuror_tela_relatorio
					******************** EXPORTA PARA EXCEL Cursor Comissão***************************
					IF MESSAGEBOX("Deseja Exportar para Excel relatório do Processamento?",4+32)=6
					xnomearq ='REL_Geracao_Imposto_'+DTOs(DATETIME())+'.XLS'
					xpatharq=PUTFILE('REL_Geracao_Imposto:',xnomearq,'XLS')                                                                                
					if EMPTY(xpatharq)                                                                                                          
					                CANCEL 
					endif
					COPY TO (xpatharq)  XLS   
					ENDIF   
					***********************************************************************

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
*** FIM - WALLACE PACHECO - 19/09/2016 - PROJETO TI Nº 392588 ***
