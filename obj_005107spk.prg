* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Geracao Custo medio materiais na entrada e Consulta Entradas por colecao propriedade                                                                                                     *
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
			
				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
				sele v_entradas_00   
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("FILIAL_ESTOQUE", "C(25)",.T., "FILIAL_ESTOQUE", "Entradas.FILIAL_ESTOQUE")			
				oCur.addbufferfield("ANM_PGTO_OK", "L",.T., "ANM_PGTO_OK", "Entradas.ANM_PGTO_OK")	
				oCur.addbufferfield("Entradas.ANM_RATEIO_PRODUCAO", "N(15,5)",.T., "ANM_RATEIO_PRODUCAO", "Entradas.ANM_RATEIO_PRODUCAO")			
				oCur.addbufferfield("ENTRADAS.ANM_FRETE_ADICIONAL", "N(14,2)",.T., "ANM_FRETE_ADICIONAL", "Entradas.ANM_FRETE_ADICIONAL")
				oCur.addbufferfield("SPACE(100) AS USUARIO", "C(100)",.F., "USUARIO", "USUARIO")
				oCur.confirmstructurechanges() 
				thisformset.l_limpa()	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 			
						
			
			
				public xvalor_nota , xtempo_producao , xvalor_producao ,xpai_filtro , xDeptoUser , xPgto_OK 
				store 0 to xvalor_nota , xtempo_producao , xvalor_producao , xDeptoUser , xPgto_OK 


			
				xalias=alias()
			
				public xfiliais_estoque
				f_select("select * from filiais where filial in ('ESTOQUE CENTRAL','ATACADO','ALMOXARIFADO')","xfiliais_estoque")
			
				with thisformset.lx_form1.lx_PAGEFRAME1.page1
					.parent.parent.addobject("bt_anm_pgto_ok","bt_anm_pgto_ok")
					.parent.parent.addobject("ck_anm_pgto","ck_anm_pgto")
					*.addobject("lb_filial_estoque","lb_filial_estoque")
					*.addobject("cmb_filial_estoque","cmb_filial_estoque") 
					*.pageframe1.page2.addobject("tx_valor_itens","tx_valor_itens")
					.pageframe1.page2.addobject("lb_anm_rateio_producao","lb_anm_rateio_producao")
					.pageframe1.page2.addobject("tx_anm_rateio_producao","tx_anm_rateio_producao")
					.pageframe1.page2.addobject("tx_valor_producao","tx_valor_producao")
					.pageframe1.page2.addobject("tx_anm_frete_adicional","tx_anm_frete_adicional")						
					.pageframe1.page2.addobject("lb_anm_frete_adicional","lb_anm_frete_adicional")
					.pageframe1.page1.addobject("lb_conferido_por","lb_conferido_por")
					.pageframe1.page1.addobject("Tx_conferido_por","Tx_conferido_por") 	 					
				endwith		

				thisformset.lx_form1.addobject("lb_retrabalho","lb_retrabalho")

				xpai_filtro=thisformset.p_pai_filtro
				

				if !f_vazio(xalias)
					sele &xalias
				endif	


				Thisformset.L_limpa()
				
				*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_filial_estoque.RowSource = "xfiliais_estoque"
				*thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_filial_estoque.ControlSource = "v_entradas_00.filial_estoque" 
				thisformset.lx_form1.ck_anm_pgto.ControlSource = "v_entradas_00.anm_pgto_ok" 
				thisformset.lx_FORM1.tx_nf_entrada.InputMask="!!!!!!!!!!!!!!!"




			case UPPER(xmetodo) == 'USR_SEARCH_BEFORE' 
			
			
				xalias=alias()			
			
				f_select("select depto,usuario from users where UPPER(usuario)=UPPER(?wusuario)","curUser",alias())
				
				sele curUser 
				
				
				if upper(wusuario)='CAIO' OR upper(wusuario)='BETH' OR upper(wusuario)='DIOGO'
					xDeptoUser = 1 
				endif					
				
	
				if !f_vazio(xalias)
					sele &xalias
				endif	
				
				
				CASE UPPER(xmetodo) == 'USR_SEARCH_AFTER'

			xalias=alias()
				
				*** Consulta e mostra o usuario que fez a entrada da nota fiscal - Tabela ANM_LOG_USUARIO_ENTRADAS
				*** Solicitado: Braulio, Data: 27-01-2014, Desenvolvido por: Julio - 07-03-2014
				IF Thisformset.P_tool_status = 'P'
					If type('thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page1.Tx_conferido_por')<>'U'
					
					SELECT v_entradas_00
					GO top
					scan
						Text To xSelLogEnt TextMerge Noshow
						
							Select USUARIO From ANM_LOG_USUARIO_ENTRADAS
							Where NF_ENTRADA       = '<<v_entradas_00.nf_entrada>>'       AND
							      SERIE_NF_ENTRADA = '<<v_entradas_00.serie_nf_entrada>>' AND
							      NOME_CLIFOR      = '<<v_entradas_00.nome_clifor>>'
							 	
						Endtext
						f_select(xSelLogEnt,"xLogEntrada")
						
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page1.Tx_conferido_por.Value       = UPPER(ALLTRIM(xLogEntrada.USUARIO)) 
						*thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page1.Tx_conferido_por.ToolTipText = UPPER(ALLTRIM(xLogEntrada.USUARIO)) 
						replace v_entradas_00.usuario WITH UPPER(ALLTRIM(xLogEntrada.USUARIO)) 
					endscan	
					SELECT v_entradas_00
					GO top
					Endif
				ENDIF
				*** Fim *****************************************
			




			case UPPER(xmetodo) == 'USR_REFRESH' 

				xalias=alias()
				
				*** Consulta e mostra o usuario que fez a entrada da nota fiscal - Tabela ANM_LOG_USUARIO_ENTRADAS
				*** Solicitado: Braulio, Data: 27-01-2014, Desenvolvido por: Julio - 07-03-2014
				IF Thisformset.P_tool_status = 'P'
					If type('thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page1.Tx_conferido_por')<>'U'
					
					SELECT v_entradas_00

						Text To xSelLogEnt TextMerge Noshow
						
							Select USUARIO From ANM_LOG_USUARIO_ENTRADAS
							Where NF_ENTRADA       = '<<v_entradas_00.nf_entrada>>'       AND
							      SERIE_NF_ENTRADA = '<<v_entradas_00.serie_nf_entrada>>' AND
							      NOME_CLIFOR      = '<<v_entradas_00.nome_clifor>>'
							 	
						Endtext
						f_select(xSelLogEnt,"xLogEntrada")
						
						thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page1.Tx_conferido_por.Value       = UPPER(ALLTRIM(xLogEntrada.USUARIO)) 
						thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page1.Tx_conferido_por.ToolTipText = UPPER(ALLTRIM(xLogEntrada.USUARIO)) 

					Endif
				ENDIF
				*** Fim *****************************************
				
				If type('thisformset.lx_form1.lb_retrabalho')<>'U'

					text to xsel noshow textmerge	
					
						select retrabalho.ordem_servico from entradas a 
						join 
							(SELECT Producao_recursos.DESC_RECURSO, Producao_fase.DESC_FASE_PRODUCAO, Producao_setor.DESC_SETOR_PRODUCAO, Producao_os_anterior.TAREFA, Producao_os_anterior.TAREFA_ANTERIOR, Producao_os_anterior.ORDEM_PRODUCAO, Producao_os_anterior.PRODUTO, Producao_os_anterior.COR_PRODUTO, Producao_os_anterior.COR_ANTERIOR, Producao_os_anterior.QTDE_A, Producao_os_anterior.A1, Producao_os_anterior.A2, Producao_os_anterior.A3, Producao_os_anterior.A4, Producao_os_anterior.A5, Producao_os_anterior.A6, Producao_os_anterior.A7, Producao_os_anterior.A8, Producao_os_anterior.A9, Producao_os_anterior.A10, Producao_os_anterior.A11, Producao_os_anterior.A12, Producao_os_anterior.A13, Producao_os_anterior.A14, Producao_os_anterior.A15, Producao_os_anterior.A16, Producao_os_anterior.A17, Producao_os_anterior.A18, Producao_os_anterior.A19, Producao_os_anterior.A20, Producao_os_anterior.A21, Producao_os_anterior.A22, Producao_os_anterior.A23, Producao_os_anterior.A24, Producao_os_anterior.A25, Producao_os_anterior.A26, Producao_os_anterior.A27, Producao_os_anterior.A28, Producao_os_anterior.A29, Producao_os_anterior.A30, Producao_os_anterior.A31, Producao_os_anterior.A32, Producao_os_anterior.A33, Producao_os_anterior.A34, Producao_os_anterior.A35, Producao_os_anterior.A36, Producao_os_anterior.A37, Producao_os_anterior.A38, Producao_os_anterior.A39, Producao_os_anterior.A40, Producao_os_anterior.A41, Producao_os_anterior.A42, Producao_os_anterior.A43, Producao_os_anterior.A44, Producao_os_anterior.A45, Producao_os_anterior.A46, Producao_os_anterior.A47, Producao_os_anterior.A48, Producao_os_anterior.CUSTO_EFETIVO, Producao_os_anterior.CUSTO_EFETIVO AS CUSTO_CHEIO, Producao_os_anterior.DESCONTO_APLICADO, Producao_os_anterior.VALOR_CREDITADO, Producao_os_anterior.TIMESTAMP, Producao_os_anterior.ITEM_IMPRESSAO, Producao_ordem_servico.ORDEM_SERVICO, Producao_tarefas.RECURSO_PRODUTIVO, Producao_tarefas.FASE_PRODUCAO, Producao_tarefas.SETOR_PRODUCAO, Producao_ordem_servico.DATA, Producao_ordem_servico.CONFERIDO_POR, Producao_ordem_servico.ORDEM_SERVICO_PARALELA, Producao_ordem_servico.FILIAL, Producao_ordem_servico.NF_SAIDA, Producao_ordem_servico.SERIE_NF,
							 Producao_ordem_servico.NF_ENTRADA, Producao_ordem_servico.INDICADOR_TIPO_MOV, Producao_ordem_servico.BENEFICIADOR_TAREFA_ANTERIOR, Producao_ordem_servico.SERIE_NF_ENTRADA, Producao_recursos.NOME_CLIFOR, Produtos.DESC_PRODUTO, Produto_cores.DESC_COR_PRODUTO, Produtos.GRADE, IsNull(produtos_indicador_cfop.indicador_cfop, ( case when IsNull(filiais.indica_cfop_somente_revenda, 0) = 1 and produtos.indicador_cfop = 10 then 11 else produtos.indicador_cfop end)) as indicador_cfop,produtos.classif_fiscal, produtos.unidade, produtos.tribut_origem, produtos.tribut_icms, produtos.CONTA_CONTABIL, PRODUCAO_OS_ANTERIOR.CUSTO_MATERIAL_TERCEIRO 
							FROM  PRODUCAO_OS_ANTERIOR Producao_os_anterior  
							INNER JOIN PRODUCAO_OS_TAREFAS Producao_os_tarefas  
							ON ( ( (  Producao_os_anterior.TAREFA = Producao_os_tarefas.TAREFA 
							AND  Producao_os_anterior.ORDEM_SERVICO = Producao_os_tarefas.ORDEM_SERVICO ) 
							AND  Producao_os_anterior.ORDEM_PRODUCAO = Producao_os_tarefas.ORDEM_PRODUCAO ) 
							AND  Producao_os_anterior.PRODUTO = Producao_os_tarefas.PRODUTO ) 
							AND  Producao_os_anterior.COR_PRODUTO = Producao_os_tarefas.COR_PRODUTO  
							INNER JOIN dbo.PRODUTOS Produtos  ON  Producao_os_anterior.PRODUTO = Produtos.PRODUTO  
							INNER JOIN dbo.PRODUTO_CORES Produto_cores  ON  Producao_os_anterior.COR_PRODUTO = Produto_cores.COR_PRODUTO 
							AND  Producao_os_anterior.PRODUTO = Produto_cores.PRODUTO  
							INNER JOIN PRODUCAO_ORDEM_SERVICO Producao_ordem_servico  
							ON  Producao_os_anterior.ORDEM_SERVICO = Producao_ordem_servico.ORDEM_SERVICO 
							INNER JOIN PRODUCAO_TAREFAS Producao_tarefas 
							ON (Producao_os_anterior.TAREFA_ANTERIOR=Producao_tarefas.TAREFA 
							AND Producao_os_anterior.ORDEM_PRODUCAO=Producao_tarefas.ORDEM_PRODUCAO) 
							INNER JOIN PRODUCAO_RECURSOS Producao_recursos  
							ON  Producao_tarefas.RECURSO_PRODUTIVO = Producao_recursos.RECURSO_PRODUTIVO  
							INNER JOIN PRODUCAO_FASE Producao_fase  ON  Producao_tarefas.FASE_PRODUCAO = Producao_fase.FASE_PRODUCAO  
							INNER JOIN PRODUCAO_SETOR Producao_setor  ON  Producao_tarefas.FASE_PRODUCAO = Producao_setor.FASE_PRODUCAO 
							AND  Producao_tarefas.SETOR_PRODUCAO = Producao_setor.SETOR_PRODUCAO 
							inner join filiais 
							on filiais.filial = '<<v_entradas_00.filial>>' 
							left join produtos_indicador_cfop 
							on produtos_indicador_cfop.produto = produtos.produto 
							and produtos_indicador_cfop.filial = filiais.filial 
							WHERE (Producao_ordem_servico.ACERTO_ENTRADA = 1) 
							AND(  Producao_ordem_servico.BENEFICIADOR_TAREFA_ANTERIOR = ( '<<v_entradas_00.nome_clifor>>' ) 
							AND  Producao_ordem_servico.NF_ENTRADA = ( '<<v_entradas_00.nf_entrada>>' ) ) 
							AND  Producao_ordem_servico.SERIE_NF_ENTRADA = ( '<<v_entradas_00.serie_nf_entrada>>' )  ) entradas_os 
							on a.nf_entrada=entradas_os.nf_entrada 
							and a.serie_nf_entrada=entradas_os.serie_nf_entrada 
							and a.nome_clifor=entradas_os.nome_clifor 
						join 
							(select * from producao_ordem_servico where indicador_tipo_mov=5) as retrabalho 
							on entradas_os.fase_producao=retrabalho.fase_producao 
							and entradas_os.setor_producao=retrabalho.setor_producao 
							and entradas_os.recurso_produtivo=retrabalho.recurso_produtivo 
							and entradas_os.ordem_producao=retrabalho.ordem_producao_os
						where 
						a.nf_entrada='<<v_entradas_00.nf_entrada>>' 
						and a.nome_clifor='<<v_entradas_00.nome_clifor>>' 
						and a.serie_nf_entrada='<<v_entradas_00.serie_nf_entrada>>'

					
					endtext	


					f_select(xsel,"curRetrabalho")





					text to xsel noshow textmerge	

						select * from estoque_sai_mat where nf_entrada='<<v_entradas_00.nf_entrada>>' 
						and nome_clifor='<<v_entradas_00.nome_clifor>>' 
						and serie_nf_entrada='<<v_entradas_00.serie_nf_entrada>>'

					endtext	
					
										
					f_select(xsel,"curDevolucaoMat")	




					

					if	xDeptoUser = 1 


						text to xsel noshow textmerge	

							select ANM_PGTO_OK from entradas where nf_entrada='<<v_entradas_00.nf_entrada>>' 
							and nome_clifor='<<v_entradas_00.nome_clifor>>' 
							and serie_nf_entrada='<<v_entradas_00.serie_nf_entrada>>'

						endtext	
						


						f_select(xsel,"curPgtoOk",alias()) 
						sele curPgtoOk					
						if curPgtoOk.anm_pgto_ok=.t.
							xPgto_OK=1	
						else	
							xPgto_OK=0												
						endif	

					endif	


					if	(upper(wusuario)='CAIO' OR upper(wusuario)='BETH' OR upper(wusuario)='DIOGO') and type("thisformset.lx_form1.bt_anm_pgto_ok")<>"U" and xPgto_OK=0
						thisformset.lx_form1.bt_anm_pgto_ok.visible=.t.
						thisformset.lx_form1.bt_anm_pgto_ok.enabled=.t.						
					else	
						thisformset.lx_form1.bt_anm_pgto_ok.visible=.f.
						thisformset.lx_form1.bt_anm_pgto_ok.enabled=.f.												
					endif





					
					if xDeptoUser=1 and xPgto_OK=1 

						thisformset.lx_form1.lb_retrabalho.visible=.t.
						thisformset.lx_form1.lb_retrabalho.caption='Pagamento Efetuado !'
						thisformset.lx_form1.lb_retrabalho.refresh()	

					else						
					
						thisformset.lx_form1.lb_retrabalho.visible=.f.
						thisformset.lx_form1.lb_retrabalho.caption='Pagamento Efetuado !'
						thisformset.lx_form1.lb_retrabalho.refresh()	


						sele curRetrabalho
						if reccount()>0 
						
							thisformset.lx_form1.lb_retrabalho.visible=.t.
							thisformset.lx_form1.lb_retrabalho.caption='PCP com Devolução'
							thisformset.lx_form1.lb_retrabalho.refresh()

						else	
						
							sele curDevolucaoMat
							if reccount()>0 

								thisformset.lx_form1.lb_retrabalho.visible=.t.
								thisformset.lx_form1.lb_retrabalho.caption='Mat com Devolução'
								thisformset.lx_form1.lb_retrabalho.refresh()	
								
							else		
							
								thisformset.lx_form1.lb_retrabalho.visible=.f.
								thisformset.lx_form1.lb_retrabalho.caption='Nota com Devolução'						
								thisformset.lx_form1.lb_retrabalho.refresh()
							endif	
							
		
						
						endif	
						



					endif	
					

				Endif	




				***MOSTRA VALOR PRODUCAO 

				
				TEXT TO XSELENT NOSHOW TEXTMERGE 
				
					SELECT SUM(ESTOQUE_PROD1_ENT.VALOR) AS VALOR 
					FROM ESTOQUE_PROD1_ENT 
					INNER JOIN ESTOQUE_PROD_ENT ON ESTOQUE_PROD1_ENT.FILIAL = ESTOQUE_PROD_ENT.FILIAL 
					AND ESTOQUE_PROD1_ENT.ROMANEIO_PRODUTO = ESTOQUE_PROD_ENT.ROMANEIO_PRODUTO 
					INNER JOIN PRODUTOS ON ESTOQUE_PROD1_ENT.PRODUTO = PRODUTOS.PRODUTO 
					INNER JOIN PRODUTO_CORES ON ESTOQUE_PROD1_ENT.PRODUTO = PRODUTO_CORES.PRODUTO 
					AND ESTOQUE_PROD1_ENT.COR_PRODUTO = PRODUTO_CORES.COR_PRODUTO 
					INNER JOIN ENTRADAS ON ESTOQUE_PROD_ENT.NF_ENTRADA = ENTRADAS.NF_ENTRADA 
					AND ESTOQUE_PROD_ENT.NOME_CLIFOR = ENTRADAS.NOME_CLIFOR 
					AND ESTOQUE_PROD_ENT.SERIE_NF_ENTRADA = ENTRADAS.SERIE_NF_ENTRADA 
					INNER JOIN FILIAIS ON FILIAIS.FILIAL = ENTRADAS.FILIAL 
					LEFT JOIN PRODUTOS_INDICADOR_CFOP ON ESTOQUE_PROD1_ENT.PRODUTO = PRODUTOS_INDICADOR_CFOP.PRODUTO 
					AND PRODUTOS_INDICADOR_CFOP.FILIAL = FILIAIS.FILIAL 
					LEFT JOIN COMPRAS ON ESTOQUE_PROD_ENT.PEDIDO = COMPRAS.PEDIDO 
					LEFT JOIN MODIFICACAO_FICHA_TECNICA 
					ON ESTOQUE_PROD1_ENT.ID_MODIFICACAO = MODIFICACAO_FICHA_TECNICA.ID_MODIFICACAO 
					WHERE ESTOQUE_PROD_ENT.NF_ENTRADA = '<<v_entradas_00.nf_entrada>>'  
					AND ESTOQUE_PROD_ENT.NOME_CLIFOR = '<<v_entradas_00.nome_clifor>>'  
					AND ESTOQUE_PROD_ENT.SERIE_NF_ENTRADA = '<<v_entradas_00.serie_nf_entrada>>'
				
				
				
				ENDTEXT 
				
			
				F_SELECT(XSELENT,"CUR_ENT",ALIAS()) 
			
			
			
				xvalor_nota = 0

				if type("thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo")<>"U"
					xtempo_producao = thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.Cnt_producao.tx_valor_tempo.Value 
				else	
					xtempo_producao = 1 
				endif		
				

					
				sele CUR_ENT 
				sum valor to xvalor_nota  
				
				go top	
				
				
				if	type("thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.Page2.tx_VALOR_PRODUCAO")<>"U"
					xvalor_producao = (round(v_entradas_00.valor_total/(1-(xtempo_producao/100)) ,2))-nvl(v_entradas_00.anm_rateio_producao,0)+nvl(v_entradas_00.anm_frete_adicional,0)				
				endif			 	
				***MOSTRA VALOR PRODUCAO 



				if !f_vazio(xalias)
					sele &xalias
				endif	




			case UPPER(xmetodo) == 'USR_CLEAN_AFTER' 
			
				if	type("xpai_filtro")<>"U" 
					thisformset.p_pai_filtro=xpai_filtro 
				endif					
				




			otherwise
				return .t.				
		endcase
	endproc
