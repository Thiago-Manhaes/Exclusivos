* Cria��o *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HOR�RIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Sele��o por Acompanhamento					                    *
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
				
				case upper(xmetodo) == 'USR_INIT'  && AND 1=2
				
					public xPai_Filtro,xCpfNovo,xCpfAnterior,xCobrancaAnterior,XdataCobrancaAnterior
					xPai_Filtro=thisformset.p_pai_filtro
				
					xalias=alias()
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Vers�o: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
					**Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
					sele V_CTB_CHEQUE_A_RECEBER_00
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("ANM_COBRANCA", "C(25)",.T., "ANM_COBRANCA", "CTB_CHEQUE_CARTAO.ANM_COBRANCA")
					oCur.addbufferfield("ANM_DATA_COBRANCA", "C(25)",.T., "ANM_DATA_COBRANCA", "CTB_CHEQUE_CARTAO.ANM_DATA_COBRANCA")
					oCur.addbufferfield("SPACE(1) AS OCORRENCIA", "C(25)",.T., "OCORRENCIA", "")					
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
					
					
						*thisform.dataEnvironment.cUR_V_CTB_ACOMPANHAMENTO_00.KeyFieldList="EMPRESA, LANCAMENTO, ITEM, SUB_ITEM, DATA_DIGITACAO, DATA_ACOMPANHAMENTO, OCORRENCIA"    
					
						text to xsel_ocorrencia noshow textmerge	
							select convert(varchar(50),'') as desc_ocorrencia,'' as ocorrencia
							union all
							select convert(varchar(50),'SEM OCORR�NCIA') as desc_ocorrencia,'88' as ocorrencia
							union all
							select desc_ocorrencia,ocorrencia from ctb_ocorrencia
						endtext
					

						f_select(xsel_ocorrencia ,"curOcorrencias",alias())
						f_select("select valor_propriedade from propriedade_valida where propriedade = '00069' union all select ''","CurCobranca",ALIAS())

			             with thisformset.lx_form1.lx_PAGEFRAME1.page1	
								
								.addObject("cmb_acompanhamento","lx_combobox")
								.cmb_acompanhamento.visible=.t.
								.cmb_acompanhamento.top=350
								.cmb_acompanhamento.left=420
								.cmb_acompanhamento.width=202
								.cmb_acompanhamento.controlsource=curOcorrencias.desc_ocorrencia
								.cmb_acompanhamento.rowsource='curOcorrencias.desc_ocorrencia'
								.cmb_acompanhamento.enabled=.t.
								.cmb_acompanhamento.rowsourcetype=2
								.cmb_acompanhamento.value='' 
								.cmb_acompanhamento.Anchor=0
								.addobject("label_acompanhamento","label_acompanhamento")
								.Lx_label9.visible=.F.
								.addObject("Anm_label_consumidor","Anm_label_consumidor")
								.addobject("label_cobranca","label_cobranca")
								.addObject("cmb_cobranca","lx_combobox")
								.cmb_cobranca.visible=.t.
								.cmb_cobranca.top=414
								.cmb_cobranca.left=420
								.cmb_cobranca.width=131
								.cmb_cobranca.controlsource='V_CTB_CHEQUE_A_RECEBER_00.ANM_COBRANCA'
								.cmb_cobranca.rowsource='CurCobranca.valor_propriedade'
								.cmb_cobranca.enabled=.t.
								.cmb_cobranca.rowsourcetype=2
								.cmb_cobranca.Anchor=0
								.addObject("tx_data_cobranca","tx_data_cobranca")						
								.tv_moeda.Visible= .F.
			              endwith	
					
							thisformset.l_limpa()
					
					if !f_vazio(xalias)
						sele &xalias
					endif	


				case upper(xmetodo) == 'USR_SEARCH_BEFORE'  && AND 1=2
					
					xalias=alias()
					
					If type("thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_acompanhamento")<>"U"
						
						if 	!f_vazio(thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_acompanhamento.value)
							
							if thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_acompanhamento.value <> 'SEM OCORR�NCIA'
							
								text to xFiltroObj noshow textmerge	
									ltrim(rtrim(convert(char(10),isnull(w_ctb_a_receber_cheque.lancamento,0))))+ltrim(rtrim(convert(char(10),isnull(w_ctb_a_receber_cheque.item,0))))+ltrim(rtrim(convert(char(10),isnull(w_ctb_a_receber_cheque.sub_item,0)))) in		
									(select ltrim(rtrim(convert(char(10),isnull(lancamento,0))))+ltrim(rtrim(convert(char(10),isnull(item,0))))+ltrim(rtrim(convert(char(10),isnull(sub_item,0)))) as chave from ctb_acompanhamento where ocorrencia in 
									(select ocorrencia from ctb_ocorrencia where desc_ocorrencia='<<thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_acompanhamento.value>>'))						
								endtext	
								
							else	
								text to xFiltroObj noshow textmerge	
									anm_existe_ocorrencia=0
								endtext	
							
							endif		
							
							
							if !f_vazio(thisformset.p_pai_filtro)
								xAnd = " and "
							else
								xAnd = ""
							endif
								
							thisformset.p_pai_filtro=thisformset.p_pai_filtro+xAnd+xFiltroObj 
								
						endif	
						
					Endif	
					
					thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_acompanhamento.Enabled = .F.
					thisformset.lx_FORM1.lx_pageframe1.page1.cmb_cobranca.Enabled= .F.
					
					if !f_vazio(xalias)
						sele &xalias
					endif	

				case upper(xmetodo) == 'USR_CLEAN_AFTER'  && AND 1=2

					If type("thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_acompanhamento")<>"U"
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_acompanhamento.Enabled = .T.
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_acompanhamento.value=""
						thisformset.p_pai_filtro=xPai_Filtro
					Endif	
					
					If type("thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_cobranca")<>"U"
						thisformset.lx_FORM1.lx_pageframe1.page1.cmb_cobranca.Enabled= .T.
						THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.Enabled= .T.
						thisformset.lx_form1.lx_PAGEFRAME1.page1.cmb_cobranca.value=""
					Endif


				* WRP - 14/11/2018 - Verifica se o cliente tem cheque baixado pelo contabilidade
				case upper(xmetodo) == 'USR_SEARCH_AFTER'  && AND 1=2

					xcpf_filtro = NVL(thisformset.lx_FORM1.lx_pageframe1.page1.tv_codigo_consumidor.value,"0")
					
					*MESSAGEBOX(xcpf_filtro)
			
					
							text to xsel_cli_block noshow textmerge	
							
								select COUNT(*) AS REG from GS_BLOQUEIA_CPF_CHEQUES_DEVOLVIDOS_ANTIGOS where codigo_consumidor = '<<xcpf_filtro>>' and status='BLOQUEADO'
								
							endtext
						

							f_select(xsel_cli_block ,"cur_cli_block",alias())
							
							xcount = NVL(cur_cli_block.reg,"0")
							
							*MESSAGEBOX(xcount)
						
						If xcount > 0
						
							IF MESSAGEBOX("Existem cheques baixados pela contabilidade no qual o cliente ainda encontra-se bloqueado, Deseja visualizar mais informa��es?",4+48,"Aviso Importante!!!")=6
							
							
							text to xFiltroChequeCliente noshow textmerge	
								SELECT a.empresa
									,a.LANCAMENTO
									,a.ITEM
									,LANCAMENTO_MOV
									,SUB_ITEM
									,a.cod_clifor
									,a.nome_clifor
									,VALOR_MOV
									,ALINEA_DEVOLUCAO
									,codigo_consumidor
									,cliente_varejo
									,vencimento
									,valor_original
									,valor_a_receber
									,nr_devolucoes
									,descr_devolucao
									,HISTORICO_MOV
									,numero_cheque_cartao
									,cheque_banco
									,cheque_agencia
									,cmc7_cvcartao
									,a.DATA_DIGITACAO
									,a.vencimento_real
									,venda_documento
									,loja_lancamento_caixa
									,inativo
								FROM w_CTB_CHEQUE_CARTAO_MOV a(NOLOCK)
								JOIN cadastro_cli_for c(NOLOCK) ON a.cod_clifor = c.cod_clifor
								JOIN CTB_LANCAMENTO d(NOLOCK) ON a.LANCAMENTO = d.LANCAMENTO
								JOIN CTB_LANCAMENTO_ITEM f(NOLOCK) ON A.LANCAMENTO = F.LANCAMENTO
									AND A.ITEM = F.ITEM
								JOIN FILIAIS e(NOLOCK) ON d.COD_FILIAL = e.COD_FILIAL
								WHERE nr_devolucoes = 1
									AND d.lancamento IN ('8197127','8197128','8198942','8199296','8199298','8199368','8208690','8208752','8209279','8211169','8214759','8214914','8215072','8215888','8216359','8222805')
								and codigo_consumidor = '<<xcpf_filtro>>'
							endtext							
							
							f_select(xFiltroChequeCliente ,"cur_cli_cheque",alias())
							
							SELECT cur_cli_cheque
							*!*	BROWSE normal
							*!*	RETURN .f.
							GO top	


								xFile = "'"+PUTFILE('','','xls')+"'"
								IF LEN(xFile) > 2 THEN 
									COPY TO &xFile XLS
									MESSAGEBOX("Exportado com Sucesso Para:"+CHR(13)+xFile,64) 
								ENDIF 
								*RETURN .F.

							*messagebox("Existem cheques baixados pela contabilidade no qual o cliente ainda encontra-se bloqueado",0,"Aviso Importante!!!")
							ENDIF
						Endif			
				
				
				case upper(xmetodo) == 'USR_WHEN' AND upper(xnome_obj) == 'TX_DATA_COBRANCA'
				
					THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.Value=CTOD('')
				
				
				
				case upper(xmetodo) == 'USR_VALID'
				
				IF thisformset.p_tool_status == 'P'
				
					IF upper(xnome_obj) == 'TV_CODIGO_CONSUMIDOR'
						
						IF MESSAGEBOX("Deseja Alterar o CPF do Cliente ?",4+32)=6
						
							xCpfNovo = Thisformset.lx_FORM1.lx_pageframe1.page1.tv_codigo_consumidor.value
							
							TEXT TO XUPD TEXTMERGE NOSHOW
							
								update CTB_CHEQUE_CARTAO set
								codigo_consumidor = '<<xCpfNovo>>'
								where lancamento = '<<V_CTB_CHEQUE_A_RECEBER_00.LANCAMENTO>>'
								and numero_cheque_cartao = '<<V_CTB_CHEQUE_A_RECEBER_00.NUMERO_CHEQUE_CARTAO>>'
								and sub_item = '<<V_CTB_CHEQUE_A_RECEBER_00.SUB_ITEM>>'
							
							ENDTEXT
							
							f_update(xupd)
							
							TEXT TO XSELCLI TEXTMERGE NOSHOW
							
								select top 1 nome_clifor from
								(select nome_clifor,cgc_cpf from cadastro_cli_for 
								union all 
								select cliente_varejo,cpf_cgc from clientes_varejo) a
								where cgc_cpf = '<<xCpfNovo>>'
							
							ENDTEXT
						
							f_select(xselcli,"xNomeCliente",ALIAS())
							
							thisformset.lx_FORM1.lx_pageframe1.page1.tv_codigo_consumidor.Enabled=.F.
							thisformset.lx_FORM1.lx_pageframe1.page1.tx_cliente_varejo.Value = xNomeCliente.nome_clifor
							thisformset.lx_FORM1.lx_pageframe1.page1.tx_cgc_cpf_consumidor.Value = xCpfNovo
							
							MESSAGEBOX("CPF Alterado com Sucesso !!!",0+48)
						
						ELSE
						
							Thisformset.lx_FORM1.lx_pageframe1.page1.tv_codigo_consumidor.value = xCpfAnterior
							
						ENDIF
					
						thisformset.lx_FORM1.lx_pageframe1.page1.tv_codigo_consumidor.Enabled=.F.
						
					ENDIF
						
					IF upper(xnome_obj) == 'CMB_COBRANCA'	
						
						IF !f_vazio(THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.cmb_cobranca.value)
							THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.setfocus()
							THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.value=DATE()
						ELSE
							THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.value=CTOD('')
						ENDIF	
						
					ENDIF
									
				ENDIF


				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE


