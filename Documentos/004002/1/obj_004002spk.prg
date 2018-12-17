* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
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
		
		* =messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		
		do CASE 
		
			
			
			
			CASE UPPER(xmetodo)=='USR_INIT' 
			
			
				**Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
				sele v_compras_01   
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("COLECAO", "C(25)",.T., "COLECAO", "COMPRAS.COLECAO")
				oCur.addbufferfield("MES_ENTRADA_LOJA","C(25)",.T., "MES_ENTRADA_LOJA", "COMPRAS.MES_ENTRADA_LOJA")		
				*** FABIANO - LUCAS MIRANDA - 01/04/2016
				oCur.addbufferfield("COMPRAS.ANM_STATUS_ALMOX", "C(25)",.T., "ANM_STATUS_ALMOX", "COMPRAS.ANM_STATUS_ALMOX")
				oCur.addbufferfield("COMPRAS.ANM_DATA_INICIO_SEPARACAO", "D",.T., "ANM_DATA_INICIO_SEPARACAO", "COMPRAS.ANM_DATA_INICIO_SEPARACAO")		
				*** FIM - FABIANO - LUCAS MIRANDA - 01/04/2016		
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
				
				public xOldStatusAlmox,xstatus_entrada,xordem_servico,curSepara,xSaveAfter
				
				f_select("select convert(varchar(25),valor_propriedade) as anm_status_almox from propriedade_valida where propriedade='00057'","xstatus_entrada")
				
				f_select("select distinct filial from filiais where CTRL_PRODUCAO_MATERIAL = 1","xstatus_filial_mat")
								 
				store '' to	xordem_servico

				with thisformset.lx_form1.lx_pageframe1.page8	
					.addobject("lb_status_entrada","lb_status_entrada")
					.addobject("cmb_status_entrada","cmb_status_entrada")					
					.addobject("tx_data_ini_separacao","tx_data_ini_separacao")					
					.addobject("lb_data_ini_separacao","lb_data_ini_separacao")				
				endwith
				
				with thisformset.lx_form1.lx_pageframe1
					.page8.cmb_status_entrada.RowSource="xstatus_entrada"
					.page8.cmb_status_entrada.ControlSource="v_compras_01.ANM_STATUS_ALMOX" 
					.page8.tx_data_ini_separacao.ControlSource="v_compras_01.ANM_DATA_INICIO_SEPARACAO" 
				endwith	
				*** FIM - FABIANO - LUCAS MIRANDA - 01/04/2016	
				TEXT TO xMes NOSHOW textmerge

					SELECT VALOR_PROPRIEDADE FROM PROPRIEDADE_VALIDA
					WHERE PROPRIEDADE = '00202' ORDER BY DATA_ATIVACAO

					--DECLARE @VALOR_ATUAL	VARCHAR(200)	= (SELECT MES FROM WANM_MES_ENTRADA_LOJAS_COMPRAS)
					--SELECT * FROM FXANM_ConsultaVarString(@VALOR_ATUAL)

				ENDTEXT
				f_select(xMes, 'curMes')
				SELE curMes		
					
			
				
			  f_select ('select DESC_COLECAO  from colecoes','curColecao',ALIAS())
			  SELECT curColecao 
			  APPEND BLANK  
				
              WITH thisformset.lx_form1.lx_PAGEFRAME1.page1
					.addObject("bt_exporta_materiais","bt_exporta_materiais")
					.addObject("cmbColecao","cmbColecao")
					.addObject("lblColecao","lblColecao")		
					.addObject("cmbMesEntrada","cmbMesEntrada")
					.addObject("lblMesEntrada","lblMesEntrada")
              ENDWITH
			 
			  THISFORMSET.L_LIMPA()		
			  
			CASE UPPER(xmetodo)=='USR_VALID' 
				
				xalias=alias()
				
					If upper(xnome_obj) = 'TV_FORNECEDOR'
						
						if !f_vazio(Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.Value)
							
							Text TO xSelCondPgto TextMerge Noshow
								
								select B.CONDICAO_PGTO,B.DESC_COND_PGTO,B.TIPO_CONDICAO 
								from FORNECEDORES A 
									JOIN COND_ENT_PGTOS B
									ON A.CONDICAO_PGTO = B.CONDICAO_PGTO 
								where FORNECEDOR = '<<V_COMPRAS_01.FORNECEDOR>>'
							Endtext	
							f_select(xSelCondPgto,"xCondFornec")
								
							With Thisformset.lx_FORM1.lx_pageframe1.page1
								.tv_condicao_pgto.Value 		= xCondFornec.CONDICAO_PGTO
								.tx_desc_condicao_pgto.Value	= xCondFornec.DESC_COND_PGTO
								.tx_tipo_condicao.Value			= xCondFornec.TIPO_CONDICAO 
							EndWith	
							
							Thisformset.lx_FORM1.lx_pageframe1.page1.tv_condicao_pgto.l_desenhista_recalculo()
							Thisformset.lx_FORM1.Tv_FORNECEDOR.l_desenhista_recalculo() 
						endif
		
					Endif
					 
				if !f_vazio(xalias)	
					sele &xalias
				endif
				
			CASE UPPER(xmetodo)=='USR_ALTER_BEFORE'  		
					
					SELECT V_COMPRAS_01
					REPLACE V_COMPRAS_01.APROVADOR_POR WITH wusuario + ' '+ DTOC(DATE())				
            
            CASE UPPER(xmetodo)=='USR_SAVE_BEFORE' 
	           	
	           	xalias=alias()
	           	
		           	**AJUSTE PARA GRAVAR NO BANCO 
		           	SELECT V_COMPRAS_01
		           	REPLACE COLECAO WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value				 
					REPLACE MES_ENTRADA_LOJA WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.value
					
					SELE V_COMPRAS_01	
						IF F_VAZIO(V_COMPRAS_01.mes_entrada_loja)
							MESSAGEBOX("Favor Colocar Mês Entrada Loja !!!",0+48)
							RETURN .f.
						ENDIF					  			   		
				 	***** COLOCAR CUSTO NOS MATERIAIS QUANDO MATERIAL NAO CONTEM CUSTO **********
				   	SELE V_COMPRAS_01_MATERIAIS
				   	GO TOP
				   
				   	SCAN
				   		
				   		SELE V_COMPRAS_01_MATERIAIS
				   		f_update("UPDATE MATERIAIS_CORES SET CUSTO_A_VISTA =?V_COMPRAS_01_MATERIAIS.CUSTO WHERE CUSTO_A_VISTA = 0 AND MATERIAL = ?V_COMPRAS_01_MATERIAIS.MATERIAL AND COR_MATERIAL =?V_COMPRAS_01_MATERIAIS.COR_MATERIAL")

				   	ENDSCAN		
					***** FIM ***** JULIO **** 19-03-2013 ******************************************
					*** #1 - Lucas Miranda - Implantação Envio Para Consumo					
					*lucas verificar saldo materiais	
					
				   Sele V_compras_01_reservas
				   xReg = RECCOUNT()
				   Go Top
				   
				   xMsg  = ''
				   XQMat = 0
				   xCont = 0
				   
				   Scan 		 	
				 		
				 		IF V_compras_01_reservas.Reserva > 0 and thisformset.pp_anm_valida_estoque AND (!'ENVIAD' $ V_COMPRAS_01.anm_status_almox or f_vazio(v_compras_01.anm_status_almox))
					 		xCont = xCont + 1
					 		f_prog_bar("Consultando Estoque Disp. - Material: ";
					 		           +ALLTRIM(V_compras_01_reservas.Material)+" | Cor: "+ALLTRIM(V_compras_01_reservas.Cor_Material)+CHR(13)+;
					 		            "Aguarde ... "+ALLTRIM(STR(ROUND((xCont/xReg)*100,0)))+"% Concluido",xCont,xReg)
					 		           
					 		Text To xSelEDisp TextMerge NoShow
					 		
					 			SELECT * FROM FX_ANM_ESTOQUE_MAT_DISP('<<V_compras_01.Pedido>>','','<<V_compras_01.Filial_a_entregar>>','<<V_compras_01_reservas.Material>>','<<V_compras_01_reservas.Cor_Material>>') 
					 			WHERE QTDE_ESTOQUE_DISP 	< <<V_compras_01_reservas.Reserva>>
					   		
					   		EndText
					   		
					   		f_select(xSelEDisp,"Tmp_CurEstDisp")
					   		
					   		If RecCount()>0
					   			
					   			XQMat = XQMat + 1
					   			xMsg = xMsg + CHR(13) + ALLTRIM(STR(XQMat))+ "- Material: "+ALLTRIM(Tmp_CurEstDisp.Material)+" | Cor: "+ALLTRIM(Tmp_CurEstDisp.Cor_Material)+" | Disponível: "+ALLTRIM(STR(Tmp_CurEstDisp.Qtde_Estoque_Disp,15,3))
					   		
					   		Else
					   			xSaveAfter = 'S'
					   			text to	xDataSeparacao noshow textmerge	
							
									SELECT  case 
										when convert(int,left(convert(varchar(13),getdate(),108),2)) > 15  
										then dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),2)
										else dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),1)
									end as DataSeparacao
								endtext
					
								f_select(xDataSeparacao,"CurDataSeparacao")
								
								sele V_compras_01
								replace anm_status_almox with '1-ENVIADO PARA ALMOX'
								replace ANM_DATA_INICIO_SEPARACAO with CurDataSeparacao.DataSeparacao
					   			
					   		Endif
				   		 ENDIF
				   	
				   	Sele V_compras_01_reservas
				   	EndScan
					f_prog_bar()
					
					If XQMat = 1
						MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível do Material:" + CHR(13) + xMsg,64)
							f_select("select ANM_STATUS_ALMOX,ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?v_compras_01.pedido ","curStatusAlmox",alias())
							Sele V_compras_01
							replace anm_status_almox with curStatusAlmox.Anm_Status_Almox
							replace ANM_DATA_INICIO_SEPARACAO with curStatusAlmox.ANM_DATA_INICIO_SEPARACAO 
							release curStatusAlmox
						RETURN .f.
					Else	
						If XQMat > 1
							MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível dos Materiais:" + CHR(13) + xMsg,64)
							f_select("select ANM_STATUS_ALMOX,ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?v_compras_01.pedido ","curStatusAlmox",alias())
							Sele V_compras_01
							replace anm_status_almox with curStatusAlmox.Anm_Status_Almox
							replace ANM_DATA_INICIO_SEPARACAO with curStatusAlmox.ANM_DATA_INICIO_SEPARACAO
							release curStatusAlmox
							RETURN .f.
						Endif
					Endif
					
					Sele V_compras_01_reservas
				    Go Top
					
					
			
						
				If Thisformset.pp_anm_valid_tipo_compra_ben = .T.
					if 'BENEFIC' $ v_compras_01.tipo_compra  
						Sele V_Compras_01_Reservas
						If Reccount() = 0
							MESSAGEBOX("Favor colocar reserva Semi-Acabado",0+64)
							Return .F.
						Endif
					endif
					if !'BENEFIC' $ v_compras_01.tipo_compra  
						Sele V_Compras_01_Reservas
						If Reccount() > 0
							MESSAGEBOX("Favor colocar tipo para Beneficiamento, pois tem Semi-Acabado",0+64)
							Return .F.
						Endif
					endif
				Endif
					
				*** #1 - Lucas Miranda - Implantação Envio Para Consumo	
				if !f_vazio(xalias)	
					sele &xalias
				endif
			
			
				
			CASE UPPER(xmetodo)=='USR_SEARCH_BEFORE'
				SELECT V_COMPRAS_01
	          	REPLACE COLECAO WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value
	          	REPLACE MES_ENTRADA_LOJA WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.value
			    thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.f.
			   	thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.enabled=.f.
			    
			CASE UPPER(xmetodo)=='USR_SEARCH_AFTER'                
				thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.f.
				thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.enabled=.f.
				thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais.visible = .T.		
			
			CASE UPPER(xmetodo)=='USR_CLEAN_AFTER'
				
				if type("thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais")<>"U"
					thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais.visible = .F.
					thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.T.
				endif		
				
