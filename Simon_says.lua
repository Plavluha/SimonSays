local event	= require ('samp.events')
local key = require "vkeys"
local work = true
local sx, sy = getScreenResolution()
local inicfg = require 'inicfg'
local spx,spy = math.random(-1,1),math.random(-1,1)
local TAG = '{7B68EE}[Neddie] {CFCFCF}SimonSays | {9B9B9B}'
local simons_str = ''

local enable_autoupdate = true
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[INSERT_CODE_HERE]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "JSON?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "SCRIPT_URL"
        end
    end
end

local directIni = '#SimonSays.ini'

local ini = inicfg.load(inicfg.load({
	simons_list = {'Neddie_Barlow'}
}, directIni))
simons = ini.simons_list

function main()
    while not isSampAvailable() do wait(110) end
    if not isSampfuncsLoaded() and not isCleoLoaded() then return end
	
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	myNick = sampGetPlayerNickname(myid)
	
	  -- вырежи тут, если хочешь отключить проверку обновлений
	  if autoupdate_loaded and enable_autoupdate and Update then
		pcall(Update.check, Update.json_url, Update.prefix, Update.url)
	  end
	  -- вырежи тут, если хочешь отключить проверку обновлений
	
	sampRegisterChatCommand('shelp',function()
		sampShowDialog(984725,'Информация о SimonSays:','Команды скрипта:\n1. shelp - Открытие пояснялочки\n2. simon - Вкл/Выкл поиска команд саймона\n3. sadd - Добавление нового саймона\n4. sdell - Удаление действующего саймона\n5. slist - Список действующих саймонов.','Ясно','Закрыть',0)
	end)
	sampRegisterChatCommand('sadd',function(arg)
		if string.match(arg,'%a+%p%a+') then
			if table.concat(simons):find(arg) then
				sampAddChatMessage(TAG..'Саймон с ником {CFCFCF}'..arg..'{9B9B9B} уже имеется в списке.',-1)
			else
				table.insert(simons,arg)
				ini.simons_list = simons
				inicfg.save(ini, directIni)
				sampAddChatMessage(TAG..'Вы добавили {CFCFCF}'..arg..'{9B9B9B} в список саймонов.',-1)
			end
		else
			sampAddChatMessage(TAG..'Такой ник неприемлим.',-1)
		end
	end)
	sampRegisterChatCommand('sdell',function(arg)
		if tonumber(arg) then
			for i= arg, #simons do 
				sampAddChatMessage(TAG..'Вы успешно удалили {CFCFCF}'..simons[i]..' {9B9B9B}со списка',-1)
			end
			table.remove(simons,arg)
			ini.simons_list = simons
			inicfg.save(ini, directIni)
		else
			sampAddChatMessage(TAG..'Введите номер саймона, который вы хотите удалить. Для просмотра списка используйте /slist',-1)
		end
	end)
	sampRegisterChatCommand('slist',function()
		if simons == '' then
			sampAddChatMessage(TAG..'{9B9B9B} Список пуст.',-1)
		else
			sampAddChatMessage(TAG..'Список действующих саймонов: (копия в консоле(~))',-1)
			for i=1, #simons do
				print(i..'. '..simons[i])
				sampAddChatMessage(TAG..''..i..'. {CFCFCF}'..simons[i],-1)
			end
		end
	end)
	sampRegisterChatCommand('simon',function()
		work = not work
		if work then
			sampAddChatMessage('{7B68EE}[Neddie] {CFCFCF}SimonSays [{33EA0D} Activated {CFCFCF}]',-1)
		else
			sampAddChatMessage('{7B68EE}[Neddie] {CFCFCF}SimonSays [{F51111} Deactivated {CFCFCF}]',-1)
		end
	end)
end

