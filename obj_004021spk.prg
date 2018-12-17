* Criação ***********************************************************************************************************
* PROGRAMADOR(A).:  Julio Cesae                                                                                                *
* DATA...........:  07/02/2011                                                                                               *
* HORÁRIO........:  12:16                                                                                           *
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

Define Class obj_entrada As Custom
	*- Nome do metodo/função que os objetos linx vão chamar.

	Procedure metodo_usuario
	*- Parametros do metodo:
	*- Xmetodo= nome do metodo
	*- Xobjeto= variavel com a referencia ao objeto
	*- Xnome_obj  = nome do objeto
	Lparam xmetodo, xobjeto ,xnome_obj

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

	Do Case

	Case Upper(xmetodo) == 'USR_INIT'

		xalias=Alias()
		
			xVersao = '01.1'
			f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
			f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
			WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT
			
			*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_faturamento_05
			Sele V_compras_divergente_00_materiais
			xalias_pai=Alias()

			oCur = Getcursoradapter(xalias_pai)
			oCur.addbufferfield("CONVERT(NUMERIC(15,3),0) AS GERA_NECESSIDADE ", "N(15,3)",.T., "Gera Necessidade", "CONVERT(NUMERIC(15,3),0) AS GERA_NECESSIDADE ")
			oCur.confirmstructurechanges()
			**-Fim Inclusao Campos Novos de Produtos no Cursor Pai
			
			With Thisformset.lx_FORM1.Lx_pageframe
				.page1.AddObject("bt_cor_vermelha","bt_cor_vermelha")
				.page1.AddObject("lb_gera_nece","lb_gera_nece")
				.page2.AddObject("ck_gera_nece","ck_gera_nece")
			EndWith	
			
			With Thisformset.lx_FORM1.lx_pageframe.page1.lx_grid_filha
				.AddColumn(3)
				.column1.Name = 'col_gera_necessidade'
				.col_gera_necessidade.Width = 20
				.col_gera_necessidade.header1.Caption = ''
				.col_gera_necessidade.BackColor = 15399423
				.col_gera_necessidade.RemoveObject("text1")
				.col_gera_necessidade.AddObject("bt_gera_necessidade","botao")
				.col_gera_necessidade.bt_gera_necessidade.Enabled = .T.
				.col_gera_necessidade.bt_gera_necessidade.Visible = .T.
				.col_gera_necessidade.bt_gera_necessidade.Caption = ''
				.col_gera_necessidade.Sparse = .F.
				.col_gera_necessidade.bt_gera_necessidade.SpecialEffect = 1
				.col_gera_necessidade.DynamicBackColor = "iif(v_Compras_Divergente_00_Materiais.GERA_NECESSIDADE>=0,15399423,255)"
				.col_gera_necessidade.DynamicForeColor = "iif(v_Compras_Divergente_00_Materiais.GERA_NECESSIDADE>=0,15399423,255)"
				.LockColumns=3

				.AddColumn(17)
				.column1.Name = 'col_necessidade_sobra'
				.col_necessidade_sobra.text1.Name = 'txt_necessidade_sobra'
				.HeaderHeight = 30
				.col_necessidade_sobra.BackColor = 15399423
				.col_necessidade_sobra.header1.FontSize = 8
				.col_necessidade_sobra.header1.FontName = 'tahoma'
				.col_necessidade_sobra.FontSize = 8
				.col_necessidade_sobra.FontName = 'tahoma'
				.col_necessidade_sobra.header1.Alignment = 2
				.col_necessidade_sobra.header1.Caption = 'Necessidade Sobra'
				.col_necessidade_sobra.header1.WordWrap = .T.
				.col_necessidade_sobra.Enabled  = .F.
				.col_necessidade_sobra.ControlSource = "v_compras_divergente_00_materiais.GERA_NECESSIDADE"
				
				.AddColumn(13)
				.column1.Name = 'col_material'
				.col_material.text1.Name = 'txt_col_material'
				.col_material.BackColor = 15399423
				.col_material.header1.FontSize = 8
				.col_material.header1.FontName = 'tahoma'
				.col_material.FontSize = 8
				.col_material.FontName = 'tahoma'
				.col_material.header1.Alignment = 2
				.col_material.header1.Caption = 'Material'
				.col_material.Enabled  = .F.
				.col_material.ControlSource = "v_compras_divergente_00_materiais.MATERIAL"
	
				.AddColumn(14)
				.column1.Name = 'col_cor_material'
				.col_cor_material.text1.Name = 'txt_col_cor_material'
				.col_cor_material.BackColor = 15399423
				.col_cor_material.header1.FontSize = 8
				.col_cor_material.header1.FontName = 'tahoma'
				.col_cor_material.FontSize = 8
				.col_cor_material.FontName = 'tahoma'
				.col_cor_material.header1.Alignment = 2
				.col_cor_material.header1.Caption = 'Cor Material'
				.col_cor_material.Enabled  = .F.
				.col_cor_material.ControlSource = "v_compras_divergente_00_materiais.COR_MATERIAL"		
			
			Endwith


		If	!f_vazio(xalias)
			Sele &xalias
		Endif
		
	Case Upper(xmetodo) == 'USR_SEARCH_AFTER'	
	
		xalias=Alias()	
		
			xSel = "SELECT A.MATERIAL,COR_MATERIAL,NECESSIDADE " +;
				"FROM WANM_CONSULTA_CONSOLIDADA A JOIN MATERIAIS (NOLOCK) ON A.MATERIAL = MATERIAIS.MATERIAL " +;
				"WHERE ESTOQUE+COMPRAS-RESERVAS-PROGRAMACOES <> 0 " +;
				IIF(!f_vazio(o_004021.lx_FORM1.lx_pageframe.page2.Lx_filtro_materiais1.p_where_material)," AND " +;
				Thisformset.lx_FORM1.lx_pageframe.page2.Lx_filtro_materiais1.p_where_material,"") 
				
			Select Distinct material,cor_material From v_compras_divergente_00_materiais Into Cursor vtmp_compras_div_material
			Go Top
			Scan
				f_prog_bar("Analisando Material: "+Alltrim(Str(Recno()/Reccount()*100))+"% concluido",Recno(),Reccount())

				xSelConCon = xSel + " AND A.MATERIAL = ?vtmp_compras_div_material.MATERIAL " +;
					" AND A.COR_MATERIAL = ?vtmp_compras_div_material.COR_MATERIAL"

				f_select(xSelConCon,"CurMontaNecessidade",Alias())

				Update A Set GERA_NECESSIDADE = NECESSIDADE  ;
					FROM v_compras_divergente_00_materiais A Join CurMontaNecessidade B ;
					ON A.material = B.material And A.cor_material = B.cor_material

				Sele vtmp_compras_div_material
			Endscan
			f_prog_bar()

			Sele v_compras_divergente_00_materiais
			Go Top

			Use In vtmp_compras_div_material
			Use In CurMontaNecessidade

			With Thisformset.lx_FORM1.lx_pageframe.page1.lx_grid_filha.col_gera_necessidade
				.bt_gera_necessidade.BackColor = .BackColor
				.bt_gera_necessidade.ForeColor = .ForeColor
			Endwith
			
			If Thisformset.lx_FORM1.Lx_pageframe.page2.Ck_gera_nece.Value=1
				sele v_compras_divergente_00_materiais
				Set Filter to gera_necessidade < 0
			Else
				sele v_compras_divergente_00_materiais
				Set Filter to 
			Endif
				
			
		If	!f_vazio(xalias)
			Sele &xalias
		Endif
		
		
		otherwise
		return .t.				
	endcase
	
	endproc
