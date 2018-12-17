* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Ajuste layout propriedades clientes varejo		/ tel celular			                    *
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
					
					xalias=ALIAS()
						
						xVersao = '01.1'
						f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
						f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
						WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
						
						With Thisformset.lx_FORM1
							.txtClienteVarejo.p_valida_coluna = ''
							.txtClienteVarejo.p_valida_coluna_tabela = ''
							.txtClienteVarejo.p_valida_nao_existencia = .f.
							.lx_pageframe1.page1.ChkTipoPessoa.Value = .t.
							.lx_pageframe1.page1.ChkTipoPessoa.valid()
							.addobject("cmb_desc_rede_loja","cmb_desc_rede_loja")	
							.cmb_desc_rede_loja.Visible = .t.
							.addobject("cmb_rede_loja","cmb_rede_loja")	
							.cmb_rede_loja.Visible = .t.
							.lx_pageframe1.page1.addobject("bt_importa_cartao","bt_importa_cartao")	
							.lx_pageframe1.page1.bt_importa_cartao.Visible = .t.
							.lx_pageframe1.page1.bt_importa_cartao.Enabled = Thisformset.pp_anm_importa_cartao_client
						EndWith
					
					
					
					
					if !f_vazio(xalias)					
						sele &xalias 
					endif	
					
					
				case upper(xmetodo) == 'USR_VALID' 
					
					xalias=ALIAS()
					
						If upper(xnome_obj)='TXTCPFCGC'

							if Thisformset.p_tool_status = "I"
								
								TEXT TO xSelCli TEXTMERGE NOSHOW
									SELECT TOP 1 CLIENTE_VAREJO,
										CONCEITO,PONTUALIDADE,TIPO_BLOQUEIO,ENDERECO,RG_IE,CIDADE ,COMPLEMENTO,CEP ,TELEFONE ,FAX  ,
										ANIVERSARIO  ,SEM_CREDITO  ,DDD  ,SEXO  ,ESTADO_CIVIL ,TIPO_TELEFONE,UF ,EMAIL ,BAIRRO ,
										NAO_CONSULTA_CHEQUE,OBS,NUMERO ,PAIS ,TIPO_LOGRADOURO ,DDD_CELULAR,CELULAR
									FROM ANM_CLIENTES_VAREJO_DETALHE
									WHERE CPF_CGC = '<<V_CLIENTES_VAREJO_00.CPF_CGC>>'
									ORDER BY DATA_PARA_TRANSFERENCIA DESC
								ENDTEXT
								f_select(xSelCli,"CurRecuperaCadastro")
								
								If RECCOUNT()=0

									TEXT TO xSelCli TEXTMERGE NOSHOW
										SELECT TOP 1 CLIENTE_VAREJO,
											CONCEITO,PONTUALIDADE,TIPO_BLOQUEIO,ENDERECO,RG_IE,CIDADE ,COMPLEMENTO,CEP ,TELEFONE ,FAX  ,
											ANIVERSARIO  ,SEM_CREDITO  ,DDD  ,SEXO  ,ESTADO_CIVIL ,TIPO_TELEFONE,UF ,EMAIL ,BAIRRO ,
											NAO_CONSULTA_CHEQUE,OBS,NUMERO ,PAIS ,TIPO_LOGRADOURO ,DDD_CELULAR,CELULAR
										FROM CLIENTES_VAREJO
										WHERE CPF_CGC = '<<V_CLIENTES_VAREJO_00.CPF_CGC>>'
										ORDER BY DATA_PARA_TRANSFERENCIA DESC
									ENDTEXT
									f_select(xSelCli,"CurRecuperaCadastro")	
								Endif
								
								Sele V_CLIENTES_VAREJO_00
								Replace CLIENTE_VAREJO      WITH CurRecuperaCadastro.CLIENTE_VAREJO;
										CONCEITO 			WITH CurRecuperaCadastro.CONCEITO;
										PONTUALIDADE 		WITH CurRecuperaCadastro.PONTUALIDADE;
										TIPO_BLOQUEIO 		WITH CurRecuperaCadastro.TIPO_BLOQUEIO;
										ENDERECO 			WITH CurRecuperaCadastro.ENDERECO;
										RG_IE 				WITH CurRecuperaCadastro.RG_IE;
										CIDADE 				WITH CurRecuperaCadastro.CIDADE;
										COMPLEMENTO 		WITH CurRecuperaCadastro.COMPLEMENTO;
										CEP 				WITH CurRecuperaCadastro.CEP;
										TELEFONE 			WITH CurRecuperaCadastro.TELEFONE;
										FAX 				WITH CurRecuperaCadastro.FAX;
										ANIVERSARIO 		WITH CurRecuperaCadastro.ANIVERSARIO;
										SEM_CREDITO 		WITH CurRecuperaCadastro.SEM_CREDITO;
										DDD 				WITH CurRecuperaCadastro.DDD;
										SEXO 				WITH CurRecuperaCadastro.SEXO;
										ESTADO_CIVIL 		WITH CurRecuperaCadastro.ESTADO_CIVIL;
										TIPO_TELEFONE 		WITH CurRecuperaCadastro.TIPO_TELEFONE;
										UF 					WITH CurRecuperaCadastro.UF;
										EMAIL 				WITH CurRecuperaCadastro.EMAIL;
										BAIRRO 				WITH CurRecuperaCadastro.BAIRRO;
										NAO_CONSULTA_CHEQUE WITH CurRecuperaCadastro.NAO_CONSULTA_CHEQUE;
										OBS 				WITH CurRecuperaCadastro.OBS;
										NUMERO 				WITH CurRecuperaCadastro.NUMERO;
										PAIS 				WITH CurRecuperaCadastro.PAIS;
										TIPO_LOGRADOURO 	WITH CurRecuperaCadastro.TIPO_LOGRADOURO;
										DDD_CELULAR 		WITH CurRecuperaCadastro.DDD_CELULAR;
										CELULAR  			WITH CurRecuperaCadastro.CELULAR 
								
								RELEASE xSelCli
								Use in CurRecuperaCadastro
								
								Thisformset.l_refresh()

							endif
						Endif	
					
					if !f_vazio(xalias)					
						sele &xalias 
					endif	
	
								
	
				case UPPER(xmetodo) == 'USR_SAVE_AFTER' 	 &&22/10/2015 - BRUNO SILVA (SS) : Atualiza a tabela ANM_CLIENTES_VAREJO_DETALHE
					
					if Thisformset.p_tool_status = "A"
					
						TEXT TO cSqL TEXTMERGE
							UPDATE ANM_CLIENTES_VAREJO_DETALHE 
								SET CONCEITO = ?V_CLIENTES_VAREJO_00.CONCEITO,
									PONTUALIDADE = ?V_CLIENTES_VAREJO_00.PONTUALIDADE,
									TIPO_BLOQUEIO = ?V_CLIENTES_VAREJO_00.TIPO_BLOQUEIO,
									ENDERECO = ?V_CLIENTES_VAREJO_00.ENDERECO,
									RG_IE = ?V_CLIENTES_VAREJO_00.RG_IE,
									CIDADE = ?V_CLIENTES_VAREJO_00.CIDADE,
									COMPLEMENTO = ?V_CLIENTES_VAREJO_00.COMPLEMENTO,
									CEP = ?V_CLIENTES_VAREJO_00.CEP,
									TELEFONE = ?V_CLIENTES_VAREJO_00.TELEFONE,
									FAX = ?V_CLIENTES_VAREJO_00.FAX,
									ANIVERSARIO = ?V_CLIENTES_VAREJO_00.ANIVERSARIO,
									SEM_CREDITO = ?V_CLIENTES_VAREJO_00.SEM_CREDITO,
									DDD = ?V_CLIENTES_VAREJO_00.DDD,
									SEXO = ?V_CLIENTES_VAREJO_00.SEXO,
									ESTADO_CIVIL = ?V_CLIENTES_VAREJO_00.ESTADO_CIVIL,
									TIPO_TELEFONE = ?V_CLIENTES_VAREJO_00.TIPO_TELEFONE,
									UF = ?V_CLIENTES_VAREJO_00.UF,
									EMAIL = ?V_CLIENTES_VAREJO_00.EMAIL,
									BAIRRO = ?V_CLIENTES_VAREJO_00.BAIRRO,
									NAO_CONSULTA_CHEQUE = ?V_CLIENTES_VAREJO_00.NAO_CONSULTA_CHEQUE,
									OBS = ?V_CLIENTES_VAREJO_00.OBS,
									NUMERO = ?V_CLIENTES_VAREJO_00.NUMERO,
									PAIS = ?V_CLIENTES_VAREJO_00.PAIS,
									TIPO_LOGRADOURO = ?V_CLIENTES_VAREJO_00.TIPO_LOGRADOURO,
									DDD_CELULAR = ?V_CLIENTES_VAREJO_00.DDD_CELULAR,
									CELULAR  = ?V_CLIENTES_VAREJO_00.CELULAR
							WHERE CODIGO_CLIENTE = ?V_CLIENTES_VAREJO_00.CODIGO_CLIENTE
						ENDTEXT
						
						IF !F_UPDATE (cSql)
							MESSAGEBOX("Não foi possivel alterar a tabela detalhe de clientes!",0+64,"Atenção")					
						endif
					
					endif					
																
				otherwise
				return .t.				
			endcase
	
	endproc
