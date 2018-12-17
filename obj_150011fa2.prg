* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........: 26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Somente Tabela VO para Shopping Vitoria						                    *
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
				
			******* incluir campo tipo caixa *********************************	
				case UPPER(xmetodo) == 'USR_INIT'
				
					xalias=alias()
				
						*** declarar variavel ***
						*PUBLIC xTipoCaixa
						f_select("select tipo as desc_tipo,tipo from vendas_tipo","curVendasTipo")
						
						with thisformset.lx_form1
							*	.addobject("lb_tipo_caixa","lb_tipo_caixa")
							*	.addobject("Tx_tipo_caixa","Tx_tipo_caixa")	
								.lx_pageframe1.page3.addobject("cmb_tipo_venda","cmb_tipo_venda")	
						endwith			
					
										
					if !f_vazio(xalias)	
						sele &xalias
					endif
					
*!*					case UPPER(xmetodo) == 'USR_SEARCH_AFTER'
*!*						
*!*						xalias=alias()
*!*						
*!*						     f_select("select anm_tipo_faturamento from faturamento_caixas where caixa =?v_faturamento_caixas_00.caixa","CurSelTipoCx")
*!*						     thisformset.lx_form1.Tx_tipo_caixa.value = left(CurSelTipoCx.anm_tipo_faturamento,1) 
*!*							 xTipoCaixa = CurSelTipoCx.anm_tipo_faturamento
*!*						
*!*											
*!*						if !f_vazio(xalias)	
*!*							sele &xalias
*!*						endif
*!*						
*!*						
*!*					case UPPER(xmetodo) == 'USR_ALTER_AFTER'
*!*						
*!*						xalias=alias()
*!*						
*!*						     f_select("select anm_tipo_faturamento from faturamento_caixas where caixa =?v_faturamento_caixas_00.caixa","CurSelTipoCx")
*!*						     thisformset.lx_form1.Tx_tipo_caixa.value = left(CurSelTipoCx.anm_tipo_faturamento,1)
*!*							 xTipoCaixa = CurSelTipoCx.anm_tipo_faturamento
					
			****************** fim *******************************************	
					
										
*!*						if !f_vazio(xalias)	
*!*							sele &xalias
*!*						endif
					
				
				case upper(xmetodo) == 'USR_VALID'
				
				IF upper(xnome_obj)='TV_NOME_CLIFOR'  
					
					xalias=alias()
					
						replace v_faturamento_caixas_00.nome_clifor_entrega WITH v_faturamento_caixas_00.nome_clifor
						*if upper(v_faturamento_caixas_00.nome_clifor)='SHOPPING VITORIA' and thisformset.p_tool_status $ "IA" 
						*	thisformset.lx_form1.lx_PAGEFRAME1.page3.Cmb_tabela.Value='VO'
						*endif
					
						f_select("select COD_CLIENTE,CODIGO_TAB_PRECO,TIPO from CLIENTES_ATACADO where cod_cliente =?v_faturamento_caixas_00.clifor","CurTipoCliTemp") 
						thisformset.lx_FORM1.Lx_pageframe1.page3.Cmb_tipo_venda.DisplayValue = CurTipoCliTemp.tipo
						thisformset.lx_FORM1.Lx_pageframe1.page3.cmb_tabela.Value= CurTipoCliTemp.CODIGO_TAB_PRECO
						
						f_select("select valor_atual from PARAMETROS where parametro = 'COLECAO_PADRAO'","CurColecaoTemp")					
						thisformset.lx_FORM1.lx_pageframe1.page3.cmb_colecao.Value = CurColecaoTemp.valor_atual
						
						******* SELEÇÃO DO TIPO DE FATURAMENTO NA CRIAÇÃO DA CAIXA QUANDO O CLIENTE ESTA CADASTRADO NA PROPRIEDADE 00060 *****
