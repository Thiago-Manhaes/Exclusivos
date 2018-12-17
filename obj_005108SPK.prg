* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Consulta Entradas por colecao propriedade                                                                                                     *
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
				
					PUBLIC xmotivo_exclusao
					
					*THISFORMSET.lx_form1.tv_operacao.p_valida_where=" AND Naturezas_entradas.Inativo = 0 AND Naturezas_entradas.Natureza NOT IN ( SELECT Natureza FROM Naturezas_Entradas_Bloqueadas WHERE Usuario = ?wUsuario ) and naturezas_entradas.CTB_TIPO_OPERACAO in ( 200, 201, 202, 205 ,208, 215, 240, 241, 245, 246 ,260 ,299)" 
					THISFORMSET.lx_form1.tv_operacao.p_valida_where=" AND Naturezas_entradas.Inativo = 0 AND naturezas_entradas.CTB_TIPO_OPERACAO in ( 200,201, 202, 205, 208, 215, 240, 241, 245, 246 , 260, 299)" 
							
				
	
				case UPPER(xmetodo) == 'USR_SAVE_BEFORE' 
						
					xalias=alias()
				
				&& Alterado por Tinoco para contemplar a conta contabil correta conforme a operacao
				
					IF UPPER(thisformset.p_tool_status) $ 'IA'
					
					
						SELECT V_ENTRADAS_00_ITENS 
						SCAN 
						
							IF V_ENTRADAS_00.CTB_TIPO_OPERACAO >= 200 AND V_ENTRADAS_00.CTB_TIPO_OPERACAO <= 202 
								
								
								F_SELECT("SELECT CONTA_CONTABIL_COMPRA FROM PRODUTOS WHERE PRODUTO = ?V_ENTRADAS_00_ITENS.CODIGO_ITEM","XCUR_CONTA_COMPRA",ALIAS()) 
								REPLACE CONTA_CONTABIL WITH XCUR_CONTA_COMPRA.CONTA_CONTABIL_COMPRA
							
							ENDIF 
							
						ENDSCAN 
						
					ENDIF 
				
						
						
						**** Controle para exclusao de Nota Fiscal
						IF THISFORMSET.P_TOOL_status == 'E'					
							MESSAGEBOX("Atenção, Todos os Seus Dados Serão Armazenados ",48,"Atenção_9!")		
							xmotivo_exclusao = inputbox('Descreva o motivo da Exclusão','Motivo Exclusão (Campo Obrigatório)','')
								 	
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
								messagebox("Não foi possível Excluir a Nota Fiscal ",48,"Atenção_9!")
								retu .f.
							endif
						ENDIF	
						**** Fim ***** if allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='5' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='A5'
						
													
							sele v_entradas_00	
							replace Agrupamento_itens with 3  
							
							thisformset.LX_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page2.Cmb_agrupamento.ValUE=3
							thisformset.LX_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page2.Cmb_agrupamento.Valid()
							
						IF thisformset.LX_FORM1.Lx_pageframe1.Page1.Pageframe1.Page1.Ck_nf_propria.value == .F.
							if	allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='E1' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='U' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='5' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='55'
								retu .t.
							else	
								messagebox("É permitido somente o uso das Séries U, 5 e de Produção !",48,"Atenção!!!")
								retu .f.
							endif		
						ELSE
							if allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='5' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='A5'
								retu .t.
							else	
								messagebox("É permitido somente o uso da Série 5 !",48,"Atenção!!!")
								retu .f.
							endif
						ENDIF
					
						
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	 				
				
				
					
				case UPPER(xmetodo) == 'USR_VALID'

					xalias=alias()
					
							sele v_entradas_00	
			         		thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tx_CliFor1.VALUE	
							f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_entradas_00.rateio_filial","curRATEIO",alias())
							thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.tx_desc_filial_rateio.Value = curRATEIO.desc_rateio_filial
						
						**** Julio - Veficica junto ao parâmetro ANM_NATUREZAS_IMPORTACAO as naturezas Permitidas para entrada de importação. ****
						If upper(xnome_obj)=='CK_IMPORTACAO'
							
							sele v_entradas_00	
							xSelImp = "SELECT COUNT(*) AS EntImpOK  FROM PARAMETROS WHERE PARAMETRO = 'ANM_NATUREZAS_IMPORTACAO' AND ( VALOR_ATUAL LIKE '%"+ALLT(v_Entradas_00.NATUREZA)+"%' OR VALOR_ATUAL = 'LIBERADO' )"
							f_select(xSelImp,"xteste")	
							
							If xteste.EntImpOK = 0
							    Thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.Ck_importacao.value=0
							    MESSAGEBOX('Não é permitido Entrada de Importação com essa natureza'+CHR(13)+'Favor Procurar o Dpto. Fiscal.',64)
							Endif
								
						Endif					
							
						*** Bloqueia alterar a natureza após a verificação caso o checkbox importação esteja marcado na tela em modo de inclusão ou alteraçao **	
							If v_entradas_00.importacao=.T.
								if Thisformset.p_tool_status $ 'I,A'
									Thisformset.lx_FORM1.tv_operacao.ReadOnly= .T.
								endif
							Else 
								Thisformset.lx_FORM1.tv_operacao.ReadOnly= .F.
							Endif	
						*** Fim do exclusivo de validação da natureza na entrada de importação ******
						*****************************************************************************
					
						***** Coloca Falso para gerar itens fisicos no retorno quando for compra de serviços ***				
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
								ELSE
									IF thisformset.lx_FORM1.Tx_clifor1.value = '000988'
									   thisformset.lx_FORM1.Tx_clifor1.value = '000017' 	  
									   thisformset.lx_FORM1.TV_FILIAL_ENTRADA.VALUE = 'ATACADO'
									ENDIF
								ENDIF		 	
								
								* Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo cliente
								THISFORMSET.lx_FORM1.Tx_clifor.refresh()
								IF thisformset.lx_FORM1.Tx_clifor.value = '000991'
								   thisformset.lx_FORM1.Tx_clifor.value = '000999'
								   thisformset.lx_FORM1.Tx_nome_clifor.VALUE = 'ESTOQUE CENTRAL'
								ELSE
									IF thisformset.lx_FORM1.Tx_clifor.value = '000988'
									   thisformset.lx_FORM1.Tx_clifor.value = '000017' 	  
									   thisformset.lx_FORM1.Tx_nome_clifor.VALUE = 'ATACADO'
									ENDIF
								ENDIF
						
						ENDIF
					
						IF THISFORMSET.p_tool_status = 'I' AND upper(xnome_obj)=='TX_NF_ENTRADA'
					
							thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE = RIGHT(STR(VAL(thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE)+10000000),7)
					
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

				if	!f_vazio(xalias)	
					sele &xalias 
				endif	
	
	
			otherwise
		   return .t.				
		endcase
	endproc
enddefine

