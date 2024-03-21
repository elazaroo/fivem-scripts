ESX = exports["es_extended"]:getSharedObject()

Text               = {}
local BanList = {}


ESX.RegisterServerCallback('keko_adminmenu:getInfo', function(src, cb, id)
  local tbl = {}
  local xPlayer = ESX.GetPlayerFromId(id)
  if xPlayer then
    local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
      ['@identifier'] = xPlayer.identifier
    })

    GetPlayerInfos(id, function(f,l,s,d,h)
        tbl['firstname'] = f
        tbl['lastname'] = l
        tbl['sex'] = s
        tbl['dob'] = d
        tbl['height'] = h
        tbl['cash'] = xPlayer.getMoney()
        tbl['bankmoney'] = xPlayer.getAccount('bank').money
        tbl['blackmoney'] = xPlayer.getAccount('black_money').money
        cb(tbl,xPlayer.getLoadout(), xPlayer.getInventory())
    end)
  end
end)

ESX.RegisterServerCallback('keko_adminmenu:getGroup', function(src, cb)
  local tbl = {}
  local xPlayer = ESX.GetPlayerFromId(src)
  cb(xPlayer.getGroup())
end)

ESX.RegisterServerCallback('keko_adminmenu:getPlayers', function(src, cb)
  local players = {}
  local xPlayers = ESX.GetPlayers()
  local Admin = ESX.GetPlayerFromId(src)
  local grp = Admin.getGroup()
  if grp ~= 'user' then
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        table.insert(players, {id = xPlayer.source, name = GetPlayerName(xPlayer.source)})
    end
    cb(json.encode(players))
  else
    cb(false)
  end
end)

ESX.RegisterServerCallback('keko_adminmenu:getAdmins', function(src, cb)
  local counts = {}
  local xPlayer = ESX.GetPlayerFromId(src)
  local xPlayers = ESX.GetPlayers()
  playercount, admincount = 0, 0
  local Admin = ESX.GetPlayerFromId(src)
  local grp = Admin.getGroup()
  if grp ~= 'user' then
    for i=1, #xPlayers, 1 do
        playercount = playercount + 1
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() ~= 'user' then
          admincount = admincount + 1
        end
    end
    counts['players'] = playercount
    counts['admins'] = admincount
    cb(counts)
  else
    cb(false)
  end
end)
function GetPlayerInfos(playerId, data)
    local idbro = ESX.GetPlayerFromId(playerId).identifier
    MySQL.Async.fetchAll("SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier", { ["@identifier"] = idbro }, function(result)
      data(result[1].firstname, result[1].lastname,result[1].sex, result[1].dateofbirth,result[1].height)
    end)
end

RegisterNetEvent('keko_adminmenu:kickbru')
AddEventHandler('keko_adminmenu:kickbru', function(ply, rsn)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= 'user' then
		DropPlayer(ply, rsn)
	end
end)


-- RegisterServerEvent('keko_scripts:update')
-- AddEventHandler('keko_scripts:update', function()
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- end)

RegisterServerEvent('requestSpectate')
AddEventHandler('requestSpectate', function(playerId)
  local target = playerId
  local xtarget = ESX.GetPlayerFromId(target)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= 'user' then

    local playerCoords = xtarget.getCoords(true)
    TriggerClientEvent("requestSpectate", source, xtarget.source, playerCoords)
  end
end)


RegisterServerEvent('goto')
AddEventHandler('goto', function(playerId)
  local target = playerId
  local xtarget = ESX.GetPlayerFromId(target)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= 'user' then
    local tgtPed = GetPlayerPed(target)
    local tgtCoords = GetEntityCoords(tgtPed)
    TriggerClientEvent('tpgoto', source, tgtCoords)
  end
end)


RegisterServerEvent('bring')
AddEventHandler('bring', function(playerId)
  local target = playerId
  local xtarget = ESX.GetPlayerFromId(target)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= 'user' then
    local tgtPed = GetPlayerPed(source)
    local tgtCoords = GetEntityCoords(tgtPed)
    TriggerClientEvent('tpbring', xtarget.source, tgtCoords)

  end
end)

RegisterServerEvent('freeze')
AddEventHandler('freeze', function(playerId)
  local target = playerId
  local xtarget = ESX.GetPlayerFromId(target)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= 'user' then
    TriggerClientEvent("frezzecl", xtarget.source)
  end
end)



RegisterServerEvent('screenshot')
AddEventHandler('screenshot', function(playerId)
  if Config.Screenshot then
    local target = playerId
    local xtarget = ESX.GetPlayerFromId(target)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	  if xPlayer.getGroup() ~= 'user' then
      doscrennshot(xtarget.source)
    end
  end
end)




