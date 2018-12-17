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
			
				
				case UPPER(xmetodo) == 'USR_INIT'   
				
				xalias=alias()
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 								
				
				
				addnewobject(thisformset.lx_form1.lx_pageframe1.Pg_filtros,"bt_exporta_vendaecom","bt_exporta_vendaecom")	
				

				
				if	!f_vazio(xalias)	
					sele &xalias 
				endif		
								
				
			otherwise
				return .t.				
		endcase
	endproc
enddefine


*-- Class:        bt_exporta (c:\documents and settings\sidnei.stellet\desktop\bt_exporta\bt_exporta.vcx)
*-- ParentClass:  botao (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   12/28/09 04:01:01 PM
*
DEFINE CLASS bt_exporta_vendaecom AS botao


	Top = 280
	Left = 770
	Height = 27
	Width = 145
	FontBold = .F.
	FontSize = 8
	Caption = "\<Exportar Vendas Ecommerce"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_exporta_vendaecom"
	Visible = .t.
	Enabled =.t.


	PROCEDURE Click

if f_vazio(thisformset.lx_form1.lx_pageframe1.Pg_filtros.tx_data_venda_i.value) OR f_vazio(thisformset.lx_form1.lx_pageframe1.Pg_filtros.tx_data_venda_f.value)
	MESSAGEBOX("Favor inserir uma data !",0+48)
	RETURN .f. 
ELSE

xResp = MESSAGEBOX("Deseja Exportar ?",4+32)
f_wait("Pesquisando ... AGUARDE !")

	IF xResp = 6

		text to	xsel noshow	textmerge	
			SELECT A.CODIGO_FILIAL,B.FILIAL,A.VENDEDOR,C.NOME_VENDEDOR,C.VENDEDOR_APELIDO,D.FILIAL,A.DATA_VENDA,A.VALOR_PAGO
			FROM LOJA_VENDA A
			INNER JOIN LOJAs_VAREJO B ON A.CODIGO_FILIAL=B.CODIGO_FILIAL 
			INNER JOIN LOJA_VENDEDORES C ON A.VENDEDOR = C.VENDEDOR
			INNER JOIN LOJAS_VAREJO D ON C.CODIGO_FILIAL =D.CODIGO_FILIAL
			INNER JOIN FILIAIS E ON D.FILIAL = E.FILIAL
			WHERE A.CODIGO_FILIAL IN ('900','000901','000902','911')
			AND A.DATA_VENDA BETWEEN '<<DTOS(thisformset.lx_form1.lx_pageframe1.Pg_filtros.tx_data_venda_i.value)>>'  
			AND '<<DTOS(thisformset.lx_form1.lx_pageframe1.Pg_filtros.tx_data_venda_f.value)>>'
			AND A.VENDEDOR NOT IN ('900','901','902') AND E.REDE_LOJAS NOT IN (2,5)
			ORDER BY C.VENDEDOR_APELIDO,A.DATA_VENDA
		endtext	

		f_select(xsel,"cur_vendaecom") 	

		sele cur_vendaecom
	
	ELSE
		f_wait()
		RETURN .f.
		
endif

	f_wait()

	sele cur_vendaecom

	IF MESSAGEBOX("Exportando Entradas de Materiais Tempo, Salvar como ?",0+46)=1

		xFile = "'"+PUTFILE('','','xls')+"'"

		COPY TO &xFile XLS
		MESSAGEBOX("Exportado com Sucesso Para:"+CHR(13)+xFile,64) 
		RETURN .F.

	ENDIF
	ENDPROC

ENDDEFINE