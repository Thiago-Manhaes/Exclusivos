UPDATE B SET B.CUSTO_A_VISTA = A.CUSTO_MEDIO_UNIT, B.CUSTO_REPOSICAO = a.CUSTO_MEDIO_UNIT
from 
(SELECT distinct A.MATERIAL, B.COR_MATERIAL, B.CUSTO_A_VISTA AS CUSTO_MP, 
CASE WHEN C.CUSTO_MEDIO_UNIT = 0 THEN cast(1/A.QTDE_ESTOQUE as numeric(15,5)) ELSE cast(C.CUSTO_MEDIO_UNIT as numeric(15,5)) END AS CUSTO_MEDIO_UNIT
FROM ESTOQUE_MATERIAIS A
JOIN MATERIAIS_CORES B
ON A.MATERIAL = B.MATERIAL
AND A.COR_MATERIAL = B.COR_MATERIAL
JOIN (select distinct MATERIAL, MAX(CUSTO_MEDIO_UNITARIO) AS CUSTO_MEDIO_UNIT from CM_ESTOQUE_MP  
where data_saldo = '20151231'
and COD_CUSTO_MEDIO like '%mp%'
GROUP BY MATERIAL) C
ON A.MATERIAL = C.MATERIAL
WHERE A.QTDE_ESTOQUE > 0
AND B.CUSTO_A_VISTA = 0
) a
join materiais_cores b
on a.MATERIAL = b.MATERIAL
and a.COR_MATERIAL = b.COR_MATERIAL
join materiais c
on b.material = c.material
order by c.DATA_CADASTRAMENTO desc