TEXT TO XSEL NOSHOW TEXTMERGE
declare @data_ini datetime
declare @data_fim datetime
select @data_ini='20110401'
select @data_fim='20110417'


select lojas.codigo_filial,lojas.filial,total_vendas.total_venda,
isnull(cartoes.valor_cartao,0) as valor_cartao, 
isnull(leitura_z.total_bruto,0) as valor_reducao,
isnull(cartoes.valor_cartao,0)-isnull(leitura_z.total_bruto,0) as diferenca 
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

left join 
( select codigo_filial, sum(total_bruto-total_cancelado)  as total_bruto
from loja_controle_fiscal 
where data_fiscal between @data_ini and @data_fim  
group by codigo_filial  ) leitura_z
on lojas.codigo_filial=leitura_z.codigo_filial
join 
( select codigo_filial, sum(valor_ticket_sem_vale)  as total_venda 
from wanm_vendas_loja_full  
where data_venda between @data_ini and @data_fim  
group by codigo_filial ) total_vendas
on lojas.codigo_filial=total_vendas.codigo_filial

order by codigo_filial

ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\Total_cartao_x_reducaoZ.XLS XLS 