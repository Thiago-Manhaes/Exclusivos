

****EXPORTA SMS ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select b.codigo_barra,'00000'+right(ltrim(rtrim(a.qtde)),6) as qtde from 
(select a.produto, a.cor_produto,
a.f1 as qtde,1 as tamanho
from FATURAMENTO_PROD a
join faturamento_caixas b
on a.caixa=b.caixa
where b.nome_clifor = 'ABRAND SAVASSI' 
and a.f1<>0
union all 
select a.produto, a.cor_produto,
a.f2 as qtde,2 as tamanho
from FATURAMENTO_PROD a
join faturamento_caixas b
on a.caixa=b.caixa
where b.nome_clifor = 'ABRAND SAVASSI' 
and a.f2<>0
union all
select a.produto, a.cor_produto,
a.f3 as qtde,3 as tamanho
from FATURAMENTO_PROD a
join faturamento_caixas b
on a.caixa=b.caixa
where b.nome_clifor = 'ABRAND SAVASSI' 
and a.f3<>0
union all
select a.produto, a.cor_produto,
a.f4 as qtde,4 as tamanho
from FATURAMENTO_PROD a
join faturamento_caixas b
on a.caixa=b.caixa
where b.nome_clifor = 'ABRAND SAVASSI' 
and a.f4<>0
union all
select a.produto, a.cor_produto,
a.f5 as qtde,5 as tamanho
from FATURAMENTO_PROD a
join faturamento_caixas b
on a.caixa=b.caixa
where b.nome_clifor = 'ABRAND SAVASSI' 
and a.f5<>0
union all
select a.produto, a.cor_produto,
a.f6 as qtde,6 as tamanho
from FATURAMENTO_PROD a
join faturamento_caixas b
on a.caixa=b.caixa
where b.nome_clifor = 'ABRAND SAVASSI' 
and a.f6<>0
union all
select a.produto, a.cor_produto,
a.f7 as qtde,7 as tamanho
from FATURAMENTO_PROD a
join faturamento_caixas b
on a.caixa=b.caixa
where b.nome_clifor = 'ABRAND SAVASSI' 
and a.f7<>0
union all
select a.produto, a.cor_produto,
a.f8 as qtde,8 as tamanho
from FATURAMENTO_PROD a
join faturamento_caixas b
on a.caixa=b.caixa
where b.nome_clifor = 'ABRAND SAVASSI' 
and a.f8<>0) a 
join produtos_barra b 
on a.produto=b.produto  
and a.cor_produto=b.cor_produto 
and a.tamanho=b.tamanho

order by a.produto,a.cor_produto  

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO "C:\TEMP\codigo.txt" CSV 