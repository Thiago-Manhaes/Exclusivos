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
				case upper(xmetodo) == 'USR_REFRESH' 
					
					xalias=alias()

						Thisformset.lx_FORM1.lx_pageframe1.page1.ed_OBS.ReadOnly = Thisformset.p_tool_status <> 'L'
						
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	


				case upper(xmetodo) == 'USR_SAVE_BEFORE' 
					
					xalias=alias()
					
						IF V_PRECOS_LOG_00.data_ativacao = DATE()
							IF MESSAGEBOX('Atualiza��o ser� executada agora, confirma?',4,'Atualiza��o de Pre�o')=7
								RETURN .f.
							ENDIF	
						ENDIF	
						
						IF f_vazio(V_PRECOS_LOG_00.RESPONSAVEL)
							replace V_PRECOS_LOG_00.OBS WITH ;
								IIF(F_VAZIO(ALLTRIM(V_PRECOS_LOG_00.OBS)),'',ALLTRIM(V_PRECOS_LOG_00.OBS)+CHR(13))+;
								DTOC(DATE())+' - '+ALLTRIM(wusuario)
						ENDIF	
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
				
				
				case upper(xmetodo) == 'USR_SAVE_AFTER' 
					
					xalias=alias()
					
						IF V_PRECOS_LOG_00.data_ativacao = DATE()
							f_update("EXEC SP_UPDATELOGPRICES")	
						ENDIF	
					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
				
				*#01# - Inclusão do botão para importação via CSV
				case upper(xmetodo) == 'USR_INIT'
					
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
					xalias=alias()
					thisformset.lx_form1.cmd_importar.visible = .F.
					**** INCLUE BOTAO NA TELA ****
					thisformset.lx_form1.addobject("btn_importa_csv","btn_importa_csv")
				
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				 					
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE

**************************************************

