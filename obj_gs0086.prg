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

						With thisformset.lx_form1.lx_PAGEFRAME1.page2
							.addobject("btn_importa_calendario","btn_importa_calendario")	
							.btn_importa_calendario.Visible = .t.
						EndWith
					
				case upper(xmetodo) == 'USR_REFRESH' 
					
					xalias=ALIAS()
						
						If Thisformset.p_tool_status == 'I' or Thisformset.p_tool_status == 'A' or ;
						   Thisformset.p_tool_status == 'L' or Thisformset.p_tool_status == 'P'
						   
							Thisformset.p_acesso_incluir=.F.
							Thisformset.p_acesso_alterar=.T.
							Thisformset.p_acesso_excluir=.F.
						Endif
						
						If type('Thisformset.lx_form1.lx_pageframe1.page2.btn_importa_calendario')<>'U'
							If Thisformset.p_tool_status <> 'L'
								Thisformset.lx_form1.lx_pageframe1.page2.btn_importa_calendario.Enabled = .F.
								Thisformset.lx_form1.lx_pageframe1.page2.Lx_ckbox_atualiza_tabela.Enabled = .F.
								Thisformset.lx_form1.lx_paGEFRAME1.page2.lx_combox_canal.Enabled = .f.
							Else
								Thisformset.lx_form1.lx_pageframe1.page2.btn_importa_calendario.Enabled = .t.	
								Thisformset.lx_form1.lx_pageframe1.page2.Lx_ckbox_atualiza_tabela.Enabled = .T.
								Thisformset.lx_form1.lx_paGEFRAME1.page2.lx_combox_canal.Enabled = .T.
							ENDIF
						Endif
					
					
					if !f_vazio(xalias)					
						sele &xalias 
					endif	
			
			case upper(xmetodo) == 'USR_ITEN_INCLUDE_AFTER' 
					
			xalias=ALIAS()		
				
				Sele v_gs_calendarios_reprogramacao
				replace v_gs_calendarios_reprogramacao.canal with v_gs_canal_00.canal
				Thisformset.lx_FORM1.lx_PAGEFRAME1.page2.lx_grid_base1.Refresh()
		
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
DEFINE CLASS btn_importa_calendario AS commandbutton

 
	Top = 02
	Left = 32
	Height = 25
	Width = 125
	Caption = "Importar Calendário"
	Name = "btn_importa_calendario"
	
	PROCEDURE Click
		xCountReg = 0
				xTRit = 0
				xMsgErro = ''
						
		xCanal = Thisformset.lx_form1.lx_pageframe1.page2.lx_combox_canal.Value
		If F_Vazio(xCanal) AND Thisformset.lx_form1.lx_pageframe1.page2.lx_ckbox_atualiza_tabela.value = 1
			MESSAGEBOX("Favor Selecionar o Canal",0+64)
			RELEASE xcanal
			Return .F.
		Endif			
		
		if used("CUR_IMPORT")
				use in CUR_IMPORT
			ENDIF
			
		CREATE CURSOR CUR_IMPORT(REDE_LOJAS C(25), CANAL C(70),COLECAO C(6), MES N(2), ANO N(4), QUINZENA N(1), DATA_ENT_LOJA D, DATA_PROGRAMACAO D, DATA_PANOS D, DATA_AVIAMENTOS D, DATA_APROV_COR_ESTAMPA D, DATA_LACRE D, DATA_INTERNACIONAL D)
			sele CUR_IMPORT


	 		xPerg = MESSAGEBOX("Deseja Importar dados ?",4+32)
			IF xPerg  = 6		
					xCaminho = "'"+GETFILE('csv','Arquivo:')+"'"
					IF ALLTRIM(xCaminho)="''" 
						RETURN .f.
					ENDIF
						
					APPEND FROM &xCaminho DELIMITED WITH CHARACTER ';'
			ELSE
				RETURN .F.
			ENDIF

		
			F_wait("Importando as informações, Aguarde...")			
				
			SELE cur_import
			DELETE FROM cur_import WHERE f_vazio(rede_lojas)
			
					
				SELECT *, SPACE(25) AS MARCA FROM cur_import INTO CURSOR vTmp_cur_import READWRITE
				sele vTmp_cur_import 
				
				
				F_wait("Validando informações, Aguarde...")
				
				F_Select("Select * From Lojas_Rede","xRede")
				Select * FROM vTmp_cur_import a ;
				left join xRede b ;
				on ALLTRIM(a.Rede_Lojas) = ALLTRIM(b.Rede_Lojas) where b.Rede_Lojas is null ;
				into cursor xNExisteRL
				
				Sele xNExisteRL
				If RECCOUNT()>0
					xMsgErro = xMsgErro + "Existe(m) Marca(s) no arquivo não cadastrado na Tabela Rede_Lojas"
					Sele xNExisteRL
					COPY TO c:\temp\ERRO_Rede_Lojas XLS
					*MESSAGEBOX("Existe cliente no arquivo não cadastrado na Tabela Cliente Atacado"+CHR(13)+"Favor Verificar !!!",0+16,"Cliente Atacado")
					release xNExisteRL
					*Return .F.
				Else
					Update A Set A.Marca = B.Desc_Rede_Lojas;
					FROM vTmp_cur_import a ;
					join xRede b ;
					on ALLTRIM(a.Rede_Lojas) = ALLTRIM(b.Rede_Lojas)
				Endif
			
								
				F_Select("Select LTRIM(RTRIM(UPPER(CANAL))) as CANAL From GS_CANAL","xTabCanal")
				Select * From vTmp_cur_import a ;
				Left Join xTabCanal B ;
				On ALLTRIM(UPPER(a.Canal)) = ALLTRIM(UPPER(b.Canal)) ;
				Where b.Canal is null and !f_vazio(a.canal);
				Into cursor xNExisteCanal
					
				
				Sele xNExisteCanal
				If RECCOUNT()>0
					
					xMsgErro = xMsgErro + CHR(13)+"Existe(m) canal(is) no arquivo não cadastrado na Tabela GS_Canal"
					Sele xNExisteCanal
					COPY TO c:\temp\ERRO_CANAL XLS
					*MESSAGEBOX("Existe colecao no arquivo não cadastrado na Tabela Coleções"+CHR(13)+"Favor Verificar !!!",0+16,"Cliente Atacado")
					release xNExisteCanal
					*Return .F.
				Endif
				
				IF !f_vazio(xMsgErro)
					MESSAGEBOX(xMsgErro+CHR(13)+"Favor verificar na pasta C:\Temp os erros!!!"+CHR(13)+CHR(13)+"Não será possível importar !!!",0+16,"Calendário Reprogramação")
					F_wait()
					Return .F.
				ENDIF
				
				F_Wait()
												
				If Thisformset.lx_form1.lx_pageframe1.page2.lx_ckbox_atualiza_tabela.value = 1
					If MESSAGEBOX("Deseja Excluir e Incluir o Registro da Tabela ?",4+32,"Calendário Reprogramação") = 6
						TEXT TO xDelete TEXTMERGE NOSHOW
						
							DELETE GS_CALENDARIOS_REPROGRAMACAO WHERE CANAL = '<<LTRIM(RTRIM(UPPER(xcanal)))>>'
						
						ENDTEXT
					
						f_delete(xDelete)
						
						IF !F_Vazio(xCanal)
							RELEASE xCanal
						ENDIF	
						
						SELECT vTmp_cur_import
						Count to xTReg
						
						GO top
						SCAN
						
							xTRit = xTRit + 1
							F_PROG_BAR("Aguarde, Importando arquivo ..."+ALLTRIM(STR(xTRit))+" de "+ALLTRIM(STR(xTReg))+;
						            CHR(13)+ALLTRIM(STR((xTRit/xTReg)*100))+"% Concluido",xTRit,xTReg)	

							TEXT TO xInsert TEXTMERGE NOSHOW
						
								INSERT INTO GS_CALENDARIOS_REPROGRAMACAO(CODIGO_MARCA, MARCA, CANAL, COLECAO, MES, ANO, QUINZENA, DATA_ENT_LOJA, DATA_PROGRAMACAO, DATA_PANOS, DATA_AVIAMENTOS, DATA_APROV_COR_ESTAMPA, DATA_LACRE, DATA_INTERNACIONAL)
								SELECT '<<LTRIM(RTRIM(UPPER(vTmp_cur_import.rede_lojas)))>>','<<LTRIM(RTRIM(UPPER(vTmp_cur_import.marca)))>>',
									   '<<LTRIM(RTRIM(UPPER(vTmp_cur_import.canal)))>>','<<LTRIM(RTRIM(UPPER(vTmp_cur_import.colecao)))>>',
									   '<<LTRIM(RTRIM(STR(vTmp_cur_import.mes)))>>','<<LTRIM(RTRIM(STR(vTmp_cur_import.ano)))>>','<<LTRIM(RTRIM(STR(vTmp_cur_import.quinzena)))>>',
									   '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_ent_loja)))>>','<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_programacao)))>>',
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_panos)),'19000101',dtos(vTmp_cur_import.data_panos))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_panos)))>>' end ,
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_aviamentos)),'19000101',dtos(vTmp_cur_import.data_aviamentos))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_aviamentos)))>>' end ,
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_aprov_cor_estampa)),'19000101',dtos(vTmp_cur_import.data_aprov_cor_estampa))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_aprov_cor_estampa)))>>' end ,
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_lacre)),'19000101',dtos(vTmp_cur_import.data_lacre))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_lacre)))>>' end ,
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_internacional)),'19000101',dtos(vTmp_cur_import.data_internacional))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_internacional)))>>' end 
							ENDTEXT
							
							IF !F_INSERT(xInsert)
								F_WAIT()
								MESSAGEBOX('Erro ao inserir o calendário, tente novamente.', 16, 'ATENÇÃO')
								RETURN .F.
							Endif	
							

							SELECT vTmp_cur_import
						endscan
					Else
						Return .F.
					Endif
				Else					
					F_Select("SELECT CODIGO_MARCA,QUINZENA AS QUINZENA_BASE,MES AS MES_BASE, ANO AS ANO_BASE, CANAL AS CANAL_BASE FROM GS_CALENDARIOS_REPROGRAMACAO","xCalMost")
					Select * From vTmp_cur_import A ;
					Join xCalMost B ;
					On A.Rede_Lojas = B.Codigo_Marca ; 
					AND A.Canal = B.CANAL_BASE ;
					AND A.QUINZENA = VAL(B.QUINZENA_BASE) ;
					And A.Mes = Val(B.Mes_Base) ;
					And A.Ano = Val(B.Ano_Base) ;
					Into cursor xExisteBase

					 
					If !F_Vazio(xExisteBase.mes) 
						Messagebox("Não será possível importar !"+CHR(13)+"Irá duplicar informações !!!",0+16,"Importação")
					Else	
						SELECT vTmp_cur_import
						Count to xTReg
						
						GO top
						SCAN
						
							xTRit = xTRit + 1
							F_PROG_BAR("Aguarde, Importando arquivo ..."+ALLTRIM(STR(xTRit))+" de "+ALLTRIM(STR(xTReg))+;
						            CHR(13)+ALLTRIM(STR((xTRit/xTReg)*100))+"% Concluido",xTRit,xTReg)	

							TEXT TO xInsert TEXTMERGE NOSHOW
								INSERT INTO GS_CALENDARIOS_REPROGRAMACAO(CODIGO_MARCA, MARCA, CANAL, COLECAO, MES, ANO, QUINZENA, DATA_ENT_LOJA, DATA_PROGRAMACAO, DATA_PANOS, DATA_AVIAMENTOS, DATA_APROV_COR_ESTAMPA, DATA_LACRE, DATA_INTERNACIONAL)
								SELECT '<<LTRIM(RTRIM(UPPER(vTmp_cur_import.rede_lojas)))>>','<<LTRIM(RTRIM(UPPER(vTmp_cur_import.marca)))>>',
									   '<<LTRIM(RTRIM(UPPER(vTmp_cur_import.canal)))>>','<<LTRIM(RTRIM(UPPER(vTmp_cur_import.colecao)))>>',
									   '<<LTRIM(RTRIM(STR(vTmp_cur_import.mes)))>>','<<LTRIM(RTRIM(STR(vTmp_cur_import.ano)))>>','<<LTRIM(RTRIM(STR(vTmp_cur_import.quinzena)))>>',
									   '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_ent_loja)))>>','<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_programacao)))>>',
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_panos)),'19000101',dtos(vTmp_cur_import.data_panos))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_panos)))>>' end ,
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_aviamentos)),'19000101',dtos(vTmp_cur_import.data_aviamentos))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_aviamentos)))>>' end ,
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_aprov_cor_estampa)),'19000101',dtos(vTmp_cur_import.data_aprov_cor_estampa))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_aprov_cor_estampa)))>>' end ,
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_lacre)),'19000101',dtos(vTmp_cur_import.data_lacre))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_lacre)))>>' end ,
									   case when '<<LTRIM(RTRIM(IIF(f_vazio(dtos(vTmp_cur_import.data_internacional)),'19000101',dtos(vTmp_cur_import.data_internacional))))>>' = '19000101' then NULL else '<<LTRIM(RTRIM(dtos(vTmp_cur_import.data_internacional)))>>' end 
							ENDTEXT
							
							
							IF !F_INSERT(xInsert)
								F_WAIT()
								MESSAGEBOX('Erro ao inserir o calendário, tente novamente.', 16, 'ATENÇÃO')
								RETURN .F.					
							Endif
							
							Sele vTmp_cur_import
						Endscan		
							
							Messagebox("Importado com sucesso !!!",0+64,"Importação")
							F_WAIT()

					Endif  
				Endif

						
	ENDPROC
ENDDEFINE
