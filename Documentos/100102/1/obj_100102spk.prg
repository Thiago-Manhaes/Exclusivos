******************************************************
*- Programa Base de Criação de Objeto de Entrada
********************************************************************
*- OBJETIVO: IMPORTACAO DE ITENS FISCAIS RELLINX --IMPORTACAO ITENS FISCAIS NOTAS NFE FILIALS FORA MATRIZES
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos 
*******************************************************************************
*- Existem 2 parametros que influem nos objetos de Entrada:  
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento
*********************************************************************************


*********************************************************************************
* - Atencao !!!!!!!!!!!														   -*
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP -*
*********************************************************************************

*
*                 Abaixo segue Programa objeto sem Codigo 
*
*
*- Definindo a classe do objeto de entrada que sera criado na Form.
define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.
	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT
		*	USR_ALTER_BEFORE  ->Return .f. Para o Metodo
		*	USR_ALTER_AFTER    
		*	USR_INCLUDE_AFTER
		*	USR_SEARCH_BEFORE ->Return .f. Para o Metodo
		*	USR_SEARCH_AFTER
		*	USR_CLEAN_AFTER
		*	USR_REFRESH
		*	USR_SAVE_BEFORE   ->Return .f. Para o Metodo 
		*	USR_SAVE_AFTER
		*	USR_ITEN_DELETE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_DELETE_AFTER
		*	USR_ITEN_INCLUDE_BEFORE ->Return .f. Para o Metodo
		*	USR_ITEN_INCLUDE_AFTER
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Validação
		*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada
		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		do case
			*- metodo do inicio da form



			case UPPER(xmetodo) == 'USR_INIT' 
				
				public curNfeSp,xImporCaixa ,curItensImport, xImportFabDist,curItensImportFabrica,xTempFilial,xFiltro,xRegINI,xRegFIM
				
				
				curNfeSp=''
				xImporNfe=0
				curItensImport='' 
				xImportFabDist=0
				curItensImportFabrica=''
				xImporCaixa = 0
				xRegINI = 0
				xRegFIM = 0
				
				if type("thisformset.lx_FORM1.lx_pageframe1.page3.Import_Item_transf")="U" AND ;	  
				   type("thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1") !="U"
					
					xalias=alias()
					thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page1.label_emissao.top=-1000
					thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page1.label_emissao.Visible=.f.
					thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page1.addobject("label_emissao2","label_emissao2")
					thisformset.lx_FORM1.lx_pageframe1.page3.addobject("Import_Item","Import_Item")
					thisformset.lx_FORM1.lx_pageframe1.page3.addobject("Import_caixa_fabrica","Import_caixa_fabrica")
					*thisformset.lx_FORM1.lx_pageframe1.page3.addobject("Import_Item_fabrica","Import_Item_fabrica")  				
					
					
						TEXT TO xSelParam TEXTMERGE NOSHOW
						
							select isnull(valor_atual_user,valor_atual) as S_OU_N
							from PARAMETROS a left join 
							(select * from PARAMETROS_USERS where USUARIO = ?WUSUARIO ) b 
							on a.PARAMETRO = b.PARAMETRO
							where a.PARAMETRO = 'ANM_PER_PROD_MAT_CONSUMI'
						
						ENDTEXT
						f_select(xSelParam,"CurParametro",ALIAS())
						xValorPram = CurParametro.S_OU_N
						
						with thisformset.lx_FORM1.lx_pageframe1.page3.Lx_container1
							.Ck_materiais.Visible = &xValorPram
							.Ck_produtos.Visible  = &xValorPram
							.Ck_ativos.Visible    = &xValorPram	
						endwith		
					
					if	!f_vazio(xalias)
						sele &xalias			
					endif	
				
				endif		
				


			case UPPER(xmetodo) == 'USR_CLEAN_AFTER' 
				
				if type("curNfeSp") != 'U'
					xImporNfe=0 
					curNfeSp=''				
				endif	

				if type("curItensImport") != 'U'
					curItensImport='' 
					xImportFabDist=0
				ENDIF
				
				if type("curItensImportFabrica") != 'U'
					curItensImportFabrica='' 
				endif	
				
				*thisformset.lx_FORM1.lx_pageframe1.page3.Import_Item.enabled=.T.


			case UPPER(xmetodo) == 'USR_INCLUDE_AFTER' 
				
				
				xFiltro = "''"
				xImporCaixa = 0
				
				if type("curNfeSp") != 'U'
					xImporNfe=0 
					curNfeSp=''				
				endif					

				if type("curItensImport") != 'U'
					curItensImport='' 
					xImportFabDist=0
				ENDIF
				
				if type("curItensImportFabrica") != 'U'
					curItensImportFabrica='' 
				endif	
				
				
				 

			case UPPER(xmetodo) == 'USR_ALTER_BEFORE' 
			
				xalias=alias()	
				
					if type("curNfeSp") != 'U'
						xImporNfe=0 
						curNfeSp=''				
					endif		

					if type("curItensImport") != 'U'
						curItensImport='' 
						xImportFabDist=0
					endif	
					
					if type("curItensImportFabrica") != 'U'
						curItensImportFabrica='' 
					endif	
			
			
					TEXT TO xVerifBaixa TEXTMERGE NOSHOW
					
						SELECT LANCAMENTO FROM CTB_AVISO_LANCAMENTO_MOV 
						WHERE LANCAMENTO_MOV = REPLACE('<<V_FATURAMENTO_05.CTB_LANCAMENTO>>','...','')
						
					ENDTEXT
					
					f_select(xVerifBaixa,"VerifBaixa",ALIAS())
					
					SELECT VerifBaixa
					GO top
					
					IF	RECCOUNT() > 0	
						MESSAGEBOX("Impossível Cancelar, Favor Solicitar ao Financeiro Cancelamento da Baixa: "+ALLTRIM(STR(VerifBaixa.LANCAMENTO)),0+48)
						RETURN .F.
					ENDIF
				
				if	!f_vazio(xalias)
					sele &xalias			
				endif	
				

			case UPPER(xmetodo) == 'USR_VALID' 
				
				if upper(xnome_obj)='TV_FILIAL' 
					f_select("select clifor from cadastro_cli_for where nome_clifor=?v_faturamento_05.filial","curClifor",alias())
					thisformset.LX_FORM1.LX_pageframe1.Page1.Lx_pageframe1.Page1.TV_rateio_filial.Value=curClifor.clifor
					thisformset.LX_FORM1.LX_pageframe1.Page1.Lx_pageframe1.Page1.TV_rateio_filial.l_desenhista_recalculo()
				endif	
						
			  	if upper(xnome_obj)='TX_CODIGO_ITEM'
					
						If v_faturamento_05_item.origem_item = 'M'
							Sele v_faturamento_05_item
							f_select("select top 1 material, CUSTO_REPOSICAO, CUSTO_A_VISTA from materiais_cores where custo_reposicao > 0 and material = ?v_faturamento_05_item.codigo_item","xCustoMP")
							Sele xCustoMP
							If RECCOUNT() > 0
								Replace v_faturamento_05_item.preco_unitario with xCustoMP.Custo_Reposicao
								Thisformset.lx_form1.lx_pageframe1.page3.LX_GRID_FILHA1.Col_tx_PRECO_UNITARIO.Tx_PRECO_UNITARIO.l_desenhista_recalculo
							Endif
						Endif
 
						If v_faturamento_05_item.origem_item = 'P'
							Sele v_faturamento_05_item
							xCodigoTabPreco=ALLTRIM(Thisformset.pp_anm_custo_cons_pa)
							f_select("select preco1 from produtos_precos where produto = ?v_faturamento_05_item.codigo_item and codigo_tab_preco = ?xCodigoTabPreco","xCustoPA")
							Sele xCustoPA
							If RECCOUNT() > 0
								Replace v_faturamento_05_item.preco_unitario with xCustoPA.preco1
								Thisformset.lx_form1.lx_pageframe1.page3.LX_GRID_FILHA1.Col_tx_PRECO_UNITARIO.Tx_PRECO_UNITARIO.l_desenhista_recalculo
							Endif
							Sele v_faturamento_05_item
						Endif
					endif
			  
			    IF THISFORMSET.p_tool_status = 'I' AND (upper(xnome_obj)=='TV_FILIAL' OR upper(xnome_obj)=='TV_NOME_CLIFOR')
					
					xalias=alias()
			        
			        thisformset.lx_FORM1.tv_filial.refresh()			        
                    thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.tv_transportadora.Value = THISFORMSET.lx_FORM1.tv_filial.Value 
				    thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.tv_transp_redespacho.value = THISFORMSET.lx_FORM1.tv_filial.Value   
		
				    SELE v_faturamento_05
					
					THISFORMSET.lx_FORM1.Tv_cod_filial.refresh()									
         		    thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tv_cod_filial.VALUE	
				    f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_faturamento_05.rateio_filial","curRATEIO",alias())
				    thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tx_desc_RATEIO_FILIAL.Value = curRATEIO.desc_rateio_filial
					
					* Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo filial					
					THISFORMSET.lx_FORM1.Tv_cod_filial.refresh()
					IF thisformset.lx_FORM1.TV_COD_FILIAL.value = '000991'
					   thisformset.lx_FORM1.TV_COD_FILIAL.value = '000999'
					   thisformset.lx_FORM1.TV_FILIAL.VALUE = 'ESTOQUE CENTRAL'
					ELSE
						IF thisformset.lx_FORM1.TV_COD_FILIAL.value = '000988'
						   thisformset.lx_FORM1.TV_COD_FILIAL.value = '000017' 	  
						   thisformset.lx_FORM1.TV_FILIAL.VALUE = 'ATACADO'
						ENDIF
					ENDIF		 	
					
					* Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo cliente
					THISFORMSET.lx_FORM1.Tv_clifor.refresh()
					IF thisformset.lx_FORM1.Tv_clifor.value = '000991'
					   thisformset.lx_FORM1.Tv_clifor.value = '000999'
					   thisformset.lx_FORM1.Tv_nome_clifor.VALUE = 'ESTOQUE CENTRAL'
					ELSE
						IF thisformset.lx_FORM1.Tv_clifor.value = '000988'
						   thisformset.lx_FORM1.Tv_clifor.value = '000017' 	  
						   thisformset.lx_FORM1.Tv_nome_clifor.VALUE = 'ATACADO'
						ENDIF
					ENDIF
					
				    if	!f_vazio(xalias)	
					  sele &xalias 
				    endif
			
			    ENDIF
			
				
				 IF THISFORMSET.p_tool_status = 'I' AND (upper(xnome_obj)=='TV_NOME_CLIFOR' OR upper(xnome_obj)=='TV_FILIAL') AND v_faturamento_05.natureza_saida = '123.01'
				 
						xalias=alias()
							
							IF USED("xValidaMatriz")
								SELECT xValidaMatriz
								USE
							ENDIF	
							
							IF USED("xValidaRedeLj")
								SELECT xValidaRedeLj
								USE
							ENDIF
							
							f_select("SELECT REDE_LOJAS FROM FILIAIS WHERE FILIAL =?v_faturamento_05.filial","xValidaRedeLj",ALIAS())
							
							IF xValidaRedeLj.REDE_LOJAS = '04'
								f_select("SELECT MATRIZ FROM FILIAIS WHERE FILIAL =?v_faturamento_05.nome_clifor","xValidaMatriz",ALIAS())
								xValidaDestino = v_faturamento_05.filial
							ELSE
								f_select("SELECT MATRIZ FROM FILIAIS WHERE FILIAL =?v_faturamento_05.filial","xValidaMatriz",ALIAS())
								xValidaDestino = v_faturamento_05.nome_clifor
							ENDIF	
								
								IF ALLTRIM(xValidaMatriz.Matriz) == ALLTRIM(xValidaDestino)
								
									thisformset.lx_FORM1.lx_pageframe1.page3.Import_caixa_fabrica.enabled = .T.
								
								ELSE
					
									thisformset.lx_FORM1.lx_pageframe1.page3.Import_caixa_fabrica.enabled = .F.
									
								ENDIF
							
						if	!f_vazio(xalias)	
						  sele &xalias 
					    endif	
					  	
				ELSE
					
							thisformset.lx_FORM1.lx_pageframe1.page3.Import_caixa_fabrica.enabled = .F.	
							
				ENDIF
				
			
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE'

			xalias=alias()

				thisformset.LX_FORM1.Lx_pageframe1.Page7.Ck_conferido.value	= .T.
				thisformset.LX_FORM1.Lx_pageframe1.Page7.Ck_conferido.l_desenhista_recalculo()			
				
				*****BLOQUEIA SALVAR FATURAMENTO SEM O PREENCHIMENTO DO PESO BRUTO >>> JULIO - 18/07, PARA SEGURANÇA NO GKO*****
					IF thisformset.lx_FORM1.lx_pageframe1.page1.Lx_pageframe1.Page1.Tx_peso_bruto.Value > 0
						return .t.
					ELSE
						MESSAGEBOX("NÃO É PERMITIDO SALVAR NOTA SEM O PESO BRUTO",48,"Atenção!!!")
						return .f.
					ENDIF
				*****BLOQUEIA SALVAR FATURAMENTO SEM O PREENCHIMENTO DO PESO BRUTO >>> JULIO - 18/07 PARA SEGURANÇA NO GKO*****
			
			if	!f_vazio(xalias)
				sele &xalias			
			endif
			
			
			case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
				
				If type("curNfeSp") != 'U'
					
					if xImporCaixa=1 
						
						TEXT TO xUpdCaixa TEXTMERGE NOSHOW
						
							UPDATE FATURAMENTO_CAIXAS 
							SET ANM_FATURA_FAB = '1' 
							WHERE CAIXA IN (<<xFiltro>>)
						
						ENDTEXT
						
						f_update(xUpdCaixa)
						xImporCaixa = 0
					endif	

				Endif	



				If type("curItensImport") != 'U'
					
					if xImportFabDist=1 

						sele curItensImport	
						go top	

						text to	xupdt1 noshow textmerge
							UPDATE RS_DADOS_NOTAS SET NOTA_FISCAL ='<<v_faturamento_05.nf_saida>>',DATA_EMISSAO='<<v_faturamento_05.EMISSAO>>' 
							WHERE TIPO=<<curItensImport.TIPO>> AND CASE WHEN FILIAL_ORIGEM='RBX DISTRIBUIDORA' THEN 'ESTOQUE CENTRAL' ELSE FILIAL_ORIGEM END='<<curItensImport.FILIAL_ORIGEM>>' 
							AND ID_REGISTRO BETWEEN <<curItensImport.REGISTRO_INICIAL>> AND <<curItensImport.REGISTRO_FINAL>>
							AND NOTA_FISCAL IS NULL 
						endtext
					
						if !f_update(xupdt1)
							messagebox("Não Foi Possível Marcar Item como Processado!",48,"Atenção!")
							retu .f.
						endif
					
					endif
					
					if xImportFabDist=2 

						sele curItensImport	
						go top	

						text to	xupdtRG noshow textmerge
							UPDATE TMP_NOTAS_RET_GX_RBX SET PROC_RBX = 1 
							WHERE SEQ BETWEEN '<<xRegINI>>' AND '<<xRegFIM>>'
						endtext
						
						if !f_update(xupdtRG)
							messagebox("Não Foi Possível Marcar Item como Processado!",48,"Atenção!")
							retu .f.
						endif
					
					endif	

				ENDIF



				otherwise
					return .t.				
		endcase
	endproc
