* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Alteracao centro custo lancamento					                    *
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
				
				case upper(xmetodo) == 'USR_INIT'  
				
					public xBaixacomAviso 
					xBaixacomAviso=.F. 
					
				
					xalias=alias()

					** Andre Maia - importacao do ISS
					thisformset.lx_form1.lx_pageframe1.page2.addobject('bt_iss', 'bt_iss')
					** Fim Andre Maia

					f_select("select valor_atual from parametros where parametro='ANM_BAIXA_COM_AVISO_PENDE'","curValPar",alias()) 
					
					if	curValPar.valor_atual='.F.' 
						xBaixacomAviso=.F. 
					else		
						xBaixacomAviso=.T. 					
					endif	


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

								
			              ENDWITH
			              
					*** WALLACE PACHECO - 19/09/2016 - PROJETO TI Nº 329141	***
					** incluir o botão **
				     with thisformset.Lx_form_filtros
					.addobject("CmdImportar","bt")
					.CmdImportar.Height = 23
					.CmdImportar.Top = 208
					.CmdImportar.Width = 112
					.CmdImportar.Left = 512

				     endwith
					*** FIM - WALLACE PACHECO - 19/09/2016 - PROJETO TI Nº 329141	***	


					
					if !f_vazio(xalias)
						sele &xalias
					endif	




				case upper(xmetodo) == 'USR_VALID'  

					xalias=alias()
				
				IF upper(xnome_obj)== 'CK_SELECIONAR'
					
					If thisformset.Lx_form_filtros.Grid_resultado.col_ck_SELECIONAR.ck_SELECIONAR.Value=1 and xBaixacomAviso=.F.
					
						IF ALLTRIM(data.SQLDatabase) == 'ANIMALE'
							xFiltraVenc = '20110811'
						ELSE
							IF ALLTRIM(data.SQLDatabase) == 'AF_BRANDS'
								xFiltraVenc = '20120601'
							ELSE
								xFiltraVenc = '20110811'	
							ENDIF
						ENDIF		
												
						TEXT TO strSqlSid TEXTMERGE noshow
							select 	IsNull(count(*),0) 			as qtde_aviso_debito, 
									sum(b.valor_aviso_padrao) 	as valor_aviso_padrao 
							from ctb_aviso_lancamento a  (NOLOCK)
									join w_ctb_aviso_lancamento_saldo b (nolock) on a.empresa = b.empresa and a.lancamento = b.lancamento and a.item = b.item  
									join ctb_lancamento c (nolock) on a.empresa = c.empresa and a.lancamento = c.lancamento  
									--não posso travar se o aviso for de outra matriz contabil	
									join FILIAIS d on c.COD_FILIAL=d.COD_FILIAL
									join FILIAIS e on e.COD_FILIAL= '<<v_ctb_lancamento_01.cod_filial>>'
							where 	a.valor_aviso 			> 0 									and 
									a.vencimento_real 		<= '<<v_ctb_lancamento_01.data_lancamento>>' and 
									a.cod_clifor 			= '<<Alltrim(v_Ctb_a_Pagar_Parcela_01.Cod_CliFor)>>' 	and 
									c.tipo_movimento 		= <<v_ctb_lancamento_01.tipo_movimento>> 	and 
									c.empresa 				= <<v_ctb_lancamento_01.empresa>>	and	
									b.lx_tipo_lancamento	= 'IAD'	
									and a.vencimento_real > '<<xFiltraVenc>>'
									and a.cod_clifor not in ( select cod_filial from filiais )				
									--não posso travar se o aviso for de outra matriz contabil	
									and d.MATRIZ = e.MATRIZ
									and a.cod_clifor not in
											( select COD_FILIAL from FILIAIS)			
						ENDTEXT

					
						If !f_select( strSqlSid,"tmp_AvisosSid")
							f_msg("'Erro na Busca dos Avisos De Débito',  favor verificar.', 16, wusuario")
							f_wait()
							Return .f.
						EndIf

						If tmp_AvisosSid.qtde_aviso_debito > 0
							f_msg("'Existe(m)  ' + Alltrim(Str(tmp_AvisosSid.qtde_aviso_debito)) + " + ;
								"'  Títulos com Aviso(s) de Débito vencido(s),  favor verificar.', 16, wusuario")
							thisformset.Lx_form_filtros.Grid_resultado.col_ck_SELECIONAR.ck_SELECIONAR.Value=0	
							Return .f.	
						Endif

					Endif	
					
				ENDIF



				
				IF upper(xnome_obj)== 'CMDENVIAR'  
					
						
						SELE V_CTB_LANCAMENTO_01_BAIXA_PAGAR
						GO TOP
						SCAN
						
							F_SELECT("SELECT ANM_RATEIO_PRODUCAO FROM ENTRADAS WHERE CTB_LANCAMENTO =?V_CTB_LANCAMENTO_01_BAIXA_PAGAR.LANCAMENTO_MOV","xDescontoRateio")
							
							REPLACE V_CTB_LANCAMENTO_01_BAIXA_PAGAR.DESCONTO_EFETIVADO WITH xDescontoRateio.ANM_RATEIO_PRODUCAO
							REPLACE V_CTB_LANCAMENTO_01_BAIXA_PAGAR.DESCONTO_OBTIDO    WITH xDescontoRateio.ANM_RATEIO_PRODUCAO
						
						ENDSCAN
						
						SELE V_CTB_LANCAMENTO_01_BAIXA_PAGAR
						GO TOP
						SCAN
							
							Thisformset.lX_FORM1.lx_pageframe1.page2.Lx_lanc_auxiliar1.Frame_valores.Page1.Tx_DESCONTO_OBTIDO.L_desenhista_recalculo()

						ENDSCAN	
				
				ENDIF
					
				IF upper(xnome_obj)== 'TX_CREDITO'
				
					SELE V_CTB_LANCAMENTO_01_ITEM
					GO TOP
					
					Thisformset.lX_FORM1.lx_pageframe1.ActivePage =2
					
					SELE V_CTB_LANCAMENTO_01_BAIXA_PAGAR
					GO TOP
					SCAN
								
						Thisformset.lX_FORM1.lx_pageframe1.page2.Lx_lanc_auxiliar1.Frame_valores.Page1.Tx_DESCONTO_OBTIDO.L_desenhista_recalculo()

					ENDSCAN	
					
					Thisformset.lX_FORM1.lx_pageframe1.ActivePage =1
				
				ENDIF
				
				
				
				
				
				if !f_vazio(xalias)
					sele &xalias
				endif
				
				
				case upper(xmetodo) == 'USR_WHEN' 

					xalias=alias()
				
					
					IF (upper(xnome_obj)== 'TX_DESCONTO_OBTIDO' OR  upper(xnome_obj)== 'Tx_SALDO_DESCONTO_EFETIVADO')
					
						IF (V_CTB_LANCAMENTO_01_BAIXA_PAGAR.DESCONTO_EFETIVADO > 0)
						
							Thisformset.lX_FORM1.lx_pageframe1.page2.Lx_lanc_auxiliar1.Frame_valores.Page1.Tx_DESCONTO_OBTIDO.enabled = .F.
							Thisformset.lX_FORM1.lx_pageframe1.page2.Lx_lanc_auxiliar1.Frame_valores.Page1.Tx_SALDO_DESCONTO_EFETIVADO.enabled = .F.
				
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
*
*** WALLACE PACHECO - 05/10/2016 - PROJETO TI Nº 329141
DEFINE class bt as botao
	visible = .T.
	caption = "Imp. Arq. Banco"
	width = 100


	PROCEDURE refresh
		this.Height = 23
		this.Top = 208
		this.Width = 112
		this.Left = 512
		
	endproc


	PROCEDURE CLICK
		*if this.parent.parent.p_tool_status $ 'I,A'
		if this.parent.parent.p_tool_status $ ''
			f_msg(['Para importar a planilha não pode estar em modo de Inclusão ou Alteração',16,'Atenção'])
			return .f.	
		else 
			xarquivo = GETFILE('XLS','Arquivo:','Importar')
			if len(xarquivo) > 0 and file(xarquivo)
				create cursor xcur_tmp (cnpj_cpf_fornecedor C(18), nome_fornecedor C(50), data_operacao D, data_vencimento D, ;
				taxa_operacao N(16,2), nosso_numero c(10), numero_operacao c(20), nf_fatura c(20), valor N(16,2) , status_pagamento c(10))
					
							
				sele xcur_tmp 
				VLC_MAcro = "append FROM '" + ALLTRIM(xarquivo)  +"' type xls "
				&VLC_MAcro
				
					SELECT xcur_tmp
					*BROWSE normal
					
					SELECT RECNO()-1 as linha, STRTRAN(STRTRAN(STRTRAN(cnpj_cpf_fornecedor,'.',''),'/',''),'-','') as cnpj_cpf_fornecedor, nome_fornecedor, nf_fatura, ;
					valor, data_vencimento FROM xcur_tmp ;
					WHERE xcur_tmp.cnpj_cpf_fornecedor <> 'CNPJ/CPF Fornecedor' ;
					AND xcur_tmp.cnpj_cpf_fornecedor <> 'Qtde Total:' ;
					AND xcur_tmp.cnpj_cpf_fornecedor <> 'Valor Total:' ;
					INTO CURSOR xcur
					
					
					SELECT xcur
					*BROWSE normal
					
					** Zera marcações da tela
					SELECT v_Ctb_a_Pagar_Parcela_01
					SCAN
						replace v_Ctb_a_Pagar_Parcela_01.selecionar WITH 0  		 
						SELECT v_Ctb_a_Pagar_Parcela_01
					ENDSCAN
					
					Private pnContador As Integer, nValIAC as Decimal(19,2), nValBTR as Decimal(19,2), nValBTRSel as Decimal(19,2)

					pnContador 	= 0
					nValIAC		= 0.00
					nValBTR 	= 0.00	
					nValBTRSel	= 0.00

					*f_wait("Verificando e Selecionando Títulos")
					*Select (Thisform.p_controlsource_filtro)
					*BROWSE normal
					
					Select a.linha, a.cnpj_cpf_fornecedor, a.nome_fornecedor, a.nf_fatura, a.data_vencimento , a.valor, b.lancamento;
					FROM xcur a LEFT JOIN v_Ctb_a_Pagar_Parcela_01 b ON a.data_vencimento = b.vencimento AND a.valor=b.valor_original;
					AND ALLTRIM(a.nf_fatura) = ALLTRIM(STR(int(VAL(b.fatura)))) ;
					INTO CURSOR xcuror_tela;					

					SELECT xcuror_tela
					*BROWSE normal

					UPDATE a SET a.selecionar = 1 from v_Ctb_a_Pagar_Parcela_01 a JOIN xcuror_tela b ON a.lancamento = b.lancamento 
					
					sele v_Ctb_a_Pagar_Parcela_01 
					*BROWSE normal

				
					Scan


