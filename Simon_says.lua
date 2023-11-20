script_name("SimonSays")
script_version("1.3.0")
local bLib = {}
bLib['ffi'], 		ffi 		= pcall(require, 'ffi')
bLib['Events'],		event 		= pcall(require, 'samp.events')
bLib['key'],		key 		= pcall(require, 'vkeys')
bLib['effil'],		effil 		= pcall(require, 'effil')
for lib, bool in pairs(bLib) do 
	if not bool then
		error('\n\nLibrary ' .. lib .. ' not found. Script does not launch\n')
		break
	end 
end

-- < Warning | Vanilla > Nick_Name[id]: Возможно Reason
local statee = true
simons = {'Haruki_DeKaluga', 'Gregary_House', 'Talkie_Walkie ', 'Wackie_Talckie', 'Teodore_Bagwell'}
adminslist = {'Danil_Stealers','George_Shreyder'}
warningList = {}
local my_font = renderCreateFont('Verdana', 11)
local work = true
local TAG = '{7B68EE}[WOUBLE] {CFCFCF}SimonSays | {9B9B9B}'
local sx, sy = getScreenResolution()
local spx,spy = math.random(-1,1),math.random(-1,1)
local razrab, textraz, repnick, reptext,repid,reptextid,admnick, admid,admre,admdol,admafk = 'nill'
local lastDialogWasActive = 0
local MeAdm = false
local LastActiveTime = nil
local admcheck = true

function main()
    while not isSampAvailable() do wait(110) end
    if not isSampfuncsLoaded() and not isCleoLoaded() then return end
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	myNick = sampGetPlayerNickname(myid)
	local x, y, z = getCharCoordinates(playerPed)
	
	if table.concat(adminslist, ', '):find(myNick) then
		MeAdm = true
	end

	autoupdate("https://raw.githubusercontent.com/Plavluha/SimonSays/main/simsays.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Plavluha/SimonSays/main/Simon_says.lua")

	sampRegisterChatCommand('shelp',function()
		sampShowDialog(984725,'Информация о SimonSays:','Команды скрипта:\n1. shelp - Открытие пояснялочки\n2. simon - Вкл/Выкл поиска команд саймона\n3. slist - Список действующих саймонов.','Ясно','Закрыть',0)
	end)

	

	lua_thread.create(flooder)

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
			sampAddChatMessage(TAG..'{33EA0D} Activated',-1)
		else
			sampAddChatMessage(TAG..'{F51111} Deactivated',-1)
		end
	end)
	
	sampRegisterChatCommand('stest', stest)
	
	while true do wait(0)
		if sampIsDialogActive() then
			lastDialogWasActive = os.clock()
		end
	end
 end


function event.onServerMessage(color,text)
	if work then
		if text:find('%(%( .+%[%d+%]: %{B7AFAF%}#.+ %)%)') then -- комманда
			print(text)
			local simon, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}#(.+)%{FFFFFF%} %)%)')
			if table.concat(simons, ', '):find(simon) then
				if simon  ~= myNick then
					if command == '/q' or command == '/rec' then
						lua_thread.create(function()--testcommand
							sampAddChatMessage(TAG.."Ввести комманду? | {808080}"..command, -1)
							local len = renderGetFontDrawTextLength(my_font, "Исход: {8ABCFA}Выбор ответа")
							while true do wait(0) 
								renderFontDrawText(my_font, "Исход: {8ABCFA}Выбор ответа\n{FFFFFF}[{67E56F}1{FFFFFF}] - Ввести.\n{FFFFFF}[{67E56F}2{FFFFFF}] - Не вводить.", sx-len-10, sy-150, 0xFFFFFFFF)					
								if isKeyJustPressed(VK_1) and not sampIsChatInputActive() and not sampIsDialogActive() then
									sampProcessChatInput(command)
									break
								end
								if isKeyJustPressed(VK_2) and not sampIsChatInputActive() and not sampIsDialogActive() then break end
							end
						end)
					elseif command == 'бб' then
						sampProcessChatInput('/q')
					else
						sampProcessChatInput(command)
					end
				end
			end
		elseif text:find('%(%( (.+)%[%d+%]: %{B7AFAF%}.+, .+%{FFFFFF%} %)%)') then -- обращение
			print(text)
			local simon, who, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}(.+), (.+)%{FFFFFF%} %)%)')
			if table.concat(simons, ', '):find(simon) then
				if simon  ~= myNick then
					if tonumber(who) and tonumber(who) == myid then
						if command == '/q' or command == '/rec' then
							lua_thread.create(function()--testcommand
								sampAddChatMessage(TAG.."Ввести комманду? | {808080}"..command, -1)
								local len = renderGetFontDrawTextLength(my_font, "Исход: {8ABCFA}Выбор ответа")
								while true do wait(0) 
									renderFontDrawText(my_font, "Исход: {8ABCFA}Выбор ответа\n{FFFFFF}[{67E56F}1{FFFFFF}] - Ввести.\n{FFFFFF}[{67E56F}2{FFFFFF}] - Не вводить.", sx-len-10, sy-150, 0xFFFFFFFF)					
									if isKeyJustPressed(VK_1) and not sampIsChatInputActive() and not sampIsDialogActive() then
										sampProcessChatInput(command)
										break
									end
									if isKeyJustPressed(VK_2) and not sampIsChatInputActive() and not sampIsDialogActive() then break end
								end
							end)
						elseif command == 'бб' then
							sampProcessChatInput('/q')
						else
							sampProcessChatInput(command)
						end
					else
						print('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} Разные myid и обращение к кому-то {ffffff}] Обращение: '..who..' Мой ид: '..myid)
					end
				end
			else 
				print('error')
			end
