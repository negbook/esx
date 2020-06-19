Locales = {}

ClientOrServer = nil

function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end
function HashToScriptedText(hashkey)
    return GetStreetNameFromHashKey(hashkey)
end 
function HexToScriptedText(hex)
    return GetStreetNameFromHashKey(GetHashKey(hex))
end 
function ShortNameToScriptedText(hex)
    return GetStreetNameFromHashKey(GetHashKey(hex))
end 

AddEventHandler('onClientResourceStart', function (resourceName)
  if(GetCurrentResourceName() ~= resourceName) then
	return
  end
  print('The resource ' .. resourceName .. ' has been started on the client.')
  if ClientOrServer == nil then 
	ClientOrServer = "Client"
  end 

end)

AddEventHandler('onServerResourceStart', function (resourceName)
  if(GetCurrentResourceName() ~= resourceName) then
    return
  end
  print('The resource ' .. resourceName .. ' has been started on the server.')
  if ClientOrServer == nil then 
	ClientOrServer = "Server"
  end
end)

function _(str, ...)  -- Translate string
	
	if Locales[Config.Locale] ~= nil then

		if Locales[Config.Locale][str] ~= nil then
			
			if ClientOrServer ~=nil then 
				
				if ClientOrServer == "Client" then 
					--print(ClientOrServer)
					Locales[Config.Locale][str] = exports.rplanguageinit:AutoChineseSimple(Locales[Config.Locale][str])
					--print(Locales[Config.Locale][str])
				elseif ClientOrServer == "Server" then 
                    if source~=nil then 
					Locales[Config.Locale][str] = exports.rplanguageinit:AutoChineseSimple_Server(Locales[Config.Locale][str],source)
                    else 
                    Locales[Config.Locale][str] = exports.rplanguageinit:AutoChineseSimple_Server(Locales[Config.Locale][str])
                    end 
				end 
			end
			
			return string.format(Locales[Config.Locale][str], ...)
		else
			return 'Translation [' .. Config.Locale .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Config.Locale .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end
