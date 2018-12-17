* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: 					                    *
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
					 
					public curDepartamentos,xdata_ini,xdata_fim,xpai_filtro
					xdata_ini=ctod('')
					xdata_fim=ctod('')

					with thisform.lx_PAGEFRAME1.page2
						.parent.parent.addobject("tx_Data_ini","tx_Data_ini")
						.parent.parent.addobject("tx_Data_fim","tx_Data_fim")		
						.parent.parent.addobject("lb_Data1","lb_Data1")	
						.parent.parent.addobject("lb_Data2","lb_Data2")								
					endwith
					
					if	type('thisform.tx_data_ini') <> 'U'
						with thisform
							.tx_data_ini.enabled= !thisformset.p_tool_status $ 'AI'
							.tx_data_fim.enabled= !thisformset.p_tool_status $ 'AI'
						endwith	
					endif	
					
					WITH Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1					
						.col_tx_CUSTO.Enabled = .F.
						.col_tx_QTDE_APROVADA.Enabled = .F.
						IF TYPE("Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_APROVADO_POR.ColumnOrder")<>"U"
							xColRemove = .col_tx_APROVADO_POR.ColumnOrder
							.DeleteColumn(xColRemove)
						ENDIF
						.col_tx_QTDE_REQUISITADA.ColumnOrder = 3
						.col_tx_ENTREGA.ColumnOrder=5
						IF TYPE("Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COTACAO.ColumnOrder")<>"U"
							xColRemove = .col_tx_COTACAO.ColumnOrder
							.DeleteColumn(xColRemove)
						ENDIF
					ENDWITH
					
					Bindevent(Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_STATUS.cmb_STATUS, "when", This, "Anm_Cmb_STATUS", 1)
	
				
				if	!f_vazio(xalias)
					sele &xalias
				endif	
		
				case upper(xmetodo) == 'USR_VALID'
				
				xalias=alias()
					
					IF upper(xnome_obj) = 'TV_MATERIAL'
					
						with Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1
							.col_tx_ENTREGA.Tx_entrega.Value  = DATE()+30
							.COL_tx_LIMITE.TX_LIMITE.Value    = DATE()+30
						endwith
					
					ENDIF
					
					IF upper(xnome_obj) = 'CMB_STATUS'
		
						IF Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_STATUS.Cmb_STATUS.Value $ 'AC' AND ;
							!IIF(TYPE("Thisformset.pp_GS_PERMIT_APROV_REQ")="U",.f.,Thisformset.pp_GS_PERMIT_APROV_REQ) AND;
							thisformset.p_tool_status $ 'AI'
							
							messagebox('Você não tem permissão para selecionar este Status !',48,'Atenção!')
							
							Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_STATUS.Cmb_STATUS.Value=;
							Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_STATUS.Cmb_STATUS.OldValue
							
							retu .f.
						ENDIF						
					ENDIF
					

				if	!f_vazio(xalias)
					sele &xalias
				endif					


				case upper(xmetodo) == 'USR_REFRESH'

				xalias=alias()	 

					if	type('thisform.tx_data_ini') <> 'U'
						with thisform
							.tx_data_ini.enabled= !thisformset.p_tool_status $ 'AI'
							.tx_data_fim.enabled= !thisformset.p_tool_status $ 'AI'
						endwith	
					endif				
					
					
					with Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1
						.col_tx_ENTREGA.enabled  = .f.
						.COL_tx_LIMITE.enabled  = .f.
						.col_tx_STATUS.Cmb_STATUS.Enabled = !thisformset.p_tool_status $ 'IP'
					endwith
					
					WITH Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1					
						.col_tx_CUSTO.Enabled = .F.
						.col_tx_QTDE_APROVADA.Enabled = .F.
						IF TYPE("Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_APROVADO_POR.ColumnOrder")<>"U"
							xColRemove = .col_tx_APROVADO_POR.ColumnOrder
							.DeleteColumn(xColRemove)
						ENDIF
						.col_tx_QTDE_REQUISITADA.ColumnOrder = 3
						.col_tx_ENTREGA.ColumnOrder=5
						IF TYPE("Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_COTACAO.ColumnOrder")<>"U"
							xColRemove = .col_tx_COTACAO.ColumnOrder
							.DeleteColumn(xColRemove)
						ENDIF
					ENDWITH
					
					
					
					Thisformset.lx_FORM1.cmb_STATUS.enabled = !thisformset.p_tool_status $ 'IP'
					
					IF !IIF(TYPE("Thisformset.pp_GS_PERMIT_APROV_REQ")="U",.f.,Thisformset.pp_GS_PERMIT_APROV_REQ)
						
						IF !thisformset.p_tool_status $ 'A' OR Thisformset.lx_FORM1.cmb_STATUS.Value $ 'AC'
							IF Thisformset.lx_FORM1.cmb_STATUS.ListCount = 2
							
								WITH Thisformset.lx_FORM1.cmb_STATUS
									.AddItem(f_Traduz('APROVADO'),  2,1)
									.AddItem(f_Traduz('COMPRADO '), 4,1)
									.AddListItem('A', 2,2)
									.AddListItem('C', 4,2)
								ENDWITH
							
							ENDIF
						ELSE
							IF Thisformset.lx_FORM1.cmb_STATUS.ListCount > 2
							
								Thisformset.lx_FORM1.cmb_STATUS.RemoveItem(4)
								Thisformset.lx_FORM1.cmb_STATUS.RemoveItem(2)
								
							ENDIF
						ENDIF
					
					ENDIF
					
				if	!f_vazio(xalias)
					sele &xalias
				endif	
				
				

				
				case upper(xmetodo) == 'USR_CLEAN_AFTER'
				
				xalias=alias()	
				
					xdata_ini=ctod('')
					xdata_fim=ctod('')
					if	type("xpai_filtro")<>'U'
						thisformset.p_pai_filtro=" REQUISICOES.COD_TABELA_FILHA = 'M' "
					endif	
				
				if	!f_vazio(xalias)
					sele &xalias
				endif	
				
							

				case upper(xmetodo) == 'USR_SEARCH_BEFORE'
				
				xalias=alias()
				
					if	!f_vazio(xdata_ini) and !f_vazio(xdata_fim)
						
						thisformset.p_pai_filtro=thisformset.p_pai_filtro+ ;
						iif(!f_vazio(thisformset.p_pai_filtro),' and ','')+;
						" requisicoes.emissao between '"+allt(dtos(xdata_ini))+"'"+ ;
						" and '"+allt(dtos(xdata_fim))+"'"
					
					endif
								
				if	!f_vazio(xalias)
					sele &xalias
				endif	
				


				case upper(xmetodo) == 'USR_ALTER_BEFORE'


				xalias=alias()	 


					IF Thisformset.lx_FORM1.cmb_STATUS.Value $ 'AC' AND;
						!IIF(TYPE("Thisformset.pp_GS_PERMIT_APROV_REQ")="U",.f.,Thisformset.pp_GS_PERMIT_APROV_REQ)
						
						messagebox('Você não tem permissão para alterar esta Requisição !',48,'Atenção!')
						retu .f.
					ENDIF
				
				if	!f_vazio(xalias)
					sele &xalias
				endif	
				
				
				case upper(xmetodo) == 'USR_ALTER_AFTER'

				xalias=alias()	
					
					SELECT V_REQUISICOES_00_MATERIAL
					GO TOP
					SCAN
						IF V_REQUISICOES_00_MATERIAL.status $ 'AC'
							thisformset.lx_FORM1.cmb_STATUS.enabled = .f.
						ENDIF	
					ENDSCAN
					GO TOP

				if	!f_vazio(xalias)
					sele &xalias
				endif	
				
				
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE'


				xalias=alias()	 

					If thisformset.p_tool_status='E'

						IF Thisformset.lx_FORM1.cmb_STATUS.Value $ 'AC' AND;
							!IIF(TYPE("Thisformset.pp_GS_PERMIT_APROV_REQ")="U",.f.,Thisformset.pp_GS_PERMIT_APROV_REQ)
							
							messagebox('Você não tem permissão para excluir esta Requisição !',48,'Atenção!')
							retu .f.
						ENDIF				
					
					Endif	
				
				if	!f_vazio(xalias)
					sele &xalias
				endif


				
																
				otherwise
				return .t.				
			endcase	
	endproc


	**** #XML ****
	Procedure Anm_Cmb_STATUS

	xalias=Alias()
			
			IF thisformset.p_tool_status $ 'AI'	
				IF !Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_STATUS.Cmb_STATUS.Value $ 'AC'
					Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_STATUS.Cmb_STATUS.OldValue =;
					Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_STATUS.Cmb_STATUS.Value
				ENDIF	
					
				IF Thisformset.lx_FORM1.lx_pageframe1.page1.lx_GRID_FILHA1.col_tx_STATUS.Cmb_STATUS.Value $ 'AC' AND ;
					!IIF(TYPE("Thisformset.pp_GS_PERMIT_APROV_REQ")="U",.f.,Thisformset.pp_GS_PERMIT_APROV_REQ)
					
					messagebox('Você não tem permissão para alterar este Status !',48,'Atenção!')
					RETURN .F.
				
				ENDIF	
			ENDIF
			
	If !f_vazio(xalias)
		Sele &xalias
	Endif
	
	Endproc
	**** FIM - #XML ****

