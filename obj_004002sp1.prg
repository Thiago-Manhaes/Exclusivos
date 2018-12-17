* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Julio Cesar                                                                                     *
* DATA...........:  01-03-2014                                                                                      *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                               			*
* OBJETIVO.: 					                    																*
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
				
						WITH thisformset.lx_FORM1.lx_pageframe1.page8
							.removeobject("Botao1")
							.addobject("Botao1","Botao1")			
						endwith

						thisformset.lx_FORM1.lx_pageframe1.page2.lx_GRID_FILHA1.COL_TV_MATERIAL.tv_MATERIAL.InputMask='!!!!!!!!!!!'

					
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
									
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE

**************************************************
*-- Class:        botao1 (c:\linx_farm7\linx\exclusivos\botao1.vcx)
*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   03/26/10 11:01:06 AM
*
DEFINE CLASS botao1 AS botao


	Top = 3
	Left = 5
	Height = 24
	Width = 326
	FontBold = .T.
	Caption = "\<Recalcular Reserva de Materiais Semi Acabados"
	ForeColor = RGB(0,0,255)
	Name = "Botao1"
	Visible = .T.
	Enabled = .T.

	PROCEDURE Click
		Local xPedido
		*- Faz a atualizacao dos materiais necessarios para este produto
		*

		* Retorna se nao for inclusao ou alteracao
		If !thisformset.p_tool_status $ 'AI'
			return .f.
		Endif

		*- Declara as variáveis
		local xAlias, xSelect, xCont, xMatZero, xfiltermat,xmanterfator

		*- inicializando variaveis globais
		xAlias = sele()
		xCont = 0
		declare xMatZero[1]
		xMatZero[1] = ''

		*_ Salva e Retira o filtro se houver na v_producao_ordem_01_materiais
		sele V_COMPRAS_01_reservas
		xfiltermat = filter()
		set filter to
		go top

		xmanterfator = .f.
		
		*- Atualizo os campos reserva
		sele v_COMPRAS_01_RESERVAS

		replace all reserva with 0 ,reserva_original with 0 , diferenca_previsao with 0

		*- percorre todos os registros da compras produtos para achar os materiais que fazem parte da ficha tecnica
		sele v_compras_01_materiais 


		Scan
			wait window f_traduz('Localizando Ficha Tecnica do material ')+v_compras_01_materiais.material NOWAIT

			xSelect = "SELECT MATERIAIS_FICHA_TECNICA.MATERIAL_UTILIZADO, MATERIAIS.DESC_MATERIAL, MATERIAIS_FICHA_TECNICA.COR_MATERIAL_UTILIZADA, " + ;
			          "       MATERIAIS_CORES.DESC_COR_MATERIAL, MATERIAIS_FICHA_TECNICA.DESC_USO, MATERIAIS_FICHA_TECNICA.CONSUMO, MATERIAIS_FICHA_TECNICA.PERDA, " + ;
			          "       MATERIAIS.FABRICANTE, MATERIAIS_COMPOSICAO.DESC_COMPOSICAO, MATERIAIS.SETOR_PRODUCAO, MATERIAIS.FASE_PRODUCAO, MATERIAIS.UNID_ESTOQUE, " + ;
			          "       MATERIAIS.SEMI_ACABADO, MATERIAIS_CORES.REFER_FABRICANTE, MATERIAIS.REF_FABRICANTE " + ;
			          "FROM MATERIAIS_FICHA_TECNICA " + ;
			          "     INNER JOIN MATERIAIS_CORES ON MATERIAIS_FICHA_TECNICA.MATERIAL_UTILIZADO = MATERIAIS_CORES.MATERIAL " + ;
			          "     AND  MATERIAIS_FICHA_TECNICA.COR_MATERIAL_UTILIZADA = MATERIAIS_CORES.COR_MATERIAL " + ;
			          "     INNER JOIN MATERIAIS ON MATERIAIS_FICHA_TECNICA.MATERIAL_UTILIZADO = MATERIAIS.MATERIAL " + ;
			          "     LEFT JOIN MATERIAIS_COMPOSICAO ON MATERIAIS.COMPOSICAO = MATERIAIS_COMPOSICAO.COMPOSICAO " + ;
			          "WHERE MATERIAIS_FICHA_TECNICA.MATERIAL = ?V_COMPRAS_01_MATERIAIS.MATERIAL AND " + ;
			          "      MATERIAIS_FICHA_TECNICA.COR_MATERIAL = ?V_COMPRAS_01_MATERIAIS.COR_MATERIAL"

			If !f_select(xSelect,'xMat')
				f_msg(["Não consegui selecionar os materiais da cor " + v_compras_01_materiais.cor_material + ', Verifique !!!',0+16+0,'Atenção !!!'])
				return .f.
			Endif

			*- Incluindo na tabela de producao_reserva
			If recc() # 0 
				Scan
					sele V_COMPRAS_01_reservas
					go top
					locate for material = xMat.MATERIAL_UTILIZADO and cor_material = xMat.COR_MATERIAL_UTILIZADA
					If ! found()
						append blank
						xCont = xCont + 1
						replace  pedido with v_compras_01.pedido, material with xMat.MATERIAL_UTILIZADO,cor_material with xMat.COR_MATERIAL_UTILIZADA, ;
						         desc_material  with xMat.desc_material , desc_cor_material with xMat.desc_cor_material,unid_estoque with xMat.unid_estoque, ;
						         unid_ficha_tec with xMat.unid_estoque  , fator_conversao with 1, fase_producao with xMat.fase_producao, ;
						         setor_producao with xMat.setor_producao, fator_conversao_na_reserva with 1
					Endif 
					replace reserva_original with reserva_original+ ; 
					(xmat.consumo*v_compras_01_materiais.qtde_original)/(1-(Nvl(xmat.perda, 0)/100)), data_reserva with date()
				    sele xMat
				EndScan
			ENDIF
			USE IN xMat  && fecho a tabela xMat
			sele v_compras_01_materiais
		Endscan

		*- Atualizo os campos reserva
		sele V_COMPRAS_01_reservas

		replace all reserva with iif(reserva_original - consumida > 0 and ! matar_saldo_reserva ,reserva_original - consumida,0), ;
		           diferenca_previsao with iif(reserva_original - consumida < 0 or matar_saldo_reserva ,reserva_original - consumida,0)

		if !empty(xfiltermat)
		   set filter to &xfiltermat
		   go top
		endif   

		*- refresh na grid
		with this.parent
			.lx_grid_filha1.refresh()
		endwith

		wait window f_traduz('Reservas de Material concluída !!! ') nowait

		sele (xAlias)

		return .t.
	ENDPROC


ENDDEFINE
*
*-- EndDefine: botao1
**************************************************
