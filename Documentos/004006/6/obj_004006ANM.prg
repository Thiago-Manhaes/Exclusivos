* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Campos Adicionais Ordens de Servico	/ Seleciona somente materiais da fase corrente					                    *
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
		*	USR_SAVE_BEFORE   -> Return .f. Para o Metodo 			=> SALVAR ANTES DE JOGAR INFORMACOES NO BANCO
		*	USR_SAVE_AFTER                                          => APOS SALVAR AS INFORMACOES    NO BANCO
		*	USR_ITENs_DELETE_BEFORE -> Return .f. Para o Metodo 		=> ANTES DE EXCLUIR ITEN NA TABELA FILHA '+'
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

		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj))

			do case

			case upper(xmetodo) == 'USR_INIT'	
				Public xOldStatusAlmox, xProdPed, xmsgpedido, xmostra, xFilialMatCons, xProduto   
				xmostra = 0
				xMsgPedido = ''
				xProduto = ''
				*xalias=alias()		
						
			 *Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_os_01   
				sele V_COMPRAS_01   
				xalias_pai=alias()
								
  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("COMPRAS.ANM_STATUS_ALMOX", "C(25)",.T., "ANM_STATUS_ALMOX", "COMPRAS.ANM_STATUS_ALMOX")
				oCur.addbufferfield("COMPRAS.ANM_DATA_INICIO_SEPARACAO", "D",.T., "ANM_DATA_INICIO_SEPARACAO", "COMPRAS.ANM_DATA_INICIO_SEPARACAO")		
				oCur.addbufferfield("COMPRAS.ANM_FILIAL_MATERIAL", "C(25)",.T., "ANM_FILIAL_MATERIAL", "COMPRAS.ANM_FILIAL_MATERIAL")		
				oCur.addbufferfield("SPACE(70) AS PROG_PRIORIDADE","C(70)",.T.,"PROG_PRIORIDADE","PROG_PRIORIDADE")
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 


			 *Inicio Inclusao Campos Novos de Produtos no Cursor Filha-- v_producao_os_02_materiais   
				sele V_Compras_01_Reservas   
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				*oCur.addbufferfield("SPACE(25) AS ANM_RESERVA_ALMOX" , "C(25)",.T., "ANM_RESERVA_ALMOX", "ANM_RESERVA_ALMOX")
				oCur.addbufferfield("0 AS ANM_RESERVA_ALMOX" , "I",.T., "ANM_RESERVA_ALMOX", "ANM_RESERVA_ALMOX")
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Filha
			
			 * Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
			 		Bindevent(thisformset.lx_form1.lx_pageframe1.page7, "Activate", This, "AnmBuscaSeparaAlmox", 1)


*!*					

				Thisformset.L_limpa()
				o_toolbar.Botao_limpa.Click()  


				f_select("select colecao from colecoes order by colecao","xcolecao",ALIAS())
				f_select("select griffe from produtos_griffes order by griffe","xgriffe",ALIAS())
				
				TEXT TO xSelPropProg TEXTMERGE NOSHOW
					SELECT case when VALOR_PROPRIEDADE = 'MOSTRUARIO' THEN '1-MOSTRUARIO'
						 when VALOR_PROPRIEDADE = 'VAREJO'     THEN '2-VAREJO'
						 when VALOR_PROPRIEDADE = 'ATACADO'    THEN '3-ATACADO'
					else '4-'+LTRIM(VALOR_PROPRIEDADE) END AS 'PROG_PRIORIDADE'
					FROM PROPRIEDADE_VALIDA WHERE PROPRIEDADE = '00038'
					ORDER BY case when VALOR_PROPRIEDADE = 'MOSTRUARIO' THEN '1-MOSTRUARIO'
						 when VALOR_PROPRIEDADE = 'VAREJO'     THEN '2-VAREJO'
						 when VALOR_PROPRIEDADE = 'ATACADO'    THEN '3-ATACADO'
					else '4-'+LTRIM(VALOR_PROPRIEDADE) END
				ENDTEXT
				f_select(xSelPropProg,"xprogPrioridade",ALIAS())
				
				public xstatus_entrada,xordem_servico,curSepara
				
				f_select("select convert(varchar(25),valor_propriedade) as anm_status_almox from propriedade_valida where propriedade='00057'","xstatus_entrada")
				
				f_select("select distinct filial from filiais where CTRL_PRODUCAO_MATERIAL = 1","xstatus_filial_mat")
				text to xselSepara noshow textmerge	
					select 1 as cod_separacao_almox,convert(varchar(25),'SEPARA') as desc_separacao_almox
					union all
					select 2 as cod_separacao_almox,convert(varchar(25),'NÃO SEPARA') as desc_separacao_almox	
				endtext	
				
				f_select(xselSepara,"curSepara",alias() )
				
				store '' to	xordem_servico

				with thisformset.lx_form1.lx_pageframe1.page7	
					.addobject("lb_status_entrada","lb_status_entrada")
					.addobject("cmb_status_entrada","cmb_status_entrada")	
					.addobject("lb_status_filial_mat","lb_status_filial_mat")
					.addobject("cmb_filial_mat","cmb_filial_mat")				
					.addobject("tx_data_ini_separacao","tx_data_ini_separacao")					
					.addobject("lb_data_ini_separacao","lb_data_ini_separacao")
					.addobject("bt_salvar","bt_salvar")
					.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.RemoveObject("tx_FATOR_CONVERSAO")
					.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.addobject("cmb_separa_almox","cmb_separa_almox")						
				endwith		
			
				with thisformset.lx_form1.lx_pageframe1
					.page7.cmb_status_entrada.RowSource="xstatus_entrada"
					.page7.cmb_status_entrada.ControlSource="v_compras_01.ANM_STATUS_ALMOX" 
					.page7.cmb_filial_mat.RowSource="xstatus_filial_mat"
					.page7.cmb_filial_mat.ControlSource="v_compras_01.ANM_FILIAL_MATERIAL"
					.page7.tx_data_ini_separacao.ControlSource="v_compras_01.ANM_DATA_INICIO_SEPARACAO" 
					.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.cmb_separa_almox.RowSource="curSepara.desc_separacao_almox,cod_separacao_almox"
					.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.cmb_separa_almox.RowSourceType= 2
					.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.controlsource="v_compras_01_reservas.ANM_RESERVA_ALMOX"
					.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Enabled= .F.
					.page5.addobject("bt_altera_obs","bt_altera_obs")
					.page9.addobject("bt_gera_op_acab","bt_gera_op_acab")
				endwith	
				
				thisformset.lx_form1.lx_pageframe1.page1.ck_CTRL_MULT_ENTREGAS.Visible=.f.		
						
				if !f_vazio(xalias_pai)
					sele &xalias_pai
				endif	
				
				case upper(xmetodo) == 'USR_ALTER_BEFORE' 
					** toda vez que clicava em alterar ficava em branco dessa forma consigo fazer o replace									 
					xFilialMatCons = v_compras_01.anm_filial_material
					
					*** #1 - LUCAS MIRANDA - 04/05/2016 - CORREÇÃO AO PERGUNTAR SE DESEJA INSER. ROTA ACABAB
					xProduto = v_compras_01_produtos.produto
					*** #1 - LUCAS MIRANDA - 04/05/2016 - CORREÇÃO AO PERGUNTAR SE DESEJA INSER. ROTA ACABAB
				case upper(xmetodo) == 'USR_ALTER_AFTER' 
					*** #6 - LUCAS MIRANDA - 10/06/2016 - CRIACAO PARAMETRO PARA LIBERAR CAMPO ENTREGA				 	
					IF DTOC(v_compras_01_produtos.entrega,1) = '19600101' or thisformset.pp_anm_permit_alt_entrega = .t.
						thisformset.lx_form1.lx_pageframe1.page1.tx_ENTREGA_UNICA.Enabled=.t.
					ELSE
				 		thisformset.lx_form1.lx_pageframe1.page1.tx_ENTREGA_UNICA.Enabled=.f.
				 	ENDIF
						
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE'	
					
