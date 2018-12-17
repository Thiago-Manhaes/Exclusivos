* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao coluna 1ª Reserva e Filiais Estoque					                    *
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
					
					xVersao = '01.1'
					f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
					f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
					WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
					
					PUBLIC xOldFilial,xFilConsumo
					
					THISFORMSET.lx_FORM1.addobject("bt_geraop_conserto","bt_geraop_conserto")
					
					sele v_producao_ordem_01
					xalias_pai=alias()
					
	  				oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("FILIAL_PRODUCAO", "C(25)",.T., "FILIAL_PRODUCAO", "PRODUCAO_ORDEM.FILIAL_PRODUCAO")		
					oCur.confirmstructurechanges() 	
					
					sele v_filiais_00
					xalias_pai=alias()
					
					oCur = getcursoradapter(xalias_pai)
					oCur.addbufferfield("FILIAIS.CTRL_PRODUCAO_PRODUTO", "L",.T., "CTRL_PRODUCAO_PRODUTO", "FILIAIS.CTRL_PRODUCAO_PRODUTO")
					oCur.addbufferfield("CADASTRO_CLI_FOR.INATIVO", "L",.T., "INATIVO", "CADASTRO_CLI_FOR.INATIVO")
					oCur.confirmstructurechanges()
					
					thisformset.lx_form1.lx_pageframe1.page2.Lx_label9.Caption='Filial'
					
					THISFORMSET.L_LIMPA()
					
					WITH THISFORMSET.lx_form1.lx_PAGEFRAME1.page2 	
						.Lx_label8.visible=.f.
						.lx_textbox_base5.visible=.f.
						.Lx_label8.enabled=.f.
						.lx_textbox_base5.enabled=.f.
						.addobject("lb_filial_producao","lb_filial_producao")	
						.addobject("cmb_filial_producao","cmb_filial_producao")							
					ENDWITH
					
					if !f_vazio(xalias_pai)	
						sele &xalias_pai
					endif	
					
				case upper(xmetodo) == 'USR_REFRESH' AND thisformset.p_tool_status $'IA'
				
					 
							xalias=alias()			 
	
							 	 if type("thisformset.lx_form1.lx_pageframe1.page2.cmb_filial_producao")<>"U"
								  	
										 thisformset.lx_form1.lx_pageframe1.page2.cmb_filial_producao.Enabled = thisformset.pp_ANM_PER_ALT_FILIAL_OP_CON
										 thisformset.lx_form1.lx_pageframe1.page2.Cmb_FILIAL.Enabled = thisformset.pp_ANM_PER_ALT_FILIAL_OP_CON 

					
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
*-- Class:        bt_geraop_conserto (c:\users\julio.cesar\documents\rbx jpa\bt_geraop_conserto.vcx)
*-- ParentClass:  botao (c:\pastas\work\linx_animale\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/26/15 05:22:05 PM
*
DEFINE CLASS bt_geraop_conserto AS botao


	Top = 57
	Left = 604
	Height = 23
	Width = 140
	FontBold = .T.
	WordWrap = .T.
	Enable = .T.
	Visible=.T.
	Caption = "Gerar OP de Conserto"
	TabIndex = 9
	ToolTipText = "Mata saldo total"
	ZOrderSet = 10
	Name = "bt_GeraOpConserto"


	PROCEDURE Click
		IF Thisformset.p_tool_status == 'L'
			xOP_Original =INPUTBOX("","Deseja Gerar o Conserto de qual OP ?")
		ELSE
			MESSAGEBOX("A Tela precisa estar Limpa para a geração da OP",64)
			RETURN .F.
		ENDIF

		IF !f_vazio(xOP_Original)
			f_select("Select ordem_producao from producao_ordem where ordem_corte like '%'+RTRIM(LTRIM(?xOP_Original))+'%'","xVerifOP")
			IF RECCOUNT()>0
				IF MESSAGEBOX("Já existe OP de conserto Gerada,"+CHR(13)+"Deseja gerar uma nova OP de conserto?",4+32+256) = 7
						SELECT v_producao_ordem_01
						REPLACE ordem_corte WITH '%'+ALLTRIM(xOP_Original)
						Thisformset.lx_fORM1.Lx_chkbox_encerrado1.Value=1
						Thisformset.lx_fORM1.Lx_chkbox_encerrado1.l_desenhista_recalculo()
						o_toolbar.Botao_procura.Click()
					RETURN .F.
				ENDIF
			ENDIF


			text to	xCurVerifOP noshow textmerge	
				select ordem_producao FROM producao_ordem where ORDEM_PRODUCAO ='<<xOP_Original>>'
				union all
				select pedido as ordem_producao FROM compras WHERE tabela_filha = 'compras_produto' AND pedido = '<<xOP_Original>>'
			endtext			
			f_select(xCurVerifOP,"xVerifOP")

			IF !f_update("EXEC LX_ANM_GERA_OP_CONSERTO_OP '"+ALLTRIM(xOP_Original)+"'")
			
			ELSE
				IF !f_update("EXEC LX_ANM_GERA_OP_CONSERTO_PEDIDO '"+ALLTRIM(xOP_Original)+"'")	
				
					MESSAGEBOX("Ocorreu algum erro ao gerar a OP, favor procurar ajuda do Suporte.",64)
					RETURN .F.
				ENDIF
			f_select("Select top 1 ordem_producao,ordem_corte from producao_ordem where ordem_corte like '%'+rtrim(ltrim(?xop_original))+'%' and tipo_processo = 2  order by emissao desc","xseleoc")  
			MESSAGEBOX("OP Gerada Com Sucesso."+CHR(13)+CHR(13)+"Ordem de Corte: "+ALLTRIM(xseleoc.ordem_corte)+CHR(13)+"Ordem de Produção: "+ALLTRIM(xseleoc.ordem_producao),64)	
			
				SELECT v_producao_ordem_01
				REPLACE ordem_corte WITH ALLTRIM(xseleoc.ordem_corte)
				Thisformset.lx_fORM1.Lx_chkbox_encerrado1.Value=1
				Thisformset.lx_fORM1.Lx_chkbox_encerrado1.l_desenhista_recalculo()
				o_toolbar.Botao_procura.Click()
			ENDIF
			
			 
		ELSE
			RETURN .F.
		ENDIF
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_geraop_conserto
**************************************************

**************************************************
*-- Class:        lb_filial (c:\temp\lb_filial.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/22/08 05:05:04 PM
*
DEFINE CLASS lb_filial_producao AS lx_label


	Caption = "Filial Ent."
	Height = 15
	Left = 350
	Top = 76
	Width = 20
	TabIndex = 10
	ForeColor = RGB(0,0,0)
	BackColor = RGB(0,0,255)
	ZOrderSet = 6
	p_muda_size = .F.
	Name = "lb_FILIAL_producao"
	Visible = .t.
	Enabled = .t.	
	Alignment=0
	

ENDDEFINE
*
*-- EndDefine: lb_filial
**************************************************



**************************************************
*-- Class:        cmb_filial (c:\temp\cmb_filial.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   10/22/08 05:05:01 PM
*
DEFINE CLASS cmb_filial_producao AS lx_combobox

	RowSource = "v_filiais_001.filial"
	ControlSource = "v_producao_ordem_01.filial_producao"
	Height = 22
	Left = 395
	TabIndex = 1
	Top = 74
	Width = 146
	ZOrderSet = 5
	Name = "cmb_FILIAL_producao"
	Visible = .t.
	Enabled = .t.	

ENDDEFINE
*
*-- EndDefine: cmb_filial
**************************************************