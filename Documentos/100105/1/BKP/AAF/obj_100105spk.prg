* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao campo Filial Estoque em funcao das entradas RBX/TRIMIX
*TRATAMENTO PARA FATURAMENTO RBX/TRIMIX E MOVIMENTACAO ESTOQUE ATAACDO/ESTOQUE CENTRAL						                    *
********************************************************************************************************************* 


******************************************************
*- Programa Base de Criação de Objeto de Entrada
********************************************************************
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
				
					xalias=alias()
				
						*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_faturamento_05 
						sele v_faturamento_05  
						xalias_faturam=alias()

		  				oCur = getcursoradapter(xalias_faturam)
						oCur.addbufferfield("FILIAL_ESTOQUE", "C(25)",.T., "FILIAL_ESTOQUE", "FATURAMENTO.FILIAL_ESTOQUE")				
						oCur.confirmstructurechanges() 	
						**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 

						public xfiliais_estoque 
						
						ThisFormSet.lX_FORM1.lx_pageframe1.page8.CK2.Value = 1
						ThisFormSet.lX_FORM1.lx_pageframe1.page8.CK2.Enabled = .F.
						ThisFormSet.lX_FORM1.lx_pageframe1.page8.Ck_Filial_Destino.Value = 1
						ThisFormSet.lX_FORM1.lx_pageframe1.page8.Ck_Filial_Destino.Enabled = .F.
					
					
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
					sele v_faturamento_05_estoque_sai1_mat   
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("ESTOQUE_SAI1_MAT.ANM_STATUS_SAIDA_ITEM", "L",.T., "ANM_STATUS_SAIDA_ITEM", "ESTOQUE_SAI1_MAT.ANM_STATUS_SAIDA_ITEM")																
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 			
					
					*** #xml ** Inicio alteração ****
					IF Type('Thisformset.pp_anm_hab_finalizar_revisao') <> 'U' AND Thisformset.pp_anm_hab_finalizar_revisao
						WITH Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1
									 .parent.addobject("bt_gera_pedido","bt_gera_pedido")	
			                         .AddColumn(1)
			                         .Column1.Name='col_Liberar_revisao'
			            	WITH .col_Liberar_revisao
	                            .RemoveObject("text1")
					            .BackColor = RGB(251,245,220)
					            .Header1.Name='h_check_revisao'
					            .h_check_revisao.Caption=' '
				                   .AddObject('ck_Liberar_revisao','CheckBox')
					            .Sparse= .F.
					            .CurrentControl = 'ck_Liberar_revisao'
					            .ck_Liberar_revisao.Caption=""
					            .ck_Liberar_revisao.Visible = .T.
	                            .Width=16
	                            .ControlSource="V_FATURAMENTO_05_ESTOQUE_SAI1_MAT.ANM_STATUS_SAIDA_ITEM"
			                ENDWITH	
	                   ENDWITH
					
				   	Bindevent(Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_Liberar_revisao.ck_Liberar_revisao, "Click", This, "Anm_Ctrl_Check", 1)
				  ENDIF 	
*!*				
*!*					xalias=alias()
					
*!*						with thisformset.lx_form1.lx_PAGEFRAME1.page1
*!*							.parent.page2.addobject("bt_gera_pedido","bt_gera_pedido")	
*!*						endwith	

