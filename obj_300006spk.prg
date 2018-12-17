* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  22/05/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao campo Codigo filial origem			                    *
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

		* =messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case


				case upper(xmetodo) == 'USR_INIT' 

					xalias=alias()
				

					
					
					THISFORMSET.LX_FORM1.ADDOBJECT("lb_chapa","lb_chapa")
					THISFORMSET.LX_FORM1.ADDOBJECT("tx_chapa","tx_chapa")
					sele v_loja_vendedores_00
					xalias_users=alias()
	  				oCur = getcursoradapter(xalias_users)
					oCur.addbufferfield("CHAPA", "C(16)",.T., "CHAPA", "LOJA_VENDEDORES.CHAPA")				
					oCur.confirmstructurechanges() 
					
					thisformset.l_limpa()



					with thisform
						.addobject("tx_codigo_filial_origem","tx_codigo_filial_origem")
						.label_COMPLEMENTO.Top=69
						.label_COMPLEMENTO.Caption='Filial Origem'
						.label_COMPLEMENTO.left=155
						.tx_COMPLEMENTO.Top=-1000
					endwith
					
					THISFORMSET.LX_FORM1.tx_chapa.ControlSource ="v_loja_vendedores_00.CHAPA"
			
					if	!f_vazio(xalias)	
						sele &xalias 
					endif	


			case upper(xmetodo) == 'USR_REFRESH' 
				
					IF TYPE("THISFORMSET.LX_FORM1.tx_chapa")<>"U"					
						THISFORMSET.LX_FORM1.tx_chapa.ControlSource ="v_loja_vendedores_00.CHAPA"
						THISFORMSET.LX_FORM1.tx_chapa.Enabled = !THISFORMSET.p_tool_status = 'P'
					ENDIF	

									
																
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE



**************************************************
*-- Class:        tx_codigo_filial_origem (c:\temp\v7\tx_codigo_filial_origem.vcx)
*-- ParentClass:  lx_textbox_valida (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/22/09 05:12:04 PM
*
DEFINE CLASS tx_codigo_filial_origem AS lx_textbox_valida


	ControlSource = "v_loja_vendedores_00.COMPLEMENTO"
	Height = 21
	Left = 225
	TabIndex = 3
	Top = 67
	Width = 43
	ZOrderSet = 34
	p_valida_coluna = "Codigo_Filial"
	p_valida_coluna_tabela = "lojas_varejo"
	p_valida_colunas_incluir = "Filial"
	Name = "txt_Codigo_Filial_Origem"
	Visible = .T.
	Enabled = .T.	


ENDDEFINE
*
*-- EndDefine: tx_codigo_filial_origem
**************************************************



**************************************************
*-- Class:        lb_filial_ex (c:\temp\kleber\lb_chave.vcx)
*-- ParentClass:  lx_label (c:\work\desenv7\linx_sql\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*
DEFINE CLASS lb_chapa AS lx_label

	Alignment=0
	AutoSize = .F.
	FontBold = .F.
	FontSize = 8	
	Caption = "Chapa"
	Height = 17
	Left = 285
	Top = 70 &&ajuste top
	Width = 30
	DisabledForeColor = RGB(0,0,0)
	Name = "lb_chapa"
	Visible = .T.

ENDDEFINE
*
*-- EndDefine: lb_chave
************************************************** 

**************************************************
*-- Class:        tx_chave (c:\temp\kleber\tx_chave.vcx)
*-- ParentClass:  lx_combobox (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*
DEFINE CLASS tx_chapa AS lx_textbox_base


	RowSource = ""
	ControlSource = ""
	Height = 21
	Left = 320
	TabIndex = 2
	Top = 67
	Width = 84
	ZOrderSet = 4
	Name = "tx_chapa"
	Visible = .T.
	Enabled = .T.
	inputmask = '9999999999999999' 

ENDDEFINE
*
*-- EndDefine: tx_chave
**************************************************