*---------------------------------------------------------------------------------------------
* Analista.....: Vagner Júlio de Azevedo		Data: 10/05/2005	Últ. Alteração: 10/05/2005
* Cliente......: Full Fit
* Propósito....: Buscar desconto da propriedade do Cad. Clientes e trazer p/ campo "desconto" do item
* Últ.Alteração: 
*---------------------------------------------------------------------------------------------

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

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada

		do case
			case  UPPER(xmetodo) == 'USR_INIT' AND varTYPE(thisformset.lx_form1.bt_importa) = 'U' AND thisformset.name = 'LX009161_001'
				SELECT 0
				CREATE CURSOR cur_arquivo (linha c(250), tipo c(1), valor n(10,2), historico c(90), ocorrencia c(20))
				
				With thisformset.dataenvironment 
				  if Type(".Cursorv_contas_00")="U" 
				      AddNewObject(thisformset.dataenvironment, "Cursorv_contas_00","ccursoradapter") 
					.Cursorv_contas_00.DataSourceType			="ADO"
					Text to .Cursorv_contas_00.SelectCmd TextMerge NoShow
					SELECT CONTA_CONTABIL AS CONTA_EXTRATO, CONTA_CONTABIL AS CONTA_ENTRADA, CONTA_CONTABIL AS CONTA_SAIDA,
				 SPACE(200) AS ARQUIVO FROM CTB_CONTA_PLANO WHERE INATIVA = 0 

					EndText
					Text to .Cursorv_contas_00.CursorSchema TextMerge NoShow
					CONTA_EXTRATO C(20), CONTA_ENTRADA C(20), CONTA_SAIDA C(20),
				 ARQUIVO C(200) 

					EndText
					Text to .Cursorv_contas_00.UpdateNameList TextMerge NoShow
					
					EndText
					Text to .Cursorv_contas_00.UpdatableFieldList TextMerge NoShow
					
					EndText
					.Cursorv_contas_00.Tables				=""
					.Cursorv_contas_00.KeyFieldList		=""
					Text to .Cursorv_contas_00.QueryList TextMerge NoShow
					CONTA_EXTRATO CONTA_CONTABIL, CONTA_ENTRADA CONTA_CONTABIL,
				 CONTA_SAIDA CONTA_CONTABIL 

					EndText
					Text to .Cursorv_contas_00.CaptionList TextMerge NoShow
					CONTA_EXTRATO Conta Extrato, CONTA_ENTRADA Conta Entrada, CONTA_SAIDA Conta Saida,
				 ARQUIVO Arquivo 

					EndText
					Text to .Cursorv_contas_00.DefaultsValuesList TextMerge NoShow
					
					EndText
					.Cursorv_contas_00.FTableList		=""
					.Cursorv_contas_00.Alias				="v_contas_00"
					.Cursorv_contas_00.ParentCursor		=""
					.Cursorv_contas_00.BufferModeOverride	=5
					.Cursorv_contas_00.NoDataOnLoad		=.T.
					.Cursorv_contas_00.IsUpdateCursor		=.F.
					.Cursorv_contas_00.IsMaster		=.F.
					.Cursorv_contas_00.UpdateType			=1
					.Cursorv_contas_00.WhereType			=3
					.Cursorv_contas_00.FetchMemo			=.T.
					.Cursorv_contas_00.SendUpdates		=.F.
					.Cursorv_contas_00.UseMemoSize		=255
					.Cursorv_contas_00.FetchSize			=-1
					.Cursorv_contas_00.MaxRecords			=-1
					.Cursorv_contas_00.Prepared			=.F.
					.Cursorv_contas_00.CompareMemo		=.F.
					.Cursorv_contas_00.BatchUpdateCount	=1
					.Cursorv_contas_00.OpenCursor() 
				  EndIf 
				EndWith 
				
				SELECT v_contas_00
				APPEND blank
				
				

				THISformset.lx_form1.addobject('bt_importa', 'bt_imp')
				THISformset.lx_form1.bt_importa.visible = .T.
				THISformset.lx_form1.bt_importa.top = 55
				THISformset.lx_form1.bt_importa.left = 427


        endcase
	endproc
ENDDEFINE

DEFINE CLASS bt_imp as botao 
	caption = 'Importa Extrato'
	autosize = .T.
	
	PROCEDURE click
		SELECT v_ctb_lancamento_01_item
		GO top
		IF EOF()
			SELECT v_contas_00 
			replace conta_extrato 	WITH '',;
					conta_entrada 	with '',;
					conta_saida 	with '',;
					arquivo 		with ''
			
			SELECT cur_arquivo 
			zap
			
			DO FORM lxanm018MIT
		ELSE
			MESSAGEBOX('Já existem itens no lancamento!', 16, wusuario)
			RETURN .F.
		ENDIF
	ENDPROC
	
	PROCEDURE refresh
		this.Visible = thisformset.p_tool_status = 'I'
	ENDPROC
	
ENDDEFINE