--[[		elseif text:find('%(%( .+%[%d+%]: %{B7AFAF%}!!.+ сюда%{FFFFFF%} %)%)') then -- ходьба сюда
				local simon, id, who = string.match(text, '%(%( (.+)%[(.+)%]: %{B7AFAF%}!!(.+) сюда%{FFFFFF%} %)%)')
				print('simon: '..simon..' id: '..id..' who: '..who)
				if table.concat(simons, ', '):find(simon) then
					if simon  ~= myNick then
						if tonumber(who) and tonumber(who) == myid then
							local px,py,pz = playerpos(id)
							go_to_point(px,py)
						else
							print('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} ERROR {ffffff}]')
						end
					end
				end	
--]]	end
	end
	if text:find('Разработчик.+%:.+') then
		razrab, textraz = string.match(text, 'Разработчик (.+)%: (.+)')
		lua_thread.create(function()
			for i=1, 5 do
				SendRoot()
				wait(1500)
			end
		end)
	end--[Репорт] от Dima_Maniak[271]:{FFFFFF} помогтие я застрял. Уже {E5261A}6{FFFFFF} репортов!!!
	-- %[Репорт%] от .+%[.+%]:%{FFFFFF%} .+%. Уже %{E5261A%}.+%{FFFFFF%} репорт.+!
	if text:find('%[Репорт%] от .+%[.+%]:%{FFFFFF%} .+%. Уже %{E5261A%}.+%{FFFFFF%} репорт.+!') then
		repnick, repid, reptext = string.match(text, '%[Репорт%] от (.+)%[(.+)%]:%{FFFFFF%} (.+)%. Уже %{E5261A%}.+%{FFFFFF%} репорт.+!')
		for int in string.gmatch(reptext, "%d+") do
			if sampIsPlayerConnected(int) then
				for i=1,#simons do
					if tostring(sampGetPlayerNickname(tonumber(int))) == tostring(simons[i]) then
						SendReport()
					else
						err=1
					end
				end
			else
				err=1
			end
		end
	end
	if text:find('Администрация в сети %(.+ чел%. | .+ в AFK%):') then
		if checkadm == true then
			lua_thread.create(function()
				wait(1000)
				checkadm = false
			end)
			return false
		end
	elseif text:find('.+%) .+%[.+%] %- /re %[.+%] %- .+ %- AFK: .+ %- Rep: .+') then
	local admnick, admid,admre,admdol,admafk = string.match(text,'.+%) (.+)%[(.+)%] %- /re %[(.+)%] %- (.+) %- AFK: (.+) %- Rep: .+')
	admrenick = sampGetPlayerNickname(tonumber(admre))
		if checkadm == true then
			for i=1,#simons do
					if tostring(sampGetPlayerNickname(tonumber(admre))) == tostring(simons[i]) then
						SendRecon()
					else
						err=1
					end
				end
			return false
		end
	elseif text:find('.+%) .+%[.+%] %- .+ %- AFK: .+ %- Rep: .+') then
		sampAddChatMessage(text,-1)
		if checkadm == true then
			return false
		end
	end
end