enddefine


**************************************************
*-- Class:        lb_filial_estoque (p:\tmpsid\entradas_rbx\lb_filial_estoque.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_filial_estoque AS lx_label


	Caption = "Filial Estoque"
	Height = 15
	Left = 487
	Top = 6
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filial_estoque"
	Visible = .t.
	Anchor = 0 

ENDDEFINE
*
*-- EndDefine: lb_filial_estoque
**************************************************



**************************************************
*-- Class:        cmb_filial_estoque (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_filial_estoque AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 550
	TabIndex = 1
	Top = 3
	Width = 160
	ZOrderSet = 5
	Name = "cmb_filial_estoque"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

ENDDEFINE
*
*-- EndDefine: cmb_filial_estoque
**************************************************




**************************************************
*-- Class:        lb_retrabalho (p:\tmpsid\entradas_rbx\lb_retrabalho.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_retrabalho AS lx_label

	Caption = "Nota com Devolução"
	Height = 15
	Left = 690
	Top = 80
	Width = 22
	TabIndex = 10
	ForeColor = RGB(255,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_filial_estoque"
	Visible = .f.
	Fontbold = .t.
	Fontsize = 13

	PROCEDURE DblClick	
	
		
	
	ENDPROC 



ENDDEFINE
*
*-- EndDefine: lb_retrabalho
**************************************************




**************************************************
*-- Class:        tx_valor_itens (c:\work\desenv\filtros_data\tx_valor_itens.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_valor_itens AS lx_textbox_base 


	ControlSource = "xvalor_nota"
	Height = 19
	Left = 197
	TabIndex = 4
	Top = 272
	Width = 117
	p_tipo_dado = "mostra"
	Name = "tx_valor_itens"
	Visible = .T.
	Enabled = .F.	
	ForeColor = RGB(255,0,0)
	BorderColor = RGB(128,128,128)	
	SpecialEffect = 1 	
	BackStyle = 0 
	BorderStyle = 0 	
	INPUTMASK = "999 999 999.99"
	FontBold = .T.

ENDDEFINE
*
*-- EndDefine: tx_valor_itens 
**************************************************


**************************************************
*-- Class:        tx_valor_producao (c:\work\desenv\filtros_data\tx_valor_producao.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_valor_producao AS lx_textbox_base 


	ControlSource = "xvalor_producao"
	Height = 19
	Left = 88
	TabIndex = 4
	Top = 254
	Width = 102
	p_tipo_dado = "mostra"
	Name = "tx_valor_producao"
	Visible = .T.
	Enabled = .F.	
	ForeColor = RGB(255,0,0)
	BackStyle = 0 
	BorderStyle = 0 	
	BorderColor = RGB(128,128,128) 
	SpecialEffect = 1 
	INPUTMASK = "999 999 999.99"
	FontBold = .T.


ENDDEFINE
*
*-- EndDefine: tx_valor_producao
**************************************************



**************************************************
*-- Class:        ck_anm_pgto (c:\temp\ck_anm_pgto.vcx)
*-- ParentClass:  lx_checkbox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   01/25/10 12:09:08 PM
*
DEFINE CLASS ck_anm_pgto AS lx_checkbox

	Visible = .f.
	Enabled = .f.	
	Controlsource=""
	Top = 50
	Left = 600
	Height = 15
	Width = 56
	Alignment = 0
	Caption = "Pagamento OK"
	Value = 1
	TabIndex = 14
	ZOrderSet = 19
	Name = "ck_anm_pgto"


ENDDEFINE
*
*-- EndDefine: ck_anm_pgto
**************************************************


**************************************************
*-- Class:        bt_anm_pgto_ok (c:\temp\bt_anm_pgto_ok.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/25/10 12:51:11 PM
*
DEFINE CLASS bt_anm_pgto_ok AS botao

	Visible = .t.
	Enabled = .t.
	Top = 45
	Left = 600
	Height = 22
	Width = 120
	FontBold = .F.
	FontSize = 8
	Caption = "Pgto. Efetuado"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_anm_pgto_ok"


	PROCEDURE Click

		if	xDeptoUser = 1 


				text to updt1 noshow textmerge	

					update entradas set anm_pgto_ok=1 where nf_entrada='<<v_entradas_00.nf_entrada>>' 
					and nome_clifor='<<v_entradas_00.nome_clifor>>' 
					and serie_nf_entrada='<<v_entradas_00.serie_nf_entrada>>'

				endtext	
				


				if	!f_update(updt1) 
					messagebox("Não foi possível marcar nota como Paga.",48,"Contactar o TI")
				endif	
				
				o_toolbar.Botao_refresh.Click()

		endif	


	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_anm_pgto_ok
**************************************************

**************************************************
*-- Class:        tx_anm_frete_adicional (c:\work\desenv\filtros_data\tx_valor_itens.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_anm_frete_adicional AS lx_textbox_base 


	ControlSource = "V_ENTRADAS_00.ANM_FRETE_ADICIONAL"
	Height = 19
	Left = 8
	TabIndex = 4
	Top = 143
	Width = 117
	p_tipo_dado = "edita"
	Name = "tx_anm_frete_adicional"
	Visible = .T.
	Enabled = .F.	
	INPUTMASK = "999 999 999.99"
	FontBold = .T.
	Readonly = .F.



ENDDEFINE
*
*-- EndDefine: tx_anm_frete_adicional
**************************************************

**************************************************
*-- Class:        lb_anm_frete_adicional (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_anm_frete_adicional AS lx_label


	Caption = "Frete Add"
	Height = 15
	Left = 8
	Top = 127
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_anm_frete_adicional"
	Visible = .t.
	Anchor = 0
	FontBold = .T.


ENDDEFINE
*
*-- EndDefine: lb_anm_frete_adicional 
**************************************************


**************************************************
*-- Class:        lb_status_entrada (p:\tmpsid\entradas_rbx\lb_status_entrada .vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   11/10/08 01:57:13 PM
*
DEFINE CLASS lb_anm_rateio_producao AS lx_label


	Caption = "Desc. Rateio"
	Height = 15
	Left = 205
	Top = 264
	Width = 22
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_anm_rateio_producao"
	Visible = .t.
	Anchor = 0
	FontBold = .T.

ENDDEFINE
*
*-- EndDefine: lb_anm_rateio_producao 
**************************************************


**************************************************
*-- Class:        tx_anm_rateio_producao (c:\work\desenv\filtros_data\tx_valor_itens.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_anm_rateio_producao AS lx_textbox_base 


	ControlSource = "V_ENTRADAS_00.ANM_RATEIO_PRODUCAO"
	Height = 19
	Left = 197
	TabIndex = 4
	Top = 281
	Width = 117
	p_tipo_dado = "edita"
	Name = "tx_anm_rateio_producao"
	Visible = .T.
	Enabled = .F.	
	ForeColor = RGB(255,0,0)
	BorderColor = RGB(128,128,128)	
	SpecialEffect = 1 	
	BackStyle = 0 
	BorderStyle = 0 	
	INPUTMASK = "999 999 999.99"
	FontBold = .T.
	Readonly = .F.


ENDDEFINE
*
*-- EndDefine: tx_anm_rateio_producao
**************************************************


**************************************************
*-- Class:        cmb_filial_estoque (p:\tmpsid\entradas_rbx\cmb_filial_estoque.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   11/10/08 01:57:09 PM
*
DEFINE CLASS cmb_colecao AS lx_combobox


	RowSource = ""
	ControlSource = ""
	Height = 22
	Left = 550
	TabIndex = 1
	Top = 3
	Width = 160
	ZOrderSet = 5
	Name = "cmb_colecao"
	Visible = .t.
	Enabled = .t.
	Anchor = 0

ENDDEFINE
*
*-- EndDefine: cmb_filial_estoque
**************************************************

**************************************************
*-- Class:        lb_conferido_por (c:\pastas\anm_class\lb_conferido_por.vcx)
*-- ParentClass:  label
*-- BaseClass:    label
*-- Time Stamp:   03/07/14 10:37:02 AM
*
DEFINE CLASS lb_conferido_por AS lx_label


	FontName = "Tahoma"
	FontSize = 8
	BackStyle = 0
	Caption = "Conferido por:"
	Visible = .t.
	Height = 14
	Left = 6
	Top = 305
	Width = 71
	Name = "lb_conferido_por"


ENDDEFINE
*
*-- EndDefine: lb_conferido_por
**************************************************

**************************************************
*-- Class:        tx_conferido_por (c:\pastas\anm_class\tx_conferido_por.vcx)
*-- ParentClass:  textbox
*-- BaseClass:    textbox
*-- Time Stamp:   03/07/14 10:36:06 AM
*
DEFINE CLASS tx_conferido_por AS lx_textbox_base 


	FontName = "Tahoma"
	FontSize = 8
	Visible = .t.
	Enabled = .F.
	Height = 19
	Left = 83
	Margin = 1
	SelectOnEntry = .T.
	SpecialEffect = 1
	Top = 303
	Width = 198
	ForeColor = RGB(0,0,255)
	DisabledForeColor = RGB(0,0,0)
	BorderColor = RGB(127,157,185)
	Name = "Tx_conferido_por"


ENDDEFINE
*
*-- EndDefine: tx_conferido_por
**************************************************

