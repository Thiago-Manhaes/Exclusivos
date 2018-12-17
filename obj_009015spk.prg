* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  20/01/2007                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Seleção por Acompanhamento					                    *
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
				
					addnewobject(thisformset.lx_FORM1,"bt_exp_omd2015","bt_exp_omd2015")	
 				
				otherwise
				return .t.				
			endcase

	
	endproc
ENDDEFINE



***-------------- INICIO OMD 2014 ****************************


**************************************************
*-- Class:        bt_exp_omd2015 (c:\work\mv2\finaliv\bt_exp_omd.vcx)
*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   01/13/12 12:15:08 PM
*
DEFINE CLASS bt_exp_omd2015 AS botao


	Top = 25
	Left = 640
	Height = 27
	Width = 30
	FontBold = .T.
	FontSize = 8
	Caption = "OMD"
	TabIndex = 13
	p_muda_size = .F.
	Name = "bt_exp_omd"
	Visible=.t.
	Enabled=.t.


	PROCEDURE Click

		  
  
		xdata_ini='20140101'  
		xdata_fim='20141231'

		if	!f_vazio(thisformset.lx_FORM1.Data_inicial.Value)
			xdata_ini=dtos(thisformset.lx_FORM1.Data_inicial.Value)
		endif		


		if	!f_vazio(thisformset.lx_FORM1.Data_final.Value )
			xdata_fim=dtos(thisformset.lx_FORM1.Data_final.Value )
		endif	

		 

		xlabel_arq=left(xdata_ini,4)+substr(xdata_ini,5,2)+substr(xdata_ini,7,2)



		*!*		* Inicio Exportacao Lancamentos
 

		* Variaveis utilizadas na Exportacao dos Lancamentos

		local xarq,xhand,xreg,xsel	 

	
		
		*Abertura do arquivo de exportacao

		*xarq = wdir+'linx\exportacao\OM_'+xlabel_arq+'.txt'
		xarq = 'c:\temp\OM_'+xlabel_arq+'.txt'
		if empty(xarq)
			return (.f.)
		endif

		xhand = fcreate( xarq )
		
		xCabecalho='"Data";"NumeroConta";"CodigoCentroDeCusto";"NumeroNF";"Descrição";"Fornecedor";"Valor";"data_Pagamento";"Lancamento_Contabil"'
		
		fputs(xhand,left(xCabecalho,len(xCabecalho)))
		
		* Inicio Exportacao Lancamentos 


		TEXT TO	XSEL_OMD NOSHOW TEXTMERGE	
			  SELECT  	
				A.DATA_LANCAMENTO AS DATA,
				CONVERT(VARCHAR(20), ISNULL(D.VALOR_PROPRIEDADE,B.CONTA_CONTABIL) ) AS NUMEROCONTA, 
				CONVERT(VARCHAR(20), ISNULL(G.VALOR_PROPRIEDADE,A.CENTRO_CUSTO) ) AS CODIGOCENTRODECUSTO,
				RTRIM(LTRIM(ISNULL(E.NF_ENTRADA,'')))+' '+'ITEM:'+RTRIM(LTRIM(ISNULL(a.ITEM,''))) AS NUMERONF,
				ISNULL(REPLACE(F.HISTORICO,'ALESSANDRO E FREDERICO',''), ISNULL(A.HISTORICO,'')) AS DESCRICAO,
			    ISNULL(ISNULL(LTRIM(RTRIM(sol.BENEFICIARIO)), E.NOME_CLIFOR), '') AS FORNECEDOR,
				CONVERT(VARCHAR(16),sum(CONVERT(NUMERIC(14,2),A.DEBITO-A.CREDITO))) AS VALOR,
				CONVERT(VARCHAR(16),'') AS DATA_PAGAMENTO,
				CONVERT(VARCHAR(40),A.LANCAMENTO) AS LANCAMENTO_CONTABIL	
						
				FROM DBO.W_CTB_LANCAMENTO_ITEM_ABERTO (NOLOCK) A 
				JOIN CTB_CONTA_PLANO (NOLOCK) B 
				ON A.CONTA_CONTABIL = B.CONTA_CONTABIL 
				LEFT JOIN (SELECT * FROM DBO.PROP_CTB_CONTA_PLANO (NOLOCK)  WHERE PROPRIEDADE='01030') C
				ON A.CONTA_CONTABIL =C.CONTA_CONTABIL 
				LEFT JOIN (SELECT * FROM DBO.PROP_CTB_CONTA_PLANO (NOLOCK)  WHERE PROPRIEDADE='01031') D
				ON A.CONTA_CONTABIL =D.CONTA_CONTABIL 	
				LEFT JOIN (SELECT FATURA,NOME_CLIFOR,NF_ENTRADA,CTB_LANCAMENTO AS LANCAMENTO FROM DBO.ENTRADAS (NOLOCK) ) E 
				ON A.LANCAMENTO=E.LANCAMENTO
				LEFT JOIN DBO.WANM_DESCRICAO_ITEM_LANCAMENTOS_CMS (NOLOCK) F
				ON  A.LANCAMENTO=F.LANCAMENTO
				AND A.CONTA_CONTABIL=F.CONTA_CONTABIL		
				LEFT JOIN (SELECT * FROM PROP_CTB_CENTRO_CUSTO (NOLOCK) WHERE PROPRIEDADE ='01037') G
				ON A.CENTRO_CUSTO =G.CENTRO_CUSTO  	
				left join (select b.beneficiario
					, b.id_solicitacao_item
					, e.conta_contabil
					, e.lancamento
					, e.item
					--, B.* 
					from CTB_SOLICITACAO_VERBA a
						join CTB_SOLICITACAO_VERBA_ITEM b
							on a.empresa = b.empresa and a.solicitacao_verba = b.solicitacao_verba
						join CTB_SOLICITACAO_VERBA_MOV c
							on b.empresa = c.empresa and b.solicitacao_verba = c.solicitacao_verba and b.id_solicitacao_item = c.id_solicitacao_item
						join ctb_lancamento d
							on c.empresa = d.empresa and c.lancamento = d.lancamento 
						join ctb_lancamento_item e
							on d.empresa = e.empresa and d.lancamento = e.lancamento and c.item = e.item) sol
				on a.lancamento		 = sol.lancamento
				and a.conta_contabil = sol.conta_contabil
				AND a.item			 = sol.item

				WHERE A.TIPO_MOVIMENTO=1 AND A.DATA_LANCAMENTO BETWEEN '<<xdata_ini>>' AND '<<xdata_fim>>'  
							AND D.VALOR_PROPRIEDADE IS NOT NULL AND G.VALOR_PROPRIEDADE IS NOT NULL
							AND C.VALOR_PROPRIEDADE = 'SIM'
						
				group by    A.DATA_LANCAMENTO ,
							CONVERT(VARCHAR(20), ISNULL(D.VALOR_PROPRIEDADE,B.CONTA_CONTABIL) ) , 
							CONVERT(VARCHAR(20), ISNULL(G.VALOR_PROPRIEDADE,A.CENTRO_CUSTO) ),
							RTRIM(LTRIM(ISNULL(E.NF_ENTRADA,''))),
							RTRIM(LTRIM(ISNULL(a.ITEM,''))) ,
							ISNULL(REPLACE(F.HISTORICO,'ALESSANDRO E FREDERICO',''), ISNULL(A.HISTORICO,'')) ,
							ISNULL(ISNULL(LTRIM(RTRIM(sol.BENEFICIARIO)), E.NOME_CLIFOR), '') ,
							CONVERT(VARCHAR(40),A.LANCAMENTO) 	
		ENDTEXT	




		F_SELECT(XSEL_OMD,'CUR_EXP_OMD')


		sele CUR_EXP_OMD 
		go top	

		scan

			f_prog_bar(' Exportando para o Arquivo : '+upper(xarq), recno(), Reccount())
			xreg = '"'+ALLTRIM(DTOC(Data))+'";'		
			xreg = xreg + '"'+ALLTRIM(NumeroConta)+'";'		 				
			xreg = xreg + '"'+ALLTRIM(CodigoCentroDeCusto)+'";'							
			xreg = xreg + '"'+ALLTRIM(NumeroNF)+'";'							
			xreg = xreg + '"'+ALLTRIM(Descricao)+'";'						
			xreg = xreg + '"'+ALLTRIM(Fornecedor)+'";'					 
			xreg = xreg + '"'+ALLTRIM(Valor)+'";'				
			xreg = xreg + '"'+ALLTRIM(DTOC(Data))+'";'	
			xreg = xreg + '"'+ALLTRIM(LANCAMENTO_CONTABIL)+'";'							     
			
			
			fputs(xhand,left(xreg,len(xreg)-1))
			

		endscan		
				
		f_prog_bar()
	

		if xhand <= 0
			=F_msg(["Verifique direitos de gravação e atributos de somente leitura, ou se o arquivo já esta aberto.";
			,16,"Erro ao Criar o Arquivo"])
			return .f.
		endif
				
		fclose(xhand)

		go top




		***----- INICIO EXPORTACAO LANCAMENTOS SEM CONTA AGRUPAMENTO --- ***

		TEXT TO XSEL_OMDFORA NOSHOW TEXTMERGE
			SELECT 
			A.DATA_LANCAMENTO AS DATA,
			CONVERT(VARCHAR(20), ISNULL(D.VALOR_PROPRIEDADE,B.CONTA_CONTABIL) ) AS NUMEROCONTA, 
			CONVERT(VARCHAR(20), ISNULL(G.VALOR_PROPRIEDADE,A.CENTRO_CUSTO) ) AS CODIGOCENTRODECUSTO,
			RTRIM(LTRIM(ISNULL(E.NF_ENTRADA,'')))+' '+'ITEM:'+RTRIM(LTRIM(ISNULL(a.ITEM,''))) AS NUMERONF,
			ISNULL(REPLACE(F.HISTORICO,'ALESSANDRO E FREDERICO',''), ISNULL(A.HISTORICO,'')) AS DESCRICAO,
			-- Lucas, Solicitado pelo Caio --
			ISNULL(ISNULL(LTRIM(RTRIM(sol.BENEFICIARIO)), E.NOME_CLIFOR), '') AS FORNECEDOR,
			-- Fim Lucas --
			CONVERT(VARCHAR(16),CONVERT(NUMERIC(14,2),A.DEBITO-A.CREDITO)) AS VALOR,
			CONVERT(VARCHAR(16),'') AS DATA_PAGAMENTO,
			--CONVERT(VARCHAR(40),LTRIM(RTRIM(CONVERT(VARCHAR(25),A.LANCAMENTO)))+'/'+LTRIM(RTRIM(CONVERT(VARCHAR(15),A.ITEM)))) AS LANCAMENTO_CONTABIL
			CONVERT(VARCHAR(40),A.LANCAMENTO) AS LANCAMENTO_CONTABIL	
			FROM DBO.W_CTB_LANCAMENTO_ITEM_ABERTO (NOLOCK) A 
			JOIN CTB_CONTA_PLANO (NOLOCK) B 
			ON A.CONTA_CONTABIL = B.CONTA_CONTABIL 
			LEFT JOIN (SELECT * FROM DBO.PROP_CTB_CONTA_PLANO (NOLOCK)  WHERE PROPRIEDADE='01030') C
			ON A.CONTA_CONTABIL =C.CONTA_CONTABIL 
			LEFT JOIN (SELECT * FROM DBO.PROP_CTB_CONTA_PLANO (NOLOCK)  WHERE PROPRIEDADE='01031') D
			ON A.CONTA_CONTABIL =D.CONTA_CONTABIL 	
			LEFT JOIN (SELECT FATURA,NOME_CLIFOR,NF_ENTRADA,CTB_LANCAMENTO AS LANCAMENTO FROM DBO.ENTRADAS (NOLOCK) ) E 
			ON A.LANCAMENTO=E.LANCAMENTO
			LEFT JOIN DBO.WANM_DESCRICAO_ITEM_LANCAMENTOS_CMS (NOLOCK) F
			ON  A.LANCAMENTO=F.LANCAMENTO
			AND A.CONTA_CONTABIL=F.CONTA_CONTABIL		
			LEFT JOIN (SELECT * FROM PROP_CTB_CENTRO_CUSTO (NOLOCK) WHERE PROPRIEDADE ='01037') G
			ON A.CENTRO_CUSTO =G.CENTRO_CUSTO 
