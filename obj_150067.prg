* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                              *
* HORÁRIO........:                                                                                             *
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
			
			
			
			xVersao = '01.1'
			f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
			f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
			WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
			
			
			
			TEXT TO xsel NOSHOW TEXTMERGE
					
				SELECT DISTINCT 
				FILIAIS.FILIAL,
				DISTRIBUICAO_LOJA_IDEAL.TIPO_ESTOQUE_IDEAL, 
				DISTRIBUICAO_LOJA_IDEAL.DESC_ESTOQUE_LOJA_IDEAL,
				ESTOQUE_IDEAL = ISNULL( E1.ESTOQUE_IDEAL, 0 ), 
				ESTOQUE_IDEAL_MIN = ISNULL( E2.ESTOQUE_IDEAL_MIN, 0), 
				ESTOQUE_IDEAL_MAX = ISNULL( E3.ESTOQUE_IDEAL_MAX, 0)
				FROM DISTRIBUICAO_LOJA_IDEAL 
				LEFT JOIN ( SELECT DISTINCT TIPO_ESTOQUE_IDEAL, 
				CAST( 1 AS INTEGER ) AS ESTOQUE_IDEAL 
				FROM FILIAIS WHERE TIPO_ESTOQUE_IDEAL IS NOT NULL) AS E1 
				ON ( DISTRIBUICAO_LOJA_IDEAL.TIPO_ESTOQUE_IDEAL = E1.TIPO_ESTOQUE_IDEAL ) 
				LEFT JOIN ( SELECT DISTINCT TIPO_ESTOQUE_IDEAL_MIN, CAST( 1 AS INTEGER ) AS ESTOQUE_IDEAL_MIN 
				FROM FILIAIS WHERE TIPO_ESTOQUE_IDEAL_MIN IS NOT NULL) AS E2 
				ON ( DISTRIBUICAO_LOJA_IDEAL.TIPO_ESTOQUE_IDEAL = E2.TIPO_ESTOQUE_IDEAL_MIN ) 
				LEFT JOIN ( SELECT DISTINCT TIPO_ESTOQUE_IDEAL_MAX, CAST( 1 AS INTEGER ) AS ESTOQUE_IDEAL_MAX 
				FROM FILIAIS WHERE TIPO_ESTOQUE_IDEAL_MAX IS NOT NULL) AS E3 
				ON ( DISTRIBUICAO_LOJA_IDEAL.TIPO_ESTOQUE_IDEAL = E3.TIPO_ESTOQUE_IDEAL_MAX )
				INNER JOIN FILIAIS 
				ON DISTRIBUICAO_LOJA_IDEAL.TIPO_ESTOQUE_IDEAL=FILIAIS.TIPO_ESTOQUE_IDEAL
			ENDTEXT
			
			f_select(xsel, 'Cur_Filial')
				

				thisformset.lx_form1.lx_PAGEFRAME1.page2.addobject("cmb_filial","cmb_filial")
				
				
				IF thisformset.lx_FORM1.lx_PAGEFRAME1.ActivePage=2
					thisformset.lx_form1.lx_pageframe1.page2.cmb_filial.visible=.t.
				ENDIF


			case upper(xmetodo) == 'USR_VALID' AND upper(xnome_obj) == 'CMB_FILIAL' 
			SET STEP ON
			IF THISFORMSET.P_TOOL_STATUS ='A'
			
				IF MESSAGEBOX("Tem Certeza Que Deseja Transferir a Grade Para Essa Filial?",4)==6
						
					TEXT TO xsel NOSHOW TEXTMERGE
						SELECT * FROM lojas_estoque_ideal
						where produto='<<Cur_lojas_estoque_ideal.produto>>'
						and cor_produto='<<Cur_lojas_estoque_ideal.cor_produto>>'
						and tipo_estoque_ideal='<<Cur_lojas_estoque_ideal.tipo_estoque_ideal>>'
					ENDTEXT
					
						f_select(xsel,'Vtmp_Cur_lojas_estoque_ideal')

						
						SELECT Vtmp_Cur_lojas_estoque_ideal
BROWSE normal
						
							UPDATE Cur_lojas_estoque_ideal SET Cur_lojas_estoque_ideal.Q1 = 0, Cur_lojas_estoque_ideal.Q2 = 0,Cur_lojas_estoque_ideal.Q3 = 0, Cur_lojas_estoque_ideal.Q4 = 0, Cur_lojas_estoque_ideal.Q5 = 0, Cur_lojas_estoque_ideal.Q6 = 0, Cur_lojas_estoque_ideal.Q7 = 0, Cur_lojas_estoque_ideal.Q8 = 0 FROM Cur_lojas_estoque_ideal INNER JOIN Vtmp_Cur_lojas_estoque_ideal ON Cur_lojas_estoque_ideal.produto = Vtmp_Cur_lojas_estoque_ideal.PRODUTO AND Cur_lojas_estoque_ideal.cor_produto=Vtmp_Cur_lojas_estoque_ideal.COR_PRODUTO AND Cur_lojas_estoque_ideal.tipo_estoque_ideal=Vtmp_Cur_lojas_estoque_ideal.TIPO_ESTOQUE_IDEAL
						
						SELECT Cur_lojas_estoque_ideal
						GO top

						
						xFilial=thisformset.lx_FORM1.lx_PAGEFRAME1.page2.cmb_filial.Value
						
					TEXT TO xsel2 NOSHOW TEXTMERGE
						SELECT distinct filiais.filial, DISTRIBUICAO_LOJA_IDEAL.desc_estoque_loja_ideal, lojas_estoque_ideal.*
						FROM lojas_estoque_ideal
						INNER JOIN FILIAIS 
						ON LOJAS_ESTOQUE_IDEAL.TIPO_ESTOQUE_IDEAL=FILIAIS.TIPO_ESTOQUE_IDEAL
						INNER JOIN DISTRIBUICAO_LOJA_IDEAL
						ON LOJAS_ESTOQUE_IDEAL.TIPO_ESTOQUE_IDEAL=DISTRIBUICAO_LOJA_IDEAL.TIPO_ESTOQUE_IDEAL
						where filial='<<xfilial>>'
						and lojas_estoque_ideal.produto='<<Vtmp_Cur_lojas_estoque_ideal.produto>>'
						and lojas_estoque_ideal.cor_produto='<<Vtmp_Cur_lojas_estoque_ideal.cor_produto>>'
					ENDTEXT
					
						f_select(xsel2,'Vtmp_filial')
						
						SELECT Vtmp_filial