*!*							f_select("select valor_propriedade from propriedade_valida where propriedade = '00060' AND valor_propriedade=?v_faturamento_caixas_00.clifor","CurSelFilial",ALIAS())			
*!*							if ALLTRIM(CurSelFilial.valor_propriedade) == v_faturamento_caixas_00.clifor	
*!*								if messagebox("Esse é uma Caixa do tipo Distribuidora?",4+32,"Atenção!")=6
*!*									xTipoCaixa = 'DISTRIBUIDORA'
*!*									thisformset.lx_form1.Tx_tipo_caixa.value = 'D'
*!*								else	
*!*									xTipoCaixa = 'FABRICA'
*!*									thisformset.lx_form1.Tx_tipo_caixa.value = 'F'
*!*								endif	
*!*							else
*!*								xTipoCaixa = ''
*!*								thisformset.lx_form1.Tx_tipo_caixa.value = ''
*!*								RETURN .t.
*!*							endif	
						******* FIM DA SELEÇÃO ************************************************************************************************	
					
					if !f_vazio(xalias)	
						sele &xalias
					endif	

				ENDIF
				
*!*					IF upper(xnome_obj)='TX_CODIGO_BARRA'  
*!*						
*!*						xalias=alias()
*!*						
*!*							IF !f_vazio(xTipoCaixa)
*!*							
*!*								xTempProduto = thisformset.lx_FORM1.lx_pageframe1.page1.Lx_importa_cbar1.Tx_Codigo_Barra.Value
*!*								
*!*								TEXT TO xSelProd TEXTMERGE NOSHOW
*!*								
*!*									select a.codigo_barra,
*!*									CASE 
*!*										WHEN b.valor_propriedade = 'PRODUTO ACABADO' THEN 'DISTRIBUIDORA'
*!*										WHEN b.valor_propriedade = 'PRODUÇAO' THEN 'FABRICA'
*!*										ELSE ''	
*!*									END AS tipo_produto 
*!*									from produtos_barra a
*!*									join prop_produtos b
*!*									on a.produto = b.produto
*!*									where a.codigo_barra = '<<xTempProduto>>'

*!*								ENDTEXT
*!*								
*!*								f_select(xSelProd,"CurVerifProduto",ALIAS())
*!*								
*!*								IF UPPER(ALLTRIM(CurVerifProduto.tipo_produto)) <> UPPER(ALLTRIM(xTipoCaixa))
*!*									MESSAGEBOX("Produto incompatível com o tipo de caixa "+xTipoCaixa,0+64)
*!*									RETURN .F.					
*!*								ENDIF
*!*							ENDIF	
*!*						
*!*						if !f_vazio(xalias)	
*!*							sele &xalias
*!*						endif	

*!*					ENDIF
				

					case upper(xmetodo) == 'USR_SAVE_BEFORE' 
