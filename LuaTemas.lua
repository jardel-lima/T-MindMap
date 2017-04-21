--[[
##############################################################################################
#   UNIVASF- Universidade Federal do Vale do S�o Francisco 									 #
#			Colegiado de Engenharia da Computa��o											 #					
#																							 #
#	Projeto de Inicia��o Cient�fica															 #
#																							 #
#	T�tulo do Projeto:Projeto e Desenvolvimento de Aplica��es para TV Digital				 #
#					  com Foco em Servi�os Governamentais									 #
#	T�tulo do Subprojeto:Uma Aplica��o de Apoio ao Ensino e a Aprendizagem via TV Digital	 #
#																							 #
#	Orientador:Prof. Ms. Mario Godoy Neto													 #
#	Orientando:Jardel Ribeiro de Lima														 #
#																							 #
#	Prot�tipo: T-ABC																		 #
##############################################################################################	  
]]--

local fille = 'Temas.txt'-- Nome do aquivo com todos os temas
local tema={} -- Guarda os temas do forum 	
local selecao = 1 -- Linha Selecionada
local visible_t = false

-- Tabela usada para comunica��o com a propriedade Tema
local evtt = {
    class = 'ncl',
    type  = 'attribution',
    name  = 'Tema',
}
-- Tabela usada para comunica��o com a area select
local selt = {
    class = 'ncl',
    type  = 'presentation',
    label = 'select',
}
-- Tabela usada para comunica��o com a area addlua
local selt2 = {
    class = 'ncl',
    type  = 'presentation',
    label = 'addlua',
}
-- Tabela usada para comunica��o com a area iniciar
local selt3 = {
    class = 'ncl',
    type  = 'presentation',
    label = 'iniciar',
}
-- Tabela usada para comunica��o com a area parar
local selt4 = {
    class = 'ncl',
    type  = 'presentation',
    label = 'parar',
}
function zerar_tabelas()
	local i
	local tam
	
	tam=#tema
	
	for  i=tam , 1 , -1  do
		table.remove (tema , i )
	end	
end	
	
-- Carrega cada linha do arquivo .txt na tabela
function carrega()
 	zerar_tabelas()
 	local str
 	local cont_line = 0-- Contador de linhas do Texto
	for aux in io.lines(fille) do
		    
			cont_line = cont_line + 1
			str=string.gsub (aux,'%c',"") -- Retira o "\n"	
			tema[cont_line] = str			
	end
end	

--Desenha o texto
function draw_texto(selecao)

	local Posicao_Texto = 0 -- Posi��o do texto a ser desenhado
	local Dx,Dy -- Dimes�es do Canvas
	local line_print= 0 -- Linha a ser exibida
	local Tamanho_Linha -- Tamanho da lina
	local dx,dy -- Dimens�es do texto
	local str -- Carrega o nome do tema
	local img -- varieavel da imagem
	
	canvas:attrColor(0,0,0,0) -- Deixa a cor padr�o transparente
	canvas:clear () -- Limpa o Canvas
--	canvas:attrColor('black') -- Retorna a cor padr�o do texto
	
	Dx,Dy = canvas:attrSize() -- Dimen��o da regi�o Lua
	canvas:attrFont ('vera', 24) -- Tipo e tamanho da Fonte
	canvas:attrColor('black') -- Cor da Fonte
	img=canvas:new('media/temas1.png')-- carrega a imagem 
	canvas:compose(0, 0 , img )-- desenha a imagem
	Tamanho_linha = (Dy-68) / #tema-- O espa�o que cada linha pode acupar na regi�o
	Tamanho_linha = math.modf (Tamanho_linha) -- Transforma em um numero inteiro
	Posicao_Texto = 68-- Posi��o inicial do texto
	
	while line_print < #tema do -- Imprime linha por linha
		
		line_print=line_print+1
	
		if line_print == selecao then -- Testa se a linha a ser impressa e a linha selecionada
			
			canvas:attrColor('gray') -- Cor retangulo
			dx,dy = canvas:measureText (tema[line_print]) -- Pega as dimens�es do texto para serem usadas no Retangulo a ser desenhado
			canvas:drawRect('fill', 10, Posicao_Texto-10, Dx*0.97, 10 ) -- Desenha o Retangulo
			canvas:attrColor(255,102,0,255) -- Cor retangulo
			--canvas:attrColor('orange') -- Cor retangulo
			canvas:drawRect('fill', 10, Posicao_Texto, Dx*0.97, dy ) -- Desenha o Retangulo
			canvas:attrColor('yellow') -- Cor do texto selecionao
			
			canvas:drawText (14, Posicao_Texto,"- "..tema[line_print])-- Fun��o que imprime o texto 
			canvas:attrColor('black') -- Retorna para a cor da linha n�o selecionada
			
		else 		

			canvas:drawText ( 14 , Posicao_Texto ,"- "..tema[line_print])-- Fun��o que imprime o texto
	
		end
		
		Posicao_Texto = Posicao_Texto + Tamanho_linha -- Posi��o do texto na vertical 
		
	end
	
	canvas:flush () -- Atualiza o Canvas
	
