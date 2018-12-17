Define Class obj_GS_classes As Custom
	*!* Criar Função e chamar no Obj de entrada *!*

	** Função abaixo criada para executar em todos os metodos da tela **
	Function l_marca_todos string

		Lparam xCursor, xColuna, xValor
		*!* Aqui escrever o código a ser executado pela função *!*
			nOldSele = Select()
			
 			SELE &xCursor
 			GO Top
			Replace ALL &xColuna WITH &xValor
			
			GO Top
			Select(nOldSele)
			
	Endfunc
	** Fim da Função ***************************************************
	
	
	** Fim da classe **
Enddefine
