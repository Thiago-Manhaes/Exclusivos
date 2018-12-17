
text to xsel noshow textmerge 

	declare @data_ini datetime
	declare @data_fim datetime

	select @data_ini ='20110101'
	select @data_fim ='20111031'

	select 
	convert(varchar(10),case 
		when month(a.data_venda)=1  then 'JANEIRO' 
		when month(a.data_venda)=2  then 'FEVEREIRO' 
		when month(a.data_venda)=3  then 'MARÇO' 
		when month(a.data_venda)=4  then 'ABRIL' 
		when month(a.data_venda)=5  then 'MAIO' 
		when month(a.data_venda)=6  then 'JUNHO' 
		when month(a.data_venda)=7  then 'JULHO' 
		when month(a.data_venda)=8  then 'AGOSTO' 
		when month(a.data_venda)=9  then 'SETEMBRO' 
		when month(a.data_venda)=10 then 'OUTUBRO' 
		when month(a.data_venda)=11 then 'NOVEMBRO' 
		when month(a.data_venda)=12 then 'DEZEMBRO' 
	end) as mes_venda,
	a.codigo_filial,e.filial,c.tipo_pgto,d.desc_tipo_pgto,f.administradora,
	sum(valor) as valor ,count(c.lancamento_caixa) as qtde_documentos,
	case when c.tipo_pgto in ('C','P') then count(c.lancamento_caixa) else 0 end  as qtde_cheques
	from loja_venda a 
	join loja_venda_pgto b 
	on  a.codigo_filial=b.codigo_filial
	and a.terminal=b.terminal 
	and a.lancamento_caixa=b.lancamento_caixa 
	join loja_venda_parcelas c 
	on  a.codigo_filial=c.codigo_filial
	and a.terminal=c.terminal 
	and a.lancamento_caixa=c.lancamento_caixa 
	join tipos_pgto d 
	on c.tipo_pgto=d.tipo_pgto 
	join lojas_varejo e 
	on a.codigo_filial=e.codigo_filial 
	left join administradoras_cartao f 
	on c.codigo_administradora=f.codigo_administradora
	where a.data_venda between @data_ini and @data_fim 
	and  c.valor<>0
	group by month(a.data_venda),a.codigo_filial,e.filial,c.tipo_pgto,d.desc_tipo_pgto,f.administradora 
	order by month(a.data_venda),a.codigo_filial,c.tipo_pgto,f.administradora

endtext 

f_select(xsel,"curExpPag")

sele curExpPag 

copy to c:\temp\ExpPag.xls xls