function stest()
	lua_thread.create(function()--testcommand
	sampAddChatMessage(TAG.."Поступило предложение ввода команды, выберите исход", -1)
	local len = renderGetFontDrawTextLength(my_font, "Исход: {8ABCFA}Выбор ответа")
	while true do wait(0) 
		renderFontDrawText(my_font, "Исход: {8ABCFA}Выбор ответа\n{FFFFFF}[{67E56F}1{FFFFFF}] - Ввести.\n{FFFFFF}[{67E56F}2{FFFFFF}] - Не вводить.", sx-len-10, sy-150, 0xFFFFFFFF)					
		if isKeyJustPressed(VK_1) and not sampIsChatInputActive() and not sampIsDialogActive() then
			lua_thread.create(function()
				wait(500)
				sampProcessChatInput(command)
			end)
			break
		end
		if isKeyJustPressed(VK_2) and not sampIsChatInputActive() and not sampIsDialogActive() then break end
	end
	end)
end
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

function playerpos(params)
    local id = string.match(params, "(%d+)")
    local result, handle = sampGetCharHandleBySampPlayerId(id)
    local px, py, pz = getCharCoordinates(handle)
	return px, py, pz
end

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
                sampAddChatMessage((TAG..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      sampAddChatMessage((TAG..'Обновление завершено! Новая версия: '..updateversion), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((TAG..'Обновление прошло неудачно. Запускаю устаревшую версию...'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              sampAddChatMessage(TAG..'У вас стоит v'..thisScript().version..'. Обновление не требуется.',-1)
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
function SendWebhook(URL, DATA, callback_ok, callback_error) -- Функция отправки запроса
    local function asyncHttpRequest(method, url, args, resolve, reject)
        local request_thread = effil.thread(function (method, url, args)
           local requests = require 'requests'
           local result, response = pcall(requests.request, method, url, args)
           if result then
              response.json, response.xml = nil, nil
              return true, response
           else
              return false, response
           end
        end)(method, url, args)
        if not resolve then resolve = function() end end
        if not reject then reject = function() end end
        lua_thread.create(function()
            local runner = request_thread
            while true do
                local status, err = runner:status()
                if not err then
                    if status == 'completed' then
                        local result, response = runner:get()
                        if result then
                           resolve(response)
                        else
                           reject(response)
                        end
                        return
                    elseif status == 'canceled' then
                        return reject(status)
                    end
                else
                    return reject(err)
                end
                wait(0)
            end
        end)
    end
    asyncHttpRequest('POST', URL, {headers = {['content-type'] = 'application/json'}, data = u8(DATA)}, callback_ok, callback_error)
end


function flooder()
	if MeAdm then
		while true do 
			wait(0)
			if sampIsLocalPlayerSpawned() then
				while (os.clock() - lastDialogWasActive) < 2.00 do wait(0) end
				if admcheck == true then
					sampSendChat('/admins')
					checkadm=true
				end
				wait(3000)
			end
		end
	end
end

function SendReport(arg)
	SendWebhook('https://discord.com/api/webhooks/1170220701169491998/fUeipWf4ZYigehfRcoyA-1VDPs08dzXT1TJpUtmw10r43kehSL-CntiGlioe864G6Zkt', ([[{
  "content": "<@&1170235730740650135>",
  "embeds": [
    {
      "title": "%s[%s]",
      "description": "**%s**",
      "color": 9117728,
      "footer": {
        "text": "%s"
      }
    }
  ],
  "attachments": []
}]]):format(repnick,repid,reptext,os.date("%d.%m.%Y %H:%M:%S")))
end

function SendRecon(arg)
	SendWebhook('https://discord.com/api/webhooks/1170220701169491998/fUeipWf4ZYigehfRcoyA-1VDPs08dzXT1TJpUtmw10r43kehSL-CntiGlioe864G6Zkt', ([[{
  "content": "<@&1170235730740650135>",
  "embeds": [
    {
      "title": "RECON",
      "description": "**%s | `%s[%s]`\nСледит за `%s[%s]`.\nAFK: `%s`**",
      "color": 16711680,
      "footer": {
        "text": "%s"
      }
    }
  ],
  "attachments": []
}]]):format(admdol,admnick,admid,admrenick,admre,admafk,os.date("%d.%m.%Y %H:%M:%S")))
end

function SendRoot(arg)
	SendWebhook('https://discord.com/api/webhooks/1169218537605312563/o-3U04LEIWsauXaFowcGpFt7L2_NxXx0km49KT5c1P9eNm3fHqoYhgCqutoozGoMaE5Q', ([[{
  "content": "<@&1169217940348993626>",
  "embeds": [
    {
      "title": "%s",
      "description": "%s",
      "color": 2840243,
      "footer": {
        "text": "%s"
      }
    }
  ],
  "attachments": []
}]]):format(razrab, textraz,os.date("%d.%m.%Y %H:%M:%S")))
end
