TEXT TO XSEL NOSHOW TEXTMERGE



declare @data_ini datetime
declare @data_fim datetime
select @data_ini='20110711'
select @data_fim='20110717'


select filiais.matriz,lojas.codigo_filial,lojas.filial,total_vendas.total_venda,
total_vendas.vales_recebidos,
venda_vale.vales_vendidos,
isnull(cartoes.valor_cartao,0) as valor_cartao,troca.total_troca,
isnull(leitura_z.total_bruto,0) as valor_reducao
from

(select a.codigo_filial,a.filial 
from lojas_varejo a 
where a.codigo_filial in 
		('002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038',
        '039','040','041','042','043','044','045','046','047','048','049','050','051','052') ) lojas  

left join 

( select a.codigo_filial ,c.filial,b.valor_cartao
	from 
	(select a.codigo_filial,
		sum(a.valor_ticket_sem_vale)  as valor_venda  
		from wanm_vendas_loja_full a 
		where a.data_venda between @data_ini and @data_fim  
		and a.codigo_filial in 
		('002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','017','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038','039','040','041','042','043',
		'044','045','046','047','048','049','050','051','052')
		group by a.codigo_filial ) a 
	join 
	(select a.codigo_filial,
		sum(case 
				when c.tipo_pgto in ('A','E','I','K') 
				then c.valor
			else 0 end) as valor_cartao,
		sum(case 
				when c.tipo_pgto not in ('A','B','E','I','K','R','X','V') 
				then c.valor
			else 0 end) as valor_chequedin
		 from wanm_vendas_loja_full a 
		join loja_venda_pgto b 
		on  a.codigo_filial=b.codigo_filial 
		and a.terminal=b.terminal 
		and a.lancamento_caixa=b.lancamento_caixa 
		join loja_venda_parcelas c 
		on  a.codigo_filial=c.codigo_filial 
		and a.terminal=c.terminal 
		and a.lancamento_caixa=c.lancamento_caixa 
		where a.data_venda between @data_ini and @data_fim 
		and a.codigo_filial in 
		('001','002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','017','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038','039','040','041','042','043',
		'044','045','046','047','048','049','050','051','052')
		group by a.codigo_filial) b 
	on a.codigo_filial=b.codigo_filial
	join lojas_varejo c 
	on a.codigo_filial=c.codigo_filial ) cartoes 
on lojas.codigo_filial=cartoes.codigo_filial 

join filiais 
on cartoes.filial=filiais.filial 

left join
(select codigo_filial, sum(valor_troca) as total_troca
from loja_venda 
where valor_troca>'0.00'
and data_venda between @data_ini and @data_fim 
and ticket not like '%p%'
and ticket not like '%v%'
group by codigo_filial ) troca
on lojas.codigo_filial=troca.codigo_filial

left join 
( select codigo_filial, sum(total_bruto-(total_cancelado+total_desconto))  as total_bruto
from loja_controle_fiscal 
where data_fiscal between @data_ini and @data_fim  
group by codigo_filial  ) leitura_z
on lojas.codigo_filial=leitura_z.codigo_filial

left join 
( select codigo_filial, sum(valor_ticket_sem_vale)  as total_venda ,
sum(valor_vale_recebido)  as vales_recebidos
from wanm_vendas_loja_full  
where data_venda between @data_ini and @data_fim  
group by codigo_filial ) total_vendas
on lojas.codigo_filial=total_vendas.codigo_filial

left join
( select a.codigo_filial,sum(b.preco_liquido) as vales_vendidos
from loja_venda a 
join loja_venda_produto b 
on a.codigo_filial=b.codigo_filial 
and a.data_venda=b.data_venda 
and a.ticket=b.ticket 
join lojas_varejo c 
on a.codigo_filial=c.codigo_filial 
where 
b.produto='99.99.9999' 
and a.data_venda between @data_ini and @data_fim 
group by a.codigo_filial ) venda_vale
on lojas.codigo_filial=venda_vale.codigo_filial

--TOTAL MATRIZ--
union all

