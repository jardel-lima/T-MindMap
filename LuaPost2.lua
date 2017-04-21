local TEXT='' --  Varialvel do tema
local post={} -- Tabela com os posts, contem o texto, quantidade de respostas e o numero da linha no arquivo .txt
local texto={} -- Tabela com o arquivo .txt completo
local resp={} -- Tabela com as respostas dos posts
local fille_p = '' --= 'test.txt'-- Nome do aquivo
local Dx, Dy = canvas:attrSize()-- dimensões do canvas
local selecaop = 1 -- Seleção do post 
local visible=false -- variavel de visibilidade
local newpost=''
local img=canvas:new('media/ret_central.png')-- carrega a imagem 
local img2=canvas:new('media/ret_post.png')-- carrega a imagem
local img3=canvas:new('media/ret_post_sel.png')-- carrega a imagem

--Tabelas usadas para comunicação com o ncl
local selp = {
    class = 'ncl',
    type  = 'presentation',
    label = 'sair_',
}

local selp2 = {
    class = 'ncl',
    type  = 'presentation',
    label = 'exibir_com',
}

local selp3 = {
    class = 'ncl',
    type  = 'presentation',
    label = 'add_post',
}

local evtp = {
    class = 'ncl',
    type  = 'attribution',
    name  = 'Com',
}
-- Zerar todas as tabelas
function zerar_tabelas()
	local i
	local tam
	
	tam=#texto
	
	for  i=tam , 1 , -1  do
		table.remove (texto , i )
	end
	
	tam=#post
	
	for i=tam , 1 , -1 do
		table.remove (post , i )
	end
	
	tam=#resp
	
	for i=tam , 1 , -1 do
		table.remove (resp , i )
	end
	
end		
	
-- Carrega a tabela com os posts e outra com as respostas
function carrega(File)
	local j = 1
	local i = 0
	local k = 1
	local ii
	local ff
	
	zerar_tabelas()
	
	for aux in io.lines(File) do
		   
			i = i + 1
			texto[i] = aux	
			
	end			
	for i=1, #texto do
		if(#post < 4) then
			if ( string.find(texto[i],"||") ) then
				ii , ff = string.find(texto[i],"||")
				post[j]={txt=string.sub(texto[i],1,ii-1),num=tonumber(string.sub(texto[i],ff+1)),line=i}-- Armazena o post, numero de respostas e a linha do arquivo .txt
				if(post[j].num ~= 0) then
					ii , ff = string.find(texto[i+1],"\\")
					resp[j]=string.sub(texto[i+1],1,ii-1)
				end	
		 		j=j+1
		 	end
		end
	end			
end

-- Função que imprime o texto adequadamente na regiã]o delimitada
function ajuste_text( str , dx_max, dy_max, p_x, p_y)
	
	local aux -- variavel auxiliar que auxilia na impressão do texto
 	local dx, dy -- recebe as dimensões do texto
 	local len -- recebe o tamaho da string
 	local py = p_y
 	local dy2 = 0
 	local i = 1
 	
 	len=string.len(str) -- tamanho da string
 	dx,dy = canvas:measureText(str)-- dimensões do texto
 	dy2=dy
 	-- determina o comprimento maximo da string naquela região
 	if(dx>dx_max)then
 		while(dx>dx_max) do
 			len=len-1
 			aux=string.sub(str,0,len)
 			dx,dy=canvas:measureText (aux)
 		end
		len = len-1
	end	
 	-- imprime a string adequadamente 
 	if dy_max~= 0 then
 		while(string.len(str)>len and dy2 <= dy_max)do
 			aux=string.sub(str,0,len)
 			str=string.sub(str,len+1)
 			canvas:drawText( p_x , py , aux ) -- desenha cada linha do texto
 			py = py + dy
 			dy2 = dy2 + dy
 		end
 		if(dy2 <= dy_max)then
 			canvas:drawText( p_x , py , str ) 			
 		else
 			canvas:drawText( p_x , py , '...' )
 		end		
 	elseif dy_max == 0 then
 		
 		while(string.len(str)>len)do
 			i = i + 1
 			aux=string.sub(str,0,len)
 			str=string.sub(str,len+1)
 			canvas:drawText( p_x , py , aux ) -- desenha cada linha do texto
 			py = py + dy
 		end	
 		if string.len(str)~= 0 then
 			canvas:drawText( p_x , py , str )
 			i = i + 1
 		end	
 	end
 	
 	--canvas:drawText( p_x , py , str ) -- desenha a ultima linha do texto
 	py = py + dy
 	
 	return py , i-- retorna a posiçaõ y para impressão
 	 
 end	