*!*						
						xalias=alias()
							
							**** VERIFICA SE PROPRIEDADE FOI TODA PREENCHIDA E SE ESTA COM A FILIAL CORRETA ******
							SELE curpropfaturamentocaixas
							GO TOP
							
							xCont = 0
							SCAN
								IF !EMPTY(curpropfaturamentocaixas.VALOR_PROPRIEDADE)
									xCont = xCont+1
								ENDIF
								
								SELE curpropfaturamentocaixas
							ENDSCAN
			
							IF xCont = 2
								IF V_FATURAMENTO_CAIXAS_00.FILIAL <> 'RBX IMPORTADORA'
									IF MESSAGEBOX("A Filial da Caixa Não é RBX IMPORTADORA,"+CHR(13)+"Deseja Alterá-la",4+32)=6
										REPLACE V_FATURAMENTO_CAIXAS_00.FILIAL WITH 'RBX IMPORTADORA'
										
										SELE V_FATURAMENTO_CAIXAS_00_EMBALADOS
										GO TOP
										
										SCAN
											REPLACE FILIAL WITH 'RBX IMPORTADORA'
										ENDSCAN
										GO TOP		
									
									ELSE
										RETURN .F.	
									ENDIF	
								ENDIF		
							ELSE
								IF xCont > 0 AND xCont < 2
									MESSAGEBOX("Complete os campos na aba Dados Importação",64)	
									RETURN .F.
								ENDIF
							ENDIF
							**** FIM - VERIFICA SE PROPRIEDADE POI PREENCHIDA E SE ESTA COM A FILIAL CORRETA ******
							
							
							**** VERIFICA SE PREÇO DA CAIXA ESTA IGUAL AO PREÇO DA NF ENTRADA *****
							IF xCont = 2
							
								SELECT curpropfaturamentocaixas
								LOCATE FOR ALLTRIM(PROPRIEDADE) = "01022"
								xNF_Entrada = ALLTRIM(curpropfaturamentocaixas.valor_propriedade)
								LOCATE FOR ALLTRIM(PROPRIEDADE) = "01023"
								xFornecedor= ALLTRIM(curpropfaturamentocaixas.valor_propriedade)
								f_select("Select Distinct CODIGO_ITEM,CONVERT(NUMERIC(14,2),PRECO_UNITARIO) AS PRECO_UNITARIO From ENTRADAS_ITEM Where NF_ENTRADA =?xNF_Entrada And NOME_CLIFOR =?xFornecedor","CurAnm_NF_Entrada")
								f_select("Select Distinct CODIGO_ITEM AS PRODUTO,SPACE(10) AS COR_PRODUTO,PRECO_UNITARIO AS PRECO_CAIXA,PRECO_UNITARIO AS PRECO_NF_ENTRADA From ENTRADAS_ITEM Where 1=2","CurANM_VerificaPreco")

								SELE V_FATURAMENTO_CAIXAS_00_EMBALADOS
								GO TOP
								SCAN

									SELE CurAnm_NF_Entrada
									LOCATE FOR CODIGO_ITEM = V_FATURAMENTO_CAIXAS_00_EMBALADOS.PRODUTO

									IF PRECO_UNITARIO <> V_FATURAMENTO_CAIXAS_00_EMBALADOS.PRECO1
										SELE CurANM_VerificaPreco
										APPEND BLANK 
										replace PRODUTO          WITH V_FATURAMENTO_CAIXAS_00_EMBALADOS.PRODUTO     ;
											    COR_PRODUTO      WITH V_FATURAMENTO_CAIXAS_00_EMBALADOS.COR_PRODUTO ;
								        	    PRECO_CAIXA      WITH V_FATURAMENTO_CAIXAS_00_EMBALADOS.PRECO1      ;
								        	    PRECO_NF_ENTRADA WITH CurAnm_NF_Entrada.PRECO_UNITARIO
								    ENDIF
								        
								SELE V_FATURAMENTO_CAIXAS_00_EMBALADOS
								ENDSCAN  
								SELE CurANM_VerificaPreco
								IF RECCOUNT() > 0
									MESSAGEBOX("Preço Unitário do Produto na Caixa"+CHR(13)+"Diferente do Preço Unitário da Nota Fiscal",16)
									RETURN .F.
								ENDIF	
							
							ENDIF
							**** FIM - VERIFICA SE PREÇO DA CAIXA ESTA IGUAL AO PREÇO DA NF ENTRADA *****
						
						
							
*!*							if upper(v_faturamento_caixas_00.nome_clifor)='SHOPPING VITORIA' and thisformset.lx_form1.lx_PAGEFRAME1.page3.Cmb_tabela.Value!='VO'
*!*								messagebox("Este Cliente permite somente a Tabela VO-Varejo Original")
*!*								retu .f.
*!*							endif

						if !f_vazio(xalias)	
							sele &xalias
						endif	

					
				**** incluir instrçoes para salvamento ********************
*!*						case upper(xmetodo) == 'USR_SAVE_AFTER' 
*!*						
*!*							xalias=alias()
*!*								
*!*								SELECT v_faturamento_caixas_00				
*!*								
*!*								TEXT TO XUPDATE NOSHOW TEXTMERGE
*!*										
*!*									update faturamento_caixas
*!*									set anm_tipo_faturamento = '<<xTipoCaixa>>'
*!*									where caixa =?v_faturamento_caixas_00.caixa 
*!*									and nome_clifor =?v_faturamento_caixas_00.nome_clifor
*!*										
*!*								ENDTEXT 

