  $   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Courier New                    7    winspool  PDFCreator  pdfcmon                          PDFCreator                      � |S� 	 �4d   X  X   A4                                                                                PRIV�0                                                                                       '''  '        � |                                 P4 (�                            �KL    
 �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          �   SMTJ     x                                                                                                                               �DRIVER=winspool
DEVICE=PDFCreator
OUTPUT=pdfcmon
ORIENTATION=0
PAPERSIZE=9
SCALE=100
ASCII=100
COPIES=1
DEFAULTSOURCE=7
PRINTQUALITY=600
COLOR=1
YRESOLUTION=600
TTOPTION=3
COLLATE=0
                                 aTITULO=Produtos Acabados Reduzido Com Cores
CRIADOR=USR_LINX
PADRAO=N
PUBLICO=S
FAVORITOS=;
                                 CurPrecoLog.produto            "requery('v_produtos_00_cores_mat')                              %dtoc(date()) + ' - ' + time() + 'hs.'                                                          Times New Roman                2iif(type('wTituloReport')='U','...',wTituloReport)                                             Times New Roman                'Pg: ' + alltrim(str(_pageno))                                                                 Times New Roman                alltrim(wlinx_versao)                                         Times New Roman                2iif(type('wCodigoReport')='U','...',wCodigoReport)                                             Times New Roman                ''Filtros: ' + o_040001.p_clausula_where                                                        Courier New                    7allt(CurPrecoLog.material)+' - '+allt(CurPrecoLog.item)                                        Courier New                    %"PRODUTO: "+allt(CurPrecoLog.produto)                                                          Courier New                    CurPrecoLog.CONSUMO_ANTIGO                                                                     Courier New                    CurPrecoLog.CONSUMO_NOVO                                      Courier New                    CurPrecoLog.data_alteracao                                                                     Courier New                    "@R"                           CurPrecoLog.RESPONSAVEL                                       Courier New                    Courier New                    "TabelaMateriais"             Courier New                    "ConsumoAnterior"             Courier New                    "ConsumoNovo"                 Courier New                    "Data Altera��o"              Courier New                    "Usu�rioLinx"                 Courier New                    Times New Roman                Times New Roman                Times New Roman                Times New Roman                Courier New                    Courier New                    Courier New                    Courier New                    dataenvironment                �Top = 122
Left = 796
Width = 294
Height = 319
Visible = .F.
TabStop = .F.
AutoOpenTables = .F.
AutoCloseTables = .F.
DataSource = .NULL.
Name = "Dataenvironment"
                       �PROCEDURE Init

f_select("select PRODUTO,MATERIAL,ITEM,DATA_ALTERACAO,RESPONSAVEL,C1_ANTIGO AS CONSUMO_ANTIGO,C1_NOVO AS CONSUMO_NOVO from ANM_LOG_CONSUMO_FT(NOLOCK)where 1=2",'CurPrecoLog')
f_select("SELECT PRODUTO FROM ANM_TB_BLOQ_FICHA_TECNICA_PA(nolock)","xTabPreco")
*SELECT * from v_produtos_00 INTO CURSOR vTemp_produtos_00

sele v_produtos_00 
=cursorset('buffering',3)
INDEX ON produto TAG iProd

	IF RECCOUNT()>1
			xResposta = MESSAGEBOX("Deseja Consultar o Log somente do produto selecionado?",4+32)
	ELSE		
			IF RECCOUNT()=0
				MESSAGEBOX("Nenhum produto encontrado!",64)
				RETURN .F.
			ENDIF	
			xResposta = 6		
	ENDIF


	IF xResposta = 6

			f_select("select PRODUTO,MATERIAL,ITEM,DATA_ALTERACAO,RESPONSAVEL,C1_ANTIGO AS CONSUMO_ANTIGO,C1_NOVO AS CONSUMO_NOVO FROM ANM_LOG_CONSUMO_FT(nolock) WHERE PRODUTO = ?v_produtos_00.produto",'vPrecoLog')
			INSERT INTO CurPrecoLog SELECT * FROM vPrecoLog
	ELSE
			Sele v_produtos_00 
			Count to xTReg
			xRAtu = 0
			GO top

			Scan
				xRAtu = xRAtu + 1
				f_prog_bar('Aguarde... Consultando Log de Altera��o'+CHR(13)+ALLTRIM(STR((xRAtu/xTReg)*100,3,0))+'% '+'completo',xRAtu,xTReg)
				
				f_select("select PRODUTO,MATERIAL,ITEM,DATA_ALTERACAO,RESPONSAVEL,C1_ANTIGO AS CONSUMO_ANTIGO,C1_NOVO AS CONSUMO_NOVO FROM ANM_LOG_CONSUMO_FT(nolock) WHERE PRODUTO = ?v_produtos_00.produto",'vPrecoLog')
				INSERT INTO CurPrecoLog SELECT * FROM vPrecoLog
				
				Sele v_produtos_00
			EndScan
	ENDIF
		


		
*USE vPrecoLog
*USE vTemp_produtos_00

SELECT xTabPreco
=cursorset('buffering',3)
INDEX ON produto TAG itbp

SELECT CurPrecoLog 
=cursorset('buffering',3)
INDEX ON produto+material+item+dtos(data_alteracao) TAG iatc
set rela to produto into xTabPreco

SELECT CurPrecoLog 
IF RECCOUNT()=0
	MESSAGEBOX("Nenhum Log encontrado!",64)
	RETURN .F.
ENDIF

IF MESSAGEBOX("DESEJA EXPORTAR O RELAT�RIO ?",4+32)=6

	xFile = "'"+PUTFILE('Salvar Como:','','xls')+"'"

	SELECT * FROM CurPrecoLog INTO CURSOR vTmpExcel
	
	Sele vTmpExcel 
	INDEX ON produto+material+dtos(data_alteracao) TAG IFIL
	COPY TO &xFile XLS
	
	MESSAGEBOX("EXPORTADO COM SUCESSO !!!",64)
	
	Return .F.
ENDIF 

*!*	if	messagebox("Deseja Exportar Conte�do do Relat�rio para o Arquivo c:\Temp\Produtos_Precos.XLS ?",4+32+256,"Aten��o!")=6
*!*		SELE a.produto,a.desc_produto,b.preco_tab from v_produtos_00 a ;
*!*		join vtmat b on a.produto = b.produto into cursor vtmalexp

*!*		SELE vtmalexp
*!*		COPY TO "C:\temp\Produtos_Precos.XLS" XLS
*!*		 
*!*		MESSAGEBOX('exportado com sucesso para C:\temp\Produtos_Precos.XLS')
*!*	endif	

*!*	sele v_produtos_00_cores_mat
*!*	=cursorset('buffering',3)
*!*	inde on produto + cor_produto tag prod

*!*	sele v_produtos_00
*!*	=cursorset('buffering',3)
*!*	inde on grupo_produto  + subgrupo_produto + produto tag grupo
*!*	*set rela to produto into v_produtos_00_cores_mat
*!*	SET RELATION TO produto INTO vPrecoLog addi
*set skip to v_produtos_00_cores_mat


ENDPROC
     ����    �  �                        �O   %         �  6   *          �  U  7� ��Cٔ select PRODUTO,MATERIAL,ITEM,DATA_ALTERACAO,RESPONSAVEL,C1_ANTIGO AS CONSUMO_ANTIGO,C1_NOVO AS CONSUMO_NOVO from ANM_LOG_CONSUMO_FT(NOLOCK)where 1=2� CurPrecoLog�  ��Q ��C�8 SELECT PRODUTO FROM ANM_TB_BLOQ_FICHA_TECNICA_PA(nolock)�	 xTabPreco�  �� F� � ��C�	 buffering���� & �� ��� � %�CN�����I T� �C�6 Deseja Consultar o Log somente do produto selecionado?�$�x�� ��� %�CN� ����) ��C� Nenhum produto encontrado!�@�x�� B�-�� � T� ���� � %�� ������ ��Cٲ select PRODUTO,MATERIAL,ITEM,DATA_ALTERACAO,RESPONSAVEL,C1_ANTIGO AS CONSUMO_ANTIGO,C1_NOVO AS CONSUMO_NOVO FROM ANM_LOG_CONSUMO_FT(nolock) WHERE PRODUTO = ?v_produtos_00.produto�	 vPrecoLog�  ��" r�� CurPrecoLogo�	 vPrecoLog�� ��� F� � (� � T� �� �� #)� ~��� T� �� ���k ��C�' Aguarde... Consultando Log de Altera��oC� CC� � �d�� Z�� % � completo �  � � ��� ��Cٲ select PRODUTO,MATERIAL,ITEM,DATA_ALTERACAO,RESPONSAVEL,C1_ANTIGO AS CONSUMO_ANTIGO,C1_NOVO AS CONSUMO_NOVO FROM ANM_LOG_CONSUMO_FT(nolock) WHERE PRODUTO = ?v_produtos_00.produto�	 vPrecoLog�  ��" r�� CurPrecoLogo�	 vPrecoLog�� F� � � � F�	 � ��C�	 buffering���� & �� ���
 � F� � ��C�	 buffering���� & �� � � C� ���� � G-(�� ���	 � F� � %�CN� ��D�% ��C� Nenhum Log encontrado!�@�x�� B�-�� �4 %�C� DESEJA EXPORTAR O RELAT�RIO ?�$�x���0�. T� �� 'C� Salvar Como:�  � xls�� '��" o� CurPrecoLogǼ��	 vTmpExcel� F� � & �� � C� ���� � COPY TO &xFile XLS
( ��C� EXPORTADO COM SUCESSO !!!�@�x�� B�-�� � U  F_SELECT V_PRODUTOS_00 PRODUTO IPROD	 XRESPOSTA	 VPRECOLOG XTREG XRATU
 F_PROG_BAR	 XTABPRECO ITBP CURPRECOLOG MATERIAL ITEM DATA_ALTERACAO IATC XFILE	 VTMPEXCEL IFIL Init,     ��1 �
s �� �� �q A � A �!� q � � Q � ��!r A A x �� r ��� r Qq A B�"r �a�r A p1                       �      )   �                  