*!*								Select v_ctb_lancamento_01_item
*!*								Calculate sum(credito+debito) for lx_tipo_lancamento = "BAC" to nValIAC
*!*								Calculate sum(credito+debito) for lx_tipo_lancamento = "BTR" to nValBTR

*!*								Select v_Ctb_a_receber_Parcela_01
*!*								nRecno = recno()
*!*								
*!*								Calculate sum(valor_a_receber_padrao) for selecionar = 1 to nValBTRSel
*!*								
*!*								nValBTR = nValBTR + nValBTRSel

*!*								try
*!*									Goto nRecno
*!*								Catch
*!*									Go top
*!*								EndTry
							
							If Thisform.grid_resultado.col_ck_SELECIONAR.ck_SELECIONAR.When()
								IF v_Ctb_a_Pagar_Parcela_01.selecionar == 1
									pnContador = pnContador + 1
									*nValBTRSel = nValBTRSel + v_ctb_a_receber_parcela_01.valor_a_receber_padrao
									*Thisformset.lx_form_filtros.grid_resultado.col_ck_SELECIONAR.ck_SELECIONAR.Value = .T.	
									Replace Selecionar With 1
								endif
							ENDIF
					Endscan

*					f_wait()
*!*						If pnContador > 0
*!*							f_msg("'Existe(m)  ' + Alltrim(Str(pnContador)) + " + ;
*!*								"'  Títulos com Aviso(s) de Crédito vencido(s),  favor verificar.', 16, wusuario")
*!*						Endif

					*Messagebox(pnContador,0,"Total de Registos Selecionados")
					*Messagebox(nValBTRSel,0,"nValBTRSel")
					
					*SELECT * FROM xcuror_tela WHERE lancamento is null INTO CURSOR xcuror_tela_relatorio
					
					IF pnContador > 0
						
						SELECT linha, cnpj_cpf_fornecedor, nome_fornecedor, nf_fatura, data_vencimento , valor, iif(NVL(lancamento,0)=0,'','S') as selecionado FROM xcuror_tela INTO CURSOR xcuror_tela_relatorio
						
						SELECT xcuror_tela_relatorio
						******************** EXPORTA PARA EXCEL Cursor Comissão***************************
						IF MESSAGEBOX("Deseja Exportar para os lancamentos não encontrados?",4+32)=6
						xnomearq ='REL_Nao_Importados_'+DTOs(DATE())+'.XLS'
						xpatharq=PUTFILE('REL_Nao_Importados:',xnomearq,'XLS')                                                                                
						if EMPTY(xpatharq)                                                                                                          
						                CANCEL 
						endif
						COPY TO (xpatharq)  XLS   
						ENDIF   
						***********************************************************************

						Release pnContador, nValIAC, nValBTR, nValBTRSel
						
						Messagebox("Para ATUALIZAR os TOTAIS clique em um dos titulos selecionados e selecione novamente!!!",0,"Seleção Finalizada!!!!")
					
					ELSE
					
						Messagebox("Nenhum registro encontrado!!!",0,"Aviso!!")
					
					ENDIF
						 
