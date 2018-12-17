* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Consulta Entradas por colecao propriedade                                                                                                     *
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
		
		*!* Chama a função disponível na classe criada para tratar xml *!* #XML_2015
 		TRY 							
			If TYPE("Thisformset.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml
				If ! o_anm.l_Obj_entrada_xml('o_005109',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
					RETURN .f.
				Endif
			Endif
		CATCH					
		ENDTRY
		*!* Fim - Instancia um objeto da classe "Obj_Entrada_XML" #XML_2015
		
		do case
		
		case UPPER(xmetodo) == 'USR_INIT' 	
			** Tiago Carvalho (SS) - 13/10/2016 - Cria o botão para criação de Nota Fiscal em lote importado via excel na tela SS0065
			thisformset.lx_FORM1.addobject("Btn_Gerar_Notas_Fiscais","Btn_Gerar_Notas_Fiscais")
			IF TYPE("Thisformset.PP_SS_PERMITE_GERAR_NF_EXCEL") <> "U" AND Thisformset.PP_SS_PERMITE_GERAR_NF_EXCEL
				thisformset.lx_FORM1.Btn_Gerar_Notas_Fiscais.Enabled = .T.
				thisformset.lx_FORM1.Btn_Gerar_Notas_Fiscais.Visible = .T.
			ELSE
				thisformset.lx_FORM1.Btn_Gerar_Notas_Fiscais.Enabled = .F.
				thisformset.lx_FORM1.Btn_Gerar_Notas_Fiscais.Visible = .F.
			ENDIF
			
			   	
		   	*!* Declara Função Obj_Entrada_XML ao Iniciar Tela *!* #XML_2015
			If TYPE("Thisformset.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml
				PUBLIC o_anm as Object
				o_anm = NEWOBJECT("Obj_Entrada_XML","linx\exclusivo\obj_entrada_xml.prg")
			Endif
			*!* Fim - Declara Função Obj_Entrada_XML ao Iniciar Tela *!* #XML_2015
		   	
		   	*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
			sele v_entradas_00   
			xalias_pai=alias()
			
  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("ENTRADAS.ANM_RATEIO_PRODUCAO", "N(15,5)",.T., "ANM_RATEIO_PRODUCAO", "Entradas.ANM_RATEIO_PRODUCAO")							
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 	
			   	
					xalias=alias()
					
					PUBLIC curDuplicaItem,xvalor_producao
					xvalor_producao=0
					
					thisformset.lx_FORM1.lx_pageframe1.page2.addobject("bt_duplica_item","bt_duplica_item")  				
					
					with thisformset.lx_form1.lx_PAGEFRAME1.page1
						.pageframe1.page2.addobject("lb_anm_rateio_producao","lb_anm_rateio_producao")
						.pageframe1.page2.addobject("tx_anm_rateio_producao","tx_anm_rateio_producao")		
						.pageframe1.page2.addobject("tx_valor_producao","tx_valor_producao")	
					endwith	
					
					if	!f_vazio(xalias)
						sele &xalias			
					endif		
				
							
				Thisformset.L_limpa()
				
		
		case UPPER(xmetodo) == 'USR_VALID'
			
				xalias=alias()

				sele v_entradas_00	
         		thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tx_CliFor1.VALUE	
				f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_entradas_00.rateio_filial","curRATEIO",alias())
				thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.tx_desc_filial_rateio.Value = curRATEIO.desc_rateio_filial 	
*!*						f_select("SELECT B.COD_FILIAL,DESC_RATEIO_FILIAL FROM FILIAIS A JOIN FILIAIS B ON A.MATRIZ=B.FILIAL JOIN CTB_FILIAL_RATEIO C ON B.COD_FILIAL=C.RATEIO_FILIAL WHERE A.COD_FILIAL =?v_entradas_00.clifor1","curRATEIO",alias())
*!*						thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.Tv_RATEIO_FILIAL.Value = curRATEIO.COD_FILIAL
*!*						thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.tx_desc_filial_rateio.Value = curRATEIO.DESC_RATEIO_FILIAL	
				
						**** Julio - Veficica junto ao parâmetro ANM_NATUREZAS_IMPORTACAO as naturezas Permitidas para entrada de importação. ****
						If upper(xnome_obj)=='CK_IMPORTACAO'
							
							sele v_entradas_00	
							xSelImp = "SELECT COUNT(*) AS EntImpOK  FROM PARAMETROS WHERE PARAMETRO = 'ANM_NATUREZAS_IMPORTACAO' AND ( VALOR_ATUAL LIKE '%"+ALLT(v_Entradas_00.NATUREZA)+"%' OR VALOR_ATUAL = 'LIBERADO' )"
							f_select(xSelImp,"xteste")	
							
							If xteste.EntImpOK = 0
							    Thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.Ck_importacao.value=0
							    MESSAGEBOX('Não é permitido Entrada de Importação com essa natureza'+CHR(13)+'Favor Procurar o Dpto. Fiscal.',64)
							Endif
								
						Endif					
							
						*** Bloqueia alterar a natureza após a verificação caso o checkbox importação esteja marcado na tela em modo de inclusão ou alteraçao **	
							If v_entradas_00.importacao=.T.
								if Thisformset.p_tool_status $ 'I,A'
									Thisformset.lx_FORM1.tv_operacao.ReadOnly= .T.
								endif
							Else 
								Thisformset.lx_FORM1.tv_operacao.ReadOnly= .F.
							Endif	
						*** Fim do exclusivo de validação da natureza na entrada de importação ******
						*****************************************************************************
*!*					
*!*						    IF THISFORMSET.p_tool_status = 'I' AND (upper(xnome_obj)=='TV_FILIAL_ENTRADA' OR upper(xnome_obj)=='TV_NOME_CLIFOR')
*!*										
*!*				* Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo filial					
*!*							   THISFORMSET.lx_FORM1.Tx_clifor1.refresh()
*!*							   IF thisformset.lx_FORM1.Tx_clifor1.value = '000991'
*!*								  thisformset.lx_FORM1.Tx_clifor1.value = '000999'
*!*								  thisformset.lx_FORM1.TV_FILIAL_ENTRADA.VALUE = 'ESTOQUE CENTRAL'
*!*							   ENDIF		 	
*!*				* Valida filial rbx dist e gx dist como estoque central e atacado respectivamente no campo cliente
*!*				               THISFORMSET.lx_FORM1.Tx_clifor.refresh()
*!*							   IF thisformset.lx_FORM1.Tx_clifor.value = '000991'
*!*								  thisformset.lx_FORM1.Tx_clifor.value = '000999'
*!*								  thisformset.lx_FORM1.Tx_nome_clifor.VALUE = 'ESTOQUE CENTRAL'
*!*							   ENDIF
*!*						    ENDIF		
*!*					
				
						** Passa numero da NF para inteiro ** #XML_2015
						IF Thisformset.p_tool_status = 'I' AND upper(xnome_obj)=='TX_NF_ENTRADA'
						
							Thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE = INT(VAL(Thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE))

						ENDIF
						** FIM - Passa numero da NF para inteiro ** #XML_2015
						
					  	If upper(xnome_obj)=='TXT_CHAVE_NFE' OR upper(xnome_obj)=='TV_NOME_CLIFOR' 
							parametro_chave=THISFORMSET.pp_valida_chave_nfe_entrada
							serie_nf_desc=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value
						
								IF parametro_chave = .T. and serie_nf_desc = 'NF-E' 
								  SELE V_ENTRADAS_00
									 xEspecie_Serie = 5
									 REPLACE ESPECIE_SERIE 		 WITH xEspecie_Serie
								ENDIF

						ENDIF		
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif
		
		
		case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
			xalias=alias()

			* 31/08/2016 - WALLACE.PACHECO - 
			*IMPLEMENTAÇÃO DO TRATAMENTO REFERENTE AO PROJETO DE ATIVOS - CHAMADO : Projetos TI #299355 */
			* INICIO - WRP
			
			sele V_ENTRADAS_00_ITENS
			
			xContItenS=0
			xContIten=0
				
			go top	
				scan	
					sele V_ENTRADAS_00_ITENS
					
					*BROWSE normal
					if ALLTRIM(V_ENTRADAS_00_ITENS.conta_contabil) == '132201' AND EMPTY(V_ENTRADAS_00_ITENS.nome_sub_projeto) 

					xContItenS = xContItenS + 1						

					ENDIF
					
					if ALLTRIM(V_ENTRADAS_00_ITENS.conta_contabil) != '132201' AND !EMPTY(V_ENTRADAS_00_ITENS.nome_sub_projeto) 

					xContIten= xContIten + 1						

					endif
							
				ENDSCAN
				
				IF xContItenS > 0
					MESSAGEBOX('Não é permitido itens fiscais com o campo NOME SUB PROJETO = vazio na conta contábil: 132201 - Obras em Andamento. Favor verificar!', 16, wusuario)
					RETURN .F.
				ENDIF

*!*					IF xContIten > 0
*!*						MESSAGEBOX('Não é permitido itens fiscais com o campo NOME SUB PROJETO = preenchido com conta contábil diferente de 132201 - Obras em Andamento. Favor verificar!', 16, wusuario)
*!*						RETURN .F.
*!*					ENDIF

			
			*MESSAGEBOX(xContIten);
			*RETURN .F.
			
			*FIM - WRP

			
			SELE V_ENTRADAS_00
			*!* Chama a função disponível na classe criada para tratar xml *!* #XML_2015
				If TYPE("o_005109.pp_anm_obj_entrada_xml")<>'U' AND Thisformset.pp_anm_obj_entrada_xml AND THISFORMSET.p_tool_status $ 'I,A' AND v_entradas_00.numero_modelo_fiscal='55'
					If ! o_anm.l_anm_valida_xml('o_005109',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
						Return .f.
					Endif
				Endif	
			***** Saida Automática dos materiais comprados para Pilotagem **** #XML_2015

			
*!*			SELE V_ENTRADAS_00
*!*			xRatioItem = V_ENTRADAS_00.RATEIO_CENTRO_CUSTO
*!*			
*!*			SELE V_ENTRADAS_00_ITENS
*!*			GO TOP
*!*			SCAN
*!*				REPLACE RATEIO_CENTRO_CUSTO WITH xRatioItem
*!*			ENDSCAN	
*!*			SELE V_ENTRADAS_00_ITENS
*!*			GO TOP
			 
			 
			IF THISFORMSET.P_TOOL_status == 'E'					
					MESSAGEBOX("Atenção, Todos os Seus Dados Serão Armazenados ",48,"Atenção_9!")		
					xmotivo_exclusao = inputbox('Descreva o motivo da Exclusão','Motivo Exclusão (Campo Obrigatório)','')
						 	
					text to	xinsert1 noshow textmerge	
						INSERT INTO ANM_LOG_EXCLUSAO_NF
						(NF_ENTRADA,SERIE_NF,FILIAL,NOME_CLIFOR,DATA_DIGITACAO,EMISSAO,RECEBIMENTO,VALOR,DATA_EXCLUSAO,
						MOTIVO_EXCLUSAO,USUARIO_LINX,USUARIO_WINDOWS,NOME_MAQUINA)
					
						SELECT '<<V_ENTRADAS_00.NF_ENTRADA>>','<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>','<<V_ENTRADAS_00.FILIAL>>',
						'<<V_ENTRADAS_00.NOME_CLIFOR>>','<<V_ENTRADAS_00.DATA_DIGITACAO>>','<<V_ENTRADAS_00.EMISSAO>>',
						'<<V_ENTRADAS_00.RECEBIMENTO>>','<<V_ENTRADAS_00.VALOR_TOTAL>>',(SELECT GETDATE()),'<<XMOTIVO_EXCLUSAO>>',
						'<<WUSUARIO>>','<<SYSTEM.NetUserName>>','<<SYSTEM.NetComputerName>>'
					endtext			
										
					if !f_insert(xinsert1) 
						messagebox("Não foi possível Excluir a Nota Fiscal ",48,"Atenção_9!")
						retu .f.
					endif
			ENDIF

			IF THISFORMSET.P_TOOL_status == 'I'				

				parametro_chave=THISFORMSET.pp_valida_chave_nfe_entrada
				chave_nfe=THISFORMSET.lx_form1.lx_pageframe1.page1.pageframe1.page_NFE.txt_chave_nfe.Value
				serie_nf_desc=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.tv_Desc_Especie_Serie.Value
				nf_entrada_propria=thisformset.lx_FORM1.lx_pageframe1.page1.Pageframe1.page1.ck_nf_propria.Value
				
				IF parametro_chave = .T. AND f_vazio(chave_nfe) AND serie_nf_desc = 'NF-E' and nf_entrada_propria = .F.
					MESSAGEBOX("VOCÊ NÃO INFORMOU A CHAVE !!!" + CHR(13) + "FAVOR INSERIR A CHAVE !",64)
					RETURN .F.
				ENDIF
				
			ENDIF		

*!*				IF thisformset.LX_FORM1.Lx_pageframe1.Page1.Pageframe1.Page1.Ck_nf_propria.value == .F.
*!*					if	allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='E1' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='U' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='5' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='CT' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='90' or allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='91'
*!*						retu .t. 
*!*					else	
*!*						messagebox("É permitido somente o uso das Séries U, 5 , 90, 91 e de Produção !",48,"Atenção!!!")
*!*						retu .f.
*!*					endif		
*!*				ELSE
*!*					if allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='5' OR allt(upper(thisformset.lx_form1.tx_serie_nf.Value))=='A5'
*!*						retu .t.
*!*					else	
*!*						messagebox("É permitido somente o uso da Série 5 !",48,"Atenção!!!")
*!*						retu .f.
*!*					endif
*!*				ENDIF

			
		if	!f_vazio(xalias)	
			sele &xalias 
		endif	


		*MIT[1] - INICIO
		IF thisformset.p_tool_status = 'A'
			*- Verifico se houve alteração no desconto
			VLC_Select = "select ISNULL(ANM_RATEIO_PRODUCAO,0) as ANM_RATEIO_PRODUCAO from entradas where nf_entrada = ?v_entradas_00.nf_entrada and nome_clifor = ?v_entradas_00.NOME_CLIFOR AND serie_nf_entrada = ?v_entradas_00.serie_nf_entrada"
			F_Select(VLC_Select, 'cur_desc')
			
			IF cur_desc.ANM_RATEIO_PRODUCAO <> v_entradas_00.ANM_RATEIO_PRODUCAO
				*- Verifico se o titulo ja foi enviado para o banco
				VLC_Select = "SELECT COUNT(1) as num FROM CTB_BORDERO_PARCELA_NOTA (nolock) where LANCAMENTO_MOV = ?v_entradas_00.ctb_lancamento	and item_mov = ?v_entradas_00.nf_entrada.ctb_item" 
				F_Select(VLC_select, 'cur_bordero')
				
				IF cur_bordero.num > 0
					USE IN cur_desc
					USE IN cur_bordero
					MESSAGEBOX('Titulo já enviado para banco! Contactar o financeiro!', 16, wusuario)
					RETURN .F.
				ENDIF
				USE IN cur_bordero
				
				*- verifico se o lancamento do desconto ja foi efetuado
				SELECT curpropentradas
				LOCATE FOR propriedade = '00280'
				VLC_Lancamento = ''
				IF FOUND()
					VLC_Lancamento = curpropentradas.valor_propriedade
				ENDIF
				
				IF !f_vazio(VAL(VLC_Lancamento))
					*- Verifico se o lancamento ainda existe
					VLC_Select = "SELECT COUNT(1) as num FROM ctb_lancamento (nolock) where lancamento = " + VLC_Lancamento 
					F_Select(VLC_select, 'cur_lanc')
					
					IF cur_lanc.num > 0
						USE IN cur_desc
						USE IN cur_lanc
						MESSAGEBOX('Já existe lancamento de desconto! Contactar o financeiro!', 16, wusuario)
						RETURN .F.
					ENDIF
					USE IN cur_mov					
				
				ENDIF
				
				
				*-Verifico se o titulo ja teve alguma movimentacao que nao seja a baixa do desconto
				VLC_Select = "SELECT COUNT(1) as num FROM CTB_A_PAGAR_MOV (nolock) where LANCAMENTO_MOV = ?v_entradas_00.ctb_lancamento	and item_mov = ?v_entradas_00.nf_entrada.ctb_item" + IIF(f_vazio(VLC_Lancamento), '', " and lancamento <> '" + VLC_Lancamento + "'")
				F_Select(VLC_select, 'cur_mov')
				
				IF cur_mov.num > 0
					USE IN cur_desc
					USE IN cur_mov
					MESSAGEBOX('Titulo já foi movimentado. Não foi possível aplicar o desconto! Contactar o financeiro!', 16, wusuario)
					RETURN .F.
				ENDIF
				USE IN cur_mov
				
				*- WRP - 19/08/2016 (projeto nº)Verifico se o titulo ja teve algum acompanhamento
				VLC_Select = "SELECT COUNT(1) as num FROM w_ctb_acompanhamento (nolock) where LANCAMENTO = ?v_entradas_00.ctb_lancamento" + IIF(f_vazio(VLC_Lancamento), '', " and lancamento <> '" + VLC_Lancamento + "'")
				F_Select(VLC_select, 'cur_acomp')
				
				IF cur_acomp.num > 0
					USE IN cur_desc
					USE IN cur_acomp
					MESSAGEBOX('Titulo já foi movimentado no acompanhamento. Não foi possível aplicar o desconto! Contactar o financeiro!', 16, wusuario)
					RETURN .F.
				ENDIF
				USE IN cur_acomp
				*- FIM - WRP - 19/08/2016 (projeto nº)Verifico se o titulo ja teve algum acompanhamento
				
			ENDIF
			USE IN cur_desc
					
			
		ENDIF
		*MIT[1] - FIM		
		
		case UPPER(xmetodo) == 'USR_SAVE_AFTER'
			** Tiago Carvalho (SS) - 13/10/2016 - Se tiver gerando nota via excel salvo o numero da nota na tabela importada pelo excel
			If type("lcStrNomeArquivo") != 'U'
				TEXT TO lcSql TEXTMERGE noshow
					UPDATE A
							SET A.NF_SAIDA ='<<V_ENTRADAS_00.NF_ENTRADA>>',
								A.SERIE_NF ='<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>',
								A.FILIAL ='<<V_ENTRADAS_00.NOME_CLIFOR>>'
							FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
							INNER JOIN PRODUTOS B(NOLOCK)
								ON A.REFERENCIA = B.PRODUTO 
							INNER JOIN FILIAIS ORIGEM (NOLOCK)
								ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
							INNER JOIN FILIAIS DESTINO (NOLOCK)
								ON A.FILIAL_DESTINO = DESTINO.FILIAL 
							INNER JOIN NATUREZAS_ENTRADAS(NOLOCK)
								ON A.NATUREZA_SAIDA = NATUREZAS_ENTRADAS.NATUREZA 
							WHERE ORIGEM.MATRIZ_FISCAL = '<<V_ENTRADAS_00.filial>>'
								and A.FILIAL_DESTINO = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
								and a.NOME_ARQUIVO = '<<lcStrNomeArquivo>>'
								and A.ID_NOTA = '<<lcIntIdNota>>'
								and A.NATUREZA_SAIDA='<<v_entradas_00.NATUREZA>>'
								and A.NF_SAIDA is null
				ENDTEXT 
				f_execute (lcSql )
				RELEASE lcStrNomeArquivo , lcIntIdNota
			ENDIF
			
		xalias=alias()
		
		IF ALLTRIM(V_ENTRADAS_00.TIPO_ENTRADAS)	== 'FINANCEIRO'
			SELE V_ENTRADAS_00
		
				text to	xsel2 noshow textmerge
					SELECT COUNT(LTRIM(RTRIM(NF_ENTRADA))+LTRIM(RTRIM(NOME_CLIFOR))) AS CONTADOR FROM 
					(SELECT DISTINCT rtrim(B.NF_ENTRADA) as NF_ENTRADA,RTRIM(B.NOME_CLIFOR) AS NOME_CLIFOR,
					A.FILIAL,B.RATEIO_CENTRO_CUSTO FROM ENTRADAS A
					JOIN ENTRADAS_ITEM B
					ON A.NF_ENTRADA = B.NF_ENTRADA
					AND A.NOME_CLIFOR = B.NOME_CLIFOR
					AND A.SERIE_NF_ENTRADA = B.SERIE_NF_ENTRADA
					WHERE B.NOME_CLIFOR = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
					AND B.NF_ENTRADA = '<<V_ENTRADAS_00.NF_ENTRADA>>'
					AND B.SERIE_NF_ENTRADA = '<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>' 
					AND A.RATEIO_CENTRO_CUSTO NOT LIKE '%R%'
					GROUP BY B.NF_ENTRADA,B.NOME_CLIFOR,A.FILIAL,B.RATEIO_CENTRO_CUSTO) A
				endtext
			
				F_SELECT(XSEL2,'CURSELCONT')	

			SELE CURSELCONT
			IF CURSELCONT.CONTADOR >1
				
				text to	xupdate1 noshow textmerge
					UPDATE SEQUENCIAIS SET SEQUENCIA =
					(SELECT RIGHT((SEQUENCIA+1)+1000000000000000,LEN(SEQUENCIA)) FROM SEQUENCIAIS 
					WHERE TABELA_COLUNA = 'CTB_CENTRO_CUSTO_RATEIO.COD_RATEIO')
					WHERE TABELA_COLUNA = 'CTB_CENTRO_CUSTO_RATEIO.COD_RATEIO'		
				endtext
			
			F_UPDATE(XUPDATE1)
			
			F_SELECT("SELECT SEQUENCIA FROM SEQUENCIAIS WHERE TABELA_COLUNA = 'CTB_CENTRO_CUSTO_RATEIO.COD_RATEIO'","CURSELSEQ",ALIAS())
			
			PUBLIC XSEQ
			
			SELE CURSELSEQ
			XSEQ = ALLTRIM(CURSELSEQ.SEQUENCIA)
				 	
			SELE V_ENTRADAS_00	
				text to	xinsert2 noshow textmerge
					INSERT INTO CTB_CENTRO_CUSTO_RATEIO
					(DESC_RATEIO_CENTRO_CUSTO,INATIVO,RATEIO_CENTRO_CUSTO,RATEIO_ENTRAR_EM_LISTA)

					SELECT 'RATEIO GERADO PELO USUÁRIO' AS DESC_RATEIO_CENTRO_CUSTO,'0' AS INATIVO, 
					'R'+'<<XSEQ>>' AS RATEIO_CENTRO_CUSTO,'1' AS RATEIO_ENTRAR_EM_LISTA 
					FROM ENTRADAS WHERE NOME_CLIFOR = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
					AND NF_ENTRADA = '<<V_ENTRADAS_00.NF_ENTRADA>>'
					AND SERIE_NF_ENTRADA = '<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>'			
				endtext
				
				if !f_insert(xinsert2) 
					messagebox("Não foi possível Inserir o Rateio ",48,"Atenção_9!")
					retu .f.
				endif
			
			SELE V_ENTRADAS_00	
				text to	xinsert3 noshow textmerge
					INSERT CTB_CENTRO_CUSTO_RATEIO_ITEM
					(CENTRO_CUSTO,PORCENTAGEM,RATEIO_CENTRO_CUSTO,RATEIO_CENTRO_CUSTO_ITEM,COD_FILIAL)

					SELECT RATEIO_CENTRO_CUSTO AS CENTRO_CUSTO,SUM(PORCENTAGEM_ITEM_RATEIO) AS PORCENTAGEM,
					'R'+'<<XSEQ>>' AS RATEIO_CENTRO_CUSTO,
					0 + ROW_NUMBER() OVER (ORDER BY RATEIO_CENTRO_CUSTO ASC) as RATEIO_CENTRO_CUSTO_ITEM,
					NULL AS COD_FILIAL
					FROM ENTRADAS_ITEM WHERE NOME_CLIFOR = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
					AND NF_ENTRADA = '<<V_ENTRADAS_00.NF_ENTRADA>>'
					AND SERIE_NF_ENTRADA = '<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>'
					GROUP BY RATEIO_CENTRO_CUSTO				
				endtext
				
				if !f_insert(xinsert3) 
					messagebox("Não foi possível Inserir o Rateio ",48,"Atenção_9!")
					retu .f.
				endif
			
			SELE V_ENTRADAS_00
				text to	xupdate2 noshow textmerge
					UPDATE ENTRADAS SET RATEIO_CENTRO_CUSTO = 'R'+'<<XSEQ>>'
					WHERE NOME_CLIFOR = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
					AND NF_ENTRADA = '<<V_ENTRADAS_00.NF_ENTRADA>>'
					AND SERIE_NF_ENTRADA = '<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>'
				endtext
	
				F_UPDATE(XUPDATE2)
			
			SELE V_ENTRADAS_00					
				text to	xupdate3 noshow textmerge
					UPDATE A SET RATEIO_CENTRO_CUSTO = 'R'+'<<XSEQ>>'
					FROM(SELECT A.* FROM CTB_LANCAMENTO_ITEM A
					JOIN ENTRADAS C
					ON A.LANCAMENTO = C.CTB_LANCAMENTO
					WHERE C.NOME_CLIFOR = '<<V_ENTRADAS_00.NOME_CLIFOR>>'
					AND C.NF_ENTRADA = '<<V_ENTRADAS_00.NF_ENTRADA>>'
					AND C.SERIE_NF_ENTRADA = '<<V_ENTRADAS_00.SERIE_NF_ENTRADA>>') A
				endtext
			
				F_UPDATE(XUPDATE3)
				
				THISFORMSET.LX_FORM1.LX_pageframe1.PAGe1.PAgeframe1.PAGe1.TV_RATEIO_CENTRO_CUSTO.VALUE = 'R'+ XSEQ
				THISFORMSET.LX_FORM1.LX_pageframe1.PAGe1.PAgeframe1.PAGe1.TX_DESC_Centro_custo_rateio.VALUE = 'RATEIO GERADO PELO USUÁRIO'
				
			ENDIF	
		ENDIF
					
			if	!f_vazio(xalias)	
				sele &xalias 
			endif		
		
		
		case UPPER(xmetodo) == 'USR_REFRESH' 
			

				If type("thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao")<>"U"
					xvalor_producao = v_entradas_00.valor_total-nvl(v_entradas_00.anm_rateio_producao,0)	
					if thisformset.p_tool_status = "P"
						thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled = .F.
					endif	
					
					if	V_ENTRADAS_00.ANM_RATEIO_PRODUCAO<>0
						thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_valor_producao.visible=.t.
					else	
						thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_valor_producao.visible=.F.	
					endif	
				Endif	
		
				** Volta Valor do campo para default **
				Thisformset.lx_FORM1.tv_operacao.ReadOnly= .F.
		
		
		case UPPER(xmetodo) == 'USR_TRIGGER_AFTER'
			
			xalias=alias()
			
				*** Calcula Custos da nota despesa auxiliar *****
				************INICIO CUSTO MEDIO MATERIAIS*********************

				SELE V_ENTRADAS_00_DESPESA_AUX
				GO TOP

				SCAN
					
					TEXT TO xSelDespAux TEXTMERGE NOSHOW

						SELECT DISTINCT C.MATERIAL,C.COR_MATERIAL,B.FILIAL,QTDE,VALOR 
						FROM ENTRADAS_ITEM A 
							JOIN ESTOQUE_RET_MAT B
							ON 	A.NF_ENTRADA		= B.NF_ENTRADA			AND
						   		A.SERIE_NF_ENTRADA	= B.SERIE_NF_ENTRADA		AND
						   		A.NOME_CLIFOR		= B.NOME_CLIFOR	
								JOIN ESTOQUE_RET1_MAT C
								ON B.REQ_MATERIAL = C.REQ_MATERIAL	AND
								   B.FILIAL		  = C.FILIAL
						WHERE 	A.NF_ENTRADA = '<<V_ENTRADAS_00_DESPESA_AUX.NF_ENTRADA_DESPESA>>'				AND 
						  		A.SERIE_NF_ENTRADA = '<<V_ENTRADAS_00_DESPESA_AUX.SERIE_NF_ENTRADA_DESPESA>>'	AND 
						 		A.NOME_CLIFOR = '<<V_ENTRADAS_00_DESPESA_AUX.FORNECEDOR>>'

					ENDTEXT
					f_select(xSelDespAux,"curEntMat") 

					If RECCOUNT()>0

									text to	xselmov1 noshow	
										select a.*,sum(qtde_estoque) as qtde_estoque
										from 
										(select emissao,documento,material,cor_material,tipo,qtde,saldo,
										(valor) as valor_ent,
										convert(numeric(14,5),((valor)/qtde)) as valor_unit 
									endtext	


									Text to	xupd noshow				 
									   UPDATE Materiais_Cores    
									   set  custo_reposicao = convert(numeric(14,2),?xcustomedio),    
									   custo_a_vista = convert(numeric(14,2),?xcustomedio)    
									   WHERE Material=?curEntMat.material   
									   AND Cor_Material=?curEntMat.cor_material  
									Endtext		
									
									
									Sele curEntMat	
									go top	

									scan	
										
										f_prog_bar('Atualizando Preço Medio de Entrada do Material: '+allt(curEntMat.material)+'\'+allt(curEntMat.cor_material),recno(),reccount()) 
										
							
										xselmov2 = " from FX_ANM_Monta_Cardex_01 ('" +allt(curEntMat.material)+"' , '"+ ; 
					 		                                                allt(curEntMat.cor_material)+"' , '%' , NULL, 0) " + ;
										"where tipo='ENTRADA DE N.F.' and valor is not null  ) a " + ;
										"join estoque_materiais b  " + ;
										"on a.material=b.material and a.cor_material=b.cor_material " +;
										"group by emissao,documento,a.material,a.cor_material,tipo,qtde,saldo,valor_ent,valor_unit  "  
										

										if !f_select(xselmov1+xselmov2,"curCardex")
											messagebox('Não foi póssível selecionar movimentação dos materiais !',32,'Atenção_3 !!!')
											retu .f.
										endif		
										sele curCardex	
											xsaldoant		= 0
											xvalorant		= 0
											xvalorestapos	= 0
											xcustomedio	= 0
											xcustoant	= 0 
											xseq_calc                = 0  
										scan	
											xsaldoant		= iif( (curCardex.saldo-curCardex.qtde)<0,0,(curCardex.saldo-curCardex.qtde) )
											xvalorant		= xsaldoant * iif( (xseq_calc=0 and xsaldoant>0), curCardex.valor_unit , xcustoant )
											xvalorestapos	= curCardex.valor_ent+xvalorant
											xcustomedio	= xvalorestapos/iif(curCardex.saldo<=curCardex.qtde,curCardex.qtde,curCardex.saldo) 
											xcustoant	= xcustomedio 
											xseq_calc                = xseq_calc + 1 
										endscan							
										
										sele curEntMat	

										if !f_update(xupd)	 
											messagebox('Não foi póssível atualizar os custo medio dos materiais !',32,'Atenção_4 !!!')
											retu .f.
										endif	
										
										sele curEntMat	
										
									endscan	
									f_prog_bar()	
	
						Endif
						
				SELE V_ENTRADAS_00_DESPESA_AUX

				ENDSCAN
				************FIM CUSTO MEDIO MATERIAIS*********************	

			
			if	!f_vazio(xalias)	
				sele &xalias 
			endif

			*Mit[1]					
			VLC_Execute = "exec MIT_DESCONTO_PRODUCAO ?v_entradas_00.nome_clifor, ?v_entradas_00.nf_entrada, ?v_entradas_00.serie_nf_entrada"
			IF !f_execute(VLC_Execute)
				RETURN .F.
			ENDIF
			*MIT[1] - FIM

		
		
		endcase
	endproc
enddefine


**************************************************
*-- Class:        bt_duplica_item (c:\temp\bt_duplica_item.vcx)
*-- ParentClass:  lx_label (c:\program files\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/08/11 06:56:09 PM
*
DEFINE CLASS bt_duplica_item AS lx_label


	AutoSize = .F.
	FontBold = .T.
	Caption = "D.I"
	Height = 20
	Left = 5
	Top = 175
	Width = 20
	TabIndex = 52
	ForeColor = RGB(0,128,0)
	ZOrderSet = 16
	Name = "BT_DUPLICA_ITEM"
	Enabled = .t.
	vISIBLE = .t.

	PROCEDURE Click	
					
			sele V_ENTRADAS_00_ITENS
			GO TOP
			
			
			TEXT TO XSEL_ITENS NOSHOW TEXTMERGE 

			SELECT '<<V_ENTRADAS_00_ITENS.CODIGO_ITEM>>' AS CODIGO_ITEM,
				   CONVERT(NUMERIC(14,2),'<<V_ENTRADAS_00_ITENS.PRECO_UNITARIO>>') AS PRECO_UNITARIO,
				   CONVERT(NUMERIC(14,2),'<<V_ENTRADAS_00_ITENS.QTDE_ITEM>>') AS QTDE_ITEM,
				   '<<V_ENTRADAS_00_ITENS.DESCRICAO_ITEM>>' AS DESCRICAO_ITEM	    	
			
			ENDTEXT 
			
			f_select(XSEL_ITENS ,"curDuplicaItem")	
			
			SELECT curDuplicaItem
			GO TOP

				
				o_toolbar.Botao_filhas_inserir.Click()			
				sele V_ENTRADAS_00_ITENS
				
				
				repla CODIGO_ITEM WITH curDuplicaItem.CODIGO_ITEM
				thisformset.lx_FORM1.lx_pageframe1.page2.lx_grid_filha1.col_CODIGO_ITEM.tx_CODIGO_ITEM.SETFOCUS()
				thisformset.lx_FORM1.lx_pageframe1.page2.lx_grid_filha1.col_CODIGO_ITEM.tx_CODIGO_ITEM.l_desenhista_recalculo()
							
	
				sele V_ENTRADAS_00_ITENS
				
				
				repla QTDE_ITEM WITH curDuplicaItem.QTDE_ITEM
				Thisformset.lx_FORM1.lx_pageframe1.page2.lx_grid_filha1.col_QTDE_ITEM.tx_QTDE_ITEM.SETFOCUS()
				thisformset.lx_FORM1.lx_pageframe1.page2.lx_grid_filha1.col_QTDE_ITEM.tx_QTDE_ITEM.l_desenhista_recalculo()
					
				
				sele V_ENTRADAS_00_ITENS
				
				
				repla PRECO_UNITARIO with curDuplicaItem.PRECO_UNITARIO
				thisformset.lx_FORM1.lx_pageframe1.page2.lx_grid_filha1.col_PRECO_ITEM.col_PRECO_ITEM.l_desenhista_recalculo()
				thisformset.lx_FORM1.lx_pageframe1.page2.lx_grid_filha1.col_tv_rateio_centro_custo.tv_rateio_centro_custo.SETFOCUS()
									
			
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_duplica_item
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


	PROCEDURE DblClick	

		TEXT TO CurSelPgto TEXTMERGE NOSHOW
		
			SELECT 1 AS NF_PAGA 
			FROM ENTRADAS 
			INNER JOIN CTB_A_PAGAR_MOV 
			ON ( ENTRADAS.CTB_LANCAMENTO = CTB_A_PAGAR_MOV.LANCAMENTO_MOV 
			OR ENTRADAS.NUMERO_CONFERENCIA = CTB_A_PAGAR_MOV.LANCAMENTO_MOV ) 
			AND ENTRADAS.CTB_ITEM = CTB_A_PAGAR_MOV.ITEM_MOV 
			AND CTB_A_PAGAR_MOV.EMPRESA = 1 
			WHERE ENTRADAS.NF_ENTRADA = '<<v_entradas_00.nf_entrada>>' 
			AND ENTRADAS.SERIE_NF_ENTRADA = '<<v_entradas_00.serie_nf_entrada>>' 
			AND ENTRADAS.NOME_CLIFOR = '<<v_entradas_00.nome_clifor>>'
		
		ENDTEXT
		
		f_select(CurSelPgto,"xSelPgto",ALIAS())
		
		
		If thisformset.p_tool_status="P" and xSelPgto.NF_PAGA = 0  
			if messagebox("Deseja Inserir Desconto Financeiro?",4+32+256,"Atenção!")=6	
				thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled = .T.
				thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page2.tx_anm_rateio_producao.Setfocus()
				
			endif	
		Else
			if xSelPgto.NF_PAGA = 1
				messagebox("Nota Fiscal já esta Paga. Impossível Inserir o desconto !!",0+48) 
			endif
		Endif

	ENDPROC  


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
	Enabled = .T.	
	ForeColor = RGB(255,0,0)
	BorderColor = RGB(128,128,128)	
	SpecialEffect = 1 	
	BackStyle = 0 
	BorderStyle = 0 	
	INPUTMASK = "999 999 999.99"
	FontBold = .T.
	Readonly = .F.


	PROCEDURE Valid	
	
		IF THISFORMSET.P_TOOL_STATUS="P"
		
			if messagebox("Deseja Realmente Inserir Desconto Rateio para esta Nota ?",4+32+256,"Atenção!")=6
			
				xnf_entrada=v_entradas_00.nf_entrada
				xserie_nf_entrada=v_entradas_00.serie_nf_entrada
				xnome_clifor=v_entradas_00.nome_clifor
				xfilial=v_entradas_00.filial



				text to	xinsert1 noshow textmerge	
					UPDATE ENTRADAS SET ANM_RATEIO_PRODUCAO='<<v_entradas_00.ANM_RATEIO_PRODUCAO>>'
					WHERE NF_ENTRADA='<<XNF_ENTRADA>>' 
					and SERIE_NF_ENTRADA='<<XSERIE_NF_ENTRADA>>'  
					and NOME_CLIFOR='<<XNOME_CLIFOR>>'
				endtext			

				if !f_insert(xinsert1) 
					messagebox("Não foi possível Inserir Desconto Rateio na Entrada ",48,"Atenção_10!")
					retu .f.
				endif
				
				o_toolbar.Botao_refresh.Click()
							
			endif
		
			
		ENDIF	
		
	ENDPROC


	PROCEDURE DblClick	
	
		*If thisformset.p_tool_status="P"     
			if messagebox("Deseja Alterar o Status da Entrada?",4+32+256,"Atenção!")=6	
				thisformset.lx_form1.lx_pageframe1.page1.pageframe1.page2.tx_anm_rateio_producao.Enabled=.t. 
			endif	
		*Endif

	ENDPROC 



ENDDEFINE
*
*-- EndDefine: tx_anm_rateio_producao
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
** Tiago Carvalho (SS) 13/10/2016 - criado o botão para gerar as notas fiscais com base em uma importação de Excel da tela SS0065
*-- BeginDefine: Btn_Gerar_Notas_Fiscais 
**************************************************
DEFINE CLASS Btn_Gerar_Notas_Fiscais AS commandbutton
	
	
	Top = 65
	Left = 410
	Height = 16
	Width = 70
	Caption = "NFs Excel"
	Name = "Btn_Gerar_Notas_Fiscais"
	FontBold=.F.
	Fontsize=9
	tooltiptext="Gerar notas para excel importados na tela SS0065SS"
	
	PROCEDURE Click			
		** Tiago Carvalho (SS) 13/10/2016 - criado o botão para gerar as notas fiscais com base em uma importação de Excel da tela SS0065
		dtDataHoraInicio = DATETIME()

		TEXT TO lcSql TEXTMERGE NOSHOW 
			SELECT	A.NATUREZA_SAIDA,
						A.FILIAL_ORIGEM,
						A.FILIAL_DESTINO,
						A.REFERENCIA,
						A.QTDE,
						A.CUSTO,
						NOME_ARQUIVO = CONVERT(VARCHAR(100),A.NOME_ARQUIVO),
						MENSAGEM_ERRO = CONVERT(VARCHAR(240),
										CASE WHEN B.PRODUTO IS NULL THEN 'PROD NÃO CADASTRADO | '+CHAR(10) ELSE '' END +
										CASE WHEN B.PRODUTO IS NULL THEN 'PROD INATIVO | '+CHAR(10) ELSE '' END +
										CASE WHEN ORIGEM.FILIAL IS NULL THEN 'FILIAL ORIGEM NÃO CADASTRADA | ' ELSE '' END+
										CASE WHEN DESTINO.FILIAL IS NULL THEN 'FILIAL DESTINO NÃO CADASTRADA | ' ELSE '' END+
										CASE WHEN NATUREZAS_SAIDAS.NATUREZA_SAIDA IS NULL AND NATUREZAS_ENTRADAS.NATUREZA IS NULL  THEN 'NATUREZA NÃO CADASTRADA | ' ELSE '' END+        
										CASE WHEN QTDE  <= 0 THEN 'QTDE MENOR IGUAL A ZERO | ' ELSE '' END+
										CASE WHEN CUSTO <= 0 THEN 'CUSTO MENOR IGUAL A ZERO | ' ELSE '' END +
										CASE WHEN CLASSIF_FISCAL.CLASSIF_FISCAL like '0000%' THEN 'CLASSIF FISCAL ' + LTRIm(RTRIM(ISNULL(CLASSIF_FISCAL.CLASSIF_FISCAL,''))) + ' | ' ELSE '' END +
										CASE WHEN CLASSIF_FISCAL.INATIVO =1 THEN 'CLASSIF FISCAL INATIVA  ' + ' | ' ELSE '' END +
										CASE WHEN NATUREZAS_FILIAIS_BLOQUEADAS.FILIAL IS NOT NULL THEN 'NATUREZA BLOQUEADA PARA A FILIAL | ' ELSE '' END +
										CASE WHEN CLIENTES_ATACADO.BLOQUEIO_FATURAMENTO IS NOT NULL THEN 'DESTINO BLOQUEADO PARA FATURAMENTO | ' ELSE '' END )
										
					FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
					LEFT JOIN PRODUTOS B(NOLOCK)
						ON A.REFERENCIA = B.PRODUTO 
					LEFT JOIN CLASSIF_FISCAL (NOLOCK)
						ON CLASSIF_FISCAL.CLASSIF_FISCAL = B.CLASSIF_FISCAL 
					LEFT JOIN FILIAIS ORIGEM (NOLOCK)
						ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
					LEFT JOIN FILIAIS DESTINO (NOLOCK)
						ON A.FILIAL_DESTINO = DESTINO.FILIAL 
					LEFT JOIN NATUREZAS_SAIDAS (NOLOCK)
						ON A.NATUREZA_SAIDA = NATUREZAS_SAIDAS.NATUREZA_SAIDA 
					LEFT JOIN NATUREZAS_ENTRADAS (NOLOCK)    
						ON A.NATUREZA_SAIDA = NATUREZAS_ENTRADAS.NATUREZA    
					LEFT JOIN NATUREZAS_FILIAIS_BLOQUEADAS(NOLOCK)
						ON ORIGEM.MATRIZ_FISCAL = NATUREZAS_FILIAIS_BLOQUEADAS.FILIAL AND A.NATUREZA_SAIDA = NATUREZAS_FILIAIS_BLOQUEADAS.NATUREZA_SAIDA 
					LEFT JOIN CLIENTES_ATACADO (NOLOCK)
						ON A.FILIAL_DESTINO = CLIENTES_ATACADO.CLIENTE_ATACADO 
					WHERE A.NF_SAIDA IS NULL 
						and (B.PRODUTO IS NULL			or						
							 ORIGEM.FILIAL IS NULL		or						
							 DESTINO.FILIAL IS NULL		or				
							 ISNULL(NATUREZAS_SAIDAS.NATUREZA_SAIDA ,NATUREZAS_ENTRADAS.NATUREZA) IS NULL	or		
							 QTDE  <= 0				or						
							 CUSTO <= 0				or						
							 CLASSIF_FISCAL.CLASSIF_FISCAL like '0000%'	or	
							 CLASSIF_FISCAL.INATIVO = 1 OR 				
							 B.INATIVO = 1 OR 				
							 NATUREZAS_FILIAIS_BLOQUEADAS.FILIAL IS NOT NULL	or
							 CLIENTES_ATACADO.BLOQUEIO_FATURAMENTO IS NOT NULL 
							)

		ENDTEXT

		f_select (lcSql ,"CurErros")

		IF RECCOUNT("CurErros") > 0
			IF MESSAGEBOX("Existem inconsistências nos arquivos importados." + chr(10) + "Deseja Exportar a validação com os Erros?",4+16,"Exportar Erros")==6

				strcaminho = PUTFILE("Nome:","Relatório de Erros.xls","xls")

				if empty(NVL(strcaminho,''))
					messagebox("Operação Cancelada!",0+64,"Caminho Inválido!")
					return .f.
				endif
				
				SELECT CurErros
				GO top
					
				COPY TO (strcaminho) XLS 
			ENDIF
			messagebox("Erros no Arquivo, Geração da Nota Fiscal Cancelada!",0+16,"Verifique os Erros gerados!")
			
			RETURN .F.
		ENDIF

		IF USED("CurErros")
			USE IN "CurErros"
		ENDIF
		
		** Crio um id para agrupar as notas a cada 400 itens para enviar que o XMl fique grande e o sefaz recuse a nota fiscal
		TEXT TO lcSql TEXTMERGE NOSHOW 
			IF ISNULL(OBJECT_ID('TEMPDB..#TMPIDNOTA') ,0) > 0 
			BEGIN
				DROP TABLE #TMPIDNOTA
			END
			SELECT ID , ID_NOTA = ROW_NUMBER () OVER(PARTITION BY NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL ORDER BY NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL	 DESC) /400
			INTO #TMPIDNOTA
			FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
			INNER JOIN FILIAIS ORIGEM (NOLOCK)
				ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
			INNER JOIN FILIAIS DESTINO (NOLOCK)
				ON A.FILIAL_DESTINO = DESTINO.FILIAL 
			WHERE A.ID_NOTA IS NULL
			ORDER BY NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL	
				
			UPDATE A
				SET A.ID_NOTA = B.ID_NOTA
			FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A
			INNER JOIN #TMPIDNOTA B
				ON A.ID = B.ID 
		ENDTEXT 

		f_execute (lcSql)
		
		TEXT TO lcSql TEXTMERGE NOSHOW 
			SELECT	A.NATUREZA_SAIDA,
					A.FILIAL_ORIGEM,
					A.FILIAL_DESTINO,
					ORIGEM.MATRIZ_FISCAL,
					ORIGEM.COD_FILIAL,
					NOME_ARQUIVO = convert(varchar(200),LTRIM(RTRIM(A.NOME_ARQUIVO))),
					QTDE = COUNT(distinct REFERENCIA ),
					ID_NOTA  
				FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
				INNER JOIN PRODUTOS B(NOLOCK)
					ON A.REFERENCIA = B.PRODUTO 
				INNER JOIN FILIAIS ORIGEM (NOLOCK)
					ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
				INNER JOIN FILIAIS DESTINO (NOLOCK)
					ON A.FILIAL_DESTINO = DESTINO.FILIAL 
				INNER JOIN NATUREZAS_ENTRADAS (NOLOCK)
					ON A.NATUREZA_SAIDA = NATUREZAS_ENTRADAS.NATUREZA  
				WHERE A.NF_SAIDA IS NULL
				GROUP BY A.NATUREZA_SAIDA, A.FILIAL_ORIGEM, A.FILIAL_DESTINO, A.NOME_ARQUIVO,ORIGEM.MATRIZ_FISCAL,ORIGEM.COD_FILIAL,ID_NOTA  
				order by QTDE ,  NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL
		ENDTEXT

		f_select (lcSql ,"CurFiliaisNotas")

		SELECT CurFiliaisNotas
		GO TOP 
		SCAN
			PUBLIC lcStrNomeArquivo , lcIntIdNota
						
			lcStrNatureza 		= ALLTRIM(CurFiliaisNotas.NATUREZA_SAIDA)
			lcStrFilialOrigem 	= ALLTRIM(CurFiliaisNotas.FILIAL_ORIGEM)
			lcStrFilialDestino 	= ALLTRIM(CurFiliaisNotas.FILIAL_DESTINO)
			lcStrMatrizFiscal 	= ALLTRIM(CurFiliaisNotas.MATRIZ_FISCAL)
			lcStrNomeArquivo	= ALLTRIM(CurFiliaisNotas.NOME_ARQUIVO)
			lcStrCodFilial		= ALLTRIM(CurFiliaisNotas.cod_filial)
			lcIntIdNota			= CurFiliaisNotas.ID_NOTA  
			
			WAIT windows "Gerando Nota Fiscal da Filial:" + lcStrFilialOrigem +" Destino:" + lcStrFilialDestino + " Natureza:" + lcStrNatureza  nowait
			
			IF thisformset.p_tool_status == "I"
				m.o_toolbar.BOtao_cancela.Click()
				m.o_toolbar.BOTAO_Limpa.Click()
			ELSE
				m.o_toolbar.BOTAO_Limpa.Click()
			ENDIF
				
			m.o_toolbar.botao_inclui.Click()
			
			thisform.tv_operacao.Value = lcStrNatureza 
			thisform.tv_operacao.InteractiveChange()
			thisform.tv_operacao.Valid()
			thisform.tv_operacao.LostFocus()
			
			thisform.tv_filial_entrada.SetFocus()
			thisform.tv_filial_entrada.Value = lcStrMatrizFiscal 
			thisform.tv_filial_entrada.InteractiveChange()
			thisform.tv_filial_entrada.Valid()
			thisform.tv_filial_entrada.LostFocus()
			
			thisform.lx_pageframe1.page1.pageframe1.page1.Ck_nf_propria.Value = .T.
			thisform.lx_pageframe1.page1.pageframe1.page1.Ck_nf_propria.LostFocus()
						
			thisform.tx_serie_nf.SetFocus()
			thisform.tx_serie_nf.Value = '12'
			thisform.tx_serie_nf.InteractiveChange()
			thisform.tx_serie_nf.Valid()		
			thisform.tx_serie_nf.LostFocus()

			thisform.tv_nome_clifor.SetFocus()
			thisform.tv_nome_clifor.Value =lcStrFilialDestino  
			thisform.tv_nome_clifor.InteractiveChange()		
			thisform.tv_nome_clifor.Valid()
			thisform.tv_nome_clifor.LostFocus()

			thisform.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.SetFocus()
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.Value='08'
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_condicao_pgto.LostFocus()

			thisform.lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.SetFocus()
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.Value='NOTA FISCAL ELETRONICA'
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_Desc_Especie_Serie.LostFocus()
			

			thisform.lx_pageframe1.page1.pageframe1.page1.pageframe1.page1.tv_TRANSPORTADORA_A_PAGAR.SetFocus()
			thisform.lx_pageframe1.page1.pageframe1.page1.pageframe1.page1.tv_TRANSPORTADORA_A_PAGAR.Value='CORREIOS'
			thisform.lx_pageframe1.page1.pageframe1.page1.pageframe1.page1.tv_TRANSPORTADORA_A_PAGAR.LostFocus()

			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_filial.SetFocus()
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_filial.Value = lcStrCodFilial
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_filial.InteractiveChange()
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_filial.Valid()
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_filial.LostFocus()
			
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_centro_custo.SetFocus()
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_centro_custo.Value = '1.000002'
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_centro_custo.InteractiveChange()
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_centro_custo.Valid()
			thisform.lx_pageframe1.page1.pageframe1.page1.tv_rateio_centro_custo.LostFocus()

			ThisFormset.Lx_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page1.tv_serie_nf_intena.SetFocus()
			ThisFormset.Lx_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page1.tv_serie_nf_intena.Value = '12'
			ThisFormset.Lx_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page1.tv_serie_nf_intena.InteractiveChange()
			ThisFormset.Lx_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page1.tv_serie_nf_intena.Valid()
			ThisFormset.Lx_form1.LX_PAGEFRAME1.Page1.Pageframe1.Page1.tv_serie_nf_intena.LostFocus()
			
			thisform.lx_pageframe1.ActivePage=2

			THISFORM.LX_PAgeframe1.page2.Chk_produtos.Value = .T.
			THISFORM.LX_PAgeframe1.page2.Chk_produtos.LostFocus()
			
			THISFORM.LX_PAgeframe1.page2.Chk_Materiais.Value = .F.
			THISFORM.LX_PAgeframe1.page2.Chk_materiais.LostFocus()
			
			THISFORM.LX_PAgeframe1.page2.Chk_itens_fiscais.Value = .F.
			THISFORM.LX_PAgeframe1.page2.Chk_itens_fiscais.LostFocus()


			TEXT TO lcSql TEXTMERGE NOSHOW 
				SELECT	A.NATUREZA_SAIDA,
						A.FILIAL_ORIGEM,
						A.FILIAL_DESTINO,
						ORIGEM.MATRIZ_FISCAL,
						A.REFERENCIA,
						NOME_ARQUIVO = convert(varchar(200),LTRIM(RTRIM(A.NOME_ARQUIVO))),
						QTDE = SUM(A.QTDE),	
						CUSTO = MAX(A.CUSTO),
						PESO = ISNULL(B.PESO ,0)
					FROM SS_FATURAMENTO_AUTOMATICO_EXCEL A(NOLOCK)
					INNER JOIN PRODUTOS B(NOLOCK)
						ON A.REFERENCIA = B.PRODUTO 
					INNER JOIN FILIAIS ORIGEM (NOLOCK)
						ON A.FILIAL_ORIGEM = ORIGEM.FILIAL 
					INNER JOIN FILIAIS DESTINO (NOLOCK)
						ON A.FILIAL_DESTINO = DESTINO.FILIAL 
					inner JOIN NATUREZAS_ENTRADAS (NOLOCK)
						ON A.NATUREZA_SAIDA = NATUREZAS_ENTRADAS.NATUREZA  
					WHERE A.NF_SAIDA IS NULL
						and A.NATUREZA_SAIDA		= '<<lcStrNatureza>>' 		
						and A.FILIAL_ORIGEM			= '<<lcStrFilialOrigem>>'
						and A.FILIAL_DESTINO		= '<<lcStrFilialDestino>>'
						and ORIGEM.MATRIZ_FISCAL	= '<<lcStrMatrizFiscal>>'
						and a.NOME_ARQUIVO			= '<<lcStrNomeArquivo>>'
						and A.ID_NOTA 				= '<<lcIntIdNota>>'
					GROUP BY A.NATUREZA_SAIDA, A.FILIAL_ORIGEM, A.FILIAL_DESTINO, A.REFERENCIA, A.NOME_ARQUIVO,ORIGEM.MATRIZ_FISCAL,B.PESO 
					order by NOME_ARQUIVO,FILIAL_ORIGEM , FILIAL_DESTINO ,ORIGEM.MATRIZ_FISCAL
			ENDTEXT

			f_select (lcSql ,"CurDadosNotasFiscais")

			SELECT CurDadosNotasFiscais
			GO top
			SCAN 
			
				lcStrReferencia = ALLTRIM(CurDadosNotasFiscais.referencia)
				lcQtde  = CurDadosNotasFiscais.qtde
				lcCusto = CurDadosNotasFiscais.CUSTO
				lcPeso  = CurDadosNotasFiscais.peso
				
				thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page2.tx_peso_bruto.Value 	= thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page2.tx_peso_bruto.Value + lcPeso  
				thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page2.tx_PESO.Value 		= thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page2.tx_PESO.Value + lcPeso  
				
				M.o_toolbar.botao_filhas_inserir.Click()

				SELECT v_entradas_00_itens 

				THISFORM.LX_PAgeframe1.page2.lx_grid_filha1.COL_CODIGO_ITEM.tx_CODIGO_ITEM.SetFocus()
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_CODIGO_ITEM.TX_CODIGO_ITEM.Value = lcStrReferencia 
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_CODIGO_ITEM.TX_CODIGO_ITEM.LostFocus()
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_CODIGO_ITEM.TX_CODIGO_ITEM.Valid()
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_CODIGO_ITEM.TX_CODIGO_ITEM.L_DEsenhista_recalculo ()

				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_QTDE_ITEM.SetFocus()
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_QTDE_ITEM.TX_QTDE_ITEM.Value = lcQtde  
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_QTDE_ITEM.TX_QTDE_ITEM.LostFocus()
			
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_PRECO_ITEM.COL_PRECO_ITEM.SetFocus()
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_PRECO_ITEM.COL_PRECO_ITEM.Value = lcCusto 
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_PRECO_ITEM.COL_PRECO_ITEM.Valid()
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.COL_PRECO_ITEM.COL_PRECO_ITEM.L_DEsenhista_recalculo ()
			
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.col_pESO.tx_PESO.SetFocus()
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.col_pESO.tx_PESO.Value = lcPeso  
				THISFORM.LX_PAgeframe1.page2.LX_grid_filha1.col_pESO.tx_PESO.LostFocus()
						
				SELECT CurDadosNotasFiscais
				
			ENDSCAN
			
			IF USED("CurDadosNotasFiscais")
				USE IN CurDadosNotasFiscais
			ENDIF
			
			IF thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page2.tx_peso_bruto.Value <= 0
				thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page2.tx_peso_bruto.Value = 1
				thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page2.tx_PESO.Value  = 1
			endif
			
			thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.pageframe1.page2.tx_EMBALAGENS.Value = 1
			
			m.o_toolbar.botao_salva.Click()
			
			SELECT CurFiliaisNotas

		ENDSCAN
		
		strMinutos = ALLTRIM(STR((DATETIME() - dtDataHoraInicio) / 60))
		strSegundos = ALLTRIM(STR(MOD((DATETIME() - dtDataHoraInicio), 60)))

		MESSAGEBOX('Tempo total: ' + strMinutos + ' minuto(s) e ' + strSegundos + ' segundo(s).',0+64,"Importação Concuída")
		
	ENDPROC
ENDDEFINE
*-- endDefine: Btn_Gerar_Notas_Fiscais 
**************************************************
