
****EXPORTA CLIENTES ANIMALE ****************************

TEXT TO XSEL_ANIMALE NOSHOW TEXTMERGE


	SELECT DISTINCT * FROM
	(select cli_var.cpf_cgc,cli_var.cliente_varejo,cli_var.email,cli_var.tipo_logradouro,cli_var.endereco,cli_var.numero,
	cli_var.complemento,cli_var.bairro,cli_var.cep,cli_var.cidade,cli_var.uf,cli_var.ddd,cli_var.celular,cli_var.telefone,
	cli_var.aniversario,cli_var.filial as FILIAL_CADASTRO,
	
	case when month(aniversario) > month(getdate()) then (year(getdate())-year(aniversario)) - 1
	else year(getdate())-year(aniversario) end as idade, 
	
                (select count(a.ticket) from loja_venda a join loja_venda_produto b 
                 on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                 join produtos d on b.produto=d.produto where a.codigo_cliente = cli_var.codigo_cliente and d.anm_marca = 'ANIMALE') as qtde_ticket,

	(select sum(valor_pago) from loja_venda a join loja_venda_produto b 
                 on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                 join produtos d on b.produto=d.produto  where a.codigo_cliente = cli_var.codigo_cliente and d.anm_marca = 'ANIMALE') as total_compra,
	
	isnull((select sum(valor_pago) from loja_venda a join loja_venda_produto b 
                          on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                          join produtos d on b.produto=d.produto where  d.anm_marca = 'ANIMALE' and a.codigo_cliente = cli_var.codigo_cliente and month(a.data_venda) >= month(getdate()) and year(a.data_venda) >= '2012'),0) as ultimos_12_meses,
	
	case when ( select filial from 
				(select top 3 a.* from loja_venda a join loja_venda_produto c
				on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
				join produtos d on c.produto=d.produto
				where d.anm_marca = 'ANIMALE' and codigo_cliente = cli_var.codigo_cliente order by a.data_venda desc) a 
				join lojas_varejo b
				on a.codigo_filial = b.codigo_filial 
				where filial <> 'FEIRINHA'
				group by filial 
				having count(b.filial) > 2) is null 
    then (select top 1 filial  from loja_venda  a join lojas_varejo b on a.codigo_filial = b.codigo_filial
		  join loja_venda_produto c on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
          join produtos d on c.produto=d.produto
		  where codigo_cliente = cli_var.codigo_cliente and filial <> 'FEIRINHA' and d.anm_marca = 'ANIMALE'
		  group by filial order by count(b.filial) desc )
    else (select filial from 
				(select top 3 a.* from loja_venda a join loja_venda_produto c
				on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
				join produtos d on c.produto=d.produto
				where d.anm_marca = 'ANIMALE' and codigo_cliente = cli_var.codigo_cliente order by a.data_venda desc) a 
				join lojas_varejo b
				on a.codigo_filial = b.codigo_filial 
				where filial <> 'FEIRINHA'
				group by filial 
				having count(b.filial) > 2) 
    end as Preferencia 
               
	from clientes_varejo cli_var join loja_venda b 
	on cli_var.codigo_cliente=b.codigo_cliente 
	join loja_venda_produto c 
	on b.codigo_filial=c.codigo_filial  and b.data_venda=c.data_venda and b.ticket=c.ticket 
	join produtos d 
	on c.produto=d.produto
	where d.anm_marca = 'ANIMALE' ) A


ENDTEXT 


****EXPORTA CLIENTES A.BRAND ****************************

TEXT TO XSEL_ABRAND NOSHOW TEXTMERGE


	SELECT DISTINCT * FROM
	(select cli_var.cpf_cgc,cli_var.cliente_varejo,cli_var.email,cli_var.tipo_logradouro,cli_var.endereco,cli_var.numero,
	cli_var.complemento,cli_var.bairro,cli_var.cep,cli_var.cidade,cli_var.uf,cli_var.ddd,cli_var.celular,cli_var.telefone,
	cli_var.aniversario,cli_var.filial as FILIAL_CADASTRO,
	
	case when month(aniversario) > month(getdate()) then (year(getdate())-year(aniversario)) - 1
	else year(getdate())-year(aniversario) end as idade, 
	
	 (select count(a.ticket) from loja_venda a join loja_venda_produto b 
                 on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                 join produtos d on b.produto=d.produto where a.codigo_cliente = cli_var.codigo_cliente and d.anm_marca = 'A.BRAND') as qtde_ticket,

	(select sum(valor_pago) from loja_venda a join loja_venda_produto b 
                 on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                 join produtos d on b.produto=d.produto  where a.codigo_cliente = cli_var.codigo_cliente and d.anm_marca = 'A.BRAND') as total_compra,
	
	isnull((select sum(valor_pago) from loja_venda a join loja_venda_produto b 
                          on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                          join produtos d on b.produto=d.produto where  d.anm_marca = 'A.BRAND' and a.codigo_cliente = cli_var.codigo_cliente and month(a.data_venda) >= month(getdate()) and year(a.data_venda) >= '2012'),0) as ultimos_12_meses,
	
	case when ( select filial from 
				(select top 3 a.* from loja_venda a join loja_venda_produto c
				on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
				join produtos d on c.produto=d.produto
				where d.anm_marca = 'A.BRAND' and codigo_cliente = cli_var.codigo_cliente order by a.data_venda desc) a 
				join lojas_varejo b
				on a.codigo_filial = b.codigo_filial 
				where filial <> 'FEIRINHA'
				group by filial 
				having count(b.filial) > 2) is null 
    then (select top 1 filial  from loja_venda  a join lojas_varejo b on a.codigo_filial = b.codigo_filial
		  join loja_venda_produto c on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
          join produtos d on c.produto=d.produto
		  where codigo_cliente = cli_var.codigo_cliente and filial <> 'FEIRINHA' and d.anm_marca = 'A.BRAND'
		  group by filial order by count(b.filial) desc )
    else (select filial from 
				(select top 3 a.* from loja_venda a join loja_venda_produto c
				on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
				join produtos d on c.produto=d.produto
				where d.anm_marca = 'A.BRAND' and codigo_cliente = cli_var.codigo_cliente order by a.data_venda desc) a 
				join lojas_varejo b
				on a.codigo_filial = b.codigo_filial 
				where filial <> 'FEIRINHA'
				group by filial 
				having count(b.filial) > 2) 
    end as Preferencia 
               
	from clientes_varejo cli_var join loja_venda b 
	on cli_var.codigo_cliente=b.codigo_cliente 
	join loja_venda_produto c 
	on b.codigo_filial=c.codigo_filial  and b.data_venda=c.data_venda and b.ticket=c.ticket 
	join produtos d 
	on c.produto=d.produto
	where d.anm_marca = 'A.BRAND' ) A