ENDDEFINE

**************************************************
*-- Class:        cmb_desc_rede_loja (c:\users\julio.cesar\desktop\cmb_desc_rede_loja.vcx)
*-- ParentClass:  lx_combobox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   04/04/16 12:23:07 PM
*
DEFINE CLASS cmb_desc_rede_loja AS lx_combobox


	ControlSource = "V_CLIENTES_VAREJO_00.DESC_REDE_LOJAS"
	Height = 21
	Left = 566
	Top = 31
	Width = 105
	Name = "cmb_desc_rede_loja"


	PROCEDURE Init
		DODEFAULT()
		
		f_select("SELECT '' REDE_LOJAS, '' DESC_REDE_LOJAS UNION ALL "+;
				 "SELECT DISTINCT a.REDE_LOJAS,b.DESC_REDE_LOJAS FROM W_FILIAIS a join LOJAS_REDE b on a.REDE_LOJAS = b.REDE_LOJAS "+;
				 "join WANM_PROP_REDES_USERS c on a.REDE_LOJAS = c.REDE_LOJAS WHERE TIPO_FILIAL = 'LOJA VAREJO' AND a.INATIVO = 0 AND c.lx_system_user = system_user "+;
				 " Order by REDE_LOJAS ","Cur_rede_lojas",ALIAS())
		this.RowSource = "Cur_rede_lojas.DESC_REDE_LOJAS"
		this.Refresh()
	ENDPROC


	PROCEDURE Valid
		DODEFAULT()

		thisform.Cmb_rede_loja.Value = Cur_rede_lojas.REDE_LOJAS
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmb_desc_rede_loja
**************************************************

