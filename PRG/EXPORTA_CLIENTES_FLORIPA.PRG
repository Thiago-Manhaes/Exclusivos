

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE


select * from clientes_varejo where uf='sc' and cidade='florianopolis'



ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\CLIENTES_FLORIPA.XLS XLS 