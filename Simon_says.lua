script_name("SimonSays")
script_version("1.0")
local event	= require ('samp.events')
local key = require "vkeys"
simons = {'Haruki_DeKaluga', 'Artem_Krukin', 'Gregary_House'}
local work = true
local sx, sy = getScreenResolution()
local spx,spy = math.random(-1,1),math.random(-1,1)
local x, y, z = getCharCoordinates(playerPed)

function main()
    while not isSampAvailable() do wait(110) end
    if not isSampfuncsLoaded() and not isCleoLoaded() then return end
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	myNick = sampGetPlayerNickname(myid)

	autoupdate("https://raw.githubusercontent.com/Plavluha/SimonSays/main/simsays.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Plavluha/SimonSays/main/Simon_says.lua")

	sampRegisterChatCommand('simon',function()
		work = not work
		if work then
			sampAddChatMessage('{7B68EE}[Neddie] {ffffff}SimonSays [{33EA0D} Activated {ffffff}]',-1)
		else
			sampAddChatMessage('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} Deactivated {ffffff}]',-1)
		end
	end)
end

function event.onServerMessage(color,text)
	if work then
		if text:find('%(%( .+%[%d+%]: %{B7AFAF%}#.+ %)%)') then -- комманда
			print(text)
			local simon, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}#(.+)%{FFFFFF%} %)%)')
			if table.concat(simons, ', '):find(simon) then
				if simon  == myNick then
					print('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} ERROR {ffffff}]')
				else
					lua_thread.create(function()
						wait(500)
						sampProcessChatInput(command)
					end)
				end
			end
		elseif text:find('%(%( (.+)%[%d+%]: %{B7AFAF%}.+, .+%{FFFFFF%} %)%)') then -- обращение
			print(text)
			local simon, who, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}(.+), (.+)%{FFFFFF%} %)%)')
			if table.concat(simons, ', '):find(simon) then
				if simon  == myNick then
					print('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} ERROR1 {ffffff}]')
				else
					if tonumber(who) and tonumber(who) == myid then
						lua_thread.create(function()
							wait(500)
							sampProcessChatInput(command)
						end)
					else
						print('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} Разные myid и обращение к кому-то {ffffff}] Обращение: '..who..' Мой ид: '..myid)
					end
				end
			else 
				print('error')
			end
		elseif text:find('%(%( .+%[%d+%]: %{B7AFAF%}!!.+ сюда%{FFFFFF%} %)%)') then -- ходьба сюда
			local simon, id, who = string.match(text, '%(%( (.+)%[(.+)%]: %{B7AFAF%}!!(.+) сюда%{FFFFFF%} %)%)')
			print('simon: '..simon..' id: '..id..' who: '..who)
			if table.concat(simons, ', '):find(simon) then
				if simon  == myNick then
					print(' ')
				else
					if tonumber(who) and tonumber(who) == myid then
						local px,py,pz = playerpos(id)
						go_to_point(px,py)
					else
						print('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} ERROR {ffffff}]')
					end
				end
			end
		end
		if text:find('Ваше сообщение зарегистрировано в системе и будет опубликовано после редакции!') or text:find('Ваше VIP сообщение зарегистрировано в системе и будет опубликовано после редакции!') then
			lua_thread.create(function()
				wait(29500)
				sampAddChatMessage(TAG..'НОВОЕ ОТПРАВЛЯЙ',-1)
				addOneOffSound(x,y,z,1052)
			end)
		end
	end
end
--addOneOffSound(xx,yy,zz,1052)
--[[function setCameraPos(a, b)
    local z = b[1] - a[1]
    local camZ = math.atan((b[2] - a[2]) / z)
    if z >= 0.0 then
        camZ = camZ + 3.14
    end
    setCameraPositionUnfixed(0.0, camZ)
end--]]


function go_to_point(px,py)
    local dist
    repeat
        set_camera_direction(point)
        wait(0)
        setGameKeyState(1, -255)
        local x, y, z = getCharCoordinates(playerPed)
		setGameKeyState(16, 255)
        dist = getDistanceBetweenCoords2d(x, y, px, py)
    until dist < 0.6
end

function set_camera_direction(x,y)
    local c_pos_x, c_pos_y, c_pos_z = getActiveCameraCoordinates()
    local vect = {x = x - c_pos_x, y = y - c_pos_y}
    local ax = math.atan2(vect.y, -vect.x)
    setCameraPositionUnfixed(0.0, -ax)
end

--[[function runTo(bx,by,cx,cy)
	setCameraPos({bx,by},{cx+spx,cy+spy})
	setGameKeyState(1,-256)
	setGameKeyState(16,256)
end
--]]
function playerpos(params)
    local id = string.match(params, "(%d+)")
    local result, handle = sampGetCharHandleBySampPlayerId(id)
    local px, py, pz = getCharCoordinates(handle)
	return px, py, pz
end
--[[
local time = os.clock() + 5
sampAddChatMessage("{7B68EE}[Neddie] {ffffff}SimonSays | Поступило предложение ввода команды, выберите исход", 0x99FF99)
local len = renderGetFontDrawTextLength(font, "Исход: {8ABCFA}Выбор ответа")
while true do wait(0) 
	if time < os.clock() and answ = 0 then
		while true do
			wait(0)
			renderFontDrawText(font, "Исход: {8ABCFA}Выбор ответа\n{FFFFFF}[{67E56F}1{FFFFFF}] - Ввести.\n{FFFFFF}[{67E56F}2{FFFFFF}] - Не вводить.", sx-len-10, sy-150, 0xFFFFFFFF)					
			if isKeyJustPressed(VK_1) and not sampIsChatInputActive() and not sampIsDialogActive() then
				lua_thread.create(function()
					wait(500)
					sampProcessChatInput(command)
				end)
				answ =1
			end
			if isKeyJustPressed(VK_2) and not sampIsChatInputActive() and not sampIsDialogActive() then answ =1; break end
		end
	end
end
--]]

function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((prefix..'Обновление завершено!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end
