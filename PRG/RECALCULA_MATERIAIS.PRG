xMaterial = '01101360'


TEXT TO SelMat TEXTMERGE NOSHOW
	SELECT material,cor_material,filial,sum(qtde_estoque) as qtde 
	FROM ESTOQUE_MATERIAIS 
	WHERE MATERIAL = '<<xMaterial>>'      
                AND FILIAL = 'FARM MATRIZ' AND QTDE_ESTOQUE > 0
	group by  material,cor_material,filial					
ENDTEXT					

F_SELECT(SelMat,"curEntMat")					

					text to	xselmov1 noshow	
						select a.*,b.qtde_estoque 
						from 
						(select emissao,documento,material,cor_material,tipo,qtde,
						case when saldo<0 then 0 else saldo end as saldo,
						(valor+icms_valor+frete_seguro_encargo+ipi_valor+cofins_valor+pis_valor+desp_import+desconto) as valor_ent,
						convert(numeric(14,5),((valor+icms_valor+frete_seguro_encargo+ipi_valor+cofins_valor+pis_valor+desp_import+desconto)/qtde)) as valor_unit 
					endtext	


					Text to	xupd noshow				 
					   UPDATE Materiais_Cores    
					   set  custo_reposicao = ?xcustomedio,    
					   custo_a_vista = ?xcustomedio    
					   WHERE Material=?curEntMat.material   
					   AND Cor_Material=?curEntMat.cor_material  
					Endtext		
					
					
					Sele curEntMat	
					go top	

					scan	
						
						f_prog_bar('Atualizando Preço Medio de Entrada dos Materiais...',recno(),reccount()) 
						
			
						xselmov2 = " from FX_ANM_MONTA_CARDEX_01('" +allt(curEntMat.material)+"' , '"+ ; 
	 		                  allt(curEntMat.cor_material)+"' , '%' , NULL, 0) " + ;
						"where tipo='ENTRADA DE N.F.' and qtde>0) a " + ;
						"join estoque_materiais b  " + ;
						"on a.material=b.material and a.cor_material=b.cor_material and b.filial='FARM MATRIZ'"  
						

						if !f_select(xselmov1+xselmov2,"curCardex")
							messagebox('Não foi póssível selecionar movimentação dos materiais !',32,'Atenção_3 !!!')
							retu .f.
						endif		
						sele curCardex	
							xsaldoant		= 0
							xvalorant		= 0
							xvalorestapos	= 0
							xcustomedio		= 0
							xcustoant		= 0 
							xseq_calc       = 0  
						scan	
							xsaldoant		= iif( (curCardex.saldo-curCardex.qtde)<0,0,(curCardex.saldo-curCardex.qtde) )
							xvalorant		= xsaldoant * iif( (xseq_calc=0 and xsaldoant>0), curCardex.valor_unit , xcustoant )
							xvalorestapos	= curCardex.valor_ent+xvalorant
							xcustomedio		= xvalorestapos/iif(curCardex.saldo<=curCardex.qtde,curCardex.qtde,curCardex.saldo) 
							xcustoant		= xcustomedio 
							xseq_calc       = xseq_calc + 1 
						endscan							
						
						f_update(xupd)	 

						
						sele curEntMat	
						
					endscan	
					f_prog_bar()	
					messagebox("terminou!!!")