* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Seleciona Destinos na coluna requisitante                                                                                                     *
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
				
					public	xpai_filtro,xdata_ini,xdata_fim 
					xpai_filtro = thisformset.p_pai_filtro
					xdata_ini   = ctod('')
					xdata_fim   = ctod('') 
				
				
					xalias=alias()
					
					with Thisform.lx_pageframe1.Page1
						.AddObject("tv_depto_destino","tv_depto_destino") 
						.AddObject("lb_data_pesquisa","lb_data_pesquisa") 
						.AddObject("tx_data_ini","tx_data_ini") 
						.AddObject("tx_data_fim","tx_data_fim") 																		
					endwith		


					if	!f_vazio(xalias)	
						sele &xalias 
					endif		

				
				case UPPER(xmetodo) == 'USR_ALTER_AFTER' 
				
					xalias=alias()
				
				
						SELECT * FROM V_ESTOQUE_SAI_MAT_00_MATERIAIS INTO CURSOR VTMP_ESTOQUE_SAI_MAT_00_MATERIAIS 
						SELECT * FROM V_ESTOQUE_SAI_MAT_00_PECAS INTO CURSOR VTMP_ESTOQUE_SAI_MAT_00_PECAS 
				
				
					if	!f_vazio(xalias)	
						sele &xalias 
					endif
				
					

				case UPPER(xmetodo) == 'USR_SAVE_BEFORE'  
				
					if V_ESTOQUE_SAI_MAT_00.FILIAL='ALMOXARIFADO'
						
						if f_vazio(V_ESTOQUE_SAI_MAT_00.REQUISITANTE)
							messagebox("O Campo Requisitante não pode ficar vazio !")
							retu .f.
						endif

					endif
					
					sele v_estoque_sai_mat_00_materiais
						scan
							if f_vazio(v_estoque_sai_mat_00_materiais.pedido)
								replace v_estoque_sai_mat_00_materiais.pedido WITH null 
							Endif	
							
							if f_vazio(v_estoque_sai_mat_00_materiais.entrega)
								replace v_estoque_sai_mat_00_materiais.entrega WITH null 
							Endif	
						endscan
					 
					If UPPER(Thisformset.p_tool_status) = 'A'
						UPDATE  A SET QTDE= (B.QTDE+B.PERDA)-A.PERDA FROM V_ESTOQUE_SAI_MAT_00_MATERIAIS A ;
						JOIN VTMP_ESTOQUE_SAI_MAT_00_MATERIAIS B ;
						ON A.MATERIAL = B.MATERIAL AND A.COR_MATERIAL = B.COR_MATERIAL AND A.REQ_MATERIAL = B.REQ_MATERIAL AND ;
						   A.FILIAL = B.FILIAL AND A.ITEM = B.ITEM
						
					
