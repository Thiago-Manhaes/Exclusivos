define class obj_entrada as custom
	procedure metodo_usuario
	lparam xmetodo, xobjeto ,xnome_obj
	
	*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017
 	TRY 							
		If TYPE("Thisformset.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl
			If ! o_gs.l_ver_rede_loja_prod('o_120009',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
				RETURN .f.
			Endif
		Endif
	CATCH					
	ENDTRY
	*!* Fim - Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017
	  
	DO CASE
		CASE UPPER(xmetodo) == 'USR_INIT'
			** 05/05/2014 - Tiago Carvalho - Sintese Soluções - wait para identificar que carregou o objeto.
			xVersao = '01.1'
			f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
			f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
			WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
		
			*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
			If TYPE("Thisformset.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl 
				PUBLIC o_gs as Object
				o_gs = NEWOBJECT("obj_gs_classes_rede_loja","linx\exclusivo\obj_gs_classes_rede_loja.prg")
			Endif
			*!* Fim - Declara Função obj_gs_classes_rede_loja ao Iniciar Tela rede loja produto *!* LUCAS MIRANDA 19/12/2017
		** Customização Feita Pela Animale 
		CASE UPPER(xmetodo) == 'USR_ALTER_BEFORE' 
			** Customização Animale
			xAlias = ALIAS()
			SELECT V_LOJA_ENTRADAS_00 
			IF ENTRADA_CONFERIDA 
				MESSAGEBOX("ENTRADA CONFERIDA"+CHR(13)+"IMPOSSÍVEL ALTERAR !",48,"Obj - ATENÇÃO!!!")
				RETURN .F.
			ENDIF 
				
			IF !F_VAZIO(xAlias)
				SELECT &xAlias 
			ENDIF 
		
		case UPPER(xmetodo) == 'USR_SAVE_BEFORE'
				
				xalias=alias()		
					
					*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
					If TYPE("o_120009.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl 
						If xSaveBefErroClass = 1
							Return .F.
						Endif	
					Endif			
					***** Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 	
*!*						*!* Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
*!*						If TYPE("o_120027.pp_gs_obj_classes_rl")<>'U' AND Thisformset.pp_gs_obj_classes_rl 
*!*							If !o_gs.l_ver_rede_loja_prod('o_120027',xmetodo, xobjeto ,xnome_obj,Thisformset.p_tool_status)
*!*								Return .f.
*!*							Endif
*!*						Endif	
*!*						***** Chama a função disponível na classe criada para tratar rede loja produto *!* LUCAS MIRANDA 19/12/2017 
				
				if !f_vazio(xalias)	
					sele &xalias 
				endif			
		
			
		CASE UPPER(xmetodo) == 'USR_VALID'
			DO CASE 
				CASE UPPER(ALLTRIM(xnome_obj)) == 'CK_ENTRADA_CONFERIDA'
					** bloqueio para alteração ou inclusão
					IF thisformset.p_tool_status == "I" OR thisformset.p_tool_status =="A" 
						IF xobjeto.value
							* 05/05/2014 - Tiago Carvalho - Sintese Soluções - Criado um parametro para bloquear baixa de transito por usuarios não autorizados.
							IF type("thisformset.PP_ANM_PERMITE_CONFIRMAR_ENT") <> "C"
								MESSAGEBOX("O parametro ANM_PERMITE_CONFIRMAR_ENT não foi encontrado, reinicie o LINX e se o problema persistir entre em contato com o departamento de Sistemas",0+16,"OBJ - Parâmentro Inválido")
								xobjeto.value = .F.
								RETURN .f.
							ENDIF

							lcFiliaisPermitidas = UPPER(ALLTRIM(thisformset.PP_ANM_PERMITE_CONFIRMAR_ENT))
							
							DO WHILE " ," $ lcFiliaisPermitidas OR ", " $ lcFiliaisPermitidas
								lcFiliaisPermitidas = STRTRAN(STRTRAN(lcFiliaisPermitidas," ,",","),", ",",")
							ENDDO
							
							IF "NENHUMA" $ lcFiliaisPermitidas OR F_VAZIO(lcFiliaisPermitidas)
								MESSAGEBOX("Atenção, Você não têm permissão para baixar o trânsito",0+16,"Obj - Baixa de Transito não Permitida")
								xobjeto.value = .F.
								RETURN .F.
							ENDIF

							IF !("TODAS" $ lcFiliaisPermitidas)
								F_SELECT("select LTRIM(RTRIM(filial)) as filial from filiais (nolock) where COD_FILIAL in('"+STRTRAN(lcFiliaisPermitidas,",","','")+"')","CurFiliaisPermitidas")
								
								IF RECCOUNT("CurFiliaisPermitidas") == 0
									MESSAGEBOX("Atenção, Você não têm permissão para baixar o trânsito",0+16,"Obj - Baixa de Trânsito não Permitida")
									xobjeto.value = .F.
									RETURN .F.
								ENDIF	
								
								lcFilial = UPPER(ALLTRIM(v_loja_entradas_00.filial)) 
								
								SELECT CurFiliaisPermitidas
								
								LOCATE FOR ALLTRIM(CurFiliaisPermitidas.FILIAL) == ALLTRIM(lcFilial) 
								IF !FOUND()
									lcMensagem = ""
									SELECT CurFiliaisPermitidas
									GO top
									SCAN
										lcMensagem = lcMensagem + ALLTRIM(CurFiliaisPermitidas.filial) + CHR(10)
									ENDSCAN							
									
									MESSAGEBOX("Você só tem permissão para baixar o trânsito das filiais Abaixo:" + CHR(10) + lcMensagem ,0+16,"OBJ - Baixa de Trânsito não Permitida")
									
									xobjeto.value = .F.
									
									RETURN .f.
								ENDIF 
							ENDIF					
						ENDIF
					ENDIF
				ENDCASE 
		OTHERWISE
			return .t.
		ENDCASE
	ENDPROC
ENDDEFINE