*!*						if thisformset.p_tool_status = 'A'
*!*								
*!*								f_select("SELECT * FROM W_FILIAIS (nolock) WHERE INATIVO = 0 AND FILIAL = ?V_COMPRAS_01.FILIAL_A_ENTREGAR","xCurTempFilial")
*!*								LOCATE FOR ctrl_producao_produto = .t.
*!*								IF ! found()
*!*									MESSAGEBOX("Filial ("+ALLTRIM(V_COMPRAS_01.FILIAL_A_ENTREGAR)+") não permite efetuar compra.",64)
*!*									RETURN .f.
*!*								endif	
*!*								USE IN xCurTempFilial					
*!*						
*!*						endif
					
					
					if thisformset.p_tool_status $ 'IA'	
							
						
						 
*!*							if thisformset.p_tool_status == 'A'						
*!*								SELE V_COMPRAS_01	
*!*									IF F_VAZIO(V_COMPRAS_01.ANM_FILIAL_MATERIAL)
*!*										MESSAGEBOX("Favor Colocar a Filial de Material!!!",0+48)
*!*										RETURN .f.
*!*									ENDIF	
*!*							Endif
						sele curpropcompras
						LOCATE FOR propriedade = '00226'
						IF f_vazio(curpropcompras.valor_propriedade) and v_compras_01.tipo_compra='CONSERTO PA' 
							MESSAGEBOX("Se é um pedido de conserto, favor informar o Pedido de Compra Origem !","PEDIDO DE CONSERTO",0+64)
							Return .f.
						ENDIF	
				Endif	
				
				if thisformset.p_tool_status == 'A'
					If f_vazio(v_compras_01.anm_filial_material)

								Sele V_Compras_01
								replace v_compras_01.anm_filial_material with xFilialMatCons
								Thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.Value = xFilialMatCons
								
					Endif
				Endif	
				case upper(xmetodo) == 'USR_SAVE_AFTER'				
				
					*Lparameters cData
				
					F_SELECT("SELECT PROPRIEDADE FROM PROP_COMPRAS WHERE PEDIDO = ?v_compras_01.pedido  AND PROPRIEDADE in ('00211')","xProp012")
					F_SELECT("SELECT PROPRIEDADE, VALOR_PROPRIEDADE FROM PROP_COMPRAS WHERE PEDIDO = ?v_compras_01.pedido  AND PROPRIEDADE in ('00222')","xProp013")

					IF !F_VAZIO(xProp012.propriedade='00211') AND F_VAZIO(xProp013.propriedade='00222')
						IF MESSAGEBOX('Propriedades CHECKLIST STATUS pendente. Verifique! Se Sim será "Aprovado", se Não "Reprovado"',3+32,"Atenção")=6
						xordem_servico1=v_compras_01.pedido
				
							text to	xinsert2 noshow textmerge	

								INSERT INTO PROP_COMPRAS
								(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, PEDIDO)
								SELECT 
								'00229','1','APROVADO','<<DTOS(WDATA)>>','<<xordem_servico1>>'
							endtext

					if !f_insert(xinsert2) 
					messagebox("Não foi possível Alterar o Status do Pedido de Compra",48,"Atenção_8!")
					retu .f.
					endif
			ELSE
						xordem_servico1=v_compras_01.pedido
				
						 text to xinsert2 noshow textmerge	

							INSERT INTO PROP_COMPRAS
							(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, PEDIDO)
							SELECT 
							'00229','1','REPROVADO','<<DTOS(WDATA)>>','<<xordem_servico1>>'
						 endtext

					if !f_insert(xinsert2) 
						messagebox("Não foi possível Alterar o Status do Pedido de Compra",48,"Atenção_8!")
						retu .f.
					endif
			endif
ENDIF 			
				
				IF F_VAZIO(xProp012.propriedade='00211') AND (!F_VAZIO(xProp013.propriedade='00222') AND xProp013.valor_propriedade <> 'PENDENTE')
	*SET STEP ON			
						IF MESSAGEBOX('Propriedades DATA CHECKLIST pendente. Informe a data!',0+16,"Atenção")=1
							DO FORM wdir+'Linx\Exclusivos\inputboxdatepa.scx'
							
							xordem_servico1=v_compras_01.pedido

						ENDIF				
				ENDIF
				
				
				sele v_compras_01
				f_update("EXEC DBO.LX_ANM_COMPRA_SAVE_AFTER ?v_compras_01.pedido, ?o_004006.p_tool_status")
			*#5 - DATA ENTREGA, LIMITE ENTREGA RETRABALHO TI - 01/06/2016  LUCAS MIRANDA*	
				If thisformset.p_tool_status = 'I' and v_compras_01.tipo_compra!='CONSERTO PA' 
					
					TEXT TO xUpdateData NOSHOW TEXTMERGE
						UPDATE A SET ENTREGA = '19600101', LIMITE_ENTREGA = '19600101'
						FROM COMPRAS_PRODUTO (NOLOCK) A  
						JOIN COMPRAS (NOLOCK) B
						ON A.PEDIDO = B.PEDIDO
						AND B.TABELA_FILHA = 'COMPRAS_PRODUTO'	
						AND B.TIPO_COMPRA NOT LIKE '%CONSERTO%'
						WHERE A.PEDIDO = '<<v_compras_01.PEDIDO>>' 
					ENDTEXT
					
					f_update(xUpdateData)					
				Endif
			*#5 - DATA ENTREGA, LIMITE ENTREGA RETRABALHO TI - 01/06/2016 LUCAS MIRANDA*	
				xMsgPedido = xMsgPedido + allt(v_compras_01.pedido)+chr(13)

				* #1 - LUCAS MIRANDA - 05/04/2016 - CORREÇÃO AO PERGUNTAR SE DESEJA INSER. ROTA ACABAB 	
				If thisformset.p_tool_status = 'A'
					Sele Curpropcompras
								LOCATE FOR propriedade = '00236'
								
									If F_Vazio(Curpropcompras.valor_propriedade) and v_compras_01.tipo_compra <> 'CONSERTO PA'
			
										TEXT TO xRotaConserto NOSHOW TEXTMERGE
											SELECT B.ROTA_CONSERTO,  A.TABELA_OPERACOES 
											FROM PRODUTOS A
											JOIN PRODUTOS_TAB_OPERACOES B
											ON A.TABELA_OPERACOES = B.TABELA_OPERACOES
											WHERE PRODUTO ='<<xProduto>>'
										ENDTEXT
										f_select(xRotaConserto,"curRotaConserto",ALIAS())
										 
										If curRotaConserto.rota_conserto = .T.
											If MESSAGEBOX("Esse produto tem rota de acabamento, deseja incluir ?",4+32) = 6
												text to xinsertRota noshow textmerge	
													INSERT INTO PROP_COMPRAS
													(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, PEDIDO)
													SELECT 
													'00236','1','<<curRotaConserto.Tabela_Operacoes>>','<<DTOS(WDATA)>>','<<v_compras_01.pedido>>'
												endtext
												
												if !f_insert(xinsertRota) 
													messagebox("Não foi possível Inserir a Rota de Acabamento !",48,"Atenção_8!")
													retu .f.
												endif	
												
												xProduto = ''
												
												Thisformset.lx_form1.lx_pageframe1.page_PROPS.l_desenhista_recalculo()
											Endif	
										Endif
									Endif	
					Endif
					* FIM - #1 - LUCAS MIRANDA - 05/04/2016 - CORREÇÃO AO PERGUNTAR SE DESEJA INSER. ROTA ACABAB
				case upper(xmetodo) == 'USR_CLEAN_AFTER'
					xalias=alias()
					*Public xmsgpedido, xmostra
					
						sele producao_programa
						if RECCOUNT()>0
							sele producao_programa
							DELETE ALL
						endif
						
						IF type("xmostra")<>"U" AND TYPE("xMsgPedido") <>"U"
							if xmostra = 1  and !f_vazio(xMsgPedido)
								messagebox('Pedidos Gerados:'+chr(13)+xMsgPedido)
								xmostra = 0
								xMsgPedido = ''
							endif	
						ENDIF
					
					if !f_vazio(xalias)
						sele &xalias
					endif	
				case upper(xmetodo) == 'USR_VALID'					
					xalias=alias()
						If thisformset.p_tool_status $ 'IA' 
									
						  IF UPPER(xnome_obj)=='CMB_FILIAL_A_ENTREGAR'
						 	
						 	sele v_compras_01
						 	f_select("SELECT * FROM W_FILIAIS (nolock) WHERE INATIVO = 0 and filial = ?v_compras_01.filial_a_entregar","xCurTempFilialEnt")
							if xCurTempFilialEnt.ctrl_producao_produto = .F.
								MESSAGEBOX("Filial não está habilitada para emitir Pedido de Compra de PA !",0+16)
								
								thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_A_ENTREGAR.value = ''
								thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_COBRANCA.value = ''
								thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_A_FATURAR.value = ''
								return .F.
							endif

						 	sele v_compras_01
							replace filial_a_entregar with thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_A_ENTREGAR.value
							replace filial_cobranca WITH thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_A_ENTREGAR.value
							replace filial_a_faturar WITH thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_A_ENTREGAR.value

							thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_A_ENTREGAR.value = v_compras_01.filial_a_entregar
							thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_COBRANCA.value = v_compras_01.filial_a_entregar
							thisformset.lx_form1.lx_pageframe1.page1.cmb_FILIAL_A_FATURAR.value = v_compras_01.filial_a_entregar

							sele v_compras_01
							f_select("select * from W_CTB_RATEIO_FILIAIS where filial = ?v_compras_01.filial_a_entregar and (DESC_RATEIO_FILIAL not like 'ratei%ger%pel%' and rateio_filial not like 'f%')","xRateio")
							SELE xRateio

							if f_vazio(xRateio.cod_filial)
								MESSAGEBOX("Rateio Filial Não Encontrado, Favor Inserir Manualmente !",0+16)
							else 
								sele v_compras_01
								replace v_compras_01.rateio_filial with xRateio.rateio_filial
								replace v_compras_01.desc_rateio_filial with xRateio.desc_rateio_filial
							endif	

							thisformset.lx_FORM1.lx_pageframe1.page1.tv_raTEIO_FILIAL.Value = v_compras_01.rateio_filial
							thisformset.lx_FORM1.lx_pageframe1.page1.tx_deSC_RATEIO_FILIAL.Value = v_compras_01.desc_rateio_filial
						  ENDIF
						 Endif 
							
						 IF thisformset.p_tool_status=='L'	
						 
						 	IF UPPER(xnome_obj)=='LX_PROGRAMACAO'
						 
							 	xProg = LTRIM(RTRIM(Thisformset.lx_form1.lx_pageframe1.page14.LX_PROGRAMACAO.Value))

								text to XSEL noshow textmerge	 
										SELECT VALOR_PROPRIEDADE as TIPO_COMPRA
										FROM PROP_PRODUCAO_PROGRAMA 
										WHERE PROPRIEDADE = '00038'
										AND PROGRAMACAO = '<<xProg>>'					
								endtext	 				

								f_select(xsel,'curProg')

								If reccount()>0
									Thisformset.lx_form1.lx_pageframe1.page14.cmb_TIPO_COMPRA.Value = curProg.tipo_compra
								Endif	 
							Endif	
						 ENDIF
												
						
					if !f_vazio(xalias)
						sele &xalias
					endif
				case upper(xmetodo) == 'USR_WHEN'					
					xalias=alias()
						IF UPPER(xnome_obj)=='BOTAO1'	 
							If  thisformset.lx_FORM1.lx_pageframe1.page4.cn_Obs_Item.Visible == .F.
									thisformset.lx_form1.lx_pageframe1.page4.lx_shape1.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.shape1.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.lx_pack_1.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.ck_packs.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.lx_cbPacksCor.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.lx_sortimento.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.lx_label6.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.lx_label8.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.lx_label13.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.label_CUSTO1.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.label_CUSTO2.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.label_CUSTO3.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.label_CUSTO4.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.tx_CUSTO1.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.tx_CUSTO2.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.tx_CUSTO3.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.tx_CUSTO4.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.label_IPI_B.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.label_DESCONTO_ITEM.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.label_QTDE_ORIGINAL.visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.label_vaLOR_ORIGINAL.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.tx_IPI_B.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.tx_descONTO_ITEM.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.tx_qtDE_ORIGINAL.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.tx_valOR_ORIGINAL.Visible=.T.
									thisformset.lx_form1.lx_pageframe1.page4.lx_textbox_base1.Visible=.T.
							Else
									thisformset.lx_form1.lx_pageframe1.page4.lx_shape1.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.shape1.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.lx_pack_1.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.ck_packs.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.lx_cbPacksCor.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.lx_sortimento.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.lx_label6.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.lx_label8.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.lx_label13.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.label_CUSTO1.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.label_CUSTO2.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.label_CUSTO3.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.label_CUSTO4.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.tx_CUSTO1.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.tx_CUSTO2.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.tx_CUSTO3.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.tx_CUSTO4.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.label_IPI_B.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.label_DESCONTO_ITEM.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.label_QTDE_ORIGINAL.visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.label_vaLOR_ORIGINAL.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.tx_IPI_B.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.tx_descONTO_ITEM.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.tx_qtDE_ORIGINAL.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.tx_valOR_ORIGINAL.Visible=.f.
									thisformset.lx_form1.lx_pageframe1.page4.lx_textbox_base1.Visible=.f.
							Endif	
						Endif	
						
						IF UPPER(xnome_obj)=='BOTAO2'	
							if !f_vazio(v_compras_01.programacao)
								f_select("select filial from PRODUCAO_PROGRAMA (nolock) where PROGRAMACAO = ?v_compras_01.programacao","xVerifFilialProg")
								f_select("SELECT * FROM W_FILIAIS (nolock) WHERE INATIVO = 0","xCurTempFilial")
								LOCATE FOR filial = xVerifFilialProg.filial AND ctrl_producao_produto = .t.
								IF ! found()
									MESSAGEBOX("Filial ("+ALLTRIM(xVerifFilialProg.filial)+") da programação"+CHR(13)+"não permite efetuar compra.",64)
									RETURN .f.
								endif	
								USE IN xVerifFilialProg
								USE IN xCurTempFilial
								
								xProdPed = o_004006.lx_form1.lx_pageframe1.page14.lx_proximo_Pedido.value 
								xmostra = 1 
								xmsgpedido = ''
							endif	
						ENDIF
						
						
						IF thisformset.p_tool_status=='A'  
							if v_compras_01_reservas.consumida > 0 AND (UPPER(xnome_obj)=='TV_MATERIAL' OR UPPER(xnome_obj)=='TV_COR_MATERIAL')
								return .f.
							endif
						ENDIF				
					if !f_vazio(xalias)
						sele &xalias
					endif
					
					CASE UPPER(xmetodo)=='USR_SEARCH_BEFORE'
					SELECT V_COMPRAS_01
		          	REPLACE ANM_FILIAL_MATERIAL WITH thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.value
		          		 
				    thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled=.f.
					
					case upper(xmetodo) == 'USR_SEARCH_AFTER'
								
							thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.visible = .T.
							thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled=.f.	
					
					case upper(xmetodo) == 'USR_REFRESH'
					
						 
						if type("thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada")<>"U"
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada.Alignment   = 0
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada.left =360
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada.top =43
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada.Anchor=0	
							
							if thisformset.p_tool_status = "I" or thisformset.p_tool_status = "L" 
								thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.T.
								thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled=.T.
							else	
								thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.F.	
								thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled=.F.
							endif		
							
							thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.cmb_separa_almox.enabled=.t.
							
							if thisformset.p_tool_status $'IA'
								thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada.visible = .F.
								thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.visible = .F.	
								thisformset.lx_form1.lx_pageframe1.page7.bt_salvar.visible = .F.
								thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.visible =.T.
								thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled =.T.
								thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.visible = .F.
								*thisformset.lx_form1.lx_pageframe1.page7.lb_status_filial_mat.visible = .F.	
								*thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.visible =.F.
								*thisformset.lx_form1.bt_salvar.visible = .f.
								
							else
								thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada.visible = .T.
								thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.visible = .T.
								thisformset.lx_form1.lx_pageframe1.page7.bt_salvar.visible = .T.
								*thisformset.lx_form1.lx_pageframe1.page7.lb_status_filial_mat.visible = .T.	
								*thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.visible =.T.
								*thisformset.lx_form1.bt_salvar.visible = .t.
							endif	
																	
						endif	
						
						if type("thisformset.lx_form1.lx_pageframe1.page7.tx_data_ini_separacao")<>"U"
							
							if	thisformset.p_tool_status='L'
								thisformset.lx_form1.lx_pageframe1.page7.tx_data_ini_separacao.enabled=.t.
							else	
								thisformset.lx_form1.lx_pageframe1.page7.tx_data_ini_separacao.enabled=.f.								
							endif
							
						endif
					
						if type("thisformset.lx_form1.lx_pageframe1.page7.lb_status_filial_mat")<>"U"
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_filial_mat.Alignment   = 0
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_filial_mat.left =367
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_filial_mat.top =67
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_filial_mat.Anchor=0	
						endif

						IF type("thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs") <> "U"
							*thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.visible = .F.
							thisformset.lx_form1.lx_pageframe1.page5.bt_altera_obs.Left=70
							thisformset.lx_form1.lx_pageframe1.page5.bt_altera_obs.Top=4  	
						ENDIF	
						
						IF type("thisformset.lx_form1.lx_pageframe1.page7.bt_salvar") <> "U"
							thisformset.lx_form1.lx_pageframe1.page7.bt_salvar.visible = .F.
						ENDIF


					case upper(xmetodo) == 'USR_INCLUDE_AFTER'
					
						If thisformset.pp_tipo_compra_default = 'CONSERTO PA'
							thisformset.lx_form1.lx_pageframe1.page1.tv_TIPO_COMPRA.Enabled=.f.
						ENDIF
							thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada.visible = .f.
							thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.visible = .F.	
							thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.visible =.T.
							thisformset.lx_form1.lx_pageframe1.page7.tx_data_ini_separacao.enabled = .F.

					case upper(xmetodo) == 'USR_ALTER_BEFORE'	
				
						xalias=alias()
						If v_compras_01.tipo_compra <> 'CONSERTO PA' AND thisformset.pp_tipo_compra_default = 'CONSERTO PA'
							MESSAGEBOX("Não tem permissão para alterar o Pedido !",0+16)
							Return .F.
						ENDIF
						
