

****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

declare @data_ini datetime
declare @data_fim datetime
select @data_ini='20120801'
select @data_fim='20120831'


select * from fx_anm_eredz(@data_ini,@data_fim)
 

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "C:\Relatorio_EZ_01082012_31082012.XLS" XLS 
