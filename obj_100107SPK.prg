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
					
					Thisformset.p_auditoria = ''
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 

					if !f_vazio(xalias)
						sele &xalias
					endif	




			case UPPER(xmetodo) == 'USR_VALID' 
				
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
			
			    ENDIF

			case UPPER(xmetodo) == 'USR_GERA_IMPOSTOS' AND upper(xnome_obj)=='OBJ_METODOS_FATURAMENTO' 
			
				xalias=alias()
				
					SELECT V_FATURAMENTO_05_ITEM 
					GO TOP 
					SCAN 
						IF LEFT(ALLTRIM(V_FATURAMENTO_05.NATUREZA_SAIDA),6)='130.02'
								SELECT V_FATURAMENTO_05_ITEM 
								REPLACE DESCRICAO_ITEM WITH ALLTRIM(STRTRAN(DESCRICAO_ITEM,'(SEMI-ACABADO)',''))+' (SEMI-ACABADO)' 	
						ENDIF	

								REPLACE CODIGO_ITEM WITH RIGHT(ALLTRIM(CODIGO_ITEM),10)

					ENDSCAN 		
					SELECT V_FATURAMENTO_05_ITEM 
					GO TOP
					
					IF LEFT(ALLTRIM(V_FATURAMENTO_05.NATUREZA_SAIDA),6)='130.02'
								SELECT V_FATURAMENTO_05 
								REPLACE OBS WITH 'PRODUTO EM PROCESSO DE BENEFICIAMENTO.'  	
					ENDIF
					
					
					
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
					If (ALLTRIM(v_faturamento_05.natureza_saida) $ ALLTRIM(thisformset.pp_ANM_VALIDA_NAT_SAIDA_OP)) or thisformset.pp_ANM_VALIDA_NAT_SAIDA_OP = 'TODOS'
							sele v_faturamento_05_os_produtos
							if RECCOUNT() <> 0
								Sele v_faturamento_05_os_produtos
								GO Top	
								SCAN					
									F_SELECT("select a.filial, matriz_fiscal from producao_ordem a join filiais b on a.filial = b.filial where ordem_producao=?v_faturamento_05_os_produtos.ORDEM_PRODUCAO","CurMFOP")
															
									If ALLTRIM(v_faturamento_05.filial) <> ALLTRIM(CurMFOP.filial)
										MESSAGEBOX("Filial da OP diferente da Filial da Nota !!!",0+16)
										Return .F.
									Else
										f_select("select valor_propriedade from prop_filiais where PROPRIEDADE = '00248' and filial = ?v_faturamento_05.Filial","xFabrica")
										If ALLTRIM(xFabrica.valor_propriedade) = 'SIM'
											Replace v_faturamento_05_os_produtos.Filial With v_faturamento_05.Filial
										Else	
											f_select("select valor_propriedade from prop_filiais where propriedade = '00206' and filial = ?v_faturamento_05.Filial","xRevisao")
											if RECCOUNT()=0										
												Replace v_faturamento_05_os_produtos.Filial With v_faturamento_05.Filial
											Else
												Replace v_faturamento_05_os_produtos.Filial With xRevisao.valor_propriedade
											Endif	
										Endif	
									Endif							
															
										f_select("select valor_propriedade as TIPO from prop_produtos where produto = ?v_faturamento_05_os_produtos.produto and propriedade = '00036'","xTipo")
										f_select("select VALOR_PROPRIEDADE as FABRICA from prop_filiais where filial = ?v_faturamento_05.Filial AND PROPRIEDADE = '00248'","xProp")
										If ALLTRIM(xTipo.tipo) = 'PRODUÇAO' AND ALLTRIM(xProp.fabrica) = 'NAO'
											MESSAGEBOX("Tipo do Produto não corresponde a filial da Nota",0+16)
											Return .F.		
										Endif
																
										If ALLTRIM(xTipo.tipo) = 'PRODUTO ACABADO' AND ALLTRIM(xProp.fabrica) = 'SIM'
											MESSAGEBOX("Tipo do Produto não corresponde a filial da Nota",0+16)
											Return .F.		
										Endif				
									Endscan	
								
								 	Sele v_faturamento_05_os_produtos
									 
									RELEASE xSelFilial 
									RELEASE CurMFOP
									RELEASE xFabrica
									RELEASE xTipo
									RELEASE xProp
									RELEASE xRevisao
							Endif
				 		Endif
			
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
			
				
				
				otherwise
			return .t.				
		endcase
	endproc
enddefine