*!*						Bindevent(Thisformset.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_Liberar_revisao.ck_Liberar_revisao, "Click", This, "Anm_Ctrl_Check", 1)	
				
				
*!*				if !f_vazio(xalias)
*!*					sele &xalias
*!*				endif	
				**** Fim - #XML - Alteração *****
				

						thisformset.l_limpa()
						o_toolbar.Botao_limpa.Click()  					


	
			case UPPER(xmetodo) == 'USR_REFRESH'
	
				xalias=alias()

					If type("thisformset.lx_form1.lx_PAGEFRAME1.page2.bt_gera_pedido")<>"U"
						IF THISFORMSET.p_tool_status <> 'L'		
							*If !EMPTY(NVL(v_faturamento_05_estoque_sai1_mat.anm_status_saida_item,""))	
								*thisformset.lx_FORM1.lx_pageframe1.page2.bt_gera_pedido.Caption = "FINALIZADO"
								*thisformset.lx_FORM1.lx_pageframe1.page2.bt_gera_pedido.enabled = .f.
							*Else	
								thisformset.lx_FORM1.lx_pageframe1.page2.bt_gera_pedido.Caption = "Finalizar Revisão"
								thisformset.lx_FORM1.lx_pageframe1.page2.bt_gera_pedido.enabled = .t.
							*ENDIF
						ELSE
							thisformset.lx_FORM1.lx_pageframe1.page2.bt_gera_pedido.Caption = "Pendente Finalizar"
							thisformset.lx_FORM1.lx_pageframe1.page2.bt_gera_pedido.enabled = .t.
						ENDIF	
					Endif
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif
	
	
	
			case UPPER(xmetodo) == 'USR_VALID' 
				
					xOSFab = Thisformset.lX_FORM1.lx_pageframe1.page8.Tx_ordem_servico.Value
					f_select("SELECT RECURSO_PRODUTIVO FROM PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?xOSFab","TMPOSFab")
					
				 	If ALLTRIM(TMPOSFab.recurso_produtivo) = '101'	OR ALLTRIM(V_FATURAMENTO_05.TIPO_FATURAMENTO) = 'CONSUMIVEIS' OR ALLTRIM(V_FATURAMENTO_05.TIPO_FATURAMENTO) = 'MATERIAIS PILOTAGEM'			 	
				 		Thisformset.lX_FORM1.lx_pageframe1.page8.CK2.Value = 0
						Thisformset.lX_FORM1.lx_pageframe1.page8.Ck_Filial_Destino.Value =0
					Else						
				 		Thisformset.lX_FORM1.lx_pageframe1.page8.CK2.Value = 1
						Thisformset.lX_FORM1.lx_pageframe1.page8.Ck_Filial_Destino.Value =1
				 	Endif
				
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
						
					if	!f_vazio(xalias)	
					  sele &xalias 
				    endif	
						
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
						
			
			    ENDIF
			
			
			case UPPER(xmetodo) == 'USR_SEARCH_AFTER' OR UPPER(xmetodo) == 'USR_SAVE_AFTER' 
			
				xalias=alias()

					SELECT * FROM v_faturamento_05_estoque_sai1_mat INTO CURSOR vOLD_faturamento_05_estoque_sai1_mat READWRITE 					
					
				if	!f_vazio(xalias)	
					sele &xalias 
				endif
			
			


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
					
					
					
					*****VERIFICANDO QTDE DE FILIAIS ARMAZEM >>> NAO PODE HAVER MAIS DE UM ARMAZEM POR ENTRADA
					
					*** Modificação para forçar filial de estoque de materiais (Estoque Central)
					V_FATURAMENTO_05.FILIAL_ESTOQUE = 'ESTOQUE CENTRAL'
					*** Fim da modificação - Julio - 04-01-2012
					
					if	type("tmpArmazem")<>"U"
						sele tmpArmazem 
						use	
					endif	
						
					select * from v_faturamento_05_estoque_sai1_mat into cursor tmp_base1 where .f.
					
					sele tmp_base1
					=afields(xcampos)
					Create CURSOR vtmp_faturamento_05_estoque_sai1_mat From array xcampos
					
				
					Sele v_faturamento_05_estoque_sai1_mat 
					Go Top	
					scan	
							f_prog_bar('Verificando Qtde de Armazens...',recno(),reccount())		
							scatter to xmemvar
							sele vtmp_faturamento_05_estoque_sai1_mat 
							appe blank
							gather from xmemvar
							sele v_faturamento_05_estoque_sai1_mat  		
					endscan	
					f_prog_bar() 

					sele distinct filial from vtmp_faturamento_05_estoque_sai1_mat into cursor "tmpArmazem"
					
					sele tmpArmazem 
					if	reccount()>1
						messagebox("Não é permitido salvar Entrada com mais de uma Filial de Armazem",48,"Atenção!!!")
						retu .f.	
					else	
						sele v_faturamento_05
						repla filial_estoque with tmpArmazem.filial
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_filial_estoque.refresh() 
					endif	
									
					*****VERIFICANDO QTDE DE FILIAIS ARMAZEM >>> NAO PODE HAVER MAIS DE UM ARMAZEM POR ENTRADA

					xfilial_estoque=v_faturamento_05.filial_estoque	
					

				   	
				if	!f_vazio(xalias)
					sele &xalias			
				endif		
			
			
			
			case UPPER(xmetodo) == 'USR_GERA_IMPOSTOS' AND upper(xnome_obj)=='OBJ_METODOS_FATURAMENTO' 
			
				xalias=alias()
			
					SELECT V_FATURAMENTO_05_ITEM 
					GO TOP 
					SCAN 
						IF LEFT(ALLTRIM(V_FATURAMENTO_05.NATUREZA_SAIDA),3)='130'
							F_SELECT("SELECT MATERIAL,TIPO FROM MATERIAIS WHERE MATERIAL=?V_FATURAMENTO_05_ITEM.CODIGO_ITEM","CURMATPANO",ALIAS())
							IF CURMATPANO.TIPO='PANOS'
								SELECT V_FATURAMENTO_05_ITEM 
								REPLACE DESCRICAO_ITEM WITH 'PEÇAS CORTADAS DE '+ALLTRIM(STRTRAN(DESCRICAO_ITEM,'CORTE DE',''))  
							ENDIF		
						ENDIF	
						
						
					ENDSCAN 		
					SELECT V_FATURAMENTO_05_ITEM 
					GO TOP
			
				if	!f_vazio(xalias)
					sele &xalias			
				endif





			case UPPER(xmetodo) == 'USR_ALTER_BEFORE'
				
				xalias=alias()	
				
					TEXT TO xVerifBaixa TEXTMERGE NOSHOW
					
						SELECT LANCAMENTO FROM CTB_AVISO_LANCAMENTO_MOV 
						WHERE LANCAMENTO_MOV = REPLACE('<<V_FATURAMENTO_05.CTB_LANCAMENTO>>','...','')
						AND VALOR_MOV = '<<V_FATURAMENTO_05.VALOR_TOTAL>>'
						
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
			
			
			