function event.onServerMessage(color,text)
	if work then
		if text:find('%(%( .+%[%d+%]: %{B7AFAF%}#.+ %)%)') then -- команда
			print(text)
			local simon, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}#(.+)%{CFCFCF%} %)%)')
			if table.concat(simons, ', '):find(simon) then
				if simon  == myNick then
					print('{7B68EE}[Neddie] {CFCFCF}SimonSays [{F51111} ERROR {CFCFCF}]')
				else
					lua_thread.create(function()
						wait(500)
						sampProcessChatInput(command)
					end)
				end
			end
		elseif text:find('%(%( (.+)%[%d+%]: %{B7AFAF%}.+, .+%{CFCFCF%} %)%)') then -- обращение
			print(text)
			local simon, who, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}(.+), (.+)%{CFCFCF%} %)%)')
			if table.concat(simons, ', '):find(simon) then
				if simon  == myNick then
					print('{7B68EE}[Neddie] {CFCFCF}SimonSays [{F51111} ERROR1 {CFCFCF}]')
				else
					if tonumber(who) and tonumber(who) == myid then
						lua_thread.create(function()
							wait(500)
							sampProcessChatInput(command)
						end)
					else
						print('{7B68EE}[Neddie] {CFCFCF}SimonSays [{F51111} Разные myid и обращение к кому-то {CFCFCF}] Обращение: '..who..' Мой ид: '..myid)
					end
				end
			else 
				print('error')
			end
		elseif text:find('%(%( .+%[%d+%]: %{B7AFAF%}!!.+ сюда%{CFCFCF%} %)%)') then -- ходьба сюда
			local simon, id, who = string.match(text, '%(%( (.+)%[(.+)%]: %{B7AFAF%}!!(.+) сюда%{CFCFCF%} %)%)')
			print('simon: '..simon..' id: '..id..' who: '..who)
			if table.concat(simons, ', '):find(simon) then
				if simon  == myNick then
					print(' ')
				else
					if tonumber(who) and tonumber(who) == myid then
						local px,py,pz = playerpos(id)
						go_to_point(px,py)
					else
						print('{7B68EE}[Neddie] {CFCFCF}SimonSays [{F51111} ERROR {CFCFCF}]')
					end
				end
			end
		end
	end
end

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
sampAddChatMessage("{7B68EE}[Neddie] {CFCFCF}SimonSays | Поступило предложение ввода команды, выберите исход", 0x99FF99)
local len = renderGetFontDrawTextLength(font, "Исход: {8ABCFA}Выбор ответа")
while true do wait(0) 
	if time < os.clock() and answ = 0 then
		while true do
			wait(0)
			renderFontDrawText(font, "Исход: {8ABCFA}Выбор ответа\n{CFCFCF}[{67E56F}1{CFCFCF}] - Ввести.\n{CFCFCF}[{67E56F}2{CFCFCF}] - Не вводить.", sx-len-10, sy-150, 0xFFFFFFFF)					
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

return {
    check = function(json_url, prefix, url)
        local dlstatus = require('moonloader').download_status
        local json = os.tmpname()
        local started = os.clock()
        if doesFileExist(json) then
            os.remove(json)
        end
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
                                    sampAddChatMessage((prefix .. 'Обнаружено обновление. Пытаюсь обновиться c ' .. thisScript().version .. ' на ' .. updateversion), color)
                                    wait(250)
                                    downloadUrlToFile(updatelink, thisScript().path,
                                        function(id3, status1, p13, p23)
                                            if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                                                print(string.format('Загружено %d из %d.', p13, p23))
                                            elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                                print('Загрузка обновления завершена.')
                                                sampAddChatMessage((prefix .. 'Обновление завершено!'), color)
                                                goupdatestatus = true
                                                lua_thread.create(function()
                                                    wait(500)
                                                    thisScript():reload()
                                                end)
                                            end
                                            if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                                                if goupdatestatus == nil then
                                                    sampAddChatMessage((prefix .. 'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                                                    update = false
                                                end
                                            end
                                        end
                                    )
                                end, prefix
                                )
                            else
                                update = false
                                print('v' .. thisScript().version .. ': Обновление не требуется.')
                                if info.telemetry then
                                    local ffi = require "ffi"
                                    ffi.cdef "int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"
                                    local serial = ffi.new("unsigned long[1]", 0)
                                    ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
                                    serial = serial[0]
                                    local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                                    local nickname = sampGetPlayerNickname(myid)
                                    local telemetry_url = info.telemetry ..
                                        "?id=" ..
                                        serial ..
                                        "&n=" ..
                                        nickname ..
                                        "&i=" ..
                                        sampGetCurrentServerAddress() ..
                                        "&v=" .. getMoonloaderVersion() .. "&sv=" .. thisScript().version .. "&uptime=" .. tostring(os.clock())
                                    lua_thread.create(function(url)
                                        wait(250)
                                        downloadUrlToFile(url)
                                    end, telemetry_url)
                                end
                            end
                        end
                    else
                        print('v' .. thisScript().version .. ': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на ' .. url)
                        update = false
                    end
                end
            end
        )
        while update ~= false and os.clock() - started < 10 do
            wait(100)
        end
        if os.clock() - started >= 10 then
            print('v' .. thisScript().version .. ': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на ' .. url)
        end
    end
}