select filiais.matriz,'TOTAL MATRIZ' as codigo_filial,'' as filial,
sum(total_vendas.total_venda) as total_venda,sum(total_vendas.vales_recebidos) as vales_recebidos,
sum(venda_vale.vales_vendidos),sum(isnull(cartoes.valor_cartao,0)) as valor_cartao,
sum(troca.total_troca) as total_troca,sum(isnull(leitura_z.total_bruto,0)) as valor_reducao
from

(select a.codigo_filial,a.filial 
from lojas_varejo a 
where a.codigo_filial in 
		('002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038',
        '039','040','041','042','043','044','045','046','047','048','049','050','051','052') ) lojas  

left join 

( select a.codigo_filial ,c.filial,b.valor_cartao
	from 
	(select a.codigo_filial,
		sum(a.valor_ticket_sem_vale)  as valor_venda  
		from wanm_vendas_loja_full a 
		where a.data_venda between @data_ini and @data_fim  
		and a.codigo_filial in 
		('002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','017','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038','039','040','041','042','043',
		'044','045','046','047','048','049','050','051','052')
		group by a.codigo_filial ) a 
	join 
	(select a.codigo_filial,
		sum(case 
				when c.tipo_pgto in ('A','E','I','K') 
				then c.valor
			else 0 end) as valor_cartao,
		sum(case 
				when c.tipo_pgto not in ('A','B','E','I','K','R','X','V') 
				then c.valor
			else 0 end) as valor_chequedin
		 from wanm_vendas_loja_full a 
		join loja_venda_pgto b 
		on  a.codigo_filial=b.codigo_filial 
		and a.terminal=b.terminal 
		and a.lancamento_caixa=b.lancamento_caixa 
		join loja_venda_parcelas c 
		on  a.codigo_filial=c.codigo_filial 
		and a.terminal=c.terminal 
		and a.lancamento_caixa=c.lancamento_caixa 
		where a.data_venda between @data_ini and @data_fim 
		and a.codigo_filial in 
		('001','002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','017','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038','039','040','041','042','043',
		'044','045','046','047','048','049','050','051','052')
		group by a.codigo_filial) b 
	on a.codigo_filial=b.codigo_filial
	join lojas_varejo c 
	on a.codigo_filial=c.codigo_filial ) cartoes 
on lojas.codigo_filial=cartoes.codigo_filial 

join filiais 
on cartoes.filial=filiais.filial 

left join
(select codigo_filial, sum(valor_troca) as total_troca
from loja_venda 
where valor_troca>'0.00'
and data_venda between @data_ini and @data_fim 
and ticket not like '%p%'
and ticket not like '%v%'
group by codigo_filial ) troca
on lojas.codigo_filial=troca.codigo_filial

left join 
( select codigo_filial, sum(total_bruto-(total_cancelado+total_desconto))  as total_bruto
from loja_controle_fiscal 
where data_fiscal between @data_ini and @data_fim  
group by codigo_filial  ) leitura_z
on lojas.codigo_filial=leitura_z.codigo_filial

left join 
( select codigo_filial, sum(valor_ticket_sem_vale)  as total_venda ,
sum(valor_vale_recebido)  as vales_recebidos
from wanm_vendas_loja_full  
where data_venda between @data_ini and @data_fim  
group by codigo_filial ) total_vendas
on lojas.codigo_filial=total_vendas.codigo_filial

left join
( select a.codigo_filial,sum(b.preco_liquido) as vales_vendidos
from loja_venda a 
join loja_venda_produto b 
on a.codigo_filial=b.codigo_filial 
and a.data_venda=b.data_venda 
and a.ticket=b.ticket 
join lojas_varejo c 
on a.codigo_filial=c.codigo_filial 
where 
b.produto='99.99.9999' 
and a.data_venda between @data_ini and @data_fim 
group by a.codigo_filial ) venda_vale
on lojas.codigo_filial=venda_vale.codigo_filial
group by matriz


--TOTAL GERAL --
union all

