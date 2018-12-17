* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  26/02/2009                                                                                               *
* HORÁRIO........:  13;00                                                                                           *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                *
* OBJETIVO.: Ajuste layout propriedades clientes varejo					                    *
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

		* =messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )

			do case
				
				case upper(xmetodo) == 'USR_INIT' 
				
					xalias=alias()					
						
						f_select("SELECT VALOR_PROPRIEDADE FROM PROPRIEDADE_VALIDA WHERE PROPRIEDADE = '00084'","xRequisitante",ALIAS())
						THISFORMSET.lX_FORM1.lx_pageframe1.page1.addobject("cmb_requisitante","cmb_requisitante")			
						
						**** INCLUE BOTAO NA TELA ****
						thisformset.lx_form1.addobject("btn_importa_csv","btn_importa_csv")			
						

					if !f_vazio(xalias)					
						sele &xalias 
					endif	
				
				
				case upper(xmetodo) == 'USR_SAVE_BEFORE' 
				
					xalias=alias()					
					
						
					IF F_VAZIO(V_ESTOQUE_SAI_MAT_00.REQUISITANTE) OR F_VAZIO(V_ESTOQUE_SAI_MAT_00.RESPONSAVEL) OR F_VAZIO(V_ESTOQUE_SAI_MAT_00.DESTINO) 
						MESSAGEBOX('Proibido salvar saida sem informar o Requisitante, Responsavel, Destino!!',0+64)
						THISFORMSET.lX_FORM1.lx_pageframe1.page1.SETFOCUS()
						THISFORMSET.lX_FORM1.lx_pageframe1.page1.cmb_requisitante.SETFOCUS()
						RETURN .F.
					ENDIF	
						
						

					if !f_vazio(xalias)					
						sele &xalias 
					endif												
																
				otherwise
				return .t.				
			endcase

	endproc


ENDDEFINE

**************************************************
*-- Class:        cmb_requisitante(c:\temp\cmb_requisitante.vcx)
*-- ParentClass:  lx_textbox_valida (c:\arquivos de programas\arquivos comuns\linx sistemas\desenv\lib\lx_class.vcx)
*-- BaseClass:    textbox
*-- Time Stamp:   05/18/09 01:02:02 PM
*
DEFINE CLASS cmb_requisitante AS lx_combobox

	RowSource = "xRequisitante"
	ControlSource = "V_ESTOQUE_SAI_MAT_00.REQUISITANTE"
	Height = 22
	Left = 84
	Top = 90
	Width = 161
	TabIndex = 1
	ZOrderSet = 5
	Name = "cmb_requisitante"
	Visible = .T.
	Enabled = .T.

ENDDEFINE
*
*-- EndDefine: cmb_requisitante
**************************************************