*!*						SELECT VTMP_ESTOQUE_SAI_MAT_00_PECAS  
*!*						BROWSE NORMAL 
*!*						
*!*						
*!*						SELECT V_ESTOQUE_SAI_MAT_00_PECAS 
*!*						BROWSE NORMAL 
*!*							
*!*						SELECT  (B.QTDE+B.PERDA)-A.PERDA AS TESTESID,A.* FROM V_ESTOQUE_SAI_MAT_00_PECAS A ;
*!*							JOIN VTMP_ESTOQUE_SAI_MAT_00_PECAS B ;
*!*							ON A.MATERIAL = B.MATERIAL AND A.COR_MATERIAL = B.COR_MATERIAL AND A.REQ_MATERIAL = B.REQ_MATERIAL ;
*!*							AND A.PECA=B.PECA INTO CURSOR TMPSID1
*!*							
*!*							BROWSE NORMAL 
							
						
						UPDATE  A SET QTDE= (B.QTDE+B.PERDA)-A.PERDA FROM V_ESTOQUE_SAI_MAT_00_PECAS A ;
						JOIN VTMP_ESTOQUE_SAI_MAT_00_PECAS B ;
						ON A.MATERIAL = B.MATERIAL AND A.COR_MATERIAL = B.COR_MATERIAL AND A.REQ_MATERIAL = B.REQ_MATERIAL ;
						AND A.PECA=B.PECA AND A.FILIAL = B.FILIAL AND A.ITEM = B.ITEM
						
					Endif	
				
				case UPPER(xmetodo) == 'USR_SAVE_AFTER'
				
				xalias=alias()
				** #1 - LUCAS MIRANDA - 28/03/2016 - GERAR PEÇA NO DESTINO AO FAZER TRANSFERENCIA
					If UPPER(Thisformset.p_tool_status) = 'I'
						Text To SelConfEnt TextMerge Noshow
						
							SELECT COUNT(*) as QTDE_PECA_RET
							FROM ESTOQUE_SAI_MAT
							JOIN ESTOQUE_SAI1_MAT 
							ON ESTOQUE_SAI_MAT.REQ_MATERIAL = ESTOQUE_SAI1_MAT.REQ_MATERIAL
							AND ESTOQUE_SAI_MAT.FILIAL = ESTOQUE_SAI1_MAT.FILIAL
							JOIN ESTOQUE_SAI_PECA 
							ON ESTOQUE_SAI1_MAT.REQ_MATERIAL = ESTOQUE_SAI_PECA.REQ_MATERIAL
							AND ESTOQUE_SAI1_MAT.FILIAL = ESTOQUE_SAI_PECA.FILIAL
							AND ESTOQUE_SAI1_MAT.MATERIAL = ESTOQUE_SAI_PECA.MATERIAL
							AND ESTOQUE_SAI1_MAT.COR_MATERIAL = ESTOQUE_SAI_PECA.COR_MATERIAL
							JOIN ESTOQUE_RET_MAT 
							ON ESTOQUE_SAI_MAT.REQ_MATERIAL_DESTINO = ESTOQUE_RET_MAT.REQ_MATERIAL
							AND ESTOQUE_SAI_MAT.FILIAL = ESTOQUE_RET_MAT.FILIAL_ORIGEM
							JOIN ESTOQUE_RET1_MAT
							ON ESTOQUE_RET_MAT.REQ_MATERIAL = ESTOQUE_RET1_MAT.REQ_MATERIAL
							AND ESTOQUE_RET_MAT.FILIAL = ESTOQUE_RET1_MAT.FILIAL
							AND ESTOQUE_SAI1_MAT.MATERIAL = ESTOQUE_RET1_MAT.MATERIAL
							AND ESTOQUE_SAI1_MAT.COR_MATERIAL = ESTOQUE_RET1_MAT.COR_MATERIAL
							LEFT JOIN ESTOQUE_RET_PECA
							ON ESTOQUE_RET_MAT.REQ_MATERIAL = ESTOQUE_RET_PECA.REQ_MATERIAL
							AND ESTOQUE_RET_MAT.FILIAL = ESTOQUE_RET_PECA.FILIAL
							AND ESTOQUE_SAI_PECA.MATERIAL = ESTOQUE_RET_PECA.MATERIAL
							AND ESTOQUE_SAI_PECA.COR_MATERIAL = ESTOQUE_RET_PECA.COR_MATERIAL

							WHERE ESTOQUE_RET_PECA.PECA IS NULL
							AND ESTOQUE_SAI_MAT.TIPO_MOVIMENTACAO = 'C'
							AND ESTOQUE_SAI_MAT.REQ_MATERIAL =  '<<V_ESTOQUE_SAI_MAT_00.req_material>>'     

						Endtext
											
						Sele V_ESTOQUE_SAI_MAT_00
						f_select(SelConfEnt,"xConfNfEnt") 

						If xConfNfEnt.QTDE_PECA_RET > 0
							f_update("update estoque_sai_peca set QTDE_AUX = QTDE_AUX where req_material = ?V_ESTOQUE_SAI_MAT_00.req_material")
						Endif
					Endif
				**FIM #1 - LUCAS MIRANDA - 28/03/2016 - GERAR PEÇA NO DESTINO AO FAZER TRANSFERENCIA
				if	!f_vazio(xalias)	
					sele &xalias 
				endif		
				
				case UPPER(xmetodo) == 'USR_VALID' and upper(xnome_obj)='CMB_FILIAL_DESTINO' 

					xalias=alias()
				
					f_select("select filial from filiais where tipo_filial='loja varejo'","curLojas",alias())
					
					sele curLojas 
					go top	
					loca for filial=v_estoque_sai_mat_00.filial_destino 
					
					if found()	
						sele v_estoque_sai_mat_00	
						repla requisitante with filial_destino 
					else	
						sele v_estoque_sai_mat_00	
						repla requisitante with '' 						
					endif	


					if	!f_vazio(xalias)	
						sele &xalias 
					endif	





				case upper(xmetodo) == 'USR_SEARCH_BEFORE' 


					if	!f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_ini.value) and f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_fim.value)
						messagebox("A data Fim não pode ser Vazia!",48,"Atenção!")
						retu .f.
					endif
					

					if	!f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_fim.value) and f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_ini.value)
						messagebox("A data Início não pode ser Vazia!",48,"Atenção!")
						retu .f.
					endif	
										
					
					if	!f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_ini.value) and !f_vazio(thisform.lx_PAGEFRAME1.page1.tx_data_fim.value)

						if	f_vazio(Thisformset.p_pai_filtro)
							thisformset.p_pai_filtro =thisformset.p_pai_filtro +" ESTOQUE_SAI_MAT.EMISSAO BETWEEN '"+dtos(xdata_ini)+"' and '"+dtos(xdata_fim)+"'"
						else	
							thisformset.p_pai_filtro =thisformset.p_pai_filtro +" and ESTOQUE_SAI_MAT.EMISSAO BETWEEN '"+dtos(xdata_ini)+"' and '"+dtos(xdata_fim)+"'"
						endif	
							
					endif	





				case upper(xmetodo) == 'USR_CLEAN_AFTER' 

					if type("thisform.lx_PAGEFRAME1.page1.tx_data_ini")<>"U"
					
						thisformset.p_pai_filtro=xpai_filtro
						xdata_ini   = ctod('')
						xdata_fim   = ctod('') 
	
					endif	
					
	
	
			otherwise
				return .t.				
		endcase
	endproc
