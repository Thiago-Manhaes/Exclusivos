

****EXPORTA CLIENTES ABRAND****************************

TEXT TO XSEL NOSHOW TEXTMERGE

select	a.nome_clifor as filial,a.cgc_cpf as cnpj,
ltrim(rtrim(a.endereco))+convert(varchar(20),ltrim(rtrim(isnull(', Nº '+a.numero,''))))
+convert(varchar(20),ltrim(rtrim(isnull(' - '+a.complemento,'')))) as endereco,
a.bairro,a.cep,a.cidade,a.uf 
from cadastro_cli_for a
join filiais b
on a.nome_clifor = b.filial
where b.tipo_filial = 'loja varejo'
and a.uf in ('rj','sp')
order by a.uf


ENDTEXT 

F_SELECT(XSEL,"CUR_EXPORTA")

SELE CUR_EXPORTA
COPY TO C:\TEMP\CADASTRO_FILIAIS.XLS XLS 