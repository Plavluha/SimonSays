script_name("SimonSays")
script_version("1.4.0")

local bLib = {}
bLib['encoding'],   encoding    = pcall(require, 'encoding')
bLib['ffi'], 		ffi 		= pcall(require, 'ffi')
bLib['Events'],		event 		= pcall(require, 'samp.events')
bLib['key'],		key 		= pcall(require, 'vkeys')
bLib['effil'],		effil 		= pcall(require, 'effil')
bLib['inicfg'],		inicfg 		= pcall(require, 'inicfg')

for lib, bool in pairs(bLib) do 
	if not bool then
		error('\n\nLibrary ' .. lib .. ' not found. Script does not launch\n')
		break
	end 
end

simons = {'Wilmer_Courtland','Ursulla_Toretto','Hiroshi_Sakai'}
warningList = {}
local TAG = '{7B68EE}[WOUBLE] {CFCFCF}SimonSays | {9B9B9B}'
local DTAG = '{7B68EE}Simon_DEBUG | {9B9B9B}'
local sx, sy = getScreenResolution()
local spx,spy = math.random(-1,1),math.random(-1,1)
local razrab, textraz, repnick, reptext,repid,reptextid,admnick, admid,admre,admdol,admafk,ohr,zek,reasonzek,punReas,punZvzekId,zekZv,zekDeys,zekReason='nill'
local u8 					 = encoding.UTF8
encoding.default 			 = 'CP1251'
local directIni = '#Simon-Says'
local debuger = false

local ini = inicfg.load(inicfg.load({
	work = true
}, directIni))
work = ini.work

function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(80) end
	while not sampIsLocalPlayerSpawned() do wait(0) end
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	myNick = sampGetPlayerNickname(myid)
	local x, y, z = getCharCoordinates(playerPed)

	autoupdate("https://raw.githubusercontent.com/Plavluha/SimonSays/main/simsays.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Plavluha/SimonSays/main/Simon_says.lua")
	local anotherIni = inicfg.load(nil, "example_another_config")
	if anotherIni ~= nil then
		local newData = {
			work = true
		}
		inicfg.save(newData, anotherIni)
	end

	sampRegisterChatCommand('shelp',function()
		sampShowDialog(984725,'Информация о SimonSays:','Команды скрипта:\n1. shelp - Открытие пояснялочки\n2. simon - Вкл/Выкл поиска команд саймона\n3. slist - Список действующих саймонов.','Ясно','Закрыть',0)
	end)
	
	sampRegisterChatCommand('ssend',function(arg)
		if arg ~= '' or arg ~= ' ' or arg ~= nill then
			SendSend(arg)
		end
	end)

	sampRegisterChatCommand('slog', function()
		debuger = not debuger
		-- lua_thread.create(flooder)
		if debuger then
			sampAddChatMessage(TAG..' режим разработчика {33EA0D}Activated',-1)
		else
			sampAddChatMessage(TAG..' режим разработчика {F51111}Deactivated',-1)
		end
	end)
	
	sampRegisterChatCommand('supdate',function()
		autoupdate("https://raw.githubusercontent.com/Plavluha/SimonSays/main/simsays.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Plavluha/SimonSays/main/Simon_says.lua")
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
		ini.work = work
		inicfg.save(ini, directIni)
		if work then
			sampAddChatMessage(TAG..'{33EA0D} Activated',-1)
		else
			sampAddChatMessage(TAG..'{F51111} Deactivated',-1)
		end
	end)
	
 end

function event.onShowDialog(did, style, title, b1, b2, text)
	if debuger then
		sampAddChatMessage(DTAG..'DIALOG INFO | ID = [{FFFFFF}'..did..'{9B9B9B}] TITLE = [{FFFFFF}'..title..'{9B9B9B}]',-1)
	end
	if did == 15253 then
		sampSendDialogResponse(did, 1, 1, nil)
		return false
	elseif did == 15254 then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	elseif did == 25893 then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	end	
end