function ExtractIdentifiers(src)
  local identifiers = {
      steam = "",
      ip = "",
      discord = "",
      license = "",
      xbl = "",
      live = ""
  }

  --Loop over all identifiers
  for i = 0, GetNumPlayerIdentifiers(src) - 1 do
      local id = GetPlayerIdentifier(src, i)

      --Convert it to a nice table.
      if string.find(id, "steam") then
          identifiers.steam = id
      elseif string.find(id, "ip") then
          identifiers.ip = id
      elseif string.find(id, "discord") then
          identifiers.discord = id
      elseif string.find(id, "license") then
          identifiers.license = id
      elseif string.find(id, "xbl") then
          identifiers.xbl = id
      elseif string.find(id, "live") then
          identifiers.live = id
      end
  end

  return identifiers
end


function doscrennshot(source)
  local src = source;

  local screenshotOptions = {
      encoding = 'png',
      quality = 1
  }    
  local ids = ExtractIdentifiers(src);
  local playerIP = ids.ip;
  local playerSteam = ids.steam;
  local playerLicense = ids.license;
  local playerXbl = ids.xbl;
  local playerLive = ids.live;
  local playerDisc = ids.discord;
  exports['discord-screenshot']:requestCustomClientScreenshotUploadToDiscord(src, Config.ScreenshotsWebhook, screenshotOptions, {
      username = '[KEKO ADMIN]',
      content = '',
      embeds = {
          {

         
              color = 16711680,
              description = '**__Player Identifiers:__** \n\n'
              .. '**Server ID:** `' .. src .. '`\n\n'
              .. '**Username:** `' .. GetPlayerName(src) .. '`\n\n'
              .. '**IP:** `' .. playerIP .. '`\n\n'
              .. '**Steam:** `' .. playerSteam .. '`\n\n'
              .. '**License:** `' .. playerLicense .. '`\n\n'
              .. '**Xbl:** `' .. playerXbl .. '`\n\n'
              .. '**Live:** `' .. playerLive .. '`\n\n'
              .. '**Discord:** `' .. playerDisc .. '`\n\n',
  
              footer = {
                  text = "[" .. src .. "] " .. GetPlayerName(src),
              }
          }
      }
  });

end





RegisterServerEvent("ban")
AddEventHandler("ban", function(target, reason, time)
  print("test")
  kickandbanuser(reason, target, time)
end)

RegisterServerEvent("unban")
AddEventHandler("unban", function(target)

  deletebanned(target) 
  loadBanList()
end)



ESX.RegisterServerCallback('keko_adminmenu:getbanlist', function(src, cb)
  loadBanList()
  Citizen.Wait(500)
  cb(BanList)
end)

loadBanList = function()
  MySQL.Async.fetchAll('SELECT * FROM keko_adminmenu', {}, function (data)
      BanList = {}
      for i=1, #data, 1 do
          table.insert(BanList, {
              token    = data[i].token,
              license    = data[i].license,
              targetname    = data[i].targetname,
              sourcename    = data[i].sourcename,
              identifier = data[i].identifier,
              liveid     = data[i].liveid,
              xblid      = data[i].xblid,
              discord    = data[i].discord,
              playerip   = data[i].playerip,
              reason     = data[i].reason,
              expiration = data[i].expiration,
              permanent  = data[i].permanent
          })
      end
  end)
end

kickandbanuser = function(reason, servertarget, duration)
  local target
  local duration     =  tonumber(duration)
  local reason    = reason

  if not reason then reason = "Not Specified" end
  if not duration then duration = 0 end
  target = tonumber(servertarget)

  if target and target > 0 then
      local ping = GetPlayerPing(target)

      if ping and ping > 0 then
          if duration and duration < 366 then
              local sourceplayername = "KEKO ADMIN"
              local targetplayername = GetPlayerName(target)
              local identifier, license, xblid, playerip, discord, liveid = getidentifiers(target)
              local token = {}
              for i = 0, GetNumPlayerTokens(target) do
                  table.insert(token, GetPlayerToken(target, i))
              end
              if duration > 0 then
                  ban_user(target,token,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duration,reason,0)
                  DropPlayer(target, "Has sido kickeado de este servidor. Razón: " .. reason)
              else
                  ban_user(target,token,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duration,reason,1)
                  DropPlayer(target, "Has sido baneado PERMANENTEMENTE de este servidor. Razón: " .. reason)
              end
          end
      end
  end
end