-- Lucas --
			left join (select b.beneficiario
				, b.id_solicitacao_item
				, e.conta_contabil
				, e.lancamento
				, e.item
				--, B.* 
				from CTB_SOLICITACAO_VERBA (NOLOCK) a
					join CTB_SOLICITACAO_VERBA_ITEM (NOLOCK) b
						on a.empresa = b.empresa and a.solicitacao_verba = b.solicitacao_verba
					join CTB_SOLICITACAO_VERBA_MOV (NOLOCK) c
						on b.empresa = c.empresa and b.solicitacao_verba = c.solicitacao_verba and b.id_solicitacao_item = c.id_solicitacao_item
					join ctb_lancamento (NOLOCK) d
						on c.empresa = d.empresa and c.lancamento = d.lancamento 
					join ctb_lancamento_item (NOLOCK) e
						on d.empresa = e.empresa and d.lancamento = e.lancamento and c.item = e.item) sol
			on a.lancamento		 = sol.lancamento
			and a.conta_contabil = sol.conta_contabil
			AND a.item			 = sol.item
-- Fim Lucas --			 		
			WHERE A.TIPO_MOVIMENTO=1 AND A.DATA_LANCAMENTO BETWEEN '<<xdata_ini>>' AND '<<xdata_fim>>' 
			AND (D.VALOR_PROPRIEDADE IS NULL OR G.VALOR_PROPRIEDADE IS NULL OR D.VALOR_PROPRIEDADE = 'NÃO')
		--	and a.matriz_contabil<>'AF BRANDS MATRIZ'				
		ENDTEXT  

		***xarq = 'c:\temp\OMD_FORA'+xlabel_arq+'.CSV'
		F_SELECT(XSEL_OMDFORA ,"CUR_OMDFORA")	
		SELECT CUR_OMDFORA
		COPY TO 'C:\temp\OMD_FORA_'+xlabel_arq xl5
		*** COPY TO &xarq  DELIMITED WITH  "" WITH CHARACTER ';'
		***----- INICIO EXPORTACAO LANCAMENTOS SEM CONTA AGRUPAMENTO --- ***






		* Fim Exportacao OM ----------------------------------------------------------------------------------------------------		



	ENDPROC


ENDDEFINE
*
*-- EndDefine: bt_exp_omd2015 
**************************************************


***-------------- FIM OMD 2015 ****************************