function event.onServerMessage(color,text)
	if work then
		if text:find('%(%( .+%[%d+%]: %{B7AFAF%}#.+ %)%)') then -- комманда
			print(text)
			local simon, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}#(.+)%{FFFFFF%} %)%)')
			if table.concat(simons, ', '):find(simon) then
				if simon  ~= myNick then
					lua_thread.create(function()
						wait(200)
						sampProcessChatInput(command)
					end)
				end
			end
		elseif text:find('%(%( (.+)%[%d+%]: %{B7AFAF%}.+, .+%{FFFFFF%} %)%)') then -- обращение
			print(text)
			local simon, who, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}(.+), (.+)%{FFFFFF%} %)%)')
			if table.concat(simons, ', '):find(simon) then
				_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
				if simon  ~= myNick then
					if tonumber(who) and tonumber(who) == myid then
						lua_thread.create(function()
							wait(200)
							sampProcessChatInput(command)
						end)
					else
						print('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} Разные myid и обращение к кому-то {ffffff}] Обращение: '..who..' Мой ид: '..myid)
					end
				end
			else 
				print('error')
			end
		end
	end
	if text:find('%[Тюрьма%] %{FFFFFF%}.+%[.+%] повысил срок .+%[.+%]. Причина: .+') then
		ohr,zek, reasonzek = string.match(text,'%[Тюрьма%] %{FFFFFF%}(.+)%[.+%] повысил срок (.+)%[.+%]. Причина: (.+)')
		if debuger then
			sampAddChatMessage(DTAG..'ohr = ['..ohr..'] zek = ['..zek..'] reasonzek = ['..reasonzek..']',-1)
		end
		if myNick == ohr then
		if debuger then
			sampAddChatMessage(DTAG..'myNick == ohr',-1)
			sampAddChatMessage(DTAG..'SendPov()',-1)
		end
			SendPov()
		end
	elseif text:find('%[Тюрьма%] %{FFFFFF%}.+%[.+%] понизил срок .+%[.+%]. Причина: .+') then
		ohr,zek, reasonzek = string.match(text,'%[Тюрьма%] %{FFFFFF%}(.+)%[.+%] понизил срок (.+)%[.+%]. Причина: (.+)')
		if debuger then
			sampAddChatMessage(DTAG..'ohr = ['..ohr..'] zek = ['..zek..'] reasonzek = ['..reasonzek..']',-1)
		end
		if myNick == ohr then
		if debuger then
			sampAddChatMessage(DTAG..'myNick == ohr',-1)
			sampAddChatMessage(DTAG..'sendPon()',-1)
		end
			SendPon()
		end
	end
	if text:find('Внимание%! %{FFFFFF%}(.)%[.+%]%{FF6347%} был%(а%) объявлен%(a%) в розыск%! Причина%: %{FFFFFF%}.+%{FF6347%} %| Уровень розыска%: %{FFFFFF%}7%.') then
		SevenNick,SevenId = string.match(text,'Внимание%! %{FFFFFF%}(.)%[(.+)%]%{FF6347%} был%(а%) объявлен%(a%) в розыск%! Причина%: %{FFFFFF%}.+%{FF6347%} %| Уровень розыска%: %{FFFFFF%}7%.')
		if SevenNick ~= '' or SevenNick ~= ' ' or SevenNick ~= nill then
			SendSeven(SevenId, SevenNick)
		end
	elseif
		text:find('Внимание%! В игру зашел особо опасный преступник (.+)%[.+%]%! %(7 уровень розыска%)') then
		SevenNick,SevenId = string.match(text,'Внимание%! В игру зашел особо опасный преступник (.+)%[(.+)%]%! %(7 уровень розыска%)')
		if SevenNick ~= '' or SevenNick ~= ' ' or SevenNick ~= nill then
			SendSeven(SevenId, SevenNick)
		end
	end
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

function SendSeven(a,b)
	SendWebhook('https://discord.com/api/webhooks/1253040561150103596/Dp9fqRaP6Ue85aPu7FcrldV6hW0HTWUNRMcv9kU6Mv8o1LiZgSt_XvuYzkmI13Fqxxin', ([[{
  "content": "## Появился новый ООП, `7` уровня розыска: %s[%s]\n||<@&1169217940348993626>||",
  "embeds": null,
  "attachments": []
}]]):format(b,a))
end

function SendSend(arg)
	sampAddChatMessage('Сообщение отправлено | '.. arg,-1)
	SendWebhook('https://discord.com/api/webhooks/1253035194387005511/6L3vECxtI8Eop5EYR04E_YEiT8IHCIWLBAVqXluSwLF9I4Y5iJmZ5mXL5XOONDLLAeap', ([[{
		"content": null,
		"embeds": [
		{
		"description": "**%s: `%s`**",
		"color": null
		}
		],
		"attachments": []
	}]]):format(myNick, arg))
end

--https://discord.com/api/webhooks/1178645399855173652/xTHqsGXrORlgaU5wYffXOVdtq2QgVKEiBqRRZKzJ19FGsepXaamtvdSClF3g3cwDQAYL
function SendPov(arg)
	SendWebhook('https://discord.com/api/webhooks/1180516745988018287/WfzVOXi9udPhtmqKCTsAH9J3YdBbJbgScIejKlLUeScaL3jjPxlhPRv4Hvppj5BmQwl7', ([[{
  "content": null,
  "embeds": [
    {
      "title": "**%s**",
      "description": "```Ваш Nick_Name: **`%s`**\nВаша должность: Начальник инспекции\nNick_Name заключённого: **`%s`**\nНа сколько звёзд был повышен срок?: **`УКАЖИ`**\nПричина повышения срока: **`%s`**```",
      "color": 12451840
    }
  ],
  "attachments": []
}]]):format(ohr,ohr,zek,reasonzek))
end

function SendPon(arg)
	SendWebhook('https://discord.com/api/webhooks/1180516745988018287/WfzVOXi9udPhtmqKCTsAH9J3YdBbJbgScIejKlLUeScaL3jjPxlhPRv4Hvppj5BmQwl7', ([[{
  "content": null,
  "embeds": [
    {
      "title": "**%s**",
      "description": "```\nВаш Nick_Name:  **`%s`**\nВаша должность:  Начальник инспекции\nNick_Name заключённого:  **`%s`**\nНа сколько звёзд был понижен срок?:  **`УКАЖИ`**\nПричина понижения срока:  **`%s`**\n```",
      "color": 2014720
    }
  ],
  "attachments": []
}]]):format(ohr,ohr,zek,reasonzek))
end

function SendPon(arg)
	SendWebhook('https://discord.com/api/webhooks/1180516745988018287/WfzVOXi9udPhtmqKCTsAH9J3YdBbJbgScIejKlLUeScaL3jjPxlhPRv4Hvppj5BmQwl7', ([[{
  "content": null,
  "embeds": [
    {
      "title": "**%s**",
      "description": "```\nВаш Nick_Name:  **`%s`**\nВаша должность:  Начальник инспекции\nNick_Name заключённого:  **`%s`**\nНа сколько звёзд был понижен срок?:  **`УКАЖИ`**\nПричина понижения срока:  **`%s`**\n```",
      "color": 2014720
    }
  ],
  "attachments": []
}]]):format(ohr,ohr,zek,reasonzek))
end