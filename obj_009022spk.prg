* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Alteracao conta contabil lancamento					                    *
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

*#GS.01# - Marco Banaggia - 29/03/2018 - Correção para exclusão do acompanhamento das faturas.


define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.

	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		Public xExcluirGS as Boolean, xFatura as String, xNomeClifor as String 
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
				
				case upper(xmetodo) == 'USR_INIT'  
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					xExcluirGS = .F.
					xalias=alias()
					
					thisformset.lx_form1.addObject("bt_importa_titulo","bt_importa_titulo")
					thisformset.lx_FORM1.bt_importa_titulo.visible = .T.

						Public xDataOld,xLancOld,xEmissaoOld 
						
			             with thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar	 	
						

								.addObject("lb_conta_contabil","lb_conta_contabil")
								.lb_conta_contabil.Height = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.Height
								.lb_conta_contabil.Left  = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.left
								.lb_conta_contabil.Top = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.top
								.lb_conta_contabil.Width = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.width
								.lb_conta_contabil.Caption = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.Caption 
								.label_conta_contabil.visible=.f.								
								.label_conta_contabil.top=-1000								
								.addObject("lb_rateio_centro_custo","lb_rateio_centro_custo")
								.lb_rateio_centro_custo.Height = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.Height
								.lb_rateio_centro_custo.Left  = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.left
								.lb_rateio_centro_custo.Top = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.top
								.lb_rateio_centro_custo.Width = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.width
								.lb_rateio_centro_custo.Caption = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.Caption 
								.label_rateio_centro_custo.visible=.f.								
								.label_rateio_centro_custo.top=-1000
								.parent.parent.parent.addObject("lb_confere_entrada","lb_confere_entrada")								

								
								
			              endwith	
		
						  thisformset.lx_form1.addObject("bt_altera_data","bt_altera_data")
						  
					
					if !f_vazio(xalias)
						sele &xalias
					endif	
					
					
					
					case upper(xmetodo) == 'USR_SEARCH_AFTER'  
				
				
					xalias=alias()
					
						f_select("select 1 as teste from parametros_users where parametro = 'anm_altera_data_lanc' and usuario = ?wusuario and valor_atual_user = '.T.'","xUser")
						
						sele xUser
						IF xUser.teste = 1
							thisformset.lx_FORM1.bt_altera_data.visible = .T.
						ENDIF
						
					if !f_vazio(xalias)
						sele &xalias
					endif
					
					
					
					case upper(xmetodo) == 'USR_ALTER_BEFORE'  
				
				
					xalias=alias()
					
						thisformset.lx_FORM1.bt_altera_data.visible = .F.
						
					if !f_vazio(xalias)
						sele &xalias
					endif
					
					
					
					case upper(xmetodo) == 'USR_CLEAN_AFTER'  
				
					xalias=alias()
					
						if type("thisformset.lx_form1.lb_confere_entrada")<>"U"
							thisformset.lx_form1.lb_confere_entrada.caption=''
							thisformset.lx_FORM1.bt_altera_data.visible = .F.
						endif	
					
					
					if !f_vazio(xalias)
							sele &xalias
					endif
					*#GS.01#
					CASE UPPER(xmetodo) == 'USR_ITEN_DELETE_AFTER'
						IF Thisformset.p_filha_atual = "V_CTB_ACOMPANHAMENTO_00"
							xFatura = ALLTRIM(thisformset.lx_form1.lx_pageframe1.page2.lx_lanc_auxiliar1.tx_FATURA.value)
							xNomeClifor = ALLTRIM(thisformset.lx_form1.lx_pageframe1.page2.lx_lanc_auxiliar1.tv_NOME_CLIFOR.value)
							*MESSAGEBOX("Excluir o acompanhamento da Fatura " + xFatura + " do Fornecedor: " + xNomeClifor + " ?")
							xExcluirGS = .T.
						ENDIF
					*#GS.01#	
					case upper(xmetodo) == 'USR_SAVE_AFTER'	
					
						if  xExcluirGS == .T.
								TEXT TO xSql TEXTMERGE NOSHOW 
								DELETE CTB_ACOMPANHAMENTO 
								WHERE 
								LANCAMENTO IN	(
												SELECT 
												LANCAMENTO
												FROM CTB_ACOMPANHAMENTO WHERE LANCAMENTO IN (
												SELECT CTB_LANCAMENTO FROM ENTRADAS WHERE FATURA IN ('<<xFatura>>') AND NOME_CLIFOR = '<<xNomeClifor>>')
												)  							
								ENDTEXT 
								
								try
									f_execute(xSql)
									*MESSAGEBOX(xSql)
									xExcluirGS = .F.
								CATCH
									MESSAGEBOX("Erro ao excluir acompanhamento!"+CHR(13)+CHR(10)+"Informe ao Suporte",16,"Atenção")
								ENDTRY						
						endif	
						
					case upper(xmetodo) == 'USR_REFRESH'
						
						if type("thisformset.lx_form1.lb_confere_entrada")<>"U"
							thisformset.lx_form1.lb_confere_entrada.caption = ''
							thisformset.lx_form1.lb_confere_entrada.refresh()
							
							If thisformset.lx_FORM1.bt_altera_data.caption == "Salvar" AND !f_vazio(xDataOld) AND !f_vazio(xLancOld)
								if MESSAGEBOX("Alteração da data não foi salva, deseja salvar alteração?",4+32)=6
									update V_CTB_LANCAMENTO_01_A_PAGAR SET EMISSAO = xEmissaoOld WHERE LANCAMENTO = xLancOld
									thisformset.lx_FORM1.bt_altera_data.click()
									
								else	
									with thisformset.lx_FORM1
										.bt_altera_data.caption = "Data:"
									    .tx_DATA_LANCAMENTO.Enabled= .F.
									    .tx_DATA_LANCAMENTO.value = xDataOld
									endwith
									
									o_toolbar.Botao_refresh.Click()
									sele V_CTB_LANCAMENTO_01
									update V_CTB_LANCAMENTO_01 SET DATA_LANCAMENTO = xDataOld WHERE LANCAMENTO = xLancOld
									update V_CTB_LANCAMENTO_01_A_PAGAR SET EMISSAO = xEmissaoOld WHERE LANCAMENTO = xLancOld
								endif
							Endif	
						endif	
						
						TEXT TO xselentrada TEXTMERGE NOSHOW
						
							SELECT A.ROMANEIO_PRODUTO,B.NF_ENTRADA,B.NOME_CLIFOR,B.DATA_DIGITACAO
							FROM ESTOQUE_PROD_ENT A
							RIGHT JOIN ENTRADAS B
							ON A.NF_ENTRADA = B.NF_ENTRADA
							AND A.NOME_CLIFOR = B.NOME_CLIFOR
							JOIN PRODUCAO_RECURSOS C
							ON B.NOME_CLIFOR = C.NOME_CLIFOR
							JOIN W_PRODUCAO_ORDEM_HIST_OS D
							ON B.NF_ENTRADA = D.NF_ENTRADA
							AND C.DESC_RECURSO = D.DESC_RECURSO
							WHERE B.NF_ENTRADA = REPLACE('<<V_CTB_LANCAMENTO_01_A_PAGAR.FATURA>>','F','')
							AND B.NOME_CLIFOR = '<<V_CTB_LANCAMENTO_01_A_PAGAR.NOME_CLIFOR>>' 
							AND B.COD_TRANSACAO = 'ENTRADAS_108'
							AND D.FASE_PRODUCAO1 = '021'
						
						ENDTEXT
						
						f_select(xselentrada,"Cur_confere_estoque_ent")
						
						text to xsel noshow textmerge	
					
							SELECT ORDEM_PRODUCAO FROM W_PRODUCAO_ORDEM_HIST_OS A
							JOIN PRODUCAO_RECURSOS B
							ON A.DESC_RECURSO1 = B.DESC_RECURSO
							WHERE INDICADOR_TIPO_MOV = '5' 
							AND B.NOME_CLIFOR = '<<V_CTB_LANCAMENTO_01_A_PAGAR.NOME_CLIFOR>>'
							AND A.NF_ENTRADA = REPLACE('<<V_CTB_LANCAMENTO_01_A_PAGAR.FATURA>>','F','')
			
						endtext	

						f_select(xsel,"curRetrabalho")
						
						text to xselMaterial noshow textmerge	
					
							SELECT REQ_MATERIAL FROM ESTOQUE_SAI_MAT 
							WHERE NF_ENTRADA = REPLACE('<<V_CTB_LANCAMENTO_01_A_PAGAR.FATURA>>','F','')
							AND SERIE_NF_ENTRADA = '<<V_CTB_LANCAMENTO_01_A_PAGAR.FATURA_SERIE>>'
							AND NOME_CLIFOR = '<<V_CTB_LANCAMENTO_01_A_PAGAR.NOME_CLIFOR>>'
							AND FILIAL_FATURAMENTO = REPLACE(LTRIM(RTRIM('<<V_CTB_LANCAMENTO_01_ITEM.DESC_RATEIO_FILIAL>>')),' 100%','')
			
						endtext	

						f_select(xselMaterial,"curDevMaterial")
					
					if type("thisformset.lx_form1.lb_confere_entrada")<>"U"	
						sele Cur_confere_estoque_ent						
						IF RECCOUNT()>0
							 if f_vazio(Cur_confere_estoque_ent.ROMANEIO_PRODUTO) AND DTOS(Cur_confere_estoque_ent.DATA_DIGITACAO) >= '20110815'
							 	thisformset.lx_form1.lb_confere_entrada.caption = 'NF SEM ENTRADA'
							 else 	
								sele curRetrabalho
								if reccount()>0 					
									thisformset.lx_form1.lb_confere_entrada.caption='PCP COM DEVOLUÇÃO'
									thisformset.lx_form1.lb_confere_entrada.refresh()
								else
									thisformset.lx_form1.lb_confere_entrada.caption = ''
									thisformset.lx_form1.lb_confere_entrada.refresh()
								endif	
							 endif	
						ELSE
							sele curDevMaterial
							if reccount()>0
								thisformset.lx_form1.lb_confere_entrada.caption = 'MATERIAL COM DEVOLUÇÃO'
								thisformset.lx_form1.lb_confere_entrada.refresh()
							else
								sele curRetrabalho
								if reccount()>0 					
									thisformset.lx_form1.lb_confere_entrada.caption='PCP COM DEVOLUÇÃO'
									thisformset.lx_form1.lb_confere_entrada.refresh()
								else	
									thisformset.lx_form1.lb_confere_entrada.caption = ''
									thisformset.lx_form1.lb_confere_entrada.refresh()
								endif	
							endif	
						ENDIF
					endif	

				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE




**************************************************
*-- Class:        label_conta_contabil (c:\temp\label_conta_contabil.vcx)
*-- ParentClass:  lx_label (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/13/11 01:48:13 PM
*
DEFINE CLASS lb_conta_contabil AS lx_label


	Name = "lb_conta_contabil"
	Enabled = .t.
	Visible = .t.

	PROCEDURE DblClick
		
		dodefault()
		
		IF thisformset.p_tool_status='P'		

			xalias=alias()

			f_select("select valor_atual from parametros where parametro='anm_users_alteracao_cp'","tmpUsersCp",alias())
			
			text to xsel noshow textmerge	
				select * from users
				where usuario in (<<allt(tmpUsersCp.valor_atual)>>)	
				and upper(usuario)='<<upper(wusuario)>>'
			endtext	 
			
			f_select(xsel,"curUsersCp",alias())
			

			sele curUsersCp
			if reccount()=0
				Messagebox("Você não tem Permissão para Alterar esta Informação!",48,"Atenção!")
				retu .f.
			endif

			
			If messagebox("Deseja Alterar a Conta deste Lancamento?",4+32+256,"Atenção!!!")=6 
			
				xnewCont=inputbox("Digite a Nova Conta Contábil.","")
				

				f_select("select * from ctb_conta_plano where conta_contabil=?xnewCont","tmpCrExist") 
				
				sele tmpCrExist 
				if reccount()=0
					messagebox("A Conta Contábil "+allt(xnewCont)+" Não Existe!"+chr(13)+"Verifique!",48,"Atenção!" ) 
					retu .f. 
				endif	
								
				
				text to	xUpdt noshow textmerge	
					
					update ctb_lancamento_item set conta_contabil='<<allt(xnewCont)>>' 
					where lancamento='<<v_ctb_lancamento_01_item.lancamento>>' 
					and   empresa='<<v_ctb_lancamento_01_item.empresa>>'				
					and   item='<<v_ctb_lancamento_01_item.item>>'


					update a set a.conta_contabil='<<allt(xnewCont)>>' 
					from entradas_item a 
					join 
						(select distinct	a.nf_entrada,a.serie_nf_entrada,a.nome_clifor 
						from entradas_item a 
						join entradas b 
						on  a.nf_entrada=b.nf_entrada 
						and a.serie_nf_entrada=b.serie_nf_entrada 
						and a.nome_clifor=b.nome_clifor 
						join 
							(select b.nome_clifor,a.* from ctb_a_pagar_fatura a 
							join cadastro_cli_for b 
							on a.cod_clifor=b.cod_clifor) ft
						on ltrim(rtrim(a.nf_entrada))=ft.DOCUMENTO
						and a.serie_nf_entrada=ft.fatura_serie 
						and a.nome_clifor=ft.nome_clifor
						join ctb_lancamento d 
						on ft.lancamento=d.lancamento 
						and ft.empresa=d.empresa
						join ctb_lancamento_item e 
						on e.lancamento=d.lancamento 
						and e.empresa=d.empresa 
						where e.lancamento='<<v_ctb_lancamento_01_item.lancamento>>'
						and   e.empresa   =<<v_ctb_lancamento_01_item.empresa>>
						and   a.conta_contabil='<<v_ctb_lancamento_01_item.conta_contabil>>'  ) b 
					on a.nf_entrada=b.nf_entrada 
					and a.serie_nf_entrada=b.serie_nf_entrada 
					and a.nome_clifor=b.nome_clifor 
					where a.conta_contabil='<<v_ctb_lancamento_01_item.conta_contabil>>' 

										
				endtext	
				
				if !f_vazio(xnewCont)

					if !f_update(xUpdt)
						messagebox("Não foi possível alterar a Conta deste Lancamento!",48,"Atenção!")
						retu .f.
					endif	
					
					o_toolbar.Botao_refresh.Click()  
					
					messagebox("Lançamento Alterado com Sucesso!",48,"Atenção!")
						
				endif		
					
					
			Endif	
			
			

			if !f_vazio(xalias)
				sele &xalias
			endif	

		ENDIF 		
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: label_conta_contabil
**************************************************



**************************************************
*-- Class:        lb_rateio_centro_custo (c:\temp\label_rateio_centro_custo.vcx)
*-- ParentClass:  lx_label (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/13/11 01:49:09 PM
*
DEFINE CLASS lb_rateio_centro_custo AS lx_label

	Enabled = .t.
	Visible = .t.
	Name = "lb_rateio_centro_custo"

	PROCEDURE DblClick
		
		dodefault()
		
		IF thisformset.p_tool_status='P'		

			xalias=alias()

			f_select("select valor_atual from parametros where parametro='anm_users_alteracao_cp'","tmpUsersCp",alias())
			
			text to xsel noshow textmerge	
				select * from users
				where usuario in (<<allt(tmpUsersCp.valor_atual)>>)	
				and upper(usuario)='<<upper(wusuario)>>'
			endtext	 
			
			f_select(xsel,"curUsersCp",alias())
			

			sele curUsersCp
			if reccount()=0
				Messagebox("Você não tem Permissão para Alterar esta Informação!",48,"Atenção!")
				retu .f.
			endif

			
			If messagebox("Deseja Alterar o CR deste Lancamento?",4+32+256,"Atenção!!!")=6 
			
				xnewCont=inputbox("Digite o Novo CR.","")
				
				f_select("select * from ctb_centro_custo_rateio where rateio_centro_custo=?xnewCont","tmpCrExist") 
				
				sele tmpCrExist 
				if reccount()=0
					messagebox("O CR "+allt(xnewCont)+" Não Existe!"+chr(13)+"Verifique!",48,"Atenção!" ) 
					retu .f. 
				endif	
				
				text to	xUpdt noshow textmerge	
					
					update ctb_lancamento_item set rateio_centro_custo='<<allt(xnewCont)>>' 
					where lancamento='<<v_ctb_lancamento_01_item.lancamento>>' 
					and   empresa='<<v_ctb_lancamento_01_item.empresa>>'				
					and   item='<<v_ctb_lancamento_01_item.item>>'
										
				endtext	
				
				if !f_vazio(xnewCont)

					if !f_update(xUpdt)
						messagebox("Não foi possível alterar o CR deste Lancamento!",48,"Atenção!")
						retu .f.
					endif	
					
					o_toolbar.Botao_refresh.Click()  

					messagebox("Lançamento Alterado com Sucesso!",48,"Atenção!")
					
				endif		
					
					
			Endif	
			
			

			if !f_vazio(xalias)
				sele &xalias
			endif	

		ENDIF 		
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: label_rateio_centro_custo
**************************************************




**************************************************
*-- Class:        lb_confere_entrada(c:\temp\lb_confere_entrada.vcx)
*-- ParentClass:  lx_label (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/13/11 01:49:09 PM
*
DEFINE CLASS lb_confere_entrada AS lx_label

	Enabled = .t.
	Visible = .t.
	Name = "lb_confere_entrada"
	Height = 20 
	Left  = 585
	Top = 80
	Width =	50
	fontsize = 11
	fontbold = .T.
	ForeColor = RGB(255,0,0)
	Caption = ""	



ENDDEFINE
*
*-- EndDefine: lb_confere_entrada 
**************************************************

**************************************************
*-- Class:        bt_saida_avulsa (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_altera_data AS botao


	Top = 25
	Left = 140
	Height = 22
	Width = 45
	FontBold = .T.
	Caption = "Data:"
	TabIndex = 5
	Name = "bt_altera_data"
	Visible = .F.


	PROCEDURE Click
		
		xDataOld = ""
		xLancOld = ""
		
		IF thisformset.lx_FORM1.bt_altera_data.caption == "Data:"
				sele V_CTB_LANCAMENTO_01
				xDataOld = V_CTB_LANCAMENTO_01.DATA_LANCAMENTO
				xLancOld = V_CTB_LANCAMENTO_01.LANCAMENTO
				sele V_CTB_LANCAMENTO_01_A_PAGAR
				xEmissaoOld = V_CTB_LANCAMENTO_01_A_PAGAR.EMISSAO
					
				with thisformset.lx_FORM1
					.bt_altera_data.caption = "Salvar"
				    .tx_DATA_LANCAMENTO.Enabled= .T.
				endwith    
			thisformset.lx_FORM1.lx_pageframe1.page2.Lx_lanc_auxiliar1.tx_EMISSAO.Value='01/01/2050'
		ELSE 		
				f_insert("UPDATE CTB_LANCAMENTO SET DATA_LANCAMENTO = ?V_CTB_LANCAMENTO_01.DATA_LANCAMENTO WHERE LANCAMENTO = ?V_CTB_LANCAMENTO_01.LANCAMENTO")
				o_toolbar.Botao_refresh.Click()
				*MESSAGEBOX("Alterado com Sucesso",0+64)
				
				with thisformset.lx_FORM1
					.bt_altera_data.caption = "Data:"
				    .tx_DATA_LANCAMENTO.Enabled= .F.
				endwith
		ENDIF
				
					
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_saida_avulsa 
**************************************************

**************************************************
*-- Class:        bt_importa_titulo (c:\users\wallace.pacheco\desktop\bt_importa_titulo.vcx)
*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   16/04/18 16:48:14 PM
*
DEFINE CLASS bt_importa_titulo AS botao


	Top = 80
	Left = 350
	Height = 23
	Width = 110
	Caption = "Importar Impostos"
	Name = "bt_importa_titulo"


	PROCEDURE Click
*!*					If f_vazio(v_clientes_varejo_00.rede_lojas)
*!*						MESSAGEBOX("Rede de Loja não informada, Favor selecionar uma!",64)
*!*						Thisformset.lx_FORM1.cmb_desc_rede_loja.SetFocus()
*!*						RETURN .f.
*!*					Endif


		if this.parent.parent.p_tool_status $ 'I,A'
			f_msg(['Para importar a planilha não pode estar em modo de Inclusão ou Alteração',16,'Atenção'])
			return .f.	
		else 
		
		
			xarquivo = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")
			
				if empty(NVL(xarquivo,''))
					messagebox("Operação Cancelada!",0+64,"Arquivo Inválido!")
					return .f.
				endif

				F_wait("Importando as informações, Aguarde...")
			
			if len(xarquivo) > 0 and file(xarquivo)
				create cursor xcur_tmp (TIPO C(14),TIPO_LANCAMENTO C(14),DESC_SOLICITACAO C(14),VENCIMENTO C(10),;
				TERCEIRO C(6),CONTA_CONTABIL C(6),CENTRO_CUSTO C(8),RATEIO_FILIAL C(6),BENEFICIARIO C(2),AGENCIA C(5),CONTA_N C(10),;
				VALOR C(10),FATURA C(15),SERIE C(2))

*!*					if used("xcur_tmp")
*!*						use in xcur_tmp
*!*					endif	
									
				sele xcur_tmp
				VLC_MAcro = "append FROM '" + ALLTRIM(xarquivo)  +"' type xls "
				&VLC_MAcro
				
					SELECT xcur_tmp 
					*BROWSE normal
					
					*SELECT v_ctb_acompanhamento_00_consulta
					*BROWSE normal
				
				SELECT * FROM xcur_tmp  ;
				WHERE tipo <> 'tipo' INTO CURSOR xcur
				
				if RECCOUNT() > 0
					GO top
					
					SELECT xcur
					*BROWSE normal
					GO top
					SCAN
					
					TEXT to	xinsert noshow
					
							exec LX_GS_IMPORTA_ITP_IMPOSTOS ?xcur.vencimento, ?xcur.terceiro, ?xcur.rateio_filial, ?xcur.conta_contabil, ?xcur.centro_custo, ?xcur.fatura, ?xcur.serie, ?xcur.valor, ?xcur.tipo_lancamento

					ENDTEXT
					
					f_insert(xinsert)
					
						*If !f_update(xupdt)
*!*							Messagebox("Não foi possível Inserir o Acompanhamento")
*!*						ELSE
*!*							Messagebox("Acompanhamento gerado com sucesso!!!")
*!*						Endif

					Release xinsert
					
					ENDSCAN
** Verificará se todos itens foram importados					
*!*						SELECT * FROM xcur INTO CURSOR cur_not_import
*!*						browse normal 
*!*						
*!*						IF RECCOUNT()>0
*!*							IF MESSAGEBOX("Alguns itens não foram importados, deseja exportar para Excel?",32+4)=6
*!*								xSetFile = "'"+PUTFILE("Salvar como","","xls")+"'"
*!*								COPY TO &xSetFile xls
*!*							ENDIF

*!*							*USE IN cur_not_import
*!*						ENDIF
					
					f_wait()
					
					Messagebox("Gravação dos Impostos Concluída!!!")

*!*						If	!f_vazio(xalias)
*!*							Sele &xalias
*!*						Endif
				endif
*
			endif 
		ENDIF

	ENDPROC
ENDDEFINE
*
*-- EndDefine: bt_importa_titulo
**************************************************

