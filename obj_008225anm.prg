* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Ajusta proptiedades -- Seleciona Materiais Somente da Fase atual						                    *
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
					
							Public xFacAnt,xFacNovo,xTarefaFab as Integer,cData
							
							cur1="RESERVA N(9,3),CONSUMIDA N(9,3),DATA_RESERVA D,RESERVA_ORIGINAL N(9,3),ULTIMA_SAIDA D,DIFERENCA_PREVISAO N(9,3),FATOR_CONVERSAO_NA_RESERVA N(12,5),MATAR_SALDO_RESERVA L,DESC_COR_MATERIAL C(50),REFER_FABRICANTE C(15),FASE_PRODUCAO C(25),"
							cur2="SETOR_PRODUCAO C(25),DESC_MATERIAL C(40),FATOR_CONVERSAO N(9,4),UNID_ESTOQUE C(5),UNID_FICHA_TEC C(5),RESERVA_MATERIAL_OP L, MATERIAL_INDIRETO L,ABATER_RESERVA_QTDE L,ESTOQUE_MATERIAL N(16,3),FALTAS_MATERIAL N(16,3),OUTRAS_RESERVAS N(16,3),"
							cur3="ESTOQUE_DISPONIVEL N(16,3),COMPRAS N(16,3),NECESSIDADE_FINAL N(16,3),SOBRA_FINAL N(16,3),PROXIMA_ENTREGA D,MATERIAL_SUBSTITUIDO C(11),COR_MATERIAL_SUBSTITUIDO C(10),PRIORIDADE_SUBSTITUICAO I,ALTERACAO_CONSUMO N(8,2),SUBSTITUICAO_POR_PRODUTO L,"
							cur4="GRUPO C(25),SUBGRUPO C(25),ORDEM_SERVICO C(8),MATERIAL C(11),COR_MATERIAL C(10),ORDEM_PRODUCAO C(8),ITEM C(3),QTDE_NECESSARIA N(9,3)"
								
							ocursor = GETCURSORADAPTER("V_PRODUCAO_OS_02_MATERIAIS")							
							ocursor.CursorSchema =cur1+cur2+cur3+cur4
							
							cur1="CONSUMIDA N(11,3),RESERVA N(11,3),DATA_RESERVA D,RESERVA_ORIGINAL N(11,3),ULTIMA_SAIDA D,DIFERENCA_PREVISAO N(11,3),FATOR_CONVERSAO_NA_RESERVA N(12,5),MATAR_SALDO_RESERVA L,DESC_COR_MATERIAL C(50),REFER_FABRICANTE C(15),"
							cur2="FASE_PRODUCAO C(25),SETOR_PRODUCAO C(25),DESC_MATERIAL C(40),FATOR_CONVERSAO N(12,5),UNID_ESTOQUE C(5),UNID_FICHA_TEC C(5),RESERVA_MATERIAL_OP L,MATERIAL_INDIRETO L,ABATER_RESERVA_QTDE L,ESTOQUE_MATERIAL N(16,3)," 
							cur3="FALTAS_MATERIAL N(16,3),OUTRAS_RESERVAS N(16,3),ESTOQUE_DISPONIVEL N(16,3),COMPRAS N(16,3),NECESSIDADE_FINAL N(16,3),SOBRA_FINAL N(16,3),PROXIMA_ENTREGA D,MATERIAL_SUBSTITUIDO C(11),COR_MATERIAL_SUBSTITUIDO C(10),"
							cur4="PRIORIDADE_SUBSTITUICAO I,ALTERACAO_CONSUMO N(10,5),SUBSTITUICAO_POR_PRODUTO L,GRUPO C(25),SUBGRUPO C(25),ORDEM_SERVICO C(8),MATERIAL C(11),COR_MATERIAL C(10),ORDEM_PRODUCAO C(8),ITEM C(3),QTDE_NECESSARIA N(11,3),"
							cur5="PARTE_APLICADO_MATERIAL C(10),DESC_USO_MATERIAL C(40),AUX N(3,0),PRODUTO C(12),COR_PRODUTO C(10),DESC_PRODUTO C(40),DESC_COR_PRODUTO C(40)"

							
							ocursor = GETCURSORADAPTER("V_PRODUCAO_OS_01_MATERIAIS")							
							ocursor.CursorSchema =cur1+cur2+cur3+cur4+cur5
							
							Thisformset.lx_forM1.lx_pageframe1.page6.lx_pageframe1.page1.lx_GRID_FILHA1.Col_tx_DESC_COR_MATERIAL.Tx_DESC_COR_MATERIAL.InputMask = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
							
								
									
							
							with thisformset.lx_form1
								.lx_pageframe1.page5.label_custo_previsto.Visible= .F.
								.lx_pageframe1.page5.addobject("lb_anm_custo_previsto","lb_anm_custo_previsto")
							endwith	
							
							with thisformset.lx_FORM1.lx_pageframe1.page5
								.addobject("bt_altera_obs","bt_altera_obs")
							endwith	
							
								
					if !f_vazio(xalias)
						sele &xalias
					endif	
				
				case upper(xmetodo) == 'USR_SAVE_AFTER'				
				
					*Lparameters cData
				
					F_SELECT("SELECT PROPRIEDADE FROM PROP_PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?v_producao_os_01.ORDEM_SERVICO  AND PROPRIEDADE in ('00012')","xProp012")
					F_SELECT("SELECT PROPRIEDADE, VALOR_PROPRIEDADE FROM PROP_PRODUCAO_ORDEM_SERVICO WHERE ORDEM_SERVICO = ?v_producao_os_01.ORDEM_SERVICO  AND PROPRIEDADE in ('50013')","xProp013")

					IF !F_VAZIO(xProp012.propriedade='00012') AND F_VAZIO(xProp013.propriedade='50013')
						IF MESSAGEBOX('Propriedades CHECKLIST STATUS pendente. Verifique! Se Sim será "Aprovado", se Não "Reprovado"',3+32,"Atenção")=6
						xordem_servico1=v_producao_os_01.ordem_servico
				
							text to	xinsert2 noshow textmerge	

								INSERT INTO PROP_PRODUCAO_ORDEM_SERVICO
								(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, ORDEM_SERVICO)
								SELECT 
								'50013','1','APROVADO','<<DTOS(WDATA)>>','<<xordem_servico1>>'
							endtext

					if !f_insert(xinsert2) 
					messagebox("Não foi possível Alterar o Status da Ordem de Serviço",48,"Atenção_8!")
					retu .f.
					endif
			ELSE
						xordem_servico1=v_producao_os_01.ordem_servico
				
						 text to xinsert2 noshow textmerge	

							INSERT INTO PROP_PRODUCAO_ORDEM_SERVICO
							(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, ORDEM_SERVICO)
							SELECT 
							'50013','1','REPROVADO','<<DTOS(WDATA)>>','<<xordem_servico1>>'
						 endtext

					if !f_insert(xinsert2) 
						messagebox("Não foi possível Alterar o Status da Ordem de Serviço",48,"Atenção_8!")
						retu .f.
					endif
			endif