select 'TOTAL GERAL' as matriz,'' as codigo_filial,'' as filial,
sum(total_vendas.total_venda) as total_venda,sum(total_vendas.vales_recebidos) as vales_recebidos,
sum(venda_vale.vales_vendidos),sum(isnull(cartoes.valor_cartao,0)) as valor_cartao,
sum(troca.total_troca) as total_troca,sum(isnull(leitura_z.total_bruto,0)) as valor_reducao
from

(select a.codigo_filial,a.filial 
from lojas_varejo a 
where a.codigo_filial in 
		('002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038',
        '039','040','041','042','043','044','045','046','047','048','049','050','051','052') ) lojas  

left join 

( select a.codigo_filial ,c.filial,b.valor_cartao
	from 
	(select a.codigo_filial,
		sum(a.valor_ticket_sem_vale)  as valor_venda  
		from wanm_vendas_loja_full a 
		where a.data_venda between @data_ini and @data_fim  
		and a.codigo_filial in 
		('002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','017','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038','039','040','041','042','043',
		'044','045','046','047','048','049','050','051','052')
		group by a.codigo_filial ) a 
	join 
	(select a.codigo_filial,
		sum(case 
				when c.tipo_pgto in ('A','E','I','K') 
				then c.valor
			else 0 end) as valor_cartao,
		sum(case 
				when c.tipo_pgto not in ('A','B','E','I','K','R','X','V') 
				then c.valor
			else 0 end) as valor_chequedin
		 from wanm_vendas_loja_full a 
		join loja_venda_pgto b 
		on  a.codigo_filial=b.codigo_filial 
		and a.terminal=b.terminal 
		and a.lancamento_caixa=b.lancamento_caixa 
		join loja_venda_parcelas c 
		on  a.codigo_filial=c.codigo_filial 
		and a.terminal=c.terminal 
		and a.lancamento_caixa=c.lancamento_caixa 
		where a.data_venda between @data_ini and @data_fim 
		and a.codigo_filial in 
		('001','002','003','004','005','006','007','008','009','010','011','012','013',   
		'014','015','016','017','018','019','020','021','022','023','024','025','026',   
		'027','028','029','030','031','032','033','034','035','036','037','038','039','040','041','042','043',
		'044','045','046','047','048','049','050','051','052')
		group by a.codigo_filial) b 
	on a.codigo_filial=b.codigo_filial
	join lojas_varejo c 
	on a.codigo_filial=c.codigo_filial ) cartoes 
on lojas.codigo_filial=cartoes.codigo_filial 

join filiais 
on cartoes.filial=filiais.filial 

left join
(select codigo_filial, sum(valor_troca) as total_troca
from loja_venda 
where valor_troca>'0.00'
and data_venda between @data_ini and @data_fim 
and ticket not like '%p%'
and ticket not like '%v%'
group by codigo_filial ) troca
on lojas.codigo_filial=troca.codigo_filial

left join 
( select codigo_filial, sum(total_bruto-(total_cancelado+total_desconto))  as total_bruto
from loja_controle_fiscal 
where data_fiscal between @data_ini and @data_fim  
group by codigo_filial  ) leitura_z
on lojas.codigo_filial=leitura_z.codigo_filial

left join 
( select codigo_filial, sum(valor_ticket_sem_vale)  as total_venda ,
sum(valor_vale_recebido)  as vales_recebidos
from wanm_vendas_loja_full  
where data_venda between @data_ini and @data_fim  
group by codigo_filial ) total_vendas
on lojas.codigo_filial=total_vendas.codigo_filial

left join
( select a.codigo_filial,sum(b.preco_liquido) as vales_vendidos
from loja_venda a 
join loja_venda_produto b 
on a.codigo_filial=b.codigo_filial 
and a.data_venda=b.data_venda 
and a.ticket=b.ticket 
join lojas_varejo c 
on a.codigo_filial=c.codigo_filial 
where 
b.produto='99.99.9999' 
and a.data_venda between @data_ini and @data_fim 
group by a.codigo_filial ) venda_vale
on lojas.codigo_filial=venda_vale.codigo_filial
ORDER BY MATRIZ,CODIGO_FILIAL


ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\Total_vendas_cartao_reducao_z.XLS XLS 