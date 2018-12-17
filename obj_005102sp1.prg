* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: AJUSTES RBX E VALORES PRODUCAO                                                                                                     *
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
* - Atencao !!!!!!!!!!!								                                    *
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

				public xvalor_nota , xtempo_producao , xvalor_producao	
				store 0 to xvalor_nota , xtempo_producao , xvalor_producao	

				thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.ACTIVATE()
				IF UPPER(WUSUARIO) = 'CHRISTIAN.COSTA' OR UPPER(WUSUARIO) = 'ROBSON.SANTANA' OR UPPER(WUSUARIO) = 'WALLACE.SANTOS' OR UPPER(WUSUARIO) = 'SA'
					THISFORMSET.lx_form1.tv_operacao.p_valida_where=" AND Naturezas_entradas.Inativo = 0 AND naturezas_entradas.CTB_TIPO_OPERACAO not in  ( 201, 202, 205, 206, 208, 209, 210, 215, 241, 246 , 299) " 
				ELSE					
					THISFORMSET.lx_form1.tv_operacao.p_valida_where=" AND Naturezas_entradas.Inativo = 0 AND naturezas_entradas.CTB_TIPO_OPERACAO not in  ( 200,201, 202, 205, 206, 208, 209, 210, 215, 241, 246 , 299) " 
				ENDIF 
				*thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo.REFRESH()
								
				xalias=alias()
			
				public xfiliais_estoque,xnf_entrada,xserie_nf_entrada,xnome_clifor,xfilial,xfilial_estoque,xromaneio,xArmazem
			
				with thisformset.lx_form1.lx_PAGEFRAME1.page1
					*.parent.page6.removeobject("Botao1")
					*.parent.page6.addobject("Botao1","Botao1")
					*.pageframe1.page2.addobject("tx_valor_itens","tx_valor_itens")
					*.pageframe1.page2.addobject("tx_valor_producao","tx_valor_producao")
					*.parent.parent.addobject("bt_saida_avulsa","bt_saida_avulsa")			
				endwith		

				store '' to	xnf_entrada,xserie_nf_entrada,xnome_clifor,xfilial,xfilial_estoque,xromaneio,xArmazem 

				if !f_vazio(xalias)
					sele &xalias
				endif	

				Thisformset.L_limpa()
				
		*** LUCAS MIRANDA ****		
 			case UPPER(xmetodo) == 'USR_INCLUDE_AFTER'
 				xalias=alias()
 				
 					IF  thisformset.pp_anm_especie_serie_padrao <>'0'
					
					thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value = 'NF-E'
					thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Enabled = .F.
					thisformset.lx_form1.lx_pageframe1.page1.pageframe1.page_nfe.txt_chave_nfe.Enabled= .T.
					
 					SELE V_ENTRADAS_00
 						 xEspecie_Serie = 5
						 xModelo_Fiscal = '55'
						 
					REPLACE ESPECIE_SERIE 		 WITH xEspecie_Serie
					REPLACE NUMERO_MODELO_FISCAL WITH xModelo_Fiscal 
					
					else
					thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Enabled = .T.
					endif
 				
				if !f_vazio(xalias)
					sele &xalias
				endif
 		*********************					
				
				
 				