ENDIF 			
				
				IF F_VAZIO(xProp012.propriedade='00012') AND (!F_VAZIO(xProp013.propriedade='50013') AND xProp013.valor_propriedade <> 'PENDENTE')
	*SET STEP ON			
						IF MESSAGEBOX('Propriedades DATA CHECKLIST pendente. Informe a data!',0+16,"Atenção")=1
								
							DO FORM wdir+'Linx\Exclusivos\inputboxdate.scx'
							
							xordem_servico1=v_producao_os_01.ordem_servico	 
*!*								MESSAGEBOX(cData)
*!*								if !f_vazio(cData)
*!*									*xfiltro_data=cData 
*!*									text to	xinsert2 noshow textmerge	
*!*										INSERT INTO PROP_PRODUCAO_ORDEM_SERVICO
*!*										(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,DATA_PARA_TRANSFERENCIA, ORDEM_SERVICO)
*!*										SELECT 
*!*										'00012','1','<<cData>>' ,'<<DTOS(WDATA)>>','<<xordem_servico1>>'
*!*									ENDTEXT
*!*									
*!*									if !f_insert(xinsert2) 
*!*											messagebox("Data não foi Inserida !!!!",48,"Atenção_8!")
*!*											retu .f.
*!*									ENDIF		
*!*								ENDIF 
						ENDIF				
				ENDIF

					
				case (upper(xmetodo) == 'USR_VALID' OR upper(xmetodo) == 'USR_TX_ORDEM_PRODUCAO') AND UPPER(xnome_obj)=='TX_ORDEM_PRODUCAO'
				
					
					xalias=alias()
					
					
						TEXT TO xSelRec NOSHOW TEXTMERGE
						
							SELECT A.RECURSO_PRODUTIVO,B.DESC_RECURSO,A.CUSTO_TAREFA 
							FROM PRODUCAO_TAREFAS A
							JOIN PRODUCAO_RECURSOS B
							ON A.RECURSO_PRODUTIVO = B.RECURSO_PRODUTIVO
							WHERE A.ORDEM_PRODUCAO = '<<ALLTRIM(v_producao_os_02_anterior.ordem_producao)>>'
							AND A.TAREFA = '<<ALLTRIM(v_producao_os_02_anterior.tarefa)>>'
						
						ENDTEXT
						
						f_select(xSelRec,'xRecurso',alias())
						sele xRecurso
						GO TOP
						
						WITH thisformset.lx_FORM1.lx_pageframe1.page2
							.tv_RECURSO_PRODUTIVO.Value = xRecurso.RECURSO_PRODUTIVO
							.tx_DESC_RECURSO.value = xRecurso.DESC_RECURSO
							.tx_custo.value = xRecurso.CUSTO_TAREFA
						ENDWITH	
					
					
					if !f_vazio(xalias)
						sele &xalias
					endif
					
				
				case upper(xmetodo) == 'USR_WHEN'
					
					
					xalias=alias()
					 
						IF UPPER(xnome_obj)=='BT_FINALIZA'
						
							****** BUSCA CUSTO DA ENTRADA DA NF DE IMPORTAÇÃO ****
							IF V_PRODUCAO_OS_02_ANTERIOR.setor_producao = '09'
								
								SELE V_PRODUCAO_OS_02_ANTERIOR
								GO TOP
								SCAN
								
									TEXT TO xBuscaCustoImp TEXTMERGE NOSHOW
									
										SELECT CUSTO_EFETIVO 
										FROM VW_MIT_ENTRADAS_RETORNO_BENEFICIAMENTO_OS
										WHERE TAREFA         = ?V_PRODUCAO_OS_02_ANTERIOR.tarefa_anterior   AND 
								      		  PRODUTO        = ?V_PRODUCAO_OS_02_ANTERIOR.produto  AND
								      		  COR_PRODUTO 	 = ?V_PRODUCAO_OS_02_ANTERIOR.cor_produto AND
								      	      ORDEM_PRODUCAO = ?V_PRODUCAO_OS_02_ANTERIOR.ordem_producao
									
									ENDTEXT

									f_select(xBuscaCustoImp,"cCustoEfetivoImp")
	**AND RECCOUNT()=1
									IF CUSTO_EFETIVO > 0 AND RECCOUNT()=1
										SELE V_PRODUCAO_OS_02_ANTERIOR
										REPLACE custo_tarefa WITH  cCustoEfetivoImp.CUSTO_EFETIVO
									ELSE	
										MESSAGEBOX("Custo da OS não encontrado."+CHR(13)+CHR(13)+;
										           "Se já fez a entrada da NF de compras,"+CHR(13)+"favor entrar em contato com o suporte."+CHR(13)+CHR(13)+;
										           "Caso não,"+CHR(13)+"favor efetuar a entrada da NF de compras e tentar novamente.",64)
										           
										RETURN .F.           
									ENDIF	           
								
								SELE V_PRODUCAO_OS_02_ANTERIOR
								ENDSCAN
							ENDIF
						
						Sele v_producao_os_02_anterior
									If thisformset.pp_ANM_BLOQ_MOVIMENTAR_OS AND v_producao_os_02_anterior.desc_setor_producao = 'EXTERNO'
										Messagebox("Favor dar Entrada de Nota Fiscal por Ordem de Serviço !!!",0+48)
										Return .f.
									Endif
							
						ENDIF
						
					if !f_vazio(xalias)
						sele &xalias
					endif
						
				
				
				case upper(xmetodo) == 'USR_VALID' 
					
				
						IF UPPER(xnome_obj)=='TX_ORDEM_PRODUCAO'
						*alimentar propriedades de tarefa_anterior
						
							xalias=alias()
									
						
									
						    		SELECT v_producao_os_02_anterior
						     	
							     	TEXT TO  xverifOsAnterior NOSHOW TEXTMERGE
							     		select tarefa,tarefa_anterior,ordem_servico 
							     		from PRODUCAO_OS_ANTERIOR 
							     		where ordem_producao='<<ALLTRIM(v_producao_os_02_anterior.ordem_producao)>>'
							     		and tarefa='<<ALLTRIM(v_producao_os_02_anterior.tarefa_anterior)>>'

							     	ENDTEXT

									f_select(xverifOsAnterior,'curOsAnterior',ALIAS())
									
									SELECT curOsAnterior
									IF RECCOUNT()>0
										
										TEXT TO xselProps NOSHOW TEXTMERGE
											select ordem_servico,propriedade,valor_propriedade 
											from PROP_PRODUCAO_ORDEM_SERVICO 
											where ordem_servico='<<ALLTRIM(curOsAnterior.ordem_servico)>>'
											and propriedade <> '00053'
										ENDTEXT
										
										f_select(xselProps,'curProps',ALIAS())
										
										SELECT curProps
										SCAN 							
											replace ALL valor_propriedade WITH curProps.valor_propriedade FOR propriedade=curProps.propriedade  IN curPropProducaoOrdemServico
										
										ENDSCAN
										
										RELEASE curProps

									ENDIF
									
									
				  	
					  	   

											
							if !f_vazio(xalias)
								sele &xalias
							endif	
						ENDIF
						
						
						
						IF UPPER(xnome_obj)=='TX_CUSTO_PREVISTO'
						
							xalias=alias()	
							
								*** JULIO - acerta ultimo_custo na tabela producao_tarefas_saldo para puxar o valor correto na entrada de nota fiscal
								SELECT V_PRODUCAO_OS_01_TAREFAS
								
								TEXT TO xUpdateCusto NOSHOW TEXTMERGE
										UPDATE PRODUCAO_OS_TAREFAS SET 
										CUSTO_PREVISTO = '<<v_producao_os_01_tarefas.custo_previsto>>' 
										WHERE TAREFA = '<<v_producao_os_01_tarefas.tarefa>>' 
										AND ORDEM_PRODUCAO = '<<v_producao_os_01_tarefas.ordem_producao>>'
										AND COR_PRODUTO = '<<v_producao_os_01_tarefas.cor_produto>>'
										AND ORDEM_SERVICO = '<<v_producao_os_01.ordem_servico>>' 
								ENDTEXT
								
								TEXT TO xUpdateUltimoCusto NOSHOW TEXTMERGE
										UPDATE PRODUCAO_TAREFAS_SALDO SET 
										ULTIMO_CUSTO_PREVISTO = '<<v_producao_os_01_tarefas.custo_previsto>>' 
										WHERE TAREFA = '<<v_producao_os_01_tarefas.tarefa>>' 
										AND ORDEM_PRODUCAO = '<<v_producao_os_01_tarefas.ordem_producao>>'
										AND COR_PRODUTO = '<<v_producao_os_01_tarefas.cor_produto>>'
										AND PRODUTO = '<<v_producao_os_01_tarefas.produto>>'
								ENDTEXT
									
								f_update(xUpdateCusto)
								f_update(xUpdateUltimoCusto)	
								thisformset.lx_FORM1.lx_pageframe1.page5.tx_custo_previsto.Enabled= .F.
								
								*** fim ***	
							if !f_vazio(xalias)
								sele &xalias
							endif	
								
						ENDIF	 				
						
						
						
						* ronald - 28042008 - digitaçao nas propriedades 46 e 12 apenas em inclusão   
						IF UPPER(xnome_obj)=='TX_VALOR_PROPRIEDADE'
							
							xalias=alias()

								SELECT curPropProducaoOrdemServico
								** IF ((curPropProducaoOrdemServico.propriedade='00046') OR (curPropProducaoOrdemServico.propriedade='00012'))
								** Retirado o bloqueio para alterar a propriedade 00012 - data chk list - a pedido da Leticia, chamado 000226 
								IF (curPropProducaoOrdemServico.propriedade='00046') 
									
									xalias=alias()
									
									
									IF  thisformset.p_tool_status $ 'IA'
									 
									    
										TEXT TO xselProps NOSHOW TEXTMERGE
											select ordem_servico,propriedade,valor_propriedade 
											from PROP_PRODUCAO_ORDEM_SERVICO 
											where ordem_servico='<<ALLTRIM(v_producao_os_01.ordem_servico)>>'
											and propriedade='<<curPropProducaoOrdemServico.propriedade>>'
										ENDTEXT
										
										f_select(xselProps,'curProps',ALIAS())
										
										IF !f_vazio(curProps.valor_propriedade)
											replace ALL valor_propriedade WITH curProps.valor_propriedade FOR propriedade=curProps.propriedade IN curPropProducaoOrdemServico
											
											MESSAGEBOX('Alteração não permitida!',0+48,'Atenção')
									 	ENDIF 
									ENDIF 
								ENDIF	 
							
							if !f_vazio(xalias)
								sele &xalias
							endif	
														
						ENDIF
				
				
				case upper(xmetodo) == 'USR_TRIGGER_AFTER'
					
					IF thisformset.p_tool_status == 'E'
							IF V_PRODUCAO_OS_01_ANTERIOR.FASE_PRODUCAO = '025'
								
								TEXT TO xUpdCtFabExc NOSHOW TEXTMERGE
									update producao_tarefas 
									set custo_tarefa = custo_tarefa + <<xFacNovo>>
									where tarefa = '<<xTarefaFab>>'								
								ENDTEXT
								
								f_update(xUpdCtFabExc)  
							ENDIF
					ENDIF		
				
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE' 
				
				xalias=alias()
				  
				  			LOCAL xVerificado 
				  			xVerificado = 0
				  			
				  			SELE V_PRODUCAO_OS_01_TAREFAS
				  			GO TOP
					  	  		
					  	  	   IF v_producao_os_01.FASE_PRODUCAO = '170'
					  	  	   	
						  	  	   TEXT TO xSelNF_Fabrica TEXTMERGE NOSHOW
						  	  	   
						  	  	   		SELECT TOP 1 NF_SAIDA,SERIE_NF 
										FROM FATURAMENTO_PROD A
											JOIN PRODUCAO_ORDEM B
											ON A.ORDEM_PRODUCAO = RIGHT(RTRIM(LTRIM(B.ORDEM_CORTE)),LEN(B.ORDEM_PRODUCAO))
											
										WHERE B.ORDEM_PRODUCAO = '<<V_PRODUCAO_OS_01_TAREFAS.ORDEM_PRODUCAO>>' 	
										ORDER BY NF_SAIDA
						  	  	   
						  	  	   ENDTEXT
						  	  	   
						  	  	   F_SELECT(xSelNF_Fabrica,"CurNFTransf")	
						  	  	   
						  	  	   SELECT v_producao_os_01
								   REPLACE nf_entrada       WITH CurNFTransf.NF_SAIDA
								   REPLACE serie_nf_entrada WITH CurNFTransf.SERIE_NF
						  	   
						  	   ENDIF
						  	   	   
						  	   TEXT TO xSelFilial TEXTMERGE NOSHOW
			
		--					 		SELECT
		--								CASE WHEN D.VALOR_PROPRIEDADE = 'ATACADO' AND E.REDE_LOJAS IN (1,3,4) AND E.TIPO_PRODUTO = 'PRODUTO ACABADO' AND E.COLECAO <> 'JOIAS'                    
		--										THEN 'REVISAO RBX ATACADO'
		--									 WHEN D.VALOR_PROPRIEDADE = 'VAREJO'  AND E.REDE_LOJAS IN (1,3,4) AND E.TIPO_PRODUTO = 'PRODUTO ACABADO' AND E.COLECAO <> 'JOIAS'   
		--										THEN 'REVISAO RBX VAREJO'
		--									 WHEN D.VALOR_PROPRIEDADE = 'MOSTRUARIO' AND E.REDE_LOJAS IN (1,3,4) AND E.TIPO_PRODUTO = 'PRODUTO ACABADO' AND E.COLECAO <> 'JOIAS'                    
		--										THEN 'REVISAO RBX ATACADO'	
		--									 WHEN E.REDE_LOJAS IN (1,3,4) AND E.TIPO_PRODUTO = 'PRODUÇAO'  AND E.COLECAO <> 'JOIAS'    
		--										THEN ( SELECT DBO.FX_ANM_PARAMETRO_USER('ANM_FILIAL_FABRICA') )
		--									 WHEN E.COLECAO = 'JOIAS' AND E.REDE_LOJAS IN (1,3,4) 
		--										THEN 'ESTOQUE CENTRAL'		
		--								ELSE A.FILIAL END AS FILIAL
		
									SELECT
										ISNULL(
										CASE WHEN D.VALOR_PROPRIEDADE IN ('ATACADO','MOSTRUARIO') AND E.TIPO_PRODUTO = 'PRODUTO ACABADO' AND E.COLECAO <> 'JOIAS'                    
										            THEN FILIAIS_ATACADO.FILIAL
										            WHEN D.VALOR_PROPRIEDADE = 'VAREJO' AND E.TIPO_PRODUTO = 'PRODUTO ACABADO' AND E.COLECAO <> 'JOIAS'   
										            THEN FILIAIS_VAREJO.FILIAL
										            WHEN E.TIPO_PRODUTO = 'PRODUÇAO'  AND E.COLECAO <> 'JOIAS'    
										            THEN FILIAIS_FABRICA.FILIAL
										            WHEN E.COLECAO = 'JOIAS' AND E.REDE_LOJAS IN (1,3,4) 
										            THEN 'ESTOQUE CENTRAL'  
						          ELSE A.FILIAL END,A.FILIAL) AS FILIAL

									FROM PRODUCAO_ORDEM A
											LEFT JOIN PRODUCAO_PROGRAMA C
											ON A.PROGRAMACAO = C.PROGRAMACAO
												LEFT JOIN PROP_PRODUCAO_PROGRAMA D
												ON C.PROGRAMACAO = D.PROGRAMACAO
												AND D.PROPRIEDADE = '00038'
												JOIN WANM_PRODUTOS E
												ON A.PRODUTO = E.PRODUTO
													
													
												LEFT JOIN dbo.FX_ANM_PARAMETROS_REDE_LOJAS('ANM_FILIAL_REVISAO_ATAC') PARAM_ATACADO ON E.REDE_LOJAS	= PARAM_ATACADO.REDE_LOJAS
												LEFT JOIN FILIAIS FILIAIS_ATACADO ON FILIAIS_ATACADO.COD_FILIAL = PARAM_ATACADO.VALOR_ATUAL

									  			LEFT JOIN dbo.FX_ANM_PARAMETROS_REDE_LOJAS('ANM_FILIAL_REVISAO_VAR') PARAM_VAREJO ON E.REDE_LOJAS	= PARAM_VAREJO.REDE_LOJAS
												LEFT JOIN FILIAIS FILIAIS_VAREJO ON FILIAIS_VAREJO.COD_FILIAL = PARAM_VAREJO.VALOR_ATUAL
										
						               			LEFT JOIN dbo.FX_ANM_PARAMETROS_REDE_LOJAS('ANM_FILIAL_FABRICA_RL') PARAM_FABRICA ON E.REDE_LOJAS	= PARAM_FABRICA.REDE_LOJAS
												LEFT JOIN FILIAIS FILIAIS_FABRICA ON FILIAIS_FABRICA.COD_FILIAL = PARAM_FABRICA.VALOR_ATUAL
												
									WHERE A.ORDEM_PRODUCAO = '<<V_PRODUCAO_OS_01_TAREFAS.ORDEM_PRODUCAO>>'
							 	
							 	ENDTEXT
							 	
							 	F_SELECT(xSelFilial,"CurFilialOS")
							 	
							 	IF xVerificado = 0 AND thisformset.p_tool_status $'IA' 
								 	SELECT v_producao_os_01
								 	REPLACE filial WITH CurFilialOS.FILIAL 
							 	ENDIF
							 	
							 	IF f_vazio(v_producao_os_01.FILIAL) AND thisformset.p_tool_status $'IA' 
							 		MESSAGEBOX("Filial de Entrada Estoque Não Encontrada,"+CHR(13)+"Favor Informar Manualmente.",64)
							 		xVerificado = 1
							 		RETURN .F.
							 	ENDIF
