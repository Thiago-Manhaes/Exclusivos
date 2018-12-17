insert into prop_produtos
(PROPRIEDADE, ITEM_PROPRIEDADE, VALOR_PROPRIEDADE, DATA_PARA_TRANSFERENCIA, PRODUTO)

select B.PROPRIEDADE, A.ITEM_PROPRIEDADE, A.VALOR_PROPRIEDADE, GETDATE(), ltrim(rtrim(PRODUTO)) from tmp_00333 a
join PROPRIEDADE b
on a.propriedade_novo = b.PROPRIEDADE 