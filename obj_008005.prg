* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  06/10/2008                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: SELECIONA MATERIAIS ESTOQUE REVISÃO						                    *
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
					
					xalias=alias()
					
					Bindevent(ThisFormSet.lx_FORM1.tx_OUTRAS_FILIAIS, "DblClick", This, "Anm_Seleciona_Revisao", 1)
					ThisFormSet.lx_FORM1.tx_OUTRAS_FILIAIS.ReadOnly=.T.

					if !f_vazio(xalias)	
						sele &xalias
					endif	
					
				
				case upper(xmetodo) == 'USR_REFRESH' 
					
					with ThisFormSet.lx_FORM1.tx_OUTRAS_FILIAIS 
						.Enabled=.t.
						.ReadOnly=.T.
					endwith	 
					
	
					
				otherwise
				return .t.				
			endcase

	endproc	
	
	
	Procedure Anm_Seleciona_Revisao

		xalias=alias()
		
		If ThisFormSet.p_Tool_Status == "P"
			
			text to xselRevisao noshow textmerge	

				select a.*,(b.qtde_entregar+a.qtde_em_revisao) as qtde_entregar_pedido 
				from 
					(select a.pedido,b.nf_entrada,
					a.material,a.cor_material,
					convert(numeric(14,2),sum(a.qtde)) as qtde_em_revisao,
					convert(numeric(15,5),(sum(a.valor)/sum(a.qtde))) as custo_materia_prima,
					convert(numeric(14,2),sum(a.valor)) as valor,
					c.anm_status_entrada 
					from estoque_ret1_mat a 
					join estoque_ret_mat b 
					on a.req_material=b.req_material 
					and a.filial=b.filial
					join entradas c 
					on b.nf_entrada=c.nf_entrada 
					and b.nome_clifor=c.nome_clifor 
					and b.serie_nf_entrada=c.serie_nf_entrada  
					where 
					c.anm_status_entrada in 
						(select convert(varchar(25),valor_propriedade) as anm_status_entrada 
						from propriedade_valida 
						where propriedade='00054' 
						and valor_propriedade <>'4-FINALIZADO')
					and a.material='<<v_materiais_02.material>>' 
					and a.cor_material='<<v_materiais_02.cor_material>>'
					group by a.pedido,b.nf_entrada,b.nome_clifor,a.material,
				a.cor_material,c.anm_status_entrada ) a
				join 
					(select pedido,material,cor_material,
					sum(qtde_entregar) as qtde_entregar 
					from compras_material  
					group by pedido,material,cor_material) b 
				on  a.pedido=b.pedido
				and a.material=b.material
				and a.cor_material=b.cor_material 

			endtext

			f_select(xselRevisao,"curMatRevisao")
			
			sele curMatRevisao 
			browse normal noedit title  'Materiais em Revisão por Pedido - Tecle Esc p/ Sair' in screen	
			
		Endif

		if !f_vazio(xalias)	
			sele &xalias
		endif	
					


	Endproc

	
	
ENDDEFINE	