*!*								 		
*!*								 	
*!*									Thisformset.lx_FORM1.Cmb_FILIAL.Refresh()
*!*													
*!*									Sele v_producao_os_01
*!*									f_select("select LEFT(ltrim(REDE_LOJAS),1) as rede_lojas from filiais (nolock) where filial=?CurFilialOS.FILIAL","xConsFilial")
*!*									Sele xConsFilial

*!*									Sele v_producao_os_01_tarefas
*!*									f_select("select rede_lojas from WANM_PRODUTOS_RL_UNION where produto=?v_producao_os_01_tarefas.produto","xConsProd")
*!*									Sele xConsProd

*!*		 							If ALLTRIM(xConsFilial.rede_lojas) <> ALLTRIM(xConsProd.rede_lojas)
*!*										MESSAGEBOX("Rede Lojas da Filial é diferente do produto !!!"+chr(13)+"Favor Procurar o TI !!!",0+16)
*!*										RETURN .f.
*!*									Endif
							 	
				  	
				  xTarefaFab = V_PRODUCAO_OS_01_ANTERIOR.TAREFA_ANTERIOR
				  xFacNovo = v_producao_os_01_tarefas.custo_previsto 	
				  
				  IF thisformset.p_tool_status == 'A'
				  		IF V_PRODUCAO_OS_01_ANTERIOR.FASE_PRODUCAO = '025'
								
								TEXT TO xUpdCtFabInc NOSHOW TEXTMERGE
									update producao_tarefas 
									set custo_tarefa = custo_tarefa + (<<xFacAnt>> - <<xFacNovo>>) 
									where tarefa = '<<V_PRODUCAO_OS_01_ANTERIOR.TAREFA_ANTERIOR>>'								
								ENDTEXT
								
								f_update(xUpdCtFabInc)  
							
						ENDIF
				  ENDIF
				 
				 
				 		
				 			 
				 IF thisformset.p_tool_status == 'I'
							IF V_PRODUCAO_OS_01_ANTERIOR.FASE_PRODUCAO = '025'
								IF v_producao_os_01_tarefas.custo_previsto = 0	
						  			MESSAGEBOX("CUSTO DA FACÇÃO NÃO INFORMADO, ATENÇÃO !!!",0+48)
						  			RETURN .F.
						  		ELSE		
									xFacNovo = v_producao_os_01_tarefas.custo_previsto
									
									TEXT TO xUpdCtFabAlt NOSHOW TEXTMERGE
										update producao_tarefas 
										set custo_tarefa = custo_tarefa - <<xFacNovo>>
										where tarefa = '<<V_PRODUCAO_OS_01_ANTERIOR.TAREFA_ANTERIOR>>'								
									ENDTEXT
									
									f_update(xUpdCtFabAlt)  
								ENDIF
							ENDIF	
				 ENDIF
				  	
					
					
				  IF thisformset.p_tool_status $'IA'
				  