enddefine


**************************************************
*-- Class:        Importa_Consumiveis 
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS Import_Item AS commandbutton


	Top = 60
	Left = 200
	Height = 20
	Width = 220
	Caption = "Importa Itens GX / RBX"
	Name = "Import_Item"
	Visible=.f.
	Enabled = .t.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Importa Itens Fiscais Gerados pelo RelLinx"
	PROCEDURE Click	
		
		thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page2.Container2.TX_VALOR_TEMPO.Value = 100.00
		
		IF MESSAGEBOX("Deseja importar os Itens Fiscais ?",4+32+256,"Atenção!!!")=6
			
			xQtde = inputbox('Quantos Itens Deseja Importar ?','Filtro Qtde','')
				IF xQtde == '' OR VAL(xQtde) = 0
					MESSAGEBOX("Digite uma qtde de Itens Válida !!!",0+64)
					RETURN .F.
				ELSE
					IF 	VAL(xQtde) > 800
						MESSAGEBOX("Somente é permitido um máximo de 400 itens por nota fiscal, Favor Alterar !!!",0+64)
						RETURN .F.
					ENDIF	
				ENDIF	
				
				
			TEXT TO XSEL_ITENS_RBX_GX NOSHOW TEXTMERGE 
					
				SELECT TOP <<xQtde>> * FROM TMP_NOTAS_RET_GX_RBX
				WHERE PROC_RBX = 0 ORDER BY SEQ
			
			ENDTEXT 
			
			f_select(XSEL_ITENS_RBX_GX,"curItensImport")	
			
			SELECT curItensImport
			GO top
			xRegINI = curItensImport.seq
			SELECT curItensImport
			GO BOTTOM
			xRegFIM = curItensImport.seq

			
			SELECT curItensImport
			GO TOP 
			SCAN 
				
				f_prog_bar("Importando Itens Fiscais... ",RECNO(),RECCOUNT())
				
				thisformset.lX_FORM1.lx_PAGEFRAME1.page3.Lx_container1.Ck_produtos.Value = .T.
				o_toolbar.Botao_filhas_inserir.Click()			
				sele V_FATURAMENTO_05_ITEM 

				repla CODIGO_ITEM with curItensImport.produto 
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()
				
				repla PRECO_UNITARIO with curItensImport.preco
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_PRECO_UNITARIO.tx_PRECO_UNITARIO.l_desenhista_recalculo()		
				
				repla QTDE_ITEM with curItensImport.qtde
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()

				
			ENDSCAN 
			
			f_prog_bar()	
			
			xImportFabDist=2
			*thisformset.lx_FORM1.lx_pageframe1.page3.Import_Item.enabled=.f.
				
			SELECT V_FATURAMENTO_05_ITEM 
			GO TOP 			
			
		ENDIF 
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: Importa_Consumiveis 
**************************************************




