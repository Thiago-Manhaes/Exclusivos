* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HOR�RIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Alteracao centro custo lancamento					                    *
********************************************************************************************************************* 

* Altera��o ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HOR�RIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Cria��o de Objeto de Entrada                                                                    *
********************************************************************************************************************* 
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
********************************************************************************************************************* 
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execu��o para facilitar o desenvolvimento *
********************************************************************************************************************* 
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
********************************************************************************************************************* 

define class obj_entrada as custom
	*- Nome do metodo/fun��o que os objetos linx v�o chamar.

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


		******************** Metodo chamado pelos Objetos na Valida��o
		*   USR_VALID -> Return .f. N�o deixa o Usuario sair do objeto.

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
			              
					*** WALLACE PACHECO - 19/09/2016 - PROJETO TI N� 329141	***
					** incluir o bot�o **
				     with thisformset.Lx_form_filtros
					.addobject("CmdImportar","bt")
					.CmdImportar.Height = 23
					.CmdImportar.Top = 208
					.CmdImportar.Width = 112
					.CmdImportar.Left = 512

				     endwith
					*** FIM - WALLACE PACHECO - 19/09/2016 - PROJETO TI N� 329141	***	


					
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
									--n�o posso travar se o aviso for de outra matriz contabil	
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
									--n�o posso travar se o aviso for de outra matriz contabil	
									and d.MATRIZ = e.MATRIZ
									and a.cod_clifor not in
											( select COD_FILIAL from FILIAIS)			
						ENDTEXT

					
						If !f_select( strSqlSid,"tmp_AvisosSid")
							f_msg("'Erro na Busca dos Avisos De D�bito',  favor verificar.', 16, wusuario")
							f_wait()
							Return .f.
						EndIf

						If tmp_AvisosSid.qtde_aviso_debito > 0
							f_msg("'Existe(m)  ' + Alltrim(Str(tmp_AvisosSid.qtde_aviso_debito)) + " + ;
								"'  T�tulos com Aviso(s) de D�bito vencido(s),  favor verificar.', 16, wusuario")
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
				Messagebox("Voc� n�o tem Permiss�o para Alterar esta Informa��o!",48,"Aten��o!")
				retu .f.
			endif

			
			If messagebox("Deseja Alterar a Conta deste Lancamento?",4+32+256,"Aten��o!!!")=6 
			
				xnewCont=inputbox("Digite a Nova Conta Cont�bil.","")
				

				f_select("select * from ctb_conta_plano where conta_contabil=?xnewCont","tmpCrExist") 
				
				sele tmpCrExist 
				if reccount()=0
					messagebox("A Conta Cont�bil "+allt(xnewCont)+" N�o Existe!"+chr(13)+"Verifique!",48,"Aten��o!" ) 
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
						messagebox("N�o foi poss�vel alterar a Conta deste Lancamento!",48,"Aten��o!")
						retu .f.
					endif	
					
					o_toolbar.Botao_refresh.Click()  
					
					messagebox("Lan�amento Alterado com Sucesso!",48,"Aten��o!")
						
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
				Messagebox("Voc� n�o tem Permiss�o para Alterar esta Informa��o!",48,"Aten��o!")
				retu .f.
			endif

			
			If messagebox("Deseja Alterar o CR deste Lancamento?",4+32+256,"Aten��o!!!")=6 
			
				xnewCont=inputbox("Digite o Novo CR.","")
				
				f_select("select * from ctb_centro_custo_rateio where rateio_centro_custo=?xnewCont","tmpCrExist") 
				
				sele tmpCrExist 
				if reccount()=0
					messagebox("O CR "+allt(xnewCont)+" N�o Existe!"+chr(13)+"Verifique!",48,"Aten��o!" ) 
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
						messagebox("N�o foi poss�vel alterar o CR deste Lancamento!",48,"Aten��o!")
						retu .f.
					endif	
					
					o_toolbar.Botao_refresh.Click()  

					messagebox("Lan�amento Alterado com Sucesso!",48,"Aten��o!")
					
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
*** WALLACE PACHECO - 05/10/2016 - PROJETO TI N� 329141
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
			f_msg(['Para importar a planilha n�o pode estar em modo de Inclus�o ou Altera��o',16,'Aten��o'])
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
					
					** Zera marca��es da tela
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

					*f_wait("Verificando e Selecionando T�tulos")
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
*!*								"'  T�tulos com Aviso(s) de Cr�dito vencido(s),  favor verificar.', 16, wusuario")
*!*						Endif

					*Messagebox(pnContador,0,"Total de Registos Selecionados")
					*Messagebox(nValBTRSel,0,"nValBTRSel")
					
					*SELECT * FROM xcuror_tela WHERE lancamento is null INTO CURSOR xcuror_tela_relatorio
					
					IF pnContador > 0
						
						SELECT linha, cnpj_cpf_fornecedor, nome_fornecedor, nf_fatura, data_vencimento , valor, iif(NVL(lancamento,0)=0,'','S') as selecionado FROM xcuror_tela INTO CURSOR xcuror_tela_relatorio
						
						SELECT xcuror_tela_relatorio
						******************** EXPORTA PARA EXCEL Cursor Comiss�o***************************
						IF MESSAGEBOX("Deseja Exportar para os lancamentos n�o encontrados?",4+32)=6
						xnomearq ='REL_Nao_Importados_'+DTOs(DATE())+'.XLS'
						xpatharq=PUTFILE('REL_Nao_Importados:',xnomearq,'XLS')                                                                                
						if EMPTY(xpatharq)                                                                                                          
						                CANCEL 
						endif
						COPY TO (xpatharq)  XLS   
						ENDIF   
						***********************************************************************

						Release pnContador, nValIAC, nValBTR, nValBTRSel
						
						Messagebox("Para ATUALIZAR os TOTAIS clique em um dos titulos selecionados e selecione novamente!!!",0,"Sele��o Finalizada!!!!")
					
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
*-- FIM - WALLACE PACHECO - 05/10/2016 - PROJETO TI N� 329141 
**************************************************