end	

local function nclhandlert(evt)

	if evt.class == 'ncl' then   
		 if evt.type == 'attribution' then
		 	if  evt.name=='visi_t' then
		 		if evt.action == 'start' then
		 			if evt.value=='1' then

		 				carrega()
						draw_texto(selecao)
		 				visible_t = true
		 				
					end
					
					evt.action = 'stop';event.post(evt)
					
				end
			elseif visible_t and evt.name=='add_t'then
				if evt.action == 'start' then
		 				evt.action = 'stop';event.post(evt)
		 				
		 				canvas:attrColor(0,0,0,0) -- Deixa a cor padr�o transparente
						canvas:clear () -- Limpa o Canvas
						canvas:flush () -- Atualiza o Canvas
						
		 				selt2.action = 'start'; event.post(selt2)
						selt2.action = 'stop';  event.post(selt2)
						
						visible_t = false
		 		end
		 	elseif not visible_t and evt.name == 'press_RED' then
		 		if evt.action == 'start' then
		 			if evt.value=='1' then
		 				evt.action = 'stop';event.post(evt)
		 			
		 				carrega()
						draw_texto(selecao)
						visible_t = true
		 			
		 				selt3.action = 'start'; event.post(selt3)
						selt3.action = 'stop';  event.post(selt3)
					end
				end
			elseif visible_t and evt.name == 'press_RED' then
		 		if evt.action == 'start' then
		 			if evt.value=='0' then
		 				evt.action = 'stop';event.post(evt)
		 			
		 				canvas:attrColor(0,0,0,0) -- Deixa a cor padr�o transparente
						canvas:clear () -- Limpa o Canvas
						canvas:flush () -- Atualiza o Canvas
						zerar_tabelas()
						
		 				selt4.action = 'start'; event.post(selt4)
						selt4.action = 'stop';  event.post(selt4)
						selecao = 1				
						visible_t = false
					end
				end											
			end			
		end
	end	   
	
	
end

event.register(nclhandlert)
		
-- Fun��o que recebe os eventos das teclas
function eventos (evt)
	local str		
	-- Eventos que ser�o analizados para alterar a linha de selecao
	if visible_t and evt.class == 'key' and evt.type == 'press' then
		
		if evt.key == 'CURSOR_DOWN' then
			selecao = selecao + 1
		elseif evt.key == 'CURSOR_UP' then
			selecao = selecao - 1
		
		elseif evt.key == 'ENTER' then
			
			canvas:attrColor(0,0,0,0) -- Deixa a cor padr�o transparente
			canvas:clear () -- Limpa o Canvas
			canvas:flush () -- Atualiza o Canvas
			
			str=string.gsub (tema[selecao],'%c',"")
			evtt.value = str
			
			
			--Faz a atribui��o a variavel Tema
			evtt.action = 'start'; event.post(evtt)
			evtt.action = 'stop'; event.post(evtt)
			
			event.timer(100, function()	
			--Indica que o documento lua deve ser parado
				selt.action = 'start'; event.post(selt)
				selt.action = 'stop';  event.post(selt)
			end)
			
			visible_t=false
  		end
	end
	
	-- Nescess�rio para que s� linhas v�lidas sejam selecionadas
	if selecao < 1 then
		selecao = #tema
	elseif selecao > #tema  then
		selecao = 1
	end	
	
	if( evt.class=='key' and visible_t) then
	 	draw_texto(selecao) -- Fun��o que imprime o Texto
	end  
			 			
end

event.register(eventos)