*!*				case UPPER(xmetodo) == 'USR_TRIGGER_BEFORE'
*!*				
*!*					xalias=alias()
*!*						
*!*	*!*						PUBLIC xdele
*!*	*!*						
*!*	*!*						sele V_FATURAMENTO_05_ESTOQUE_SAI1_MAT
*!*	*!*						xdele = set('dele')
*!*	*!*						set dele off
*!*						
*!*					if	!f_vazio(xalias)
*!*						sele &xalias			
*!*					endif
								
		
				
				otherwise
					return .t.								
		endcase
	endproc


	Procedure Anm_Ctrl_Check

		xalias=alias()
		
		sele vOLD_faturamento_05_estoque_sai1_mat
		LOCATE FOR material = v_faturamento_05_estoque_sai1_mat.material AND cor_material = v_faturamento_05_estoque_sai1_mat.cor_material
	*	xTestValorOld = vOLD_faturamento_05_estoque_sai1_mat.anm_status_saida_item

		
		IF vOLD_faturamento_05_estoque_sai1_mat.anm_status_saida_item == .T.
		    
		    THISFORMSET.lX_FORM1.lx_PAGEFRAME1.page2.LX_GRID_FILHA1.col_Liberar_revisao.ck_Liberar_revisao.VALUE = 1
		
		ENDIF
		
	
		if !f_vazio(xalias)	
			sele &xalias
		endif	

	Endproc

ENDDEFINE



