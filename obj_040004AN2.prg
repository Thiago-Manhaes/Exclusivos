* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Bloquear botoes de busca ultimo preco compra e alteracao de custo de produto com entrada no estoque                                                                                                     *
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
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				WITH thisform	
					.addobject("calcula_custo","calcula_custo")
					.lx_PAGEFRAME1.page1.addobject("rel_custos","rel_custos")					
				ENDWITH 
			

			otherwise
				return .t.				
		endcase
	endproc
enddefine




**************************************************
*-- Class:        Calcula_Custo 
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS calcula_custo AS commandbutton


	Top = 20
	Left = 560
	Height = 45
	Width = 130
	Caption = "Calcula Custos Efetivos (Produção/PA)"
	Name = "calcula_custo"
	Visible=.t.
	Enabled = .t.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Calcula os Custos com Base nos Consumos das Op's e Pedidos PA e, Registra na Tabela CT"
	wordwrap = .T.
	Anchor =0	
	
	PROCEDURE Click	
		
		IF messagebox("Deseja Calcular os Custos Efetivos de Produção/PA da Seleção corrente e Salvar na Tabela CT e CA ?",4+32+256,"Atenção!!!")=6
	
			xMsgAvisa = .t.	 
			
			Sele v_produtos_00	
			Go Top
			
			If RECCOUNT()>1
				If MESSAGEBOX("Deseja ser avisado dos produtos com custo calculado igual a zero?",4+32)=7
					xMsgAvisa = .f.
				Endif
			Endif		
			
			Scan	
				f_prog_bar("Calculando Custo do Produto : "+ALLTRIM(v_produtos_00.PRODUTO),RECNO(),RECCOUNT())
				
				text to XSEL noshow textmerge	 
						
					SELECT CONVERT(CHAR(10),ISNULL(B.DATA_FINAL_META,GETDATE()),103) AS DATA_FIM 
					FROM PRODUTOS A 
						JOIN COLECOES B ON A.COLECAO = B.COLECAO 
					WHERE PRODUTO = '<<v_produtos_00.PRODUTO>>'

				endtext	 				

				f_select(xsel,'curVerifColecao')
				
				If CTOD(curVerifColecao.DATA_FIM) >= DATE() OR thisformset.pp_ANM_PER_ALT_CUSTO_COLECAO OR 1=1
						
						f_select("EXEC LX_PREPARA_CUSTO_EFETIVO ?v_produtos_00.produto",'curDefine')
						
					If reccount()>0
						
						sele v_produtos_00
						thisformset.refresh()
							
							f_update("LX_CALCULA_CUSTO_EFETIVO_PRODUTO_CA ?v_produtos_00.PRODUTO") 
								
						
						
					
					Else	 

							o_toolbar.Botao_refresh.Click()
							o_040004.lx_form1.lx_PAGEFRAME1.ActivePage=4
							
							**** Custo CT ****
							xpreco_ct = NVL(ROUND(o_040004.px_total_produto*(1+(xFatorProd.PERC_CUSTO_PILOTAGEM/100)),2),0)
							
							**** Custo CA ****
							
							** Custo CA do produto da OP de Tranf **
							TEXT TO xSel_CustoCA_OP_Trans TEXTMERGE NOSHOW

								SELECT ISNULL(C.PRECO1,0) AS CUSTO_CA_PROD_TRAN     
								FROM PRODUTOS (nolock) A
									LEFT JOIN PRODUTO_MONTAGEM_KIT (nolock) B
									ON A.PRODUTO = B.PRODUTO
										LEFT JOIN PRODUTOS_PRECOS (nolock) C
										ON B.KIT_PRODUTO = C.PRODUTO AND
										   C.CODIGO_TAB_PRECO = 'CA'
											LEFT JOIN PRODUTOS_OPE_EXTRA (nolock) D
											ON A.PRODUTO = D.PRODUTO 
								WHERE A.PRODUTO = '<<v_produtos_00.produto>>'	

							ENDTEXT

							f_select(xSel_CustoCA_OP_Trans,'CurCustoCA')
							
							Sele v_produto_operacoes_00_rotas
							GO top

							xCustoCA = 0
								SCAN
									IF (('FACCAO' $ desc_fase_producao OR ;
									     'FACÇAO' $ desc_fase_producao OR ;
									     'FACÇÃO' $ desc_fase_producao OR ;
									     'FACCÃO' $ desc_fase_producao ) AND 'EXTERNO' $ desc_setor_producao ) OR;
									    (('EMISSAO PEDIDO' $ desc_fase_producao ) AND 'EXTERNO' $ desc_setor_producao)
															
										xCustoCA = xCustoCA + custo_sugerido
									ENDIF	
								endscan
							
							 xCustoCA = NVL(xCustoCA,0) + CurCustoCA.CUSTO_CA_PROD_TRAN 
							
							IF xCustoCA > 0
							
								text to xupdt_custoCA noshow textmerge 
									
									UPDATE PRODUTOS_PRECOS SET PRECO1=<<xCustoCA>> WHERE PRODUTO='<<allt(v_produtos_00.produto)>>' 
									AND CODIGO_TAB_PRECO='CA'
									
								endtext	 	 
								
								f_update(xupdt_custoCA)	 
						
							 ENDIF			   
							 
							 IF xpreco_ct > 0
							 				
								text to xupdt_custoCT noshow textmerge 
									
									UPDATE PRODUTOS_PRECOS SET PRECO1=<<xpreco_ct>> WHERE PRODUTO='<<allt(v_produtos_00.produto)>>' 
									AND CODIGO_TAB_PRECO='CT'
																	
								endtext	 	 
								
								if !f_update(xupdt_custoCT)	AND xMsgAvisa = .t.
									messagebox("Não foi possível registrar o Custo do Produto "+allt(v_produtos_00.produto),48,"Atenção") 
									*retur .f. 
								endif	 
							 ELSE
								If xMsgAvisa = .t.
									MESSAGEBOX("Produto: "+allt(v_produtos_00.produto)+CHR(13)+;
											   "Custo CT calculado igual zero. Favor verificar.",64)
							 	Endif
							 ENDIF	 
							
							o_040004.lx_form1.lx_PAGEFRAME1.ActivePage=1

					Endif	
				Endif
				
				sele v_produtos_00
				
			Endscan		
			
			Sele v_produtos_00	
			Go Top
			
			o_toolbar.Botao_refresh.Click()
			f_prog_bar()
		
						
		ENDIF 	 
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: calcula_custo
**************************************************





