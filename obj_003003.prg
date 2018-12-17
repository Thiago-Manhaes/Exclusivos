* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  06/10/2008                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Inclusao percentual Pilotagem						                    *
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
				
					*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_produtos_linhas_00   
					sele v_colecoes_00   
					xalias_pai=alias()

	  				oCur = getcursoradapter(xalias_pai)
	  				oCur.addbufferfield("ANM_COLECAO_BASE", "C(6)",.T., "ANM_COLECAO_BASE", "colecoes.ANM_COLECAO_BASE")	
					oCur.addbufferfield("ANM_PILOT_ANIMALE", "N(8,2)",.T., "ANM_PILOT_ANIMALE", "colecoes.ANM_PILOT_ANIMALE")				
					oCur.addbufferfield("ANM_PILOT_FYI", "N(8,2)",.T., "ANM_PILOT_FYI", "colecoes.ANM_PILOT_FYI")
					oCur.addbufferfield("ANM_PILOT_ABRAND", "N(8,2)",.T., "ANM_PILOT_ABRAND", "colecoes.ANM_PILOT_ABRAND")
					
					oCur.addbufferfield("ANM_PILOT_FARM", "N(8,2)",.T., "ANM_PILOT_FARM", "colecoes.ANM_PILOT_FARM")
					oCur.addbufferfield("ANM_PILOT_FABULA", "N(8,2)",.T., "ANM_PILOT_FABULA", "colecoes.ANM_PILOT_FABULA")
					oCur.addbufferfield("ANM_PILOT_FOXTON", "N(8,2)",.T., "ANM_PILOT_FOXTON", "colecoes.ANM_PILOT_FOXTON")
					oCur.addbufferfield("INATIVA_PILOTAGEM", "L",.T., "INATIVA_PILOTAGEM", "colecoes.INATIVA_PILOTAGEM")							
					oCur.confirmstructurechanges() 	
					**-Fim Inclusao Campos Novos de Produtos no Cursor Pai 
				
				     
					WITH THISFORMSET.lx_form1.lx_GRID_FILHA1
						
						.addColumn(13)
						.Columns(13).name="col_Colecao_Base"
						.col_Colecao_Base.Header1.Caption="Colecao"+CHR(13)+CHR(10)+"Base"
						.col_Colecao_Base.Header1.Alignment= 2
						.col_Colecao_Base.Header1.WordWrap= .t.
						.col_Colecao_Base.Header1.FontSize=8
						.col_Colecao_Base.ControlSource='v_colecoes_00.ANM_COLECAO_BASE'
						.col_Colecao_Base.enabled = .f.
						.col_Colecao_Base.BackColor=15399423  		
						.col_Colecao_Base.Visible = .f.
						
						.addColumn(14)
						.Columns(14).name="col_Inativa_Pilotagem"
						.col_Inativa_Pilotagem.Header1.Caption="Inativa"+CHR(13)+CHR(10)+"Pilotagem"
						.col_Inativa_Pilotagem.Header1.Alignment= 2
						.col_Inativa_Pilotagem.Header1.WordWrap= .t.
						.col_Inativa_Pilotagem.Header1.FontSize=8
						.col_Inativa_Pilotagem.ControlSource='v_colecoes_00.inativa_pilotagem'
						.col_Inativa_Pilotagem.enabled = .f.
						.col_Inativa_Pilotagem.BackColor=15399423  					
						
						.addColumn(15)
						.Columns(15).name="col_Perc_Pilotagem_Animale"
						.col_Perc_Pilotagem_Animale.Header1.Caption="% Pilotagem"+CHR(13)+CHR(10)+"ANIMALE"
						.col_Perc_Pilotagem_Animale.Header1.Alignment= 2
						.col_Perc_Pilotagem_Animale.Header1.WordWrap= .t.
						.col_Perc_Pilotagem_Animale.Header1.FontSize=8
						.col_Perc_Pilotagem_Animale.ControlSource='v_colecoes_00.ANM_PILOT_ANIMALE'
						.col_Perc_Pilotagem_Animale.enabled = .f.
						.col_Perc_Pilotagem_Animale.BackColor=15399423
						
						.addColumn(16)
						.Columns(16).name="col_Perc_Pilotagem_Fyi"
						*.Columns(15).width=95
						.col_Perc_Pilotagem_Fyi.Header1.Caption="% Pilotagem"+CHR(13)+CHR(10)+"FYI STORE"
						.col_Perc_Pilotagem_Fyi.Header1.Alignment= 2
						.col_Perc_Pilotagem_Fyi.Header1.WordWrap= .t.
						.col_Perc_Pilotagem_Fyi.Header1.FontSize=8
						.col_Perc_Pilotagem_Fyi.ControlSource='v_colecoes_00.ANM_PILOT_FYI'
						.col_Perc_Pilotagem_Fyi.enabled = .f.
						.col_Perc_Pilotagem_Fyi.BackColor=15399423
						
						.addColumn(17)
						.Columns(17).name="col_Perc_Pilotagem_Abrand"
						*.Columns(16).width=130
						.col_Perc_Pilotagem_Abrand.Header1.Caption="% Pilotagem"+CHR(13)+CHR(10)+"A.BRAND"
						.col_Perc_Pilotagem_Abrand.Header1.Alignment= 2
						.col_Perc_Pilotagem_Abrand.Header1.WordWrap= .t.
						.col_Perc_Pilotagem_Abrand.Header1.FontSize=8
						.col_Perc_Pilotagem_Abrand.ControlSource='v_colecoes_00.ANM_PILOT_ABRAND'	
						.col_Perc_Pilotagem_Abrand.enabled = .f.
						.col_Perc_Pilotagem_Abrand.BackColor=15399423	
						.parent.Width=605
						.parent.lx_GRID_FILHA1.Width=605
						.parent.Lx_TitleBar.Width=605	
						
						.addColumn(18)
						.Columns(18).name="col_Perc_Pilotagem_Farm"
						.col_Perc_Pilotagem_Farm.Header1.Caption="% Pilotagem"+CHR(13)+CHR(10)+"FARM"
						.col_Perc_Pilotagem_Farm.Header1.Alignment= 2
						.col_Perc_Pilotagem_Farm.Header1.WordWrap= .t.
						.col_Perc_Pilotagem_Farm.Header1.FontSize=8
						.col_Perc_Pilotagem_Farm.ControlSource='v_colecoes_00.ANM_PILOT_FARM'	
						.col_Perc_Pilotagem_Farm.enabled = .f.
						.col_Perc_Pilotagem_Farm.BackColor=15399423	
						.parent.Width=605
						.parent.lx_GRID_FILHA1.Width=605
						.parent.Lx_TitleBar.Width=605	
						
						.addColumn(19)
						.Columns(19).name="col_Perc_Pilotagem_Fabula"
						.col_Perc_Pilotagem_Fabula.Header1.Caption="% Pilotagem"+CHR(13)+CHR(10)+"FABULA"
						.col_Perc_Pilotagem_Fabula.Header1.Alignment= 2
						.col_Perc_Pilotagem_Fabula.Header1.WordWrap= .t.
						.col_Perc_Pilotagem_Fabula.Header1.FontSize=8
						.col_Perc_Pilotagem_Fabula.ControlSource='v_colecoes_00.ANM_PILOT_FABULA'	
						.col_Perc_Pilotagem_Fabula.enabled = .f.
						.col_Perc_Pilotagem_Fabula.BackColor=15399423	
						.parent.Width=605
						.parent.lx_GRID_FILHA1.Width=605
						.parent.Lx_TitleBar.Width=605	
						
						.addColumn(20)
						.Columns(20).name="col_Perc_Pilotagem_Foxton"
						.col_Perc_Pilotagem_Foxton.Header1.Caption="% Pilotagem"+CHR(13)+CHR(10)+"FOXTON"
						.col_Perc_Pilotagem_Foxton.Header1.Alignment= 2
						.col_Perc_Pilotagem_Foxton.Header1.WordWrap= .t.
						.col_Perc_Pilotagem_Foxton.Header1.FontSize=8
						.col_Perc_Pilotagem_Foxton.ControlSource='v_colecoes_00.ANM_PILOT_FOXTON'	
						.col_Perc_Pilotagem_Foxton.enabled = .f.
						.col_Perc_Pilotagem_Foxton.BackColor=15399423	
						.parent.Width=605
						.parent.lx_GRID_FILHA1.Width=605
						.parent.Lx_TitleBar.Width=605	
															
					ENDWITH

				
				case upper(xmetodo) == 'USR_REFRESH' 
					
					xalias_pai=alias()
						
						WITH THISFORMSET.lx_form1.lx_GRID_FILHA1 
							.col_Perc_Pilotagem_Animale.enabled = THISFORMSET.P_TOOL_STATUS <> 'P'
							.col_Perc_Pilotagem_Fyi.enabled		= THISFORMSET.P_TOOL_STATUS <> 'P'
							.col_Perc_Pilotagem_Abrand.enabled 	= THISFORMSET.P_TOOL_STATUS <> 'P'
							.col_Perc_Pilotagem_Farm.enabled 	= THISFORMSET.P_TOOL_STATUS <> 'P'
							.col_Perc_Pilotagem_Fabula.enabled 	= THISFORMSET.P_TOOL_STATUS <> 'P'
							.col_Perc_Pilotagem_Foxton.enabled 	= THISFORMSET.P_TOOL_STATUS <> 'P'
							.col_Inativa_Pilotagem.enabled 		= THISFORMSET.P_TOOL_STATUS <> 'P'
						ENDWITH
					
					if	!f_vazio(xalias_pai)	
						sele &xalias_pai
					endif
								
