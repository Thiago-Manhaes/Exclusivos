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
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
			
				*A pedido da larissa manna - Lucas Miranda - 08/08/2014
				thisformset.lx_FORM1.lx_pageframe1.page1.tv_rateio_filial.Value='000990'		
				

					
			
				
			  f_select ('select DESC_COLECAO  from colecoes','curColecao',ALIAS())
			  SELECT curColecao 
			  APPEND BLANK 
				
              WITH thisformset.lx_form1.lx_PAGEFRAME1.page1
					.addObject("bt_exporta_materiais","bt_exporta_materiais")
					.addObject("cmbColecao","cmbColecao")
					.addObject("lblColecao","lblColecao")		
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
				
				
            
            CASE UPPER(xmetodo)=='USR_SAVE_BEFORE' 
	           	
	           	xalias=alias()
	           	
		           	**AJUSTE PARA GRAVAR NO BANCO 
		           	SELECT V_COMPRAS_01
		           	REPLACE COLECAO WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value				 
				  			   		
				 	***** COLOCAR CUSTO NOS MATERIAIS QUANDO MATERIAL NAO CONTEM CUSTO **********
				   	SELE V_COMPRAS_01_MATERIAIS
				   	GO TOP
				   
				   	SCAN
				   		
				   		SELE V_COMPRAS_01_MATERIAIS
				   		f_update("UPDATE MATERIAIS_CORES SET CUSTO_A_VISTA =?V_COMPRAS_01_MATERIAIS.CUSTO WHERE CUSTO_A_VISTA = 0 AND MATERIAL = ?V_COMPRAS_01_MATERIAIS.MATERIAL AND COR_MATERIAL =?V_COMPRAS_01_MATERIAIS.COR_MATERIAL")

				   	ENDSCAN		
					***** FIM ***** JULIO **** 19-03-2013 ******************************************
					
					
				   Sele V_compras_01_reservas
				   xReg = RECCOUNT()
				   Go Top
				   
				   xMsg  = ''
				   XQMat = 0
				   xCont = 0
				   
				   Scan 		 	
				 		
				 		IF V_compras_01_reservas.Reserva > 0
					 		xCont = xCont + 1
					 		f_prog_bar("Consultando Estoque Disp. - Material: ";
					 		           +ALLTRIM(V_compras_01_reservas.Material)+" | Cor: "+ALLTRIM(V_compras_01_reservas.Cor_Material)+CHR(13)+;
					 		            "Aguarde ... "+ALLTRIM(STR(ROUND((xCont/xReg)*100,0)))+"% Concluido",xCont,xReg)
					 		           
					 		Text To xSelEDisp TextMerge NoShow
					 		
					 			SELECT * FROM FX_ANM_ESTOQUE_MAT_DISP('<<V_compras_01.Pedido>>','') 
					 			WHERE MATERIAL 	   		= '<<V_compras_01_reservas.Material>>' 		AND
					 			      COR_MATERIAL 		= '<<V_compras_01_reservas.Cor_Material>>' 	AND
					 			      QTDE_ESTOQUE_DISP 	< <<V_compras_01_reservas.Reserva>>
					   		
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
						MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível do Material:" + CHR(13) + xMsg,64)
						RETURN .f.
					Else	
						If XQMat > 1
							MESSAGEBOX("Quantidade Reservada Maior que Quantidade Disponível dos Materiais:" + CHR(13) + xMsg,64)
							RETURN .f.
						Endif
					Endif
					
					Sele V_compras_01_reservas
				    Go Top
					
				
				if !f_vazio(xalias)	
					sele &xalias
				endif
			
			
				
			CASE UPPER(xmetodo)=='USR_SEARCH_BEFORE'
				SELECT V_COMPRAS_01
	          	REPLACE COLECAO WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value
			    thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.f.
			   
			   
			CASE UPPER(xmetodo)=='USR_SEARCH_AFTER'                
				thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.f.
				thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais.visible = .T.		
			
			CASE UPPER(xmetodo)=='USR_CLEAN_AFTER'
				
				if type("thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais")<>"U"
					thisformset.lx_form1.lx_PAGEFRAME1.page1.bt_exporta_materiais.visible = .F.
					thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.T.
				endif		
				
			CASE UPPER(xmetodo)=='USR_REFRESH'                
				
				xalias=alias()
				
					TRY
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value=v_compras_01.colecao 
					
						
						If thisformset.p_tool_status="I"
						*A pedido da larissa manna - Lucas Miranda - 08/08/2014
						thisformset.lx_FORM1.lx_pageframe1.page1.tv_rateio_filial.Value='000990'
						thisformset.lx_FORM1.lx_pageframe1.page1.tx_desc_rateio_filial.Value='RBX FABRICA 100%'
						thisformset.lx_form1.lx_PAGEFRAME1.page1.tv_rateio_filial.refresh()
						Endif 
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_filial_a_entregar.refresh()
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.tv_rateio_filial.valid()
						
			
						*replace colecao WITH '' IN  v_compras_01
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.valid()
						
						 
					CATCH 
					
					endtry 
				
				if !f_vazio(xalias)	
					sele &xalias
				endif	
				
				
			CASE UPPER(xmetodo)=='USR_INCLUDE_AFTER' 
			
			thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.t.
			*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.value='' 
			
			CASE UPPER(xmetodo)=='USR_ALTER_AFTER' 	
			
				thisformset.lx_form1.lx_PAGEFRAME1.page1.cmbColecao.enabled=.t.
				
			otherwise
				return .t.				
		endcase
	endproc
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