BROWSE normal
						
						IF !F_vazio(Vtmp_filial.filial)
						
							UPDATE Cur_lojas_estoque_ideal SET Cur_lojas_estoque_ideal.Q1 = Vtmp_Cur_lojas_estoque_ideal.Q1, Cur_lojas_estoque_ideal.Q2 = Vtmp_Cur_lojas_estoque_ideal.Q2, Cur_lojas_estoque_ideal.Q3 = Vtmp_Cur_lojas_estoque_ideal.Q3, Cur_lojas_estoque_ideal.Q4 = Vtmp_Cur_lojas_estoque_ideal.Q4, Cur_lojas_estoque_ideal.Q5 = Vtmp_Cur_lojas_estoque_ideal.Q5, Cur_lojas_estoque_ideal.Q6 = Vtmp_Cur_lojas_estoque_ideal.Q6, Cur_lojas_estoque_ideal.Q7 = Vtmp_Cur_lojas_estoque_ideal.Q7, Cur_lojas_estoque_ideal.Q8 = Vtmp_Cur_lojas_estoque_ideal.Q8 FROM Cur_lojas_estoque_ideal INNER JOIN Vtmp_filial ON Cur_lojas_estoque_ideal.produto = Vtmp_filial.PRODUTO AND Cur_lojas_estoque_ideal.cor_produto=Vtmp_filial.COR_PRODUTO AND Cur_lojas_estoque_ideal.tipo_estoque_ideal=Vtmp_filial.TIPO_ESTOQUE_IDEAL

						ELSE
						
							IF MESSAGEBOX("Não Existe No Estoque Ideal, Tem Certeza Que Deseja Incluir e Transferir a Grade Para Essa Filial?",4)==6
						
								TEXT TO xsel3 NOSHOW TEXTMERGE
									SELECT distinct filiais.filial, DISTRIBUICAO_LOJA_IDEAL.TIPO_estoque_ideal, DISTRIBUICAO_LOJA_IDEAL.desc_estoque_loja_ideal
									FROM FILIAIS 
									INNER JOIN DISTRIBUICAO_LOJA_IDEAL
									ON FILIAIS.TIPO_ESTOQUE_IDEAL=DISTRIBUICAO_LOJA_IDEAL.TIPO_ESTOQUE_IDEAL
									where filial='<<xfilial>>'
								ENDTEXT
					
								f_select(xsel3,'Vtmp_inclui')
						
						
								SELECT Vtmp_inclui
BROWSE normal
								o_toolbar.Botao_inclui.Click()
							
								thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_GRID_FILHA1.col_TV_TIPO_ESTOQUE_IDEAL.tv_TIPO_ESTOQUE_IDEAL.value=Vtmp_inclui.tipo_estoque_ideal
								thisformset.lx_FORM1.lx_PAGEFRAME1.page1.lx_GRID_FILHA1.col_tx_desc_estoque_loja_ideal.tx_desc_estoque_loja_ideal.value=Vtmp_inclui.desc_estoque_loja_ideal
								thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.col_tv_produto.tv_produto.value=Vtmp_Cur_lojas_estoque_ideal.produto
								thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.col_tv_cor_produto.tv_cor_produto.value=Vtmp_Cur_lojas_estoque_ideal.cor_produto
								
								
								REPLACE Cur_lojas_estoque_ideal.Q1 WITH Vtmp_Cur_lojas_estoque_ideal.Q1
								REPLACE Cur_lojas_estoque_ideal.Q2 WITH Vtmp_Cur_lojas_estoque_ideal.Q2
								REPLACE Cur_lojas_estoque_ideal.Q3 WITH Vtmp_Cur_lojas_estoque_ideal.Q3
								REPLACE Cur_lojas_estoque_ideal.Q4 WITH Vtmp_Cur_lojas_estoque_ideal.Q4
								REPLACE Cur_lojas_estoque_ideal.Q5 WITH Vtmp_Cur_lojas_estoque_ideal.Q5
								REPLACE Cur_lojas_estoque_ideal.Q6 WITH Vtmp_Cur_lojas_estoque_ideal.Q6
								REPLACE Cur_lojas_estoque_ideal.Q7 WITH Vtmp_Cur_lojas_estoque_ideal.Q7
								REPLACE Cur_lojas_estoque_ideal.Q8 WITH Vtmp_Cur_lojas_estoque_ideal.Q8


							ENDIF			
							
						ENDIF
						
							thisformset.lx_FORM1.lx_pageframe1.ActivePage=1
						
							SELECT Cur_lojas_estoque_ideal
						
				ENDIF
			ENDIF

				otherwise
				return .t.				
			endcase

	
	ENDPROC
	
ENDDEFINE

DEFINE CLASS cmb_filial AS lx_combobox


	RowSource = "Cur_Filial"
	Height = 18
	Left = 710
	TabIndex = 1
	Top = 27
	Width = 160
	ZOrderSet = 5
	Name = "cmb_filial"
	Visible = .t.
	Enabled = .t.

ENDDEFINE