-- Ajusta e exibe o texto nos retangulos
function DrawText ( n, p_x, p_y, dx_max, dy_max )
	
	local ddx -- comprimento do texto
	local ddy -- altura do texto
	local py = p_y -- posisão y para desenho
	local pyLine
	local str -- recebe o texto a ser exibido
	local i = 1
	local ddy_aux
	local i2 = 1
		
	canvas:attrFont ('vera', 18) -- Tipo e tamanho do texto do post
	canvas:attrColor('black') -- Cor do texto
	
	str=post[n].txt -- texto a ser recebido
	
	ddx,ddy_aux = canvas:measureText (str) -- dimensões do texto
	
	pyLine , i = ajuste_text( str , dx_max , 0 , p_x , py )
	
	--canvas:attrColor('red')
 	--canvas:drawLine(p_x, pyLine , dx_max ,pyLine) -- desenha uma linha divisória 
		
	canvas:attrFont ('vera', 14) -- tipo e tamanaho do texto de comentario
	
	if(#resp ~= 0) then
		str=resp[n] -- recepe o primeiro comentario do post
		
		str = tostring(str)
		
		ddx,ddy = canvas:measureText (str) -- dimensões do texto
	
		py=pyLine+(ddy*0.5) -- cordenada y do texto a ser impresso
	
		pyLine,i2 = ajuste_text( str , dx_max , dy_max - (i*ddy_aux)  , p_x , py )
	end	
	
end 

--Desenha toda a tela
function redraw ( select )

	local dx,dy = 0.47*Dx,0.385*Dy -- Tamanhos dos retangulos
	local draw={} -- Tabela que contem os posições que os retangulas teram
	
	canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
	canvas:clear () -- Limpa o Canvas
			
	draw[1]={tipo='fill', px=0.02*Dx ,py = 0.02*Dy , dimx=dx , dimy = dy } -- Primeiro retângulo 
	draw[2]={tipo='fill', px=((0.04*Dx)+dx) , py=0.02*Dy ,dimx= dx ,dimy= dy } -- Segundo retângulo
	draw[3]={tipo='fill',px= 0.02*Dx ,py= ((0.06*Dy)+(dy+0.15*Dy)) ,dimx= dx , dimy=dy } -- Terceiro retângulo
	draw[4]={tipo='fill', px=((0.04*Dx)+dx) , py=((0.06*Dy)+(dy+0.15*Dy)) ,dimx= dx ,dimy= dy } -- Quarto retângulo
			
	canvas:compose(0.1*Dx, (0.04*Dy)+dy , img )-- desenha a imagem
	
	for i=1, #post do -- Iprime a quantidade de retangulos de acordo com a quantidade de posts
	 	canvas:compose(draw[i].px,draw[i].py , img2 )-- desenha a imagem
		if ( i == select ) then
	 		canvas:compose(draw[i].px,draw[i].py , img3 )-- desenha a imagem
	 	end 	
	 		
		DrawText(i,draw[i].px+7,draw[i].py+5, dx-10,dy-10)-- ajusta e desenha cada texto
	 end
	
	canvas:attrFont ('vera', 24) -- Padrão e tamanho do texto do retangulo central
	canvas:drawText( 0.1*Dx + 10, (0.04*Dy)+ dy + 2, TEXT) -- Desenha o texto central(tema principal)
	
	canvas:flush() -- atualiza o canvas
	
end
 
local function nclhandlerp(evt)
	local txt=''
	if evt.class == 'ncl' then   
		if evt.type == 'attribution' then  
			if evt.name == 'Tema1' then 
				if evt.action == 'start' then   -- Somente se  ocorrer atribuição na variavel Temas
					
					TEXT = evt.value -- recebe o tema selecionada
					fille_p = TEXT..".txt"--Nome do arquivo .txt do tema
										
				end	
				
			elseif evt.name =='visi_p' then -- variavel que valida a visibilidade
					if evt.value == '1' then
						visible = true	
						carrega(fille_p)
					end	
			
			elseif visible and evt.name =='add_p' then
					if evt.action=='start' then
							canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
							canvas:clear () -- Limpa o Canvas
							canvas:flush() -- atualiza o canvas
							
							selp3.action = 'start';event.post( selp3 )
				    		selp3.action = 'stop';event.post( selp3 )
				    		
				    		visible = false
					end	
			elseif evt.name == 'NewPost' then
						
						newpost = evt.value
						txt = io.open(fille_p,'a+')
						txt:write(newpost..'|| 0 \n')
						io.close (txt)
						carrega(fille_p)
						visible=true  
	
			end
			evt.action = 'stop'; event.post(evt)	
					
		end
	end	
					
	if( visible and (TEXT ~='')) then
		redraw(selecaop)
	end		


end

event.register(nclhandlerp) 
 
local function handler (evt)

	if (visible and (evt.class == 'key' and evt.type == 'press')) then
		
			if( evt.key == 'CURSOR_DOWN') then
				selecaop = selecaop + 1
			elseif (  evt.key == 'CURSOR_UP') then
				selecaop = selecaop - 1	
  			elseif ( evt.key == 'ENTER')then
  				
  				--if(#resp~=0)then
					visible=false
  				
  					canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
					canvas:clear () -- Limpa o Canvas
					canvas:flush() -- atualiza o canvas
				
  					evtp.value = post[selecaop].line
  					evtp.action = 'start';event.post(evtp)
					evtp.action = 'stop';event.post(evtp)
				
					selp2.action = 'start';event.post( selp2 )
					selp2.action = 'stop';event.post( selp2 )
			--	end		
  			elseif (evt.key == 'CURSOR_LEFT' )then
  				
  				visible = false	
  				selecaop = 1
  				zerar_tabelas()
  				
  				canvas:attrColor(0,0,0,0) -- Deixa a cor padrão transparente
				canvas:clear () -- Limpa o Canvas
				canvas:flush() -- atualiza o canvas
  
  				event.timer(200, function()
						selp.action = 'start'; event.post(selp)
  						selp.action = 'stop';  event.post(selp)
				end)
  				
  			end
  				
	end		
		
	if selecaop < 1 then
		selecaop = #post
	elseif selecaop > #post  then
		selecaop = 1	
 	end
		
	if(visible) then
		redraw(selecaop)
	end	
	 
end		

event.register(handler)	