**************************************************
*-- Class:        btn_atu_dados_cob_entr(c:\linx desenv\classes lucas\btn_atu_dados_cob_entr.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
Define Class btn_importa_csv As botao

	Top = 28
	Left = 595
	Height = 25
	Anchor = 0
	Width = 85
	FontBold = .T. 
	FontName = 'TAHOMA'
	Caption = "Importar \<CSV"
	ForeColor = Rgb(0,0,0)
	Name = "btn_importa_csv"
	Visible = .T.


	Procedure Click
	
		LOCAL nCount as int 

		nOldSele = Select()
		IF  thisformset.p_tool_status $ ('IA')
			IF this.Parent.ck_varia_cor.Value=0
				xImport = .t.
				
				*SELECT v_precos_log_00
				*xRecPai = RECNO()
				
				IF EMPTY(THISFORMSET.LX_FORM1.CONTAINER1.TX_TABELA.VALUE) 
					F_MSG(["Selecione uma tabela de pre�o.",64,"Aten��o!"])
					RETURN .F.
				ENDIF 

				CREATE CURSOR CUR_IMPORT(PRODUTO C(12), PRECO1 N(14,2)) 
			
				strCaminho = Getfile("csv", "Importar Arquivo", "Importar")
				lcArquivo = FILETOSTR(strCaminho)
				lnLinhas = ALINES(laRegistro,lcArquivo)
			
				IF F_VAZIO(strCaminho)
					RETURN .F.
				ENDIF
				
				SELECT CUR_IMPORT
		 
				*thisformset.lx_FORM1.lx_pageframe.page2.olecontrol1.Max = lnLinhas

				
				FOR C=1 TO lnLinhas
					*thisformset.lx_FORM1.lx_pageframe.page2.olecontrol1.Value = STR(C)
				
					*SET STEP ON	
					xPosicao    = ATC(';',laRegistro(C),1)
					xProduto   	= SUBSTR(laRegistro(C),1,xPosicao - 1) &&------- PRODUTO
					xPosicao1   = ATC(';',laRegistro(C),2)
					xPreco	 	= SUBSTR(laRegistro(C),xposicao+1, LEN(laRegistro(C))) &&------- PRE�O
					xPreco 		= STRTRAN(xPreco,",",".")
					f_Wait(' Lendo Registro -> Produto: ' + xProduto )
						APPEND BLANK
								REPLACE PRODUTO	WITH xProduto ;
								PRECO1 			WITH VAL(xPreco)
				ENDFOR
				f_Wait()
				
				SELECT CUR_IMPORT
				GO TOP
				BROWSE NORMAL
				
				IF !EOF()
					**VALIDA SE O CAMPO PREÇO É VAZIO
					SCAN 
						IF F_VAZIO(CUR_IMPORT.PRECO1) 
							F_MSG(["Erro ao ler o arquivo CSV. Verifique!",64,"Erro:002"])
							RETURN .F. 
						ENDIF 
					ENDSCAN 
					
					SELECT CUR_IMPORT
					
					**VALIDA SE O PRODUTO QUE FOI IMPORTADO EXITE NA TABELA PRODUTOS
					SCAN
						f_wait("Verificando se o produto ["+ALLTRIM(CUR_IMPORT.PRODUTO) + "] est� cadastrado...") 
						thisformset.LX_gera_cursor_importacao(1,"cur_valida")
						SELECT cur_valida
						GO TOP 
						IF EOF()
							MESSAGEBOX("PRODUTO: [" + ALLTRIM(CUR_IMPORT.PRODUTO) +"] n�o esta cadastrado. Verifique",64,"Aten��o")
							RETURN .F.
						ENDIF 
						SELECT CUR_IMPORT
					ENDSCAN 
					f_wait()
					*#01# - Marco Banaggia - 29/09/2017 - verifica se o produto existe na tabela de preco*
					**VALIDA SE O PRODUTO QUE FOI IMPORTADO EXITE NA TABELA PRODUTOS, SE NÃO EXISTIR INCLUI O PRODUTO COM VALOR ZERADO.
					nCount = 0
					SCAN
						thisformset.LX_gera_cursor_importacao(3,"cur_valida")
						f_wait("Verificando se o produto ["+ALLTRIM(CUR_IMPORT.PRODUTO) + "] est� cadastrado na tabela de pre�o...") 
						SELECT cur_valida
						GO TOP 
						IF EOF()
							TEXT TO XSQL TEXTMERGE NOSHOW 
								INSERT INTO PRODUTOS_PRECOS (CODIGO_TAB_PRECO, PRODUTO, PRECO1, PRECO_LIQUIDO1,LX_STATUS_REGISTRO)
								VALUES ('<<THISFORMSET.LX_FORM1.CONTAINER1.tv_CODIGO_TAB_PRECO.VALUE>>','<<ALLTRIM(CUR_IMPORT.PRODUTO)>>',0.00,NULL,0)
							ENDTEXT
							TRY
								F_UPDATE(XSQL)
								nCount = nCount + 1
							CATCH
								MESSAGEBOX("N�o foi poss�vel cadastrar o PRODUTO: [" + ALLTRIM(CUR_IMPORT.PRODUTO) +"] na tabela de Pre�o selecionada." + CHR(10)+CHR(13)+"Verifique",64,"Aten��o")
								RETURN .F.	
							ENDTRY
						ENDIF 
						SELECT CUR_IMPORT
					ENDSCAN 
					f_wait()
					**
					SCAN 
					
						*WAIT windows 'Processando produto ['+ALLTRIM(CUR_IMPORT.PRODUTO) + ']' NOWAIT 
						f_wait("Processando produto ["+ALLTRIM(CUR_IMPORT.PRODUTO) + "]")  
						
						thisformset.LX_gera_cursor_importacao(1,"cur_preco_Prod")	
						
						SELECT cur_preco_Prod
						GO TOP 
						
						IF !EOF()
						
							XPRECO = CUR_IMPORT.PRECO1 && 
							xProd = CUR_IMPORT.produto
							
							*PROCURA PELO PRODUTO DENTRO DO CURSOR EXISTENTE 			
							SELECT v_precos_log_00_produtos
							LOCATE FOR ALLTRIM(v_precos_log_00_produtos.produto) = ALLTRIM(xProd) 
							
							*VERIFICA SE O PRODUTO EXISTE DENTRO DO CURSOR
							IF FOUND()
								replace PRECO1 WITH  XPRECO  IN v_precos_log_00_produtos
								REPLACE DATA_DIGITACAO     With DATE() 								in v_precos_log_00_produtos 
								REPLACE	CONTRASENHA        With "CONTRASENHA" 						in v_precos_log_00_produtos 
								REPLACE PROCESSADO         With "0"									in v_precos_log_00_produtos						
							ELSE 
								
								SELECT v_precos_log_00_produtos 				
								APPEND BLANK 
									REPLACE PRODUTO            With cur_preco_Prod.PRODUTO 				in v_precos_log_00_produtos 
									REPLACE DESC_PRODUTO       With cur_preco_Prod.DESC_PRODUTO 		in v_precos_log_00_produtos 
									REPLACE GRUPO_PRODUTO      With cur_preco_Prod.GRUPO_PRODUTO 		in v_precos_log_00_produtos 
									REPLACE SUBGRUPO_PRODUTO   With cur_preco_Prod.SUBGRUPO_PRODUTO 	in v_precos_log_00_produtos 
									REPLACE GRADE              With cur_preco_Prod.GRADE 				in v_precos_log_00_produtos 
									REPLACE PONTEIRO_PRECO_TAM With cur_preco_Prod.PONTEIRO_PRECO_TAM 	in v_precos_log_00_produtos 
									REPLACE VARIA_PRECO_TAM    With cur_preco_Prod.VARIA_PRECO_TAM 		in v_precos_log_00_produtos 
									REPLACE VARIA_PRECO_COR    With cur_preco_Prod.VARIA_PRECO_COR 		in v_precos_log_00_produtos 
									REPLACE VARIA_CUSTO_COR    With cur_preco_Prod.VARIA_CUSTO_COR 		in v_precos_log_00_produtos 
									REPLACE PRECO1             With XPRECO  							in v_precos_log_00_produtos 
									REPLACE PRECO2             With cur_preco_Prod.PRECO2 				in v_precos_log_00_produtos 
									REPLACE PRECO3             With cur_preco_Prod.PRECO3 				in v_precos_log_00_produtos 
									REPLACE PRECO4             With cur_preco_Prod.PRECO4 				in v_precos_log_00_produtos 
									REPLACE PRECO1_ATUAL       With cur_preco_Prod.PRECO1 				in v_precos_log_00_produtos 
									REPLACE PRECO2_ATUAL       With cur_preco_Prod.PRECO2 				in v_precos_log_00_produtos 
									REPLACE PRECO3_ATUAL       With cur_preco_Prod.PRECO3 				in v_precos_log_00_produtos 
									REPLACE PRECO4_ATUAL       With cur_preco_Prod.PRECO4 				in v_precos_log_00_produtos 
									REPLACE DATA_DIGITACAO     With DATE() 								in v_precos_log_00_produtos 
									REPLACE	CONTRASENHA        With "CONTRASENHA" 						in v_precos_log_00_produtos 
									REPLACE PROCESSADO         With "0"									in v_precos_log_00_produtos 
																
									XPMENOR = .T.
							ENDIF

						ELSE 
							F_MSG(["Nenhum produto encontrado. Verifique se o(s) produto(s) se encontram cadastrado(s).",64,"Aten��o!"])
							RETURN .f.
						ENDIF    
						SELECT CUR_IMPORT
					ENDSCAN 
					f_wait()
				   
					WITH THISFORMSET.lx_FORM1.cmd_importar
						.ENABLED = .F.
					ENDWITH

					SELECT v_precos_log_00_produtos 
					GO TOP 
					thisformset.l_desenhista_refresh()
					
					IF RECCOUNT()>0
						MESSAGEBOX("Processo de importa��o, realizado com sucesso."+CHR(10)+CHR(13)+"Adicionado " + ALLTRIM(STR(nCount)) + " Produtos na Tabela de pre�o, pois n�o existia",64,"Aten��o!")
					ELSE
						F_MSG(["Nenhum produto encontrado. Verifique de o(s) produto(s) se encontram cadastrado(s).",64,"Aten��o!"])
						RETURN .f.
					ENDIF 
				   
					THISFORMSET.lx_FORM1.LX_PAGEFRAME1.page2.activate()

					SELECT v_precos_log_00_produtos 
					GO TOP 
					thisformset.l_desenhista_refresh()
					
					*SELECT v_precos_log_00
					*GO xRecPai
					this.Enabled= .F. 
				ELSE 
					F_MSG(["Nenhum registro encontrado no arquivo CSV. Verifique!",64, "Aten��o!"])
					RETURN .F. 
				ENDIF 
			ELSE &&---------------VARIAÇÃO DE COR---------------------------------
				xImport = .t.
				
				SELECT v_precos_log_00
				xRecPai = RECNO()
				
				IF EMPTY(THISFORMSET.LX_FORM1.CONTAINER1.TX_TABELA.VALUE) 
					F_MSG(["Selecione uma tabela de pre�o.",64,"Aten��o!"])
					RETURN .F.
				ENDIF 

				CREATE CURSOR CUR_IMPORT_COR(produto c(50),COR_PRODUTO C(10), preco1 n(10,2))
				XPMENOR = .F. 
				
				strCaminho = Getfile("csv", "Importar Arquivo", "Importar")
				lcArquivo = FILETOSTR(strCaminho)
				lnLinhas = ALINES(laRegistro,lcArquivo)
			
				IF F_VAZIO(strCaminho)
					RETURN .F.
				ENDIF
				
				SELECT CUR_IMPORT_COR
		 
				FOR C=1 TO lnLinhas
				
					xPosicao    = ATC(';',laRegistro(C),1)
					xProduto   	= SUBSTR(laRegistro(C),1,xPosicao - 1) &&------- PRODUTO
					xPosicao1   = ATC(';',laRegistro(C),2)
					xcor	 	= SUBSTR(laRegistro(C),xposicao+1, xPosicao1 - xposicao -1) &&------- COR_PRODUTO
					xPosicao2   = ATC(';',laRegistro(C),3)
					xPreco      = SUBSTR(laRegistro(C),xPosicao1+1, LEN(laRegistro(C))) &&------- PRECO1
					xPreco 		= STRTRAN(xPreco,",",".")
					f_Wait(' Lendo Registro -> Produto: ' + xProduto )
						APPEND BLANK
								REPLACE PRODUTO	WITH xProduto ;
								COR_PRODUTO		WITH xCor ;
								PRECO1 			WITH VAL(xPreco)
				ENDFOR
				f_Wait()
				
				SELECT CUR_IMPORT_COR
				GO TOP

				*SET STEP ON 
				IF !EOF()
					**VALIDA SE O CAMPO PREÇO É VAZIO
					SELECT CUR_IMPORT_COR
					GO TOP
					SCAN 
						F_SELECT("SELECT PRODUTO FROM PRODUTO_CORES A WHERE  a.PRODUTO = ?CUR_IMPORT_COR.PRODUTO AND A.COR_PRODUTO = ?CUR_IMPORT_COR.COR_PRODUTO ","CUR_VALIDA_COR")
						SELECT CUR_VALIDA_COR
						GO TOP 
						
						IF EOF()
							MESSAGEBOX("O Produto: [" + ALLTRIM(CUR_IMPORT_COR.PRODUTO) +"] n�o esta cadastrado ou sem varia��o de pre�o por cor. Verifique!",64,"Aten��o!")
							RETURN .F. 
						ENDIF 
						
						IF f_vazio(CUR_IMPORT_COR.COR_PRODUTO)
							MESSAGEBOX("O Produto: ["+ALLTRIM(CUR_IMPORT_COR.PRODUTO)+"] n�o tem cor informada. Verifique!!",64,"Aten��o!")
							RETURN .f.
						ENDIF 
						
						IF f_vazio(CUR_IMPORT_COR.preco1)
							MESSAGEBOX("O Produto: ["+ ALLTRIM(CUR_IMPORT_COR.PRODUTO) +"] n�o tem pre�o informado. Verifique!",64,"Aten��o!")
							RETURN .f.
						ENDIF 					
						SELECT CUR_IMPORT_COR
					ENDSCAN 

					SELECT CUR_IMPORT_COR
					GO TOP 
					
					SCAN 
					
						WAIT windows 'Processando produto ['+ALLTRIM(CUR_IMPORT_COR.PRODUTO) + ']' NOWAIT 
						
						thisformset.LX_gera_cursor_importacao(2,"CUR_COR_PRECO")	

						SELECT CUR_COR_PRECO
						GO TOP 
						
						IF !EOF()
						
							XPRECO = CUR_IMPORT_COR.PRECO1 && 
							xProd = CUR_IMPORT_COR.produto
							X_COR = CUR_IMPORT_COR.produto
							
							*PROCURA PELO PRODUTO DENTRO DO CURSOR EXISTENTE 			
							SELECT v_precos_log_00_cor
							LOCATE FOR ALLTRIM(v_precos_log_00_cor.produto) = ALLTRIM(xProd) AND  v_precos_log_00_cor.cor_produto = X_COR  
							
							
							*VERIFICA SE O PRODUTO EXISTE DENTRO DO CURSOR
							IF FOUND()
								replace PRECO1 				WITH  XPRECO  							IN v_precos_log_00_cor
								REPLACE	CONTRASENHA        	With "CONTRASENHA" 						in v_precos_log_00_cor
								**REPLACE PROCESSADO         	With "0"								in v_precos_log_00_cor						
							ELSE 
								SELECT v_precos_log_00_cor				
								APPEND BLANK 
								
								REPLACE PRODUTO            	With CUR_COR_PRECO.PRODUTO 				in v_precos_log_00_cor
								REPLACE DESC_PRODUTO       	With CUR_COR_PRECO.DESC_PRODUTO 		in v_precos_log_00_cor
								REPLACE GRUPO_PRODUTO      	With CUR_COR_PRECO.GRUPO_PRODUTO 		in v_precos_log_00_cor
								REPLACE SUBGRUPO_PRODUTO   	With CUR_COR_PRECO.SUBGRUPO_PRODUTO 	in v_precos_log_00_cor
								REPLACE GRADE              	With CUR_COR_PRECO.GRADE 				in v_precos_log_00_cor
								REPLACE COR_PRODUTO			With CUR_COR_PRECO.COR_PRODUTO			in v_precos_log_00_cor
								REPLACE DESC_COR_PRODUTO	With CUR_COR_PRECO.DESC_COR_PRODUTO		in v_precos_log_00_cor
								
								REPLACE PROMOCAO_DESCONTO	With CUR_COR_PRECO.PROMOCAO_DESCONTO	in v_precos_log_00_cor
								**REPLACE PROCESSADO	    	With CUR_COR_PRECO.PROCESSADO			in v_precos_log_00_cor
								REPLACE VARIA_CUSTO_COR    	With CUR_COR_PRECO.VARIA_CUSTO_COR 		in v_precos_log_00_cor
								REPLACE PRECO1             	With XPRECO  							in v_precos_log_00_cor
								REPLACE PRECO2             	With CUR_COR_PRECO.PRECO2 				in v_precos_log_00_cor
								REPLACE PRECO3             	With CUR_COR_PRECO.PRECO3 				in v_precos_log_00_cor
								REPLACE PRECO4             	With CUR_COR_PRECO.PRECO4 				in v_precos_log_00_cor
								REPLACE PRECO1_ATUAL       	With CUR_COR_PRECO.PRECO1 				in v_precos_log_00_cor
								REPLACE PRECO2_ATUAL       	With CUR_COR_PRECO.PRECO2 				in v_precos_log_00_cor
								REPLACE PRECO3_ATUAL       	With CUR_COR_PRECO.PRECO3 				in v_precos_log_00_cor
								REPLACE PRECO4_ATUAL       	With CUR_COR_PRECO.PRECO4 				in v_precos_log_00_cor
								REPLACE DATA_DIGITACAO     	With DATE() 							in v_precos_log_00_cor
								REPLACE	CONTRASENHA        With "CONTRASENHA" 						in v_precos_log_00_cor
								**REPLACE PROCESSADO         With "0"									in v_precos_log_00_cor

								XPMENOR = .T.
							ENDIF
						ELSE 
							F_MSG(["Nenhum produto encontrado. Verifique se o(s) produto(s) se encontram cadastrado(s).",64,"Aten��o!"])
							RETURN .f.
						ENDIF    
						SELECT CUR_IMPORT_COR
					ENDSCAN 
				
				   
					SELECT CUR_COR_PRECO
					GO TOP 
					thisformset.l_desenhista_refresh()
					
					IF RECCOUNT()>0
						WITH THISFORMSET.lx_FORM1.CK_varia_cor 
							.ENABLED = .F.
						ENDWITH			
						WITH THISFORMSET.lx_FORM1.cmd_importar
							.ENABLED = .F.
						ENDWITH
						F_MSG(["Processo de importa��o, realizado com sucesso.",64,"Aten��o!"])
						THISFORMSET.lx_FORM1.LX_PAGEFRAME1.page2.activate()
						THISFORMSET.Refresh()
					ELSE
						F_MSG(["Nenhum produto encontrado. Verifique de o(s) produto(s) se encontram cadastrado(s).",64,"Aten��o!"])
						RETURN .f.
					ENDIF 
				   
					SELECT v_precos_log_00_cor
					GO TOP 
					thisformset.l_desenhista_refresh()
					*SELECT v_precos_log_00
					*GO xRecPai
					this.Enabled= .F. 
				ELSE 
					F_MSG(["Nenhum registro encontrado no arquivo CVS. Verifique!",64, "Aten��o!"])
					RETURN .F. 
				ENDIF 
			ENDIF 	
		ENDIF  
		Select(nOldSele)
		thisformset.lx_form1.btn_importa_csv.enabled = .T.
		Return				
Enddefine
*
*-- EndDefine: btn_gs_consumo_terceiro
**************************************************
