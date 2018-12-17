

****EXPORTA VENDAS ABRAND****************************

public xDataIni,xDataFIm

xDataIni = '20130101'
xDataFim = '20130531'

TEXT TO XSEL NOSHOW TEXTMERGE

declare @data_ini datetime
declare @data_fim datetime
select @data_ini= '<<xDataIni>>'
select @data_fim= '<<xDataFim>>'

SELECT * FROM
(select DISTINCT
a.desc_recurso1 as FORNECEDOR,a.ORDEM_SERVICO,convert(numeric(14,2),(isnull(d.valor_frete_os,0))) as VALOR_FRETE_OS 
from 
(select * from FX_ANMPRODUCAO_ORDEM_HIST_OS_FULL('') 
where data between @data_ini and @data_fim
AND FASE_PRODUCAO = '004') a 
join 
(select ordem_servico,convert(numeric(14,2),valor_propriedade) as valor_frete_os,
valor_propriedade 
from PROP_PRODUCAO_ORDEM_SERVICO                  
where propriedade='00053') d 
on a.ordem_servico=d.ordem_servico 
where d.valor_frete_os<>0 and  
d.valor_propriedade not like '1111%'
) a
union all
-- TOTAL --
SELECT * FROM
(SELECT 'TOTAL' AS FORNECEDOR, 
'QTDE = '+CONVERT(VARCHAR,(SELECT COUNT(A.ORDEM_SERVICO) FROM
(select DISTINCT a.ordem_servico
from (select * from FX_ANMPRODUCAO_ORDEM_HIST_OS_FULL('') 
where data between @data_ini and @data_fim
AND FASE_PRODUCAO = '004') a 
join 
(select ordem_servico,convert(numeric(14,2),valor_propriedade) as valor_frete_os,
valor_propriedade 
from PROP_PRODUCAO_ORDEM_SERVICO                  
where propriedade='00053') d 
on a.ordem_servico=d.ordem_servico 
where d.valor_frete_os<>0 and  
d.valor_propriedade not like '1111%') A)) AS ORDEM_SERVICO,
(SELECT sum(isnull(a.valor_frete_os,0)) as valor_frete_os from
(select distinct a.ordem_servico,d.valor_frete_os
from (select * from FX_ANMPRODUCAO_ORDEM_HIST_OS_FULL('') 
where data between @data_ini and @data_fim
AND FASE_PRODUCAO = '004') a 
join 
(select ordem_servico,convert(numeric(14,2),valor_propriedade) as valor_frete_os,
valor_propriedade  
from PROP_PRODUCAO_ORDEM_SERVICO                  
where propriedade='00053') d 
on a.ordem_servico=d.ordem_servico 
and  d.valor_propriedade not like '1111%')a ) AS VALOR_FRETE_OS) b

ENDTEXT 


TEXT TO XSEL2 NOSHOW TEXTMERGE

declare @data_ini datetime
declare @data_fim datetime
select @data_ini= '<<xDataIni>>'
select @data_fim= '<<xDataFim>>'

--analitico
select NOME_CLIFOR AS FORNECEDOR,NF_ENTRADA,ANM_FRETE_ADICIONAL AS VALOR_FRETE_MP  
from entradas where cod_transacao='ENTRADAS_104' 
and  recebimento between @data_ini and @data_fim
and  anm_frete_adicional<>0 
union all
select 'TOTAL' AS FORNECEDOR,
'QTDE = '+CONVERT(VARCHAR,(select COUNT(NF_ENTRADA) 
from entradas where cod_transacao='ENTRADAS_104' 
and  recebimento between @data_ini and @data_fim
and  anm_frete_adicional<>0)) AS NF_ENTRADA,
SUM(ISNULL(ANM_FRETE_ADICIONAL,0)) AS VALOR_FRETE_MP  
from entradas where cod_transacao='ENTRADAS_104' 
and  recebimento between  @data_ini and @data_fim
--FIM FRETE MP

ENDTEXT 


F_SELECT(XSEL,"CUR_EXPORTA")
F_SELECT(XSEL2,"CUR_EXPORTA2")

SELE CUR_EXPORTA
COPY TO C:\TEMP\RELATORIO_FRETE_OS_JAN_MAI_2013.XLS XLS 

SELE CUR_EXPORTA2
COPY TO C:\TEMP\RELATORIO_FRETE_MATERIAL_JAN_MAI_2013.XLS XLS 