ENDDEFINE



**************************************************
*-- Class:        tx_departamento (l:\linx_sql\linx\exclusivos\requisicao_compras\tx_departamento.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   12/26/07 10:43:01 AM
*
DEFINE CLASS cmb_departamento AS lx_combobox


	RowSource = "curDepartamentos.departamento"
	ControlSource = "v_requisicoes_00.departamento"
	Height = 22
	Left = 135
	Top = 34
	Width = 262
	ZOrderSet = 9
	Name = "cmb_departamento"
	Visible	= .t.
	Enabled = .t.

ENDDEFINE
*
*-- EndDefine: tx_departamento
**************************************************


**************************************************
*-- Class:        tx_data_ini (l:\linx_sql\linx\exclusivos\requisicao_compras\tx_data_ini.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   12/26/07 11:50:13 AM
*
DEFINE CLASS tx_data_ini AS lx_textbox_base


	ControlSource = "xdata_ini"
	Height = 22
	Left = 574
	Top = 83
	Width = 75
	ZOrderSet = 8
	Name = "tx_data_ini"
	Visible	= .t.
	Enabled = .t.

	PROCEDURE WHEN 
	
		if	type('thisform.tx_data_ini') <> 'U'
			
			with thisform
				.tx_data_ini.enabled= thisformset.p_tool_status $ 'AL'
				.tx_data_fim.enabled= thisformset.p_tool_status $ 'AL'
			endwith	

		endif

	
	ENDPROC


ENDDEFINE
*
*-- EndDefine: tx_data_ini
**************************************************

**************************************************
*-- Class:        tx_data_fim (l:\linx_sql\linx\exclusivos\requisicao_compras\tx_data_fim.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   12/26/07 11:51:02 AM
*
DEFINE CLASS tx_data_fim AS lx_textbox_base


	ControlSource = "xdata_fim"
	Height = 22
	Left = 671
	Top = 83
	Width = 75
	ZOrderSet = 8
	Name = "tx_data_fim"
	Visible	= .t.
	Enabled = .t.

ENDDEFINE
*
*-- EndDefine: tx_data_fim
**************************************************



**************************************************
*-- Class:        lb_data (l:\linx_sql\linx\exclusivos\requisicao_compras\lb_data.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   12/26/07 11:51:06 AM
*
DEFINE CLASS lb_data2 AS lx_label


	Caption = "a"
	Height = 15
	Left = 655
	Top = 87
	Width = 8
	ZOrderSet = 13
	Name = "lb_data2"
	Visible	= .t.


ENDDEFINE
*
*-- EndDefine: lb_data
**************************************************


**************************************************
*-- Class:        lb_data (l:\linx_sql\linx\exclusivos\requisicao_compras\lb_data.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   12/26/07 11:51:06 AM
*
DEFINE CLASS lb_data1 AS lx_label


	Caption = "Filtro Emissão"
	Height = 15
	Left = 495
	Top = 87
	Width = 75
	ZOrderSet = 13
	Name = "lb_data1"
	Visible	= .t.


ENDDEFINE
*
*-- EndDefine: lb_data
**************************************************