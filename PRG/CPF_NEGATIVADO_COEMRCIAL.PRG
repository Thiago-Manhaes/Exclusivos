

****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select distinct cpf_cli as cpf  from TAB_CLIENTES_CREDITO 
where qtd_chq_devol>0 
or  qtd_chq_problema>0

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO P:\Debora_MKT\CPF_NEGATIVADO_21_MAIO_2013.XLS XLS 