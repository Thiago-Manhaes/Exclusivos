define class obj_entrada as custom
	procedure metodo_usuario
	lparam xmetodo, xobjeto ,xnome_obj
	 *=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
	DO CASE
*!*			CASE UPPER(xmetodo) == 'USR_CLEAN_AFTER'
*!*				STRTRAN(Thisformset.dataEnvironment.Cur_v_loja_entradas_transito_01.SelectCmd,'LOJA_ENTRADAS.EMISSAO,','LOJA_ENTRADAS.DATA_SAIDA AS EMISSAO,')	
			
		CASE UPPER(xmetodo) == 'USR_INIT'
		
			xVersao = '01.1'
			f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
			f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
			WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT
		
			** Adiciona um novo botão para liberação do Transito porque o botão original não está chamando o objeto de entrada
			thisformset.lx_FORM1.lx_pageframe1.page1.addobject("CmdLiberaTransito","CmdLiberaTransito") 
			thisformset.lx_FORM1.lx_pageframe1.page1.cmdTransit.Enabled = .F. && Desabilita o botão original para o usuario não clicar
			thisformset.lx_FORM1.lx_pageframe1.page1.cmdTransit.Visible = .F. && Esconde o botão original para o usuario não clicar
			
			thisformset.lx_form1.lx_pageframe1.page1.lx_grid_filha1.col_tx_rESPONSAVEL.h_tx_RESPONSAVEL.Caption = 'Data Saida'
			x="SELECT LOJA_ENTRADAS.ROMANEIO_PRODUTO, LOJA_ENTRADAS.FILIAL, REGIAO,  LOJA_ENTRADAS.FILIAL_ORIGEM, LOJA_ENTRADAS.TIPO_ENTRADA_SAIDA, "
			x1="LOJA_ENTRADAS.CODIGO_TAB_PRECO, LOJA_ENTRADAS.NUMERO_NF_TRANSFERENCIA, LOJA_ENTRADAS.FORNECEDOR, LOJA_ENTRADAS.DATA_SAIDA AS RESPONSAVEL, "
			x2="LOJA_ENTRADAS.EMISSAO, LOJA_ENTRADAS.OBS, LOJA_ENTRADAS.ENTRADA_CONFERIDA, LOJA_ENTRADAS.ENTRADA_SEM_PRODUTOS,LOJA_ENTRADAS.QTDE_TOTAL, "
			x3="LOJA_ENTRADAS.VALOR_TOTAL, LOJA_ENTRADAS.FATOR_PRECO, LOJA_ENTRADAS.ROMANEIO_NF_SAIDA, LOJA_ENTRADAS.VALOR_NAO_CONFERIDO, LOJA_ENTRADAS.QTDE_NAO_CONFERIDA, "
			x4="CONVERT(BIT, 0) AS LIBERA_TRANSITO, LOJA_ENTRADAS_DIF.STATUS_TRANSITO  FROM LOJA_ENTRADAS  JOIN FILIAIS ON LOJA_ENTRADAS.FILIAL = FILIAIS.FILIAL "
			x5="LEFT JOIN LOJA_ENTRADAS_DIF ON LOJA_ENTRADAS.FILIAL = LOJA_ENTRADAS_DIF.FILIAL  AND LOJA_ENTRADAS.NUMERO_NF_TRANSFERENCIA = LOJA_ENTRADAS_DIF.NUMERO_NF_TRANSFERENCIA "  
			x6="AND LOJA_ENTRADAS.FILIAL_ORIGEM = LOJA_ENTRADAS_DIF.FILIAL_ORIGEM  AND LOJA_ENTRADAS.ROMANEIO_NF_SAIDA = LOJA_ENTRADAS_DIF.ROMANEIO_NF_SAIDA  AND LOJA_ENTRADAS.EMISSAO = LOJA_ENTRADAS_DIF.EMISSAO "
			x7="WHERE LOJA_ENTRADAS.ENTRADA_CONFERIDA=0  ORDER BY EMISSAO ASC, FILIAIS.FILIAL"


			Thisformset.DataEnvironment.Cur_v_loja_entradas_transito_01.SelectCmd=x+x1+x2+x3+x4+x5+x6+x7
		OTHERWISE
			return .t.
		ENDCASE
	ENDPROC
ENDDEFINE

*-- Class: Imprime_zebra_transp 
DEFINE CLASS CmdLiberaTransito AS commandbutton
	Top = 408
	Left = 551
	Height = 27
	Width = 120
	Caption = "Liberar Trânsito."
	Name = "CmdLiberaTransito"
	fontbold = .T.
	visible=.T.
	enabled=.T.

	PROCEDURE Click
	
	SET STEP ON
	
		local nRecCount as Integer
		
		select v_loja_entradas_transito_01
		count for libera_transito to nRecCount
		if nRecCount = 0
			f_msg(["Selecione pelo menos um item para liberação do trânsito.", 48, "Atenção"])
			return .f.
		EndIf

		* 05/05/2014 - Tiago Carvalho - Sintese Soluções - Criado um parametro para bloquear baixa de transito por usuarios não autorizados.
		IF type("thisformset.PP_ANM_PERMITE_CONFIRMAR_ENT") <> "C"
			MESSAGEBOX("O parametro ANM_PERMITE_CONFIRMAR_ENT não foi encontrado, reinicie o LINX e se o problema persistir entre em contato com o departamento de Sistemas",0+16,"OBJ - Parâmentro Inválido")
			RETURN .f.
		ENDIF
		
		lcFiliaisPermitidas = UPPER(ALLTRIM(thisformset.PP_ANM_PERMITE_CONFIRMAR_ENT))
		
		DO WHILE " ," $ lcFiliaisPermitidas OR ", " $ lcFiliaisPermitidas
			lcFiliaisPermitidas = STRTRAN(STRTRAN(lcFiliaisPermitidas," ,",","),", ",",")
		ENDDO
		
		IF "NENHUMA" $ lcFiliaisPermitidas OR F_VAZIO(lcFiliaisPermitidas)
			MESSAGEBOX("Atenção, Você não têm permissão para baixar o trânsito",0+16,"Obj - Baixa de Transito não Permitida")
			f_wait()
			RETURN .F.
		ENDIF
		
		IF !("TODAS" $ lcFiliaisPermitidas)
			F_SELECT("select LTRIM(RTRIM(filial)) as filial from filiais (nolock) where COD_FILIAL in('"+STRTRAN(lcFiliaisPermitidas,",","','")+"')","CurFiliaisPermitidas")
			
			IF RECCOUNT("CurFiliaisPermitidas") == 0
				MESSAGEBOX("Atenção, Você não têm permissão para baixar o trânsito",0+16,"Obj - Baixa de Trânsito não Permitida")
				f_wait()
				RETURN .F.
			ENDIF	
			
			f_wait("Consultando Acesso...")
			
			sele v_loja_entradas_transito_01 

			scan for libera_transito
				lcFilial = v_loja_entradas_transito_01.filial
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
					f_wait()
					RETURN .f.
				ENDIF 
				SELECT v_loja_entradas_transito_01 
			ENDSCAN
		ENDIF	
					
			** Tiago Carvalho - Sintese Soluções - Se passar pela validação clico no botão original para fazer o processo de baixa.
			thisformset.lx_FORM1.lx_pageframe1.page1.cmdTransit.CLICK()
			thisformset.refresh()
			f_wait()
			

	ENDPROC
ENDDEFINE