enddefine



**************************************************
*-- Class:        tv_depto_destino (c:\temp\tv_depto_destino.vcx)
*-- ParentClass:  lx_textbox_valida (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/18/09 01:02:02 PM
*
DEFINE CLASS tv_depto_destino AS lx_textbox_valida


	ControlSource = "V_ESTOQUE_SAI_MAT_00.REQUISITANTE"
	Height = 22
	Left = 84
	Top = 89
	Width = 161
	ZOrderSet = 5
	p_valida_coluna = "DESTINO"
	p_valida_coluna_tabela = "WANM_DESTINOS_ALMOXARIFADO"
	Name = "tv_depto_destino"
	Visible = .T.
	Enabled = .T.


ENDDEFINE
*
*-- EndDefine: tv_depto_destino
**************************************************




**************************************************
*-- Class:        lb_data_pesquisa (c:\work\desenv\filtros_data\lb_data_venda.vcx)
*-- ParentClass:  lx_label (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    label
*-- Time Stamp:   10/15/08 10:28:09 AM
*
DEFINE CLASS lb_data_pesquisa AS lx_label


	AutoSize = .T.
	FontSize = 10
	Alignment = 2
	Caption = "Filtro Data "
	Height = 20
	Left = 650
	Top = 122
	Width = 100
	TabIndex = 3
	ForeColor = RGB(0,0,160)
	Name = "lb_data_pesquisa"
	Visible = .T.
	Fontbold = .T.

ENDDEFINE
*
*-- EndDefine: lb_data_pesquisa
**************************************************



**************************************************
*-- Class:        tx_data_ini (c:\work\desenv\filtros_data\tx_data_ini.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_data_ini AS lx_textbox_base


	ControlSource = "xdata_ini"
	Height = 22
	Left = 650
	TabIndex = 4
	Top = 143
	Width = 76
	p_tipo_dado = "edita"
	Name = "tx_data_ini"
	Visible = .T.
	Enabled = .T.	

ENDDEFINE
*
*-- EndDefine: tx_data_ini
**************************************************


**************************************************
*-- Class:        tx_data_fim (c:\work\desenv\filtros_data\tx_data_fim.vcx)
*-- ParentClass:  lx_textbox_base (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   10/15/08 10:28:04 AM
*
DEFINE CLASS tx_data_fim AS lx_textbox_base


	ControlSource = "xdata_fim"
	Height = 22
	Left = 650
	TabIndex = 5
	Top = 166
	Width = 76
	p_tipo_dado = "edita"
	Name = "tx_data_fim"
	Visible = .T.
	Enabled = .T.	

ENDDEFINE
*
*-- EndDefine: tx_data_fim
**************************************************
