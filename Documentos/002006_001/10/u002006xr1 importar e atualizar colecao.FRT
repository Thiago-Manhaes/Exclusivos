   �   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Courier New                    �ORIENTATION=1
PAPERSIZE=9
SCALE=100
ASCII=100
COPIES=1
DEFAULTSOURCE=7
PRINTQUALITY=600
COLOR=2
YRESOLUTION=600
TTOPTION=2
COLLATE=0
                   5TITULO=
CRIADOR=
PADRAO=N
PUBLICO=N
FAVORITOS=;
           Courier New                    dataenvironment                �Top = 163
Left = 524
Width = 436
Height = 307
AutoOpenTables = .F.
AutoCloseTables = .F.
DataSource = .NULL.
Name = "Dataenvironment"
                    dPROCEDURE Destroy
SET proce to &x_proc
RELEASE x_proc

ENDPROC
PROCEDURE Init
***** colecao *****
If o_002006.pp_anm_importa_excel_pa = .f.
	MESSAGEBOX("Voc� n�o tem permiss�o para importar/alterar os produtos !",0+16,"ATEN��O")
	Return .F.
Endif

if used("IMPORTARCSV")
	select IMPORTARCSV
	use
endif

CREATE CURSOR IMPORTARCSV (PRODUTO CHAR(12), COLECAO CHAR(6)) 
			
sele IMPORTARCSV 
cursorset('buffering',3)
index on produto+colecao tag iOs6



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

F_WAIT("Importando dados do Excel !")
SELE IMPORTARCSV
F_WAIT()

*** VERIFICA SE NO ARQUIVO COLOCOU A COLE��O EXISTENTE NO SISTEMA ****

f_select("select colecao from colecoes","xColecao",ALIAS())
SELECT UPPER(a.colecao) AS COLECAO FROM IMPORTARCSV A LEFT JOIN xColecao B ON UPPER(A.COLECAO) = UPPER(B.COLECAO) WHERE B.COLECAO IS NULL INTO CURSOR xVerColecao
Sele xVerColecao
IF RECCOUNT()>0
	MESSAGEBOX("Favor verificar se a cole��o informada no arquivo est� correta !",0+16)
	release xVerColecao
	Return .F.
Endif

**********************************************************************
F_WAIT("Atualizando as Cole��es do Produto !!!")
SELECT produto as produto_import, UPPER(colecao) as colecao_import from IMPORTARCSV into cursor vtmp_importar_csv 
sele vtmp_importar_csv
If RECCOUNT()>0
Scan	
	
			F_UPDATE("UPDATE PRODUTOS SET COLECAO=?vtmp_importar_csv.colecao_import WHERE PRODUTO=?vtmp_importar_csv.produto_import")
	*		TEXT TO xupdtcolecao NOSHOW textmerge

	*			UPDATE PRODUTOS SET COLECAO='<<vtmp_importar_csv.colecao_import>>'
	*			WHERE produto = '<<vtmp_importar_csv.produto_import>>'

	*		ENDTEXT
	
		Sele vtmp_importar_csv 
EndScan
F_WAIT()

MESSAGEBOX("Atualizado com Sucesso !!!",0+64,"Status Atualiza��o")
F_WAIT()	
Else
F_WAIT()
	MESSAGEBOX("N�o foram encontrados registros no arquivo ! Verificar !!!",0+16)
	Return .F.
*!*		SELECT a.produto from v_produtos_00 a LEFT JOIN IMPORTARCSV   b ON a.produto = b.produto WHERE b.produto is null into cursor vtmp_erros_1 
*!*		SELECT a.produto from IMPORTARCSV   a LEFT JOIN v_produtos_00 b ON a.produto = b.produto WHERE b.produto is null into cursor vtmp_erros_2 

*!*		select * from vtmp_erros_1 UNION all SELECT * FROM vtmp_erros_2 INTO CURSOR vTmpExcelErros

*!*		Sele vTmpExcelErros
*!*		If RECCOUNT()>0
*!*			SELE vTmpExcelErros
*!*			CURSORSETPROP('BUFFERING',3)
*!*			COPY TO C:\TEMP\ERRO_IMPORTACAO_SOLUCAO XLS
*!*			MESSAGEBOX("Os produtos que n�o estavam no filtro da tela / planilha que n�o foram atualizados foram exportado para: "+CHR(13)+"C:\TEMP\ERRO_IMPORTACAO_SOLUCAO para an�lise !!!",0+64)
*!*			Return .F.
*!*		Endif
Endif	
RETURN .F.
ENDPROC
                  ���    �  �                        ��   %         �  7   .          �  U  "  SET proce to &x_proc
 <�  � U  X_PROC� %��  � -��l �S ��C�: Voc� n�o tem permiss�o para importar/alterar os produtos !�� ATEN��O�x�� B�-�� � %�C� IMPORTARCSV���� � F� � Q� �8 h�� IMPORTARCSV� � CHAR���� � CHAR���� F� � ��C�	 buffering���� & �� � ��� �* T� �C� Deseja Importar dados ?�$�x�� %�� �����' T� �� 'C� csv� Arquivo:�� '�� %�C� �� ''���� B�-�� �6 APPEND FROM &xCaminho DELIMITED WITH CHARACTER ';'
 ��� B�-�� �( ��C� Importando dados do Excel !� �� F� �
 ��C� ��6 ��C� select colecao from colecoes� xColecaoC�	 ��a o� IMPORTARCSVQ�
 X�� xColecaoQ�  �C�� fC�� f��C�� f�Q� ��C�� ����� xVerColecao� F� � %�CN� ���O ��C�@ Favor verificar se a cole��o informada no arquivo est� correta !��x�� <� � B�-�� �3 ��C�& Atualizando as Cole��es do Produto !!!� ��> o� IMPORTARCSV�� �Q� �C� f�Q� ��� vtmp_importar_csv� F� � %�CN� ��|� ~�&�z ��C�m UPDATE PRODUTOS SET COLECAO=?vtmp_importar_csv.colecao_import WHERE PRODUTO=?vtmp_importar_csv.produto_import� �� F� � �
 ��C� ��> ��C� Atualizado com Sucesso !!!�@� Status Atualiza��o�x��
 ��C� �� ���
 ��C� ��I ��C�: N�o foram encontrados registros no arquivo ! Verificar !!!��x�� B�-�� � B�-�� U  O_002006 PP_ANM_IMPORTA_EXCEL_PA IMPORTARCSV PRODUTO COLECAO IOS6 XPERG XCAMINHO F_WAIT F_SELECT A XCOLECAO B XVERCOLECAO PRODUTO_IMPORT COLECAO_IMPORT VTMP_IMPORTAR_CSV F_UPDATE Destroy,     �� InitZ     ��1 �q 3 "1q A �q A A �r �!�qQq A b� q A �q � dq �q q A 3�q � �x A � �� � � �q N q 1                       9         T   Y      )   �                  