*!*							IF v_compras_01.status_aprovacao='R'
*!*								MESSAGEBOX("Pedido Já Foi Cancelado !!!",0+16)
*!*								RETURN .F.
*!*							ENDIF
						
						thisformset.lx_form1.lx_pageframe1.page7.tx_data_ini_separacao.enabled = .F.
						thisformset.lx_form1.lx_pageframe1.page7.lb_status_entrada.visible = .f.
						thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.visible = .F.
								
						if !f_vazio(xalias)
							sele &xalias
						endif

		otherwise
		return .t.				
	endcase
	ENDPROC
	
	
	* Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais	
	Procedure AnmBuscaSeparaAlmox 
	
		sele v_compras_01_reservas
		go top	
		scan	
			f_select("select anm_reserva_almox " + ; 
			         "from producao_reserva where material=?v_compras_01_reservas.material " + ; 
			         "and cor_material=?v_compras_01_reservas.cor_material " + ;
			         "and ordem_producao=?v_compras_01_reservas.pedido","curSeparaAlmox",alias())

			repla anm_reserva_almox with curSeparaAlmox.anm_reserva_almox 
		endscan	

		sele v_compras_01_reservas
		go top	

	Endproc
	* Inclui Nova Procedure na Classe da Tela >> Dentro de Activate da Guia Materiais
ENDDEFINE