*!*					if type("thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada")<>"U"
*!*						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.visible =.f.
*!*					endif		
*!*					
			CASE UPPER(xmetodo)=='USR_REFRESH'                
				 
				xalias=alias()
				
					TRY
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value=v_compras_01.colecao 
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.value=v_compras_01.mes_entrada_loja
						
						If thisformset.p_tool_status="I"
						*A pedido da larissa manna - Lucas Miranda - 08/08/2014
						*thisformset.lx_FORM1.lx_pageframe1.page1.tv_rateio_filial.Value='000990'
						*thisformset.lx_FORM1.lx_pageframe1.page1.tx_desc_rateio_filial.Value='RBX FABRICA 100%'
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.tv_rateio_filial.refresh()
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
						thisformset.lx_FORM1.lx_pageframe1.page1.tv_raTEIO_FILIAL.refresh()
						thisformset.lx_FORM1.lx_pageframe1.page1.tx_deSC_RATEIO_FILIAL.refresh()
						Endif 
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_filial_a_entregar.refresh()
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.tv_rateio_filial.valid()			
			
						*replace colecao WITH '' IN  v_compras_01
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.valid()
						
						 
					CATCH 
					
					endtry 
				**** #1 - Lucas Miranda - Implantação Envio Para Consumo	
					if type("thisformset.lx_form1.lx_pageframe1.page8.lb_status_entrada")<>"U"
							
							if thisformset.p_tool_status = "I" or thisformset.p_tool_status = "L" 
								thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.T.
							else	
								thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.	
							endif		
														
							if thisformset.p_tool_status $'IA'
								thisformset.lx_form1.lx_pageframe1.page8.lb_status_entrada.visible = .F.
								thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.visible = .F.								
							else
								thisformset.lx_form1.lx_pageframe1.page8.lb_status_entrada.visible = .T.
								thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.visible = .T.
							endif	
																	
						endif	
						
						if type("thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao")<>"U"
							
							if	thisformset.p_tool_status='L'
								thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao.enabled=.t.
							else	
								thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao.enabled=.f.						
							endif

						endif
						
							Thisformset.lx_form1.lx_pageframe1.Page8.Botao1.Enabled = .T.
							Thisformset.lx_form1.lx_pageframe1.Page8.Botao4.Enabled = .T.
						*** #1 - Lucas Miranda - Implantação Envio Para Consumo	

				if !f_vazio(xalias)	
					sele &xalias
				endif	
				
				 
			CASE UPPER(xmetodo)=='USR_INCLUDE_AFTER' 
			
			SELECT V_COMPRAS_01
			REPLACE V_COMPRAS_01.APROVADOR_POR WITH wusuario + ' '+ DTOC(DATE())
			
			TEXT TO xCol TEXTMERGE NOSHOW
				SELECT COLECAO, DESC_COLECAO FROM COLECOES WHERE COLECAO = ?o_004002.pp_colecao_padrao
			ENDTEXT 

			f_select(xCol,"Cur_Colpadrao")
			sele Cur_Colpadrao
			REPLACE V_COMPRAS_01.COLECAO WITH Cur_Colpadrao.DESC_COLECAO
			thisformset.lx_form1.lx_pageframe1.page1.CmbColecao.Value = Cur_Colpadrao.DESC_COLECAO	
			
			thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.t.
			thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.enabled=.t.
			*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value='' 
			
			CASE UPPER(xmetodo)=='USR_ALTER_AFTER' 	
			
				thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.t.
				thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbMesEntrada.enabled=.t.
			*** #1 - Lucas Miranda - Implantação Envio Para Consumo
				thisformset.lx_form1.lx_pageframe1.Page8.LX_GRID_FILHA1.Col_tx_RESERVA_ORIGINAL.Enabled = .T.
				Thisformset.lx_form1.lx_pageframe1.Page8.LX_GRID_FILHA1.Col_tx_matar_saldo_reserva.Enabled=.T.
				Thisformset.lx_form1.lx_pageframe1.Page8.Botao1.Enabled = .T.
				Thisformset.lx_form1.lx_pageframe1.Page8.Botao4.Enabled = .T.
				
				
			CASE UPPER(xmetodo)=='USR_ITEN_INCLUDE_BEFORE' OR UPPER(xmetodo)=='USR_ITEN_DELETE_BEFORE'
				
				xalias=alias()
					If upper(xnome_obj) = 'COMPRAS_001'
						IF thisformset.p_tool_status = 'A' AND thisformset.lx_form1.lx_pageframe1.ActivePage = 9 
							if v_compras_01.anm_status_almox = '1-ENVIADO PARA ALMOX'
								MESSAGEBOX("Proibido Incluir ou Excluir Material com Pedido Enviado Para Almoxarifado !",16)
								Return .F.
							endif 		
						
						ENDIF
					Endif		
				if !f_vazio(xalias)	
					sele &xalias
				endif					
			
			CASE UPPER(xmetodo)=='USR_WHEN'
				
				xalias=alias()
					If upper(xnome_obj) = 'TX_RESERVA_ORIGINAL' or upper(xnome_obj) = 'BOTAO1' or upper(xnome_obj) = 'BOTAO4'
						IF thisformset.p_tool_status = 'A' AND thisformset.lx_form1.lx_pageframe1.ActivePage = 9 
							if v_compras_01.anm_status_almox = '1-ENVIADO PARA ALMOX'
								Thisformset.lx_form1.lx_pageframe1.Page8.LX_GRID_FILHA1.Col_tx_RESERVA_ORIGINAL.Enabled = .F.
								Thisformset.lx_form1.lx_pageframe1.Page8.LX_GRID_FILHA1.Col_tx_matar_saldo_reserva.Enabled=.f.
								Thisformset.lx_form1.lx_pageframe1.Page8.Botao1.Enabled = .F.
								Thisformset.lx_form1.lx_pageframe1.Page8.Botao4.Enabled = .F.
							endif 		
						
						ENDIF
					Endif		
				
			
				if !f_vazio(xalias)	
					sele &xalias
				endif					
			
			CASE UPPER(xmetodo)=='USR_SAVE_AFTER'
				
				xalias=alias()
					If thisformset.p_tool_status $'IA' AND xSaveAfter = 'S' AND 'ENVIAD' $ V_COMPRAS_01.anm_status_almox
							text to	xinsert1 noshow textmerge	

								INSERT INTO ANM_STATUS_COMPRAS_MP_MOV
								(PEDIDO,ANM_STATUS_ALMOX,
								DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID)
								SELECT 
								'<<V_Compras_01.pedido>>',
								'<<V_Compras_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
								'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
								(select max(id_registro) from ANM_STATUS_COMPRAS_MP_MOV where pedido = '<<V_Compras_01.pedido>>' and left(ANM_STATUS_ALMOX,1)=1 and ANM_STATUS_ALMOX = '1-ENVIADO PARA ALMOX' )

							endtext

							xSaveAfter = ''
							
							if !f_insert(xinsert1) 
								messagebox("Não foi Gravar o Log do Status do Pedido de Compra",48,"Atenção_8!")
							ENDIF	
					
					Endif		
				
			*** #1 - Lucas Miranda - Implantação Envio Para Consumo	
				if !f_vazio(xalias)	
					sele &xalias
				endif	
			
			otherwise
				return .t.				
		endcase
	ENDPROC 