**************************************************
*-- Class:        label_acompanhamento (c:\temp\v7\label_colecao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   06/09/09 11:07:14 AM
*
DEFINE CLASS tx_data_cobranca AS lx_textbox_base

	visible=.t.
	top=414
	left=555
	width=70
	Name = "tx_data_cobranca"
	controlsource='V_CTB_CHEQUE_A_RECEBER_00.ANM_DATA_COBRANCA'
	Enabled=.t.
	Visible	= .T.


ENDDEFINE
*
*-- EndDefine: label_acompanhamento
**************************************************


**************************************************
*-- Class:        label_acompanhamento (c:\temp\v7\label_colecao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   06/09/09 11:07:14 AM
*
DEFINE CLASS Anm_label_consumidor AS lx_label

	AutoSize = .F.
	Caption = "Consumidor:"
	p_muda_size_obrigatorio = .F.
	Name = "Anm_label_consumidor"
	Height = 15
	Left = 12
	Top = 234
	Width = 84
	Visible	= .T.
	Enabled=.T.
	
	PROCEDURE DblClick
		
		dodefault()
		
		IF thisformset.p_tool_status='P'		
		
			thisformset.lx_FORM1.lx_pageframe1.page1.tv_codigo_consumidor.Enabled= .T.
			xCpfAnterior = thisformset.lx_FORM1.lx_pageframe1.page1.tv_codigo_consumidor.value
			
			
		ENDIF
						
	ENDPROC

ENDDEFINE
*
*-- EndDefine: label_acompanhamento
**************************************************

**************************************************
*-- Class:        label_cobranca (c:\temp\v7\label_colecao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   06/09/09 11:07:14 AM
*
DEFINE CLASS label_cobranca AS commandbutton


	AutoSize = .F.
	Caption = "COBRAN�A"
	Height = 15
	Left = 335
	Top = 415
	Width = 80
	Height=20
	TabIndex = 56
	ZOrderSet = 25
	p_muda_size_obrigatorio = .F.
	Name = "label_acompanhamento"
	Visible	= .T.
	FontBold = .T.
	ForeColor=RGB(255,0,0)

	PROCEDURE Click
		
		dodefault()
		
		IF thisformset.p_tool_status='P' AND this.Caption == "COBRAN�A"		
			
			this.Caption="SALVAR"
			xCobrancaAnterior = V_CTB_CHEQUE_A_RECEBER_00.ANM_COBRANCA
			XdataCobrancaAnterior = V_CTB_CHEQUE_A_RECEBER_00.ANM_DATA_COBRANCA
			thisformset.lx_FORM1.lx_pageframe1.page1.cmb_cobranca.Enabled= .T.
			THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.Enabled= .T.
			
			IF f_vazio(THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.cmb_cobranca.value)
				THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.Value=CTOD('')
			ENDIF
				
						
		ELSE
		
			IF thisformset.p_tool_status='P' AND this.Caption == "SALVAR"		
				
				this.Caption="COBRAN�A"
				thisformset.lx_FORM1.lx_pageframe1.page1.cmb_cobranca.Enabled= .F.
				THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.Enabled= .F.
				IF MESSAGEBOX("Deseja Alterar/Incluir Cobran�a ?",4+32)=6
						
								xCobranca = Thisformset.lx_FORM1.lx_pageframe1.page1.cmb_cobranca.value
						
								TEXT TO XUPD2 TEXTMERGE NOSHOW
								
									UPDATE CTB_CHEQUE_CARTAO 
									SET ANM_COBRANCA = '<<xCobranca>>',ANM_DATA_COBRANCA='<<V_CTB_CHEQUE_A_RECEBER_00.ANM_DATA_COBRANCA>>'
									WHERE LANCAMENTO = '<<V_CTB_CHEQUE_A_RECEBER_00.LANCAMENTO>>'
									AND SUB_ITEM = '<<V_CTB_CHEQUE_A_RECEBER_00.SUB_ITEM>>'
								
								ENDTEXT
										
						f_update(xupd2)
										
					*MESSAGEBOX("Cobran�a Cadastrada com Sucesso !!!",0+48)	
				ELSE
					
					thisformset.lx_FORM1.lx_pageframe1.page1.cmb_cobranca.Enabled= .F.
					thisformset.lx_FORM1.lx_pageframe1.page1.cmb_cobranca.value=xCobrancaAnterior
					THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.Enabled= .F.
					THISFORMSET.LX_FORM1.LX_pageframe1.PAge1.TX_DATA_COBRANCA.value=XdataCobrancaAnterior
							
				ENDIF
		
			ENDIF
		
		ENDIF	
						
	ENDPROC

ENDDEFINE
*
*-- EndDefine: label_cobranca 
**************************************************


**************************************************
*-- Class:        label_acompanhamento (c:\temp\v7\label_colecao.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   06/09/09 11:07:14 AM
*
DEFINE CLASS label_acompanhamento AS lx_label


	AutoSize = .F.
	Caption = "Acompanhamento:"
	Height = 15
	Left = 309
	Top = 352
	Width = 110
	TabIndex = 56
	ZOrderSet = 25
	p_muda_size_obrigatorio = .F.
	Name = "label_acompanhamento"
	Visible	= .T.
	FontBold = .F.


ENDDEFINE
*
*-- EndDefine: label_acompanhamento
**************************************************

