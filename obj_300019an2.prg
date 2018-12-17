* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  23/05/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclui Colunas nas Views da tela			                    *
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
					
					xalias=alias()

					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT

				
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- V_LOJA_RESUMO_OPERACAO_01   
					sele V_LOJA_RESUMO_OPERACAO_01   
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALOR_LIQ_SEM_VALE", "N(14,2)",.F., "VALOR_LIQ_SEM_VALE", "")				
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALES_RECEBIDOS", "N(14,2)",.F., "VALES_RECEBIDOS", "")									
					oCur.addbufferfield("SUM(LOJA_RESUMO_OPERACAO.NUMERO_TICKETS_CANCELADOS) as SUM_NUMERO_TICKETS_CANCELADOS", "I",.F., "'SUM_NUMERO_TICKETS_CANCELADOS", "")				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
					
					
					
					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- V_LOJA_RESUMO_OPERACAO_01_OPERACOES_VENDA 
					sele V_LOJA_RESUMO_OPERACAO_01_OPERACOES_VENDA 
					xalias_filha=alias()

	  				oCur = getcursoradapter(xalias_filha)
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALOR_LIQ_SEM_VALE", "N(14,2)",.F., "VALOR_LIQ_SEM_VALE", "")				
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALES_RECEBIDOS", "N(14,2)",.F., "VALES_RECEBIDOS", "")									
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha 
					
					

					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- V_LOJA_RESUMO_OPERACAO_01_PAGAMENTOS_FORMAS 
					sele V_LOJA_RESUMO_OPERACAO_01_PAGAMENTOS_FORMAS
					xalias_filha=alias()

	  				oCur = getcursoradapter(xalias_filha)
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALOR_LIQ_SEM_VALE", "N(14,2)",.F., "VALOR_LIQ_SEM_VALE", "")				
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALES_RECEBIDOS", "N(14,2)",.F., "VALES_RECEBIDOS", "")									
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha	
					
					
					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- V_LOJA_RESUMO_OPERACAO_01_VENDEDOR 
					sele V_LOJA_RESUMO_OPERACAO_01_VENDEDOR
					xalias_filha=alias()

	  				oCur = getcursoradapter(xalias_filha)
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALOR_LIQ_SEM_VALE", "N(14,2)",.F., "VALOR_LIQ_SEM_VALE", "")				
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALES_RECEBIDOS", "N(14,2)",.F., "VALES_RECEBIDOS", "")									
					oCur.addbufferfield("SUM(Loja_resumo_operacao.numero_tickets_cancelados) as SUM_NUMERO_TICKETS_CANCELADOS", "I",.F., "SUM_NUMERO_TICKETS_CANCELADOS", "SUM_NUMERO_TICKETS_CANCELADOS")														
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha												
					


					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- V_LOJA_RESUMO_OPERACAO_01_VENDEDOR_FILIAL
					sele V_LOJA_RESUMO_OPERACAO_01_VENDEDOR_FILIAL
					xalias_filha=alias()

	  				oCur = getcursoradapter(xalias_filha)
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALOR_LIQ_SEM_VALE", "N(14,2)",.F., "VALOR_LIQ_SEM_VALE", "")				
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALES_RECEBIDOS", "N(14,2)",.F., "VALES_RECEBIDOS", "")									
					oCur.addbufferfield("SUM(Loja_resumo_operacao.numero_tickets_cancelados) as SUM_NUMERO_TICKETS_CANCELADOS", "I",.F., "SUM_NUMERO_TICKETS_CANCELADOS", "SUM_NUMERO_TICKETS_CANCELADOS")														
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha												



					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- V_Group_Temp
					sele V_Group_Temp
					xalias_filha=alias()

	  				oCur = getcursoradapter(xalias_filha)
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALOR_LIQ_SEM_VALE", "N(14,2)",.F., "VALOR_LIQ_SEM_VALE", "")				
					oCur.addbufferfield("CONVERT(NUMERIC(14,2),0) AS VALES_RECEBIDOS", "N(14,2)",.F., "VALES_RECEBIDOS", "")									
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha	



					*Inicio Inclusao Campos Novos de Produtos no Cursor Filha -- V_LOJA_RESUMO_OPERACAO_01_OPERACOES_VENDA 
					sele V_LOJA_RESUMO_OPERACAO_01_FILIAL 
					xalias_filha=alias()

	  				oCur = getcursoradapter(xalias_filha)
					oCur.addbufferfield("SUM(V_loja_resumo_operacao_01.valor_liq_sem_vale) AS VALOR_LIQ_SEM_VALE", "N(14,2)",.F., "VALOR_LIQ_SEM_VALE", "")				
					oCur.addbufferfield("SUM(V_loja_resumo_operacao_01.vales_recebidos) AS VALES_RECEBIDOS", "N(14,2)",.F., "VALES_RECEBIDOS", "")									
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Filha 
					
				
					with thisform.LX_pageframe1
						.Page1.LX_GRID_FILHA1.Cl_vales_recebidos.ControlSource ="v_loja_resumo_operacao_01.vales_recebidos"
						.Page1.LX_GRID_FILHA1.Cl_valor_sem_vales.ControlSource ="v_loja_resumo_operacao_01.valor_liq_sem_vale" 
						.Page10.LX_GRID_FILHA1.Col_vales_recebidos.ControlSource ="v_loja_resumo_operacao_01_operacoes_venda.vales_recebidos"
						.Page10.LX_GRID_FILHA1.Cl_valor_liq_sem_vale.ControlSource ="v_loja_resumo_operacao_01_operacoes_venda.valor_liq_sem_vale" 						
						.Page13.LX_GRID_FILHA1.Cl_vales_recebidos.ControlSource ="v_loja_resumo_operacao_01_linha.vales_recebidos"
						.Page13.LX_GRID_FILHA1.Cl_valor_liq_sem_vales.ControlSource ="v_loja_resumo_operacao_01_linha.valor_liq_sem_vale" 						
						.Page9.LX_GRID_FILHA1.Cl_vales_recebidos.ControlSource ="V_Loja_resumo_operacao_01_pagamentos_formas.vales_recebidos"
						.Page9.LX_GRID_FILHA1.Cl_valor_liq_sem_vale.ControlSource ="V_Loja_resumo_operacao_01_pagamentos_formas.valor_liq_sem_vale"
						.Page8.LX_GRID_FILHA1.Cl_vales_recebidos.ControlSource ="V_Loja_resumo_operacao_01_vendedor.vales_recebidos"
						.Page8.LX_GRID_FILHA1.Cl_valor_liq_sem_vale.ControlSource ="V_Loja_resumo_operacao_01_vendedor.valor_liq_sem_vale" 		
						.Page8.LX_GRID_FILHA1.Col_tickets_cancelados.ControlSource ="v_loja_resumo_operacao_01_vendedor.sum_numero_tickets_cancelados" 																							 												
						.Page17.LX_GRID_FILHA1.Cl_valor_sem_vale.ControlSource ="V_Loja_resumo_operacao_01_vendedor_filial.valor_liq_sem_vale" 		
						.Page17.LX_GRID_FILHA1.Column15.ControlSource ="V_Loja_resumo_operacao_01_vendedor_filial.vales_recebidos" 																							 																		
						.Page16.LX_GRID_FILHA1.Cl_valor_liq_sem_vale.ControlSource ="V_Group_Temp.valor_liq_sem_vale" 		
						.Page16.LX_GRID_FILHA1.Cl_vales_recebidos.ControlSource ="V_Group_temp.VALES_RECEBIDOS" 																							 																								
						.Page15.LX_GRID_FILHA1.Cl_vales_recebidos.ControlSource ="V_Loja_resumo_operacao_01_filial.vales_recebidos"
						.Page15.LX_GRID_FILHA1.Cl_valor_liq_sem_vale.ControlSource ="V_Loja_resumo_operacao_01_filial.valor_liq_sem_vale" 		
					endwith	
					
					
					
					addnewobject(thisformset.lx_FORM1.lx_pageframe1.page2,"bt_exporta","bt_exporta")								
					addnewobject(thisformset.lx_FORM1.lx_pageframe1.page2,"bt_exporta_ecf","bt_exporta_ecf")	
					addnewobject(thisformset.lx_FORM1.lx_pageframe1.page2,"bt_exporta_luc","bt_exporta_luc")		
									
				

					if !f_vazio(xalias)
						sele &xalias
					endif	

					Thisformset.L_limpa()	
					
				
					

					if	!f_vazio(xalias)	
						sele &xalias 
					endif	
				
									
																
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE




**************************************************
*-- Class:        bt_exporta_ecf (c:\documents and settings\sidnei.stellet\desktop\bt_exporta\bt_exporta_ecf.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/28/09 04:01:01 PM
*
DEFINE CLASS bt_exporta_ecf AS botao


	Top = 355
	Left = 500
	Height = 27
	Width = 120
	FontBold = .F.
	FontSize = 8
	Caption = "\<Exportar ECF"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_exporta_ecf"
	Visible = .t.
	Enabled =.t.


	PROCEDURE Click


		  
		xdata_ini='19800101'  
		xdata_fim='20201231'

		if	!f_vazio(thisformset.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.DATA_INICIAL.Value)
			xdata_ini=dtos(thisformset.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.DATA_INICIAL.Value)
		endif


		if	!f_vazio(thisformset.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.DATA_FINAL.Value)
			xdata_fim=dtos(thisformset.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.DATA_FINAL.Value)
		endif


		*xlabel_arq=substr(xdata_ini,7,2) + '_a_'+substr(xdata_fim,7,2)+substr(xdata_ini,5,2)+left(xdata_ini,4)
		xlabel_arq = substr(xdata_ini,5,2)+'_'+left(xdata_ini,4)
		


		*!*			* Inicio Exportacao Vendas
	 
			If 1=1

				* Variaveis utilizadas na Exportacao ECF

				local xarq,xhand,xreg,xsel	 


			if f_vazio(thisformset.lx_FORM1.lx_pageframe1.page2.lx_combobox1.Value)
				xfiltro_filial=''
			else
				xfiltro_filial=" where a.filial='"+allt(thisformset.lx_FORM1.lx_pageframe1.page2.lx_combobox1.Value)+"'" 
			endif


				text to	xsel_400 noshow	textmerge

					select
					convert(varchar(4),'C400') as REG,
					convert(varchar(2),'2D') as COD_MOD,
					convert(varchar(20),isnull(b.modelo,'')) as ECF_MOD, 
					convert(varchar(20),a.id_equipamento) as ECF_FAB, 
					convert(varchar(5),a.terminal) as ECF_CX,
					a.codigo_filial as CHAVE_CODIGO_FILIAL,
					a.terminal as CHAVE_TERMINAL,
					a.filial as CHAVE_FILIAL,
					a.cgc_cpf as CHAVE_CNPJ

					from 
						(select  a.codigo_filial,c.terminal,a.filial,c.id_equipamento,b.cgc_cpf  
						from lojas_varejo a 
						join filiais b 
						on a.filial=b.filial 
						join 
							(select distinct codigo_filial,terminal,id_equipamento 
							from loja_controle_fiscal 
							where data_sistema between '<<xdata_ini>>' and '<<xdata_fim>>') c 
						on a.codigo_filial=c.codigo_filial
						where b.tipo_filial='LOJA VAREJO'
						and c.terminal<>'999') a 	
						left join lcf_ecf b 
						on  a.codigo_filial=b.anm_codigo_filial 
						and a.id_equipamento=b.nr_serie
					    and a.terminal=b.terminal 
					<<xfiltro_filial>>
					order by a.codigo_filial,a.terminal,a.filial 

				endtext


*!*					*Abertura do arquivo de exportacao

*!*					xarq = wdir+'linx\exportacao\Vendas_ECF_'+xlabel_arq+'.txt'
*!*					if empty(xarq)
*!*						return (.f.)
*!*					endif

*!*					xhand = fcreate( xarq )


*!*					* Inicio Exportacao ECF

				f_select(xsel_400,'curVendasECF_400')

				sele curVendasECF_400 && Equipamentos ECF -- Registro Pai
				go top	
					
				xVerificaFilial = ''
					
				SCAN && Equipamentos ECF -- Registro Pai curVendasECF_400 
					
					IF ALLTRIM(curVendasECF_400.CHAVE_CNPJ) <> ALLTRIM(xVerificaFilial) OR f_vazio(xVerificaFilial)
						

							IF !f_vazio(xVerificaFilial)
						
								if xhand <= 0
									=F_msg(["Verifique direitos de gravação e atributos de somente leitura, ou se o arquivo já esta aberto.";
									,16,"Erro ao Criar o Arquivo"])
									return .f.
								endif

								fclose(xhand)
							
							ENDIF
							
								xVerificaFilial = ALLTRIM(curVendasECF_400.CHAVE_CNPJ)
							
							
						*Abertura do arquivo de exportacao

							xarq = wdir+'linx\exportacao\'+xVerificaFilial+'_'+xlabel_arq+'.txt'
							if empty(xarq)
								return (.f.)
							endif

							xhand = fcreate( xarq )

						* Inicio Exportacao ECF
					
					ENDIF
					
					
					f_prog_bar(UPPER(ALLTRIM(curVendasECF_400.CHAVE_FILIAL))+' - Exportando para o Arquivo : '+upper(xarq), recno(), Reccount())

					xreg = REG
					xreg = xreg + ";" + COD_MOD 	 
					xreg = xreg + ";" + ECF_MOD	 
					xreg = xreg + ";" + ECF_FAB					
					xreg = xreg + ";" + ECF_CX					
	
					fputs(xhand,left(xreg,len(xreg)-1))


					**seleciona 405
					text to	xsel_405 noshow	textmerge	

						select
						convert(varchar(4),'C405') as REG,
						convert(varchar(8),replace(convert(varchar(13),a.data_fiscal,103),'/','')) as DT_DOC,
						convert(varchar(3),a.contador_reinicio_operacao) as CRO,
						convert(varchar(6),a.qtde_reducoes_z) as CRZ, 
						convert(varchar(6),a.cf_final) as NUM_COO_FIN,
						replace(convert(varchar(17),a.gt_final),'.',',') as GT_FIN,
						replace(convert(varchar(17),a.total_bruto),'.',',') as VL_BRT,
						a.codigo_filial as CHAVE_CODIGO_FILIAL,
						a.terminal as CHAVE_TERMINAL,
						a.id_equipamento as CHAVE_ID_EQUIPAMENTO,
						a.cf_inicial as CHAVE_CF_INICIAL,
						a.ecf as CHAVE_CF_INICIAL,
						a.serie_nf as CHAVE_SERIE_NF,
						a.data_fiscal as CHAVE_DT_DOC
						from loja_controle_fiscal a 
						where a.codigo_filial='<<curVendasECF_400.CHAVE_CODIGO_FILIAL>>' 
						and   a.terminal='<<curVendasECF_400.CHAVE_TERMINAL>>'
						and   a.id_equipamento='<<curVendasECF_400.ECF_FAB>>'  
						and   a.data_sistema between  '<<xdata_ini>>' and '<<xdata_fim>>' 

					endtext
					
					f_select(xsel_405,'curVendasECF_405')
					
					sele curVendasECF_405 && Leituras Z dos equipamentos -- Registro Filha 1
					go top	
					
					Scan && Leituras Z dos equipamentos
						
						xreg = REG
						xreg = xreg + ";" + DT_DOC	 
						xreg = xreg + ";" + CRO	 
						xreg = xreg + ";" + CRZ					
						xreg = xreg + ";" + NUM_COO_FIN
						xreg = xreg + ";" + GT_FIN	 
						xreg = xreg + ";" + VL_BRT	 
						
						fputs(xhand,left(xreg,len(xreg)-1))
						
						
						**seleciona 410
*!*							text to	xsel_410 noshow	textmerge	


*!*								--C410 INICIO--------

*!*								select
*!*								convert(varchar(4),'C410') as REG,
*!*								convert(varchar(17),' ') as VL_PIS,
*!*								convert(varchar(17),' ') as VL_COFINS
*!*								from loja_controle_fiscal a 
*!*								where a.codigo_filial='<<curVendasECF_400.CHAVE_CODIGO_FILIAL>>' 
*!*								and   a.terminal='<<curVendasECF_400.CHAVE_TERMINAL>>'
*!*								and   a.id_equipamento='<<curVendasECF_400.ECF_FAB>>'  
*!*								and   a.data_sistema between  '<<xdata_ini>>' and '<<xdata_fim>>' 

*!*							endtext
*!*							
*!*							f_select(xsel_410,'curVendasECF_410')
*!*							
*!*							
*!*							xreg = REG
*!*							xreg = xreg + ";" + VL_PIS	 
*!*							xreg = xreg + ";" + VL_COFINS	 
*!*							
*!*							fputs(xhand,left(xreg,len(xreg)-1))
						
						
						**seleciona 420
						text to	xsel_420 noshow	textmerge	


							--C420 INICIO--------

							--select
							--convert(varchar(4),'C420') as REG,
							--convert(varchar(7),'COD_TOT_PAR') as COD_TOT_PAR, 
							--convert(varchar(17),sum(total_tarifa)) as VLR_ACUM_TOT,
							--convert(varchar(2),'01') as NR_TOT,
							--convert(varchar(2),' ') as DESCR_NR_TOT,
							--a.codigo_filial as CHAVE_CODIGO_FILIAL,
							--a.terminal as CHAVE_TERMINAL,
							--a.id_equipamento as CHAVE_ID_EQUIPAMENTO,
							--a.cf_inicial as CHAVE_CF_INICIAL,
							--a.ecf as CHAVE_CF_INICIAL,
							--a.serie_nf as CHAVE_SERIE_NF,
							--b.codigo_fiscal_operacao as CHAVE_CODIGO_FISCAL_OPERACAO 
							--from loja_controle_fiscal a 
							--join loja_controle_fiscal_tarifas b 
							--on  a.CODIGO_FILIAL=b.CODIGO_FILIAL 
							--and a.TERMINAL=b.TERMINAL 
							--and a.DATA_FISCAL=b.DATA_FISCAL 
							--and a.ECF=b.ECF 
							--and a.ID_EQUIPAMENTO=b.ID_EQUIPAMENTO 
							--and a.SERIE_NF=b.SERIE_NF 
							--and a.CF_INICIAL=b.CF_INICIAL 
							--where a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
							--and   a.data_fiscal='<<curVendasECF_405.DT_DOC>>'
							--and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
							--and   a.id_equipamento='<<curVendasECF_405.CHAVE_ID_EQUIPAMENTO>>' 
							--and   a.cf_inicial='<<curVendasECF_405.CHAVE_CF_INICIAL>>'
							--group by a.data_fiscal,a.codigo_filial,a.terminal,a.id_equipamento,
							--b.codigo_fiscal_operacao,a.ecf,a.serie_nf,a.cf_inicial 
							
							select 
							convert(varchar(4),'C420') as REG,
							replace(replace(replace(convert(varchar(8),'01'+legenda_tarifa),',',''),'%',''),'.','') as COD_TOT_PAR,
							replace(convert(varchar(17),sum(total_tarifa)),'.',',') as VLR_ACUM_TOT,
							convert(varchar(2),'01') as NR_TOT,
							convert(varchar(2),' ') as DESCR_NR_TOT,
							a.codigo_filial as CHAVE_CODIGO_FILIAL,
							a.terminal as CHAVE_TERMINAL,
							a.id_equipamento as CHAVE_ID_EQUIPAMENTO,
							a.cf_inicial as CHAVE_CF_INICIAL,
							a.ecf as CHAVE_CF_INICIAL,
							a.serie_nf as CHAVE_SERIE_NF  
							from loja_controle_fiscal a 
							join loja_controle_fiscal_tarifas b 
							on  a.CODIGO_FILIAL=b.CODIGO_FILIAL 
							and a.TERMINAL=b.TERMINAL 
							and a.DATA_FISCAL=b.DATA_FISCAL 
							and a.ECF=b.ECF 
							and a.ID_EQUIPAMENTO=b.ID_EQUIPAMENTO 
							and a.SERIE_NF=b.SERIE_NF 
							and a.CF_INICIAL=b.CF_INICIAL 
							where a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
							and   a.data_fiscal='<<curVendasECF_405.CHAVE_DT_DOC>>'
							and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
							and   a.id_equipamento='<<curVendasECF_405.CHAVE_ID_EQUIPAMENTO>>' 
							and   a.cf_inicial='<<curVendasECF_405.CHAVE_CF_INICIAL>>'
							and   b.legenda_tarifa <> 'SUBTRIB'
							group by b.legenda_tarifa,a.data_fiscal,a.codigo_filial,a.terminal,a.id_equipamento,
							a.ecf,a.serie_nf,a.cf_inicial

							union all

							select 
							convert(varchar(4),'C420') as REG,
							replace(replace(replace(convert(varchar(8),'CAN-T'),',',''),'%',''),'.','') as COD_TOT_PAR,
							replace(convert(varchar(17),sum(total_cancelado)),'.',',') as VLR_ACUM_TOT,
							convert(varchar(2),'01') as NR_TOT,
							convert(varchar(2),' ') as DESCR_NR_TOT,
							a.codigo_filial as CHAVE_CODIGO_FILIAL,
							a.terminal as CHAVE_TERMINAL,
							a.id_equipamento as CHAVE_ID_EQUIPAMENTO,
							a.cf_inicial as CHAVE_CF_INICIAL,
							a.ecf as CHAVE_CF_INICIAL,
							a.serie_nf as CHAVE_SERIE_NF  
							from loja_controle_fiscal a 
							join loja_controle_fiscal_tarifas b 
							on  a.CODIGO_FILIAL=b.CODIGO_FILIAL 
							and a.TERMINAL=b.TERMINAL 
							and a.DATA_FISCAL=b.DATA_FISCAL 
							and a.ECF=b.ECF 
							and a.ID_EQUIPAMENTO=b.ID_EQUIPAMENTO 
							and a.SERIE_NF=b.SERIE_NF 
							and a.CF_INICIAL=b.CF_INICIAL 
							where a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
							and   a.data_fiscal='<<curVendasECF_405.CHAVE_DT_DOC>>'
							and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
							and   a.id_equipamento='<<curVendasECF_405.CHAVE_ID_EQUIPAMENTO>>' 
							and   a.cf_inicial='<<curVendasECF_405.CHAVE_CF_INICIAL>>'
							and   a.total_cancelado <> 0
							group by a.data_fiscal,a.codigo_filial,a.terminal,a.id_equipamento,
							a.ecf,a.serie_nf,a.cf_inicial
							
							union all

							select 
							convert(varchar(4),'C420') as REG,
							replace(replace(replace(convert(varchar(8),'DT'),',',''),'%',''),'.','') as COD_TOT_PAR,
							replace(convert(varchar(17),sum(total_desconto)),'.',',') as VLR_ACUM_TOT,
							convert(varchar(2),'01') as NR_TOT,
							convert(varchar(2),' ') as DESCR_NR_TOT,
							a.codigo_filial as CHAVE_CODIGO_FILIAL,
							a.terminal as CHAVE_TERMINAL,
							a.id_equipamento as CHAVE_ID_EQUIPAMENTO,
							a.cf_inicial as CHAVE_CF_INICIAL,
							a.ecf as CHAVE_CF_INICIAL,
							a.serie_nf as CHAVE_SERIE_NF  
							from loja_controle_fiscal a 
							join loja_controle_fiscal_tarifas b 
							on  a.CODIGO_FILIAL=b.CODIGO_FILIAL 
							and a.TERMINAL=b.TERMINAL 
							and a.DATA_FISCAL=b.DATA_FISCAL 
							and a.ECF=b.ECF 
							and a.ID_EQUIPAMENTO=b.ID_EQUIPAMENTO 
							and a.SERIE_NF=b.SERIE_NF 
							and a.CF_INICIAL=b.CF_INICIAL 
							where a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
							and   a.data_fiscal='<<curVendasECF_405.CHAVE_DT_DOC>>'
							and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
							and   a.id_equipamento='<<curVendasECF_405.CHAVE_ID_EQUIPAMENTO>>' 
							and   a.cf_inicial='<<curVendasECF_405.CHAVE_CF_INICIAL>>'
							and   a.total_cancelado <> 0
							group by a.data_fiscal,a.codigo_filial,a.terminal,a.id_equipamento,
							a.ecf,a.serie_nf,a.cf_inicial
							
							union all
							
							select 
							convert(varchar(4),'C420') as REG,
							replace(replace(replace(convert(varchar(8),'F1'),',',''),'%',''),'.','') as COD_TOT_PAR,
							replace(convert(varchar(17),sum(total_substituicao)),'.',',') as VLR_ACUM_TOT,
							convert(varchar(2),'01') as NR_TOT,
							convert(varchar(2),' ') as DESCR_NR_TOT,
							a.codigo_filial as CHAVE_CODIGO_FILIAL,
							a.terminal as CHAVE_TERMINAL,
							a.id_equipamento as CHAVE_ID_EQUIPAMENTO,
							a.cf_inicial as CHAVE_CF_INICIAL,
							a.ecf as CHAVE_CF_INICIAL,
							a.serie_nf as CHAVE_SERIE_NF  
							from loja_controle_fiscal a 
							join loja_controle_fiscal_tarifas b 
							on  a.CODIGO_FILIAL=b.CODIGO_FILIAL 
							and a.TERMINAL=b.TERMINAL 
							and a.DATA_FISCAL=b.DATA_FISCAL 
							and a.ECF=b.ECF 
							and a.ID_EQUIPAMENTO=b.ID_EQUIPAMENTO 
							and a.SERIE_NF=b.SERIE_NF 
							and a.CF_INICIAL=b.CF_INICIAL 
							where a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
							and   a.data_fiscal='<<curVendasECF_405.CHAVE_DT_DOC>>'
							and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
							and   a.id_equipamento='<<curVendasECF_405.CHAVE_ID_EQUIPAMENTO>>' 
							and   a.cf_inicial='<<curVendasECF_405.CHAVE_CF_INICIAL>>'
							and   a.total_substituicao <> 0
							group by a.data_fiscal,a.codigo_filial,a.terminal,a.id_equipamento,
							a.ecf,a.serie_nf,a.cf_inicial

							union all

							select 
							convert(varchar(4),'C420') as REG,
							replace(replace(replace(convert(varchar(8),'I1'),',',''),'%',''),'.','') as COD_TOT_PAR,
							replace(convert(varchar(17),sum(total_isento)),'.',',') as VLR_ACUM_TOT,
							convert(varchar(2),'01') as NR_TOT,
							convert(varchar(2),' ') as DESCR_NR_TOT,
							a.codigo_filial as CHAVE_CODIGO_FILIAL,
							a.terminal as CHAVE_TERMINAL,
							a.id_equipamento as CHAVE_ID_EQUIPAMENTO,
							a.cf_inicial as CHAVE_CF_INICIAL,
							a.ecf as CHAVE_CF_INICIAL,
							a.serie_nf as CHAVE_SERIE_NF  
							from loja_controle_fiscal a 
							join loja_controle_fiscal_tarifas b 
							on  a.CODIGO_FILIAL=b.CODIGO_FILIAL 
							and a.TERMINAL=b.TERMINAL 
							and a.DATA_FISCAL=b.DATA_FISCAL 
							and a.ECF=b.ECF 
							and a.ID_EQUIPAMENTO=b.ID_EQUIPAMENTO 
							and a.SERIE_NF=b.SERIE_NF 
							and a.CF_INICIAL=b.CF_INICIAL 
							where a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
							and   a.data_fiscal='<<curVendasECF_405.CHAVE_DT_DOC>>'
							and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
							and   a.id_equipamento='<<curVendasECF_405.CHAVE_ID_EQUIPAMENTO>>' 
							and   a.cf_inicial='<<curVendasECF_405.CHAVE_CF_INICIAL>>'
							and   a.total_isento <> 0
							group by a.data_fiscal,a.codigo_filial,a.terminal,a.id_equipamento,
							a.ecf,a.serie_nf,a.cf_inicial
							
							
						endtext
						
						f_select(xsel_420,'curVendasECF_420')
						
						sele curVendasECF_420	
						go top
						
						scan	&& registro 420
							
							xreg = REG
							xreg = xreg + ";" + COD_TOT_PAR	 
							xreg = xreg + ";" + VLR_ACUM_TOT	 
							xreg = xreg + ";" + NR_TOT	
							xreg = xreg + ";" + DESCR_NR_TOT						
							
							fputs(xhand,left(xreg,len(xreg)-1))						
						
						endscan	&& registro 420
																		
						**seleciona 425
						text to	xsel_425 noshow	textmerge	
							
														
							--C425 INICIO--------

							select a.REG, 
							a.COD_ITEM,
							--convert(varchar(17),a.QTD-isnull(b.QTD,0)) as QTD, -- abatendo troca
							convert(varchar(17),a.QTD) as QTD, 
							a.UNID,
							--convert(varchar(17),a.VL_ITEM-isnull(b.VL_ITEM,0)) as VL_ITEM, -- abatendo troca
							convert(varchar(17),a.VL_ITEM) as VL_ITEM, 
							a.VL_PIS,
							a.VL_COFINS,
							a.CHAVE_CODIGO_FILIAL,
							a.CHAVE_TERMINAL,  
							a.CHAVE_DATA_VENDA,
							a.CHAVE_PRODUTO 
							from 
								(select
								convert(varchar(4),'C425') as REG,
								convert(varchar(60),b.produto) as COD_ITEM,
								sum(b.qtde) as QTD,
								convert(varchar(6),isnull(d.unidade,'PC')) as UNID,
								replace(sum(b.qtde*(b.preco_liquido-b.desconto_item)),'.',',') as VL_ITEM,
								convert(varchar(17),' ') as VL_PIS,
								convert(varchar(17),' ') as VL_COFINS,
								a.codigo_filial as CHAVE_CODIGO_FILIAL,
								a.terminal as CHAVE_TERMINAL,  
								a.data_venda as CHAVE_DATA_VENDA,
								b.produto as CHAVE_PRODUTO   
								from loja_venda a 
								join loja_venda_produto b 
								on  a.codigo_filial=b.codigo_filial 
								and a.data_venda=b.data_venda 
								and a.ticket=b.ticket 
								join loja_venda_pgto c 
								on  a.codigo_filial=c.codigo_filial 
								and a.lancamento_caixa=c.lancamento_caixa 
								and a.terminal=c.terminal 
								join produtos d 
								on b.produto=d.produto 
								where c.numero_cupom_fiscal is not null
								and b.qtde <> 0  
								and a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
								and   a.data_venda='<<curVendasECF_405.CHAVE_DT_DOC>>'
								and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
								group by b.produto,d.unidade,a.codigo_filial,a.terminal,a.data_venda ) a
							left join --TROCAS
								(select
								convert(varchar(4),'C425') as REG,
								convert(varchar(60),b.produto) as COD_ITEM,
								sum(b.qtde) as QTD,
								convert(varchar(6),isnull(d.unidade,'PC')) as UNID,
								replace(sum(b.qtde*(b.preco_liquido-b.desconto_item)),'.',',') as VL_ITEM,
								convert(varchar(17),' ') as VL_PIS,
								convert(varchar(17),' ') as VL_COFINS,
								a.codigo_filial as CHAVE_CODIGO_FILIAL,
								a.terminal as CHAVE_TERMINAL,  
								a.data_venda as CHAVE_DATA_VENDA,
								b.produto as CHAVE_PRODUTO   
								from loja_venda a 
								join loja_venda_troca b 
								on  a.codigo_filial=b.codigo_filial 
								and a.data_venda=b.data_venda 
								and a.ticket=b.ticket 
								join loja_venda_pgto c 
								on  a.codigo_filial=c.codigo_filial 
								and a.lancamento_caixa=c.lancamento_caixa 
								and a.terminal=c.terminal 
								join produtos d 
								on b.produto=d.produto 
								where c.numero_cupom_fiscal is not null
								and b.qtde <> 0 
								and a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
								and   a.data_venda='<<curVendasECF_405.CHAVE_DT_DOC>>'
								and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
								group by b.produto,d.unidade,a.codigo_filial,a.terminal,a.data_venda  ) b  --TROCAS
							on  a.chave_codigo_filial=b.chave_codigo_filial 
							and a.chave_data_venda=b.chave_data_venda 
							and a.chave_produto=b.chave_produto

							--C425 FIM-----------
							
						endtext	
						
						f_select(xsel_425,'curVendasECF_425')
						
						sele curVendasECF_425
						go top	
						
						scan	&& registro 425
						
							xreg = REG
							xreg = xreg + ";" + COD_ITEM	 
							xreg = xreg + ";" + QTD
							xreg = xreg + ";" + UNID		 
							xreg = xreg + ";" + VL_ITEM	
							xreg = xreg + ";" + VL_PIS						
							xreg = xreg + ";" + VL_COFINS						
						
							fputs(xhand,left(xreg,len(xreg)-1))														
						
						endscan	&& registro 425
						


																		
						**seleciona 460
						text to	xsel_460 noshow	textmerge	

							--C460 INICIO--------

							select 
							a.REG,
							a.COD_MOD,
							a.COD_SIT,
							a.NUM_DOC,
							a.DT_DOC,
							case when a.COD_SIT='02' then convert(varchar(17),' ') else convert(varchar(17),a.VL_DOC) end as VL_DOC,
							a.VL_PIS,
							a.VL_COFINS,
							a.CPF_CNPJ,
							a.NOM_ADQ,
							a.CHAVE_CODIGO_FILIAL,
							a.CHAVE_TERMINAL,
							a.CHAVE_LANCAMENTO_CAIXA,
							a.CHAVE_DATA_VENDA,
							a.CHAVE_NUMERO_CUPOM_FISCAL
							from 
								(select
								convert(varchar(4),'C460') as REG,
								convert(varchar(3),'2D') as COD_MOD,
								convert(varchar(4),case when a.valor_cancelado>0 and a.motivo_cancelamento is not null then '02' else '00' end ) as COD_SIT,
								convert(varchar(6),isnull(c.numero_cupom_fiscal,' ')) as NUM_DOC,
								convert(varchar(8),replace(convert(varchar(13),a.data_venda,103),'/','')) as DT_DOC,
								replace(convert(varchar(17),(isnull(a.valor_venda_bruta,0)- isnull(a.desconto,0))),'.',',') as VL_DOC,
								convert(varchar(17),' ') as VL_PIS,
								convert(varchar(17),' ') as VL_COFINS,
								convert(varchar(14),' ') as CPF_CNPJ,
								convert(varchar(60),' ') as NOM_ADQ,
								a.codigo_filial    as CHAVE_CODIGO_FILIAL,
								a.terminal         as CHAVE_TERMINAL,
							    a.lancamento_caixa as CHAVE_LANCAMENTO_CAIXA,
								a.data_venda       as CHAVE_DATA_VENDA, 
								c.numero_cupom_fiscal as CHAVE_NUMERO_CUPOM_FISCAL
								from loja_venda a 
								join loja_venda_pgto c 
								on  a.codigo_filial=c.codigo_filial 
								and a.lancamento_caixa=c.lancamento_caixa 
								and a.terminal=c.terminal 
								where c.numero_cupom_fiscal is not null 
								and a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
								and   a.data_venda='<<curVendasECF_405.CHAVE_DT_DOC>>'
								and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' ) a

							--C460 FIM-----------
						
						endtext	
							
						f_select(xsel_460,'curVendasECF_460')
						
						sele curVendasECF_460
						go top	
						
						scan	&& registro 460
						
							xreg = REG
							xreg = xreg + ";" + COD_MOD	 
							xreg = xreg + ";" + COD_SIT	 
							xreg = xreg + ";" + NUM_DOC	
							xreg = xreg + ";" + DT_DOC						
							xreg = xreg + ";" + VL_DOC						
							xreg = xreg + ";" + VL_PIS	
							xreg = xreg + ";" + VL_COFINS						
							xreg = xreg + ";" + CPF_CNPJ	
							xreg = xreg + ";" + NOM_ADQ	
													
							fputs(xhand,left(xreg,len(xreg)-1))														
						
								
								**seleciona 470
								text to	xsel_470 noshow	textmerge	
																	
									--C470 INICIO--------
															
								select 
								a.REG,
								a.COD_ITEM,
								convert(varchar(17),sum(a.QTD)) as QTD,
								convert(varchar(17),sum(a.QTDE_CANC)) as QTDE_CANC,
								a.UNID,
								replace(convert(varchar(17),sum(a.VL_ITEM)),'.',',') as VL_ITEM,
								a.CST_ICMS,
								a.CFOP,
								a.ALIQ_ICMS,
								a.VL_PIS,
								a.VL_COFINS,
								a.CHAVE_CODIGO_FILIAL,
								a.CHAVE_TERMINAL,
								a.CHAVE_DATA_VENDA,
								a.CHAVE_PRODUTO
								from
									(select 
									convert(varchar(4),'C470') as REG,
									convert(varchar(60),b.produto) as COD_ITEM,
									sum(isnull(b.qtde,0)) as QTD,
									sum(isnull(b.qtde_cancelada,0)) as QTDE_CANC,
									convert(varchar(6),isnull(d.unidade,'PC')) as UNID,
									convert(numeric(14,2),sum((b.preco_liquido*b.qtde)*b.fator_venda_liq)) as VL_ITEM, 
									convert(varchar(3), case when isnull(b.aliquota,0)<0 then 'ST' else '00' end ) as CST_ICMS,
									convert(varchar(4),'5102') as CFOP,
									convert(varchar(17),case when isnull(b.aliquota,0)<0 then 0 else isnull(b.aliquota,0) end ) as ALIQ_ICMS,
									convert(varchar(17),'') as VL_PIS,
									convert(varchar(17),'') as VL_COFINS,
									a.codigo_filial as CHAVE_CODIGO_FILIAL,
									a.terminal as CHAVE_TERMINAL,  
									a.data_venda as CHAVE_DATA_VENDA,
									b.produto as CHAVE_PRODUTO  
									from loja_venda a 
									join loja_venda_produto b 
									on  a.codigo_filial=b.codigo_filial 
									and a.data_venda=b.data_venda 
									and a.ticket=b.ticket 
									join loja_venda_pgto c 
									on  a.codigo_filial=c.codigo_filial 
									and a.lancamento_caixa=c.lancamento_caixa 
									and a.terminal=c.terminal 
									join produtos d 
									on b.produto=d.produto 
									where c.numero_cupom_fiscal is not null 
									and   c.numero_cupom_fiscal is not null 
									and   a.codigo_filial='<<curVendasECF_460.CHAVE_CODIGO_FILIAL>>' 
									and   a.data_venda ='<<curVendasECF_460.CHAVE_DATA_VENDA>>'
									and   a.terminal='<<curVendasECF_460.CHAVE_TERMINAL>>'
									and   c.numero_cupom_fiscal='<<curVendasECF_460.CHAVE_NUMERO_CUPOM_FISCAL>>'						
									group by b.qtde,a.codigo_filial,a.terminal,a.data_venda,
									b.produto,isnull(d.unidade,'PC'),b.aliquota,b.fator_venda_liq) a
									group by a.REG,a.COD_ITEM,a.UNID,a.CST_ICMS,a.CFOP,a.ALIQ_ICMS,a.VL_PIS,a.VL_COFINS,
									a.CHAVE_CODIGO_FILIAL,a.CHAVE_TERMINAL,a.CHAVE_DATA_VENDA,a.CHAVE_PRODUTO

									--C470 FIM-----------
								
								endtext	
											
								f_select(xsel_470,'curVendasECF_470')
								
								sele curVendasECF_470
								go top	
								
								scan	&& registro 470
								
									xreg = REG
									xreg = xreg + ";" + COD_ITEM	 
									xreg = xreg + ";" + QTD 	 
									xreg = xreg + ";" + QTDE_CANC	
									xreg = xreg + ";" + UNID						
									xreg = xreg + ";" + VL_ITEM						
									xreg = xreg + ";" + CST_ICMS	
									xreg = xreg + ";" + CFOP						
									xreg = xreg + ";" + ALIQ_ICMS	
									xreg = xreg + ";" + VL_PIS	
									xreg = xreg + ";" + VL_COFINS									
															
									fputs(xhand,left(xreg,len(xreg)-1))			

								endscan	 && registro 470 
																
						
						
							sele curVendasECF_460
							
						endscan	&& registro 460
																				

																								
						**seleciona 490
						text to	xsel_490 noshow	textmerge	
							
							select 
							convert(varchar(4),'C490') as REG,
							a.CST_ICMS,
							a.CFOP,
							replace(convert(varchar(17),a.ALIQ_ICMS),'.',',') as ALIQ_ICMS,
							replace(convert(varchar(17),convert(numeric(14,2) , sum(a.VL_ITEM) )),'.',',') as VL_OPR,
							replace(convert(varchar(17),convert(numeric(14,2) , sum(case when a.ALIQ_ICMS=0 then 0 else a.VL_ITEM end ) )),'.',',') as VL_BC_ICMS,
							replace(convert(varchar(17),convert(numeric(14,2) , sum( ( a.VL_ITEM * (case when a.ALIQ_ICMS=0 then 0 else a.ALIQ_ICMS end) ) /100 ) )),'.',',') as VL_ICMS,
							convert(varchar(6),' ') as COD_OBS 
							from 
								(select 
								convert(varchar(4),'C470') as REG,
								convert(varchar(60),b.produto) as COD_ITEM,
								sum(isnull(b.qtde,0)) as QTD ,
								convert(varchar(17),0) as QTDE_CANC,
								convert(varchar(6),isnull(d.unidade,'PC')) as UNID,
								convert(numeric(14,2),sum((b.PRECO_LIQUIDO*b.QTDE)*b.FATOR_VENDA_LIQ)) as VL_ITEM, 
								convert(varchar(3), case when isnull(b.aliquota,0)<0 then 'ST' else '00' end ) as CST_ICMS,
								convert(varchar(4),'5102') as CFOP,
								case when isnull(b.aliquota,0)<0 then 0 else isnull(b.aliquota,0) end  as ALIQ_ICMS,
								convert(varchar(17),'') as VL_PIS,
								convert(varchar(17),'') as VL_COFINS,
								a.codigo_filial as CHAVE_CODIGO_FILIAL,
								a.terminal as CHAVE_TERMINAL,  
								a.data_venda as CHAVE_DATA_VENDA,
								b.produto as CHAVE_PRODUTO  
								from loja_venda a 
								join loja_venda_produto b 
								on  a.codigo_filial=b.codigo_filial 
								and a.data_venda=b.data_venda 
								and a.ticket=b.ticket 
								join loja_venda_pgto c 
								on  a.codigo_filial=c.codigo_filial 
								and a.lancamento_caixa=c.lancamento_caixa 
								and a.terminal=c.terminal 
								join produtos d 
								on b.produto=d.produto 
								where c.numero_cupom_fiscal is not null 
								and a.codigo_filial='<<curVendasECF_405.CHAVE_CODIGO_FILIAL>>' 
								and   a.data_venda='<<curVendasECF_405.CHAVE_DT_DOC>>'
								and   a.terminal='<<curVendasECF_405.CHAVE_TERMINAL>>' 
								group by a.codigo_filial,a.terminal,a.data_venda,
								b.produto,isnull(d.unidade,'PC'),b.aliquota) a
							group by a.reg,a.cst_icms,a.cfop,a.aliq_icms 
							
						endtext	

						
						
						f_select(xsel_490,'curVendasECF_490')
						
						sele curVendasECF_490
						go top	
						
						scan	&& registro 490
						
							xreg = REG
							xreg = xreg + ";" + CST_ICMS	 
							xreg = xreg + ";" + CFOP	 
							xreg = xreg + ";" + ALIQ_ICMS	
							xreg = xreg + ";" + VL_OPR						
							xreg = xreg + ";" + VL_BC_ICMS						
							xreg = xreg + ";" + VL_ICMS	
							xreg = xreg + ";" + COD_OBS 						
													
							fputs(xhand,left(xreg,len(xreg)-1))			
							
						endscan	&& registro 490						
												
						
						
						
						sele curVendasECF_405 
						
					Endscan	&& Leituras Z dos equipamentos





					sele curVendasECF_400
					
				ENDSCAN && Equipamentos ECF -- Registro Pai

				f_prog_bar()


				if xhand <= 0
					=F_msg(["Verifique direitos de gravação e atributos de somente leitura, ou se o arquivo já esta aberto.";
					,16,"Erro ao Criar o Arquivo"])
					return .f.
				endif

				fclose(xhand)

				go top


				* Fim Exportacao ECF ----------------------------------------------------------------------------------------------------

			Endif	
			
			

	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_exporta_ecf
**************************************************



























**************************************************
*-- Class:        bt_exporta (c:\documents and settings\sidnei.stellet\desktop\bt_exporta\bt_exporta.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/28/09 04:01:01 PM
*
DEFINE CLASS bt_exporta AS botao


	Top = 305
	Left = 500
	Height = 27
	Width = 120
	FontBold = .F.
	FontSize = 8
	Caption = "\<Exportar Vendas"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_exporta"
	Visible = .t.
	Enabled =.t.


	PROCEDURE Click


		  
		xdata_ini='19800101'  
		xdata_fim='20201231'

		if	!f_vazio(thisformset.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.DATA_INICIAL.Value)
			xdata_ini=dtos(thisformset.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.DATA_INICIAL.Value)
		endif


		if	!f_vazio(thisformset.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.DATA_FINAL.Value)
			xdata_fim=dtos(thisformset.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.DATA_FINAL.Value)
		endif


		xlabel_arq=substr(xdata_ini,7,2) + '_a_'+substr(xdata_fim,7,2)+substr(xdata_ini,5,2)+left(xdata_ini,4)
		
         
        text to xselcoligada noshow textmerge	 
        	select convert(char(2),0) as anm_cod_coligada
        	union all
			select convert(char(2),1)
			union all
			select convert(char(2),2)
			union all
			select convert(char(2),3)
			union all
			select convert(char(2),4)
			union all
			select convert(char(2),5)
        endtext	

		f_select(xselcoligada,"curcod_coligada")         
        
        Sele curcod_coligada 
        Go Top  
        Scan	

		
			*!*			* Inicio Exportacao Vendas
			 
				If 1=1

					* Variaveis utilizadas na Exportacao Clientes

					local xarq,xhand,xreg,xsel	 


				if f_vazio(thisformset.lx_FORM1.lx_pageframe1.page2.lx_combobox1.Value)
					xfiltro_filial=''
				else
					xfiltro_filial=" and filial='"+allt(thisformset.lx_FORM1.lx_pageframe1.page2.lx_combobox1.Value)+"'" 
				endif


					text to	xsel noshow	textmerge

						select  convert(varchar(16),(isnull(chapa,' ')+' ')) as chapa,
						'25'+right('00'+ltrim(rtrim(convert(char(2),month(getdate())))),2)+
						ltrim(rtrim(convert(varchar(4),year(getdate())))) as data_pagamento,
						convert(varchar(4),' D'+right('00'+ltrim(rtrim(convert(char(2),day(data_venda)))),2)) as codigo_do_evento,
						convert(varchar(6),'000:00' ) as hora_evento,
						convert(varchar(15),'000000000000.00') as referencia,
						convert(varchar(15),right(convert(varchar(17),1000000000000+isnull(valor_pago,0)),15)) as valor_pago,
						convert(varchar(15),right(convert(varchar(17),1000000000000+isnull(valor_pago,0)),15)) as valor_original,
						'N ' as dados_alterados
						from WANM_VENDAS_VENDEDOR_DP 
						where data_venda between '<<xdata_ini>>' and '<<xdata_fim>>'
						and isnull(ANM_CODCOLIGADA,'0')='<<curcod_coligada.anm_cod_coligada>>'
						<<xfiltro_filial>> and valor_pago > 0
						order by filial, nome_vendedor 

					endtext


					text to	xsel2 noshow textmerge
						
						select chapa,data_pagamento,' 965' as codigo_do_evento,hora_evento,referencia,
						convert(varchar(15),right(convert(varchar(17),1000000000000+isnull(sum(valor_pago),0)),15)) as valor_pago,
						convert(varchar(15),right(convert(varchar(17),1000000000000+isnull(sum(valor_pago),0)),15)) as valor_original,
						dados_alterados
						from 
											(select  convert(varchar(16),(isnull(chapa,' ')+' ')) as chapa,
											'25'+right('00'+ltrim(rtrim(convert(char(2),month(getdate())))),2)+
											ltrim(rtrim(convert(varchar(4),year(getdate())))) as data_pagamento,
											convert(varchar(4),' D'+right('00'+ltrim(rtrim(convert(char(2),day(data_venda)))),2)) as codigo_do_evento,
											convert(varchar(6),'000:00' ) as hora_evento,
											convert(varchar(15),'000000000000.00') as referencia,
											valor_pago as valor_pago,
											valor_pago as valor_original,
											'N ' as dados_alterados,
											filial,nome_vendedor
											from WANM_VENDAS_VENDEDOR_DP 
											where data_venda between '<<xdata_ini>>' and '<<xdata_fim>>'
											and isnull(ANM_CODCOLIGADA,'0')='<<curcod_coligada.anm_cod_coligada>>'
											<<xfiltro_filial>> and valor_pago > 0 ) a 
						group by a.nome_vendedor,a.chapa,a.data_pagamento,a.hora_evento,a.referencia,a.dados_alterados
						order by a.nome_vendedor 

					endtext


					*Abertura do arquivo de exportacao
					
					xAgroup=.f.
					if messagebox("Deseja Exportar Vendas Consolidado?",4+32+256,"Atenção!!!")=6

						xAgroup=.t.

						xarq = wdir+'linx\exportacao\Vendas_RM_Agroup'+'_'+allt(curcod_coligada.anm_cod_coligada)+'_'+xlabel_arq+'.txt'
						if empty(xarq)
							return (.f.)
						endif

						xhand = fcreate( xarq )
						
					
					else	
					
						xAgroup=.f.
					
						xarq = wdir+'linx\exportacao\Vendas_RM_'+'_'+allt(curcod_coligada.anm_cod_coligada)+'_'+xlabel_arq+'.txt'
						if empty(xarq)
							return (.f.)
						endif

						xhand = fcreate( xarq )
									
					
					endif	
					

					* Inicio Exportacao Vendas
					
					if xAgroup=.f.

						f_select(xsel,'curVendasRM')

					else	

						f_select(xsel2,'curVendasRM')
					
					endif	

					sele curVendasRM 

					scan

						f_prog_bar(' Exportando para o Arquivo : '+upper(xarq), recno(), Reccount())

		

						xreg = chapa
						xreg = xreg + data_pagamento	 
						xreg = xreg + codigo_do_evento
						xreg = xreg + hora_evento
						xreg = xreg + referencia
						xreg = xreg + valor_pago				 
						xreg = xreg + valor_original
						xreg = xreg + dados_alterados  					     
						

						fputs(xhand,left(xreg,len(xreg)-1))

					endscan

					f_prog_bar()


					if xhand <= 0
						=F_msg(["Verifique direitos de gravação e atributos de somente leitura, ou se o arquivo já esta aberto.";
						,16,"Erro ao Criar o Arquivo"])
						return .f.
					endif

					fclose(xhand)

					go top


					* Fim Exportacao VENDAS RM ----------------------------------------------------------------------------------------------------

				Endif	
				
				sele curcod_coligada 
			
			Endscan			
			
			
			
			
			
					*!*			* Fim Exportacao CIENTES SEM CHAPA
		 
			If 1=1

				* Variaveis utilizadas na Exportacao Clientes

				local xarq,xhand,xreg,xsel	 


			if f_vazio(thisformset.lx_FORM1.lx_pageframe1.page2.lx_combobox1.Value)
				xfiltro_filial=''
			else
				xfiltro_filial=" and filial='"+allt(thisformset.lx_FORM1.lx_pageframe1.page2.lx_combobox1.Value)+"'" 
			endif


				text to	xsel noshow	textmerge

					select distinct convert(varchar(13),'codigo_filial') as codigo_filial,
					convert(varchar(25),'filial') as filial,
					convert(varchar(8),'vendedor') as vendedor,
					convert(varchar(40),'nome_vendedor') as nome_vendedor
					union all
					select distinct convert(varchar(13),a.codigo_filial) as codigo_filial,
					convert(varchar(25),c.filial) as filial,
					convert(varchar(4),a.vendedor) as vendedor,
					convert(varchar(40),b.nome_vendedor) as nome_vendedor
					from loja_venda a 
					join loja_vendedores b 
					on  a.vendedor=b.vendedor 
					join lojas_varejo c 
					on  a.codigo_filial=c.codigo_filial
					where a.data_venda between '<<xdata_ini>>' and '<<xdata_fim>>' 
					<<xfiltro_filial>>
					and b.chapa is null

				endtext


				*Abertura do arquivo de exportacao

				xarq = wdir+'linx\exportacao\Vendedores_sem_chapa'+xlabel_arq+'.txt'
				if empty(xarq)
					return (.f.)
				endif

				xhand = fcreate( xarq )


				* Inicio Exportacao Vendas

				f_select(xsel,'curVendasRM')


				sele curVendasRM 

				scan

					f_prog_bar(' Exportando para o Arquivo : '+upper(xarq), recno(), Reccount())

	

					xreg = codigo_filial
					xreg = xreg + filial	 
					xreg = xreg + vendedor
					xreg = xreg + nome_vendedor
					xreg = xreg + codigo_filial
					xreg = xreg + filial				 
					xreg = xreg + vendedor
					xreg = xreg + nome_vendedor 					     
					

					fputs(xhand,left(xreg,len(xreg)-1))

				endscan

				f_prog_bar()


				if xhand <= 0
					=F_msg(["Verifique direitos de gravação e atributos de somente leitura, ou se o arquivo já esta aberto.";
					,16,"Erro ao Criar o Arquivo"])
					return .f.
				endif

				fclose(xhand)

				go top


				* Fim Exportacao CIENTES SEM CHAPA ----------------------------------------------------------------------------------------------------

			Endif
			
			
			
			
			
			

	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_exporta
**************************************************


*-- Class:        bt_exporta (c:\documents and settings\sidnei.stellet\desktop\bt_exporta\bt_exporta.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/28/09 04:01:01 PM
*
DEFINE CLASS bt_exporta_luc AS botao


	Top = 255
	Left = 500
	Height = 27
	Width = 120
	FontBold = .F.
	FontSize = 8
	Caption = "\<Exportar Lucratividade"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_exporta_luc"
	Visible = .t.
	Enabled =.t.


	PROCEDURE Click


Data_Ini = DTOS(o_300019.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.data_INICIAL.Value)
Data_Fim = DTOS(o_300019.lx_FORM1.lx_pageframe1.page2.lx_faixa_data1.data_FINAL.Value)


f_select("select COD_FILIAL from filiais where filial=?v_loja_resumo_operacao_01.filial","xCodFilial")
xFilial= IIF(f_vazio(xCodFilial.cod_filial),"%",xCodFilial.cod_filial)

xResp = MESSAGEBOX("Deseja Exportar Por Periodo ?",4+32)
f_wait("Pesquisando ... AGUARDE !")

IF xResp = 6
f_select("EXEC SOMA.DBO.LX_ANM_LUCATIVIDADE ?Data_Ini,?Data_Fim,?xFilial,'S'","xLucratividade")
ELSE
f_select("EXEC SOMA.DBO.LX_ANM_LUCATIVIDADE ?Data_Ini,?Data_Fim,?xFilial,'N'","xLucratividade")
ENDIF

f_wait()

SELE xLucratividade
*COPY TO C:\TEMP\Lucratividade.XLS XLS 
*MESSAGEBOX('Exportado no caminho C:\TEMP\Lucratividade',0+64)


IF MESSAGEBOX("Exportando Lucratividade, Salvar como ?",0+46)=1

	xFile = "'"+PUTFILE('','','xls')+"'"

	COPY TO &xFile XLS
	MESSAGEBOX("Exportado com Sucesso Para:"+CHR(13)+xFile,64) 
	RETURN .F.

ENDIF

ENDPROC

ENDDEFINE