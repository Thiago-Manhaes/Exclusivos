				************INICIO CUSTO MEDIO MATERIAIS*********************	
			
text to xselmaterial textmerge noshow

select 
a.material,cor_material,filial,0 as qtde,0 as valor 
from estoque_materiais a join materiais b on a.material = b.material 
where QTDE_ESTOQUE>0 and grupo = 'consumiveis' and filial = 'farm filial pa'

endtext

f_select(xselmaterial,"curEntMat")
				

				text to	xselmov1 noshow	
					select a.*,b.qtde_estoque 
					from 
					(select emissao,documento,material,cor_material,tipo,qtde,
					case when saldo<0 then 0 else saldo end as saldo,
					(valor) as valor_ent,
					convert(numeric(14,5),((valor)/qtde)) as valor_unit 
				endtext	


				Text to	xupd noshow				 
				   UPDATE Materiais_Cores    
				   set  custo_reposicao = ?xcustomedio,    
				   custo_a_vista = ?xcustomedio    
				   WHERE Material=?curEntMat.material   
				   AND Cor_Material=?curEntMat.cor_material  
				Endtext		


				Text to	xupd2 noshow				 
				   UPDATE Materiais    
				   set  custo_reposicao = ?xcustomedio,    
				   custo_a_vista = ?xcustomedio    
				   WHERE Material=?curEntMat.material   
				Endtext		
				

				
				
				Sele curEntMat	
				go top	

				scan	
					
					f_prog_bar('Atualizando Preço Medio de Entrada dos Materiais...',recno(),reccount()) 
					
		
					xselmov2 = " from FX_ANM_Monta_Cardex_01 ('" +allt(curEntMat.material)+"' , '"+ ; 
 		                    allt(curEntMat.cor_material)+"' , '"+allt(curEntMat.filial)+"' , NULL, 0) " + ;
					"where tipo='ENTRADA DE N.F.') a " + ;
					"join estoque_materiais b  " + ;
					"on a.material=b.material and a.cor_material=b.cor_material and b.filial='"+allt(curEntMat.filial)+"'"  

					
					if !f_select(xselmov1+xselmov2,"curCardex")		

						messagebox('Não foi póssível selecionar movimentação dos materiais !',32,'Atenção !!!')
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
					
					sele curEntMat	

					if !f_update(xupd)	 
						messagebox('Não foi póssível atualizar os custo medio dos materiais !',32,'Atenção !!!')
					endif	
					
					sele curEntMat	
					
				endscan	
				f_prog_bar()	
				************FIM CUSTO MEDIO MATERIAIS*********************