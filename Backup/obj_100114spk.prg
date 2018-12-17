* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao campo Filial Estoque em funcao das entradas RBX/TRIMIX					                    *
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

	**	=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
				
				case upper(xmetodo) == 'USR_INIT' 
				
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_faturamento_06 
					sele v_faturamento_prod_02  
					xalias_faturam=alias()

	  				oCur = getcursoradapter(xalias_faturam)
					oCur.addbufferfield("FILIAL_ESTOQUE", "C(25)",.T., "FILIAL_ESTOQUE", "W_FATURAMENTO_PROD_02.FILIAL_ESTOQUE")				
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
				
				
				    *adicao da coluna na grid de consulta	
					WITH thisformset.lx_form1.lx_PAGEFRAME1.page1.lx_grid_filha1			
						.addColumn(1)
						.Columns(75).name="col_filial_estoque"
						.col_filial_estoque.Header1.Caption="Filial Estoque"
						.col_filial_estoque.width=105						
						.col_filial_estoque.ControlSource='v_faturamento_prod_02.filial_estoque'
						.col_filial_estoque.removeobject("text1")
						.col_filial_estoque.addobject("tv_filial_estoque","tv_filial_estoque")	
						.col_filial_estoque.header1.FontSize =THISFORMSET.lx_form1.lx_paGEFRAME1.page1.lx_GRID_FILHA1.coL_TX_EMISSAO.FontSize 
						.col_filial_estoque.header1.Alignment=2
						.col_filial_estoque.tv_filial_estoque.FontSize =THISFORMSET.lx_form1.lx_paGEFRAME1.page1.lx_GRID_FILHA1.coL_TX_EMISSAO.FontSize 
						.col_filial_estoque.FontSize =THISFORMSET.lx_form1.lx_paGEFRAME1.page1.lx_GRID_FILHA1.coL_TX_EMISSAO.FontSize 
					ENDWITH
					
					thisformset.l_limpa()
					o_toolbar.Botao_limpa.Click()  


				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE


**************************************************
*-- Class:        tv_filial_estoque (c:\work\cientes\imaginarium\tv_franquia.vcx)
*-- ParentClass:  lx_textbox_valida (c:\work\desenv7\linx_sql\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   03/09/07 12:23:02 PM
*
DEFINE CLASS tv_filial_estoque AS lx_textbox_valida

	Visible = .T.
	Enabled = .T.
	*ControlSource = "v_faturamento_prod_02.filial_estoque"
	Format = "!"
	p_valida_coluna = "FILIAL"
	p_valida_coluna_tabela = "FILIAIS"
	p_valida_colunas_incluir = "clifor"
	p_tipo_dado = "EDITA"
	Name = "tv_filial_estoque"


ENDDEFINE
*
*-- EndDefine: tv_filial_estoque
**************************************************