getidentifiers = function(player)
    local steamid = "Not Linked"
    local license = "Not Linked"
    local discord = "Not Linked"
    local xbl = "Not Linked"
    local liveid = "Not Linked"
    local ip = "Not Linked"

    for k, v in pairs(GetPlayerIdentifiers(player)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = string.sub(v, 4)
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@" .. discordid .. ">"
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        end
    end

    return steamid, license, xbl, ip, discord, liveid
end


ban_user = function(source,token,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duration,reason,permanent)
  local expiration = duration * 86400
  local timeat     = os.time()
  if expiration < os.time() then
      expiration = os.time()+expiration
  end
  MySQL.Async.execute('INSERT INTO keko_adminmenu (token,license,identifier,liveid,xblid,discord,playerip,targetname,sourcename,reason,expiration,timeat,permanent) VALUES (@token,@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetname,@sourcename,@reason,@expiration,@timeat,@permanent)',{
      ['@token']          = json.encode(token),
      ['@license']          = license,
      ['@identifier']       = identifier,
      ['@liveid']           = liveid,
      ['@xblid']            = xblid,
      ['@discord']          = discord,
      ['@playerip']         = playerip,
      ['@targetname'] = targetplayername,
      ['@sourcename'] = sourceplayername,
      ['@reason']           = reason,
      ['@expiration']       = expiration,
      ['@timeat']           = timeat,
      ['@permanent']        = permanent,
      }, function ()
  end)
  Citizen.Wait(500)
  loadBanList()
end





Citizen.CreateThread(function()
  Citizen.Wait(3000)
  while true do
      loadBanList()
      local min = 1000 * 60
      local wait = (min * Config.ReloadBanList)
      Citizen.Wait(wait)
  end
end)


AddEventHandler('playerConnecting', function (playerName,setKickReason, deferrals)
  local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

  for k,v in ipairs(GetPlayerIdentifiers(source))do
      if string.sub(v, 1, string.len("license:")) == "license:" then
              license = v
      elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
              steamID = v
      elseif string.sub(v, 1, string.len("live:")) == "live:" then
              liveid = v
      elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
              xblid  = v
      elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
              discord = v
      elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
              playerip = v
      end
  end
  local _src = source
  local tokens = {}
  for it = 0, GetNumPlayerTokens(_src) do
      table.insert(tokens, GetPlayerToken(_src, it))
  end
  local banned = false
  for i = 1, #BanList, 1 do
      if ((tostring(BanList[i].license)) == tostring(license) or (tostring(BanList[i].identifier)) == tostring(steamID) or (tostring(BanList[i].liveid)) == tostring(liveid) or (tostring(BanList[i].xblid)) == tostring(xblid) or (tostring(BanList[i].discord)) == tostring(discord) or (tostring(BanList[i].playerip)) == tostring(playerip)) then
          if (tonumber(BanList[i].permanent)) == 1 then
              banned = true
          end
      end
      local bannedtokens = json.decode(BanList[i].token)
      for k,v in pairs(bannedtokens) do
          for i3 = 1, #tokens, 1 do
              if v == tokens[i3] then
                  banned = true
              end
          end
      end
     
      if banned then
          if (tonumber(BanList[i].permanent)) == 1 then

      setKickReason(Text.yourpermban .. BanList[i].reason)
      CancelEvent()
      break
          elseif (tonumber(BanList[i].expiration)) > os.time() then

      local tempsrestant     = (((tonumber(BanList[i].expiration)) - os.time())/60)
      if tempsrestant >= 1440 then
        local day        = (tempsrestant / 60) / 24
        local hrs        = (day - math.floor(day)) * 24
        local minutes    = (hrs - math.floor(hrs)) * 60
        local txtday     = math.floor(day)
        local txthrs     = math.floor(hrs)
        local txtminutes = math.ceil(minutes)
          setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day ..txthrs .. Text.hour ..txtminutes .. Text.minute)
          CancelEvent()
          break
      elseif tempsrestant >= 60 and tempsrestant < 1440 then
        local day        = (tempsrestant / 60) / 24
        local hrs        = tempsrestant / 60
        local minutes    = (hrs - math.floor(hrs)) * 60
        local txtday     = math.floor(day)
        local txthrs     = math.floor(hrs)
        local txtminutes = math.ceil(minutes)
          setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
          CancelEvent()
          break
      elseif tempsrestant < 60 then
        local txtday     = 0
        local txthrs     = 0
        local txtminutes = math.ceil(tempsrestant)
          setKickReason(Text.yourban .. BanList[i].reason .. Text.timeleft .. txtday .. Text.day .. txthrs .. Text.hour .. txtminutes .. Text.minute)
          CancelEvent()
          break
      end

    elseif (tonumber(BanList[i].expiration)) < os.time() and (tonumber(BanList[i].permanent)) == 0 then

      deletebanned(license)
      break
    end
      end
  end
end)



