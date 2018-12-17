* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Consulta Entradas por colecao propriedade                                                                                                     *
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
		
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		
		*!* Chama a fun��o dispon�vel na classe criada para tratar xml *!* #XML_2015
 		TRY 							
			If TYPE("Thisformset.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml
				If ! o_anm.l_Obj_entrada_xml('o_005108',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
					RETURN .f.
				Endif
			Endif
		CATCH					
		ENDTRY
		*!* Fim - Instancia um objeto da classe "Obj_Entrada_XML" #XML_2015
		
		do case


			
				case UPPER(xmetodo) == 'USR_INIT' 
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 

					*!* Declara Fun��o Obj_Entrada_XML ao Iniciar Tela *!* #XML_2015
					If TYPE("Thisformset.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml
						PUBLIC o_anm as Object
						o_anm = NEWOBJECT("Obj_Entrada_XML","linx\exclusivo\obj_entrada_xml.prg")
					Endif
					*!* Fim - Declara Fun��o Obj_Entrada_XML ao Iniciar Tela *!* #XML_2015
					
					PUBLIC xmotivo_exclusao
				
					THISFORMSET.lx_form1.tv_operacao.p_valida_where=" AND Naturezas_entradas.Inativo = 0 AND naturezas_entradas.CTB_TIPO_OPERACAO in ( 200,201, 202, 205, 208, 209, 215, 240, 241, 245, 246 , 250, 260, 299)" 
										
	
				case UPPER(xmetodo) == 'USR_SAVE_BEFORE' 
						
					xalias=alias()
						
						*!* Chama a fun��o dispon�vel na classe criada para tratar xml *!* #XML_2015
						If TYPE("o_005108.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml
							If ! o_anm.l_anm_valida_xml('o_005108',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
								Return .f.
							Endif
						Endif	
						***** Saida Autom�tica dos materiais comprados para Pilotagem **** #XML_2015
						
				&& Alterado por Tinoco para contemplar a conta contabil correta conforme a operacao
				
					IF UPPER(thisformset.p_tool_status) $ 'IA'
					
						SELECT v_entradas_00_retorno_beneficiamento_os 
							SCAN 
								sele V_ENTRADAS_00
									IF V_ENTRADAS_00.CTB_TIPO_OPERACAO >= 200 AND V_ENTRADAS_00.CTB_TIPO_OPERACAO <= 202 
								
								
									F_SELECT("SELECT CONTA_CONTABIL_COMPRA FROM PRODUTOS WHERE PRODUTO = ?v_entradas_00_retorno_beneficiamento.produto","XCUR_CONTA_COMPRA",ALIAS()) 
									REPLACE CONTA_CONTABIL WITH XCUR_CONTA_COMPRA.CONTA_CONTABIL_COMPRA
							
									ENDIF 
							
							ENDSCAN 
						
					ENDIF 
				
		*** LUCAS MIRANDA ****
					IF THISFORMSET.P_TOOL_status == 'I'				

						parametro_chave=THISFORMSET.pp_valida_chave_nfe_entrada
						chave_nfe=THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page_NFE.txt_chave_nfe.Value
						serie_nf_desc=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value
						nota_propria=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.ck_nf_propria.Value
						
						IF parametro_chave = .T. AND f_vazio(chave_nfe) AND serie_nf_desc = 'NF-E' and nota_propria = .F.
							MESSAGEBOX("VOC� N�O INFORMOU A CHAVE !!!" + CHR(13) + "FAVOR INSERIR A CHAVE !",64)
							RETURN .F.
						ENDIF
						
					ENDIF							
						
						**** Controle para exclusao de Nota Fiscal
						IF THISFORMSET.P_TOOL_status == 'E'					
							MESSAGEBOX("Aten��o, Todos os Seus Dados Ser�o Armazenados ",48,"Aten��o_9!")		
							xmotivo_exclusao = inputbox('Descreva o motivo da Exclus�o','Motivo Exclus�o (Campo Obrigat�rio)','')
								 	
							text to	xinsert1 noshow textmerge	
								INSERT INTO ANM_LOG_EXCLUSAO_NF
								(NF_ENTRADA,SERIE_NF,FILIAL,NOME_CLIFOR,DATA_DIGITACAO,EMISSAO,RECEBIMENTO,VALOR,DATA_EXCLUSAO,
								MOTIVO_EXCLUSAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA)
							
								SELECT '<<V_ENTRADAS_00.NF_ENTRADA>>','<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>','<<V_ENTRADAS_00.FILIAL>>',
								'<<V_ENTRADAS_00.NOME_CLIFOR>>','<<V_ENTRADAS_00.DATA_DIGITACAO>>','<<V_ENTRADAS_00.EMISSAO>>',
								'<<V_ENTRADAS_00.RECEBIMENTO>>','<<V_ENTRADAS_00.VALOR_TOTAL>>',(SELECT GETDATE()),'<<XMOTIVO_EXCLUSAO>>',
								'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>'
							endtext			
												
							if !f_insert(xinsert1) 
								messagebox("N�o foi poss�vel Excluir a Nota Fiscal ",48,"Aten��o_9!")
								retu .f.
							endif
						ENDIF	
						**** Fim ***** if allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='5' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='A5'
						
													
							sele v_entradas_00	
							replace Agrupamento_itens with 3  
							
							thisformset.LX_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page2.Cmb_agrupamento.ValUE=3
							thisformset.LX_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page2.Cmb_agrupamento.Valid()
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	 	
					
					
				Case Upper(xmetodo) == 'USR_INCLUDE_AFTER'
	

 				**** IN�CIO #12 - BLOQUEIO DO CAMPO CONDI��O PGTO - SILVIO LUIZ - 22/11/2016 ****
					if thisformset.p_tool_status $ 'IA'	
						If thisformset.pp_anm_blq_cond_pgto_005108 = .f.
								thisformset.lx_forM1.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.Enabled= .F.
						ENDIF
					ENDIF 
				**** FIM #12
								
				
				
					
				case UPPER(xmetodo) == 'USR_VALID'

					xalias=alias()
					
							sele v_entradas_00	
			         		thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tx_CliFor1.VALUE	
							f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_entradas_00.rateio_filial","curRATEIO",alias())
							thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.tx_desc_filial_rateio.Value = curRATEIO.desc_rateio_filial
						
						**** Julio - Veficica junto ao par�metro ANM_NATUREZAS_IMPORTACAO as naturezas Permitidas para entrada de importa��o. ****
						If upper(xnome_obj)=='CK_IMPORTACAO'
							
							sele v_entradas_00	
							xSelImp = "SELECT COUNT(*) AS EntImpOK  FROM PARAMETROS WHERE PARAMETRO = 'ANM_NATUREZAS_IMPORTACAO' AND ( VALOR_ATUAL LIKE '%"+ALLT(v_Entradas_00.NATUREZA)+"%' OR VALOR_ATUAL = 'LIBERADO' )"
							f_select(xSelImp,"xteste")	
							
							If xteste.EntImpOK = 0
							    Thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.Ck_importacao.value=0
							    MESSAGEBOX('N�o � permitido Entrada de Importa��o com essa natureza'+CHR(13)+'Favor Procurar o Dpto. Fiscal.',64)
							Endif
								
						Endif					
							
						*** Bloqueia alterar a natureza ap�s a verifica��o caso o checkbox importa��o esteja marcado na tela em modo de inclus�o ou altera�ao **	
							If v_entradas_00.importacao=.T.
								if Thisformset.p_tool_status $ 'I,A'
									Thisformset.lx_FORM1.tv_operacao.ReadOnly= .T.
								endif
							Else 
								Thisformset.lx_FORM1.tv_operacao.ReadOnly= .F.
							Endif	
						*** Fim do exclusivo de valida��o da natureza na entrada de importa��o ******
						*****************************************************************************
					
						***** Coloca Falso para gerar itens fisicos no retorno quando for compra de servi�os ***				
						IF upper(xnome_obj) == 'TV_OPERACAO'
						
							IF allt(upper(THISFORMSET.lx_form1.tv_operacao.value)) == '201.01'
								THISFORMSET.lx_foRM1.lx_pageframe1.page5.ck_gera_itens_simbolicos.Visible = .F.
							ELSE
								THISFORMSET.lx_foRM1.lx_pageframe1.page5.ck_gera_itens_simbolicos.Visible = .T.	
							ENDIF
						
						ENDIF  
						****** FIM ******************************************************************************  	
					
						IF 	upper(xnome_obj) =='CMD_TODAS'
												
							sele v_entradas_00	
							replace Agrupamento_itens with 3  
							
							thisformset.LX_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page2.Cmb_agrupamento.ValUE=3
							thisformset.LX_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page2.Cmb_agrupamento.Valid()
							
						ENDIF
					
						IF THISFORMSET.p_tool_status = 'I' AND (upper(xnome_obj)=='TV_FILIAL_ENTRADA' OR upper(xnome_obj)=='TV_NOME_CLIFOR')
						
								 * Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo filial					
								THISFORMSET.lx_FORM1.Tx_clifor1.refresh()
								IF thisformset.lx_FORM1.Tx_clifor1.value = '000991'
								   thisformset.lx_FORM1.Tx_clifor1.value = '000999'
								   thisformset.lx_FORM1.TV_FILIAL_ENTRADA.VALUE = 'ESTOQUE CENTRAL'
								ENDIF		 	
								
								* Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo cliente
								THISFORMSET.lx_FORM1.Tx_clifor.refresh()
								IF thisformset.lx_FORM1.Tx_clifor.value = '000991'
								   thisformset.lx_FORM1.Tx_clifor.value = '000999'
								   thisformset.lx_FORM1.Tx_nome_clifor.VALUE = 'ESTOQUE CENTRAL'
								ENDIF
						
						ENDIF
					
						** Passa numero da NF para inteiro ** #XML_2015
						IF Thisformset.p_tool_status = 'I' AND upper(xnome_obj)=='TX_NF_ENTRADA'
						
							Thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE = INT(VAL(Thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE))

						ENDIF
						** FIM - Passa numero da NF para inteiro ** #XML_2015

			****lucas colocar especie serie padrao ao inserir a chave***
				If upper(xnome_obj)=='TXT_CHAVE_NFE' 
					parametro_chave=THISFORMSET.pp_valida_chave_nfe_entrada
					serie_nf_desc=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value
					
					IF parametro_chave = .T. and serie_nf_desc = 'NF-E' 
						  SELE V_ENTRADAS_00
	 						 xEspecie_Serie = 5
							
						   REPLACE ESPECIE_SERIE 		 WITH xEspecie_Serie
					ENDIF
				
				ENDIF				        
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	 				
			


	
				case UPPER(xmetodo) == 'USR_LX_ENVIA_OS_APOS'

					xalias=alias()
												
						sele v_entradas_00	
						replace Agrupamento_itens with 3  
						
						thisformset.LX_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page2.Cmb_agrupamento.ValUE=3
						thisformset.LX_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page2.Cmb_agrupamento.Valid()
						
						
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	 				
		
	
			case UPPER(xmetodo) == 'USR_REFRESH' 
							
				xalias=alias()
				
				** Volta Valor do campo para default **
				Thisformset.lx_FORM1.tv_operacao.ReadOnly= .F.

				if	!f_vazio(xalias)	
					sele &xalias 
				endif

			case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
							
				xalias=alias()
				
					sele v_entradas_00_retorno_beneficiamento_os  
					go top	
					
					f_select("select filial from producao_ordem where ordem_producao=?v_entradas_00_retorno_beneficiamento_os.ordem_producao","curOP",alias())	

					f_update("update entradas set filial_estoque =?curOP.filial where nf_entrada=?v_entradas_00.nf_entrada and serie_nf_entrada=?v_entradas_00.serie_nf_entrada and nome_clifor=?v_entradas_00.nome_clifor")
					
					*****************************
			
				If (ALLTRIM(v_entradas_00.natureza) $ ALLTRIM(thisformset.pp_anm_valida_natureza_op)) or thisformset.pp_anm_valida_natureza_op = 'TODOS'
					Sele v_entradas_00_retorno_beneficiamento_os
					Go Top
					Scan	
						F_SELECT("select a.filial, matriz_fiscal from producao_ordem a join filiais b on a.filial = b.filial where ordem_producao=?v_entradas_00_retorno_beneficiamento_os.ordem_producao","CurMFOP")
						f_select("select colecao, rede_lojas from produtos where produto = ?v_entradas_00_retorno_beneficiamento_os.produto","xColecaoProd")						
												
						If ALLTRIM(v_entradas_00.filial) <> ALLTRIM(CurMFOP.filial) 
							MESSAGEBOX("Filial da OP diferente da Filial da Nota !!!",0+16)
							Return .F.
						Endif							
												
							f_select("select valor_propriedade as TIPO from prop_produtos where produto = ?v_entradas_00_retorno_beneficiamento_os.produto and propriedade = '00036'","xTipo")
							f_select("select VALOR_PROPRIEDADE as FABRICA from prop_filiais where filial = ?v_entradas_00.Filial AND PROPRIEDADE = '00248'","xProp")
							If ALLTRIM(xTipo.tipo) = 'PRODU�AO' AND ALLTRIM(xProp.fabrica) = 'NAO'
								MESSAGEBOX("Tipo do Produto n�o corresponde a filial da Nota",0+16)
								Return .F.		
							Endif
													
							If ALLTRIM(xTipo.tipo) = 'PRODUTO ACABADO' AND ALLTRIM(xProp.fabrica) = 'SIM'
								MESSAGEBOX("Tipo do Produto n�o corresponde a filial da Nota",0+16)
								Return .F.		
							Endif
													
						Endscan	
						Sele v_entradas_00_retorno_beneficiamento_os
							 
						RELEASE xSelFilial 
						RELEASE CurMFOP
						RELEASE xFabrica
						RELEASE xTipo
						RELEASE xProp
						RELEASE xRevisao
				Endif
			
				if	!f_vazio(xalias)	
					sele &xalias 
				endif	
			
			
			
			case UPPER(xmetodo) == 'USR_WHEN' 
							
				xalias=alias()
				
					If upper(xnome_obj)=='CMD_FECHA_SELECAO'
						If (ALLTRIM(v_entradas_00.natureza) $ ALLTRIM(thisformset.pp_anm_valida_natureza_op)) or thisformset.pp_anm_valida_natureza_op = 'TODOS'
							Sele V_PRODUCAO_OS_02_ANTERIOR
							Go Top
							Scan	
								F_SELECT("select a.filial, matriz_fiscal from producao_ordem a join filiais b on a.filial = b.filial where ordem_producao=?V_PRODUCAO_OS_02_ANTERIOR.ORDEM_PRODUCAO","CurMFOP")
								f_select("select colecao, rede_lojas from produtos where produto = ?V_PRODUCAO_OS_02_ANTERIOR.produto","xColecaoProd")														

														
								If ALLTRIM(v_entradas_00.filial) <> ALLTRIM(CurMFOP.filial)
									MESSAGEBOX("Filial da OP diferente da Filial da Nota !!!",0+16)
									Return .F.
								Else
									f_select("select valor_propriedade from prop_filiais where PROPRIEDADE = '00248' and filial = ?v_entradas_00.Filial","xFabrica")
									If ALLTRIM(xFabrica.valor_propriedade) = 'SIM'
										Replace V_PRODUCAO_OS_02_ANTERIOR.Filial With v_entradas_00.Filial
									Else	
										f_select("select valor_propriedade from prop_filiais where propriedade = '00206' and filial = ?v_entradas_00.Filial","xRevisao")
										if RECCOUNT()=0	or ALLTRIM(xColecaoProd.colecao) = 'JOIAS'
											Replace V_PRODUCAO_OS_02_ANTERIOR.Filial With v_entradas_00.Filial
										Else
											Replace V_PRODUCAO_OS_02_ANTERIOR.Filial With xRevisao.valor_propriedade
										Endif	
									Endif	
								Endif							
														
									f_select("select valor_propriedade as TIPO from prop_produtos where produto = ?V_PRODUCAO_OS_02_ANTERIOR.produto and propriedade = '00036'","xTipo")
									f_select("select VALOR_PROPRIEDADE as FABRICA from prop_filiais where filial = ?v_entradas_00.Filial AND PROPRIEDADE = '00248'","xProp")
									If ALLTRIM(xTipo.tipo) = 'PRODU�AO' AND ALLTRIM(xProp.fabrica) = 'NAO'
										MESSAGEBOX("Tipo do Produto n�o corresponde a filial da Nota",0+16)
										Return .F.		
									Endif
															
									If ALLTRIM(xTipo.tipo) = 'PRODUTO ACABADO' AND ALLTRIM(xProp.fabrica) = 'SIM'
										MESSAGEBOX("Tipo do Produto n�o corresponde a filial da Nota",0+16)
										Return .F.		
									Endif
															
								Endscan	
								Sele V_PRODUCAO_OS_02_ANTERIOR
									 
								RELEASE xSelFilial 
								RELEASE CurMFOP
								RELEASE xFabrica
								RELEASE xTipo
								RELEASE xProp
								RELEASE xRevisao
						  ENDIF	
					Endif
				
					** Bloquear condi��o pagamento caso o fornecedor esteja marcado como nao valida pagamento
						If upper(xnome_obj)=='TV_CONDICAO_PGTO'
						 
							TEXT TO xMetodoPagamento NOSHOW textmerge
								select a.*, isnull(b.ANM_N_VALIDA_PAGAMENTO,0) ANM_N_VALIDA_PAGAMENTO 
								from fornecedores a 
								left join CTB_LX_METODO_PAGAMENTO b 
								on a.LX_METODO_PAGAMENTO = b.LX_METODO_PAGAMENTO 
								where fornecedor = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
							Endtext
							F_select(xMetodoPagamento,"CurMetodoPagamento")

							Sele CurMetodoPagamento

							If !F_Vazio(CurMetodoPagamento.anm_n_valida_pagamento) AND CurMetodoPagamento.anm_n_valida_pagamento = .T.
							 	Thisformset.lx_forM1.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.Enabled= .F.
							Endif	
						Endif	
					** Fim
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif	
			
				
	 
			otherwise
		   return .t.				
		endcase
	endproc
enddefine