*!*								F_UPDATE(XUPDATE)

*!*							if !f_vazio(xalias)	
*!*								sele &xalias
*!*							endif	
					************** fim *******************************************
				
				
					case upper(xmetodo) == 'USR_INCLUDE_AFTER' 
					
						xalias=alias()
						
							IF thisformset.lx_FORM1.lx_pageframe1.page3.ck_sem_pedido.Value	== .T.						
								with thisformset.lx_FORM1.lx_pageframe1.page3
									.Tv_filial.Enabled = .T.
									.cmb_colecao.Enabled = .T.
									.cmb_tipo_venda.Visible = .T.
								endwith	
							ELSE
								with thisformset.lx_FORM1.lx_pageframe1.page3
									.cmb_colecao.Enabled = .F.
								    .Tv_filial.enabled = .F.
								    .cmb_tipo_venda.Visible = .F.
								endwith
							ENDIF
						
						if !f_vazio(xalias)	
							sele &xalias
						endif	
					
					

					
					
									
				otherwise
				return .t.				
			endcase

	endproc
ENDDEFINE	

**************************************************
*-- Class:        lb_tipo_caixa
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS lb_tipo_caixa AS lx_label


FontSize = 10
Caption = "Tipo Caixa"
Height = 18
Left = 367
Top = 162
Width = 62
TabIndex = 25
ZOrderSet = 33
visible = .t.
Name = "lb_tipo_caixa"

ENDDEFINE
*
*-- EndDefine: lb_tipo_caixa
**************************************************

**************************************************
*-- Class:        cmb_filial_estoque (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS Tx_tipo_caixa AS lx_textbox_base

fontbold = .t.
fontsize = 10
alignment = 2
Height = 23
Left = 437
TabIndex = 20
Top = 160
Width = 24
ZOrderSet = 35
Name = "Lx_tipo_caixa"
Visible = .t.
Enabled = .f.

ENDDEFINE
*
*-- EndDefine: cmb_filial_estoque
**************************************************

**************************************************
*-- Class Library:  c:\users\julio.cesar\desktop\cmb_tipo_venda.vcx
**************************************************


**************************************************
*-- Class:        cmb_tipo_venda (c:\users\julio.cesar\desktop\cmb_tipo_venda.vcx)
*-- ParentClass:  lx_combobox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   02/01/13 11:36:14 AM
*

DEFINE CLASS cmb_tipo_venda AS lx_combobox


	BoundColumn = 2
	RowSource = "curVendasTipo.desc_tipo,tipo"
	ControlSource = "thisformset.pp_tipo_venda"
	Height = 19
	Left = 490
	TabIndex = 10
	Top = 110
	Width = 169
	p_tipo_dado = "edita"
	Visible= .T.
	Enabled = .F.
	Name = "cmb_tipo_venda"


	PROCEDURE Init
		dodefault()

		xalias=alias()

			f_select("select tipo as desc_tipo,tipo from vendas_tipo","curVendasTipo") 

		if !f_vazio(xalias)
			sele &xalias 
		endif
	ENDPROC


	PROCEDURE When
		** Samuel Santos - 08/01/09
		** Processo exclusivo para bloquear campo dependendo do parametro P_BLOQUEIA_NA_ALTERACAO .. 
		** não pkdemos utilizar o padrão pois o ControlSource deste campo não é tabela.. é uma propriedade.
		*!*	if !thisformset.p_tool_status $ "IA" ;
		*!*	or reccount("v_faturamento_caixas_00_embalados") > 0 ;
		*!*	or !thisformset.px_verifica_sem_pedidos
		*!*		return .f.
		*!*	ENDIF

		IF thisformset.p_tool_status $ "A" AND this.p_bloqueia_na_alteracao 
			WAIT WINDOW String.Translate("Não é permitido alterar a informação") nowait 
			return .f.
		ENDIF 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmb_tipo_venda
**************************************************

