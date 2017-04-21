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
local line --linha que contém o post desejado
local texto_r={}
local resp_r={}
local visible_r = false 
local selecao = 2
local num -- recebe o número de comentários do post 
local fille_r = ''
local TEXT_r = ''
local nota
local NOTA =''
local KEY = ' '
local visible_nota = false
local img = canvas:new('media/dar_nota.png')-- carrega a imagem 
local Dx, Dy = canvas:attrSize()-- dimensões do canvas 
	
local selr = {
    class = 'ncl',
    type  = 'presentation',
    label = 'sair_2',
}

local selr2 = {
    class = 'ncl',
    type  = 'presentation',
    label = 'add_com',
}

local selr3 = {
    class = 'ncl',
    type  = 'presentation',
    label = 'dar_nota_area',
}

-- Zerar todas as tabelas
local function zerar_tabelas()
	local i
	local tam
	
	tam=#texto_r
	
	for  i=tam , 1 , -1  do
		table.remove (texto_r , i )
	end
		
	tam=#resp_r
	
	for i=tam , 1 , -1 do
		table.remove (resp_r , i )
	end
	
end		
	
-- Carrega a tabela com os posts e outra com as respostas
local function carrega(File)
	
	local i = 0
	local ii
	local ff
	local ii2
	local ff2
	local aux
	
	zerar_tabelas()
	
	for aux in io.lines(File) do
		   
			i = i + 1
			texto_r[i] = aux	
			
	end
	
	ii , ff = string.find(texto_r[line],"||")
	
	num=tonumber(string.sub(texto_r[line],ff+1))
	
	resp_r[1]={txt=string.sub(texto_r[line],1,ii-1),line=line}
	i=line+1
			
	for j = 2 , num+1  do
		
		ii , ff = string.find(texto_r[i],"\\")-- procura ate onde vai o texto
		aux = string.sub(texto_r[i],ff+1)
		ii2 , ff2 = string.find(aux,"!")-- procura a quantidade de votos e a nota média
		resp_r[j]={txt=string.sub(texto_r[i],1,ii-1),soma=tonumber(string.sub(aux,2,ii2-1)),votos=tonumber(string.sub(aux,ff2+1)),line=i}
		if(resp_r[j].soma== 0 or resp_r[j].votos==0)then
			resp_r[j].media = 0
		else
			resp_r[j].media=resp_r[j].soma/resp_r[j].votos
		end		
		i=i+1
	end		
end

local function ajuste_text_aux(str, dx_max)
	local aux -- variavel auxiliar que auxilia na impressão do texto
 	local dx,dx2,dy -- recebe as dimensões do texto
 	local len -- recebe o tamaho da string
 	local int, fracao
	local line_extra = 1
	local cont = 0
	
	len=string.len(str) -- tamanho da string
 	dx,dy = canvas:measureText(str)-- dimensões do texto
 	dx2=dx
 	
 	-- determina o comprimento maximo da string naquela região
 	while(dx2>dx_max) do
 		len=len-1
 		aux=string.sub(str,0,len)
 		dx2,dy=canvas:measureText (aux)
 	end
 	
 	while(string.len(str)>len)do
 		aux=string.sub(str,0,len)
 		str=string.sub(str,len+1)
 		cont = cont + 1
 	end	
 	
 	if string.len(str)~= 0 then
 		cont = cont + 1
 	end	

 	return (cont)*dy + 5, cont -- retorna a tamanho em y a ser acupado com a string str
 
 end	
 	
 	
local function ajuste_text( str , dx_max, dy_max, p_x, p_y)
	
	local aux -- variavel auxiliar que auxilia na impressão do texto
 	local dx, dy -- recebe as dimensões do texto
 	local len -- recebe o tamaho da string
 	local py = p_y
 	local cont =1
 
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
 		cont = cont + 1
 	end	
 	
 	canvas:drawText( p_x , py , str ) -- desenha a ultima linha do texto
 	py = py + dy
 	
 	return py,cont*dy + 5-- retorna a posiçaõ y para impressão
 	 
 end