**************************************************
*-- Class:        bt_saida_avulsa (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_gera_pedido AS botao


	Top = 10
	Left = 15
	Height = 24
	Width = 140
	FontBold = .T.
	Caption = "Pendente Finalizar"
	TabIndex = 40
	Name = "bt_gera_pedido"
	Visible = .t.
	Enabled =.t.


	PROCEDURE Click
	
				if thisformset.lx_FORM1.lx_pageframe1.page2.bt_gera_pedido.Caption = "Pendente Finalizar"
				
					SELECT v_faturamento_05
					replace v_faturamento_05.nome_clifor WITH 'REVISAO MATERIA PRIMA'
					thisformset.p_pai_filtro_query = " FATURAMENTO.FILIAL+FATURAMENTO.NF_SAIDA+FATURAMENTO.SERIE_NF IN (SELECT DISTINCT FILIAL+NF_SAIDA+SERIE_NF FROM ESTOQUE_SAI1_MAT WHERE ISNULL(ANM_STATUS_SAIDA_ITEM,0) = 0  )"
					o_toolbar.Botao_procura.Click()
				else					
					if messagebox("Deseja Finalizar a Revisão do Itens Marcados?",4+32+256,"Atenção!")=6	
						
						xFiltroFunc = ""
						SELECT v_faturamento_05_estoque_sai1_mat
						GO TOP
						SCAN
							IF v_faturamento_05_estoque_sai1_mat.anm_status_saida_item == .T.
								sele vOLD_faturamento_05_estoque_sai1_mat
								LOCATE FOR MATERIAL = v_faturamento_05_estoque_sai1_mat.material AND COR_MATERIAL = v_faturamento_05_estoque_sai1_mat.cor_material AND REQ_MATERIAL = v_faturamento_05_estoque_sai1_mat.req_material AND FILIAL = v_faturamento_05_estoque_sai1_mat.filial
								
								IF NVL(vOLD_faturamento_05_estoque_sai1_mat.anm_status_saida_item,.F.) == .F. 
									xFiltroFunc = xFiltroFunc +"( B.REQ_MATERIAL = /"+v_faturamento_05_estoque_sai1_mat.req_material+"/ AND B.MATERIAL = /"+v_faturamento_05_estoque_sai1_mat.material+"/ AND B.COR_MATERIAL = /"+v_faturamento_05_estoque_sai1_mat.cor_material+"/) OR"
								ENDIF
								
							SELECT v_faturamento_05_estoque_sai1_mat
							ENDIF
						ENDSCAN
						
						IF EMPTY(xFiltroFunc)
							MESSAGEBOX('Os Materiais selecionados já foram Finalizados.',64)
						ELSE	
							xFiltroFunc = LEFT(xFiltroFunc,LEN(xFiltroFunc)-2)		

	                                              sele v_faturamento_05_estoque_sai1_mat
												  GO TOP
												  	
	                                              TEXT TO xExecProc TEXTMERGE NOSHOW

	                                                     EXECUTE LX_ANM_GERA_PEDIDO_OL_FAT_ITEM  '<<v_faturamento_05_estoque_sai1_mat.filial>>','<<v_faturamento_05_estoque_sai1_mat.nf_saida>>',
	                                                                                             '<<v_faturamento_05_estoque_sai1_mat.serie_nf>>','DEPOSITO RBX','<<xFiltroFunc>>'     

	                                              ENDTEXT


								if !f_update(xExecProc)
									RETURN .f.
								endif
								
								MESSAGEBOX('Revisão Finalizada com sucesso!',64)
								
								sele v_faturamento_05_estoque_sai1_mat
								GO top

								SCAN
									sele vold_faturamento_05_estoque_sai1_mat 
									LOCATE FOR MATERIAL = v_faturamento_05_estoque_sai1_mat.material AND COR_MATERIAL = v_faturamento_05_estoque_sai1_mat.cor_material AND REQ_MATERIAL = v_faturamento_05_estoque_sai1_mat.req_material AND FILIAL = v_faturamento_05_estoque_sai1_mat.filial
									
									REPLACE anm_status_saida_item WITH v_faturamento_05_estoque_sai1_mat.anm_status_saida_item 

								sele v_faturamento_05_estoque_sai1_mat

								ENDSCAN	
						 ENDIF
							
							sele v_faturamento_05_estoque_sai1_mat
							GO top	
					 endif
				 endif
	
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_saida_avulsa 
**************************************************

