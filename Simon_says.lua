script_name("SimonSays")
script_version("1.4.2")

local bLib = {}
bLib['encoding'],   encoding    = pcall(require, 'encoding')
bLib['Events'],		event 		= pcall(require, 'samp.events')
bLib['effil'],		effil 		= pcall(require, 'effil')
bLib['inicfg'],		inicfg 		= pcall(require, 'inicfg')
bLib['mimgui'],		imgui 		= pcall(require, 'mimgui')


for lib, bool in pairs(bLib) do 
	if not bool then
		error('\n\nLibrary ' .. lib .. ' not found . Script does not launch\n')
		break
	end 
end

simons = {'Neddie_Barlow','Ursulla_Toretto','Hiroshi_Sakai','Balance_Shilling', 'Asuka_Barlow'}
local TAG = '{7B68EE}[WOUBLE] {CFCFCF}SimonSays | {9B9B9B}'
local DTAG = '{7B68EE}Simon_DEBUG | {9B9B9B}'
local ohr,zek,reasonzek,punReas,punZvzekId,zekZv,zekDeys,zekReason='nill'
local u8 = encoding.UTF8
encoding.default = 'CP1251'
local directIni = '#Simon-Says'
local debuger = false
local work = true
local tab = 1
local MessagesList = {}

local new = imgui.new
local WinState = new.bool()