Text = {
	start         = "La lista de prohibiciones (BanList) y el historial de prohibiciones (BanListHistory) se cargaron correctamente.",
	starterror    = "ERROR: No se pudo cargar la lista de prohibiciones (BanList) y el historial de prohibiciones (BanListHistory), por favor, inténtalo de nuevo.",
	banlistloaded = "La lista de prohibiciones (BanList) se cargó correctamente.",
	historyloaded = "El historial de prohibiciones (BanListHistory) se cargó correctamente.",
	loaderror     = "ERROR: No se pudo cargar la lista de prohibiciones (BanList).",
	cmdban        = "/sqlban (ID) (Duración en días) (Motivo de la prohibición)",
	cmdbanoff     = "/sqlbanoffline (Permid) (Duración en días) (Nombre de Steam)",
	cmdhistory    = "/sqlbanhistory (Nombre de Steam) o /sqlbanhistory 1,2,2,4......",
	forcontinu    = " días. Para continuar, ejecuta /sqlreason [motivo]",
	noreason      = "No se proporcionó un motivo.",
	during        = " durante: ",
	noresult      = "No se encontraron resultados.",
	isban         = " fue baneado",
	isunban       = " fue desbaneado",
	invalidsteam  = "Se requiere Steam para unirse a este servidor.",
	invalidid     = "ID del jugador no encontrada.",
	invalidname   = "El nombre especificado no es válido.",
	invalidtime   = "Duración de prohibición no válida.",
	alreadyban    = " ya estaba baneado por: ",
	yourban       = "Has sido baneado por: ",
	yourpermban   = "Has sido baneado permanentemente por: ",
	youban        = "Estás baneado en este servidor por: ",
	forr          = " días. Por: ",
	permban       = " permanentemente por: ",
	timeleft      = ". Tiempo restante: ",
	toomanyresult = "Demasiados resultados, sé más específico para acortar los resultados.",
	day           = " días ",
	hour          = " horas ",
	minute        = " minutos ",
	by            = "por",
	ban           = "Prohibir a un jugador",
	banoff        = "Prohibir a un jugador desconectado",
	dayhelp       = "Duración (días) de la prohibición",
	reason        = "Motivo de la prohibición",
	history       = "Muestra todas las prohibiciones anteriores para un jugador específico",
	reload        = "Actualiza la lista de prohibiciones y el historial.",
	unban         = "Desbanear a un jugador",
	steamname     = "Nombre de Steam"
}

function deletebanned(license) 
	MySQL.Async.execute(
		'DELETE FROM keko_adminmenu WHERE license=@license',
		{
		  ['@license']  = license
		},
		function ()
      print(""..license.." got unbanned")
			loadBanList()
	end)
end



RegisterCommand("am", function(source, args, rawCommand)
  local arg = args[1]
  local forbiddenNames = { 
    "license"
  }
  if source ~= 0 then
  
  else
      if not arg then 
    print("invalid usage")
    print("use am help > Commands")
  end
      if arg == "help" then
          print([[
##########################################################################################
                  Commands: 
                      am ban <target> <reason> <duration>
                      am unban license:23324345354
                      am reload 
##########################################################################################
          ]])
      elseif arg == "ban" then 
        local target = tonumber(args[2])
        if target and target > 0 then
            local ping = GetPlayerPing(target)
        
            if ping and ping > 0 then
              if args[3] then 
                if args[4] then
      
                  TriggerEvent("ban", target, args[3], args[4])
                else
    
                  TriggerEvent("ban", target, args[3], "0")
                end
              else
                print(Text.noreason)
              end
            else
              print(Text.invalidid)
            end
        else
          print("invalid usage")
          print("use am help > Commands")
        end
      elseif arg == "unban" then 
          if args[2] then
            local idses = args[2]
            for name in pairs(forbiddenNames) do
              if(string.gsub(string.gsub(string.gsub(string.gsub(idses:lower(), "-", ""), ",", ""), "%.", ""), " ", ""):find(forbiddenNames[name])) then
                deletebanned(args[2]) 
                loadBanList()
              else
                print("Argument format not correct")
                print("Argument format must be like | license:233943484384093284")
              end
            end
          else
              print("You must write the license identifier like | license:233943484384093284")
          end
      elseif arg == "reload" then 
          loadBanList()
          print("Ban List Reloaded")
      else
          print("Unknown Command")
      end
  end
end, true)


