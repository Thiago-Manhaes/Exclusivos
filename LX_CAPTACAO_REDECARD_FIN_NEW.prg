PROCEDURE 	LX_CAPTACAO_REDECARD_FIN_NEW                                                                                                                                                        
                                                                                                                                                                                               
			LPARAMETERS PFORMSET, ;                                                                                                                                                                     
						HANDLE_FILE, ;                                                                                                                                                                           
						PTAMREG, PTAMARQ                                                                                                                                                                         
                                                                                                                                                                                               
      		If	!f_select([SELECT isnull(max(taxa_administracao),0) as taxa FROM administradoras_cartao WHERE tipo_cartao = 0 and rede_controladora = ']+Alltrim(PFORMSET.rede)+['],[cur_taxa_rede])

      			Return .f.                                                                                                                                                                            

      		EndIf                                                                                                                                                                                  

			DIMENSION aStatus(13,2)
                                                                                                                                                                     
			aStatus(01,1)					= '00'                                                                                                                                                                        
			aStatus(01,2)					= 'CV OK                           '
			aStatus(02,1)					= '01'                                                                                                                                                                        
			aStatus(02,2)					= 'A EMITIR                        '
			aStatus(03,1)					= '02'                                                                                                                                                                        
			aStatus(03,2)					= 'TRÂNSITO                        '
			aStatus(04,1)					= '03'                                                                                                                                                                        
			aStatus(04,2)					= 'PENDENTE BANCO                  '
			aStatus(05,1)					= '04'                                                                                                                                                                        
			aStatus(05,2)					= 'PENDENTE MATRIZ                 '
			aStatus(06,1)					= '05'                                                                                                                                                                        
			aStatus(06,2)					= 'PENDENTE FILIAL                 '
			aStatus(07,1)					= '06'                                                                                                                                                                        
			aStatus(07,2)					= 'BAIXADA                         '
			aStatus(08,1)					= '07'                                                                                                                                                                        
			aStatus(08,2)					= 'TRÂNSITO FITA                   '
			aStatus(09,1)					= '08'                                                                                                                                                                        
			aStatus(09,2)					= 'BAIXA AUTOMÁTICA                '
			aStatus(10,1)					= '09'                                                                                                                                                                        
			aStatus(10,2)					= 'BAIXADO PARA PENHORA OU RETENÇÃO'
			aStatus(11,1)					= '11'                                                                                                                                                                        
			aStatus(11,2)					= 'SUSPENSO                        '
			aStatus(12,1)					= '12'                                                                                                                                                                        
			aStatus(12,2)					= 'PENHORADO                       '
			aStatus(13,1)					= '13'                                                                                                                                                                        
			aStatus(13,2)					= 'RETIDO                          '
			lcArquivo						= FILETOSTR(PFORMSET.px_arquivo_adm)                                                                                                                                             
			lcCrLf							= CHR(10)     		                                                                                                                                                           
            PFORMSET.PX_TAXA_ADMINISTRACAO 	= cur_taxa_rede.taxa

			Text TO sqlDadosDespesa textmerge noshow
				SELECT Count(*) as DESPESAS
				FROM CTB_BORDERO_LAYOUT_VALIDA A
				WHERE LAYOUT = ?v_ctb_lancamento_01_bordero.layout
			EndText
			
			If !F_SELECT(sqlDadosDespesa,"curDadosDespesa")
				Return .f.
			EndIf

			intDespesas = Nvl(curDadosDespesa.despesas,0)
						
			If Used("curDadosDespesa")						
				Use in curDadosDespesa
			EndIf
			                                                                                                                                                                                               
			for	lcocorrencia = 1 to occurs(lccrlf,lcarquivo)                                                                                                                                            
                                                                                                                                                                                               
				f_wait('captando resumos do arquivo: '+pformset.px_arquivo_adm+'!',ptamarq)                                                                                                                
                                                                                                                                                                                               
				xlinha 		= strextract(lcarquivo,lccrlf,lccrlf,lcocorrencia)	                                                                                                                               
				xtiporeg 	= substr(xlinha,001,03)                                                                                                                                                          

				do	case

					case	inlist(xtiporeg,'034')

							xmaquineta      = substr(xlinha,132,009)  
							If !f_vazio(PFORMSET.px_tipo_estabelecimento)
								If !Seek(PADL(ALLTRIM(xmaquineta),11,"0")+" "+ALLTRIM(PFORMSET.px_tipo_estabelecimento), "cur_relacao_estabelecimentos", "idxTipo")
									Loop 
								EndIf 
							EndIf 				
							
							xguia_envio     = substr(xlinha,076,009)                                                                                                                                                  
							xstatus         = astatus(ceiling(ascan(astatus,substr(xlinha,130,002))/2),2)
							xemissao        = ctod(substr(xlinha,085,02)+'/'+substr(xlinha,087,02)+'/'+substr(xlinha,089,04))                                                                                         
							xvencimento     = ctod(substr(xlinha,024,02)+'/'+substr(xlinha,026,02)+'/'+substr(xlinha,028,04))                                                                                         
							xvalorliquido   = val(substr(xlinha,032,15))/100                                                                                                                                       
							xvalortaxa 		= (val(substr(xlinha,110,15))/100)/(val(substr(xlinha,128,02)))  && xvalorbruto * (pformset.px_taxa_administracao/100)                                                                                                                         
							xvalorbruto 	= xvalorliquido+xvalortaxa
							xcartao			= iif(substr(xlinha,093,01)='1','mastercard',;                                                                                                                                  
											  iif(substr(xlinha,093,01)='2','dinners',;                                                                                                                                           
											  iif(substr(xlinha,093,01)='3','redeshop crédito',;                                                                                                                                  
											  iif(substr(xlinha,093,01)='4','redeshop cdc',;                                                                                                                                      
											  iif(substr(xlinha,093,01)='5','sidecard',;                                                                                                                                          
											  iif(substr(xlinha,093,01)='6','private label',;                                                                                                                                     
											  iif(substr(xlinha,093,01)='9','outros','')))))))                                                                                                                                    
							xtipocaptura    = iif(substr(xlinha,094,01)='1','à vista+rotativo+parc.c/juros',;                                                                                                         
											  iif(substr(xlinha,094,01)='2','parcelado sem juros',;                                                                                                                               
											  iif(substr(xlinha,094,01)='3','parcelado iata','rotativo dólar')))                                                                                                                  
							xvctooriginal   = ctod('')                                                                                                                                                               
							xobservacao     = '1) docto: '+substr(xlinha,013,11)+' 2) data movimento : '+substr(xlinha,068,02)+'/'+substr(xlinha,070,02)+'/'+substr(xlinha,072,04)                                    
							xparcela 		= substr(xlinha,125,5)                                                                                                                                                         
					                                                                                                                                                                                          
							select v_temp_lote                                                                                                                                                                        
                                                                                                                                                                                               
							xlocateagrupa = pformset.px_condicao_agregacao_extratos                                                                                                                                   
                                                                                                                                                                                               
							locate for &xlocateagrupa.                                                                                                                                                                
					                                                                                                                                                                                          
							if	eof()                                                                                                                                                                                  
							                                                                                                                                                                                          
							    append blank                                                                                                                                                                          
							                                                                                                                                                                                          
							    replace cp		 		with 0,;                                                                                                                                                               
										maquineta 		with xmaquineta,;                                                                                                                                                          
										filial          with pformset.lx_localiza_filial(xmaquineta),;                                                                                                                         
										guia_envio 		with xguia_envio,;                                                                                                                                                        
										parcela 		with xparcela,;                                                                                                                                                              
										status 			with xstatus,;                                                                                                                                                               
										emissao 		with xemissao,;                                                                                                                                                              
										vencimento 		with xvencimento,;                                                                                                                                                        
										valor_bruto 	with xvalorbruto,;                                                                                                                                                        
										valor_taxa 		with xvalortaxa,;                                                                                                                                                         
										valor_liquido 	with xvalorliquido,;                                                                                                                                                    
										valor_rejeitado with 0.00,;                                                                                                                                                            
										cartao			with xcartao,;                                                                                                                                                                
										tipo_captura    with xtipocaptura,;                                                                                                                                                    
										vcto_original   with xvctooriginal,;                                                                                                                                                   
										qtde_aceitos 	with 1,;                                                                                                                                                                 
										qtde_rejeitados with 0,;                                                                                                                                                               
										observacao      with xobservacao					                                                                                                                                                  
							                                                                                                                                                                                          
							else                                                                                                                                                                                    
							                                                                                                                                                                                          
						    	replace	cp		 		with 0,;                                                                                                                                                            
										valor_bruto 	with valor_bruto+xvalorbruto,;                                                                                                                                         
										valor_taxa 		with valor_taxa+xvalortaxa,;                                                                                                                                           
										valor_rejeitado with valor_rejeitado+0.00,;                                                                                                                                         
										valor_liquido 	with valor_liquido+xvalorliquido,;                                                                                                                                   
										qtde_aceitos 	with qtde_aceitos+1,;                                                                                                                                                 
										qtde_rejeitados with qtde_rejeitados+0                                                                                                                                              
							                                                                                                                                                                                        
						 	endif                                                                                                                                                                                   
					                                                                                                                                                                                          
							xsomabruto	= xsomabruto  + valor_bruto                                                                                                                                                   
							xsomataxa	= xsomataxa   + valor_taxa                                                                                                                                                     
							xsomarejeit	= xsomarejeit + valor_rejeitado                                                                                                                                              
							xsomaliquid	= xsomaliquid + valor_liquido                                                                                                                                                
							xqtderesumo = xqtderesumo + 1 
							                                                                                                                                                           
				Case inlist(xtiporeg,'035') and intDespesas > 0

					strMaquinetaDespesa = substr(xlinha,004,009)  

					If !f_vazio(PFORMSET.px_tipo_estabelecimento)
						If !Seek(PADL(ALLTRIM(xmaquineta),11,"0")+" "+ALLTRIM(PFORMSET.px_tipo_estabelecimento), "cur_relacao_estabelecimentos", "idxTipo")
							Loop 
						EndIf 
					EndIf 	
					
					strMaquinetaDespesa = PADL(ALLTRIM(strMaquinetaDespesa),11,"0")
											
					strOcorrenciaDespesa 	= ""
					strHistoricoDespesa		= ""	
					datDataDespesa			= v_ctb_lancamento_01.data_lancamento
					decValorDespesa			= 0.00

					datDataDespesa        	= ctod(substr(xlinha,171,02)+'/'+substr(xlinha,173,02)+'/'+substr(xlinha,175,04))                                                                                         
					decValorDespesa 		= val(substr(xlinha,030,15))/100
					strOcorrenciaDespesa 	= Substr(xlinha,046,2)
					strHistoricoDespesa 	= Substr(xlinha,048,28)

					Text to sqlFilialMaquineta textmerge noshow
						SELECT DISTINCT C.COD_FILIAL, C.FILIAL 
							FROM ESTABELECIMENTOS A	
									JOIN LOJAS_VAREJO B ON
										A.CODIGO_FILIAL = B.CODIGO_FILIAL
									JOIN FILIAIS C ON
										B.FILIAL				= C.FILIAL
							WHERE ESTABELECIMENTO = ?strMaquinetaDespesa
					EndText
					
					If !F_SELECT(sqlFilialMaquineta,"curFilialMaquineta")
						Return .f.
					EndIf
					
					strCodFilialDespesa		= curFilialMaquineta.cod_filial
					strFilialDespesa		= curFilialMaquineta.filial
					
					If Used("curFilialMaquineta")
						Use in curFilialMaquineta
					EndIf
						
					If F_VAZIO(strCodFilialDespesa)
						LOOP
					EndIf
						
					Text TO sqlDadosDespesa textmerge noshow
						SELECT A.CONTA_CONTABIL, A.LX_TIPO_LANCAMENTO, A.CODIGO_HISTORICO, B.HISTORICO_PADRAO, C.DESC_CONTA, D.DESC_TIPO_LANCAMENTO 
						FROM CTB_BORDERO_LAYOUT_VALIDA A
								LEFT JOIN CTB_HIST_PADRAO B ON
									A.CODIGO_HISTORICO	= B.CODIGO_HISTORICO
								LEFT JOIN CTB_CONTA_PLANO C ON
									A.CONTA_CONTABIL	= C.CONTA_CONTABIL
								LEFT JOIN CTB_LX_LANCAMENTO_TIPO D ON
									A.LX_TIPO_LANCAMENTO = D.LX_TIPO_LANCAMENTO											
						WHERE LAYOUT = ?v_ctb_lancamento_01_bordero.layout AND VALOR_CAMPO = ?strOcorrenciaDespesa
					EndText
				
					If !F_SELECT(sqlDadosDespesa,"curDadosDespesa")
						Return .f.
					EndIf
					
					strContaContabilDespesa		= curDadosDespesa.conta_contabil
					strDescContaDespesa			= curDadosDespesa.desc_conta
					strTipoLancDespesa			= curDadosDespesa.lx_tipo_lancamento
					strDescTipoLancDespesa		= curDadosDespesa.desc_tipo_lancamento
					strCodHistDespesa			= Iif(f_vazio(strHistoricoDespesa),curDadosDespesa.codigo_historico,null)
					strHistoricoDespesa			= Iif(f_vazio(strHistoricoDespesa),curDadosDespesa.historico_padrao,strHistoricoDespesa)
					
					If Used("curDadosDespesa")
						Use in curDadosDespesa
					EndIf			

					Select v_ctb_lancamento_01_bordero_cheque_despesa
					Go top
					
					Locate for conta_contabil = strContaContabilDespesa and lx_tipo_lancamento = strTipoLancDespesa and cod_filial = strCodFilialDespesa and tipo_movimentacao_adm = strOcorrenciaDespesa
					
					If Found()
						replace valor_despesa with valor_despesa + decValorDespesa
					Else
				
						Append Blank
						replace conta_contabil 			with strContaContabilDespesa,;
								desc_conta				with strDescContaDespesa,;
								lx_tipo_lancamento		with strTipoLancDespesa,;
								desc_tipo_lancamento	with strDescTipoLancDespesa,;
								historico				with strHistoricoDespesa,;
								cod_filial				with strCodFilialDespesa,;
								filial					with strFilialDespesa,;
								tipo_movimentacao_adm	with strOcorrenciaDespesa,;
								valor_despesa 			with decValorDespesa,;
								data_despesa			with datDataDespesa		
					EndIf

				endcase	

			endfor

			F_WAIT()                                                                                                                                                                                    
                                                                                                                                                                                               
ENDPROC