**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_status_entrada AS lx_label


	Caption = "Status Entrada"
	Height = 15
	Left = 360
	Top = 43
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	FontBold = .T.
	p_muda_size = .F.
	Name = "lb_status_entrada"
	Visible = .t. 
	Anchor = 0
	Alignment=0

	PROCEDURE DblClick	
		
		*If thisformset.p_tool_status="P" and (v_producao_os_01.anm_status_almox <>"2-RECEBIDO ALMOX" or f_vazio(v_producao_os_01.anm_status_almox))  
	If thisformset.p_tool_status="P"
		sele v_compras_01 
		xOldStatusAlmox = v_compras_01.anm_status_almox
		if f_vazio(v_compras_01.anm_filial_material)
			MESSAGEBOX("Favor colocar a filial para enviar para consumo !!!",0+64)
			RETURN .f.
		Endif		

		sele v_compras_01
		
		If v_compras_01.anm_status_almox="1-ENVIADO PARA ALMOX" 
			
			text to xselUser noshow textmerge	
				SELECT * FROM PROPRIEDADE_VALIDA 
				WHERE PROPRIEDADE='00058' 
				AND LTRIM(RTRIM(VALOR_PROPRIEDADE))= '<<WUSUARIO>>'
			endtext	
		
			f_select(xselUser,"curUserFimOs",alias())
			
			if f_vazio(curUserFimOs.valor_propriedade)
				messagebox("Você Não tem Permissão para Alterar o Status do Pedido enquanto não for Finalizado",48,"Atenção!!!")
				thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.F.
				*thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled=.f.
				retu .f.
				o_toolbar.Botao_refresh.Click()
			else
				if messagebox("Deseja Alterar o Status do Pedido?",4+32+256,"Atenção!")=6	
					thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.T.
					*thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled=.T.
				endif
			endif				
		Else
				if messagebox("Deseja Alterar o Status do Pedido?",4+32+256,"Atenção!")=6	
					thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.T.
					thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .T.
					thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.refresh()
					*thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled=.t.
				endif		
		Endif
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
	Left = 450
	TabIndex = 1
	Top = 41
	Width = 147
	ZOrderSet = 5
	Name = "cmb_status_entrada"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

	PROCEDURE Valid	
	
	
	IF THISFORMSET.P_TOOL_STATUS="P"
	
		If V_Compras_01.anm_status_almox <> "1-ENVIADO PARA ALMOX" 
			
			if messagebox("Deseja Finalizar este Pedido de Compra?",4+32+256,"Atenção!")=6	

				xordem_servico=V_Compras_01.pedido
				*ORDEM_SERVICO,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

					UPDATE COMPRAS SET ANM_STATUS_ALMOX='<<v_compras_01.anm_status_almox>>'	, ANM_DATA_INICIO_SEPARACAO=null
					WHERE pedido='<<xordem_servico>>' 
				
					INSERT INTO ANM_STATUS_COMPRAS_PA_MOV
					(PEDIDO,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID)
					SELECT 
					'<<xordem_servico>>',
					'<<V_Compras_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
					'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
					(select max(id_registro) from ANM_STATUS_COMPRAS_PA_MOV where pedido = '<<xordem_servico>>' and left(ANM_STATUS_ALMOX,1)=1 )
					where '<<xordem_servico>>'+'<<V_Compras_01.ANM_STATUS_ALMOX>>' 
					not in 
					(select  pedido+anm_status_ALMOX
					from ANM_STATUS_COMPRAS_PA_MOV)	

				endtext


				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status do Pedido de Compra",48,"Atenção_8!")
					replace v_compras_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.F.
					thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .F.
					thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Refresh()
					retu .f.
				ELSE
					
					f_select("select ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?xordem_servico ","curDataIciAlmox",alias())
				
					thisformset.lx_form1.lx_pageframe1.page7.tx_data_ini_separacao.value=curDataIciAlmox.ANM_DATA_INICIO_SEPARACAO 
					o_toolbar.Botao_refresh.Click()
				ENDIF	
				
				thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .F.
				thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Refresh()
				o_toolbar.Botao_refresh.Click()

			endif
						
		
		Else
		
			
			if messagebox("Deseja Alterar o Status deste Ped. para "+allt(V_Compras_01.anm_status_almox)+" ?",4+32+256,"Atenção!")=6
				
				xordem_servico=V_Compras_01.PEDIDO
				
				TEXT TO xSelReserva TEXTMERGE NOSHOW
				
					SELECT COUNT(*) as QTDE FROM PRODUCAO_RESERVA (NOLOCK) A
					--JOIN (SELECT DISTINCT ORDEM_PRODUCAO FROM WANM_PRODUCAO_TAREFAS_OS (NOLOCK)
					--		      WHERE ORDEM_SERVICO = '<<xordem_servico>>' ) B
					--		ON A.ORDEM_PRODUCAO= B.ORDEM_PRODUCAO  
					WHERE A.RESERVA > 0 AND A.ANM_RESERVA_ALMOX = 1
					AND A.ORDEM_PRODUCAO ='<<xordem_servico>>'
				ENDTEXT
				
				f_select(xSelReserva,"xVerifReserva")
				
				IF xVerifReserva.QTDE = 0
					MESSAGEBOX("ATENÇÃO!"+CHR(13)+"Impossível Enviar Ped., Não existe material a ser consumido.",64)
					f_select("select ANM_STATUS_ALMOX from COMPRAS where PEDIDO=?xordem_servico ","curStatsAlmox",alias())
					thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
					
					thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.F.
					thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .F.
					thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Refresh()
					RETURN .F.
					o_toolbar.Botao_refresh.Click()
				ENDIF
				
				*lucas verificar saldo materiais	
				  If V_Compras_01.anm_status_almox = "1-ENVIADO PARA ALMOX" 	
				   
				   ** #4 - Julio Cesar - 13/05/2016 - CONTROLE P/ NÃO ENVIAR MAT PARA ALMOX COM CUSTO IGUAL 0
					** Incio **
					TEXT TO xCustoZero TEXTMERGE NOSHOW
					
						SELECT A.MATERIAL,A.COR_MATERIAL 
						FROM PRODUCAO_RESERVA A
							JOIN WANM_MATERIAIS_CUSTOS B ON A.MATERIAL = B.MATERIAL AND A.COR_MATERIAL = B.COR_MATERIAL
						WHERE A.ORDEM_PRODUCAO = '<<V_Compras_01.PEDIDO>>'  
						  AND ANM_RESERVA_ALMOX = 1 AND B.CUSTO_A_VISTA = 0 AND A.RESERVA > 0
						
					ENDTEXT
					f_select(xCustoZero,"xCusCustoZero")
					
					IF RECCOUNT()>0
						
						GO Top
						xMsgcusto = 'Existem materiais com custo igual a zero:'+CHR(13)+CHR(13)
						SCAN
							xMsgcusto = xMsgcusto + ALLTRIM(xCusCustoZero.MATERIAL) + ' - ' +  ALLTRIM(xCusCustoZero.COR_MATERIAL) + CHR(13)
						ENDSCAN

						MESSAGEBOX(xMsgcusto+CHR(13)+CHR(13)+"CTRL+C Executado",64)
						_CLIPTEXT = xMsgcusto
						
						SELECT v_compras_01
						replace v_compras_01.anm_status_almox with xOldStatusAlmox
						thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.F.
						thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .F.
						thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Refresh()
						RETURN .f.

					ENDIF
					** Fim #4 **	
				   
				   Sele V_compras_01_reservas
				   xReg = RECCOUNT()
				   Go Top
				   
				   xMsg  = ''
				   XQMat = 0
				   xCont = 0
				   
				   Scan 		 	
				 		
				 		IF V_compras_01_reservas.Reserva > 0 and thisformset.pp_anm_valida_estoque and V_compras_01_reservas.anm_reserva_almox < 2
					 		xCont = xCont + 1
					 		f_prog_bar("Consultando Estoque Disp. - Material: ";
					 		           +ALLTRIM(V_compras_01_reservas.Material)+" | Cor: "+ALLTRIM(V_compras_01_reservas.Cor_Material)+CHR(13)+;
					 		            "Aguarde ... "+ALLTRIM(STR(ROUND((xCont/xReg)*100,0)))+"% Concluido",xCont,xReg)
					 		           
					 		Text To xSelEDisp TextMerge NoShow
					 		
					 			SELECT * FROM FX_ANM_ESTOQUE_MAT_DISP('<<V_compras_01.Pedido>>','','<<V_compras_01.Anm_Filial_Material>>','<<V_compras_01_reservas.Material>>','<<V_compras_01_reservas.Cor_Material>>') 
					 			WHERE QTDE_ESTOQUE_DISP 	< <<V_compras_01_reservas.Reserva>>
					   		
					   		EndText
					   		
					   		f_select(xSelEDisp,"Tmp_CurEstDisp")
					   		
					   		If RecCount()>0
					   			
					   			XQMat = XQMat + 1
					   			xMsg = xMsg + CHR(13) + ALLTRIM(STR(XQMat))+ "- Material: "+ALLTRIM(Tmp_CurEstDisp.Material)+" | Cor: "+ALLTRIM(Tmp_CurEstDisp.Cor_Material)+" | Disponível: "+ALLTRIM(STR(Tmp_CurEstDisp.Qtde_Estoque_Disp,15,3))
					   		
					   		Endif	
				   		ENDIF
				   	
				   	Sele V_compras_01_reservas
				   	EndScan
					f_prog_bar()
					
					If XQMat = 1
						f_select("select ANM_STATUS_ALMOX from COMPRAS where PEDIDO=?xordem_servico ","curStatsAlmox",alias())
    					thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
						MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível do Material:" + CHR(13) + xMsg,64)
						
						thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.F.
						thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .F.
						thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Refresh()
						RETURN .f.
					Else	
						If XQMat > 1
							f_select("select ANM_STATUS_ALMOX from COMPRAS where PEDIDO=?xordem_servico ","curStatsAlmox",alias())
							thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
							MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível dos Materiais:" + CHR(13) + xMsg,64)
							
							thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.F.
							thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .F.
							thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Refresh()
							RETURN .f.
						Endif
					Endif
				
					
					Sele V_compras_01_reservas
				    Go Top					
				Endif
				*lucas verificar saldo materiais
				
				*ORDEM_SERVICO,ANM_STATUS_ALMOX,DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP
				text to	xinsert1 noshow textmerge	

						UPDATE COMPRAS SET ANM_STATUS_ALMOX='<<V_Compras_01.anm_status_almox>>'
						WHERE PEDIDO='<<xordem_servico>>' and tabela_filha = 'COMPRAS_PRODUTO'

						UPDATE COMPRAS SET ANM_DATA_INICIO_SEPARACAO=
							case 
						           when convert(int,left(convert(varchar(13),getdate(),108),2)) > 15  
						           then dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),2)
						           else dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),1)
						    end
										
						WHERE PEDIDO='<<xordem_servico>>' and tabela_filha = 'COMPRAS_PRODUTO'

					INSERT INTO ANM_STATUS_COMPRAS_PA_MOV
					(PEDIDO,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,DATA_SEPARA,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP)
					SELECT 
					'<<xordem_servico>>',
					'<<V_Compras_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
					(select anm_data_inicio_separacao from COMPRAS where PEDIDO = '<<xordem_servico>>'),
					'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE())
					where '<<xordem_servico>>'+'<<V_Compras_01.ANM_STATUS_ALMOX>>' 
					not in 
					(select  PEDIDO+anm_status_ALMOX
					 from ANM_STATUS_COMPRAS_PA_MOV)	

				endtext	
				
				
				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status do Pedido de Compra",48,"Atenção_8!")
					replace v_compras_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.enabled=.F.
					thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .F.
					thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Refresh()
					retu .f.
				endif
				
				thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.enabled = .F.
				thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.Refresh()
				o_toolbar.Botao_refresh.Click()
				
				f_select("select ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?xordem_servico ","curDataIciAlmox",alias())
				
				thisformset.lx_form1.lx_pageframe1.page7.tx_data_ini_separacao.value=curDataIciAlmox.ANM_DATA_INICIO_SEPARACAO 
							
			endif	
	
		Endif	
	
	ENDIF 
	
	ENDPROC 
	
	



