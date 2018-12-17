* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Controle de Coleta das Saidas de Material					                    *
********************************************************************************************************************* 

* Alteração ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                         *
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

			* Sintese Soluções - Tiago Carvalho - CRIADO OBJETO PARA IMPRIMIR ETIQUETA DE LOCALIZAÇÃO DE MATÉRIA PRIMA
			Case UPPER(ALLT(xmetodo)) == 'USR_INIT'
				
				WAIT WINDOW 'OBJ-SS 1.0' NOWAIT
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.addcolumn(14)
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.columns[14].name = 'col_etiqueta_peca'
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.width = 70
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.BackColor = 15399423
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.columnorder = 7
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.header1.caption = 'Etiqueta'
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.header1.alignment = 2
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.header1.FONTSIZE = 8
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.addobject('bt_etiqueta_peca','bt_etiqueta_peca')
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.currentcontrol = 'bt_etiqueta_peca'
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.removeobject('text1')
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.currentcontrol = 'bt_etiqueta_peca'
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.sparse = .F.
				thisformset.lx_forM1.lx_pageframe1.page3.lx_GRID_FILHA1.col_etiqueta_peca.refresh()
					
				xalias=alias()				
				 *Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_estoque_sai_mat_00   
				sele v_estoque_sai_mat_00   
				xalias_pai=alias()
 
  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("ESTOQUE_SAI_MAT.ANM_STATUS_ALMOX", "C(25)",.T., "ANM_STATUS_ALMOX", "ESTOQUE_SAI_MAT.ANM_STATUS_ALMOX")
				oCur.addbufferfield("'' AS DATA_COLETA", "C(25)",.T., "DATA_COLETA", "DATA_COLETA")
				oCur.addbufferfield("'' AS USUARIO_TECIDO", "C(25)",.T., "USUARIO_TECIDO", "USUARIO_TECIDO")
				oCur.addbufferfield("'' AS USUARIO_AVIAMENTO", "C(25)",.T., "USUARIO_AVIAMENTO", "USUARIO_AVIAMENTO")
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 

				Thisformset.L_limpa()


				public xstatus_entrada,xreq_material,xfilial
				f_select("select convert(varchar(25),valor_propriedade) as anm_status_almox from propriedade_valida where propriedade='00059'","xstatus_entrada")
				
				store '' to	xordem_servico,xreq_material,xfilial

				with thisformset.lx_form1
					.addobject("lb_status_entrada","lb_status_entrada")
					.addobject("cmb_status_entrada","cmb_status_entrada")
					.addobject("lb_data_coletado","lb_data_coletado")
					.addobject("lb_Prod_PA","lb_Prod_PA")
					.lx_label3.Top =73
					.tv_nome_clifor.top =70
				endwith		
				
				
				with thisformset.lx_form1
					.cmb_status_entrada.RowSource="xstatus_entrada"
					.cmb_status_entrada.ControlSource="v_estoque_sai_mat_00.ANM_STATUS_ALMOX"
				endwith	
				

				if !f_vazio(xalias)
					sele &xalias
				endif	

				
				thisformset.lx_FORM1.lb_status_entrada.left =16




				case upper(xmetodo) == 'USR_REFRESH' 
				
				xalias=alias()
					
					
					if type("thisformset.lx_FORM1.lb_status_entrada")<>"U"
						thisformset.lx_FORM1.lb_status_entrada.Alignment   = 0
						thisformset.lx_FORM1.lb_status_entrada.left =16
						thisformset.lx_FORM1.lb_status_entrada.Anchor=0	
						if thisformset.p_tool_status = "I" or thisformset.p_tool_status = "L" 
							thisformset.lx_FORM1.cmb_status_entrada.enabled=.T.
						else	
							thisformset.lx_FORM1.cmb_status_entrada.enabled=.F.	
						endif
						
						if ALLTRIM(v_estoque_sai_mat_00.anm_status_almox)=="2-COLETADO" 
							f_select("select (convert(varchar(10),TIMESTAMP,103)+' '+convert(varchar(10),TIMESTAMP,108)) as data_coleta from ANM_STATUS_SAI_MAT_MOV where REQ_MATERIAL=?v_estoque_sai_mat_00.req_material","xdata_coletado",ALIAS())
							thisformset.lx_FORM1.lb_data_coletado.caption=xdata_coletado.data_coleta		
						else
							thisformset.lx_FORM1.lb_data_coletado.caption=""
						endif						
						
						******** Verifica PA ************
						
						TEXT TO SelLabelPA TEXTMERGE NOSHOW
					
							select 1 as VLabelPA,'PA' as LabelPA
							from estoque_sai_mat a
							join producao_ordem_servico b
							on a.ordem_servico = b.ordem_servico
							join producao_ordem c
							on b.ordem_producao_os = c.ordem_producao
							join prop_produtos d
							on c.produto = d.produto
							and valor_propriedade = 'PRODUTO ACABADO'
							and propriedade = '00036'
							and a.req_material = '<<v_estoque_sai_mat_00.req_material>>'
					
						ENDTEXT
						
						f_select(SelLabelPA,"xLabelPA")
						
						IF xLabelPA.VLabelPA> 0
							thisformset.lx_foRM1.lb_Prod_PA.caption = xLabelPA.LabelPA
						ENDIF
					
					endif	
					
					IF UPPER(thisformset.p_tool_status) $ 'IA'
					
						thisformset.lx_form1.cmb_status_entrada.enabled = .f.	
					
					ENDIF
					
				if !f_vazio(xalias)
					sele &xalias
				endif	
				
				case upper(xmetodo) == 'USR_INCLUDE_AFTER' 
				
				xalias=alias()
					
					thisformset.lx_form1.cmb_status_entrada.value = "1-COLETA PENDENTE"
					

				if !f_vazio(xalias)
					sele &xalias
				endif
				
				case upper(xmetodo) == 'USR_SEARCH_AFTER' 
				
				xalias=alias()
				
				
				SELE V_ESTOQUE_SAI_MAT_00
				GO TOP
				SCAN
					
					TEXT TO XSEL TEXTMERGE NOSHOW
					
						SELECT A.REQ_MATERIAL,
						(convert(varchar(10),TIMESTAMP,103)+' '+convert(varchar(10),TIMESTAMP,108)) AS DATA_COLETA,
						ISNULL(convert(varchar(25),B.VALOR_PROPRIEDADE),'') AS USUARIO_AVIAMENTO,
						ISNULL(convert(varchar(25),C.VALOR_PROPRIEDADE),'') AS USUARIO_TECIDO
						FROM ANM_STATUS_SAI_MAT_MOV A 
						LEFT JOIN PROP_ESTOQUE_SAI_MAT B
						ON A.REQ_MATERIAL = B.REQ_MATERIAL
						AND B.PROPRIEDADE = '00066'
						LEFT JOIN PROP_ESTOQUE_SAI_MAT C
						ON A.REQ_MATERIAL = C.REQ_MATERIAL
						AND C.PROPRIEDADE = '00067'
						WHERE A.REQ_MATERIAL = '<<v_estoque_sai_mat_00.req_material>>'
						
					ENDTEXT

					f_select(xsel,"xTempSelect",ALIAS())
					
					sele V_ESTOQUE_SAI_MAT_00
					
					replace data_coleta       WITH xTempSelect.data_coleta
					replace usuario_aviamento WITH xTempSelect.usuario_aviamento
					replace usuario_tecido    WITH xTempSelect.usuario_tecido
					
				ENDSCAN	
				
				SELE V_ESTOQUE_SAI_MAT_00
				GO TOP
				
				if !f_vazio(xalias)
					sele &xalias
				endif
				
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE' 
				
				xalias=alias()
					
					  IF UPPER(thisformset.p_tool_status) $ 'IA'	 
							
								f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_SAI_MAT_PARCIAL') AS ValorParam","xParam_Sai_Parcial")
								f_select("select * from materiais where 1=2","Cur_dados_materiais",ALIAS())
								f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('TOLER_MAX_ENVIO_MAT_QTDE') AS ValorParam","xParam_MP")
							
								If val(xParam_Sai_Parcial.ValorParam) > 0 
										 
										ThisFormset.LX_FORM1.LX_pageframe1.Page2.setfocus()
										ThisFormset.LX_FORM1.LX_pageframe1.Page2.LX_GRID_FILHA1.Refresh()
										xOrdemProducao = ThisFormset.LX_FORM1.LX_pageframe1.Page2.LX_GRID_FILHA1.COL_ORDEM_PRODUCAO.TV_ORDEM_PRODUCAO.Value

										TEXT TO SelVerifQtdeSaida TEXTMERGE NOSHOW
										
											select COUNT(*) as QTDE_MAT  
												from (SELECT * FROM PRODUCAO_RESERVA (nolock) 
												WHERE ORDEM_PRODUCAO = '<<xOrdemProducao>>') A
													join MATERIAIS (nolock) C
													on A.MATERIAL = C.MATERIAL
														Left Join ESTOQUE_SAI1_MAT B
															On A.ORDEM_PRODUCAO = B.ORDEM_PRODUCAO 	AND
															   A.MATERIAL = B.MATERIAL 				AND
															   A.COR_MATERIAL = B.COR_MATERIAL 		AND
															   B.REQ_MATERIAL = '<<v_estoque_sai_mat_00.req_material>>'
															   
											where  A.RESERVA+ISNULL(B.QTDE,0) > 0 AND A.ANM_RESERVA_ALMOX = 1
										
										ENDTEXT
										
										f_select(SelVerifQtdeSaida,"VerifQtdeSaida")
										
											sele v_estoque_sai_mat_00_materiais
											GO TOP
											
										If RECCOUNT() < VerifQtdeSaida.QTDE_MAT
											
											MESSAGEBOX('Impossível Incluir Saída, Falta consumir Material, ATENÇÃO!',64)
											RETURN .F.
											
										Endif	

								Endif

										SELECT v_estoque_sai_mat_00_materiais
										If RECCOUNT() > 0
											
											xMsgErro = ""

											SELECT v_estoque_sai_mat_00_materiais
											GO TOP
											
											SCAN
																						
													TEXT TO xVerifQtde TEXTMERGE NOSHOW
													
														Select A.MATERIAL,A.COR_MATERIAL,A.RESERVA+ISNULL(B.QTDE,0) AS RESERVA,<<Qtde>> AS QTDE 
														From PRODUCAO_RESERVA A 
															join MATERIAIS (nolock) C
															on A.MATERIAL = C.MATERIAL
																Left Join ESTOQUE_SAI1_MAT B
																On A.ORDEM_PRODUCAO = B.ORDEM_PRODUCAO 	AND
																   A.MATERIAL = B.MATERIAL 				AND
																   A.COR_MATERIAL = B.COR_MATERIAL 		AND
																   B.REQ_MATERIAL = '<<v_estoque_sai_mat_00.req_material>>'
														Where A.ORDEM_PRODUCAO = '<<Ordem_Producao>>' 	AND 
														      A.RESERVA+ISNULL(B.QTDE,0) > 0 			AND 
														      A.ANM_RESERVA_ALMOX = 1					AND
														      C.TIPO IN ('AVIAMENTOS','PANOS') 
														       
														  AND A.MATERIAL = '<<Material>>' and A.COR_MATERIAL = '<<Cor_Material>>'
														  AND ( '<<Qtde>>' < RESERVA+ISNULL(B.QTDE,0)-<<xParam_MP.ValorParam>> OR 
														        '<<Qtde>>' > RESERVA+ISNULL(B.QTDE,0)+<<xParam_MP.ValorParam>> )
													
													ENDTEXT
												
												
												f_select(xVerifQtde,"TMP_Cur_VerifQtde")
												
												Sele TMP_Cur_VerifQtde
												IF RECCOUNT() > 0	
												
													xMsgErro = xMsgErro +ALLTRIM(Material)+" | "+ALLTRIM(Cor_material)+;
												                          " | "+ALLTRIM(STR(Reserva,12,3))+" | "+ALLTRIM(STR(Qtde,12,3))+CHR(13)		
												ENDIF
											
											SELECT v_estoque_sai_mat_00_materiais
											
											ENDSCAN
											
											IF !f_vazio(xMsgErro)
												MESSAGEBOX("Qtde Menor ou Maior que a Reservada:"+CHR(13)+;
												"Material | Cor Material | Necessidade | Reservado "+CHR(13)+CHR(13)+xMsgErro,64)
												RETURN .f.
											
											ENDIF
										Endif
								ENDIF
					
