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
		
		*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017
	 	TRY 							
			If TYPE("Thisformset.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl
				If ! o_gs.l_ver_rede_loja_prod('o_150011',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
					RETURN .f.
				Endif
			Endif
		CATCH					
		ENDTRY
		*!* Fim - Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017
		
			do case
				
			******* incluir campo tipo caixa *********************************	
				case UPPER(xmetodo) == 'USR_INIT'
				
					xalias=alias()
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
					*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
					If TYPE("Thisformset.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl 
						PUBLIC o_gs as Object
						o_gs = NEWOBJECT("obj_gs_classes_rede_loja","linx\exclusivo\obj_gs_classes_rede_loja.prg")
					Endif
					*!* Fim - Declara Função obj_gs_classes_rede_loja ao Iniciar Tela rede loja produto *!* LUCAS MIRANDA 19/12/2017
					
						f_select("select tipo as desc_tipo,tipo from vendas_tipo","curVendasTipo")
						
						with thisformset.lx_form1
								.lx_pageframe1.page3.addobject("cmb_tipo_venda","cmb_tipo_venda")	
						endwith			
					
										
					if !f_vazio(xalias)	
						sele &xalias
					endif

					
				
				case upper(xmetodo) == 'USR_VALID'
				
				IF upper(xnome_obj)='TV_NOME_CLIFOR'  
					
					xalias=alias()
					
						replace v_faturamento_caixas_00.nome_clifor_entrega WITH v_faturamento_caixas_00.nome_clifor
					
						f_select("select COD_CLIENTE,CODIGO_TAB_PRECO,TIPO from CLIENTES_ATACADO where cod_cliente =?v_faturamento_caixas_00.clifor","CurTipoCliTemp") 
						*thisformset.lx_FORM1.Lx_pageframe1.page3.Cmb_tipo_venda.DisplayValue = CurTipoCliTemp.tipo
						thisformset.lx_FORM1.Lx_pageframe1.page3.cmb_tabela.Value= CurTipoCliTemp.CODIGO_TAB_PRECO
						
						f_select("select valor_atual from PARAMETROS where parametro = 'COLECAO_PADRAO'","CurColecaoTemp")					
						*thisformset.lx_FORM1.lx_pageframe1.page3.cmb_colecao.Value = CurColecaoTemp.valor_atual
						

					
					if !f_vazio(xalias)	
						sele &xalias
					endif	

				ENDIF
				
					case upper(xmetodo) == 'USR_INCLUDE_AFTER' 
					
						xalias=alias()
						
							IF thisformset.lx_FORM1.lx_pageframe1.page3.ck_sem_pedido.Value	== .T.						
								with thisformset.lx_FORM1.lx_pageframe1.page3
									.Tv_filial.Enabled = .T.
									.cmb_colecao.Enabled = .T.
									.cmb_colecao.Value = ""
									.cmb_tipo_venda.Visible = .T.
									.cmb_tipo_venda.Value = ""
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
					
					case upper(xmetodo) == 'USR_SAVE_BEFORE' 
					 
						xalias=alias()
							*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
							If TYPE("o_150011.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl 
								If xSaveBefErroClass = 1
									Return .F.
								Endif	
							Endif			
							***** Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 	
							
							
							IF thisformset.lx_FORM1.lx_pageframe1.page3.ck_sem_pedido.Value	== .T.
								IF f_vazio(thisformset.lx_FORM1.lx_pageframe1.page3.cmb_colecao.Value)
									MESSAGEBOX("Coleção não informada!",64,"Coleção Incorreta")
									RETURN .f.
								ENDIF
								
								IF f_vazio(thisformset.lx_FORM1.lx_pageframe1.page3.cmb_tipo_venda.Value)
									MESSAGEBOX("Tipo Venda não informado!",64,"Tipo Venda Incorreto")
									RETURN .f.
								ENDIF	
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

		IF thisformset.p_tool_status $ "A" AND this.p_bloqueia_na_alteracao 
			WAIT WINDOW String.Translate("Não é permitido alterar a informação") nowait 
			return .f.
		ENDIF 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmb_tipo_venda
**************************************************