*!*						If	!f_vazio(xalias)
*!*							Sele &xalias
*!*						Endif
				endif
*
			endif 
*!*			ENDIF
	
*						
*
*
	endproc 


ENDDEFINE
*
*-- FIM - WALLACE PACHECO - 05/10/2016 - PROJETO TI Nº 329141 
**************************************************

**************************************************
*
*** Andre Maia - 19/06/2018 - Importacao da planilha de ICMS
DEFINE class bt_iss as botao
	visible = .T.
	caption = "Imp. Arq. ISS"
	width = 100
	top = 375
	left = 430
	
	PROCEDURE click
		VLC_File = GETFILE('xls')

		IF !f_vazio(VLC_File)
			IF !USED('cur_iss')
				SELECT 0
				CREATE CURSOR cur_iss (a c(250), b c(250), c c(250), d c(250), e c(250), f c(250), g c(250), h c(250), i c(250), j c(250), k c(250), l c(250), m c(250), n c(250), o c(250), p c(250), q c(250), r c(250), s c(250), t c(250), u c(250))
			endif
		
			SELECT cur_iss 
			VLC_Macro = "APPEND FROM '" + vlc_file + "' xls"
			&VLC_Macro
			
			select MAX(item) as item from V_CTB_LANCAMENTO_01_ITEM WITH (buffering = .t.) into CURSOR cur_item
			SELECT cur_item
			GO top
			IF EOF()
				VLN_Item = 0
			ELSE
				VLN_Item = cur_item.item
			ENDIF
			USE IN cur_item
			
			VLN_Item = NVL(VLN_Item,0)
			
			SELECT cur_iss
			GO top
			DELETE 
			*o primeiro registro sera considerado cabecalho
			VLC_Erro = ''
			
			SCAN
				*- Procuro o itp
				TEXT TO VLC_Select TEXTMERGE noshow
					select a.lancamento, a.ITEM, a.ID_PARCELA, a.EMPRESA,a.VENCIMENTO_REAL, b.HISTORICO AS hist_itp, b.CODIGO_HISTORICO AS cod_hist_itp,  c.COD_CLIFOR, d.NOME_CLIFOR, b.CONTA_CONTABIL, VALOR_A_PAGAR, 'BAIXA SUA FATURA NR. [NTP]' as historico, 'BTP' AS COD_HISTORICO, b.MOEDA, e.DESC_CONTA, 'BAIXA DE TÍTULOS A PAGAR' as desc_tipo_lancamento, d.RAZAO_SOCIAL, d.CGC_CPF, d.RG_IE, d.UF, d.PAIS, b.RATEIO_CENTRO_CUSTO, f.DESC_RATEIO_CENTRO_CUSTO, b.RATEIO_FILIAL, g.DESC_RATEIO_FILIAL, 'BTP' AS lx_tipo_lancamento, a.VALOR_ORIGINAL, c.FATURA, c.FATURA_SERIE, c.EMISSAO, c.LX_TIPO_DOCUMENTO, a.CONTA_PORTADOR, a.VENCIMENTO, a.NUMERO_BANCARIO, a.DIAS_PRORROGADOS, a.DESCONTO_VENC, a.DATA_DESCONTO_VENC, H.TIPO_DOCUMENTO, I.DESC_CONTA AS DESC_CONTA_PORTADORA, C.COD_CLIFOR_SACADO
					from CTB_A_PAGAR_parcela a
					join CTB_LANCAMENTO_ITEM b on a.LANCAMENTO = b.LANCAMENTO and a.ITEM = b.ITEM 
					join CTB_A_PAGAR_FATURA c on a.LANCAMENTO = c.LANCAMENTO and a.ITEM = c.ITEM 
					join CADASTRO_CLI_FOR d on c.COD_CLIFOR = d.COD_CLIFOR 
					join CTB_CONTA_PLANO e on b.CONTA_CONTABIL = e.CONTA_CONTABIL  
					join CTB_CENTRO_CUSTO_RATEIO f on b.RATEIO_CENTRO_CUSTO = f.RATEIO_CENTRO_CUSTO 
					join CTB_FILIAL_RATEIO g on b.RATEIO_FILIAL = g.RATEIO_FILIAL 
					JOIN CTB_LX_DOCUMENTO_TIPO H ON C.LX_TIPO_DOCUMENTO = H.LX_TIPO_DOCUMENTO 
					LEFT JOIN CTB_CONTA_PLANO I ON A.CONTA_PORTADOR = I.CONTA_PORTADORA 
					where a.lancamento = '<<cur_iss.p>>' and a.VALOR_A_PAGAR = <<ALLTRIM(STR(VAL(cur_iss.o),10,2))>>
				ENDTEXT
				
				F_Select(VLC_Select, 'cur_tit')
				GO top
				IF EOF()
					VLC_Erro = VLC_Erro + IIF(f_vazio(VLC_Erro), '', ',') + ALLTRIM(cur_iss.p)
				ELSE
					VLN_Item = VLN_Item + 1
				
					SELECT V_CTB_LANCAMENTO_01_ITEM
					APPEND BLANK
					
					replace item 				WITH VLN_Item ,;
						 	cod_clifor 			WITH cur_tit.cod_clifor ,;
							conta_Contabil		WITH cur_tit.conta_contabil ,;
							debito				WITH cur_tit.valor_a_pagar ,;
							historico			WITH cur_tit.historico ,;
							codigo_historico 	WITH 'BTP' ,;
							RATEIO_CENTRO_CUSTO WITH CUR_TIT.rateio_centro_custo ,;
							MOEDA				WITH CUR_TIT.moeda ,;
							NOME_CLIFOR			WITH CUR_TIT.nome_clifor ,;
							DESC_cONTA			WITH CUR_TIT.desc_conta ,;
							DESC_TIPO_LANCAMENTO WITH CUR_TIT.desc_tipo_lancamento ,;
							RAZAO_SOCIAL		WITH CUR_TIT.razao_social ,;
							CGC_CPF				WITH CUR_TIT.cgc_cpf ,;
							RG_IE				WITH CUR_TIT.rg_ie,;
							UF					WITH CUR_TIT.uf ,;
							PAIS				WITH CUR_TIT.pais ,;
							DESC_RATEIO_CENTRO_CUSTO WITH CUR_TIT.desc_rateio_centro_custo ,;
							LX_TIPO_LANCAMENTO WITH CUR_TIT.lx_tipo_lancamento ,;
							DEBITO_MOEDA		WITH CUR_TIT.valor_a_pagar ,;
							CAMBIO_NA_DATA		WITH 1 ,;
							RATEIO_FILIAL		WITH CUR_TIT.rateio_filial ,;
							DESC_RATEIO_FILIAL	WITH CUR_TIT.desc_rateio_filial ,;
							id_contrapartida	WITH 1 ,;
							credito				with 0 ,;
							data_digitacao		with date() ,;
							credito_debito		with 'D' ,;
							indica_id_contabil_terceiro	with .t. ,;
							somente_lanc_contabil with .F. ,;
							credito_moeda		with 0 ,;
							conta_padrao		with .null. 
					
					SELECT V_CTB_LANCAMENTO_01_BAIXA_PAGAR
					APPEND BLANK

										
					REPLACE lancamento_mov 	WITH cur_tit.lancamento ,;
							empresa			WITH cur_tit.empresa ,;
							item_mov		WITH cur_tit.item ,;
							item			WITH vln_item ,;
							id_parcela		WITH cur_tit.id_parcela ,;
							data_pagamento	WITH wdata ,;
							cambio_na_data	WITH 1 ,;
							valor_multa_gerada	WITH 0 ,;
							valor_multa_paga	WITH 0 ,;
							valor_juros_gerado	with 0 ,;
							valor_juros_pago	WITH 0 ,;
							desconto_efetivado	WITH 0 ,;
							desconto_obtido		WITH 0 ,;
							valor_multa_paga_padrao	WITH 0 ,;
							valor_juros_pago_padrao	WITH 0,;
							desconto_efetivado_padrao	WITH 0 ,;
							valor_mov			WITH cur_tit.valor_a_pagar ,;
							valor_mov_padrao	WITH cur_tit.valor_a_pagar ,;
							saldo_principal_devido WITH cur_tit.valor_a_pagar ,;
							vencimento_real		WITH cur_tit.vencimento_real ,;
							saldo_multa_gerada	WITH 0 ,;
							historico			WITH cur_tit.hist_itp ,;
							codigo_historico	WITH cur_tit.cod_hist_itp ,;
							saldo_juros_gerado	WITH 0 ,;
							saldo_desconto_obtido	WITH 0 ,;
							total_principal_pago	WITH cur_tit.valor_a_pagar ,;
							total_multa_paga	WITH 0 ,;
							total_juros_pago	WITH 0 ,;
							indica_sacado_principal	WITH .F. ,;
							total_desconto_efetivado	WITH 0 ,;
							total_multa_gerada	WITH 0 ,;
							total_juros_gerado	WITH 0 ,;
							total_desconto_obtido	WITH 0 ,;
							valor_original		WITH cur_tit.valor_original ,;
							valor_original_padrao	WITH cur_tit.valor_original ,;
							valor_a_pagar		WITH cur_tit.valor_a_pagar ,;
							valor_a_pagar_padrao	WITH cur_tit.valor_a_pagar ,;
							valor_liquido_pago	WITH cur_tit.valor_a_pagar ,;
							fatura				WITH cur_tit.fatura ,;
							fatura_serie		WITH cur_tit.fatura_serie ,;
							emissao				WITH cur_tit.emissao ,;
							cod_clifor			WITH cur_tit.cod_clifor ,;
							lx_tipo_documento	WITH cur_tit.lx_tipo_documento ,;
							moeda				WITH cur_tit.moeda ,;
							taxa_juros			WITH 0 ,;
							taxa_multa			WITH 0 ,;
							numero_parcelas		WITH 0 ,;
							conta_portador		WITH cur_tit.conta_portador ,;
							numero_bancario		WITH cur_tit.numero_bancario 
 
					REPLACE vencimento 		WITH cur_tit.vencimento ,;
							desconto_venc	WITH cur_tit.desconto_venc ,;
							cambio_na_data_emissao	WITH 1 ,;
							DATA_DESCONTO_VENC WITH cur_tit.DATA_DESCONTO_VENC ,;
							conta_contabil	WITH cur_tit.conta_contabil ,;
							RATEIO_CENTRO_CUSTO 	WITH CUR_TIT.rateio_centro_custo ,;
							RATEIO_FILIAL	WITH CUR_TIT.rateio_filial ,;
							DESC_CONTA		WITH CUR_TIT.desc_conta ,;
							DESC_TIPO_LANCAMENTO WITH 'BAIXA DE TÍTULOS A PAGAR' ,;
							DESC_RATEIO_CENTRO_CUSTO	WITH CUR_TIT.desc_rateio_centro_custo ,;
							DESC_RATEIO_FILIAL	WITH CUR_TIT.desc_rateio_filial ,;
							CREDITO_DEBITO		WITH 'D' ,;
							LX_TIPO_LANCAMENTO	WITH 'BTP' ,;
							TIPO_DOCUMENTO		WITH CUR_TIT.TIPO_DOCUMENTO ,;
							DESC_CONTA_PORTADOR	WITH CUR_TIT.DESC_CONTA_PORTADORA ,;
							NOME_CLIFOR			WITH CUR_TIT.nome_clifor ,;
							RAZAO_SOCIAL		WITH CUR_TIT.razao_social ,;
							VALOR_LIQUIDO_PAGO_PADRAO	WITH CUR_TIT.valor_a_pagar ,;
							SALDO_PRINCIPAL_DEVIDO_PADRAO	WITH 0 ,;
							SALDO_MULTA_GERADA_PADRAO	WITH 0 ,;
							SALDO_JUROS_GERADO_PADRAO	WITH 0 ,;
							SALDO_DESCONTO_OBTIDO_PADRAO	WITH 0 ,;
							TOTAL_PRINCIPAL_PAGO_PADRAO	WITH CUR_TIT.valor_a_pagar  ,;
							TOTAL_MULTA_PAGA_PADRAO		WITH 0,;
							TOTAL_JUROS_PAGO_PADRAO		WITH 0 ,;
							TOTAL_DESCONTO_EFETIVADO_PADRAO WITH 0 ,;
							TOTAL_MULTA_GERADA_PADRAO	WITH 0 ,;
							TOTAL_JUROS_GERADO_PADRAO	WITH 0 ,;
							TOTAL_DESCONTO_OBTIDO_PADRAO	WITH 0 ,;
							PAGAMENTO_APROVADO	WITH 'N' ,;
							COD_CLIFOR_SACADO	WITH CUR_TIT.COD_CLIFOR_SACADO ,;
							VALOR_MOV_FINANCEIRO	WITH CUR_TIT.valor_a_pagar 							
				
					Thisformset.lx_calcula_valor_liquido()								
				ENDIF
			ENDSCAN
			
			USE IN cur_iss 
			
			SELECT V_CTB_LANCAMENTO_01_ITEM
			GO TOP
			
			SELECT V_CTB_LANCAMENTO_01_BAIXA_PAGAR
			GO TOP
			
			THISFORMSET.LX_FORM1.LX_PAGEFRAME1.PAGE2.REFRESH()
			
			IF !f_vAZIO(VLC_Erro)
				MESSAGEBOX('Lancamentos nao encontrados:' + VLC_Erro, 16, wusuario)
			ENDIF
		ENDIF
		
	ENDPROC
	
	PROCEDURE refresh
		DODEFAULT()
		this.Enabled = (thisformset.p_tool_status = 'I')
	ENDPROC
	
		
enddefine