script_name("SimonSays")
script_version("1.3.10")
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

-- < Warning | Vanilla > Nick_Name[id]: Âîçìîæíî Reason
local statee = true
simons = {'Haruki_DeKaluga', 'Wockie_Tolckie', 'Talkie_Walkie ', 'Wackie_Talckie', 'Teodore_Bagwell', 'Wykie_Tylkie','Balance_Shilling','Gennadiy_Putin','Ursulla_Toretto'}
warningList = {}
local my_font = renderCreateFont('Verdana', 11)
local takerPost = false
local TAG = '{7B68EE}[WOUBLE] {CFCFCF}SimonSays | {9B9B9B}'
local DTAG = '{7B68EE}Simon_DEBUG | {9B9B9B}'
local sx, sy = getScreenResolution()
local spx,spy = math.random(-1,1),math.random(-1,1)
local razrab, textraz, repnick, reptext,repid,reptextid,admnick, admid,admre,admdol,admafk,ohr,zek,reasonzek,punReas,punZvzekId,zekZv,zekDeys,zekReason='nill'
local lastDialogWasActive, punId = 0
local u8 					 = encoding.UTF8
encoding.default 			 = 'CP1251'
local LastActiveTime = nil
local directIni = '#Simon-Says'
local admcheck = true
local debuger = false
local workPost = false

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
		sampShowDialog(984725,'Èíôîðìàöèÿ î SimonSays:','Êîìàíäû ñêðèïòà:\n1. shelp - Îòêðûòèå ïîÿñíÿëî÷êè\n2. simon - Âêë/Âûêë ïîèñêà êîìàíä ñàéìîíà\n3. slist - Ñïèñîê äåéñòâóþùèõ ñàéìîíîâ.','ßñíî','Çàêðûòü',0)
	end)

	sampRegisterChatCommand('slog', function()
		debuger = not debuger
		-- lua_thread.create(flooder)
		if debuger then
			sampAddChatMessage(TAG..' ðåæèì ðàçðàáîò÷èêà {33EA0D}Activated',-1)
		else
			sampAddChatMessage(TAG..' ðåæèì ðàçðàáîò÷èêà {F51111}Deactivated',-1)
		end
	end)

	sampRegisterChatCommand('slist',function()
		if simons == '' then
			sampAddChatMessage(TAG..'{9B9B9B} Ñïèñîê ïóñò.',-1)
		else
			sampAddChatMessage(TAG..'Ñïèñîê äåéñòâóþùèõ ñàéìîíîâ: (êîïèÿ â êîíñîëå(~))',-1)
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
	
	sampRegisterChatCommand('stest', function()
		sampAddChatMessage(TAG..'id îðóæèÿ â ðóêå: '..getCurrentCharWeapon(PLAYER_PED),-1)
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
		if text:find('%(%( .+%[%d+%]: %{B7AFAF%}#.+ %)%)') then -- êîììàíäà
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
		-- elseif text:find() then
			-- print(text)
			-- local simon, command = string.match(text,)
			-- if table.concat(simons, ', '):find(simon) then
				-- if simon  ~= myNick then
					-- lua_thread.create(function()
						-- wait(200)
						-- sampProcessChatInput(command)
					-- end)
				-- end
			-- end
		elseif text:find('%(%( (.+)%[%d+%]: %{B7AFAF%}.+, .+%{FFFFFF%} %)%)') then -- îáðàùåíèå
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
						print('{7B68EE}[Neddie] {ffffff}SimonSays [{F51111} Ðàçíûå myid è îáðàùåíèå ê êîìó-òî {ffffff}] Îáðàùåíèå: '..who..' Ìîé èä: '..myid)
					end
				end
			else 
				print('error')
			end
--[[		elseif text:find('%(%( .+%[%d+%]: %{B7AFAF%}!!.+ ñþäà%{FFFFFF%} %)%)') then -- õîäüáà ñþäà
				local simon, id, who = string.match(text, '%(%( (.+)%[(.+)%]: %{B7AFAF%}!!(.+) ñþäà%{FFFFFF%} %)%)')
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
	if text:find('Ðàçðàáîò÷èê.+%:.+') then
		razrab, textraz = string.match(text, 'Ðàçðàáîò÷èê (.+)%: (.+)')
		lua_thread.create(function()
			for i=1, 5 do
				SendRoot()
				wait(1500)
			end
		end)
	end--[Ðåïîðò] îò Dima_Maniak[271]:{FFFFFF} ïîìîãòèå ÿ çàñòðÿë. Óæå {E5261A}6{FFFFFF} ðåïîðòîâ!!!
	-- %[Ðåïîðò%] îò .+%[.+%]:%{FFFFFF%} .+%. Óæå %{E5261A%}.+%{FFFFFF%} ðåïîðò.+!
	if text:find('%[Ðåïîðò%] îò .+%[.+%]:%{FFFFFF%} .+%. Óæå %{E5261A%}.+%{FFFFFF%} ðåïîðò.+!') then
		repnick, repid, reptext = string.match(text, '%[Ðåïîðò%] îò (.+)%[(.+)%]:%{FFFFFF%} (.+)%. Óæå %{E5261A%}.+%{FFFFFF%} ðåïîðò.+!')
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
	-- if text:find('Àäìèíèñòðàöèÿ â ñåòè %(.+ ÷åë%. | .+ â AFK%):') then
		-- if checkadm == true then
			-- lua_thread.create(function()
				-- wait(1000)
				-- checkadm = false
			-- end)
			-- return false
		-- end
	-- elseif text:find('^%{fefe22%}.+%[.+%] %- %[.+%] %{FFFFFF%} %- %{DC2020%}/re .+%- %[AFK: .+%]%{FFFFFF%} %- Ðåïóòàöèÿ: .+') then
	-- local admnick,admid,admdol,admre,admafk = string.match(text,'^%{fefe22%}(.+)%[(.+)%] %- %[(.+)%] %{FFFFFF%} %- %{DC2020%}/re (.+)%- %[AFK: (.+)%]%{FFFFFF%} %- Ðåïóòàöèÿ: .+')
	-- admrenick = sampGetPlayerNickname(tonumber(admre))
	-- if debuger then
	-- sampAddChatMessage('Simon_DEBUG | admnick = ['..admnick..'] admid = ['..admid..'] admre = ['..admre..']',-1)
	-- sampAddChatMessage('Simon_DEBUG | admdol = ['..admdol..'] admafk = ['..admafk..'] admrenick = ['..admrenick..']',-1)
	-- end
		-- if checkadm == true then
			-- for i=1,#simons do
					-- if tostring(sampGetPlayerNickname(tonumber(admre))) == tostring(simons[i]) then
						-- if debuger then
						-- sampAddChatMessage('Simon_DEBUG | SendRecon()',-1)
						-- end
						-- SendRecon(admdol,admnick,admid,admrenick,admre,admafk)
					-- else
						-- err=1
					-- end
				-- end
			-- return false--[Òþðüìà] {FFFFFF}Wackie_Talckie[454] ïîíèçèë ñðîê Melty_Semenov[513]. Ïðè÷èíà: Õîðîøåå ïîâèäåíèå
		-- end--[Òþðüìà] {FFFFFF}Wackie_Talckie[423] ïîâûñèë ñðîê Jhon_Milar[344]. Ïðè÷èíà: Ïðîâîêàöèÿ + Ñóáîðäèíàöèÿ
		-- --%[Òþðüìà%] %{FFFFFF%}.+%[.+%] ïîâûñèë ñðîê .+%[.+%]. Ïðè÷èíà: .+
	elseif text:find('%[Òþðüìà%] %{FFFFFF%}.+%[.+%] ïîâûñèë ñðîê .+%[.+%]. Ïðè÷èíà: .+') then
		ohr,zek, reasonzek = string.match(text,'%[Òþðüìà%] %{FFFFFF%}(.+)%[.+%] ïîâûñèë ñðîê (.+)%[.+%]. Ïðè÷èíà: (.+)')
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
	elseif text:find('%[Òþðüìà%] %{FFFFFF%}.+%[.+%] ïîíèçèë ñðîê .+%[.+%]. Ïðè÷èíà: .+') then
		ohr,zek, reasonzek = string.match(text,'%[Òþðüìà%] %{FFFFFF%}(.+)%[.+%] ïîíèçèë ñðîê (.+)%[.+%]. Ïðè÷èíà: (.+)')
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
end

-- function stest()
	-- lua_thread.create(function()--testcommand
	-- sampAddChatMessage(TAG.."Ïîñòóïèëî ïðåäëîæåíèå ââîäà êîìàíäû, âûáåðèòå èñõîä", -1)
	-- local len = renderGetFontDrawTextLength(my_font, "Èñõîä: {8ABCFA}Âûáîð îòâåòà")
	-- while true do wait(0) 
		-- renderFontDrawText(my_font, "Èñõîä: {8ABCFA}Âûáîð îòâåòà\n{FFFFFF}[{67E56F}1{FFFFFF}] - Ââåñòè.\n{FFFFFF}[{67E56F}2{FFFFFF}] - Íå ââîäèòü.", sx-len-10, sy-150, 0xFFFFFFFF)					
		-- if isKeyJustPressed(VK_1) and not sampIsChatInputActive() and not sampIsDialogActive() then
			-- lua_thread.create(function()
				-- wait(500)
				-- sampProcessChatInput(command)
			-- end)
			-- break
		-- end
		-- if isKeyJustPressed(VK_2) and not sampIsChatInputActive() and not sampIsDialogActive() then break end
	-- end
	-- end)
-- end
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
                sampAddChatMessage((TAG..'Îáíàðóæåíî îáíîâëåíèå. Ïûòàþñü îáíîâèòüñÿ c '..thisScript().version..' íà '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Çàãðóæåíî %d èç %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')
                      sampAddChatMessage((TAG..'Îáíîâëåíèå çàâåðøåíî! Íîâàÿ âåðñèÿ: '..updateversion), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((TAG..'Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóñêàþ óñòàðåâøóþ âåðñèþ...'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              sampAddChatMessage(TAG..'Ó âàñ ñòîèò v'..thisScript().version..'. Îáíîâëåíèå íå òðåáóåòñÿ.',-1)
            end
          end
        else
          print('v'..thisScript().version..': Íå ìîãó ïðîâåðèòü îáíîâëåíèå. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end
function SendWebhook(URL, DATA, callback_ok, callback_error) -- Ôóíêöèÿ îòïðàâêè çàïðîñà
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

-- function flooder()
	-- if MeAdm or debuger then
		-- while true do 
			-- wait(0)
			-- if sampIsLocalPlayerSpawned() then
				-- while (os.clock() - lastDialogWasActive) < 2.00 do wait(0) end
				-- sampSendChat('/admins')
				-- checkadm=true
				-- if debuger then
				-- sampAddChatMessage(DTAG..'/admins send',-1)
				-- end
				-- wait(3000)
			-- end
		-- end
	-- end
-- end

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

--https://discord.com/api/webhooks/1178645399855173652/xTHqsGXrORlgaU5wYffXOVdtq2QgVKEiBqRRZKzJ19FGsepXaamtvdSClF3g3cwDQAYL
function SendPov(arg)
	SendWebhook('https://discord.com/api/webhooks/1180516745988018287/WfzVOXi9udPhtmqKCTsAH9J3YdBbJbgScIejKlLUeScaL3jjPxlhPRv4Hvppj5BmQwl7', ([[{
  "content": null,
  "embeds": [
    {
      "title": "**%s**",
      "description": "```Âàø Nick_Name: **`%s`**\nÂàøà äîëæíîñòü: Íà÷àëüíèê èíñïåêöèè\nNick_Name çàêëþ÷¸ííîãî: **`%s`**\nÍà ñêîëüêî çâ¸çä áûë ïîâûøåí ñðîê?: **`ÓÊÀÆÈ`**\nÏðè÷èíà ïîâûøåíèÿ ñðîêà: **`%s`**```",
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
      "description": "```\nÂàø Nick_Name:  **`%s`**\nÂàøà äîëæíîñòü:  Íà÷àëüíèê èíñïåêöèè\nNick_Name çàêëþ÷¸ííîãî:  **`%s`**\nÍà ñêîëüêî çâ¸çä áûë ïîíèæåí ñðîê?:  **`ÓÊÀÆÈ`**\nÏðè÷èíà ïîíèæåíèÿ ñðîêà:  **`%s`**\n```",
      "color": 2014720
    }
  ],
  "attachments": []
}]]):format(ohr,ohr,zek,reasonzek))
end

function SendRecon(a,b,c,d,e,f)
	SendWebhook('https://discord.com/api/webhooks/1170220701169491998/fUeipWf4ZYigehfRcoyA-1VDPs08dzXT1TJpUtmw10r43kehSL-CntiGlioe864G6Zkt', ([[{
  "content": "<@&1170235730740650135>",
  "embeds": [
    {
      "title": "RECON",
      "description": "**%s | `%s[%s]`\nÑëåäèò çà `%s[%s]`\nAFK: `%s`**",
      "color": 16711680,
      "footer": {
        "text": "%s"
      }
    }
  ],
  "attachments": []
}]]):format(a,b,c,d,e,f,os.date("%d.%m.%Y %H:%M:%S")))
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

function sendKey(key)
    local _, myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
    local data = allocateMemory(68)
    sampStorePlayerOnfootData(myId, data)
    setStructElement(data, 36, 1, key, false)
    sampSendOnfootData(data)
    freeMemory(data)
end