**************************************************
*-- Class:        Import_Item_Transf 
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS Import_caixa_fabrica AS commandbutton


	*Top = 60
	*Left = 277
	*Height = 20
	*Width = 220
	
	Top = 63
	Left = 477
	Height = 20
	Width = 220
	Caption = "caixa Estoque x Fabrica"
	Enabled = .t.
	Visible= .f.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Importa caixa EC x Fabrica"
	
	PROCEDURE Click	
		
		IF thisformset.p_tool_status!='I' and thisformset.p_tool_status!='A'  
			
			text to	xselNotaspendentes noshow textmerge	
					select distinct 
					a.caixa,a.filial,a.nome_clifor from 
					vendas_prod_embalado a
					join faturamento_caixas b
					on a.caixa = b.caixa
					where b.anm_tipo_faturamento = 'FABRICA'
					and b.anm_fatura_fab = '0'
					order by caixa
			endtext
			
			f_select(xselNotaspendentes,"curNotasPendentes" )
			brow normal noedit title  'Caixas Pendentes - Tecle Esc p/ Sair' in screen

		ELSE 		
					
				text to xselNfeSp noshow textmerge
					select distinct 
					convert(varchar(1),'') as marca,a.caixa,a.nome_clifor from 
					faturamento_caixas a
					join vendas_prod_embalado b
					on a.caixa = b.caixa
					where b.filial='<<v_faturamento_05.filial>>'
					and a.anm_tipo_faturamento = 'FABRICA'
					and a.anm_fatura_fab = '0'
					and a.caixa not in (<<xFiltro>>)
					order by caixa
				endtext 
				
				f_select(xselNfeSp,"curNfeSp" )

				brow normal title  'Digite x nas caixas que deseja Processar - Tecle Esc p/ Sair' in screen
				*SELECIONA NOTAS PARA FATURAR
				thisformset.lX_FORM1.lx_PAGEFRAME1.page3.Lx_container1.Ck_produtos.Value = .T.
				thisformset.lX_FORM1.lx_pageframe1.page3.lx_container1.Tv_CODIGO_TAB_PRECO.Value = 'VO'
				thisformset.lX_FORM1.lx_pageframe1.page3.lx_container1.Tv_CODIGO_TAB_PRECO.REFRESH()
				*INSERE FATURAMENTO ITENS SELECIONADOS
				Sele curNfeSp 
				Scan for UPPER(marca)='X'
					
					f_prog_bar("Importando Itens Fiscais... ",RECNO(),RECCOUNT())
					
					xFiltro = xFiltro+",'"+curNfeSp.caixa+"'"
					
					text to xselItemNfeSp noshow textmerge	
						
						select a.produto,a.preco1,a.qtde_embalada 
						from vendas_prod_embalado a
						join faturamento_caixas b
						on a.caixa = b.caixa
						where a.caixa = '<<curNfeSp.caixa>>'
						and b.anm_tipo_faturamento = 'FABRICA'
						and b.anm_fatura_fab = '0'
					
					endtext
					
					f_select(xselItemNfeSp,"curItensNfeSp")

					sele curItensNfeSp
					go top
					scan	 
						
						o_toolbar.Botao_filhas_inserir.Click()			
						sele v_faturamento_05_item 

						repla codigo_item with curItensNfeSp.produto 
						thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()
						
						repla qtde_item with curItensNfeSp.qtde_embalada
						thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()
						
					endscan 

				Endscan	 
				
				xImporCaixa=1
					
				f_prog_bar()					

				sele v_faturamento_05_item
				go top	
				
				sele v_faturamento_05
				
					REPLACE condicao_pgto WITH "999"
					REPLACE peso_bruto    WITH 0.001
					REPLACE volumes       WITH 1		
		
		ENDIF 	
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: Import_Item_Transf
**************************************************




