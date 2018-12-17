

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select * from
(select a.ordem_producao,a.qtde_a as qtde_tot_nf,b.qtde_a_ret as qtde_tot_ret,
(qtde_a-qtde_a_ret) as 'qtde_tot_nf_qtde_tot_ret',a.qtde_total as qtde_total_op,a.qtde_em_producao,c.qtde_ent as qtde_ent_estoque from
( select a.ordem_producao,sum(qtde_a) as qtde_a,qtde_total,qtde_em_producao,indicador_tipo_mov
from W_PRODUCAO_ORDEM_HIST_OS a
join PRODUCAO_ORDEM b
on a.ordem_producao = b.ordem_producao
where a.nf_entrada <> ''
and b.status <> 'E'
and emissao >= '20110101'
and fase_producao1 = '021'
and indicador_tipo_mov = '1'
--and a.ordem_producao = '212701'
group by a.ordem_producao,qtde_total,qtde_em_producao,indicador_tipo_mov ) a
join
( select a.ordem_producao,sum(qtde_a) as qtde_a_ret,qtde_total,qtde_em_producao,indicador_tipo_mov
from W_PRODUCAO_ORDEM_HIST_OS a
join PRODUCAO_ORDEM b
on a.ordem_producao = b.ordem_producao
where a.nf_entrada <> ''
and b.status <> 'E'
and emissao >= '20110101'
--and fase_producao = '007'
and indicador_tipo_mov = '5'
--and a.ordem_producao = '212701'
group by a.ordem_producao,qtde_total,qtde_em_producao,indicador_tipo_mov ) b
on a.ordem_producao = b.ordem_producao
join (select ordem_producao,sum(qtde) as qtde_ent
from  estoque_prod1_ent group by ordem_producao) c
on a.ordem_producao = c.ordem_producao) a
where qtde_tot_nf_qtde_tot_ret <> qtde_ent_estoque

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\OP_ENTRADA_NF.XLS XLS 