function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(80) end
	while not sampIsLocalPlayerSpawned() do wait(0) end
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	myNick = sampGetPlayerNickname(myid)
	
	autoupdate("https://raw.githubusercontent.com/Plavluha/SimonSays/main/simsays.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Plavluha/SimonSays/main/Simon_says.lua")

    sampRegisterChatCommand('cmd', function() WinState[0] = not WinState[0] end)

	sampRegisterChatCommand('shelp',function()
		sampShowDialog(984725,'Информация о SimonSays:','Команды скрипта:\n1. shelp - Открытие пояснялочки\n2. simon - Вкл/Выкл поиска команд саймона\n3. slist - Список действующих саймонов.','Ясно','Закрыть',0)
	end)
	
	sampRegisterChatCommand('ssend',function(arg)
		if arg ~= '' or arg ~= ' ' or arg ~= nill then
			SendSend(arg)
		end
	end)
	
	sampRegisterChatCommand('padd',function(arg)
		if arg:match('(.+) (.+)') then
			local arg = {arg:match('(.-) (.+)')}
			pstatus = 1
			CheckValid(arg[1],arg[2])
		else
			sampAddChatMessage(TAG..'Используйте /padd id/Nick пометка',-1)
		end
	end)
	
	sampRegisterChatCommand('pdell',function(arg)
		if arg:match('(.+) (.+)') then
			local arg = {arg:match('(.-) (.+)')}
			pstatus = 2
			CheckValid(arg[1],arg[2])
		else
			sampAddChatMessage(TAG..'Используйте /pdell id/Nick пометка',-1)
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
		print(text)
		print('-    ---    ---   ---   ---   ---   ---   -')
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
	elseif did == 15346 then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	elseif did == 25477 then
		sampSendDialogResponse(did, 1, 0, nil)
		return false
	elseif did == 15347 then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	end	
end

function event.onServerMessage(color,text)
	if text:find('Ваше сообщение зарегистрировано в системе и будет опубликовано после редакции.') then -- комманда
		lua_thread.create(function()
			sampAddChatMessage(TAG..'Вы отправили объявление, кд пошло.',-1)
			wait(29900)
			sampAddChatMessage(TAG..'КД прошло, можете снова отправить объявление',-1)
			if sampIsCursorActive() then
				sampAddChatMessage(TAG..'Отправить не получилось, требуется ручная отправка объявления.',-1)
			else
				sampAddChatMessage(TAG..'Отправили объявление о работе СМИ =3',-1)
				sampSendChat('/ad Радиоцентр г.Лос-Сантос ждет ваших объявлений! Самая быстрая редакция!$')
			end
		end)
		return false
	end
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

imgui.OnFrame(function() return WinState[0] end, function(player)
    imgui.SetNextWindowPos(imgui.ImVec2(500, 500), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(600, 400), imgui.Cond.Always)
    imgui.Begin('##Window', WinState, imgui.WindowFlags.NoResize)
    imgui.SetWindowFontScale(1)

    imgui.BeginChild('LeftPane', imgui.ImVec2(130, 0), false, imgui.WindowFlags.NoScrollbar)
    imgui.Text("")
    imgui.SameLine(0, 10)
    
    imgui.SetCursorPosX(4)
    imgui.SetCursorPosY(5)
    if imgui.Button(u8'Main', imgui.ImVec2(120, 60)) then tab = 1 end
    imgui.SetCursorPosX(4)
    
    if imgui.Button(u8'SimonSays', imgui.ImVec2(120, 60)) then tab = 2 end
    imgui.SetCursorPosX(4)
    if imgui.Button(u8'Other', imgui.ImVec2(120, 60)) then tab = 3 end
    imgui.SetCursorPosX(4)
    if imgui.Button(u8'Soon', imgui.ImVec2(120, 60)) then tab = 4 end
    imgui.EndChild()
    
    -- Правая часть с содержимым разделов
    imgui.SameLine()
    imgui.BeginChild('RightPane', imgui.ImVec2(450, 0), true)
    
    if tab == 1 then
		imgui.Text('Tab1')
    elseif tab == 2 then
        imgui.Text('Tab2')
    elseif tab == 3 then
        imgui.Text('tab3')
    elseif tab == 4 then
		imgui.Text('Tab4')
    end
	
    imgui.EndChild()
    imgui.End()
end)

function CheckValid(a,b)
	if tonumber(a) then
		a = tonumber(a)
		if a > -1 and a < 1000 then
			if sampIsPlayerConnected(a) then
				aa = sampGetPlayerNickname(a)
			else
			aa = ' '
				sampAddChatMessage(TAG..'Неверный ID',-1)
			end
		else
			aa = ' '
			sampAddChatMessage(TAG..'Неверный ID',-1)
		end
	elseif tostring(a) then
		if a:match('%w+_%w+') then
			aa = a
		else
			aa = ' '
			sampAddChatMessage(TAG..'Неверно указан Nick_Name. Возможно вы проспустили "_"',-1)
		end
	else
			aa = ' '
		sampAddChatMessage(TAG..'Используйте /command id/Nick reason',-1)
	end
	
	if aa ~= ' ' then
		if pstatus == 1 then
			sampAddChatMessage(aa..' добавлен',-1)
		
		elseif pstatus == 2 then
			sampAddChatMessage(aa..' удален.',-1)
		end
		SendPList(aa,b)
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

function SendPList(a,b)

	if pstatus == 1 then
		ptext = [[{
  "content": null,
  "embeds": [
    {
      "title": "Заявка на добавление в PL",
      "description": "**Ник: %s\nПометка: %s**",
      "color": 4303917
    }
  ],
  "attachments": []
	}]]
	elseif pstatus == 2 then
		ptext = [[{
  "content": null,
  "embeds": [
    {
      "title": "Заявка на удаление из PL",
      "description": "**Ник: %s\nПометка: %s**",
      "color": 16620833
    }
  ],
  "attachments": []
}]]
	else
		ptext = [[{
			"content": null,
			"embeds": [
				{
					"title": "ERROR =(\n%s\n%s",
					"color": 16711680
				}
			],
			"attachments": []
		}]]
	end


	SendWebhook('https://discord.com/api/webhooks/1253267821983567943/t4WEWs7V3_XmuW2FbKBkMBO-PgNEgGpwSHUS5LrSnUyBp7WgkKx3pbLtA3zSVBjty2Ej', ptext:format(a,b))
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

function AddNotify(type, title, text,time)
	local str = ('window.executeEvent(\'event.notify.initialize\', \'["%s", "%s", "%s", "%s"]\');'):format(type, title, text, NotifyTime)
	MessagesList[#MessagesList+1] = {active = false, time = 0, showtime = time, str=str}
	sampAddChatMessage(DTAG..'new notify',-1)
end

function imgui.AnimatedButton(label, size, speed, rounded) -- circles -> rect
    local size = size or imgui.ImVec2(0, 0)
    local bool = false
    local text = label:gsub('##.+$', '')
    local ts = imgui.CalcTextSize(text)
    speed = speed and speed or 0.4
    if not AnimatedButtons then AnimatedButtons = {} end
    if not AnimatedButtons[label] then
        local color = imgui.GetStyle().Colors[imgui.Col.ButtonHovered]
        AnimatedButtons[label] = {circles = {}, hovered = false, state = false, time = os.clock(), color = imgui.ImVec4(color.x, color.y, color.z, 0.2)}
    end
    local button = AnimatedButtons[label]
    local dl = imgui.GetWindowDrawList()
    local p = imgui.GetCursorScreenPos()
    local c = imgui.GetCursorPos()
    local CalcItemSize = function(size, width, height)
        local region = imgui.GetContentRegionMax()
        if (size.x == 0) then
            size.x = width
        elseif (size.x < 0) then
            size.x = math.max(4.0, region.x - c.x + size.x);
        end
        if (size.y == 0) then
            size.y = height;
        elseif (size.y < 0) then
            size.y = math.max(4.0, region.y - c.y + size.y);
        end
        return size
    end
    size = CalcItemSize(size, ts.x+imgui.GetStyle().FramePadding.x*2, ts.y+imgui.GetStyle().FramePadding.y*2)
    local ImSaturate = function(f) return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f) end
    if #button.circles > 0 then
        local PathInvertedRect = function(a, b, col)
            local rounding = rounded and imgui.GetStyle().FrameRounding or 0
            if rounding <= 0 or not rounded then return end
            local dl = imgui.GetWindowDrawList()
            dl:PathLineTo(a)
            dl:PathArcTo(imgui.ImVec2(a.x + rounding, a.y + rounding), rounding, -3.0, -1.5)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(b.x, a.y))
            dl:PathArcTo(imgui.ImVec2(b.x - rounding, a.y + rounding), rounding, -1.5, -0.205)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(b.x, b.y))
            dl:PathArcTo(imgui.ImVec2(b.x - rounding, b.y - rounding), rounding, 1.5, 0.205)
            dl:PathFillConvex(col)

            dl:PathLineTo(imgui.ImVec2(a.x, b.y))
            dl:PathArcTo(imgui.ImVec2(a.x + rounding, b.y - rounding), rounding, 3.0, 1.5)
            dl:PathFillConvex(col)
        end
        for i, circle in ipairs(button.circles) do
            local time = os.clock() - circle.time
            local t = ImSaturate(time / speed)
            local color = imgui.GetStyle().Colors[imgui.Col.ButtonActive]
            local color = imgui.GetColorU32Vec4(imgui.ImVec4(color.x, color.y, color.z, (circle.reverse and (255-255*t) or (255*t))/255))
            local radius = math.max(size.x, size.y) * (circle.reverse and 1.5 or t)
            imgui.PushClipRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), true)
            dl:AddRectFilled(p, imgui.ImVec2(p.x+size.x, p.y+size.y), color)
            PathInvertedRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), imgui.GetColorU32Vec4(imgui.GetStyle().Colors[imgui.Col.WindowBg]))
            imgui.PopClipRect()
            if t == 1 then
                if not circle.reverse then
                    circle.reverse = true
                    circle.time = os.clock()
                else
                    table.remove(button.circles, i)
                end
            end
        end
    end
    local t = ImSaturate((os.clock()-button.time) / speed)
    button.color.w = button.color.w + (button.hovered and 0.8 or -0.8)*t
    button.color.w = button.color.w < 0.2 and 0.2 or (button.color.w > 1 and 1 or button.color.w)
    color = imgui.GetStyle().Colors[imgui.Col.Button]
    color = imgui.GetColorU32Vec4(imgui.ImVec4(color.x, color.y, color.z, 0.2))
    dl:AddRectFilled(p, imgui.ImVec2(p.x+size.x, p.y+size.y), color, rounded and imgui.GetStyle().FrameRounding or 0)
    dl:AddRect(p, imgui.ImVec2(p.x+size.x, p.y+size.y), imgui.GetColorU32Vec4(button.color), rounded and imgui.GetStyle().FrameRounding or 0)
    local align = imgui.GetStyle().ButtonTextAlign
    imgui.SetCursorPos(imgui.ImVec2(c.x+(size.x-ts.x)*align.x, c.y+(size.y-ts.y)*align.y))
    imgui.Text(text)
    imgui.SetCursorPos(c)
    if imgui.InvisibleButton(label, size) then
        bool = true
        table.insert(button.circles, {animate = true, reverse = false, time = os.clock(), clickpos = imgui.ImVec2(getCursorPos())})
    end
    button.hovered = imgui.IsItemHovered()
    if button.hovered ~= button.state then
        button.state = button.hovered
        button.time = os.clock()
    end
    return bool
end

function theme()
    imgui.SwitchContext()
    --==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(4, 4)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10
    
    --==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().ChildBorderSize = 1
    imgui.GetStyle().PopupBorderSize = 1
    imgui.GetStyle().FrameBorderSize = 1
    imgui.GetStyle().TabBorderSize = 1
    
    --==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5
    
    --==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    
    --==[ COLORS ]==--
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.00, 0.00, 0.00, 0.70)
end

imgui.OnInitialize(function()
    theme()
end)

function imgui.TextQuestion(text)
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.PushTextWrapPos(450)
        imgui.TextUnformatted(text)
        imgui.PopTextWrapPos()
        imgui.EndTooltip()
    end
end