**************************************************
*-- Class:        btn_atu_dados_cob_entr(c:\linx desenv\classes lucas\btn_atu_dados_cob_entr.vcx)
*-- ParentClass:  botao (c:\linx desenv\desenv\lib\lx_class.vcx)
*-- BaseClass:    commandbutton
*-- Time Stamp:   10/06/14 05:29:10 PM
*
Define Class btn_importa_csv As botao

	Top = 29
	Left = 450
	Height = 25
	Anchor = 0
	Width = 85
	FontBold = .T. 
	FontName = 'TAHOMA'
	Caption = "Importar \<CSV"
	ForeColor = Rgb(0,0,0)
	Name = "btn_importa_csv"
	Visible = .T.
	
	PROCEDURE click
	LOCAL xMaterial as String, xCor as String, xQtde as Number, xPosicao as Integer, xPosicao1 as Integer, xItem as integer
	
	nOldSele = Select()
	
		IF  thisformset.p_tool_status $ ('IA')
			IF !THISFORMSET.l_desenhista_filhas_inclui_antes() then
				RETURN .f.
			ENDIF 

			CREATE CURSOR CUR_IMPORT(MATERIAL C(12), COR_MATERIAL C(6), QTDE NUMERIC(11,3)) 
		
			strCaminho = Getfile("csv", "Importar Arquivo", "Importar")
			lcArquivo = FILETOSTR(strCaminho)
			lnLinhas = ALINES(laRegistro,lcArquivo)
		
			IF F_VAZIO(strCaminho)
				RETURN .F.
			ENDIF
			
			SELECT CUR_IMPORT
			FOR C=1 TO lnLinhas
				xPosicao    = ATC(';',laRegistro(C),1) &&---- = 10
				xMaterial   = SUBSTR(laRegistro(C), 1, xPosicao - 1) &&------- Material
				
				xPosicao1   = ATC(';',laRegistro(C),2) &&--- = 14
				xCor	 	= SUBSTR(laRegistro(C), xPosicao + 1, xPosicao1-1) &&------- Cor Material
				xCor		= SUBSTR(xCor, 1, ATC(';',xCor,1)-1)
				xQtde	 	= SUBSTR(laRegistro(C), xPosicao1+1, LEN(laRegistro(C))) &&------- Qtde
				
				f_Wait(' Lendo Registro -> Material: ' + xMaterial )
					APPEND BLANK
							REPLACE MATERIAL	 WITH xMaterial 
							REPLACE	COR_MATERIAL WITH xCor
							REPLACE	QTDE		 WITH VAL(xQtde)
			ENDFOR
			f_Wait()
			
			SELECT CUR_IMPORT
			
			SELECT MATERIAL, COR_MATERIAL , SUM(QTDE) AS TQTDE, 'XX' AS UNIDADE, 0000000000.000 AS ESTOQUE FROM CUR_IMPORT GROUP BY MATERIAL, COR_MATERIAL INTO CURSOR CUR_IMPORT_FINAL READWRITE
			
			SELECT CUR_IMPORT_FINAL
			&&------Verificaçao se existe o material, cor e saldo antes de importar

			SCAN
			*SET STEP ON
			
			F_WAIT("Verificando Material("+ALLTRIM(CUR_IMPORT_FINAL.MATERIAL)+"), Cor("+ALLTRIM(CUR_IMPORT_FINAL.COR_MATERIAL)+") e Saldo. Aguarde...")
				TEXT TO xSql TEXTMERGE NOSHOW 
					SELECT A.UNID_ESTOQUE,ISNULL(C.QTDE_ESTOQUE,0) AS QTDE_ESTOQUE
					FROM  
					MATERIAIS A
					INNER JOIN MATERIAIS_CORES B ON A.MATERIAL=B.MATERIAL
					LEFT JOIN ESTOQUE_MATERIAIS C ON A.MATERIAL=C.MATERIAL AND B.COR_MATERIAL=C.COR_MATERIAL AND C.FILIAL='<<ALLTRIM(thisformset.lx_FORM1.cmb_FILIAL.Value)>>'
					WHERE  
					A.MATERIAL='<<ALLTRIM(CUR_IMPORT_FINAL.MATERIAL)>>' AND
					B.COR_MATERIAL='<<ALLTRIM(CUR_IMPORT_FINAL.COR_MATERIAL)>>' 
				ENDTEXT 
				IF F_SELECT(xSql,"vTmp_Material") then
					REPLACE CUR_IMPORT_FINAL.UNIDADE WITH vTmp_Material.UNID_ESTOQUE
					REPLACE CUR_IMPORT_FINAL.ESTOQUE WITH vTmp_Material.QTDE_ESTOQUE 
				ENDIF
				
			ENDSCAN
			f_wait()
			SELECT MATERIAL, COR_MATERIAL, TQTDE, UNIDADE, ESTOQUE FROM CUR_IMPORT_FINAL WHERE UNIDADE <> 'XX' INTO CURSOR CUR_FINAL
			
			SELECT CUR_FINAL
			GO TOP
			xItem = 1
			SCAN
				SELECT V_ESTOQUE_SAI_MAT_00_MATERIAIS
				APPEND BLANK
				REPLACE MATERIAL 	 		WITH CUR_FINAL.MATERIAL
				REPLACE COR_MATERIAL 		WITH CUR_FINAL.COR_MATERIAL 
				REPLACE QTDE		 		WITH CUR_FINAL.TQTDE
				REPLACE ITEM		 		WITH STR(XITEM)
				REPLACE UNID_ESTOQUE 		WITH CUR_FINAL.UNIDADE
				REPLACE UNID_FICHA_TEC 		WITH CUR_FINAL.UNIDADE
				REPLACE QTDE_ESTOQUE_ATUAL 	WITH CUR_FINAL.ESTOQUE 
				REPLACE QTDE_UNID_FICHA 	WITH CUR_FINAL.ESTOQUE 
				REPLACE QTDE_ESTOQUE_NOVO 	WITH (CUR_FINAL.ESTOQUE - CUR_FINAL.TQTDE)
				
				SELECT CUR_FINAL
				xItem = xItem + 1
			ENDSCAN 
			SELECT V_ESTOQUE_SAI_MAT_00_MATERIAIS
			GO TOP
			THISFORMSET.LX_FORM1.LX_pageframe1.PAge2.LX_GRID_FILHA1.Refresh
		ELSE
			MESSAGEBOX("Somente para inclusão e alteração",64,"Atenção")
			RETURN .f.
		ENDIF
			
	ENDPROC
		
enddefine