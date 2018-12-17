update b set b.colecao = a.colecao
from [192.168.9.4].SOMA_BKP.dbo.tmp_colecao_farm a
join produtos b
on a.produto = b.produto