ENDTEXT 


****EXPORTA CLIENTES FYI ****************************

TEXT TO XSEL_FYI NOSHOW TEXTMERGE


	SELECT DISTINCT * FROM
	(select cli_var.cpf_cgc,cli_var.cliente_varejo,cli_var.email,cli_var.tipo_logradouro,cli_var.endereco,cli_var.numero,
	cli_var.complemento,cli_var.bairro,cli_var.cep,cli_var.cidade,cli_var.uf,cli_var.ddd,cli_var.celular,cli_var.telefone,
	cli_var.aniversario,cli_var.filial as FILIAL_CADASTRO,
	
	case when month(aniversario) > month(getdate()) then (year(getdate())-year(aniversario)) - 1
	else year(getdate())-year(aniversario) end as idade, 
	
	(select count(a.ticket) from loja_venda a join loja_venda_produto b 
                 on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                 join produtos d on b.produto=d.produto where a.codigo_cliente = cli_var.codigo_cliente and d.anm_marca = 'F.Y.I') as qtde_ticket,

	(select sum(valor_pago) from loja_venda a join loja_venda_produto b 
                 on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                 join produtos d on b.produto=d.produto  where a.codigo_cliente = cli_var.codigo_cliente and d.anm_marca = 'F.Y.I') as total_compra,
	
	isnull((select sum(valor_pago) from loja_venda a join loja_venda_produto b 
                          on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                          join produtos d on b.produto=d.produto where  d.anm_marca = 'F.Y.I' and a.codigo_cliente = cli_var.codigo_cliente and month(a.data_venda) >= month(getdate()) and year(a.data_venda) >= '2012'),0) as ultimos_12_meses,
	
	case when ( select filial from 
				(select top 3 a.* from loja_venda a join loja_venda_produto c
				on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
				join produtos d on c.produto=d.produto
				where d.anm_marca = 'F.Y.I' and codigo_cliente = cli_var.codigo_cliente order by a.data_venda desc) a 
				join lojas_varejo b
				on a.codigo_filial = b.codigo_filial 
				where filial <> 'FEIRINHA'
				group by filial 
				having count(b.filial) > 2) is null 
    then (select top 1 filial  from loja_venda  a join lojas_varejo b on a.codigo_filial = b.codigo_filial
		  join loja_venda_produto c on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
          join produtos d on c.produto=d.produto
		  where codigo_cliente = cli_var.codigo_cliente and filial <> 'FEIRINHA' and d.anm_marca = 'F.Y.I'
		  group by filial order by count(b.filial) desc )
    else (select filial from 
				(select top 3 a.* from loja_venda a join loja_venda_produto c
				on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
				join produtos d on c.produto=d.produto
				where d.anm_marca = 'F.Y.I' and codigo_cliente = cli_var.codigo_cliente order by a.data_venda desc) a 
				join lojas_varejo b
				on a.codigo_filial = b.codigo_filial 
				where filial <> 'FEIRINHA'
				group by filial 
				having count(b.filial) > 2) 
    end as Preferencia 
               
	from clientes_varejo cli_var join loja_venda b 
	on cli_var.codigo_cliente=b.codigo_cliente 
	join loja_venda_produto c 
	on b.codigo_filial=c.codigo_filial  and b.data_venda=c.data_venda and b.ticket=c.ticket 
	join produtos d 
	on c.produto=d.produto
	where d.anm_marca = 'F.Y.I' ) A


ENDTEXT 

F_SELECT(XSEL_ANIMALE,"CUR_EXPORTA_ANIMALE")
F_SELECT(XSEL_FYI,"CUR_EXPORTA_FYI")
F_SELECT(XSEL_ABRAND,"CUR_EXPORTA_ABRAND")

SELE CUR_EXPORTA_ANIMALE
COPY TO C:\TEMP\CLIENTES_ANIMALE.XLS XLS 

SELE CUR_EXPORTA_FYI
COPY TO C:\TEMP\CLIENTES_FYI.XLS XLS 

SELE CUR_EXPORTA_ABRAND
COPY TO C:\TEMP\CLIENTES_ABRAND.XLS XLS 