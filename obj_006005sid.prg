* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                        *
* OBJETIVO.: Seleciona custos dos materiais                                                                                          *
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
				
				case UPPER(xmetodo) == 'USR_SEARCH_AFTER'  
					
					xalias=alias()
					
*!*						TEXT TO XSEL TEXTMERGE NOSHOW				
*!*							SELECT A.FILIAL,ISNULL(B.LOCALIZACAO,'') AS LOCALIZACAO,A.MATERIAL,C.DESC_MATERIAL ,A.COR_MATERIAL,
*!*							A.QTDE_ESTOQUE,C.UNID_ESTOQUE,C.TIPO,C.FABRICANTE,C.GRUPO
*!*							FROM ESTOQUE_MATERIAIS A
*!*							JOIN MATERIAIS_CORES B
*!*							ON A.MATERIAL = B.MATERIAL
*!*							JOIN MATERIAIS C
*!*							ON A.MATERIAL = C.MATERIAL
*!*							WHERE 1=2
*!*						ENDTEXT
*!*						
*!*						f_select(xsel,"exporta_estoque_mat",ALIAS())
					
					SELECT filial,'          ' as localizacao,material,desc_material,cor_material,qtde_estoque,unid_estoque,tipo,fabricante,grupo FROM v_estoque_materiais_02 INTO CURSOR exporta_estoque_mat readwrite

					
					SCAN
						f_select("select isnull(localizacao,'') as localizacao from materiais_cores where material =?exporta_estoque_mat.material","xtmp_localiza",ALIAS())
						
						sele exporta_estoque_mat
						replace localizacao WITH xtmp_localiza.localizacao
					
					ENDSCAN
						
					
*!*						if	!f_vazio(xalias)	
*!*							sele &xalias 
*!*						endif
*!*					
*!*					case UPPER(xmetodo) == 'USR_SEARCH_AFTER'  
*!*					
*!*					
*!*						xalias=alias()
					
					if used("curMatCustos")	
						sele curMatCustos
						use	
					endif
					
					f_select("select material,cor_material,custo_reposicao from materiais_cores","curMatCustos")
					
					update	a set a.ultimo_custo=b.custo_reposicao,a.valor_estoque=a.qtde_estoque*b.custo_reposicao from v_estoque_materiais_02 a join curMatCustos b on a.material=b.material and a.cor_material=b.cor_material   
						

*!*				
*!*						sele v_estoque_materiais_02 
*!*						go top	
*!*						scan	
*!*							f_prog_bar("Selecionando Custos Materiais...",RECNO(),RECCOUNT())
*!*							replace ultimo_custo with 
*!*						endscan	
*!*						f_prog_bar()
*!*						

					if	!f_vazio(xalias)	
						sele &xalias 
					endif		
					
	
			otherwise
				return .t.				
		endcase
	endproc
enddefine


