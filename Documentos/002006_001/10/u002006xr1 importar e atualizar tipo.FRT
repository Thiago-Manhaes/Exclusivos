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
                    �PROCEDURE Destroy
SET proce to &x_proc
RELEASE x_proc

ENDPROC
PROCEDURE Init
***** segmento *****
If o_002006.pp_anm_importa_excel_pa = .f.
	MESSAGEBOX("Voc� n�o tem permiss�o para importar/alterar os produtos !",0+16,"ATEN��O")
	Return .F.
Endif

if used("IMPORTARCSV")
	select IMPORTARCSV
	use
endif

CREATE CURSOR IMPORTARCSV (PRODUTO CHAR(12), TIPO_PRODUTO CHAR(25)) 
			
sele IMPORTARCSV 
cursorset('buffering',3)
index on produto tag iOs6



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

*** VERIFICA SE NO ARQUIVO COLOCOU O SEGMENTO EXISTENTE NO SISTEMA ****

f_select("select * from produtos_tipos (nolock) where inativo = 0","xSegmento",ALIAS())
SELECT a.tipo_produto FROM IMPORTARCSV A LEFT JOIN xSegmento B ON UPPER(A.tipo_produto) = UPPER(B.tipo_produto) ; 
WHERE B.tipo_produto IS NULL INTO CURSOR xVerTipoo
Sele xVerTipoo
IF RECCOUNT()>0
	MESSAGEBOX("Favor verificar se o tipo informado no arquivo est� correta !",0+16)
	release xVerTipoo
	Return .F.
Endif

**********************************************************************
F_WAIT("Atualizando os Tipos do Produto !!!")
SELECT produto as produto_import, UPPER(tipo_produto) as tipo_produto_import from IMPORTARCSV into cursor vtmp_importar_csv 
sele vtmp_importar_csv 
If RECCOUNT()>0
	Scan	
	
			F_UPDATE("UPDATE PRODUTOS SET TIPO_PRODUTO=?vtmp_importar_csv.tipo_produto_import WHERE PRODUTO=?vtmp_importar_csv.produto_import")
	*		TEXT TO xupdtcolecao NOSHOW textmerge

	*			UPDATE PRODUTOS SET COLECAO='<<vtmp_importar_csv.colecao_import>>'
	*			WHERE produto = '<<vtmp_importar_csv.produto_import>>'

	*		ENDTEXT
	
		Sele vtmp_importar_csv 
	Endscan
	
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
*!*			COPY TO C:\TEMP\ERRO_IMPORTACAO_TIPO XLS
*!*			MESSAGEBOX("Os produtos que n�o estavam no filtro da tela / planilha que n�o foram atualizados foram exportado para: "+CHR(13)+"C:\TEMP\ERRO_IMPORTACAO_TIPO para an�lise !!!",0+64)
*!*			Return .F.
*!*		Endif
Endif	
RETURN .F.
ENDPROC
                   ���                              �   %   #      �  6   B          �  U  "  SET proce to &x_proc
 <�  � U  X_PROC� %��  � -��l �S ��C�: Voc� n�o tem permiss�o para importar/alterar os produtos !�� ATEN��O�x�� B�-�� � %�C� IMPORTARCSV���� � F� � Q� �8 h�� IMPORTARCSV� � CHAR���� � CHAR���� F� � ��C�	 buffering���� & �� ��� �* T� �C� Deseja Importar dados ?�$�x�� %�� �����' T� �� 'C� csv� Arquivo:�� '�� %�C� �� ''��|� B�-�� �6 APPEND FROM &xCaminho DELIMITED WITH CHARACTER ';'
 ��� B�-�� �( ��C� Importando dados do Excel !� �� F� �
 ��C� ��R ��C�7 select * from produtos_tipos (nolock) where inativo = 0�	 xSegmentoC�	 ��Z o� IMPORTARCSVQ�
 X��	 xSegmentoQ�  �C�� fC�� f���� ���C�� �����	 xVerTipoo� F� � %�CN� ���L ��C�= Favor verificar se o tipo informado no arquivo est� correta !��x�� <� � B�-�� �0 ��C�# Atualizando os Tipos do Produto !!!� ��> o� IMPORTARCSV�� �Q� �C� f�Q� ��� vtmp_importar_csv� F� � %�CN� ���� ~�;�� ��C�w UPDATE PRODUTOS SET TIPO_PRODUTO=?vtmp_importar_csv.tipo_produto_import WHERE PRODUTO=?vtmp_importar_csv.produto_import� �� F� � �> ��C� Atualizado com Sucesso !!!�@� Status Atualiza��o�x��
 ��C� �� ���
 ��C� ��I ��C�: N�o foram encontrados registros no arquivo ! Verificar !!!��x�� B�-�� � B�-�� U  O_002006 PP_ANM_IMPORTA_EXCEL_PA IMPORTARCSV PRODUTO TIPO_PRODUTO IOS6 XPERG XCAMINHO F_WAIT F_SELECT A	 XSEGMENTO B	 XVERTIPOO PRODUTO_IMPORT TIPO_PRODUTO_IMPORT VTMP_IMPORTAR_CSV F_UPDATE Destroy,     �� InitZ     ��1 �q 3 "1q A �q A A �r �� �qQq A b� q A �q � $�q �q q A �q � Bx A �� � � �q N q 1                       9         T   z      )                     