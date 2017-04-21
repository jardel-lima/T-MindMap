--[[ 
##############################################################################################
#   UNIVASF- Universidade Federal do Vale do São Francisco 									 #
#			Colegiado de Engenharia da Computação											 #					
#																							 #
#	Projeto de Iniciação Científica															 #
#																							 #
#	Título do Projeto:Projeto e Desenvolvimento de Aplicações para TV Digital				 #
#					  com Foco em Serviços Governamentais									 #
#	Título do Subprojeto:Uma Aplicação de Apoio ao Ensino e a Aprendizagem via TV Digital	 #
#																							 #
#	Orientador:Prof. Ms. Mario Godoy Neto													 #
#	Orientando:Jardel Ribeiro de Lima														 #
#																							 #
#	Protótipo: T-ABC																		 #
##############################################################################################	
]]--
local TEXT = ''
local CHAR = '' 
local visible_ac = false
local img=canvas:new('media/novocomentario.png')-- carrega a imagem

local KEY, IDX = nil, -1
local MAP = {
	  ['1'] = { '1', '.', ',','!','?' }
	, ['2'] = { 'a', 'b', 'c', '2' }
	, ['3'] = { 'd', 'e', 'f', '3' }
	, ['4'] = { 'g', 'h', 'i', '4' }
	, ['5'] = { 'j', 'k', 'l', '5' } 
	, ['6'] = { 'm', 'n', 'o', '6' }
	, ['7'] = { 'p', 'q', 'r', 's', '7' }
	, ['8'] = { 't', 'u', 'v', '8' }
	, ['9'] = { 'w', 'x', 'y', 'z', '9' }
	, ['0'] = { '0' }
}

local UPPER = false
local case = function (c)
	return (UPPER and string.upper(c)) or c
end

local dx, dy = canvas:attrSize()
canvas:attrFont('vera', dy/12)

function ajuste_text( str , dx_max, dy_max, p_x, p_y)
	
	local aux -- variavel auxiliar que auxilia na impressão do texto
 	local dx, dy -- recebe as dimensões do texto
 	local len -- recebe o tamaho da string
 	local py = p_y
 
 	len=string.len(str) -- tamanho da string
 	dx,dy = canvas:measureText(str)-- dimensões do texto
 	
 	-- determina o comprimento maximo da string naquela região
 		while(dx>dx_max) do
 			len=len-1
 			aux=string.sub(str,0,len)
 			dx,dy=canvas:measureText (aux)
 		end
 	-- imprime a string adequadamente 
 	while(string.len(str)>len)do
 		aux=string.sub(str,0,len)
 		str=string.sub(str,len+1)
 		canvas:drawText( p_x , py , aux ) -- desenha cada linha do texto
 		py = py + dy
 	end	
 	
 	canvas:drawText( p_x , py , str ) -- desenha a ultima linha do texto
 	py = py + dy
 	
 	return py-- retorna a posiçaõ y para impressão
 	 
 end	

function redraw ()
	local py = 52

	canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
	canvas:clear () -- Limpa o Canvas
	
	canvas:compose(0, 0 , img )-- desenha a imagem
	canvas:attrColor('black')
	
	ajuste_text( TEXT..case(CHAR)..'|' , dx-16, 0 , 8 , 52)
	--canvas:drawText(8,py, TEXT..case(CHAR)..'|')

	canvas:flush()
end

local function setText (new, outside)
	TEXT = new or TEXT..case(CHAR)
	text = TEXT
	CHAR, UPPER = '', false
	KEY, IDX = nil, -1
end

local TIMER = nil
local function timeout ()
	return event.timer(1000,
		function()
			if KEY then
				setText()
			end
		end)
end

local sel = {
    class = 'ncl',
    type  = 'presentation',
    label = 'sair_add3',
}
	
local evt2 = {
	class = 'ncl',
	type = 'attribution',
	name = 'NewComA',
}	


local function nclhandler_ap(evt)

	if evt.class == 'ncl' then   
		if evt.type == 'attribution' then 
		   if evt.name == 'visi_ac' then
				if evt.action == 'start' then		 
		   			if evt.value == '1' then
		   				evt.action = 'stop';event.post(evt)
		   				redraw()
		   				visible_ac = true
		   				
		   				
		   				
		   			end
		   		end
		   	end
		end
	end	  				
end
event.register(nclhandler_ap)


local function keyHandler (evt)
	if visible_ac then
	if evt.class == 'key' then --return end
	if evt.type == 'press' then --return true end
	local key = evt.key

	-- SELECT
	if (key == 'ENTER') then
		
		canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
		canvas:clear () -- Limpa o Canvas
		canvas:flush() -- atualiza o canvas
		
		evt2.value = TEXT..case(CHAR)
		
		evt2.action ='start';event.post(evt2)
		evt2.action = 'stop';  event.post(evt2)
		
		event.timer(100, function()
			sel.action = 'start'; event.post(sel)
			sel.action = 'stop';  event.post(sel)
		end)
		 
		TEXT = ''
		CHAR = ''	 
		KEY, IDX = nil, -1
		UPPER = false
		TIMER = nil
		
		visible_ac = false

	-- BACKSPACE
	 elseif (key == 'CURSOR_LEFT') then
		setText( (KEY and TEXT) or string.sub(TEXT, 1, -2) )

	-- UPPER
	elseif (key == 'CURSOR_UP') then
		UPPER = not UPPER

	-- SPACE
	elseif (key == 'CURSOR_RIGHT') then
		setText( (not KEY) and (TEXT..' ') )

	-- NUMBER
	elseif _G.tonumber(key) then
		if KEY and (KEY ~= key) then
			setText()
		end
		IDX = (IDX + 1) % #MAP[key]
		CHAR = MAP[key][IDX+1]
		KEY = key 
	end

	if visible_ac and TIMER then TIMER() end
	TIMER = timeout()
	if visible_ac then
	redraw()
	end
	return true
	
	end
   end
  end
  
end
event.register(keyHandler)