**************************************************
*-- Class:        label_emissao (c:\temp\label_emissao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/09/09 12:19:07 PM
*
DEFINE CLASS label_emissao2 AS lx_label


	Name = "label_emissao2"
	Visible=.t.
	Enabled=.t.	
	Caption = "Emissão"
	Top=5
	Left=413
	height=15
	Alignment=1


	PROCEDURE DblClick
		DODEFAULT()

		xdata=inputbox("Digite a Data","Digite a Data Correta",dtoc(v_faturamento_05.emissao))

		text to xupdt noshow	textmerge
			update faturamento SET emissao='<<DTOS(CTOD(xdata))>>',data_saida='<<DTOS(CTOD(xdata))>>' 
			where nf_saida='<<v_faturamento_05.nf_saida>>' and serie_nf='<<v_faturamento_05.serie_nf>>' 
			and filial='<<v_faturamento_05.filial>>' 
		endtext	 

		if !f_update(xupdt) 

			messagebox("Não foi possível Alterar a Data do Faturamento",48,"Atenção!")
			retu .f.

		endif

		thisformset.Refresh() 

		o_toolbar.Botao_refresh.Click()

	ENDPROC


ENDDEFINE
*
*-- EndDefine: label_emissao
**************************************************


**************************************************
*-- Class:        Importa_Consumiveis 
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS Import_Item_fabrica AS commandbutton


	Top = 60
	Left = 115
	Height = 20
	Width = 165
	Caption = "Itens Fiscais Fabrica x Loja"
	Name = "Import_Item_fabrica"
	Visible=.f.
	Enabled = .t.
	FontBold=.t.
	Fontsize=8
	tooltiptext="Importa Itens Fiscais da Fabrica para Loja"
	PROCEDURE Click	
		
			
		IF MESSAGEBOX("Deseja importar os Itens Fiscais ?",4+32+256,"Atenção!!!")=6
						
			IF LTRIM(RTRIM(thisformset.lx_FORM1.Tv_filial.Value))  == 'GX NORTE FABRICA'
				xTempFilial= 'GX NORTE DISTRIBUIDORA'
			
			thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_faturamento.Value = 'SAIDA FABRICA'
			thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page2.Container2.TX_VALOR_TEMPO.Value = 100.00
			thisformset.lX_FORM1.lx_PAGEFRAME1.page3.Lx_container1.Ck_produtos.Value = .T.	
				
			TEXT TO XSEL_ITENS NOSHOW TEXTMERGE 
					
					select top 400 a.codigo_item as PRODUTO,A.QTDE,isnull(b.preco_fat,0) as PRECO
					from 
					(select distinct b.codigo_item,CONVERT(NUMERIC(14,2),1) AS QTDE
					from faturamento a
					join faturamento_item b
					on a.nf_saida=b.nf_saida
					and a.filial=b.filial
					and a.serie_nf=b.serie_nf
					where a.filial='<<v_faturamento_05.filial>>'
					and a.nome_clifor= '<<xTempFilial>>'
					and a.emissao between '20110101' and convert(datetime,convert(char(13),getdate(),112))-1) a
					left join (select produto,convert(numeric(14,2),(preco1*0.4762)) as preco_fat from produtos_precos where codigo_tab_preco='VO' ) b
					on convert(char(12),a.codigo_item)=convert(char(12),b.produto)
					
					left join

					(select distinct b.codigo_item
					from faturamento a
					join faturamento_item b
					on a.nf_saida=b.nf_saida
					and a.filial=b.filial
					and a.serie_nf=b.serie_nf
					where a.filial='<<v_faturamento_05.filial>>'
					and a.nome_clifor in (SELECT FILIAL FROM FILIAIS WHERE TIPO_FILIAL = 'LOJA VAREJO')
					and a.emissao between '20110101' and convert(datetime,convert(char(13),getdate(),112))) c
					on a.codigo_item=c.codigo_item
					where c.codigo_item is null
				
			ENDTEXT 
			
			f_select(XSEL_ITENS ,"curItensImportFabrica")	
			
			SELECT curItensImportFabrica
			GO TOP 
			SCAN 
				
				f_prog_bar("Importando Itens Fiscais... ",RECNO(),RECCOUNT())

				o_toolbar.Botao_filhas_inserir.Click()			
				sele V_FATURAMENTO_05_ITEM 

				repla CODIGO_ITEM with curItensImportFabrica.produto 
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()
				
				repla PRECO_UNITARIO with curItensImportFabrica.preco
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_PRECO_UNITARIO.tx_PRECO_UNITARIO.l_desenhista_recalculo()		
				
				repla QTDE_ITEM with curItensImportFabrica.qtde
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()
	
			ENDSCAN
			
			f_prog_bar()	
			
			RETU .f.
				
			SELECT V_FATURAMENTO_05_ITEM 
			GO TOP 	
			 
			ENDIF
			
			
			
			IF LTRIM(RTRIM(thisformset.lx_FORM1.Tv_filial.Value)) == 'RBX FABRICA'
				xTempFilial= 'RBX DISTRIBUIDORA'
				
			thisformset.lx_FORM1.lx_pageframe1.page1.lx_pageframe1.page1.tv_tipo_faturamento.Value = 'SAIDA FABRICA'	
			thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_PAGEFRAME1.page2.Container2.TX_VALOR_TEMPO.Value = 100.00
			thisformset.lX_FORM1.lx_PAGEFRAME1.page3.Lx_container1.Ck_produtos.Value = .T.	
				
			TEXT TO XSEL_ITENS NOSHOW TEXTMERGE 
					
					select top 400 a.codigo_item as PRODUTO,A.QTDE,isnull(b.preco_fat,0) as PRECO
					from 
					(select distinct b.codigo_item,CONVERT(NUMERIC(14,2),1) AS QTDE
					from faturamento a
					join faturamento_item b
					on a.nf_saida=b.nf_saida
					and a.filial=b.filial
					and a.serie_nf=b.serie_nf
					where a.filial='<<v_faturamento_05.filial>>'
					and a.nome_clifor= '<<xTempFilial>>'
					and a.emissao between '20110101' and convert(datetime,convert(char(13),getdate(),112))-1) a
					left join (select produto,convert(numeric(14,2),(preco1*0.7)) as preco_fat from produtos_precos where codigo_tab_preco='VO' ) b
					on convert(char(12),a.codigo_item)=convert(char(12),b.produto)
					
					left join

					(select distinct b.codigo_item
					from faturamento a
					join faturamento_item b
					on a.nf_saida=b.nf_saida
					and a.filial=b.filial
					and a.serie_nf=b.serie_nf
					where a.filial='<<v_faturamento_05.filial>>'
					and a.nome_clifor in (SELECT FILIAL FROM FILIAIS WHERE TIPO_FILIAL = 'LOJA VAREJO')
					and a.emissao between '20110101' and convert(datetime,convert(char(13),getdate(),112))) c
					on a.codigo_item=c.codigo_item
					where c.codigo_item is null
				
			ENDTEXT 
			
			f_select(XSEL_ITENS ,"curItensImportFabrica")	
			
			SELECT curItensImportFabrica
			GO TOP 
			SCAN 
				
				f_prog_bar("Importando Itens Fiscais... ",RECNO(),RECCOUNT())

				o_toolbar.Botao_filhas_inserir.Click()			
				sele V_FATURAMENTO_05_ITEM 

				repla CODIGO_ITEM with curItensImportFabrica.produto 
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()
				
				repla PRECO_UNITARIO with curItensImportFabrica.preco
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_PRECO_UNITARIO.tx_PRECO_UNITARIO.l_desenhista_recalculo()		
				
				repla QTDE_ITEM with curItensImportFabrica.qtde
				thisformset.lx_FORM1.lx_pageframe1.page3.lx_grid_filha1.col_tx_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()

				
			ENDSCAN 
			
			f_prog_bar()	
			
			RETU .f.
				
			SELECT V_FATURAMENTO_05_ITEM 
			GO TOP 	
			
			ENDIF
			
				
			
		ENDIF 
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: Importa_Consumiveis 
**************************************************