ENDDEFINE


**************************************************
*-- Class:        bt_saida_avulsa (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_exporta_materiais AS botao


	Top = 352
	Left = 35
	Height = 20
	Width = 230
	FontBold = .T.
	Caption = "Exporta Materiais dos Pedidos (Excel)"
	TabIndex = 40
	Name = "bt_exporta_materiais"
	Visible = .F.


	PROCEDURE Click	
		
	*SET STEP ON	
			
			SELECT B.PEDIDO,B.MATERIAL AS EMISSAO,B.MATERIAL,B.DESC_MATERIAL,B.COR_MATERIAL,B.DESC_COR_MATERIAL,;
			A.FORNECEDOR,B.QTDE_ENTREGUE,B.VALOR_ENTREGUE,B.QTDE_ENTREGAR,B.VALOR_ENTREGAR,;
			A.FORNECEDOR AS STATUS_APROVACAO,A.APROVADOR_POR,A.TIPO_COMPRA;
			FROM V_COMPRAS_01 A JOIN V_COMPRAS_01_MATERIAIS B; 
			ON A.PEDIDO = B.PEDIDO WHERE 1=2 INTO CURSOR EXPORTA_MATERIAIS_EXCEL READWRITE
			
			SELE EXPORTA_MATERIAIS_EXCEL 
			GO TOP 

 	SELE V_COMPRAS_01
 	GO TOP
 	
 	SCAN
		
		SELE V_COMPRAS_01
		f_prog_bar('Exportando Pedido nº '+V_COMPRAS_01.PEDIDO)
		
		TEXT TO XSEL TEXTMERGE NOSHOW
		
			SELECT B.PEDIDO,CONVERT(CHAR,(A.EMISSAO),103) AS EMISSAO,B.MATERIAL,C.DESC_MATERIAL,B.COR_MATERIAL,D.DESC_COR_MATERIAL,
			A.FORNECEDOR,B.QTDE_ENTREGUE,CONVERT(NUMERIC(18,2),B.VALOR_ENTREGUE) AS VALOR_ENTREGUE,B.QTDE_ENTREGAR,
			CONVERT(NUMERIC(18,2),B.VALOR_ENTREGAR) AS VALOR_ENTREGAR,E.DESC_STATUS_COMPRA,A.APROVADOR_POR,A.TIPO_COMPRA
			FROM COMPRAS A JOIN COMPRAS_MATERIAL B
			ON A.PEDIDO = B.PEDIDO
			JOIN MATERIAIS C
			ON B.MATERIAL = C.MATERIAL
			JOIN MATERIAIS_CORES D
			ON  B.MATERIAL = D.MATERIAL
			AND B.COR_MATERIAL = D.COR_MATERIAL
			JOIN COMPRAS_STATUS E
			ON A.STATUS_APROVACAO = E.STATUS_COMPRA
			WHERE A.PEDIDO = '<<V_COMPRAS_01.PEDIDO>>'
		
		ENDTEXT
		
		F_SELECT(XSEL,"TMP_EXPORTACAO",ALIAS())
		
	SELE TMP_EXPORTACAO
	GO TOP
	
		SCAN		
			
			SELE EXPORTA_MATERIAIS_EXCEL
			
			APPEND BLANK
			REPLACE     TIPO_COMPRA 	  WITH ALLTRIM(TMP_EXPORTACAO.TIPO_COMPRA)
			REPLACE     PEDIDO	 		  WITH ALLTRIM(TMP_EXPORTACAO.PEDIDO)
			REPLACE     EMISSAO	 		  WITH ALLTRIM(TMP_EXPORTACAO.EMISSAO)
			REPLACE		MATERIAL	      WITH ALLTRIM(TMP_EXPORTACAO.MATERIAL)
			REPLACE	    DESC_MATERIAL	  WITH ALLTRIM(TMP_EXPORTACAO.DESC_MATERIAL)
			REPLACE		COR_MATERIAL	  WITH ALLTRIM(TMP_EXPORTACAO.COR_MATERIAL)
			REPLACE		DESC_COR_MATERIAL WITH ALLTRIM(TMP_EXPORTACAO.DESC_COR_MATERIAL)
			REPLACE		QTDE_ENTREGUE     WITH 		   TMP_EXPORTACAO.QTDE_ENTREGUE
			REPLACE		VALOR_ENTREGUE    WITH         TMP_EXPORTACAO.VALOR_ENTREGUE
			REPLACE		QTDE_ENTREGAR     WITH         TMP_EXPORTACAO.QTDE_ENTREGAR
			REPLACE		VALOR_ENTREGAR    WITH         TMP_EXPORTACAO.VALOR_ENTREGAR
			REPLACE		FORNECEDOR        WITH ALLTRIM(TMP_EXPORTACAO.FORNECEDOR)
			REPLACE		STATUS_APROVACAO  WITH ALLTRIM(TMP_EXPORTACAO.DESC_STATUS_COMPRA)
			REPLACE		APROVADOR_POR     WITH ALLTRIM(TMP_EXPORTACAO.APROVADOR_POR)
		
		SELE TMP_EXPORTACAO
		
		ENDSCAN	
	
	RELEASE TMP_EXPORTACAO
	
	SELE V_COMPRAS_01
	

	
	ENDSCAN
				
		SELE V_COMPRAS_01
 		GO TOP	

	SELE EXPORTA_MATERIAIS_EXCEL
	GO TOP

		COPY TO C:\TEMP\Exportacao_Pedido_Materiais.XLS XLS
		MESSAGEBOX("Exportado com sucesso para C:\TEMP\Exportacao_Pedido_Materiais.XLS",0+64)
	
	RELEASE EXPORTA_MATERIAIS_EXCEL
 	f_wait()
 				
	ENDPROC

ENDDEFINE
*
*-- EndDefine: bt_saida_avulsa 
**************************************


**************************************************
*-- Class:        cmb_separa_almox (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmbColecao AS lx_combobox

Name = "cmbColecao"
visible=.t.
top=152
left=110
width=201
controlsource=v_compras_01.colecao 
rowsource='curColecao'
enabled=.t.				
rowsourcetype=2
value='' 



ENDDEFINE
*
*-- EndDefine: cmbColecao
**************************************************

**************************************************
*-- Class:        lblColecao(p:\tmpsid\entradas_rbx\lblColecao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lblColecao AS lx_label
				
	visible=.t.
	top=155
	left=68
	width=77
	caption='Coleção'					
	height=15
	Name = "lblColecao"


ENDDEFINE
*
*-- EndDefine: lblColecao
**************************************************

**************************************************
*-- Class:        cmb_separa_almox (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmbMesEntrada AS lx_combobox

Name = "cmbMesEntrada"
visible=.t.
top=175
left=110
width=184
controlsource=v_compras_01.mes_entrada_loja 
rowsource='curMes'
enabled=.t.				
rowsourcetype=2
value='' 



ENDDEFINE
*
*-- EndDefine: cmbColecao
**************************************************

**************************************************
*-- Class:        lblMesEntrada(p:\tmpsid\entradas_rbx\lblColecao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lblMesEntrada AS lx_label
				
	visible=.t.
	top=175
	left=23
	width=77
	caption='Mês Entrada Loja'					
	height=15
	Name = "lblMesEntrada"


ENDDEFINE
*
*-- EndDefine: lblMesEntrada
**************************************************
**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_status_entrada AS lx_label


	Caption = "Status Entrada"
	Height = 15
	Left = 334
	Top = 6
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
	If thisformset.p_tool_status ="P"
		sele v_compras_01 
		xOldStatusAlmox = v_compras_01.anm_status_almox
		if f_vazio(v_compras_01.filial_a_entregar)
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
				thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
				retu .f.
				o_toolbar.Botao_refresh.Click()
			else
				if messagebox("Deseja Alterar o Status do Pedido?",4+32+256,"Atenção!")=6	
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.T.	
				endif
			endif				
		Else
				if messagebox("Deseja Alterar o Status do Pedido?",4+32+256,"Atenção!")=6	
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.T.
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
	Left = 420
	TabIndex = 1
	Top = 3
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
				
					INSERT INTO ANM_STATUS_COMPRAS_MP_MOV
					(PEDIDO,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP,CHAVE_ID)
					SELECT 
					'<<xordem_servico>>',
					'<<V_Compras_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
					'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE()),
					(select max(id_registro) from ANM_STATUS_COMPRAS_MP_MOV where pedido = '<<xordem_servico>>' and left(ANM_STATUS_ALMOX,1)=1 and ANM_STATUS_ALMOX = '1-ENVIADO PARA ALMOX' )

				endtext


				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status do Pedido de Compra",48,"Atenção_8!")
					replace v_compras_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
					retu .f.
				ELSE
					
					f_select("select ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?xordem_servico ","curDataIciAlmox",alias())
				
					thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao.value=curDataIciAlmox.ANM_DATA_INICIO_SEPARACAO 
					o_toolbar.Botao_refresh.Click()
				ENDIF	
				
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
					WHERE A.RESERVA > 0 
					AND A.ORDEM_PRODUCAO ='<<xordem_servico>>'
				ENDTEXT
				
				f_select(xSelReserva,"xVerifReserva")
				
				IF xVerifReserva.QTDE = 0
					MESSAGEBOX("ATENÇÃO!"+CHR(13)+"Impossível Enviar Ped., Não existe material a ser consumido.",64)
					f_select("select ANM_STATUS_ALMOX from COMPRAS where PEDIDO=?xordem_servico ","curStatsAlmox",alias())
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
					
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
					RETURN .F.
					o_toolbar.Botao_refresh.Click()
				ENDIF
				
				*lucas verificar saldo materiais	
				  If V_Compras_01.anm_status_almox = "1-ENVIADO PARA ALMOX" 	
				   Sele V_compras_01_reservas
				   xReg = RECCOUNT()
				   Go Top
				   
				   xMsg  = ''
				   XQMat = 0
				   xCont = 0
				   
				   Scan 		 	
				 		
				 		IF V_compras_01_reservas.Reserva > 0 and thisformset.pp_anm_valida_estoque 
					 		xCont = xCont + 1
					 		f_prog_bar("Consultando Estoque Disp. - Material: ";
					 		           +ALLTRIM(V_compras_01_reservas.Material)+" | Cor: "+ALLTRIM(V_compras_01_reservas.Cor_Material)+CHR(13)+;
					 		            "Aguarde ... "+ALLTRIM(STR(ROUND((xCont/xReg)*100,0)))+"% Concluido",xCont,xReg)
					 		           
					 		Text To xSelEDisp TextMerge NoShow
					 		
					 			SELECT * FROM FX_ANM_ESTOQUE_MAT_DISP('<<V_compras_01.Pedido>>','','<<V_compras_01.Filial_a_Entregar>>','<<V_compras_01_reservas.Material>>','<<V_compras_01_reservas.Cor_Material>>') 
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
    					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
						MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível do Material:" + CHR(13) + xMsg,64)
						
						thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
						RETURN .f.
					Else	
						If XQMat > 1
							f_select("select ANM_STATUS_ALMOX from COMPRAS where PEDIDO=?xordem_servico ","curStatsAlmox",alias())
							thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.value=curStatsAlmox.ANM_STATUS_ALMOX 
							MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível dos Materiais:" + CHR(13) + xMsg,64)
							
							thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
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
						WHERE PEDIDO='<<xordem_servico>>' and tabela_filha = 'COMPRAS_MATERIAL'

						UPDATE COMPRAS SET ANM_DATA_INICIO_SEPARACAO=
							case 
						           when convert(int,left(convert(varchar(13),getdate(),108),2)) > 15  
						           then dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),2)
						           else dbo.lx_dias_uteis('000994',convert(datetime,convert(varchar(13),getdate(),112)),1)
						    end
										
						WHERE PEDIDO='<<xordem_servico>>' and tabela_filha = 'COMPRAS_MATERIAL'

					INSERT INTO ANM_STATUS_COMPRAS_MP_MOV
					(PEDIDO,ANM_STATUS_ALMOX,
					DATA_ALTERACAO,DATA_SEPARA,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA,TIMESTAMP)
					SELECT 
					'<<xordem_servico>>',
					'<<V_Compras_01.ANM_STATUS_ALMOX>>','<<DTOS(WDATA)>>',
					(select anm_data_inicio_separacao from COMPRAS where PEDIDO = '<<xordem_servico>>'),
					'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>',(SELECT GETDATE())

				endtext	
				
				
				if !f_insert(xinsert1) 
					messagebox("Não foi possível Alterar o Status do Pedido de Compra",48,"Atenção_8!")
					replace v_compras_01.anm_status_almox with xOldStatusAlmox
					thisformset.lx_form1.lx_pageframe1.page8.cmb_status_entrada.enabled=.F.
					retu .f.
				endif
				

				o_toolbar.Botao_refresh.Click()
				
				f_select("select ANM_DATA_INICIO_SEPARACAO from COMPRAS where PEDIDO=?xordem_servico ","curDataIciAlmox",alias())
				
				thisformset.lx_form1.lx_pageframe1.page8.tx_data_ini_separacao.value=curDataIciAlmox.ANM_DATA_INICIO_SEPARACAO 
							
			endif	
	
		Endif	
	
	ENDIF 
	
	ENDPROC 
	
	



ENDDEFINE
*
*-- EndDefine: cmb_status_entrada
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
	Left = 502
	TabIndex = 11
	Top = 45
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
*-- Class:        lb_data_ini_separacao (p:\tmpsid\entradas_rbx\lb_data_ini_separacao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_data_ini_separacao AS lx_label


	Caption = "Data Separação"
	Height = 15
	Left = 410
	Top = 49
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

