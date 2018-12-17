* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Alteracao conta contabil lancamento					                    *
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


			             with thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar	 	
						

								.addObject("lb_conta_contabil","lb_conta_contabil")
								.lb_conta_contabil.Height = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.Height
								.lb_conta_contabil.Left  = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.left
								.lb_conta_contabil.Top = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.top
								.lb_conta_contabil.Width = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.width
								.lb_conta_contabil.Caption = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_conta_contabil.Caption 
								.label_conta_contabil.visible=.f.								
								.label_conta_contabil.top=-1000								
								.addObject("lb_rateio_centro_custo","lb_rateio_centro_custo")
								.lb_rateio_centro_custo.Height = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.Height
								.lb_rateio_centro_custo.Left  = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.left
								.lb_rateio_centro_custo.Top = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.top
								.lb_rateio_centro_custo.Width = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.width
								.lb_rateio_centro_custo.Caption = thisformset.lx_form1.lx_pageframe1.page1.cnt_lanc_auxiliar.label_rateio_centro_custo.Caption 
								.label_rateio_centro_custo.visible=.f.								
								.label_rateio_centro_custo.top=-1000											

								
			              endwith	


					
					if !f_vazio(xalias)
						sele &xalias
					endif	










				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE




**************************************************
*-- Class:        label_conta_contabil (c:\temp\label_conta_contabil.vcx)
*-- ParentClass:  lx_label (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/13/11 01:48:13 PM
*
DEFINE CLASS lb_conta_contabil AS lx_label


	Name = "lb_conta_contabil"
	Enabled = .t.
	Visible = .t.

	PROCEDURE DblClick
		
		dodefault()
		
		IF thisformset.p_tool_status='P'		

			xalias=alias()

			f_select("select valor_atual from parametros where parametro='anm_users_alteracao_cp'","tmpUsersCp",alias())
			
			text to xsel noshow textmerge	
				select * from users
				where usuario in (<<allt(tmpUsersCp.valor_atual)>>)	
				and upper(usuario)='<<upper(wusuario)>>'
			endtext	 
			
			f_select(xsel,"curUsersCp",alias())
			

			sele curUsersCp
			if reccount()=0
				Messagebox("Você não tem Permissão para Alterar esta Informação!",48,"Atenção!")
				retu .f.
			endif

			
			If messagebox("Deseja Alterar a Conta deste Lancamento?",4+32+256,"Atenção!!!")=6 
			
				xnewCont=inputbox("Digite a Nova Conta Contábil.","")
				

				f_select("select * from ctb_conta_plano where conta_contabil=?xnewCont","tmpCrExist") 
				
				sele tmpCrExist 
				if reccount()=0
					messagebox("A Conta Contábil "+allt(xnewCont)+" Não Existe!"+chr(13)+"Verifique!",48,"Atenção!" ) 
					retu .f. 
				endif	
								
				
				text to	xUpdt noshow textmerge	
					
					update ctb_lancamento_item set conta_contabil='<<allt(xnewCont)>>' 
					where lancamento='<<v_ctb_lancamento_01_item.lancamento>>' 
					and   empresa='<<v_ctb_lancamento_01_item.empresa>>'				
					and   item='<<v_ctb_lancamento_01_item.item>>'
										
				endtext	
				
				if !f_vazio(xnewCont)

					if !f_update(xUpdt)
						messagebox("Não foi possível alterar a Conta deste Lancamento!",48,"Atenção!")
						retu .f.
					endif	
					
					o_toolbar.Botao_refresh.Click()  
					
					messagebox("Lançamento Alterado com Sucesso!",48,"Atenção!")
						
				endif		
					
					
			Endif	
			
			

			if !f_vazio(xalias)
				sele &xalias
			endif	

		ENDIF 		
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: label_conta_contabil
**************************************************



**************************************************
*-- Class:        lb_rateio_centro_custo (c:\temp\label_rateio_centro_custo.vcx)
*-- ParentClass:  lx_label (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   04/13/11 01:49:09 PM
*
DEFINE CLASS lb_rateio_centro_custo AS lx_label

	Enabled = .t.
	Visible = .t.
	Name = "lb_rateio_centro_custo"

	PROCEDURE DblClick
		
		dodefault()
		
		IF thisformset.p_tool_status='P'		

			xalias=alias()

			f_select("select valor_atual from parametros where parametro='anm_users_alteracao_cp'","tmpUsersCp",alias())
			
			text to xsel noshow textmerge	
				select * from users
				where usuario in (<<allt(tmpUsersCp.valor_atual)>>)	
				and upper(usuario)='<<upper(wusuario)>>'
			endtext	 
			
			f_select(xsel,"curUsersCp",alias())
			

			sele curUsersCp
			if reccount()=0
				Messagebox("Você não tem Permissão para Alterar esta Informação!",48,"Atenção!")
				retu .f.
			endif

			
			If messagebox("Deseja Alterar o CR deste Lancamento?",4+32+256,"Atenção!!!")=6 
			
				xnewCont=inputbox("Digite o Novo CR.","")
				
				f_select("select * from ctb_centro_custo_rateio where rateio_centro_custo=?xnewCont","tmpCrExist") 
				
				sele tmpCrExist 
				if reccount()=0
					messagebox("O CR "+allt(xnewCont)+" Não Existe!"+chr(13)+"Verifique!",48,"Atenção!" ) 
					retu .f. 
				endif	
				
				text to	xUpdt noshow textmerge	
					
					update ctb_lancamento_item set rateio_centro_custo='<<allt(xnewCont)>>' 
					where lancamento='<<v_ctb_lancamento_01_item.lancamento>>' 
					and   empresa='<<v_ctb_lancamento_01_item.empresa>>'				
					and   item='<<v_ctb_lancamento_01_item.item>>'
										
				endtext	
				
				if !f_vazio(xnewCont)

					if !f_update(xUpdt)
						messagebox("Não foi possível alterar o CR deste Lancamento!",48,"Atenção!")
						retu .f.
					endif	
					
					o_toolbar.Botao_refresh.Click()  

					messagebox("Lançamento Alterado com Sucesso!",48,"Atenção!")
					
				endif		
					
					
			Endif	
			
			

			if !f_vazio(xalias)
				sele &xalias
			endif	

		ENDIF 		
			
	ENDPROC


ENDDEFINE
*
*-- EndDefine: label_rateio_centro_custo
**************************************************

