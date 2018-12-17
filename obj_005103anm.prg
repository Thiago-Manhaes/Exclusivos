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
		
		
			case UPPER(xmetodo) == 'USR_VALID'
			
			
				xalias=alias()
											
					sele v_entradas_00	
	         		thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.Tv_RATEIO_FILIAL.Value = THISFORMSET.lx_FORM1.Tx_CliFor1.VALUE	
					f_select("select desc_rateio_filial from CTB_FILIAL_RATEIO where rateio_filial=?v_entradas_00.rateio_filial","curRATEIO",alias())
					thisformset.lx_FORM1.lx_PAGEFRAME1.Page1.Pageframe1.Page1.tx_desc_filial_rateio.Value = curRATEIO.desc_rateio_filial
		
					IF THISFORMSET.p_tool_status = 'I' AND upper(xnome_obj)=='TX_NF_ENTRADA'
						
							thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE = RIGHT(STR(VAL(thisformset.lx_FORM1.TX_NF_ENTRADA.VALUE)+10000000),7)
						
					ENDIF
					
				if	!f_vazio(xalias)	
					sele &xalias 
				endif
			
			
				
			case UPPER(xmetodo) == 'USR_SAVE_BEFORE' 
				
				xalias=alias()
				
					sele v_entradas_00
					replace filial_cobranca WITH v_entradas_00.filial
				
				text to	xupdt noshow	
					insert into prop_entradas  
					(PROPRIEDADE,ITEM_PROPRIEDADE,VALOR_PROPRIEDADE,NF_ENTRADA,SERIE_NF_ENTRADA,NOME_CLIFOR)  
					select  
					'00014',1,b.valor_propriedade,a.nf_entrada, a.serie_nf_entrada,a.nome_clifor  
					from  
					(select top 1 a.pedido,a.nome_clifor,a.nf_entrada,a.serie_nf_entrada   
					from entradas_material a  
					where a.nome_clifor    = ?v_entradas_00.nome_clifor   
					and a.nf_entrada       = ?v_entradas_00.nf_entrada   
					and a.serie_nf_entrada = ?v_entradas_00.serie_nf_entrada) a   
					join prop_compras b  
					on a.pedido=b.pedido 
					left join prop_entradas c  
					on  a.nome_clifor      = c.nome_clifor 
					and a.nf_entrada       = c.nf_entrada  
					and a.serie_nf_entrada = c.serie_nf_entrada  
					where c.nome_clifor is null  
				endtext		
				
				if !f_update(xupdt) 
					messagebox("Não foi possível Inserir Propriedade")	
				endif		
					

				if	!f_vazio(xalias)	
					sele &xalias 
				endif	 
			
			
		
		
			case UPPER(xmetodo) == 'USR_SAVE_AFTER' 
				
				xalias=alias()

	
					sele v_compras_01_materiais
					GO top 
					SCAN
						TEXT TO xUpdtTab TEXTMERGE NOSHOW

							INSERT INTO ANM_ENT_COMPRAS_DEPOSITO
							(PEDIDO,NOME_CLIFOR,NF_ENTRADA,SERIE_NF_ENTRADA,MATERIAL,COR_MATERIAL,DATA_ENTRADA,USUARIO)
							VALUES
							('<<v_compras_01_materiais.pedido>>'  ,'<<v_entradas_00.nome_clifor>>'          ,
							 '<<v_entradas_00.nf_entrada>>'       ,'<<v_entradas_00.serie_nf_entrada>>'     ,
							 '<<v_compras_01_materiais.material>>','<<v_compras_01_materiais.cor_material>>',
							 '<<v_entradas_00.data_digitacao>>'   ,'<<wusuario>>'                           )

						ENDTEXT

					f_update(xUpdtTab)
					sele v_compras_01_materiais 
					ENDSCAN

				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif	
	
			otherwise
				return .t.				
		endcase
	endproc
enddefine


