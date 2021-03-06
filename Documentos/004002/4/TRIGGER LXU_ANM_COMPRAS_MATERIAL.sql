/****** Object:  Trigger [dbo].[LXU_ANM_COMPRAS_MATERIAL]    Script Date: 24/11/2016 15:37:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER TRIGGER [dbo].[LXU_ANM_COMPRAS_MATERIAL] 
ON [dbo].[COMPRAS_MATERIAL]
FOR UPDATE NOT FOR REPLICATION 
AS
BEGIN
	declare  @numrows int,
             @nullcnt int,
             @validcnt int,
             @errno int,
             @errmsg  varchar(255), 
             @MATERIAL_NO_REDE VARCHAR(MAX)='',
             @MATERIAL_NO_REDE_FILIAL VARCHAR(MAX)='',
			 @feriado varchar(255)
             
     SELECT @MATERIAL_NO_REDE=@MATERIAL_NO_REDE+A.MATERIAL+' - '+RTRIM(LTRIM(VALOR_PROPRIEDADE))+CHAR(13) 
     FROM inserted A
		JOIN PROP_MATERIAIS B ON A.MATERIAL = B.MATERIAL 
		AND LEFT(LTRIM(B.VALOR_PROPRIEDADE),1) NOT IN (SELECT CONVERT(CHAR(6),VALOR_PROPRIEDADE) AS REDE_LOJAS 
		                                               FROM WPROPUSERS WHERE PROPRIEDADE='01000' AND USUARIO=SYSTEM_USER)
	 WHERE B.PROPRIEDADE = '01004' 	
	 GROUP BY A.MATERIAL,VALOR_PROPRIEDADE	        
  
    if @MATERIAL_NO_REDE <> ''
	
	begin
      select @errno  = 30007,
             @errmsg = 'Impossível Salvar, você não tem permissão de comprar os sequintes materiais:'+CHAR(13)+CHAR(13)+'Material - Rede de Loja'+CHAR(13)+CHAR(13)+@MATERIAL_NO_REDE
      goto error
    end
	

	SELECT @MATERIAL_NO_REDE_FILIAL=@MATERIAL_NO_REDE_FILIAL+A.MATERIAL+' - '+RTRIM(LTRIM(B.VALOR_PROPRIEDADE))+CHAR(13)  
	FROM inserted A
		JOIN PROP_MATERIAIS B ON A.MATERIAL = B.MATERIAL 
		JOIN COMPRAS C ON A.PEDIDO = C.PEDIDO
		JOIN FILIAIS D ON C.FILIAL_A_ENTREGAR = D.FILIAL
	WHERE B.PROPRIEDADE = '01004' AND 
	( LEFT(LTRIM(B.VALOR_PROPRIEDADE),1) <> LEFT(LTRIM(D.REDE_LOJAS),1) AND
	  LEFT(LTRIM(B.VALOR_PROPRIEDADE),1) NOT IN (SELECT REDE_PARA FROM WANM_REDE_LOJAS_AGRUP WHERE REDE_DE = LEFT(LTRIM(D.REDE_LOJAS),1) )
	)  	 AND D.REDE_LOJAS <> '9'
	GROUP BY A.MATERIAL,B.VALOR_PROPRIEDADE
	
	if @MATERIAL_NO_REDE_FILIAL <> ''
			 
    begin
      select @errno  = 30007,
             @errmsg = 'Impossível Salvar, existem materiais com a rede de loja diferente da filial a entregar.'+CHAR(13)+CHAR(13)+'Material - Rede de Loja'+CHAR(13)+CHAR(13)+@MATERIAL_NO_REDE_FILIAL
      goto error
    end
 
----------------------------------------------------------------


		DECLARE @xPedido Char(8), @xMaterial Char(11) , @xCor_Material Char(10)
		
		DECLARE Cur_CALCULA_PROC_CONSUMO CURSOR
		FOR SELECT Distinct PEDIDO,MATERIAL,COR_MATERIAL FROM Inserted
			
    
		OPEN Cur_CALCULA_PROC_CONSUMO

		FETCH NEXT FROM Cur_CALCULA_PROC_CONSUMO INTO @xPedido, @xMaterial, @xCor_Material

		DELETE FROM ANM_COMPRAS_MATERIAL_RATEIO_PROP WHERE PEDIDO = @xPedido	  

		WHILE (@@Fetch_Status = 0)
			BEGIN      
				
				INSERT INTO ANM_COMPRAS_MATERIAL_RATEIO_PROP

				SELECT PEDIDO,MATERIAL,COR_MATERIAL,PROGRAMACAO,PRODUTO,SUM(TOT_PROG_ORI) AS TOT_PROG_ORI,
				SUM(QTDE_PROG) AS QTDE_PROG,SUM(PORC_CONSUMO) AS PORC_CONSUMO
				FROM 
				(SELECT @xPedido AS PEDIDO, A.*,
				       CONVERT(NUMERIC(6,3),(QTDE_PROG/  
						 CASE WHEN QTDE_PROG_TOTAL=0 THEN 1 ELSE QTDE_PROG_TOTAL END )*100) AS PORC_CONSUMO 
			    FROM  
  
				(SELECT PRODUTOS_FICHA.MATERIAL, PRODUTOS_FICHA_COR.COR_MATERIAL, E.PROGRAMACAO AS PROGRAMACAO ,
				        PRODUTOS.PRODUTO,  QTDE_PROGRAMADA AS TOT_PROG_ORI,  
  
						CONVERT(NUMERIC(14,3),   
						 SUM((( PRODUTOS_FICHA.C1*QTDE_PROGRAMADA ) * (PRODUTOS_FICHA_COR.PORCENTAGEM_CONSUMO/100) )  
							 /MATERIAIS.FATOR_CONVERSAO ) ) AS QTDE_PROG  
      
				FROM  PRODUTOS_FICHA (NOLOCK)   , PRODUTOS          (NOLOCK),     
				PRODUTOS_FICHA_COR   (NOLOCK)   , MATERIAIS         (NOLOCK),    
				PRODUCAO_PROG_PROD   (NOLOCK) D , PRODUCAO_PROGRAMA (NOLOCK) E   
				WHERE  PRODUTOS_FICHA.PRODUTO  = PRODUTOS.PRODUTO      AND        
				PRODUTOS_FICHA.PRODUTO  = PRODUTOS_FICHA_COR.PRODUTO   AND      
				PRODUTOS_FICHA.MATERIAL = PRODUTOS_FICHA_COR.MATERIAL  AND     
				PRODUTOS_FICHA.ITEM     = PRODUTOS_FICHA_COR.ITEM      AND          
				PRODUTOS_FICHA.MATERIAL = MATERIAIS.MATERIAL           AND        
				PRODUTOS_FICHA_COR.PRODUTO     = D.PRODUTO             AND          
				PRODUTOS_FICHA_COR.COR_PRODUTO = D.COR_PRODUTO         AND         
				D.PROGRAMACAO=E.PROGRAMACAO                            AND 
				PRODUTOS_FICHA.MATERIAL = @xMaterial                   AND 
				COR_MATERIAL = @xCor_Material                          AND   
  
				PRODUTOS.PRODUTO IN  ( SELECT DISTINCT B.VALOR_PROPRIEDADE FROM PROP_COMPRAS (NOLOCK) B   
									   WHERE  B.PROPRIEDADE = '01021' AND B.PEDIDO = @xPedido  ) AND   
                E.PROGRAMACAO IN ( SELECT DISTINCT A.VALOR_PROPRIEDADE FROM PROP_COMPRAS (NOLOCK) A    
                                   WHERE A.PROPRIEDADE = '01020'  AND A.PEDIDO = @xPedido  )  
  
				GROUP BY PRODUTOS_FICHA.MATERIAL, PRODUTOS_FICHA_COR.COR_MATERIAL, E.PROGRAMACAO,PRODUTOS.PRODUTO,QTDE_PROGRAMADA ) A  
  
				JOIN  

			  ( SELECT PRODUTOS_FICHA.MATERIAL, PRODUTOS_FICHA_COR.COR_MATERIAL, 
				  
					CONVERT(NUMERIC(14,3),   
					 SUM((( PRODUTOS_FICHA.C1*QTDE_PROGRAMADA ) * (PRODUTOS_FICHA_COR.PORCENTAGEM_CONSUMO/100) )  
						 /MATERIAIS.FATOR_CONVERSAO ) )  AS QTDE_PROG_TOTAL  
				      
					FROM  PRODUTOS_FICHA(NOLOCK) , PRODUTOS(NOLOCK),     
					PRODUTOS_FICHA_COR(NOLOCK),  MATERIAIS(NOLOCK),    
					PRODUCAO_PROG_PROD(NOLOCK) D , PRODUCAO_PROGRAMA(NOLOCK) E   
					WHERE  PRODUTOS_FICHA.PRODUTO  = PRODUTOS.PRODUTO AND        
					PRODUTOS_FICHA.PRODUTO  = PRODUTOS_FICHA_COR.PRODUTO  AND      
					PRODUTOS_FICHA.MATERIAL = PRODUTOS_FICHA_COR.MATERIAL  AND     
					PRODUTOS_FICHA.ITEM     = PRODUTOS_FICHA_COR.ITEM  AND          
					PRODUTOS_FICHA.MATERIAL = MATERIAIS.MATERIAL                  AND        
					PRODUTOS_FICHA_COR.PRODUTO     = D.PRODUTO      AND          
					PRODUTOS_FICHA_COR.COR_PRODUTO = D.COR_PRODUTO     AND         
					D.PROGRAMACAO=E.PROGRAMACAO                 AND 
					PRODUTOS_FICHA.MATERIAL = @xMaterial          AND COR_MATERIAL = @xCor_Material    AND   
				    PRODUTOS.PRODUTO IN    ( SELECT DISTINCT B.VALOR_PROPRIEDADE FROM PROP_COMPRAS (NOLOCK) B   
										     WHERE  B.PROPRIEDADE = '01021' AND B.PEDIDO = @xPedido  ) AND   
				    E.PROGRAMACAO IN ( SELECT DISTINCT A.VALOR_PROPRIEDADE FROM PROP_COMPRAS (NOLOCK) A    
					                   WHERE A.PROPRIEDADE = '01020'  AND A.PEDIDO = @xPedido  )  
				   GROUP BY PRODUTOS_FICHA.MATERIAL, PRODUTOS_FICHA_COR.COR_MATERIAL ) B  
  
				ON A.MATERIAL = B.MATERIAL AND A.COR_MATERIAL = B.COR_MATERIAL --AND A.PROGRAMACAO = B.PROGRAMACAO   
				  ) A
  
				GROUP BY PEDIDO,MATERIAL,COR_MATERIAL,PROGRAMACAO,PRODUTO  
				
				FETCH NEXT FROM Cur_CALCULA_PROC_CONSUMO INTO @xPedido, @xMaterial, @xCor_Material

		  END


		CLOSE Cur_CALCULA_PROC_CONSUMO
		DEALLOCATE Cur_CALCULA_PROC_CONSUMO

----------------------------------------------------------------
--------- BLOQUEIO FERIADOS DATA -----------
--------- LUCAS MIRANDA - 22/11/2016 -------
--------- CHAMADO: 334744

If update(entrega) or update(limite_entrega) or update(data_confirmacao)
begin
	select @feriado = b.descr_feriado
	from (select CAST(YEAR(ENTREGA) AS VARCHAR(4)) 
							+ '-' + case when len(CAST(MONTH(ENTREGA) AS VARCHAR(2))) = 1 then '0'+CAST(MONTH(ENTREGA) AS VARCHAR(2)) else CAST(MONTH(ENTREGA) AS VARCHAR(2)) end
							+ '-' + case when len(CAST(DAY(ENTREGA) AS VARCHAR(2))) = 1 then '0'+CAST(DAY(ENTREGA) AS VARCHAR(2)) else CAST(DAY(ENTREGA) AS VARCHAR(2)) end as anm_entrega,
							CAST(YEAR(LIMITE_ENTREGA) AS VARCHAR(4)) 
									+ '-' + case when len(CAST(MONTH(LIMITE_ENTREGA) AS VARCHAR(2))) = 1 then '0'+CAST(MONTH(LIMITE_ENTREGA) AS VARCHAR(2)) else CAST(MONTH(LIMITE_ENTREGA) AS VARCHAR(2)) end
									+ '-' + case when len(CAST(DAY(LIMITE_ENTREGA) AS VARCHAR(2))) = 1 then '0'+CAST(DAY(LIMITE_ENTREGA) AS VARCHAR(2)) else CAST(DAY(LIMITE_ENTREGA) AS VARCHAR(2)) end as anm_limite_entrega,
							CAST(YEAR(DATA_CONFIRMACAO) AS VARCHAR(4)) 
									+ '-' + case when len(CAST(MONTH(DATA_CONFIRMACAO) AS VARCHAR(2))) = 1 then '0'+CAST(MONTH(DATA_CONFIRMACAO) AS VARCHAR(2)) else CAST(MONTH(DATA_CONFIRMACAO) AS VARCHAR(2)) end
									+ '-' + case when len(CAST(DAY(DATA_CONFIRMACAO) AS VARCHAR(2))) = 1 then '0'+CAST(DAY(DATA_CONFIRMACAO) AS VARCHAR(2)) else CAST(DAY(DATA_CONFIRMACAO) AS VARCHAR(2)) end as anm_data_confirmacao
							from inserted
							) a
					join (SELECT CASE WHEN INDICA_TODO_ANO = 1 THEN 
							 CAST(YEAR(GETDATE()) AS VARCHAR(4)) 
							 + '-' + case when len(CAST(MONTH(DATA_FERIADO) AS VARCHAR(2))) = 1 then '0'+CAST(MONTH(DATA_FERIADO) AS VARCHAR(2)) else CAST(MONTH(DATA_FERIADO) AS VARCHAR(2)) end
							 + '-' + case when len(CAST(DAY(DATA_FERIADO) AS VARCHAR(2))) = 1 then '0'+CAST(DAY(DATA_FERIADO) AS VARCHAR(2)) else CAST(DAY(DATA_FERIADO) AS VARCHAR(2)) end
							 ELSE 
							 CAST(YEAR(DATA_FERIADO) AS VARCHAR(4)) 
							 + '-' + case when len(CAST(MONTH(DATA_FERIADO) AS VARCHAR(2))) = 1 then '0'+CAST(MONTH(DATA_FERIADO) AS VARCHAR(2)) else CAST(MONTH(DATA_FERIADO) AS VARCHAR(2)) end
							 + '-' + case when len(CAST(DAY(DATA_FERIADO) AS VARCHAR(2))) = 1 then '0'+CAST(DAY(DATA_FERIADO) AS VARCHAR(2)) else CAST(DAY(DATA_FERIADO) AS VARCHAR(2)) end
							END AS anm_feriados, descr_feriado
						from CTB_FERIADOS (NOLOCK) 
						) b
			on a.anm_entrega = b.anm_feriados or a.anm_limite_entrega = b.anm_feriados or a.anm_data_confirmacao = b.anm_feriados
			
	if @feriado <> ''	
		begin
		  select @errno  = 30007,
				 @errmsg = 'Impossível Salvar, a data escolhida é um Feriado !!!'+char(13)+'Feriado: '+@feriado+CHAR(13)+CHAR(13)+'Favor Verificar a Data Entrega/Limite Entrega/Data Confirmação Fornecedor !!!'
		  goto error
		end
end
--------- FIM BLOQUEIO FERIADOS DATA -------

--------- BLOQUEIO - DOMINGO - LUCAS MIRANDA - 22/11/2016 -------
--------- CHAMADO: 334744

If update(entrega) or update(limite_entrega) or update(data_confirmacao)
begin
	Declare @entrega datetime = (select entrega from inserted),
		    @limite_entrega datetime = (select limite_entrega from inserted),
			@data_confirmacao datetime = (select data_confirmacao from inserted)

		Begin
			IF datepart(dw,@entrega) = 1 or datepart(dw,@limite_entrega) = 1 or datepart(dw,@data_confirmacao) = 1
			begin
			  select @errno  = 30007,
					 @errmsg = 'Impossível Salvar, a data escolhida é um Domingo'+CHAR(13)+CHAR(13)+'Favor Verificar a Data Entrega/Limite Entrega/Data Confirmação Fornecedor !!!'
			  goto error
			end	
		End
end
--------- FIM BLOQUEIO FERIADOS DATA -------



  return
error:

    rollback transaction
    raiserror (@errmsg, 16, 1)
end