*!*						IF THISFORMSET.P_TOOL_STATUS <> 'P'
*!*							
*!*							WITH THISFORMSET.lx_form1.lx_GRID_FILHA1 
*!*								.col_Colecao_Base.enabled 			= .t.
*!*								.col_Perc_Pilotagem_Animale.enabled = .t.
*!*								.col_Perc_Pilotagem_Fyi.enabled		= .t.
*!*								.col_Perc_Pilotagem_Abrand.enabled 	= .t.
*!*								.col_Inativa_Pilotagem.enabled 		= .t.
*!*							ENDWITH
*!*						
*!*						ELSE
*!*						
*!*							WITH THISFORMSET.lx_form1.lx_GRID_FILHA1 
*!*								.col_Colecao_Base.enabled 			= .t.
*!*								.col_Perc_Pilotagem_Animale.enabled = .f.
*!*								.col_Perc_Pilotagem_Fyi.enabled		= .f.
*!*								.col_Perc_Pilotagem_Abrand.enabled 	= .f.
*!*								.col_Inativa_Pilotagem.enabled 		= .f.
*!*							ENDWITH
*!*							
*!*						ENDIF

	

*!*					case upper(xmetodo) == 'USR_SAVE_BEFORE' 	

*!*						sele v_colecoes_00   
*!*						xalias_pai=alias()
*!*					
*!*						sele v_colecoes_00   
*!*						go top	
*!*						scan	
*!*							if nvl(anm_colecao_base,' ')=' '
*!*								repla anm_colecao_base	with colecao 
*!*							endif	
*!*						endscan								
*!*					
*!*					
*!*						if	used('tmp1colecoes')
*!*							sele tmp1colecoes 
*!*							use	
*!*						endif
*!*						
*!*						if	type("tmp1colecoes")<>"U"
*!*							sele tmp1colecoes 
*!*							use	
*!*						endif
*!*						
*!*						if	used('tmp2colecoes')
*!*							sele tmp2colecoes 
*!*							use	
*!*						endif
*!*							
*!*						if	type("tmp2colecoes")<>"U"
*!*							sele tmp2colecoes 
*!*							use	
*!*						endif					
*!*				
*!*						select anm_colecao_base from v_colecoes_00 where 1=2 into cursor tmp1colecoes readwrite
*!*						select colecao          from v_colecoes_00 where 1=2 into cursor tmp2colecoes readwrite
*!*						
*!*						sele v_colecoes_00   
*!*						go top
*!*						scan	
*!*						
*!*							sele tmp1colecoes 
*!*							appe blank	
*!*							repla anm_colecao_base with v_colecoes_00.anm_colecao_base 

*!*							sele tmp2colecoes 
*!*							appe blank	
*!*							repla colecao          with v_colecoes_00.colecao          
*!*							
*!*							sele v_colecoes_00   						   
*!*							
*!*						endscan

*!*						
*!*						select a.* from	tmp1colecoes a ; 
*!*						left join tmp2colecoes b ;
*!*						on a.anm_colecao_base =b.colecao ;
*!*						where b.colecao is null	;
*!*						into cursor tmp3_colecoes	
*!*						
*!*						
*!*						
*!*						sele tmp3_colecoes
*!*						if reccount()>0
*!*							messagebox("As Coleções relacionadas a seguir não foram encontradas !",48)
*!*							brow normal	
*!*							retu .t.
*!*						endif	         	
*!*						

*!*						if	!f_vazio(xalias_pai)	
*!*							sele &xalias_pai
*!*						endif
*!*					
	
					
					
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE