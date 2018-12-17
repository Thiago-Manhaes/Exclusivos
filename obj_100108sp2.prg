* Criação *********************************************************************************************************** 
* PROGRAMADOR(A).:  Sidnei Stellet                                                                                                *
* DATA...........:  09/03/2005                                                                                                *
* HORÁRIO........:  18:00                                                                                                *
********************************************************************************************************************* 
* CLIENTE..: Animale                                                                                                      *
* OBJETIVO.: Melhorar o desempenho na impressão de etiquetas de código de barras  *
********************************************************************************************************************* 

* Alteração ********************************************************************************************************* 
* PROGRAMADOR(A).:                                                                                                  *
* DATA...........:                                                                                                  *
* HORÁRIO........:                                                                                                  *
********************************************************************************************************************* 
* CLIENTE..:                                                                                                        *
* OBJETIVO.:                                                                                                        *
********************************************************************************************************************* 


********************************************************************************************************************* 
*- Programa Base de Criação de Objeto de Entrada                                                                    *
********************************************************************************************************************* 
*- O programa deve ser texto com o nome = OBJ_xxxxxx.prg onde x=numero da tela                                      *
*- Este arquivo deve ser colocado no diretorio \Linx_sql\Linx\Exclusivos                                            *
********************************************************************************************************************* 
*- Existem 2 parametros que influem nos objetos de Entrada:                                                         *
*  utiliza_objeto_entrada = .f. desliga os objetos de entrada para testar telas sem os mesmos                       *
*  mostra_nome_obj = .t. mostra o nome dos objetos no tooltip em tempo de execução para facilitar o desenvolvimento *
********************************************************************************************************************* 
* - Atencao !!!!!!!!!!!														                                        *
* - Toda vez que houver qualquer alteracao no PRG deve-se apagar o arquivo FXP                                      *
********************************************************************************************************************* 
*- Mit[1] - 11/09/2018 - criacao da exportacao do XML do RPS - Rio

define class obj_entrada as custom
	*- Nome do metodo/função que os objetos linx vão chamar.

	procedure metodo_usuario
		*- Parametros do metodo:
		*- Xmetodo= nome do metodo
		*- Xobjeto= variavel com a referencia ao objeto
		*- Xnome_obj  = nome do objeto
		lparam xmetodo, xobjeto ,xnome_obj
		
		******************** Metodos chamados pelo FORMSET
		*	USR_INIT  												=> NA INICIALIZACAO DA TELA 
		*	USR_ALTER_BEFORE  -> Return .f. Para o Metodo 			=> ANTES DA ALTERACAO ,AO CLICKAR ANTES DE LIBERAR OS CAMPOS
		*	USR_ALTER_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO   
		*	USR_INCLUDE_AFTER 										=> APOS LIBERAR OS CAMPOS PARA INCLUSAO
		*	USR_SEARCH_BEFORE -> Return .f. Para o Metodo PESQUISA	=> ANTES DE FAZER A PESQUISA NO BANCO
		*	USR_SEARCH_AFTER										=> APOS FAZER A PESQUISA NO BANCO
		*	USR_CLEAN_AFTER 										=> APOS LIMPAR A TELA 
		*	USR_REFRESH                                             => 
		*	USR_SAVE_BEFORE   -> Return .f. Para o Metodo 			=> SALVAR ANTES DE JOGAR INFORMACOES NO BANCO
		*	USR_SAVE_AFTER                                          => APOS SALVAR AS INFORMACOES    NO BANCO
		*	USR_ITEN_DELETE_BEFORE -> Return .f. Para o Metodo 		=> ANTES DE EXCLUIR ITEN NA TABELA FILHA '+'
		*	USR_ITEN_DELETE_AFTER                                   => APOS DELETAR UM ITEM NA TABELA FILHA '-' 
		*	USR_ITEN_INCLUDE_BEFORE -> Return .f. Para o Metodo 	=> ANTES DE INCLUIR ITEM NA TABELA FILHA
		*	USR_ITEN_INCLUDE_AFTER									=> APOS INCLUIR ITEM NA TABELA FILHA 
		*
		***************** Metodos que ocorrem dentro da Transaction do Banco de Dados
		*	USR_TRIGGER_AFTER ->Return .f. Para o Salvamento e da Rollback ANTES DE EXECUTAR UMA TRIGGER
		*	USR_TRIGGER_BEFORE ->Return .f. Para o Salvamento e da Rollback


		******************** Metodo chamado pelos Objetos na Validação
		*   USR_VALID -> Return .f. Não deixa o Usuario sair do objeto.

		******************** Metodo chamado pelos PageFrames
		*   USR_ACTIVE_PAGE -> Return .f. Para o Metodo.

		*- Inicio dos procedimentos do Usuario
		*- Testando qual o metodo que esta chamando o metodo entrada

		*=messagebox( 'Metodo '+ UPPER(xmetodo) + ' Nome Objeto ' + upper(xnome_obj) )
		do case
			case UPPER(xmetodo)=='USR_INIT' 
				xVersao = '01.1'
				f_update("update transacoes set versao_liberada = ?xVersao where control_sistema like '"+right(ALLTRIM(Thisformset.p_controle_sistema),6)+"%' and versao_liberada <> ?xVersao ")
				f_select("Select valor_atual from parametros where parametro = 'ver_hotfix'","CurVersaoLinx")
				WAIT WINDOW "Versão: "+allt(CurVersaoLinx.valor_atual)+"."+xVersao NOWAIT 
			
				thisformset.lx_FORM1.lx_pageframe1.page1.addobject("imprime_zebra_transp","imprime_zebra_transp") 
				thisformset.lx_FORM1.lx_pageframe1.page1.addobject("imprime_Volumes_NFe","imprime_Volumes_NFe") 
				thisformset.lx_FORM1.lx_pageframe1.page3.addobject("bt_rps_rio","bt_rps_rio") &&Mit[1]
			otherwise
				return .t.				
		endcase
	endproc
ENDDEFINE


**************************************************
*-- Class:        imprime_zebra_transp 
*-- ParentClass:  commandbutton
*-- BaseClass:    commandbutton
*-- Time Stamp:   08/25/05 04:39:04 PM
*
DEFINE CLASS imprime_zebra_transp AS commandbutton


	Top = 0
	Left = 553
	Height = 22
	Width = 150
	Caption = "Etiqueta Caixa"
	Name = "imprime_zebra_transp"
	visible=.t.
	enabled=.t.



	PROCEDURE Click


				SELECT V_IMPRESSAO_NF_00
				&& REPORT FORM wdir+'LINX\REPORT\USER\u100108zr etiqueta por volume.frx' NOCONSOLE TO PRINTER 
				
				&& ismara - mandar para arquivo e depois pelo .bat enviar para a impressora
				REPORT FORM wdir+'LINX\REPORT\USER\u100108zr etiqueta por volume.frx' NOCONSOLE TO FILE L:\etiqcaixa.txt ASCII
				
				SELECT V_IMPRESSAO_NF_00
				GO TOP
				
		WAIT WINDOW 'Etiquetas Impressas...' nowait 
	ENDPROC


ENDDEFINE
*
*-- EndDefine: imprime_zebra_transp
**************************************************



*-- Tiago Carvalho - Sintese Soluções - Etiqueta Provisória para impressão de Volumes para NFe, será subistituida no processo do WMS.
*-- Class: Imprime_zebra_transp 
DEFINE CLASS Imprime_Volumes_NFe AS commandbutton
	Top = 0
	Left = 403
	Height = 22
	Width = 150
	Caption = "Etiqueta Volumes"
	Name = "imprime_Volumes_NFe"
	visible=.t.
	enabled=.t.

	PROCEDURE Click

		nAntArea = select()
		
		IF RECCOUNT("V_IMPRESSAO_NF_00") > 0 AND !F_VAZIO(V_IMPRESSAO_NF_00.NF)
			IF (MESSAGEBOX("Deseja imprimir etiquetas de volumes para "+ALLTRIM(STR(RECCOUNT("V_IMPRESSAO_NF_00")))+IIF(RECCOUNT("V_IMPRESSAO_NF_00") > 1," Notas"," Nota"),32+4+256,"Etiqueta de Volumes"))<>6
				RETURN .f.
			endif				
		ELSE
			MESSAGEBOX("Efetue a pesquisa da nota a ser impressa antes de imprimir",0+64,"Nenhuma nota Pesquisada")
			RETURN .f.
		ENDIF
		
		SELECT V_IMPRESSAO_NF_00
		GO TOP			
		
		strProc = SET("Procedure")
		Set procedure To \Linx\Report\User\Proc_SS_Etiquetas.prg Additive
		
		SCAN
			lcNf =ALLTRIM(v_impressao_nf_00.nf)
			lcSerie =ALLTRIM(v_impressao_nf_00.serie_nf)
			lcFilial = ALLTRIM(v_impressao_nf_00.filial)
			lcVolumeTotal = v_impressao_nf_00.volumes
			
			FOR lcVolume = 1 TO lcVolumeTotal
				
				WAIT WINDOW 'NF:'+lcNf +" Serie:"+lcSerie+" Filial:"+lcFilial +" Volume:"+ALLTRIM(STR(lcVolume))+" de "+ALLTRIM(STR(lcVolumeTotal)) nowait  
				
				lcNomeArq = "C:\SINTESE\ETIQUETA\EtiquetaVolumes"+wusuario+".ETQ"
				intArq = fCreate(lcNomeArq, 0)
				if (intArq >= 0)
					fwrite(intArq, Proc_Etiqueta_Volume(lcNf , lcSerie , lcFilial ,ALLTRIM(STR(lcVolume)) ,'',''))
					fClose(intArq)
					!COPY &lcNomeArq LPT1
				ENDIF
			endfor
		endscan		
		
		SET PROCEDURE TO &strProc
		SELECT (nAntArea)	
		WAIT WINDOW 'Etiquetas Impressas...' nowait 
	ENDPROC
ENDDEFINE

*- Mit[1]
DEFINE CLASS bt_rps_rio as botao
	visible = .T.
	caption = 'RPS RIO'
	width = 150
	top = 270
	left = 500

	PROCEDURE click
		IF 6 = MESSAGEBOX('Deseja exportar os RPS das nota selecionadas?',36, wusuario)
			SELECT v_impressao_nf_00
			SCAN
				IF v_impressao_nf_00.serie_nf = '92' AND !v_impressao_nf_00.nota_cancelada
					VLC_Emissao = LEFT(dtos(wdata),4) + '-' + SUBSTR(dtos(wdata), 5,2) + '-' + right(dtos(wdata), 2) + 'T' + ALLTRIM(TIME())
					VLC_Lote = ALLTRIM(STR(VAL(f_sequenciais('RPS_RJ', .T.))))

					VLC_Select = "select cgc_cpf, razao_social, im from cadastro_cli_for (nolock) where nome_clifor = '" + v_impressao_nf_00.filial + "'"
					F_select(VLC_Select, 'cur_filial', ALIAS())

					VLC_Select = "select pj_pf, razao_social, cgc_cpf, indicador_fiscal_terceiro, endereco, numero, complemento, bairro, cod_municipio_ibge, uf, cep from cadastro_cli_for (nolock) where nome_clifor = '" + v_impressao_nf_00.nome_clifor + "'"
					F_select(VLC_Select, 'cur_cli', ALIAS())

					VLC_Select = "select MAX(replace(DESCRICAO_ITEM, '-', '')) as descricao_item from faturamento_item (nolock) where nf_saida = '" + v_impressao_nf_00.nf + "' and filial = '" + v_impressao_nf_00.filial + "' and serie_nf = '" + v_impressao_nf_00.serie_nf + "'"
					F_select(VLC_Select, 'cur_item', ALIAS())
					
					VLC_Select = "select SUM(case when id_imposto = 5 then valor_imposto else 0 end) as valor_pis, " + ;
								 "		SUM(case when id_imposto = 6 then valor_imposto else 0 end) as valor_cofins, " +;
								 "		SUM(case when id_imposto = 4 then valor_imposto else 0 end) as valor_INSS, " +;
								 "		SUM(case when id_imposto = 3 then valor_imposto else 0 end) as valor_IRRF, " +;
								 "		SUM(case when id_imposto = 16 then valor_imposto else 0 end) as valor_CSLL, " +;
								 "		SUM(case when id_imposto = 22 then valor_imposto else 0 end) as valor_ISSR, " +;								 
								 "		SUM(case when id_imposto = 14 then valor_imposto else 0 end) as valor_ISS, " +;								 								 
								 "      MAX(case when id_imposto = 14 then TAXA_IMPOSTO else 0 end) as aliquota_ISS " +;
								 "from faturamento_imposto where nf_saida = '" + v_impressao_nf_00.nf + "' and filial = '" + v_impressao_nf_00.filial + "' and serie_nf = '" + v_impressao_nf_00.serie_nf + "'"
					
					F_Select(VLC_Select, 'cur_imp')
					
					VLC_XML = '<?xml version="1.0"?>'
					VLC_XML = VLC_XML + '<EnviarLoteRpsEnvio xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd">'
					VLC_XML = VLC_XML + '<LoteRps Id="L1">'
					VLC_XML = VLC_XML + '<NumeroLote>' + ALLTRIM(VLC_Lote) + '</NumeroLote>'
					VLC_XML = VLC_XML + '<Cnpj>' + ALLTRIM(cur_filial.cgc_cpf) +  '</Cnpj>'
					VLC_XML = VLC_XML + '<InscricaoMunicipal>' + ALLTRIM(cur_filial.im) + '</InscricaoMunicipal>'
					VLC_XML = VLC_XML + '<QuantidadeRps>1</QuantidadeRps>'
					VLC_XML = VLC_XML + '<ListaRps>'
					VLC_XML = VLC_XML + '<Rps>'
					VLC_XML = VLC_XML + '<InfRps Id="R1">'
					VLC_XML = VLC_XML + '<IdentificacaoRps>'
					VLC_XML = VLC_XML + '<Numero>' + ALLTRIM(STR(VAL(v_impressao_nf_00.nf))) + '</Numero>'
					VLC_XML = VLC_XML + '<Serie>' + ALLTRIM(STR(VAL(v_impressao_nf_00.serie_nf))) + '</Serie>'
					VLC_XML = VLC_XML + '<Tipo>1</Tipo>'
					VLC_XML = VLC_XML + '</IdentificacaoRps>'
					VLC_XML = VLC_XML + '<DataEmissao>' + VLC_Emissao + '</DataEmissao>'
					VLC_XML = VLC_XML + '<NaturezaOperacao>1</NaturezaOperacao>'
					VLC_XML = VLC_XML + '<OptanteSimplesNacional>2</OptanteSimplesNacional>'
					VLC_XML = VLC_XML + '<IncentivadorCultural>2</IncentivadorCultural>'
					VLC_XML = VLC_XML + '<Status>1</Status>'
					VLC_XML = VLC_XML + '<Servico>'
					VLC_XML = VLC_XML + '<Valores>'
					VLC_XML = VLC_XML + '<ValorServicos>' + ALLTRIM(STR(v_impressao_nf_00.valor_total,10,2)) + '</ValorServicos>'
					VLC_XML = VLC_XML + '<ValorDeducoes>0</ValorDeducoes>'
					VLC_XML = VLC_XML + '<ValorPis>' + ALLTRIM(STR(cur_imp.valor_pis,10,2)) + '</ValorPis>'					
					VLC_XML = VLC_XML + '<ValorCofins>' + ALLTRIM(STR(cur_imp.valor_pis,10,2)) + '</ValorCofins>'
					VLC_XML = VLC_XML + '<ValorInss>' + ALLTRIM(STR(cur_imp.valor_inss,10,2)) + '</ValorInss>'
					VLC_XML = VLC_XML + '<ValorIr>' + ALLTRIM(STR(cur_imp.valor_irrf,10,2)) + '</ValorIr>'
					VLC_XML = VLC_XML + '<ValorCsll>' + ALLTRIM(STR(cur_imp.valor_csll,10,2)) + '</ValorCsll>'
					VLC_XML = VLC_XML + '<IssRetido>2</IssRetido>'
					VLC_XML = VLC_XML + '<ValorIss>' + ALLTRIM(STR(cur_imp.valor_ISS,10,2)) + '</ValorIss>'					
					VLC_XML = VLC_XML + '<OutrasRetencoes>0.00</OutrasRetencoes>'
					VLC_XML = VLC_XML + '<Aliquota>' + ALLTRIM(STR(cur_imp.aliquota_ISS,10,2)) + '</Aliquota>'				
					VLC_XML = VLC_XML + '<DescontoIncondicionado>0</DescontoIncondicionado>'
					VLC_XML = VLC_XML + '<DescontoCondicionado>0</DescontoCondicionado>'
					VLC_XML = VLC_XML + '</Valores>'
					VLC_XML = VLC_XML + '<ItemListaServico>1009</ItemListaServico>'
					VLC_XML = VLC_XML + '<CodigoTributacaoMunicipio>100901</CodigoTributacaoMunicipio>'
					VLC_XML = VLC_XML + '<Discriminacao>' + ALLTRIM(cur_item.descricao_item) + '</Discriminacao>'
					VLC_XML = VLC_XML + '<CodigoMunicipio>3304557</CodigoMunicipio>'
				    VLC_XML = VLC_XML + '</Servico>'
					VLC_XML = VLC_XML + '<Prestador>'
					VLC_XML = VLC_XML + '<Cnpj>' + ALLTRIM(cur_filial.cgc_cpf) + '</Cnpj>'
					VLC_XML = VLC_XML + '<InscricaoMunicipal>' + ALLTRIM(NVL(cur_filial.im,'')) + '</InscricaoMunicipal>'
					VLC_XML = VLC_XML + '</Prestador>'
					VLC_XML = VLC_XML + '<Tomador>'
					VLC_XML = VLC_XML + '<IdentificacaoTomador>'
					VLC_XML = VLC_XML + '<CpfCnpj>'
					VLC_XML = VLC_XML + IIF(cur_cli.pj_pf, '<Cnpj>' + ALLTRIM(cur_cli.cgc_cpf) + '</Cnpj>', '<Cpf>' + ALLTRIM(cur_cli.cgc_cpf) + '</Cpf>')
					VLC_XML = VLC_XML + '</CpfCnpj>'
					VLC_XML = VLC_XML + '</IdentificacaoTomador>'
					VLC_XML = VLC_XML + '<RazaoSocial>' + ALLTRIM(cur_cli.razao_social) + '</RazaoSocial>' 
					VLC_XML = VLC_XML + '<Endereco>'
					VLC_XML = VLC_XML + '<Endereco>' + ALLTRIM(cur_cli.endereco) + '</Endereco>'
					VLC_XML = VLC_XML + '<Numero>' + ALLTRIM(cur_cli.numero) + '</Numero>'
					
					IF !F_vazio(ALLTRIM(cur_cli.complemento))
						VLC_XML = VLC_XML + '<Complemento>' + ALLTRIM(cur_cli.complemento) + '</Complemento>'
					ENDIF
					
					VLC_XML = VLC_XML + '<Bairro>'+ ALLTRIM(cur_cli.bairro) + '</Bairro>'
					VLC_XML = VLC_XML + '<CodigoMunicipio>' + ALLTRIM(cur_cli.cod_municipio_ibge) +   '</CodigoMunicipio>'
					VLC_XML = VLC_XML + '<Uf>'+ ALLTRIM(cur_cli.uf) +'</Uf>'
					VLC_XML = VLC_XML + '<Cep>' + ALLTRIM(cur_cli.cep) + '</Cep>'
					VLC_XML = VLC_XML + '</Endereco>'
					VLC_XML = VLC_XML + '<Contato>'
					VLC_XML = VLC_XML + '<Email>revisaofiscal@somagrupo.com.br</Email>'
					VLC_XML = VLC_XML + '</Contato>'
					VLC_XML = VLC_XML + '</Tomador>'
					VLC_XML = VLC_XML + '</InfRps>'
					VLC_XML = VLC_XML + '</Rps>'
					VLC_XML = VLC_XML + '</ListaRps>'
					VLC_XML = VLC_XML + '</LoteRps>'
					VLC_XML = VLC_XML + '</EnviarLoteRpsEnvio>'
					
					STRTOFILE(VLC_XML, 'C:\temp\NF' + ALLTRIM(v_impressao_nf_00.nf) + '.xml')
					
				ENDIF
			ENDSCAN
		ENDIF
	ENDPROC

	PROCEDURE refresh
		this.Visible = thisformset.p_tool_status = 'P'	
	ENDPROC
ENDDEFINE
*- Fim Mit[1]
