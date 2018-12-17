* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Marcar div fiscal                                                                                                     *
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
			
				
				case UPPER(xmetodo) == 'USR_INIT' 
				
				xalias=alias()


				with Thisform
					.AddObject("bt_marca_div","bt_marca_div") 
					.AddObject("bt_cancela_nota","bt_cancela_nota") 
				endwith		

				
				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif		
								

				case UPPER(xmetodo) == 'USR_ALTER_AFTER' 

				thisformset.lx_form1.lx_PAGEFRAME1.page1.pageframe1.page1.tx_EMISSAO.Enabled=.t.
				Thisformset.lx_FORM1.lx_pageframe1.page1.pageframe1.page1.tv_desc_Especie_Serie.Enabled = .T.


	
	
	
			otherwise
				return .t.				
		endcase
	endproc
enddefine




**************************************************
*-- Class:        bt_marca_div (c:\temp\bt_marca_div.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/09 04:13:09 PM
*
DEFINE CLASS bt_marca_div AS botao


	Top = 95
	Left = 440
	Height = 24
	Width = 94
	FontBold = .F.
	FontSize = 8
	Caption = "Dif Imposto"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_marca_div"
	Visible=.t.
	Enabled=.t.	

	PROCEDURE Click

		xalias=alias()

			f_update("update entradas set diferenca_valor = case when diferenca_valor=1 then 0 else 1 end  where nf_entrada=?v_entradas_00.nf_entrada and serie_nf_entrada=?v_entradas_00.serie_nf_entrada and nome_clifor=?v_entradas_00.nome_clifor")
			thisformset.refresh()
			o_toolbar.Botao_refresh.Click() 
				
		if	!f_vazio(xalias)	
			sele &xalias 
		endif		


	
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_marca_div
**************************************************






**************************************************
*-- Class:        bt_cancela_nota (c:\temp\bt_marca_div.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/09 04:13:09 PM
*
DEFINE CLASS bt_cancela_nota AS botao


	Top = 95
	Left = 600
	Height = 24
	Width = 94
	FontBold = .F.
	FontSize = 8
	Caption = "Cancela Nota"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_cancela_nota"
	Visible=.t.
	Enabled=.t.	

	PROCEDURE Click

		xalias=alias()

			if messagebox("Deseja Realmente Cancelar esta Nota?",4+256+32,"Atenção!")=6

				f_update("delete  from entradas_imposto where nf_entrada=?v_entradas_00.nf_entrada and serie_nf_entrada=?v_entradas_00.serie_nf_entrada and nome_clifor=?v_entradas_00.nome_clifor")
				*f_update("update entradas set nota_cancelada = 1 where nf_entrada=?v_entradas_00.nf_entrada and serie_nf_entrada=?v_entradas_00.serie_nf_entrada and nome_clifor=?v_entradas_00.nome_clifor")
				thisformset.refresh()
				o_toolbar.Botao_refresh.Click() 

			endif	
				
		if	!f_vazio(xalias)	
			sele &xalias 
		endif		


	
	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_cancela_nota
**************************************************



