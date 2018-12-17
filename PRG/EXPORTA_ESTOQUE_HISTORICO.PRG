****EXPORTA ESTOQUE HISTORICO****************************

TEXT TO XSEL NOSHOW TEXTMERGE


select convert(char(12),a.produto) as produto,b.desc_produto,a.estoque,
convert(numeric(14,2),(c.preco1*70)/100) as custo,c.preco1 as preco_venda 
from 
(select produto,sum(estoque) as estoque 
from tmp_higi_2010 
group by produto) a
join produtos b 
on a.produto=b.produto
left join (select produto,preco1 from produtos_precos where codigo_tab_preco='VO') c  
on a.produto=c.produto
where a.estoque>0

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\estoque_higienopolis_31122010.XLS XLS 