**************************************************
*-- Class:        cmb_rede_loja (c:\users\julio.cesar\desktop\cmb_rede_loja.vcx)
*-- ParentClass:  lx_combobox (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    combobox
*-- Time Stamp:   04/04/16 12:23:03 PM
*
DEFINE CLASS cmb_rede_loja AS lx_combobox


	ControlSource = "V_CLIENTES_VAREJO_00.REDE_LOJAS"
	Height = 21
	Left = 516
	Top = 31
	Width = 48
	Name = "cmb_rede_loja"


	PROCEDURE Valid
		DODEFAULT()

		thisform.cmb_desc_rede_loja.Value = cur_rede_lojas.DESC_REDE_LOJAS
	ENDPROC


	PROCEDURE Init
		DODEFAULT()

		this.RowSource = "Cur_rede_lojas.REDE_LOJAS"
		this.Refresh()
	ENDPROC


ENDDEFINE
*
*-- EndDefine: cmb_rede_loja
**************************************************

**************************************************
*-- Class Library:  c:\users\julio.cesar\desktop\bt_importa_cartao.vcx
**************************************************


**************************************************
*-- Class:        bt_importa_cartao (c:\users\julio.cesar\desktop\bt_importa_cartao.vcx)
*-- ParentClass:  botao (c:\program files (x86)\common files\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   04/05/16 01:48:14 PM
*
DEFINE CLASS bt_importa_cartao AS botao


	Top = 2
	Left = 455
	Height = 23
	Width = 91
	Caption = "Importar Cartão"
	Name = "bt_importa_codigo_cartao"


	PROCEDURE Click
				If f_vazio(v_clientes_varejo_00.rede_lojas)
					MESSAGEBOX("Rede de Loja não informada, Favor selecionar uma!",64)
					Thisformset.lx_FORM1.cmb_desc_rede_loja.SetFocus()
					RETURN .f.
				Endif


				strcaminho = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")

				if empty(NVL(strcaminho,''))
					messagebox("Operação Cancelada!",0+64,"Arquivo Inválido!")
					return .f.
				endif

				F_wait("Importando as informações, Aguarde...")

				if used("CUR_IMPORT")
					use in CUR_IMPORT
				endif

				CREATE CURSOR CUR_IMPORT(CPF C(14), NUMERO_CARTAO C(16),TIPO_CLIENTE C(25))


				try
					objxls 			= createobject("excel.application")
					objworkbook 	= objxls.workbooks.open(strcaminho)
					objsheet 		= objworkbook.sheets(1)
					iRowsSheet 		= objsheet.Rows.Count
					iPermitido 	    = 65000
					iImatrizIni		= 2 
					iImatrizFim		= iPermitido 
					iPercorrido     = 1 

					IF (MOD(iRowsSheet , iPermitido ) > 0 )
						iPercorrer = (ROUND(iRowsSheet/iPermitido,0))+1
					ELSE 
						iPercorrer = (iRowsSheet/iPermitido)
					ENDIF

					IF upper(alltrim(objsheet.cells(1,1).text)) <> "CPF" OR upper(alltrim(objsheet.cells(1,2).text))<> "NUMERO_CARTAO" OR upper(alltrim(objsheet.cells(1,3).text))<> "TIPO_CLIENTE"
						MESSAGEBOX("O Layout do Arquivo é Inválido, O Cabeçalho deve Conter as Seguintes Informações:"+CHR(10)+"CPF Célula A"+CHR(10)+"Numero_Cartao Célula B"+CHR(10)+"Tipo_cliente Célula C",0+16,"Obj - Layout Inválido")
						GO to oexception
					ENDIF

					IF f_vazio(alltrim(objsheet.cells(iPermitido,1).text)) 
						objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,5)).value
						SELECT CUR_IMPORT
						APPEND FROM array objsheetRange   
					ELSE 
						DO WHILE iPercorrer >= iPercorrido      

							objsheetRange   = objsheet.range(objsheet.cells(iImatrizIni,1),objsheet.cells(iImatrizFim,5)).value

							SELECT CUR_IMPORT
							APPEND FROM array objsheetRange

							iPercorrido = iPercorrido + 1
							iImatrizIni = IIF(iImatrizIni==2,1 + iPermitido,iImatrizIni + iPermitido)
							iImatrizFim = IIF((iImatrizFim + iPermitido) < iRowsSheet, iImatrizFim + iPermitido, iRowsSheet )
						ENDDO

					ENDIF


					objworkbook.close()
					release objsheet
					release objworkbook
					release objxls 


				catch to oexception

					objworkbook.close()
					release objsheet
					release objworkbook
					release objxls 
				ENDTRY


				if type("oexception") = "O"
					f_wait()
					return.f.
				ENDIF
			
			f_wait()
			
			CurCartaoNaoImportado = ""
			xCartaoNaoImportado = 0
			xGetDate = DTOS(DATE())
			xCountReg = 0
			xTRit = 0
		
			SELECT cur_import
			DELETE FROM cur_import WHERE f_vazio(cpf)
			
			
			TEXT to lcSql TEXTMERGE NOSHOW
				
				IF (SELECT OBJECT_ID('TEMPDB..#CTB_IMPORTA_CARTAO_CLIENTE')) IS NOT NULL
					DROP TABLE #CTB_IMPORTA_CARTAO_CLIENTE

				CREATE TABLE #CTB_IMPORTA_CARTAO_CLIENTE (
						CPF 			VARCHAR(14) COLLATE DATABASE_DEFAULT, 
						NUMERO_CARTAO 	VARCHAR(16) COLLATE DATABASE_DEFAULT,
						TIPO_CLIENTE 	VARCHAR(25) COLLATE DATABASE_DEFAULT
						)

			ENDTEXT 

				If !f_Execute(lcSql)
					Messagebox.Show("Erro na verificação de tabelas temporárias." + Message(), 64, "Atenção")
					Return .F.
				Endif
			

			SELECT cur_import
			Count to xTReg
			GO top
			SCAN
				
				xTRit = xTRit + 1
				F_PROG_BAR("Aguarde, Importando arquivo ..."+ALLTRIM(STR(xTRit))+" de "+ALLTRIM(STR(xTReg))+;
				            CHR(13)+ALLTRIM(STR((xTRit/xTReg)*100))+"% Concluido",xTRit,xTReg)	
				
				TEXT TO xInsert TEXTMERGE NOSHOW
				
					INSERT INTO #CTB_IMPORTA_CARTAO_CLIENTE
					SELECT '<<cur_import.CPF>>','<<cur_import.numero_cartao>>','<<cur_import.TIPO_CLIENTE>>'
				
				ENDTEXT
				
				f_execute(xInsert)

				SELECT cur_import
			endscan

			F_PROG_BAR()		

			
			F_wait("Atualizando Registros, Aguarde...")
			
			xProcCli = "Exec LX_ANM_ATUALIZA_CARTAO_AFINIDADE "+ALLTRIM(v_clientes_varejo_00.rede_lojas)+",'"+ALLTRIM(strcaminho)+"'"
			IF f_execute(xProcCli)
				F_wait()
				MESSAGEBOX(" clientes importados com sucesso!",64)
			else	
				F_wait()
				MESSAGEBOX("clientes não importados!",64)
				RETURN .f.
			endif
			
			
			Thisformset.p_pai_filtro_query = Thisformset.p_pai_filtro_query +; 
			IIF(!f_vazio(Thisformset.p_pai_filtro_query)," And "," ")+;
			" DATA_IMPORT_CARTAO_AFINIDADE = '"+xGetDate+"' And "+;
			" ARQUIVO_IMPORT_CARTAO_AFINIDADE = '"+ALLTRIM(strcaminho)+"' "

			o_toolbar.Botao_procura.Click()

			Thisformset.p_clausula_where= ""
			Thisformset.p_comando_where= ""
			Thisformset.p_pai_filtro_query = ""

			SELECT a.* FROM cur_import a LEFT JOIN v_clientes_varejo_00 b ON a.cpf = b.CPF_CGC;
			where b.CPF_CGC is null INTO CURSOR cur_not_import

			IF RECCOUNT()>0
				IF MESSAGEBOX("Alguns clientes não foram importados, deseja exportar para Excel?",32+4)=6
					xSetFile = "'"+PUTFILE("Salvar como","","xls")+"'"
					COPY TO &xSetFile xls
				ENDIF

				USE IN cur_not_import
			ENDIF
	ENDPROC
ENDDEFINE
*
*-- EndDefine: bt_importa_cartao
**************************************************