***MOSTRA VALOR PRODUCAO
			
			case UPPER(xmetodo) == 'USR_REFRESH' 

				xalias=alias()
			
				
					xvalor_nota = 0

					if type("o_005102.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo")<>"U"
						xtempo_producao = o_005102.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo.Value 
					else	
						xtempo_producao = 1 
					endif		
				
					sele v_entradas_00_prod1_ent 
					sum valor to xvalor_nota  
				
					go top	
				
					xvalor_producao = ( round( xvalor_nota/(1-(xtempo_producao/100)) ,2)-xvalor_nota )				

					If type("thisformset.lx_form1.bt_saida_avulsa")<>"U"  
						IF UPPER(WUSUARIO) = 'ROSALVO' OR UPPER(WUSUARIO) = 'SA'
							thisformset.lx_form1.bt_saida_avulsa.visible=.T.			
						ELSE					
							thisformset.lx_form1.bt_saida_avulsa.visible=.F.
						ENDIF 
					Endif
					
					** Volta Valor do campo para default **
					Thisformset.lx_FORM1.tv_operacao.ReadOnly= .F.
			

				if !f_vazio(xalias)
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
									
						IF upper(xnome_obj) == 'BT_FECHA_PEDIDO' 
							
							xvalor_nota = 0

							o_005102.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.ACTIVATE()


							sele v_entradas_00_prod1_ent 
							sum valor to xvalor_nota  
							
							go top	
					
							xvalor_producao = ( round( xvalor_nota/(1-(xtempo_producao/100)) ,2)-xvalor_nota )				

						 ENDIF 								 	
						
						
						IF upper(xnome_obj) == 'BTNSELECAO'
						
							UPDATE V_ENTRADAS_00_PROD1_ENT SET FILIAL = V_ENTRADAS_00.FILIAL
						
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


				
***MOSTRA VALOR PRODUCAO
	
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE' 
				
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

			IF THISFORMSET.P_TOOL_status == 'I'				

				parametro_chave=THISFORMSET.pp_valida_chave_nfe_entrada
				chave_nfe=THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page_NFE.txt_chave_nfe.Value
				serie_nf_desc=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value
				nf_entrada_propria=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.ck_nf_propria.Value
				
				IF parametro_chave = .T. AND f_vazio(chave_nfe) AND serie_nf_desc = 'NF-E' AND nf_entrada_propria = .F. 
					MESSAGEBOX("VOCÊ NÃO INFORMOU A CHAVE !!!" + CHR(13) + "FAVOR INSERIR A CHAVE !",64)
					RETURN .F.
				ENDIF
				
			ENDIF	
				xalias=alias()
				
					text to	xupdt noshow	
						insert into prop_entradas  
						(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,NF_ENTRADA,SERIE_NF_ENTRADA,NOME_CLIFOR)  
						select  
						'00014',1,b.valor_propriedade,a.nf_entrada, a.serie_nf_entrada,a.nome_clifor  
						from  
						(select top 1 a.pedido,a.nome_clifor,a.nf_entrada,a.serie_nf_entrada   
						from entradas_material a  
						where a.nome_clifor    = ?v_entradas_00.nome_clifor   
						and a.nf_entrada       = ?v_entradas_00.nf_entrada   
						and a.serie_nf_entrada = ?v_entradas_00.serie_nf_entrada) a   
						join prop_compras b  
						on a.pedido=b.pedido 
						left join prop_entradas c  
						on  a.nome_clifor      = c.nome_clifor 
						and a.nf_entrada       = c.nf_entrada  
						and a.serie_nf_entrada = c.serie_nf_entrada  
						where c.nome_clifor is null  
					endtext		
					
					if !f_update(xupdt) 
						messagebox("Não foi possível Inserir Propriedade")	
					endif		
					
					xnf_entrada=v_entradas_00.nf_entrada
					xserie_nf_entrada=v_entradas_00.serie_nf_entrada
					xnome_clifor=v_entradas_00.nome_clifor
					xfilial=v_entradas_00.filial							
					
*!*						IF thisformset.LX_FORM1.Lx_pageframe1.Page1.Pageframe1.Page1.Ck_nf_propria.value == .F.
*!*							if	allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='E1' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='U' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='5' 
*!*								retu .t. 
*!*							else	
*!*								messagebox("É permitido somente o uso das Séries U, 5 e de Produção !",48,"Atenção!!!")
*!*								retu .f.
*!*							endif		
*!*						ELSE
*!*							if allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='5' OR allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='A5'
*!*								retu .t.
*!*							else	
*!*								messagebox("É permitido somente o uso das Séries 5 e 55 !",48,"Atenção!!!")
*!*								retu .f.
*!*							endif
*!*						ENDIF							

				if	!f_vazio(xalias)	
					sele &xalias 
				endif	 




			otherwise
				return .t.				
		endcase
	endproc
enddefine


