* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
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
		
		do case
			
				
				case UPPER(xmetodo) == 'USR_INIT' AND upper(xnome_obj)== 'ENTRADAS_114'  
				
				xalias=alias()
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
							
				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_producao_programa_00  
				sele v_entradas_materiais_00 
				xalias_pai=alias()

  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("W_ENTRADAS_MATERIAIS.DATA_DIGITACAO", "D",.F., "DATA_DIGITACAO", "W_ENTRADAS_MATERIAIS.DATA_DIGITACAO")				
				oCur.addbufferfield("datediff(day,recebimento,data_digitacao) as DIAS_ENTRE_DIGREC", "I",.F., "DATA_DIGITACAO", "DIAS_ENTRE_DIGREC")
				*** #1 - INCLUIDA A COLUNA NA VIEW E NA TELA PUXANDO A COLECAO DO PRODUTO
				*** LUCAS MIRANDA 18/07/2016
				oCur.addbufferfield("W_ENTRADAS_MATERIAIS.COLECAO_COMPRA", "C(40)",.F., "COLECAO COMPRA", "W_ENTRADAS_MATERIAIS.COLECAO_COMPRA")
				oCur.confirmstructurechanges() 	
				*-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
	
				*** #1 - INCLUIDA A COLUNA NA VIEW E NA TELA PUXANDO A COLECAO DO PRODUTO
				*** LUCAS MIRANDA 18/07/2016
				with THISFORMSET.LX_FORM1.LX_PAGEFRAME1.PAGE1.LX_GRID_FILHA1 
												xcColumnCount = .columncount
												xcColumnCount = xcColumnCount + 1 
									.addcolumn(xcColumnCount)
									.columns[xcColumnCount].name = 'col_anm_colecao_pedido'
									.col_anm_colecao_pedido.width = 100
									.col_anm_colecao_pedido.columnorder = 25
									.col_anm_colecao_pedido.header1.caption = 'Coleção Pedido'
									.col_anm_colecao_pedido.header1.alignment = 2
									.col_anm_colecao_pedido.header1.FONTSIZE = 8
									.col_anm_colecao_pedido.refresh()
									.col_anm_colecao_pedido.ControlSource='v_entradas_materiais_00.colecao_compra'
				endwith									
				*** #1 - INCLUIDA A COLUNA NA VIEW E NA TELA PUXANDO A COLECAO DO PRODUTO
				*** LUCAS MIRANDA 18/07/2016					
				
				
				public xfiltro_colec,xPai_Filtro		
				xfiltro_colec=''
				xPai_Filtro=thisformset.p_pai_filtro 
				
				text to xsel noshow	
					select convert(char(6),'') as colecao,  
					convert(varchar(40),'') as desc_colecao 
					union all  
					select colecao,desc_colecao  
					from colecoes 				 
				endtext	
				
				f_select(xsel,"cur_colecoes") 
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif		
								
				with Thisform.lx_pageframe1.Page2
					.AddObject("cmb_colecao_entrada","cmb_colecao_entrada") 
					.AddObject("lb_colecao_ent","lb_colecao_ent")  
				endwith		


				case UPPER(xmetodo) == 'USR_SEARCH_BEFORE' AND upper(xnome_obj)== 'ENTRADAS_114'  
				
				if	!f_vazio(xfiltro_colec)	

					xfiltro=" (EXISTS(SELECT 1 FROM Prop_entradas WHERE Prop_entradas.NF_ENTRADA = ENTRADAS.NF_ENTRADA  " + ;
							"AND Prop_entradas.SERIE_NF_ENTRADA = ENTRADAS.SERIE_NF_ENTRADA AND Prop_entradas.NOME_CLIFOR = ENTRADAS.NOME_CLIFOR " + ;
							"AND ((PROPRIEDADE = '00014' AND VALOR_PROPRIEDADE  = '"+allt(xfiltro_colec)+"')) )) "
					
					thisformset.p_pai_filtro=thisformset.p_pai_filtro+xfiltro
					
				endif		
	

				case UPPER(xmetodo) == 'USR_CLEAN_AFTER' AND upper(xnome_obj)== 'ENTRADAS_114' 
				
				if	type("xPai_Filtro") != 'U'
					thisformset.p_pai_filtro=xPai_Filtro
				endif	
				
				if	type("xfiltro_colec") != 'U'  
					xfiltro_colec='' 
				endif	
					
	
	
			otherwise
				return .t.				
		endcase
	endproc
enddefine


**************************************************
*-- Class:        cmb_colecao_entrada (c:\temp\cmb_colecao_entrada.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   03/01/07 12:03:05 PM
*
*#INCLUDE "c:\desenv\formtool\lx_const.h"
*
DEFINE CLASS cmb_colecao_entrada AS lx_combobox


	BoundColumn = 1
	ColumnWidths = "50,200"
	RowSource = "cur_colecoes.colecao,desc_colecao"
	ControlSource = "xfiltro_colec"
	Height = 24
	Left = 420
	Top = 16
	Width = 281
	ZOrderSet = 6
	p_tipo_dado = "EDITA"
	Name = "cmb_colecao_entrada"
	Visible = .T.	
	Enable	= .T. 
	ColumnCount = 2

ENDDEFINE
*
*-- EndDefine: cmb_colecao_entrada
************************************************** 

**************************************************
*-- Class:        lb_colecao_ent (c:\temp\lb_colecao_ent.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   03/01/07 12:31:11 PM
*
*#INCLUDE "c:\desenv\formtool\lx_const.h"
*
DEFINE CLASS lb_colecao_ent AS lx_label


	FontSize = 11
	Caption = "Coleção Compra/Entrada "
	Height = 31
	Left = 250
	Top = 17
	Width = 84
	ForeColor = RGB(255,0,0)
	Name = "lb_colecao_ent"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lb_colecao_ent
**************************************************