*!*							SELECT v_producao_os_01
*!*							IF ALLTRIM(v_producao_os_01_anterior.fase_producao)='004'
*!*								
*!*								xCount=0
*!*								*SELECT * from curPropProducaoOrdemServico INTO cursor vtmp_prop_producao_ordem_servico_00 
*!*	 
*!*								SELECT curPropProducaoOrdemServico 
*!*								
*!*								IF RECCOUNT()>0 
*!*									   
*!*									xTotRec=RECCOUNT()
*!*									GO TOP 
*!*									*busca propriedade vazia
*!*									SCAN  
*!*										*cursor de propriedade varre somente registros com valor. 
*!*										xCount=xCount + 1 										
*!*									ENDSCAN 								
*!*									
*!*									GO TOP 
*!*									IF xCount<xTotRec-1
*!*										MESSAGEBOX('Propriedades pendentes de cadastro. Verifique!',0+48,"Atenção")
*!*										RETURN .f.
*!*									ENDIF 
*!*									
*!*								ELSE 
*!*									MESSAGEBOX('Propriedades pendentes de cadastro. Verifique!',0+48,"Atenção")	 
*!*									RETURN .f.
*!*									 	 	
*!*								ENDIF 
*!*							ENDIF						
*!*						
					  ENDIF
					  
					if !f_vazio(xalias)
						sele &xalias
					endif



					case upper(xmetodo) == 'USR_SEARCH_AFTER'
					
						xalias=alias()	
							
							
								thisform.lx_pageframe1.page6.Lx_optiongroup1.Value=1
								thisform.lx_pageframe1.page6.Lx_optiongroup1.valid()

								Select 	V_PRODUCAO_OS_01_MATERIAIS
								thisform.Lx_pageframe1.Page2.Lx_grid_filha1.Refresh()
								thisform.Lx_pageframe1.Page1.Lx_grid_filha1.Refresh()
								
								
								thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.visible = .T.
						
						
						if !f_vazio(xalias)
							sele &xalias
						endif		
							

 
				  case upper(xmetodo) == 'USR_ALTER_BEFORE'	
				
						xalias=alias()