**************************************************
*-- Class:        bt_pedidos_prod (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   11/20/08 01:37:14 PM
*
DEFINE CLASS Botao1 AS botao


	Top = 108
	Left = 590
	Height = 24
	Width = 115
	FontBold = .T.
	Caption = "\<Seleção"
	TabIndex = 48
	Name = "Botao1"
	Visible = .T.


	PROCEDURE Click
		Local nOldSele, cWhereNF, cWhere, cSQL as String

		nOldSele = Select()

		If ! InList(ThisFormSet.p_Tool_Status, "I", "A") OR v_Entradas_00.NOTA_COMPLEMENTAR

			Select(nOldSele)
			Return

		EndIf

		If InList(v_Entradas_00.TIPO_OPERACAO, "D", "N")

			If this.parent.lx_opcaoselecao.Value = 1
				F_Msg(["Não é possível utilizar a opção de seleção de pedidos em devoluções!", 0+48, "Atenção"])
				Select(nOldSele)
				Return
			Endif 

			If (Type('ThisFormSet.pp_valida_pedido_dig_cod_bar') = "U" or ThisFormSet.pp_valida_pedido_dig_cod_bar)

				F_Msg(["Para utilizar essa opção, ajuste o parâmetro VALIDA_PEDIDO_DIG_COD_BAR.", 0+48, "Atenção"])
				Select(nOldSele)
				Return

			Endif 

		EndIf

		ThisFormSet.px_Zerar_Qtde_Entrada = ( This.Parent.lx_OpcaoSelecao.Value == 2 )   && Se for código de barras

		If F_Vazio(v_Entradas_00.NOME_CLIFOR)

			F_Msg(["Informe o fornecedor para selecionar os pedidos !", 0+48, "Atenção"])
			Select(nOldSele)
			Return .F.

		EndIf

		With This.Parent.Parent.Page7.lx_PageFrame1

			.Page1.cmb_Fornecedores.ControlSource = ""
			.Page1.cmb_Fornecedores.RowSource     = ""
			.Page1.cmb_PEDIDOS.CONTROLSOURCE	  = ""
			.Page1.cmb_PEDIDOS.ROWSOURCE		  = ""

			.Page2.cmb_Fornecedores.ControlSource = ""
			.Page2.cmb_Fornecedores.RowSource     = ""
			.Page2.cmb_PEDIDOS.CONTROLSOURCE	  = ""
			.Page2.cmb_PEDIDOS.ROWSOURCE		  = ""

		EndWith

		If Used("xCur_Pedidos")

			Select xCur_Pedidos
			Use

		EndIf

		If Used("xCur_Pedidos_Fornec")

			Select xCur_Pedidos_Fornec
			Use

		EndIf

		If ThisFormSet.px_Bloq_EntPed_NOP
			cWhereNF = " AND ( COMPRAS.NATUREZA_ENTRADA IS NULL OR COMPRAS.NATUREZA_ENTRADA = ?v_Entradas_00.NATUREZA ) "
		Else
			cWhereNF = ""
		EndIf

		cWhere = "RTRIM(COMPRAS.TABELA_FILHA) = 'COMPRAS_PRODUTO' AND " + ;
		         "COMPRAS.TOT_QTDE_ENTREGAR > 0 AND " + ;
		         "COMPRAS.STATUS_APROVACAO = 'A' " + ;
		         cWhereNF



		If wCtrl_Multi_Empresa
			cWhere = cWhere + " AND FILIAIS.EMPRESA = ?wEmpresa_Atual"
		EndIf

		If Type("ThisFormSet.pp_Valida_Pedido_Dig_Cod_Bar") == "L" AND ! ThisFormSet.pp_Valida_Pedido_Dig_Cod_Bar AND This.Parent.lx_OpcaoSelecao.Value == 2

			F_Select("SELECT DISTINCT COMPRAS.PEDIDO, COMPRAS.FORNECEDOR, COMPRAS.FILIAL_COBRANCA, SPACE(06) AS COD_FILIAL_COBRANCA " + ;
			         "FROM COMPRAS " + ;
			         "WHERE 1 = 0", "xCur_Pedidos")
			         
			Select distinct fornecedor from xcur_pedidos into cursor xcur_pedidos_fornec

		Else

			cSQL = "SELECT DISTINCT COMPRAS.PEDIDO, COMPRAS.FORNECEDOR, COMPRAS.FILIAL_COBRANCA, FILIAIS_COBRANCA.COD_FILIAL AS COD_FILIAL_COBRANCA " + ;
			       "FROM COMPRAS "

			If Type("ThisFormSet.pp_Filtrar_Limite_Pedido")== "L" AND ThisFormSet.pp_Filtrar_Limite_Pedido
				cSQL = cSQL + "INNER JOIN COMPRAS_PRODUTO ON COMPRAS.PEDIDO = COMPRAS_PRODUTO.PEDIDO AND COMPRAS_PRODUTO.LIMITE_ENTREGA >= ?v_Entradas_00.RECEBIMENTO "
			EndIf

			cSQL = cSQL + "INNER JOIN FILIAIS ON COMPRAS.FILIAL_A_ENTREGAR = FILIAIS.FILIAL " + ;
			              "LEFT JOIN FILIAIS AS FILIAIS_COBRANCA ON COMPRAS.FILIAL_COBRANCA = FILIAIS_COBRANCA.FILIAL " + ;
			              "WHERE " + cWhere + " " + ;
			              "ORDER BY COMPRAS.PEDIDO"

			If ! F_Select(cSQL, "xCur_Pedidos")

				Select(nOldSele)
				Return .F.

			EndIf

			If Reccount("xCur_Pedidos") == 0

				F_Msg(["Não há pedidos em aberto !", 0+48, "Atenção"])

				Select(nOldSele)
				Return .F.

			EndIf

			Select distinct fornecedor from xcur_pedidos into cursor xcur_pedidos_fornec

			Select xCur_Pedidos_Fornec
			Locate For FORNECEDOR == v_Entradas_00.NOME_CLIFOR

			If ! Found()
				F_Msg(["Não existem pedidos para o fornecedor da entrada, será utilizado para filtro um outro fornecedor.", 0+48, "Atenção"])
				Go Top
			EndIf

		EndIf

		With This.Parent.Parent

			.Page1.Enabled = .F.
			.Page2.Enabled = .F.
			.Page3.Enabled = .F.
			.Page4.Enabled = .F.
			.Page5.Enabled = .F.
			.Page6.Enabled = .F.

			With .Page7

				.Enabled           = .T.
				.Parent.ActivePage = 7

				If This.Parent.lx_OpcaoSelecao.Value == 2 && Se código de barras

					With .lx_PageFrame1

						.Page1.Enabled                   = .F.
						.Page2.Enabled                   = .T.

						.Page2.cmb_Fornecedores.ControlSource = "xcur_pedidos_fornec.FORNECEDOR"
						.Page2.cmb_Fornecedores.RowSource     = "xcur_pedidos_fornec.FORNECEDOR"
						.Page2.cmb_Fornecedores.Requery()
						.Page2.cmb_Fornecedores.Refresh()
						.Page2.cmb_Fornecedores.l_Desenhista_Recalculo()

						.Page2.cmb_Pedidos.ControlSource = "xCur_Pedidos.PEDIDO"
						.Page2.cmb_Pedidos.RowSource     = "xCur_Pedidos.PEDIDO"
						.Page2.cmb_Pedidos.Requery()
						.Page2.cmb_PEDIDOS.LISTITEMID    = 1

						If Reccount("v_Entradas_00_Prod1_Ent") > 0

							.Page2.lx_Importa_CBar1.p_Converte_48_Barra = .T.
							.Page2.lx_Importa_CBar1.l_Conv_G48_To_Barra()

						EndIf

						.Page2.cmb_Pedidos.l_Desenhista_Recalculo()
						.ActivePage = 2

					EndWith

				Else

					With .lx_PageFrame1

						.Page1.Enabled = .T.
						.Page2.Enabled = .F.
						.ActivePage    = 1

					EndWith

				EndIf

			EndWith

		EndWith

		Select(nOldSele)
		Return
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_pedidos_prod
**************************************************




**************************************************
*-- Class:        tx_valor_itens (c:\work\desenv\filtros_data\tx_valor_itens.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_valor_itens AS lx_textbox_base 


	ControlSource = "xvalor_nota"
	Height = 19
	Left = 197
	TabIndex = 4
	Top = 272
	Width = 117
	p_tipo_dado = "mostra"
	Name = "tx_valor_itens"
	Visible = .T.
	Enabled = .F.	
	ForeColor = RGB(255,0,0)
	BorderColor = RGB(128,128,128)	
	SpecialEffect = 1 	
	BackStyle = 0 
	BorderStyle = 0 	
	INPUTMASK = "999 999 999.99"
	FontBold = .T.

ENDDEFINE
*
*-- EndDefine: tx_valor_itens 
**************************************************


**************************************************
*-- Class:        tx_valor_producao (c:\work\desenv\filtros_data\tx_valor_producao.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_valor_producao AS lx_textbox_base 


	ControlSource = "xvalor_producao"
	Height = 19
	Left = 88
	TabIndex = 4
	Top = 254
	Width = 102
	p_tipo_dado = "mostra"
	Name = "tx_valor_producao"
	Visible = .T.
	Enabled = .F.	
	ForeColor = RGB(255,0,0)
	BackStyle = 0 
	BorderStyle = 0 	
	BorderColor = RGB(128,128,128) 
	SpecialEffect = 1 
	INPUTMASK = "999 999 999.99"
	FontBold = .T.


ENDDEFINE
*
*-- EndDefine: tx_valor_producao
**************************************************



**************************************************
*-- Class:        bt_saida_avulsa (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_saida_avulsa AS botao


	Top = 45
	Left = 610
	Height = 18
	Width = 90
	FontBold = .T.
	Caption = "Saida Avulsa"
	TabIndex = 40
	Name = "bt_saida_avulsa"
	Visible = .F.


	PROCEDURE Click

					text to	xinsert2 noshow textmerge	
					

						DELETE FROM ESTOQUE_PROD_SAI 
						WHERE ROMANEIO_PRODUTO IN 
						(SELECT 
						'T'+RIGHT(LTRIM(RTRIM(NF_ENTRADA)),6)
						FROM ESTOQUE_PROD_ENT
						WHERE NF_ENTRADA='<<allt(v_entradas_00.nf_entrada)>>' 
						and SERIE_NF_ENTRADA='<<allt(v_entradas_00.serie_nf_entrada)>>'  
						and NOME_CLIFOR='<<allt(v_entradas_00.nome_clifor)>>')
						AND FILIAL='ATACADO'
									
						INSERT INTO ESTOQUE_PROD_SAI   
						(ROMANEIO_PRODUTO,FILIAL,EMISSAO,RESPONSAVEL,TIPO_ROMANEIO,
						SEGUNDA_QUALIDADE,NAO_VALIDAR_ENTRADA,CM_OPERACAO,OBS) 
						SELECT DISTINCT
						'T'+RIGHT(LTRIM(RTRIM(NF_ENTRADA)),6) AS ROMANEIO_PRODUTO
						,'ATACADO' AS FILIAL,GETDATE() AS EMISSAO,'<<WUSUARIO>>' AS RESPONSAVEL,
						'AVULSA' AS TIPO_ROMANEIO,0 AS SEGUNDA_QUALIDADE,
						0 AS NAO_VALIDAR_ENTRADA,'011' AS CM_OPERACAO,
						'--AJUSTE MOSTRUARIO -- '
						+CHAR(13)+'NOTA FISCAL: '+LTRIM(RTRIM(NF_ENTRADA))
						+CHAR(10)+'SERIE: '+LTRIM(RTRIM(SERIE_NF_ENTRADA))
						+CHAR(10)+'FORNECEDOR: '+LTRIM(RTRIM(NOME_CLIFOR))
						FROM ESTOQUE_PROD_ENT
						WHERE NF_ENTRADA='<<allt(v_entradas_00.nf_entrada)>>' 
						and SERIE_NF_ENTRADA='<<allt(v_entradas_00.serie_nf_entrada)>>'  
						and NOME_CLIFOR='<<allt(v_entradas_00.nome_clifor)>>'
						
						INSERT INTO ESTOQUE_PROD1_SAI 
						(ROMANEIO_PRODUTO,FILIAL,PRODUTO,COR_PRODUTO,QTDE,
						SA_1,SA_2,SA_3,SA_4,SA_5,SA_6,SA_7,SA_8,SA_9,
						SA_10,SA_11,SA_12,SA_13,SA_14,SA_15,SA_16) 
						SELECT
						'T'+RIGHT(LTRIM(RTRIM(B.NF_ENTRADA)),6) AS ROMANEIO_PRODUTO
						,'ATACADO' AS FILIAL,A.PRODUTO,A.COR_PRODUTO,A.QTDE,
						EN_1,EN_2,EN_3,EN_4,EN_5,EN_6,EN_7,EN_8,EN_9,
						EN_10,EN_11,EN_12,EN_13,EN_14,EN_15,EN_16
						FROM ESTOQUE_PROD1_ENT A 
						JOIN ESTOQUE_PROD_ENT B 
						ON A.ROMANEIO_PRODUTO=B.ROMANEIO_PRODUTO 
						AND A.FILIAL=B.FILIAL
						WHERE B.NF_ENTRADA='<<allt(v_entradas_00.nf_entrada)>>' 
						and B.SERIE_NF_ENTRADA='<<allt(v_entradas_00.serie_nf_entrada)>>'  
						and B.NOME_CLIFOR='<<allt(v_entradas_00.nome_clifor)>>'
												

					endtext


					if !f_insert(xinsert2) 
						messagebox("Não foi possível Ajustar as Movimentações RBX",48,"Atenção!")
						retu .f.
					ELSE 
						messagebox("Movimentação Ajustada com Sucesso",48,"Atenção!")
					endif

				

	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_saida_avulsa 
**************************************************