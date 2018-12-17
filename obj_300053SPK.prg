* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  22/07/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Consulta cupom origem troca				                    *
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
				
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
				
				*Inicio Inclusao Campos Novos de Produtos no Cursor Pai -- v_loja_venda_troca_01 
				sele v_loja_venda_troca_01 
				xalias_pai=alias()

				
  				oCur = getcursoradapter(xalias_pai)
				oCur.addbufferfield("CONVERT(VARCHAR(8),'')  AS ANM_NUMERO_CUPOM_FISCAL", "C(8)",.F., "ANM_NUMERO_CUPOM_FISCAL", "")				
				oCur.addbufferfield("CONVERT(VARCHAR(14),'')  AS ANM_CPF_CLIENTE", "C(14)",.F., "ANM_CPF_CLIENTE", "")	
				oCur.addbufferfield("CONVERT(VARCHAR(90),'')  AS ANM_END_CLIENTE", "C(90)",.F., "ANM_END_CLIENTE", "")					
				oCur.addbufferfield("CONVERT(VARCHAR(35),'')  AS ANM_CIDADE_CLIENTE", "C(35)",.F., "ANM_CIDADE_CLIENTE", "")					
				oCur.addbufferfield("CONVERT(VARCHAR(35),'')  AS ANM_BAIRRO_CLIENTE", "C(35)",.F., "ANM_BAIRRO_CLIENTE", "")				
				oCur.addbufferfield("CONVERT(VARCHAR(9),'')  AS ANM_CEP_CLIENTE", "C(9)",.F., "ANM_CEP_CLIENTE", "")				
				oCur.addbufferfield("CONVERT(VARCHAR(2),'')  AS ANM_UF_CLIENTE", "C(2)",.F., "ANM_UF_CLIENTE", "")				
				oCur.confirmstructurechanges() 	
				**-Fim Inclusao Campos Novos de Tickets no Cursor Pai 		
				
			
				if !f_vazio(xalias)
					sele &xalias
				endif	

				Thisformset.L_limpa()	
			
			
				
				case upper(xmetodo) == 'USR_SEARCH_AFTER'

					SELECT v_loja_venda_troca_01 
					GO top
					
					SCAN 
					
						f_prog_bar("Selecionando Cupons Origem...",RECNO(),RECCOUNT())
						
						TEXT TO xsel NOSHOW TEXTMERGE 
							
							select A.CODIGO_CLIENTE,d.numero_cupom_fiscal from loja_venda a 
							join loja_venda_produto b 
							on  a.ticket=b.ticket 
							and a.data_venda=b.data_venda  
							and a.codigo_filial=b.codigo_filial 
							join	(select distinct a.codigo_cliente,b.produto from loja_venda a 
									join loja_venda_troca b 
									on  a.ticket=b.ticket 
									and a.data_venda=b.data_venda  
									and a.codigo_filial=b.codigo_filial 
									where a.ticket='<<v_loja_venda_troca_01.TICKET>>' 
									and a.codigo_filial='<<v_loja_venda_troca_01.CODIGO_FILIAL>>'  
									and a.data_venda='<<v_loja_venda_troca_01.DATA_VENDA>>') c 
							on a.codigo_cliente=c.codigo_cliente 
							and b.produto=c.produto
							join loja_venda_pgto d
							on  a.codigo_filial=d.codigo_filial 
							and a.terminal=d.terminal 
							and a.lancamento_caixa=d.lancamento_caixa 

							
						ENDTEXT  
					
						F_SELECT(XSEL,'CURTROCAS',ALIAS())	
						
						SELECT v_loja_venda_troca_01  
						REPLACE ANM_NUMERO_CUPOM_FISCAL WITH CURTROCAS.numero_cupom_fiscal
						REPLACE ANM_CPF_CLIENTE         WITH CURTROCAS.CODIGO_CLIENTE 						
					
					ENDSCAN 
					f_prog_bar()
					
					GO TOP 



					
					SELECT v_loja_venda_troca_01 
					GO top
					
					SCAN FOR ISNULL(ANM_NUMERO_CUPOM_FISCAL)
					
						f_prog_bar("Selecionando Cupons Origem !...",RECNO(),RECCOUNT())
						TEXT TO xsel NOSHOW TEXTMERGE 
							
							select top 1 A.CODIGO_CLIENTE,d.numero_cupom_fiscal,e.* 
							from loja_venda a 
							join loja_venda_produto b 
							on  a.ticket=b.ticket 
							and a.data_venda=b.data_venda  
							and a.codigo_filial=b.codigo_filial 
							join loja_venda_pgto d
							on  a.codigo_filial=d.codigo_filial 
							and a.terminal=d.terminal 
							and a.lancamento_caixa=d.lancamento_caixa 
							join clientes_varejo e 
							on a.codigo_cliente=e.codigo_cliente 
							where b.preco_liquido = 
							(select top 1 b.preco_liquido from loja_venda a 
									join loja_venda_troca b 
									on  a.ticket=b.ticket 
									and a.data_venda=b.data_venda  
									and a.codigo_filial=b.codigo_filial 
									where a.ticket='<<v_loja_venda_troca_01.TICKET>>' 
									and a.codigo_filial='<<v_loja_venda_troca_01.CODIGO_FILIAL>>'  
									and a.data_venda='<<v_loja_venda_troca_01.DATA_VENDA>>'
									and b.produto='<<v_loja_venda_troca_01.produto>>'
									and b.cor_produto='<<v_loja_venda_troca_01.cor_produto>>') 
							and d.numero_cupom_fiscal is not null 		
							order by a.data_venda desc 		

							
						ENDTEXT  
					
						F_SELECT(XSEL,'CURTROCAS',ALIAS())	
						
						SELECT v_loja_venda_troca_01  
						REPLACE ANM_NUMERO_CUPOM_FISCAL WITH CURTROCAS.numero_cupom_fiscal
						REPLACE ANM_CPF_CLIENTE         WITH CURTROCAS.CODIGO_CLIENTE 						
						REPLACE ANM_END_CLIENTE         WITH CURTROCAS.ENDERECO							
						REPLACE ANM_CIDADE_CLIENTE      WITH CURTROCAS.CIDADE									
						REPLACE ANM_BAIRRO_CLIENTE      WITH CURTROCAS.BAIRRO						
						REPLACE ANM_CEP_CLIENTE		    WITH CURTROCAS.CEP					
						REPLACE ANM_UF_CLIENTE		    WITH CURTROCAS.UF						
					
					ENDSCAN 
					f_prog_bar()
					
					GO TOP 



																
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE