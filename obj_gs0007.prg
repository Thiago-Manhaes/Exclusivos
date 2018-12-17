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
							.addobject("btn_importa_limite","btn_importa_limite")	
							.btn_importa_limite.Visible = .t.
						EndWith
					
				case upper(xmetodo) == 'USR_REFRESH' 
					
					xalias=ALIAS()
						If type('Thisformset.lx_form1.btn_importa_limite')<>'U'
							If Thisformset.p_tool_status <> 'L'
								Thisformset.lx_form1.btn_importa_limite.Enabled = .F.
								Thisformset.lx_form1.Lx_ckbox_atualiza_tabela.Enabled = .F.
							Else
								Thisformset.lx_form1.btn_importa_limite.Enabled = .t.	
								Thisformset.lx_form1.Lx_ckbox_atualiza_tabela.Enabled = .T.
							ENDIF
						Endif
					
					
					if !f_vazio(xalias)					
						sele &xalias 
					endif	
					
			
																
				otherwise
				return .t.				
			endcase
	
	endproc
ENDDEFINE


**************************************************
*-- Class:        btn_importa_limite (c:\users\lucas.miranda\desktop\projetos\desenvolvimento\2016\atacado\limite de crédito\btn_importa_limite.vcx)
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   09/14/16 03:01:08 PM
*
DEFINE CLASS btn_importa_limite AS commandbutton

 
	Top = 22
	Left = 32
	Height = 25
	Width = 105
	Caption = "Importar Limite"
	Name = "btn_importa_limite"
	
	PROCEDURE Click
		strcaminho = getfile("xls?","Importar Arquivo","Importar",0,"Importar Arquivo")

					if empty(NVL(strcaminho,''))
						messagebox("Operação Cancelada!",0+64,"Arquivo Inválido!")
						return .f.
					endif

					F_wait("Importando as informações, Aguarde...")

					if used("CUR_IMPORT")
						use in CUR_IMPORT
					endif

					CREATE CURSOR CUR_IMPORT(REDE_LOJAS C(6), COLECAO C(6),COD_CLIENTE C(6), LIMITE N(14,2))

 
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

						IF upper(alltrim(objsheet.cells(1,1).text)) <> "REDE_LOJAS" OR upper(alltrim(objsheet.cells(1,2).text))<> "COLECAO" OR upper(alltrim(objsheet.cells(1,3).text))<> "COD_CLIENTE" OR upper(alltrim(objsheet.cells(1,4).text))<> "LIMITE"
							MESSAGEBOX("O Layout do Arquivo é Inválido, O Cabeçalho deve Conter as Seguintes Informações:"+CHR(10)+"REDE_LOJAS Célula A"+CHR(10)+"COLECAO Célula B"+CHR(10)+"COD_CLIENTE Célula C"+CHR(10)+"LIMITE Célula D",0+16,"Obj - Layout Inválido")
							return .f.
							*GO to oexception
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
				xMsgErro = ''
				
				SELECT cur_import
				DELETE FROM cur_import WHERE f_vazio(rede_lojas)
				
				
				F_wait("Validando informações, Aguarde...")
				
				select distinct ALLTRIM(UPPER(cod_cliente)) as cod_cliente from cur_import into CURSOR xCod_VerCliente
				Sele xCod_VerCliente			
				
				f_select("select LTRIM(RTRIM(UPPER(cod_cliente))) as cod_cliente from clientes_atacado (nolock)","xTabCliente")
				Select * FROM xCod_VerCliente a ;
				left join xTabCliente b ;
				on a.cod_cliente = b.cod_cliente where b.cod_cliente is null ;
				into cursor xNExisteCliente
				
				Sele xNExisteCliente
				If RECCOUNT()>0
					xMsgErro = xMsgErro + "Existe(m) cliente(s) no arquivo não cadastrado na Tabela Cliente Atacado"
					Sele xNExisteCliente
					COPY TO c:\temp\ERRO_COD_CLIENTE XLS
					*MESSAGEBOX("Existe cliente no arquivo não cadastrado na Tabela Cliente Atacado"+CHR(13)+"Favor Verificar !!!",0+16,"Cliente Atacado")
					release xNExisteCliente
					*Return .F.
				Endif
				 
				select distinct ALLTRIM(UPPER(colecao)) as colecao from cur_import into CURSOR xCod_VerColecao
				Sele xCod_VerColecao			
				
				f_select("select LTRIM(RTRIM(UPPER(colecao))) as colecao from colecoes (nolock)","xTabColecao")
				Select * FROM xCod_VerColecao a ;
				left join xTabColecao b ;
				on a.colecao = b.colecao where b.colecao is null ;
				into cursor xNExisteColecao
				
				Sele xNExisteColecao
				If RECCOUNT()>0
					
					xMsgErro = xMsgErro + CHR(13)+"Existe(m) colecao(ões) no arquivo não cadastrado na Tabela Coleções"
					Sele xNExisteColecao
					COPY TO c:\temp\ERRO_COLECAO XLS
					*MESSAGEBOX("Existe colecao no arquivo não cadastrado na Tabela Coleções"+CHR(13)+"Favor Verificar !!!",0+16,"Cliente Atacado")
					release xNExisteColecao
					*Return .F.
				Endif
				
				select distinct ALLTRIM(rede_lojas) as rede_lojas from cur_import into CURSOR xCod_VerRede
				Sele xCod_VerRede			

				f_select("select distinct left(LTRIM(RTRIM(rede_lojas)),1) as rede_lojas from lojas_rede (nolock)","xTabRede")
				sele xTabRede
				
				Select * FROM xCod_VerRede a ;
				left join xTabRede b ;
				on VAL(a.rede_lojas) = VAL(b.rede_lojas) where b.rede_lojas is null ;
				into cursor xNExisteRede
				
				Sele xNExisteRede
				If RECCOUNT()>0
					xMsgErro = xMsgErro + CHR(13)+ "Existe(m) Rede_Lojas no arquivo não cadastrado na Tabela Rede_Lojas"
					Sele xNExisteRede
					COPY TO c:\temp\ERRO_REDE_LOJA XLS
					*MESSAGEBOX("Existe Rede_Lojas no arquivo não cadastrado na Tabela Rede_Lojas"+CHR(13)+"Favor Verificar !!!",0+16,"Cliente Atacado")
					release xNExisteRede
					*Return .F.
				Endif			
				
				IF !f_vazio(xMsgErro)
					MESSAGEBOX(xMsgErro+CHR(13)+"Favor Verificar no c:\temp os erros!!!",0+16,"Limite Crédito Cliente Atacado")
					F_wait()
					Return .F.
				ENDIF
				
				F_wait()
					
				If Thisformset.lx_form1.lx_ckbox_atualiza_tabela.value = 0
					If MESSAGEBOX("Deseja Excluir e Incluir o Registro da Tabela ?",4+32,"Limite Crédito Cliente Atacado") = 6
						TEXT TO xDelete TEXTMERGE NOSHOW
						
								DELETE ANM_CLIENTE_ATAC_LIMITE_CREDITO
						
						ENDTEXT
						
						f_delete(xDelete)	
						
						SELECT cur_import
						Count to xTReg
						GO top
						SCAN
						
							xTRit = xTRit + 1
							F_PROG_BAR("Aguarde, Importando arquivo ..."+ALLTRIM(STR(xTRit))+" de "+ALLTRIM(STR(xTReg))+;
						            CHR(13)+ALLTRIM(STR((xTRit/xTReg)*100))+"% Concluido",xTRit,xTReg)	
							
							TEXT TO xInsert TEXTMERGE NOSHOW
						
								INSERT INTO ANM_CLIENTE_ATAC_LIMITE_CREDITO(REDE_LOJAS,COLECAO,COD_CLIENTE,LIMITE)
								SELECT '<<LTRIM(RTRIM(UPPER(cur_import.REDE_LOJAS)))>>','<<LTRIM(RTRIM(UPPER(cur_import.COLECAO)))>>','<<LTRIM(RTRIM(UPPER(cur_import.COD_CLIENTE)))>>',REPLACE('<<cur_import.LIMITE>>',',','.')
							ENDTEXT
						
							f_execute(xInsert)

							SELECT cur_import
						endscan
						F_PROG_BAR()
						MESSAGEBOX("Importado com Sucesso !!!",0+64,"Importação")
					Else
						Return .F.
					Endif
				Else
				**** caso esteja marcado o checkbox
					f_select("select * from ANM_CLIENTE_ATAC_LIMITE_CREDITO","xClienteLimCred")
					select a.* from cur_import a left join xClienteLimCred b ;
					on UPPER(a.rede_lojas) = UPPER(b.rede_lojas) ;
					and UPPER(a.colecao) = UPPER(b.colecao) ;
					and UPPER(a.cod_cliente) = UPPER(b.cod_cliente) ;
					where b.cod_cliente is null into cursor	vTmp_Sem_Cadastro
					
					If RECCOUNT()>0
					
						If Messagebox("Foram encontrados registros que não tem na tabela"+CHR(13)+"deseja inserir ?",4+32,"Limite Crédito Cliente Atacado") = 6
							Sele vTmp_Sem_Cadastro
							Count to xTReg
							GO top
							Scan
								xTRit = xTRit + 1
								F_PROG_BAR("Aguarde, Inserindo Cadastro ..."+ALLTRIM(STR(xTRit))+" de "+ALLTRIM(STR(xTReg))+;
					            CHR(13)+ALLTRIM(STR((xTRit/xTReg)*100))+"% Concluido",xTRit,xTReg)	
							
								TEXT TO xInsert TEXTMERGE NOSHOW
						
									INSERT INTO ANM_CLIENTE_ATAC_LIMITE_CREDITO(REDE_LOJAS,COLECAO,COD_CLIENTE,LIMITE)
									SELECT '<<LTRIM(RTRIM(UPPER(vTmp_Sem_Cadastro.REDE_LOJAS)))>>','<<LTRIM(RTRIM(UPPER(vTmp_Sem_Cadastro.COLECAO)))>>','<<LTRIM(RTRIM(UPPER(vTmp_Sem_Cadastro.COD_CLIENTE)))>>',REPLACE('<<vTmp_Sem_Cadastro.LIMITE>>',',','.')
					
								ENDTEXT
					
								f_execute(xInsert)
								sele vTmp_Sem_Cadastro
							Endscan	
							f_prog_bar()
						Endif
					Endif
					
					select a.* from cur_import a join xClienteLimCred b ;
					on UPPER(a.rede_lojas) = UPPER(b.rede_lojas) ;
					and UPPER(a.colecao) = UPPER(b.colecao) ;
					and UPPER(a.cod_cliente) = UPPER(b.cod_cliente) ;
					into cursor	vTmp_Atualiza_Cadastro
					
					SELECT vTmp_Atualiza_Cadastro
					Count to xTReg
					GO top
					SCAN
					
						xTRit = xTRit + 1
						F_PROG_BAR("Aguarde, Atualizando Cadastro ..."+ALLTRIM(STR(xTRit))+" de "+ALLTRIM(STR(xTReg))+;
					            CHR(13)+ALLTRIM(STR((xTRit/xTReg)*100))+"% Concluido",xTRit,xTReg)	
						
						TEXT TO xUpdate TEXTMERGE NOSHOW
							update ANM_CLIENTE_ATAC_LIMITE_CREDITO set LIMITE = replace('<<vTmp_Atualiza_Cadastro.limite>>',',','.')
							where REDE_LOJAS = '<<vTmp_Atualiza_Cadastro.rede_lojas>>'
							and COLECAO = '<<vTmp_Atualiza_Cadastro.colecao>>'
							and COD_CLIENTE = '<<vTmp_Atualiza_Cadastro.cod_cliente>>'
						ENDTEXT
					
						f_execute(xUpdate)
					
						SELECT vTmp_Atualiza_Cadastro
					endscan
						F_PROG_BAR()	
						MESSAGEBOX("Importado/Atualizado com Sucesso !!!",0+64,"Importação")
				Endif
						
	ENDPROC
ENDDEFINE