*!*								
*!*								SELE V_PRODUCAO_OS_01
*!*								IF !F_VAZIO(V_PRODUCAO_OS_01.NF_SAIDA) OR V_PRODUCAO_OS_01.acerto_entrada = .T.
*!*									MESSAGEBOX("Proibido alterar OS com NF Emitida !!!",0+48)
*!*									RETURN .f.	
*!*								ENDIF				
								
							f_select("select anm_status_almox from producao_ordem_servico where ordem_servico =?V_PRODUCAO_OS_01.ORDEM_SERVICO","xStatus",ALIAS())
							
							
							IF ALLTRIM(xStatus.anm_status_almox) == "1-ENVIADO PARA ALMOX"     
								messagebox("Não pode alterar uma OS enviada para Almox - Favor procurar o Almoxarifado para Liberar !!",48,"Atenção!!!")
								return .F.
							ENDIF
									
							xFacAnt = v_producao_os_01_tarefas.custo_previsto
									
						if !f_vazio(xalias)
							sele &xalias
						endif

				case upper(xmetodo) == 'USR_REFRESH'	
					
				
					 	IF thisformset.p_tool_status='A'  
							thisformset.lx_Form1.lx_pageframe1.page1.lX_GRID_FILHA1.Col_tx_QTDE_O.Enabled=.f.
					 	ELSE
							thisformset.lx_Form1.lx_pageframe1.page1.lX_GRID_FILHA1.Col_tx_QTDE_O.Enabled=.t.
					 	ENDIF
					

				case upper(xmetodo) == 'USR_CLEAN_AFTER'	
					
						xalias=alias()
							
							
							IF type("thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs") <> "U"
								thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.visible = .F.
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
*-- Class:        bt_saida_avulsa (c:\temp\rbx\bt_pedidos_prod.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/08/10 01:37:14 PM
*
DEFINE CLASS bt_altera_obs AS botao


	Top = 192
	Left = 35
	Height = 18
	Width = 90
	FontBold = .T.
	Caption = "Alterar"
	TabIndex = 40
	Name = "bt_altera_obs"
	Visible = .F.


	PROCEDURE Click

		
		IF thisformset.lx_FORM1.lx_pageframe1.page5.bt_altera_obs.caption == "Alterar"
				with thisformset.lx_FORM1.lx_pageframe1.page5
					.bt_altera_obs.caption = "Salvar"
				    .Ed_OBSERVACAO.ReadOnly= .F.
				endwith    
		ELSE 		
				
				f_insert("UPDATE PRODUCAO_ORDEM_SERVICO SET OBSERVACAO =?V_PRODUCAO_OS_01.OBSERVACAO WHERE ORDEM_SERVICO =?V_PRODUCAO_OS_01.ORDEM_SERVICO")
				MESSAGEBOX("Alterado com Sucesso",0+64)
				
				with thisformset.lx_FORM1.lx_pageframe1.page5
					.bt_altera_obs.caption = "Alterar"
				    .Ed_OBSERVACAO.ReadOnly= .T.
				endwith
		ENDIF
				
					
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_saida_avulsa 
**************************************************

**************************************************
*-- Class:        lb_anm_custo_previsto (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_anm_custo_previsto AS lx_label


	Caption = "Custo Previsto"
	Height = 15
	Left = 312
	Top = 51
	Width = 81
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_anm_custo_previsto"
	Visible = .t.
	Anchor = 0


	PROCEDURE DblClick	
		
			thisformset.lx_FORM1.lx_pageframe1.page5.tx_custo_previsto.Enabled= .T.
	
	ENDPROC 

ENDDEFINE
*
*-- EndDefine: lb_anm_custo_previsto 
**************************************************