ENDDEFINE

**************************************************
*-- Class:        ck_gera_nece (c:\pastas\work\classes_julio\ck_gera_nece.vcx)
*-- ParentClass:  lx_checkbox (c:\pastas\work\linx_spk_teste\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    checkbox
*-- Time Stamp:   07/08/15 10:02:06 AM
*
DEFINE CLASS ck_gera_nece AS lx_checkbox


	Top = 147
	Left = 124
	Alignment = 0
	Caption = "Gerando Necessidade"
	Name = "ck_gera_nece"
	Enabled = .t.
	Visible = .t.


ENDDEFINE
*
*-- EndDefine: ck_gera_nece
**************************************************

**************************************************
*-- Class:        cor_vermelha (c:\pastas\work\classes_julio\cor_vermelha.vcx)
*-- ParentClass:  botao (c:\pastas\work\linx_spk_teste\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   07/08/15 10:01:10 AM
*
DEFINE CLASS bt_cor_vermelha AS botao


	Top = 387
	Left = 430
	Height = 21
	Width = 23
	Caption = ""
	Style = 0
	TabStop = .F.
	SpecialEffect = 1
	BackColor = RGB(255,0,0)
	p_manter_baixo = .T.
	p_manter_cima = .F.
	Name = "bt_cor_vermelha"
	Enabled = .t.
	Visible = .t.
	

	PROCEDURE When
		Return .F.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cor_vermelha
**************************************************

**************************************************
*-- Class Library:  c:\pastas\work\classes_julio\label_gera_nece.vcx
**************************************************

**************************************************
*-- Class:        label_gera_nece (c:\pastas\work\classes_julio\label_gera_nece.vcx)
*-- ParentClass:  lx_label (c:\pastas\work\linx_spk_teste\linx\exclusivos\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   07/08/15 10:01:05 AM
*
DEFINE CLASS lb_gera_nece AS lx_label


	FontBold = .T.
	Alignment = 0
	Caption = "Gerando Necessidade"
	Left = 460
	Top = 391
	p_manter_baixo = .T.
	p_manter_cima = .F.
	Name = "lb_gera_nece"
	Enabled = .t.
	Visible = .t.

ENDDEFINE
*
*-- EndDefine: label_gera_nece
**************************************************