ENDDEFINE
*
*-- EndDefine: cmb_status_entrada
**************************************************

**************************************************
*-- Class:        lb_status_filial_mat (p:\tmpsid\entradas_rbx\lb_status_filial_mat.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_status_filial_mat AS lx_label


	Caption = "Filial Material"
	Height = 15
	Left = 367
	Top = 67
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	FontBold = .T.
	p_muda_size = .F.
	Name = "lb_status_filial_mat"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_status_filial_mat
**************************************************

**************************************************
*-- Class:        cmb_filial_mat (p:\tmpsid\entradas_rbx\cmb_filial_mat.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_filial_mat AS lx_combobox

	Height = 22
	Left = 450
	TabIndex = 1
	Top = 63
	Width = 147
	ZOrderSet = 5
	Name = "cmb_filial_mat"
	Visible = .t.
	Enabled = .t.
	Anchor = 0
	*RowSource = ""
	*ControlSource = ""

*!*			PROCEDURE VALID 	
*!*			xpedido = V_Compras_01.PEDIDO
*!*				dodefault() 
*!*				text to	xupdt noshow textmerge	
*!*					update compras set ANM_FILIAL_MATERIAL=?v_Compras_01.ANM_FILIAL_MATERIAL
*!*					where pedido=?v_Compras_01.pedido 
*!*					and fornecedor=?v_Compras_01.fornecedor 		
*!*				endtext	 		
*!*				
*!*				f_update(xupdt)
*!*				
*!*				f_select("select ANM_FILIAL_MATERIAL from COMPRAS where PEDIDO=?xpedido","curStatsAlmox",alias())
*!*				
*!*				replace v_compras_01.ANM_FILIAL_MATERIAL with curStatsAlmox.ANM_FILIAL_MATERIAL
*!*				*thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.enabled=.f.
*!*			
*!*		ENDPROC
ENDDEFINE
*
*-- EndDefine: cmb_filial_mat 
**************************************************
**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_data_ini_separacao AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 450
	TabIndex = 11
	Top = 85
	Width = 65
	ZOrderSet = 8
	Name = "tx_data_ini_separacao"
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************


**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_data_menor_que AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 250
	TabIndex = 11
	Top = 153
	Width = 65
	ZOrderSet = 8
	Name = "tx_data_menor_que"
	value = CTOD('')
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************

**************************************************
*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_data_maior_que AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 160
	TabIndex = 11
	Top = 153
	Width = 65
	ZOrderSet = 8
	Name = "tx_data_maior_que"
	value = CTOD('')
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: tx_data_ini_separacao
**************************************************

**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_a AS lx_label


	Caption = "a"
	Height = 15
	Left = 232
	Top = 155
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_a"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************

**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_de AS lx_label


	Caption = "De"
	Height = 15
	Left = 142
	Top = 155
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_de"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************

**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_relatorio AS lx_label


	Caption = "Filtro por data"
	Height = 15
	Left = 160
	Top = 135
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_relatorio"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************

**************************************************
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_data_ini_separacao AS lx_label


	Caption = "Data Início Separação Almox"
	Height = 15
	Left = 280
	Top = 90
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_data_ini_separacao"
	Visible = .t.
	Anchor = 0
	Alignment=0
	FontBold = .T.
	
ENDDEFINE
*
*-- EndDefine: lb_data_ini_separacao 
**************************************************


**************************************************
*-- Class:        lb_filto_colecao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_colecao AS lx_label


	Caption = "Coleção"
	Height = 15
	Left = 130
	Top = 105
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_colecao"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_filtro_colecao
**************************************************

**************************************************
*-- Class:        cmb_filtro_colecao (c:\temp\cmb_filtro_colecao.vcx)
*-- ParentClass:  lx_textbox_valida (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/18/09 01:02:02 PM
*
DEFINE CLASS cmb_filtro_colecao AS lx_combobox

	RowSource = "xcolecao.colecao"
	ControlSource = ""
	Height = 22
	Left = 180
	Top = 100
	Width = 140
	TabIndex = 1
	ZOrderSet = 5
	Name = "cmb_filtro_colecao"
	Visible = .T.
	Enabled = .T.

ENDDEFINE
*
*-- EndDefine: cmb_filtro_colecao
**************************************************


**************************************************
*-- Class:        lb_filtro_griffe(p:\tmpsid\entradas_rbx\lb_filtro_griffe.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_griffe AS lx_label


	Caption = "Griffe"
	Height = 15
	Left = 350
	Top = 105
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_griffe"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_filtro_griffe
**************************************************

**************************************************
*-- Class:        cmb_filtro_griffe(c:\temp\cmb_filtro_griffe.vcx)
*-- ParentClass:  lx_textbox_valida (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/18/09 01:02:02 PM
*
DEFINE CLASS cmb_filtro_griffe AS lx_combobox

	RowSource = "xgriffe.griffe"
	ControlSource = ""
	Height = 22
	Left = 390
	Top = 100
	Width = 140
	TabIndex = 1
	ZOrderSet = 5
	Name = "cmb_filtro_griffe"
	Visible = .T.
	Enabled = .T.

ENDDEFINE
*
*-- EndDefine: lb_filtro_griffe
**************************************************


**************************************************
*-- Class:        cmb_separa_almox (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_separa_almox AS lx_combobox


	*RowSource = ""
	*ControlSource = ""
	Height = 22
	Left = 1
	TabIndex = 1
	Top = 1
	Width = 147
	ZOrderSet = 5
	Name = "cmb_separa_almox"
	Visible = .t.
	Enabled = .T.
	Anchor = 0
	BoundColumn=2


	PROCEDURE VALID 	
		
		If thisformset.p_tool_status <> "L" 
			dodefault() 
			text to	xupdt noshow textmerge	
				update producao_reserva set anm_reserva_almox=?v_Compras_01_Reservas.anm_reserva_almox 
				where ordem_producao=?v_Compras_01_Reservas.pedido 
				and material=?v_Compras_01_Reservas.material   
				and cor_material=?v_Compras_01_Reservas.cor_material 			
			endtext	 
			
			f_update(xupdt)
		Endif
	ENDPROC



ENDDEFINE
*
*-- EndDefine: cmb_status_entrada
**************************************************


**************************************************
*!*	*-- Class:        ck_separa_almox (c:\temp\est_renato\ck_separa_almox.vcx)
*!*	*-- ParentClass:  lx_checkbox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*!*	*-- BaseClass:    checkbox
*!*	*-- Time Stamp:   09/01/11 02:19:13 PM
*!*	*
*!*	DEFINE CLASS ck_separa_almox AS lx_checkbox


*!*		Top = 78
*!*		Left = 664
*!*		Alignment = 0
*!*		ControlSource = "V_PRODUCAO_OS_01.RECURSO_PROPRIO"
*!*		TabIndex = 14
*!*		ZOrderSet = 20
*!*		Name = "ck_RECURSO_PROPRIO"

*!*		PROCEDURE DBLCLICK	
*!*			
*!*			this.Enabled=.t. 
*!*			MESSAGEBOX(v_producao_os_02_materiais.anm_reserva_almox )
*!*			
*!*		ENDPROC	


*!*	ENDDEFINE
*!*	*
*-- EndDefine: ck_separa_almox
**************************************************


*!*	**************************************************
*!*	*-- Class:        lb_custo_fabrica (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*!*	*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*!*	*-- BaseClass:    label
*!*	*-- Time Stamp:   11/10/08 01:57:13 PM
*!*	*
*!*	DEFINE CLASS lb_custo_fabrica AS lx_label


*!*		Caption = "Custo Fabrica"
*!*		Height = 15
*!*		Left = 250
*!*		Top = 155
*!*		Width = 22
*!*		TabIndex = 10
*!*		ForeColor = RGB(0,0,0)
*!*		BackColor = RGB(0,0,255)
*!*		ZOrderSet = 6
*!*		p_muda_size = .F.
*!*		Name = "lb_custo_fabrica"
*!*		Visible = .F.
*!*		Anchor = 0
*!*		Alignment=0

*!*	ENDDEFINE
*!*	*
*!*	*-- EndDefine: lb_custo_fabrica 
*!*	**************************************************



*!*	**************************************************
*!*	*-- Class:        tx_data_ini_separacao (c:\temp\tx_data_ini_separacao.vcx)
*!*	*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*!*	*-- BaseClass:    textbox
*!*	*-- Time Stamp:   07/15/11 02:05:13 PM
*!*	*
*!*	DEFINE CLASS tx_custo_fabrica AS lx_textbox_base


*!*		ControlSource = ""
*!*		Height = 22
*!*		Left = 320
*!*		TabIndex = 11
*!*		Top = 153
*!*		Width = 65
*!*		ZOrderSet = 8
*!*		Name = "tx_custo_fabrica"
*!*		Enabled=.T.
*!*		Visible=.F.
*!*		value = 0.00

*!*	ENDDEFINE
*!*	*
*-- EndDefine: tx_data_ini_separacao
**************************************************

**************************************************
*-- Class:        tx_codigo_barras(c:\temp\tx_codigo_barras.vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS tx_codigo_barras AS lx_textbox_base


	ControlSource = ""
	Height = 22
	Left = 257
	TabIndex = 11
	Top = 61
	Width = 250
	ZOrderSet = 8
	Name = "tx_codigo_barras"
	Enabled=.T.
	Visible=.F.


ENDDEFINE
*
*-- EndDefine: tx_codigo_barras
**************************************************

**************************************************
*-- Class:        lb_codigo_barra (p:\tmpsid\entradas_rbx\lb_codigo_barra .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_codigo_barra AS lx_label


	Caption = "Cod. Barra"
	Height = 15
	Left = 197
	Top = 63
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_codigo_barra "
	Visible = .F.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_codigo_barra 
**************************************************

**************************************************
*-- Class:        cmb_prog_prioridade (c:\temp\cmb_prog_prioridade .vcx)
*-- ParentClass:  lx_textbox_base (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   07/15/11 02:05:13 PM
*
DEFINE CLASS cmb_prog_prioridade AS lx_combobox

	RowSource = "xprogPrioridade.PROG_PRIORIDADE"
	ControlSource = ""
	Height = 22
	Left = 224
	TabIndex = 11
	Top = 287
	Width = 150
	ZOrderSet = 8
	Name = "cmb_prog_prioridade"
	value = ''
	Enabled=.T.
	Visible=.T.

ENDDEFINE
*
*-- EndDefine: cmb_prog_prioridade 
**************************************************

**************************************************
*-- Class:        lb_filtro_tipoProg (p:\tmpsid\entradas_rbx\lb_filtro_tipoProg.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filtro_tipoProg AS lx_label


	Caption = "Programação"
	Height = 15
	Left = 150
	Top = 290
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filtro_tipoProg"
	Visible = .t.
	Anchor = 0
	Alignment=0

ENDDEFINE
*
*-- EndDefine: lb_filtro_tipoProg 
*!*	**************************************************
*!*	**************************************************
*!*	*-- Class:        bt_inverte_separacao (c:\linx desenv\classes lucas\bt_inverte_separacao.vcx)
*!*	*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*!*	*-- BaseClass:    commandbutton
*!*	*-- Time Stamp:   06/05/15 01:54:07 PM
*!*	*!*	*
*!*	DEFINE CLASS bt_inverte_separacao AS botao


*!*		Top = 5
*!*		Left = 116
*!*		Height = 27
*!*		Width = 104
*!*		Caption = "Inverte Separação"
*!*		Name = "bt_inverte_separacao"
*!*		Visible = .T.
*!*		Enabled = .T.
*!*		
*!*		PROCEDURE Click

*!*				IF F_VAZIO(V_Compras_01_Reservas.MATERIAL)
*!*						MESSAGEBOX("SEM MATERIAL NA TELA",0+64)
*!*						RETURN .f.
*!*				ENDIF
*!*					IF thisformset.lx_form1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COR_MATERIAL_SUBSTITUIDO.Enabled=.t.

*!*						SELE V_Compras_01_Reservas
*!*							GO TOP
*!*							SCAN
*!*								IF V_Compras_01_Reservas.anm_reserva_almox=1
*!*									replace V_Compras_01_Reservas.anm_reserva_almox WITH 2
*!*								ELSE
*!*									replace V_Compras_01_Reservas.anm_reserva_almox WITH 1
*!*								ENDIF
*!*								SELE V_Compras_01_Reservas
*!*							ENDSCAN
*!*						SELE V_Compras_01_Reservas
*!*					 ELSE
*!*					 	RETURN .f.
*!*					ENDIF
*!*					
*!*		ENDPROC


*!*	ENDDEFINE
*!*	*
*-- EndDefine: bt_inverte_separacao
**************************************************
**************************************************
*-- Class:        bt_altera_obs(c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_altera_obs AS botao


	Top = 4
	Left = 70
	Height = 18
	Width = 90
	FontBold = .T.
	Caption = "Alterar"
	TabIndex = 40
	Name = "bt_altera_obs"
	Visible = .T.


	PROCEDURE Click

		
		IF thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.caption == "Alterar"
				with thisformset.lx_FORM1.lx_pageframe1.page5
					.bt_altera_obs.caption = "Salvar"
				    .Ed_OBS.ReadOnly= .F.
				endwith    
		ELSE 		
				
				f_insert("UPDATE COMPRAS SET OBS =?V_COMPRAS_01.OBS WHERE PEDIDO =?V_COMPRAS_01.PEDIDO AND TABELA_FILHA = 'COMPRAS_PRODUTO'")
				MESSAGEBOX("Alterado com Sucesso",0+64)
				
				with thisformset.lx_FORM1.lx_pageframe1.page5
					.bt_altera_obs.caption = "Alterar"
				    .Ed_OBS.ReadOnly= .T.
				endwith
		ENDIF
				
					
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_altera_obs 
**************************************************
**************************************************
*-- Class:        botao_salvar (c:\pastas\work\classes_julio\botao_salvar.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/24/15 01:52:13 PM
*
DEFINE CLASS bt_salvar AS commandbutton


	Top = 85
	Left = 520
	Height = 22
	Width = 23
	Visible= .T.
	Picture = ("salvar.jpg")
	Caption = "Salvar"
	Style = 0
	ToolTipText = [Salvar]
	PicturePosition = 14
	ZOrderSet = 46
	Name = "bt_salvar"


	PROCEDURE Click
		if	thisformset.p_tool_status='P'
			thisformset.lx_form1.lx_pageframe1.page7.cmb_status_entrada.ENABLED = .f.
			thisformset.lx_form1.lx_pageframe1.page7.cmb_filial_mat.ENABLED = .f.
			thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.cmb_separa_almox.enabled=.f.
			thisformset.lx_form1.lx_pageframe1.page7.lx_GRID_FILHA1.Col_tx_FATOR_CONVERSAO.cmb_separa_almox.Refresh()
		endif
	ENDPROC


ENDDEFINE
*
*-- EndDefine: botao_salvar
**************************************************

**************************************************
*-- Class:        bt_gera_op (c:\pastas\work\classes_julio\bt_gera_op_acabamento.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/13/16 06:13:09 PM
*
DEFINE CLASS bt_gera_op_acab AS commandbutton


	Top = 1
	Left = 651
	Height = 31
	Width = 101
	FontSize = 8
	WordWrap = .T.
	Visible= .T.
	Caption = "Gera OP de Acabamento"
	Name = "bt_gera_op_acab"


	PROCEDURE Click
		sele v_compras_01_ent_prod
		TEXT TO xSelOpAcabamento TEXTMERGE NOSHOW

			SELECT * FROM ANM_PEDIDO_OP_ACABAMENTO
			WHERE PEDIDO 		= '<<V_COMPRAS_01.PEDIDO>>'
			 AND  NF_ENTRADA 	= '<<V_COMPRAS_01_ENT_PROD.NF_ENTRADA >>' 
			 AND  NOME_CLIFOR 	= '<<V_COMPRAS_01.FORNECEDOR>>'
			 AND  PRODUTO 		= '<<V_COMPRAS_01_ENT_PROD.PRODUTO>>'  

		ENDTEXT
		f_select(xSelOpAcabamento,"xCur_Verif_OP_Acabamento")

		IF RECCOUNT()=0

			IF MESSAGEBOX("Deseja gerar a OP de acabamento?",4+32)=6
				IF f_update("LX_ANM_GERA_OP_ACABAMENTO ?V_COMPRAS_01.PEDIDO,?v_compras_01_ent_prod.NF_ENTRADA,?V_COMPRAS_01.FORNECEDOR,?v_compras_01_ent_prod.PRODUTO")
					TEXT TO xSelOpAcabamento TEXTMERGE NOSHOW

						SELECT * FROM ANM_PEDIDO_OP_ACABAMENTO
						WHERE PEDIDO 		= '<<V_COMPRAS_01.PEDIDO>>'
						 AND  NF_ENTRADA 	= '<<V_COMPRAS_01_ENT_PROD.NF_ENTRADA >>' 
						 AND  NOME_CLIFOR 	= '<<V_COMPRAS_01.FORNECEDOR>>'
						 AND  PRODUTO 		= '<<V_COMPRAS_01_ENT_PROD.PRODUTO>>'  

					ENDTEXT
					f_select(xSelOpAcabamento,"xCur_Verif_OP_Acabamento")
					
					_Cliptext = ALLTRIM(xCur_Verif_OP_Acabamento.ordem_producao)
					MESSAGEBOX("OP: "+ALLTRIM(xCur_Verif_OP_Acabamento.ordem_producao)+CHR(13)+"Gerada com Sucesso!",64) 
				ELSE
					MESSAGEBOX("Não foi possível gerar OP de acabamento."	,64)
				ENDIF
			ELSE
				RETURN .F.
			ENDIF
		ELSE
			_Cliptext = ALLTRIM(xCur_Verif_OP_Acabamento.ordem_producao)
			MESSAGEBOX("OP: "+ALLTRIM(xCur_Verif_OP_Acabamento.ordem_producao)+CHR(13)+"já gerada para essa entrada!",64)
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_gera_op
**************************************************
