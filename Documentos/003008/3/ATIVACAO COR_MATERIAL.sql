update b set b.INATIVO = 0
from estoque_materiais a
join materiais_cores b
on a.material = b.material 
and a.cor_material = b.cor_material
join prop_materiais c
on a.material = c.material
and c.PROPRIEDADE = '01004'
where  c.VALOR_PROPRIEDADE = 1
AND A.QTDE_ESTOQUE > 0
and b.INATIVO = 1