**************************************************
*-- Class:        rel_custos
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS rel_custos AS commandbutton


	Top = 2
	Left = 600 
	Height = 45
	Width = 130
	Caption = "Relatório Custos Produtos (Produção/PA)"
	Name = "calcula_custo"
	Visible=.t.
	Enabled = .t.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Calcula os Custos com Base nos Consumos das Op's"
	wordwrap = .T.

	PROCEDURE Click	
		
		IF messagebox("Deseja Exportar Consulta para Excel ?",4+32+256,"Atenção!!!")=6	
			
			xFile = "'"+PUTFILE('Salvar como:','','xls')+"'"

			text to xsel noshow textmerge	

				select produto,desc_produto,fabricante,
				custo_reposicao1 as custo_materiais_estimado,
				custo_reposicao1 as operacoes_estimado,
				custo_reposicao1 as operacoes_extras_estimado,
				custo_reposicao1 as custo_compra_estimado,
				custo_reposicao1 as perc_pilotagem,
				custo_reposicao1 as custo_produto_estimado, 
				custo_reposicao1 as custo_materiais_efetivo,
				custo_reposicao1 as operacoes_efetivo,
				custo_reposicao1 as operacoes_extras_efetivo,
				custo_reposicao1 as custo_compra_efetivo,
				custo_reposicao1 as custo_produto_efetivo,
				grupo_produto,subgrupo_produto,colecao,griffe,linha  

				from produtos where 1=2

			endtext	

			f_select(xsel,"curProdutos")

				
			sele v_produtos_00
			count to xRegTotal
			xRegAtual = 0
			xpreco_ct = 0
			go top
			Scan	 
				
				f_select("select produto,desc_produto,fabricante,grupo_produto,subgrupo_produto,colecao,griffe,linha from produtos where produto =?v_produtos_00.produto","curSelectProd")
				
				o_toolbar.Botao_refresh.Click()
				
				xRegAtual = xRegAtual + 1
				f_prog_bar('Aguarde...   '+ALLTRIM(str(xRegAtual))+" de "+ALLTRIM(str(xRegTotal))+chr(13)+"Exportando Produto: "+allt(v_produtos_00.produto),xRegAtual,xRegTotal)
				
				o_040004.lx_form1.lx_PAGEFRAME1.ActivePage=4  && custos produto 
				

				sele curProdutos 
				appe blank	
				repla produto 						with curSelectProd.PRODUTO
				repla desc_produto					with curSelectProd.desc_PRODUTO				
				repla fabricante					with curSelectProd.fabricante 					
				repla custo_materiais_estimado		with o_040004.lx_form1.lx_PAGEFRAME1.page5.total_Material.Value 
				repla operacoes_estimado			with o_040004.lx_form1.lx_PAGEFRAME1.page5.total_Operacoes.Value 
				repla operacoes_extras_estimado		with o_040004.lx_form1.lx_PAGEFRAME1.page5.total_Op_Extra.Value 
				repla custo_compra_estimado			with o_040004.lx_form1.lx_PAGEFRAME1.page5.preco_Produto.Value
				repla perc_pilotagem				with xFatorProd.PERC_CUSTO_PILOTAGEM
				repla custo_produto_estimado		with ROUND(o_040004.px_total_produto*(1+(xFatorProd.PERC_CUSTO_PILOTAGEM/100)),2) 
				repla custo_materiais_efetivo		with o_040004.lx_form1.lx_PAGEFRAME1.page5.lx_textbox_base11.Value
				repla operacoes_efetivo				with o_040004.lx_form1.lx_PAGEFRAME1.page5.lx_textbox_base10.Value	
				repla operacoes_extras_efetivo		with o_040004.lx_form1.lx_PAGEFRAME1.page5.lx_textbox_base12.Value		
				repla custo_compra_efetivo			with o_040004.lx_form1.lx_PAGEFRAME1.page5.lx_textbox_base13.Value	
				repla custo_produto_efetivo			with o_040004.lx_form1.lx_PAGEFRAME1.page5.lx_textbox_base9.Value	 
				repla grupo_produto					with curSelectProd.grupo_produto					
				repla subgrupo_produto				with curSelectProd.subgrupo_produto		
				repla colecao						with curSelectProd.colecao 
				repla griffe						with curSelectProd.griffe	
				repla linha							with curSelectProd.linha														
				
				sele v_produtos_00
 					
			
			Endscan	 
			
			f_prog_bar()	
			
			
			
			sele v_produtos_00
			go top
			o_toolbar.Botao_refresh.Click()
			o_040004.lx_form1.lx_PAGEFRAME1.ActivePage=1
			
			sele curProdutos  
			go top	 
	

				sele curProdutos 
				copy to	&xFile xls 
			
		ENDIF 	 
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: rel_custos
**************************************************