-- Mostr todas as respostas  do post que está na linha num_line do arquivo .txt
local function resp_completa(select)
 	
 	local str
 	local dx, dy -- dimensões do texto
 	local dy_ret -- altura do retangulo a ser desenhado
 	local ddy = 0 -- posição y do texto a ser mostrado 
 	local ddy_aux = 0
 	local i = 1
 		 	
 	canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
	canvas:clear () -- Limpa o Canvas
 	
 	canvas:attrFont ('vera', 24) -- Tipo e tamanho da Fonte
 	canvas:attrColor('black') -- Cor da Fonte
 
 	str=resp_r[i].txt -- Titulo do post	
 	ddy = ajuste_text( str , Dx-20 , 0 , 15 , ddy+10 ) -- Desenhará o texto corretamente
 	 
 	canvas:attrColor('gray') -- Cor da Linha 
 	canvas:drawRect('fill', 12 , ddy , Dx-24 , 10 )-- retangulo de divisória
 
 	ddy = ddy+10  	
	i = i+1 -- Aparti dessa linha será as respostas do post

	canvas:attrFont ('vera', 20) -- Tipo e tamanho da Fonte
	canvas:attrColor('black') -- Cor da Fonte
	
	dx,dy =  canvas:measureText(str) -- dimensões das respostas
	ddy = ddy + dy*0.1 + 3 -- Espaço entre a lina divisória e o texto
	
	-- enquanto exitir resposta para aquele post mostre-a
	while( i <= #resp_r) do 
		local aux
		str = resp_r[i].txt -- carrega as respostas do post
 	 	aux = tostring(resp_r[i].media)
 	 	
 	 	if string.len(aux)>3 then
 	 		aux=string.sub(aux,1,3)
 	 	end	
 	 		
 	 	canvas:attrColor('black')	
 		ddy_aux,dy_ret = ajuste_text( str.." Nota: "..aux , (Dx*0.96)-11 , 0 , 20 , ddy+3 )	
 	 	
 	 	if (select == i ) then -- se a resposta corresponder a selecionada mostre-a destacada
 	 		canvas:attrColor('yellow') -- Cor da Fonte
 	 	else 
 	 		canvas:attrColor(255,102,0,255) -- Cor retangulo
 	 	end
 	 	local sum_Dx = 1
 	 	--Desenha um retângulo
 	 	for i = 1, 5 , 1 do
 	 		canvas:drawRect("frame",13+i,ddy+(i-1),(Dx*0.96)-sum_Dx,dy_ret-(sum_Dx-1))
 	 		sum_Dx = sum_Dx + 2
 	 	end
 	 	--[[	 
 	 	canvas:drawRect("frame",14,ddy,(Dx*0.96)-1,dy_ret)
 	 	canvas:drawRect("frame",15,ddy+1,(Dx*0.96)-3,dy_ret-2)
 	 	canvas:drawRect("frame",16,ddy+2,(Dx*0.96)-5,dy_ret-4)
 	 	canvas:drawRect("frame",17,ddy+3,(Dx*0.96)-7,dy_ret-6)
 	 	canvas:drawRect("frame",18,ddy+4,(Dx*0.96)-9,dy_ret-8)]]--
 	 	canvas:attrColor('gray')
 	 	canvas:drawRect('fill',14,ddy-5,(Dx*0.96)-1, 10) -- Desenha o Retangulo
 	 	  
 	 	ddy = ddy_aux + dy*0.1 + 6
 	 	i = i + 1
 	 	
	end
	 
	 canvas:flush()
end

local function redraw ()
	local py = 52
	
	canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
	canvas:clear () -- Limpa o Canvas
	
	canvas:compose(Dx*0.3437, Dy*0.35 , img )-- desenha a imagem
	canvas:attrColor('black')
	canvas:attrFont ('vera', 24) -- Tipo e tamanho da Fonte
	
	if KEY~=' ' and tonumber(NOTA..KEY) < 11 then
		NOTA = NOTA..KEY
	end
	
	ajuste_text( NOTA..'|' , 500, 0 , Dx*0.47 , Dy*0.47)
	--canvas:drawText(8,py, TEXT..case(CHAR)..'|')

	canvas:flush()
end


local function ordenar()
	local aux
	local aux2

	for i=2, #resp_r-1, 1 do
		aux = i
		for j=i+1, #resp_r, 1 do
			if resp_r[aux].media <= resp_r[j].media then
				
				aux = j
			end	
				 
		end
	
		if aux~=i then
			aux2 = resp_r[i].txt
			resp_r[i].txt = resp_r[aux].txt
			resp_r[aux].txt = aux2

			aux2 = resp_r[i].media
			resp_r[i].media = resp_r[aux].media
			resp_r[aux].media = aux2

			aux2 = resp_r[i].votos
			resp_r[i].votos = resp_r[aux].votos
			resp_r[aux].votos = aux2

			aux2 = resp_r[i].line
			resp_r[i].line = resp_r[aux].line
			resp_r[aux].line = aux2
			
			aux2 = resp_r[i].soma
			resp_r[i].soma = resp_r[aux].soma
			resp_r[aux].soma = aux2
		end
	end
	
	for i=2, #resp_r-1, 1 do
		aux = i
		for j=i+1, #resp_r, 1 do
			if resp_r[aux].media == resp_r[j].media and resp_r[aux].votos < resp_r[j].votos then
				aux = j	
			end 	
		end
		if aux~=i then
			aux2 = resp_r[i].txt
			resp_r[i].txt = resp_r[aux].txt
			resp_r[aux].txt = aux2

			aux2 = resp_r[i].media
			resp_r[i].media = resp_r[aux].media
			resp_r[aux].media = aux2

			aux2 = resp_r[i].votos
			resp_r[i].votos = resp_r[aux].votos
			resp_r[aux].votos = aux2

			aux2 = resp_r[i].line
			resp_r[i].line = resp_r[aux].line
			resp_r[aux].line = aux2
			
			aux2 = resp_r[i].soma
			resp_r[i].soma = resp_r[aux].soma
			resp_r[aux].soma = aux2
		end
	end
end

local function substituir()
	local linha_texto = resp_r[1].line
	for i = 2, #resp_r, 1 do
		if (resp_r[i].line ~=( (i - 1) + linha_texto) ) then
		--	table.remove(texto_r,linha_texto+i)
		--	table.insert(texto_r,linha_texto+i,resp_r[i].txt..'\\\\'..resp_r[i].media..'!'..resp_r[i].votos)
			texto_r[linha_texto+(i-1)] = resp_r[i].txt..'\\\\'..resp_r[i].soma..'!'..resp_r[i].votos
		end
	end
end



local function nclhandler_r(evt)
	local newCom = ''

	if evt.class ~= 'ncl'  then return end   
		if evt.type ~= 'attribution' then return end  
			if evt.name == 'Com2' then
				
				line = evt.value
				evt.action = 'stop' -- finaliza a atribuição
				event.post(evt)
				line = tonumber(line)
				
			elseif evt.name == 'Tema3' then 
					TEXT_r = evt.value -- recebe o tema selecionada
					evt.action = 'stop' -- finaliza a atribuição
					fille_r = TEXT_r..".txt"--Nome do arquivo .txt do tema
					
					event.post(evt)
					carrega(fille_r)
					visible_r=true
					
			elseif visible_r and evt.name == 'add_c' then
			
					
					canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
					canvas:clear () -- Limpa o Canvas
					canvas:flush() -- atualiza o canvas
					
					selr2.action = 'start';event.post( selr2 )
				    selr2.action = 'stop';event.post( selr2 )
				    		
				    visible_r = false
			   				
			elseif evt.name == "NewCom" then
				newCom = evt.value..'\\\\0!0'
				evt.action = 'stop' -- finaliza a atribuição
				event.post(evt)
				table.insert(texto_r,resp_r[#resp_r].line+1,newCom)
				texto_r[resp_r[1].line] = resp_r[1].txt..'||'..num+1
				
				local txt
				
				txt = io.open (fille_r , 'w+')
				
				for i = 1 , #texto_r , 1 do
					txt:write(texto_r[i]..'\n')
				end
				
				io.close (txt)
				
				carrega(fille_r)
				
				visible_r = true
			
			elseif visible_r and evt.name == 'dar_nota' then
			 	if evt.action =='start' then
			 		if evt.value == '1' then
						
						canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
						canvas:clear () -- Limpa o Canvas
						canvas:flush() -- atualiza o canvas
						
						selr3.action = 'start';event.post( selr3 )
				    	--selr3.action = 'stop';event.post( selr3 )
				    	
						visible_nota = true
						visible_r = false
						redraw()
					end
				end	
			end		
	
	if(visible_r) then
		resp_completa(selecao)
	end	
	
end

event.register(nclhandler_r) 


local function handler_r (evt)

	if ((visible_r or visible_nota) and (evt.class == 'key' and evt.type == 'press')) then
					
			if(visible_r and evt.key == 'CURSOR_DOWN') then
				
				selecao = selecao + 1
			
			elseif (visible_r and evt.key == 'CURSOR_UP') then
			
				selecao = selecao - 1	
				
			elseif (visible_r and evt.key == 'CURSOR_LEFT' )then
				
				visible_r = false
				selecao = 2
				
				canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
				canvas:clear () -- Limpa o Canvas
				canvas:flush() -- atualiza o canvas
  				
  				event.timer(100, function()
						selr.action = 'start'; event.post(selr)
  						selr.action = 'stop';  event.post(selr)
				end)
  				
  			elseif (visible_nota and _G.tonumber(evt.key)) then
				KEY = evt.key
				redraw()
				KEY = ' '
				
			elseif (visible_nota and string.len(NOTA)~=0 and evt.key == 'CURSOR_LEFT') then
			 	
			 	NOTA = string.sub(NOTA, 1, -2)
			 	redraw()
			 	
			elseif( visible_nota and string.len(NOTA)~=0 and evt.key == 'ENTER') then
				local aux
				local txt
				
				canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
				canvas:clear () -- Limpa o Canvas
				canvas:flush() -- atualiza o canvas
				
				KEY = ' '
				
				visible_nota = false
				visible_r = true
				
				nota = tonumber(NOTA)
				NOTA = ''
				
				resp_r[selecao].votos = resp_r[selecao].votos + 1
				resp_r[selecao].soma = resp_r[selecao].soma + nota
				resp_r[selecao].media = resp_r[selecao].soma /resp_r[selecao].votos				
			--	aux=tonumber(string.sub(aux,1,5))
				texto_r[resp_r[selecao].line] = resp_r[selecao].txt..'\\\\'..resp_r[selecao].soma..'!'..resp_r[selecao].votos
				
				ordenar()
				
				substituir()
				
				txt = io.open (fille_r , 'w+')
				for i = 1 , #texto_r , 1 do
					txt:write(texto_r[i]..'\n')
				end
				io.close (txt)
				carrega(fille_r)
				
				--selr4.action = 'start';event.post( selr4 )
				selr3.action = 'stop';event.post( selr3 )
					
  			end	
  		
	end
		
	if selecao < 2 then
		selecao = #resp_r
	elseif selecao > #resp_r  then
		selecao = 2
	end
		 
	if(visible_r) then
		resp_completa(selecao)
	end		
	
end

event.register(handler_r)	
