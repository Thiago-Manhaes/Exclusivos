
xFILIAL = 'RIO SUL'

****EXPORTA CLIENTES ANIMALE ****************************

TEXT TO XSEL NOSHOW TEXTMERGE


	SELECT DISTINCT * FROM
	(select cli_var.cpf_cgc,cli_var.cliente_varejo,cli_var.email,cli_var.tipo_logradouro,cli_var.endereco,cli_var.numero,
	cli_var.complemento,cli_var.bairro,cli_var.cep,cli_var.cidade,cli_var.uf,cli_var.ddd,cli_var.celular,cli_var.telefone,
	cli_var.aniversario,cli_var.filial as FILIAL_CADASTRO,
	
	case when month(aniversario) > month(getdate()) then (year(getdate())-year(aniversario)) - 1
	else year(getdate())-year(aniversario) end as idade, 
	
                (select count(a.ticket) from loja_venda a join loja_venda_produto b 
                 on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                 join produtos d on b.produto=d.produto where a.codigo_cliente = cli_var.codigo_cliente ) as qtde_ticket,

	(select sum(valor_pago) from loja_venda a join loja_venda_produto b 
                 on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                 join produtos d on b.produto=d.produto  where a.codigo_cliente = cli_var.codigo_cliente ) as total_compra,
	
	isnull((select sum(valor_pago) from loja_venda a join loja_venda_produto b 
                          on a.codigo_filial=b.codigo_filial  and a.data_venda=b.data_venda and a.ticket=b.ticket 
                          join produtos d on b.produto=d.produto where   a.codigo_cliente = cli_var.codigo_cliente and month(a.data_venda) >= month(getdate()) and year(a.data_venda) >= '2012'),0) as ultimos_12_meses,
	
	case when ( select filial from 
				(select top 3 a.* from loja_venda a join loja_venda_produto c
				on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
				join produtos d on c.produto=d.produto
				where codigo_cliente = cli_var.codigo_cliente order by a.data_venda desc) a 
				join lojas_varejo b
				on a.codigo_filial = b.codigo_filial 
				where filial <> 'FEIRINHA'
				group by filial 
				having count(b.filial) > 2) is null 
    then (select top 1 filial  from loja_venda  a join lojas_varejo b on a.codigo_filial = b.codigo_filial
		  join loja_venda_produto c on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
          join produtos d on c.produto=d.produto
		  where codigo_cliente = cli_var.codigo_cliente and filial <> 'FEIRINHA' 
		  group by filial order by count(b.filial) desc )
    else (select filial from 
				(select top 3 a.* from loja_venda a join loja_venda_produto c
				on a.codigo_filial=c.codigo_filial  and a.data_venda=c.data_venda and a.ticket=c.ticket 
				join produtos d on c.produto=d.produto
				where codigo_cliente = cli_var.codigo_cliente order by a.data_venda desc) a 
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
	where b.data_venda >= '20120101') A

where 	Preferencia = '<<xFILIAL>>'


ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")


SELECT CLIENTE_VAREJO,CPF_CGC,DDD,ALLT(STRTRAN(CELULAR,'-','')) AS CELULAR ,PREFERENCIA FROM CUR_EXPORTA WHERE !F_VAZIO(CELULAR) AND LEN(ALLT(STRTRAN(CELULAR,'-',''))) >= 8  INTO CURSOR CUR_EXPORTA_SMS
SELECT CLIENTE_VAREJO,CPF_CGC,LOWER(EMAIL) AS EMAIL,PREFERENCIA FROM CUR_EXPORTA WHERE !F_VAZIO(EMAIL) AND '@' $ EMAIL AND '.COM' $ EMAIL AND  !'ANIMALE' $ EMAIL  INTO CURSOR CUR_EXPORTA_EMKT
SELECT CLIENTE_VAREJO,CPF_CGC,DDD,TELEFONE  FROM CUR_EXPORTA WHERE F_VAZIO(CELULAR) AND LEN(ALLT(STRTRAN(CELULAR,'-',''))) < 8 AND  F_VAZIO(EMAIL) AND ( ! '@' $ EMAIL OR ! '.COM' $ EMAIL) AND  !'ANIMALE' $ EMAIL;
INTO CURSOR CUR_EXPORTA_TLMKT

SELE CUR_EXPORTA_SMS
COPY TO C:\TEMP\CLIENTES_SMS.XLS XLS 

SELE CUR_EXPORTA_EMKT
COPY TO C:\TEMP\CLIENTES_EMKT.XLS XLS 

SELE CUR_EXPORTA_TLMKT
IF RECCOUNT() > 0
  COPY TO C:\TEMP\CLIENTES_TLMK.XLS XLS 
ENDIF