*!*						TEXT TO SelVerificaPA TEXTMERGE NOSHOW
*!*						
*!*							select 1 as VerificaPA,valor_propriedade,A.* 
*!*							from producao_ordem_servico a
*!*							join producao_ordem b
*!*							on a.ordem_producao_os = b.ordem_producao
*!*							join prop_produtos c
*!*							on b.produto = c.produto
*!*							and valor_propriedade = 'PRODUTO ACABADO'
*!*							and propriedade = '00036'
*!*							where a.ordem_servico = '<<V_ESTOQUE_SAI_MAT_00.ORDEM_SERVICO>>'
*!*						
*!*						ENDTEXT
*!*						
*!*						f_select(SelVerificaPA,"xVerificaPA")
*!*						
*!*						IF xVerificaPA.VerificaPA > 0
*!*							thisformset.LX_FORM1.LX_container1.Lx_checkbox1.Value=0
*!*						ENDIF
					
					if thisformset.p_tool_status == 'E'		
						
						TEXT TO UdtVoltaStatus TEXTMERGE NOSHOW
						
							update producao_ordem_servico set
							anm_status_almox = '1-ENVIADO PARA ALMOX'
							where ordem_servico = '<<V_ESTOQUE_SAI_MAT_00.ORDEM_SERVICO>>'
						
						ENDTEXT
						
						TEXT TO xDeletaLog TEXTMERGE NOSHOW
						
							delete ANM_STATUS_OS_MOV 
							where chave_sai_mat = '<<v_estoque_sai_mat_00.req_material>>'
							
							delete ANM_STATUS_SAI_MAT_MOV
							where req_material = '<<v_estoque_sai_mat_00.req_material>>'
						
						ENDTEXT
						
						f_insert(UdtVoltaStatus)
						f_insert(xDeletaLog)
						
						***********************************************************
						
						TEXT TO UdtVoltaStatusPed TEXTMERGE NOSHOW
						
							update compras set
							anm_status_almox = '1-ENVIADO PARA ALMOX'
							where pedido = '<<V_ESTOQUE_SAI_MAT_00_MATERIAIS.ORDEM_PRODUCAO>>'
							--and TABELA_FILHA = 'COMPRAS_PRODUTO'
						
						ENDTEXT
						
						TEXT TO xDeletaLogPed TEXTMERGE NOSHOW
							
							delete ANM_STATUS_COMPRAS_MP_MOV
							where chave_sai_mat = '<<v_estoque_sai_mat_00.req_material>>' 
							
							delete ANM_STATUS_COMPRAS_PA_MOV
							where chave_sai_mat = '<<v_estoque_sai_mat_00.req_material>>'
							
							delete ANM_STATUS_SAI_MAT_MOV
							where req_material = '<<v_estoque_sai_mat_00.req_material>>'
						
						ENDTEXT
						
						f_insert(UdtVoltaStatusPed)
						f_insert(xDeletaLogPed)		
									
					endif
				
				if !f_vazio(xalias)
					sele &xalias
				endif
				
				
				
				case upper(xmetodo) == 'USR_VALID' 
				
					xalias=alias() 
					
						IF UPPER(xnome_obj)== 'LX_TEXTBOX_VALIDA1'
							
							F_SELECT("SELECT ISNULL(B.VALOR_PROPRIEDADE,FORNECEDOR) AS FORNECEDOR FROM COMPRAS A LEFT JOIN PROP_COMPRAS B ON A.PEDIDO = B.PEDIDO AND B.PROPRIEDADE = '00370' WHERE A.PEDIDO = ?V_ESTOQUE_SAI_MAT_00_OC.ORDEM_PRODUCAO","xFornPedido")	
							
							IF F_VAZIO(V_ESTOQUE_SAI_MAT_00.NOME_CLIFOR)								
								SELECT V_ESTOQUE_SAI_MAT_00
								REPLACE NOME_CLIFOR WITH xFornPedido.FORNECEDOR
								THISFORMSET.LX_FORM1.TV_nome_clifor.Refresh()
							ELSE
								F_SELECT("SELECT RTRIM(FORNECEDOR) AS FORNECEDOR FROM COMPRAS WHERE PEDIDO = ?V_ESTOQUE_SAI_MAT_00_OC.ORDEM_PRODUCAO","xFornPedido")
								F_SELECT("SELECT LTRIM(RTRIM(VALOR_PROPRIEDADE)) AS FORN_ACAB FROM PROP_COMPRAS WHERE PROPRIEDADE = '00370'  AND PEDIDO = ?V_ESTOQUE_SAI_MAT_00_OC.ORDEM_PRODUCAO","xFornPedidoAcab")
								
								If RECCOUNT("xFornPedidoAcab") = 0
									xFornAcab = 'FORNECEDOR NULO'
								Else
									xFornAcab = xFornPedidoAcab.FORN_ACAB
								Endif
										IF xFornPedido.FORNECEDOR <> ALLTRIM(V_ESTOQUE_SAI_MAT_00.NOME_CLIFOR) or xFornAcab <> ALLTRIM(V_ESTOQUE_SAI_MAT_00.NOME_CLIFOR)								
											MESSAGEBOX("Beneficiador Selecionado é diferente do pedido ("+ALLTRIM(xFornPedido.FORNECEDOR)+")",0+64)
											THISFORMSET.LX_FORM1.LX_Pageframe1.PAge6.Lx_pageframe1.Page1.Bt_nenhuma_oc.Click()
											SELE V_ESTOQUE_SAI_MAT_00_MATERIAIS
											
											IF RECCOUNT()=0
												SELE V_ESTOQUE_SAI_MAT_00
												REPLACE V_ESTOQUE_SAI_MAT_00.NOME_CLIFOR WITH ""
											ELSE
												THISFORMSET.LX_FORM1.TV_nome_clifor.Enabled = .F.	
											ENDIF
											
											THISFORMSET.LX_FORM1.TV_nome_clifor.Refresh()
										ENDIF					  	
							ENDIF
						
						ENDIF
					
					if !f_vazio(xalias)
						sele &xalias
					endif
				
				
				case upper(xmetodo) == 'USR_SAVE_AFTER' 
				
				xalias=alias()
								
					if thisformset.p_tool_status == 'I'
						
						*** Verifica se saida pode ter sido impressa com OS agrupada e emite um alerta ** Julio - 22-05-2014 ***
						TEXT TO xSelAgrup TEXTMERGE NOSHOW

							SELECT ORDEM_PRODUCAO,ORDEM_SERVICO 
							FROM PRODUCAO_ORDEM_SERVICO A 
								JOIN PRODUCAO_ORDEM B
								ON A.ORDEM_PRODUCAO_OS = B.ORDEM_PRODUCAO
								
								JOIN (SELECT B.PRODUTO
										FROM PRODUCAO_ORDEM_SERVICO A
											JOIN PRODUCAO_ORDEM B
											ON A.ORDEM_PRODUCAO_OS = B.ORDEM_PRODUCAO
												JOIN (SELECT DISTINCT ORDEM_PRODUCAO 
												       FROM PRODUCAO_RESERVA WHERE RESERVA > 0 ) C
												ON B.ORDEM_PRODUCAO = C.ORDEM_PRODUCAO
												
									   WHERE A.ANM_STATUS_ALMOX = '1-ENVIADO PARA ALMOX'
									   GROUP BY B.PRODUTO,RECURSO_PRODUTIVO
									   HAVING COUNT(B.ORDEM_PRODUCAO) > 1 ) C
								ON B.PRODUTO = C.PRODUTO
							WHERE A.ANM_STATUS_ALMOX = '1-ENVIADO PARA ALMOX'

						ENDTEXT

						F_SELECT(xSelAgrup,"xConfereAgrup")
						
						sele xConfereAgrup
						LOCATE FOR v_estoque_sai_mat_00.ordem_servico = xConfereAgrup.ordem_servico OR ;
						   v_estoque_sai_mat_00_materiais.ordem_producao = xConfereAgrup.ordem_producao

						IF FOUND()

							MESSAGEBOX("ATENÇÃO!!"+CHR(13)+"Separação pode ter agrupamento de OS,"+CHR(13)+"Favor conferir no relatório",64)

						ENDIF						
						***** TERMINA AQUI ****
						
						
						TEXT TO UdtStatusFin TEXTMERGE NOSHOW
						
							UPDATE A SET ANM_STATUS_ALMOX = B.ANM_STATUS_ALMOX 
							FROM PRODUCAO_ORDEM_SERVICO A
							JOIN ( SELECT A.ORDEM_SERVICO,
							       CASE WHEN SUM(RESERVA) = 0 THEN '2-FINALIZADO' ELSE '3-FINALIZADO INCONSISTENC' END AS ANM_STATUS_ALMOX
								   FROM PRODUCAO_ORDEM_SERVICO A
										JOIN WANM_PRODUCAO_TAREFAS_OS B
										ON A.ORDEM_SERVICO = B.ORDEM_SERVICO
											JOIN PRODUCAO_RESERVA C
											ON B.ORDEM_PRODUCAO = C.ORDEM_PRODUCAO
								   WHERE A.ORDEM_SERVICO = '<<V_ESTOQUE_SAI_MAT_00.ORDEM_SERVICO>>' AND
								         C.ANM_RESERVA_ALMOX = 1
							       GROUP BY A.ORDEM_SERVICO ) B
							ON A.ORDEM_SERVICO = B.ORDEM_SERVICO 
						
						ENDTEXT
	
						f_insert(UdtStatusFin)
					
						sele v_estoque_sai_mat_00					
						f_select("select ordem_servico,anm_status_almox from producao_ordem_servico where ordem_servico =?v_estoque_sai_mat_00.ordem_servico","xValidaStatus",ALIAS())

						
							TEXT TO xInsertLog TEXTMERGE NOSHOW
						
								INSERT INTO ANM_STATUS_OS_MOV
								(ORDEM_SERVICO,ANM_STATUS_ALMOX,
								DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID,CHAVE_SAI_MAT)
								SELECT 
								'<<v_estoque_sai_mat_00.ordem_servico>>',
								'<<xValidaStatus.anm_status_almox>>','<<DTOS(WDATA)>>','<<WUSUARIO>>','<<SYSTEM.NetUserName>>',
								'<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
								(select max(id_registro) from ANM_STATUS_OS_MOV 
								where ordem_servico = '<<v_estoque_sai_mat_00.ordem_servico>>' and left(ANM_STATUS_ALMOX,1)=1 ),
								'<<v_estoque_sai_mat_00.req_material>>'
						
							ENDTEXT	
							
							f_insert(xInsertLog)
												
					***************************************
					
					TEXT TO UdtStatusFinPed TEXTMERGE NOSHOW
						
							UPDATE A SET ANM_STATUS_ALMOX = B.ANM_STATUS_ALMOX, A.ANM_DATA_INICIO_SEPARACAO = NULL
							FROM  COMPRAS A
							JOIN ( SELECT A.PEDIDO,
							       CASE WHEN SUM(RESERVA) = 0 THEN '2-FINALIZADO' ELSE '3-FINALIZADO INCONSISTENC' END AS ANM_STATUS_ALMOX
								   FROM COMPRAS A
											JOIN PRODUCAO_RESERVA B
											ON A.PEDIDO = B.ORDEM_PRODUCAO
											AND A.TABELA_FILHA = 'COMPRAS_PRODUTO'
								   WHERE A.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00_MATERIAIS.ORDEM_PRODUCAO>>' AND
								         B.ANM_RESERVA_ALMOX = 1
							       GROUP BY A.PEDIDO ) B
							ON A.PEDIDO = B.PEDIDO 
							AND A.TABELA_FILHA = 'COMPRAS_PRODUTO'
						
						ENDTEXT
	
						f_insert(UdtStatusFinPed)
							
						sele v_estoque_sai_mat_00					
						f_select("select top 1 pedido,anm_status_almox from compras where pedido =?V_ESTOQUE_SAI_MAT_00_MATERIAIS.ordem_producao","xValidaStatusPed",ALIAS())

						
							TEXT TO xInsertLogPed TEXTMERGE NOSHOW
						
								INSERT INTO ANM_STATUS_COMPRAS_PA_MOV
								(PEDIDO,ANM_STATUS_ALMOX,
								DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID,CHAVE_SAI_MAT)
								SELECT 
								'<<V_ESTOQUE_SAI_MAT_00_MATERIAIS.ORDEM_PRODUCAO>>',
								'<<xValidaStatusPed.anm_status_almox>>','<<DTOS(WDATA)>>','<<WUSUARIO>>','<<SYSTEM.NetUserName>>',
								'<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
								(select max(id_registro) from ANM_STATUS_COMPRAS_PA_MOV
								where PEDIDO = '<<V_ESTOQUE_SAI_MAT_00_MATERIAIS.ORDEM_PRODUCAO>>' and left(ANM_STATUS_ALMOX,1)=1 ),
								'<<v_estoque_sai_mat_00.req_material>>'
						
							ENDTEXT	
							
							f_insert(xInsertLogPed)
								
	***************************
	***************************************
					   
					TEXT TO UdtStatusFinPedMat TEXTMERGE NOSHOW
						
							UPDATE A SET ANM_STATUS_ALMOX = B.ANM_STATUS_ALMOX, A.ANM_DATA_INICIO_SEPARACAO = NULL
							FROM  COMPRAS A
							JOIN ( SELECT A.PEDIDO,
							       CASE WHEN SUM(RESERVA) = 0 THEN '2-FINALIZADO' ELSE '3-FINALIZADO INCONSISTENC' END AS ANM_STATUS_ALMOX
								   FROM COMPRAS A
											JOIN PRODUCAO_RESERVA B
											ON A.PEDIDO = B.ORDEM_PRODUCAO
											AND A.TABELA_FILHA = 'COMPRAS_MATERIAL'
								   WHERE A.PEDIDO = '<<V_ESTOQUE_SAI_MAT_00_MATERIAIS.ORDEM_PRODUCAO>>' AND
								         B.ANM_RESERVA_ALMOX = 1
							       GROUP BY A.PEDIDO ) B
							ON A.PEDIDO = B.PEDIDO 
							AND A.TABELA_FILHA = 'COMPRAS_MATERIAL'
						
						ENDTEXT
	
						f_insert(UdtStatusFinPedMat)
							
						sele v_estoque_sai_mat_00					
						f_select("select top 1 pedido,anm_status_almox from compras where pedido =?V_ESTOQUE_SAI_MAT_00_MATERIAIS.ordem_producao","xValidaStatusPedMat",ALIAS())

						
							TEXT TO xInsertLogPedMat TEXTMERGE NOSHOW
						
								INSERT INTO ANM_STATUS_COMPRAS_MP_MOV
								(PEDIDO,ANM_STATUS_ALMOX,
								DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID,CHAVE_SAI_MAT)
								SELECT 
								'<<V_ESTOQUE_SAI_MAT_00_MATERIAIS.ORDEM_PRODUCAO>>',
								'<<xValidaStatusPedMat.anm_status_almox>>','<<DTOS(WDATA)>>','<<WUSUARIO>>','<<SYSTEM.NetUserName>>',
								'<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
								(select max(id_registro) from ANM_STATUS_COMPRAS_PA_MOV
								where PEDIDO = '<<V_ESTOQUE_SAI_MAT_00_MATERIAIS.ORDEM_PRODUCAO>>' and left(ANM_STATUS_ALMOX,1)=1 ),
								'<<v_estoque_sai_mat_00.req_material>>'
						
							ENDTEXT	
							
							f_insert(xInsertLogPedMat)
								
	***************************
				endif
							
				
				if !f_vazio(xalias)
					sele &xalias
				endif
					
					case upper(xmetodo) == 'USR_TRIGGER_BEFORE' 
					
						xalias=alias()
							

							*** Busca Paramêtros ***********************************************************************************
								f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_ARMAZEM') AS VALOR_ATUAL","xFILDEP") 
								f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_DEST_ARMAZEM') AS VALOR_ATUAL","xFILDEST")
								f_select("SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_PILOTAGEM') AS VALOR_ATUAL","xFILPILOT")
							********************************************************************************************************	
							
							IF thisformset.p_tool_status == 'A'
								
								MESSAGEBOX('Não é permitido Alterar Saída'+CHR(13)+'Tranferência de estoque já esta encerrada'+CHR(13)+'Excluir e Refazer.',64)
								RETURN .F.
									
							ENDIF	
							
							IF thisformset.p_tool_status == 'I'
								
								
								***** Calcula Custos dos materiais **** Tela não esta fazendo ****								
								Sele v_estoque_sai_mat_00_materiais
								GO TOP
								Scan
									Thisformset.lx_atualiza_custo()
								EndScan	
								GO TOP 
								******************************************************************
								
								***** Passa os Parameetros para variável ***********							
								xFilial        = ALLTRIM(xFILDEP.VALOR_ATUAL) 
								xFilialDestino = ALLTRIM(xFILDEST.VALOR_ATUAL) 
								****************************************************
								
								******* Loop para Pilotagem **************
								IF  ALLTRIM(v_estoque_sai_mat_00.FILIAL) == ALLTRIM(xFILDEST.VALOR_ATUAL)
									xExec = 1
								ELSE
									IF ALLTRIM(v_estoque_sai_mat_00.FILIAL) == ALLTRIM(xFILPILOT.VALOR_ATUAL)
										xExec = 0
									ELSE
										xExec = 2 	
									ENDIF	
								ENDIF	
								
								DO WHILE xExec < 2 
								
								IF ALLTRIM(UPPER(xFilial)) <> ALLTRIM(UPPER(xFilialDestino))							
									**********************************************
									**** Insere Tabela Pai ***********************
									TEXT TO xInsertPai TEXTMERGE NOSHOW
														
										INSERT INTO ESTOQUE_SAI_MAT 
										(	REQ_MATERIAL,FILIAL,TIPO_MOVIMENTACAO,EMISSAO,CENTRO_CUSTO,SAIDA_POR_PECA,RESPONSAVEL,REQUISITANTE,DESTINO,
											NF_ENTRADA,NOME_CLIFOR,FILIAL_FATURAMENTO,SERIE_NF,NF_SAIDA,ORDEM_SERVICO,FORNECEDOR,FASE_PRODUCAO,FILIAL_DESTINO,
											REQ_MATERIAL_DESTINO,PEDIDO,OBS,NUMERO_EMBALAGEM,PESO_LIQUIDO,PESO_BRUTO,DIMENSOES_EMBALAGEM,MOEDA,CAMBIO_NA_DATA,
											DATA_DIGITACAO,NF_PENDENTE,NAO_VALIDAR_ENTRADA,SERIE_NF_ENTRADA,RATEIO_FILIAL,RATEIO_CENTRO_CUSTO,CONTA_CONTABIL,
											CM_OPERACAO,ANM_STATUS_ALMOX 
										)	VALUES
														
										(	'<<v_estoque_sai_mat_00.REQ_MATERIAL>>','<<xFilial>>','C','<<dtos(v_estoque_sai_mat_00.EMISSAO)>>',null,0,
											'<<v_estoque_sai_mat_00.RESPONSAVEL>>','<<v_estoque_sai_mat_00.REQUISITANTE>>',NULL,'','<<xFilialDestino>>',NULL,
											NULL,NULL,NULL,'','','<<xFilialDestino>>',NULL,NULL,'','<<v_estoque_sai_mat_00.NUMERO_EMBALAGEM>>',
											'<<v_estoque_sai_mat_00.PESO_LIQUIDO>>','<<v_estoque_sai_mat_00.PESO_BRUTO>>','<<v_estoque_sai_mat_00.DIMENSOES_EMBALAGEM>>',
											'R$',NULL,'<<dtos(v_estoque_sai_mat_00.DATA_DIGITACAO)>>',1,1,NULL,NULL,NULL,NULL,NULL,NULL
										)
											
									ENDTEXT

									IF !f_insert(xInsertPai)
										MESSAGEBOX('Erro na movimentação automática de Estoque',64)
										RETURN .F.
									ENDIF
									**** FIM - Insere Tabela Pai ***********************
									****************************************************
									
									
									***************************************
									**** Insere Tabela Filha Materiais ****
									SELE v_estoque_sai_mat_00_materiais
									GO TOP
					
									SCAN

										TEXT TO xInsertFilha TEXTMERGE NOSHOW
															
											INSERT INTO ESTOQUE_SAI1_MAT 
											( 	REQ_MATERIAL,FILIAL,MATERIAL,COR_MATERIAL,ITEM,ORDEM_PRODUCAO,QTDE,QTDE_AUX,CUSTO,DATA_CUSTO,MATAR_SALDO_RESERVA,
												FILIAL_FATURAMENTO,SERIE_NF,NF_SAIDA,ICMS,IPI,DESCONTO_ITEM,PRECO,VALOR,FATOR_CONVERSAO_UNIDADE,UNIDADE_FATURAMENTO,
												VALOR_BRUTO,ENTREGA,PEDIDO,RESERVA_AUTOMATICA,PERDA,TRANSF_ORDEM_PRODUCAO,PRECO_SERVICO,PRECO_MATERIAL_EMPREGADO,
												OF_FATURAR,CODIGO_FISCAL_OPERACAO,ITEM_IMPRESSAO,CONTA_CONTABIL,RATEIO_FILIAL,RATEIO_CENTRO_CUSTO 
											)	VALUES
															
											(	
												'<<v_estoque_sai_mat_00.REQ_MATERIAL>>','<<xFilial>>','<<v_estoque_sai_mat_00_materiais.MATERIAL>>','<<v_estoque_sai_mat_00_materiais.COR_MATERIAL>>',
												'<<v_estoque_sai_mat_00_materiais.ITEM>>',NULL,<<v_estoque_sai_mat_00_materiais.QTDE>>+<<v_estoque_sai_mat_00_materiais.PERDA>>,
												<<v_estoque_sai_mat_00_materiais.QTDE_AUX>>,<<v_estoque_sai_mat_00_materiais.CUSTO>>,'<<dtos(v_estoque_sai_mat_00_materiais.DATA_CUSTO)>>',
												0,NULL,NULL,NULL,NULL,NULL,<<v_estoque_sai_mat_00_materiais.DESCONTO_ITEM>>,
												<<v_estoque_sai_mat_00_materiais.PRECO>>,<<v_estoque_sai_mat_00_materiais.VALOR>>,'<<v_estoque_sai_mat_00_materiais.FATOR_CONVERSAO_UNIDADE>>',
												'<<v_estoque_sai_mat_00_materiais.UNIDADE_FATURAMENTO>>',<<v_estoque_sai_mat_00_materiais.VALOR_BRUTO>>,NULL,NULL,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL				
											)
												
										ENDTEXT
									
										IF !f_insert(xInsertFilha)
											MESSAGEBOX('Erro na movimentação automática de Estoque',64)
											RETURN .F.
										ENDIF
										
										
											***********************************
											**** Insere Tabela Filha Pecas ****
											Thisformset.lx_FORM1.LX_pageframe1.Page3.SetFocus()
											Thisformset.lx_FORM1.LX_pageframe1.Page3.refresh()
											SELE v_estoque_sai_mat_00_pecas
											GO TOP
											
											SCAN
											
												TEXT TO xInsertPecas TEXTMERGE NOSHOW
																	
													INSERT INTO ESTOQUE_SAI_PECA
													(	REQ_MATERIAL,FILIAL,MATERIAL,PECA,PARTIDA,COR_MATERIAL,ITEM,QTDE,QTDE_AUX,
														PERDA,PERDA_REQ_MATERIAL,FRACIONAMENTO,PECA_ORIGINAL,PARTIDA_ORIGINAL
													) VALUES				
																					
													(	
														'<<v_estoque_sai_mat_00.REQ_MATERIAL>>','<<xFilial>>','<<v_estoque_sai_mat_00_pecas.MATERIAL>>',
														'<<v_estoque_sai_mat_00_pecas.PECA>>','<<v_estoque_sai_mat_00_pecas.PARTIDA>>','<<v_estoque_sai_mat_00_pecas.COR_MATERIAL>>',
														'<<v_estoque_sai_mat_00_pecas.ITEM>>',<<v_estoque_sai_mat_00_pecas.QTDE>>,<<v_estoque_sai_mat_00_pecas.QTDE_AUX>>,
														<<v_estoque_sai_mat_00_pecas.PERDA>>,NULL,'<<v_estoque_sai_mat_00_pecas.FRACIONAMENTO>>',NULL,NULL
													)
														
												ENDTEXT
												
												IF RECCOUNT()>0
													IF !f_insert(xInsertPecas)
														MESSAGEBOX('Erro na movimentação automática de Estoque',64)
														RETURN .F.
													ENDIF
												ENDIF

												SELE v_estoque_sai_mat_00_pecas

											ENDSCAN
											**** FIM - Insere Tabela Filha Pecas ****
											*****************************************
										
										
										SELE v_estoque_sai_mat_00_materiais

									ENDSCAN
									**** FIM - Insere Tabela Filha Materiais ****
									*********************************************
								
								
									********************************************************************************
									**** Updates necessário para executar as Trigges que movimentam o estoque ******
									TEXT TO xUpdateEnt TEXTMERGE NOSHOW
										
										
										UPDATE SEQUENCIAIS SET SEQUENCIA = RIGHT(100000000+SEQUENCIA+1,TAMANHO) WHERE TABELA_COLUNA='ESTOQUE_RET_MAT.REQ_MATERIAL' 
														
										UPDATE ESTOQUE_SAI_MAT SET REQ_MATERIAL_DESTINO = 'T'+
										(SELECT RTRIM(LTRIM(SEQUENCIA)) FROM SEQUENCIAIS WHERE TABELA_COLUNA='ESTOQUE_RET_MAT.REQ_MATERIAL') 
										WHERE REQ_MATERIAL = '<<v_estoque_sai_mat_00.REQ_MATERIAL>>' AND 
										FILIAL = '<<xFilial>>' AND FILIAL_DESTINO = '<<xFilialDestino>>'
										
										UPDATE ESTOQUE_SAI_PECA SET QTDE_AUX = 0
										WHERE REQ_MATERIAL = '<<v_estoque_sai_mat_00.REQ_MATERIAL>>' AND 
										FILIAL = '<<xFilial>>'
											
									ENDTEXT


									IF !f_update(xUpdateEnt)
										MESSAGEBOX('Erro na movimentação automática de Estoque',64)
										RETURN .F.
									ENDIF

								ENDIF
								****** Parametros pra loop de pilotagem *****
								xFilial        = ALLTRIM(xFILDEST.VALOR_ATUAL)
								xFilialDestino = ALLTRIM(xFILPILOT.VALOR_ATUAL)
								**********************************************
									
								xExec = xExec + 1
								
								ENDDO
							***** FIM - CUSTOMIZAÇÃO *****
							******************************
							ENDIF
													
						if !f_vazio(xalias)
							sele &xalias
						endif		
				
				
				case UPPER(xmetodo) == 'USR_TRIGGER_AFTER' 
					
				  xalias=alias()				
					
					IF THISFORMSET.P_TOOL_STATUS == 'E'
				
							**** Deleta as trasnferencias vinculadas na movimentação *****
							TEXT TO xDelTran TEXTMERGE NOSHOW
							
								DELETE ESTOQUE_SAI_MAT 
								WHERE REQ_MATERIAL = '<<V_ESTOQUE_SAI_MAT_00.REQ_MATERIAL>>' AND
									  FILIAL = '<<ALLTRIM(xFILDEST.VALOR_ATUAL)>>'	
								
								
								DELETE ESTOQUE_SAI_MAT 
								WHERE REQ_MATERIAL = '<<V_ESTOQUE_SAI_MAT_00.REQ_MATERIAL>>' AND
									  FILIAL = '<<ALLTRIM(xFILDEP.VALOR_ATUAL)>>'
								
							ENDTEXT
												
							f_update(xDelTran)
							**** FIM - Deleta as trasnferencias vinculadas na movimentação *****
			
				   ENDIF
				
				if !f_vazio(xalias)
					sele &xalias
				endif		
				
																
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE




*!*	select convert(int,0) as dias_entre,a.ordem_servico,
*!*	status_os.anm_status_almox as status_os,status_os.timestamp as data_mov_os
*!*	from producao_ordem_servico a 
*!*	join anm_status_os_mov status_os
*!*	on a.ordem_servico=status_os.ordem_servico
*!*	where a.ordem_servico in 
*!*	('037277')
*!*	union all
*!*	select convert(int,0) as dias_entre,a.ordem_servico,
*!*	status_sai_mat.anm_status_almox as status_sai_mat,status_sai_mat.timestamp as data_mov_os
*!*	from producao_ordem_servico a 
*!*	join 
*!*		(select b.ordem_servico,a.* from anm_status_sai_mat_mov a 
*!*		join estoque_sai_mat b 
*!*		on  a.req_material=b.req_material	
*!*		and a.filial=b.filial) status_sai_mat
*!*	on a.ordem_servico=status_sai_mat.ordem_servico 
*!*	where a.ordem_servico in 
*!*	('037277')

**************************************************
*-- Class:        lb_data_coletado (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_data_coletado AS lx_label


	Caption = ""
	Height = 15
	Left = 360
	Top = 100
	Width = 20
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	Name = "lb_data_coletado"
	Visible = .t.
	Anchor = 0
	Fontbold=.t.


ENDDEFINE
*
*-- EndDefine: lb_data_coletado 
**************************************************


**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_status_entrada AS lx_label


	Caption = "Status Saida"
	Height = 15
	Left = 60
	Top = 100
	Width = 22
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	Name = "lb_status_entrada"
	Visible = .t.
	Anchor = 0
	Fontbold=.t.

	PROCEDURE DblClick	
		

		If thisformset.p_tool_status="P" and (v_estoque_sai_mat_00.anm_status_almox <>"2-COLETADO" or f_vazio(v_estoque_sai_mat_00.anm_status_almox))  
			if messagebox("Deseja Alterar o Status da Saida de Material?",4+32+256,"Atenção!")=6	
				thisformset.lx_form1.cmb_status_entrada.enabled=.T.
			endif	
		Endif

	ENDPROC 

ENDDEFINE
*
*-- EndDefine: lb_status_entrada 
**************************************************



**************************************************
*-- Class:        cmb_status_entrada (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_status_entrada AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 103
	TabIndex = 1
	Top = 96
	Width = 147
	ZOrderSet = 5
	Name = "cmb_status_entrada"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

	PROCEDURE Valid	
	
	IF THISFORMSET.P_TOOL_STATUS="P"

		If v_estoque_sai_mat_00.anm_status_almox="2-COLETADO" 
			
			*text to xselUser noshow textmerge	
			*	SELECT * FROM PROPRIEDADE_VALIDA 
			*	WHERE PROPRIEDADE='00058' 
			*	AND LTRIM(RTRIM(VALOR_PROPRIEDADE))= '<<WUSUARIO>>'
			*endtext	
			
			*f_select(xselUser,"curUserFimOs",alias())
			
			*if f_vazio(curUserFimOs.valor_propriedade)
			*	messagebox("Você Não tem Permissão para Marcar esta OS como Recebido no Almoxarifado",48,"Atenção!!!")
			*	retu .f.	
			*endif	
			
			if messagebox("Deseja Marcar esta Saida como Coletada?",4+32+256,"Atenção!")=6	


				xreq_material=v_estoque_sai_mat_00.req_material
				xfilial      =v_estoque_sai_mat_00.filial
				*REQ_MATERIAL,FILIAL,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

					UPDATE ESTOQUE_SAI_MAT SET ANM_STATUS_ALMOX='2-COLETADO'	
					WHERE req_material='<<xreq_material>>'  
					and   filial='<<xfilial>>'
				
					INSERT INTO ANM_STATUS_SAI_MAT_MOV
					(REQ_MATERIAL,FILIAL,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP)
					SELECT 
					'<<xreq_material>>','<<xfilial>>',
					'<<v_estoque_sai_mat_00.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>','<<WUSUARIO>>','<<SYSTEM.NetUserName>>',
					'<<SYSTEM.NetComputerName>>',(SELECT GETDATE())
					where '<<xreq_material>>'+'<<xfilial>>'+'<<v_estoque_sai_mat_00.ANM_STATUS_ALMOX>>' 
					not in 
					(select  req_material+filial+anm_status_ALMOX
					 from ANM_STATUS_SAI_MAT_MOV)	

				endtext


				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status da Saida de Material",48,"Atenção_8!")
					retu .f.
				endif

				o_toolbar.Botao_refresh.Click()

			endif
						
		
		Else
		
			
			if messagebox("Deseja Alterar o Status desta Saida de Material para "+chr(13)+allt(v_estoque_sai_mat_00.anm_status_almox)+" ?",4+32+256,"Atenção!")=6
			

				xreq_material=v_estoque_sai_mat_00.req_material
				xfilial      =v_estoque_sai_mat_00.filial
				*REQ_MATERIAL,FILIAL,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

					UPDATE ESTOQUE_SAI_MAT SET ANM_STATUS_ALMOX='<<v_estoque_sai_mat_00.anm_status_almox>>'
					WHERE req_material='<<xreq_material>>'  
					and   filial='<<xfilial>>'
									
					INSERT INTO ANM_STATUS_SAI_MAT_MOV
					(REQ_MATERIAL,FILIAL,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP)
					SELECT 
					'<<xreq_material>>','<<xfilial>>',
					'<<v_estoque_sai_mat_00.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>','<<WUSUARIO>>','<<SYSTEM.NetUserName>>',
					'<<SYSTEM.NetComputerName>>',(SELECT GETDATE())
					where '<<xreq_material>>'+'<<xfilial>>'+'<<v_estoque_sai_mat_00.ANM_STATUS_ALMOX>>' 
					not in 
					(select  req_material+filial+anm_status_ALMOX
					 from ANM_STATUS_SAI_MAT_MOV)	

				endtext	
				
				
				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status da Saida de Material",48,"Atenção_8!")
					retu .f.
				endif

				o_toolbar.Botao_refresh.Click()
							
			endif	
	
		Endif	
	
	ENDIF 
	
	ENDPROC 
	
	



ENDDEFINE

*
*-- EndDefine: cmb_status_entrada
**************************************************



**************************************************
*-- Class:        lb_data_coletado (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_Prod_PA AS lx_label


	Caption = ""
	*Height = 15
	Left = 130
	Top = 41
	*Width = 20
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	FontSize = 15
	Name = "lb_Prod_PA"
	Visible = .t.
	Anchor = 0
	Fontbold=.t.


ENDDEFINE
*
*-- EndDefine: lb_data_coletado 
**************************************************

* Sintese Soluções - Tiago Carvalho - CRIADO OBJETO PARA IMPRIMIR ETIQUETA DE LOCALIZAÇÃO DE MATÉRIA PRIMA
DEFINE CLASS bt_etiqueta_peca AS commandbutton
	Height = 25
	Width = 85
	FontBold = .F.
	FontName = "Arial"
	FontSize = 8
    Caption = "Etiqueta"
	Name = "bt_etiqueta_peca"
	autosize = .T.
	visible = .T.
	enabled = .T.
		
	PROCEDURE Click
		IF !(THISFORMSET.P_TOOL_STATUS == "P")
			MESSAGEBOX("Etiqueta só dispoível em modo de pesquisa!",0+64,"Obj-Etiqueta Somente Pesquisa")
		else
			nAntArea = select()
			
			** Consulta Saldo do Estoque*
			lcPeca 			= V_ESTOQUE_SAI_MAT_00_PECAS.peca
			lcPartida 		= V_ESTOQUE_SAI_MAT_00_PECAS.partida
			lcQtdeSaida 	= V_ESTOQUE_SAI_MAT_00_PECAS.qtde - V_ESTOQUE_SAI_MAT_00_PECAS.PERDA
			lcMaterial 		= V_ESTOQUE_SAI_MAT_00_PECAS.material
			lcCorMaterial 	= V_ESTOQUE_SAI_MAT_00_PECAS.cor_material
			lcFilial 		= V_ESTOQUE_SAI_MAT_00_PECAS.FILIAL
								
			TEXT TO lcSql TEXTMERGE noshow
				SELECT 	A.MATERIAL,
						B.DESC_MATERIAL,
						A.PECA,
						A.LOCALIZACAO,
						B.DESC_COMPOSICAO,
						B.UNID_ESTOQUE,
						A.LARGURA,
						A.COR_MATERIAL,
						B.COLECAO,
						C.DESC_COR_MATERIAL,
						B.FABRICANTE,
						A.QTDE,
						A.PARTIDA,
						RECEITA = ISNULL(A.RECEITA,'')
					FROM ESTOQUE_MAT_PECA A(nolock)
					INNER JOIN MATERIAIS B(nolock)
						ON A.MATERIAL = B.MATERIAL 
					INNER JOIN MATERIAIS_CORES C(nolock)
						ON A.MATERIAL = C.MATERIAL AND A.COR_MATERIAL = C.COR_MATERIAL 
					WHERE A.MATERIAL=?lcMaterial 
						AND A.COR_MATERIAL = ?lcCorMaterial 
						AND A.PECA = ?lcPeca 
						AND A.PARTIDA = ?lcPartida 
						AND A.FILIAL = 'DEPOSITO RBX'
			ENDTEXT
			
			IF !f_select (lcSql,"CurTmpEstoquePeca")
				MESSAGEBOX("Erro ao consultar o estoque da peça, Tente novamente!",0+16,"Obj-Erro Consulta")
				RETURN .f.
			ENDIF
			
			IF RECCOUNT("CurTmpEstoquePeca") > 0
				
				* 19/12/2013 - Síntese Soluções - Tiago Carvalho - Alterado para o padrão Sintese Etiquetas
				strPeca 			= ALLTRIM(CurTmpEstoquePeca.PECA)
				strQtde 			= ALLTRIM(str(CurTmpEstoquePeca.QTDE, 7,3))
				strUnidEstoque 		= ALLTRIM(CurTmpEstoquePeca.unid_estoque)
				strLargura 			= ALLTRIM(str(CurTmpEstoquePeca.LARGURA,6,2))
				strPartida			= ALLTRIM(CurTmpEstoquePeca.PARTIDA)
				strLocalizacao 		= ALLTRIM(CurTmpEstoquePeca.localizacao)
				strFabricante 		= ALLTRIM(CurTmpEstoquePeca.fabricante)
				strMaterial 		= ALLTRIM(CurTmpEstoquePeca.material)
				strDescMaterial 	= ALLTRIM(CurTmpEstoquePeca.DESC_MATERIAL)
				strDescComposicao 	= allt(CurTmpEstoquePeca.Desc_Composicao)
				strCor 				= ALLTRIM(CurTmpEstoquePeca.cor_material)
				strDescCor 			= ALLTRIM(CurTmpEstoquePeca.desc_cor_material)
				strQtdeSaida     	= ALLTRIM(str(lcQtdeSaida, 7,3))
				strNFEntrada		=""
				strFornecedor		=""
				strColecao			= ALLTRIM(CurTmpEstoquePeca.COLECAO)
				strPecaTemp			=ALLTRIM(CurTmpEstoquePeca.RECEITA)
				strSaida			= V_ESTOQUE_SAI_MAT_00.REQ_MATERIAL
							
				wait wind 'IMPRIMINDO ETIQUETAS...' nowait

				strProc = SET("Procedure")

				Set procedure To \Linx\Report\User\Proc_SS_Etiquetas.prg Additive

				IF !DIRECTORY('C:\SINTESE\ETIQUETA')
					MD('C:\SINTESE\ETIQUETA')
				ENDIF

				IF FILE ('C:\SINTESE\ETIQUETA\PECAMP.ETQ')
					DELETE FILE 'C:\SINTESE\ETIQUETA\PECAMP.ETQ'
				ENDIF
					
				* 19/12/2013 - Síntese Soluções - Tiago Carvalho - Criado o PRG para centralizar as etiquetas facilitando o manutenção
				* ETIQUETA TERMICA DE PEÇAS DE SAÍDA - ARGOX
				intArq = fCreate('C:\SINTESE\ETIQUETA\PECAMPSAIDA.ETQ', 0)
				if (intArq >= 0)
					fwrite(intArq, Proc_Etiqueta_Peca(strPeca, strQtdeSaida, strUnidEstoque, strLargura, strPartida, strLocalizacao, strFabricante, strMaterial, strDescMaterial, strDescComposicao, strCor, strDescCor,strNFEntrada,strFornecedor,strColecao,strPecaTemp,strSaida))
					fClose(intArq)
					!COPY C:\SINTESE\ETIQUETA\PECAMPSAIDA.ETQ LPT1
				ENDIF
				wait wind 'IMPRESSÃO CONCLUIDA.' nowait
				
				* ETIQUETA TERMICA DE PEÇAS DE ESTOQUE - ARGOX
				IF CurTmpEstoquePeca.QTDE > 0 
					intArq = fCreate('C:\SINTESE\ETIQUETA\PECAMP.ETQ', 0)
					if (intArq >= 0)
						fwrite(intArq, Proc_Etiqueta_Peca(strPeca, strQtde , strUnidEstoque, strLargura, strPartida, strLocalizacao, strFabricante, strMaterial, strDescMaterial, strDescComposicao, strCor, strDescCor,strNFEntrada,strFornecedor,strColecao,strPecaTemp,'RETORNO'))
						fClose(intArq)
						!COPY C:\SINTESE\ETIQUETA\PECAMP.ETQ LPT1
					ENDIF
					wait wind 'IMPRESSÃO CONCLUIDA.' nowait
				endif
				SET PROCEDURE TO &strProc
			ENDIF
			SELECT (nAntArea)
		endif
	EndProc
EndDefine
