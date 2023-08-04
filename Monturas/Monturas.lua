-- Aqui puedo definir las variables globales. También se pueden poner en otro .LUA
-- (como se hace para las localizaciones por idioma) siempre y cuando se incluya la referencia en el TOC o en el XML.

_MonturasOptions= {}
_MonturasOptionsCharacter= {}

local tt={}
local tn=0
local vt={}
local vn=0
local dt={}
local dn=0
local puid=0

-- Localización (multilenguaje). Como es tan poco he preferido meterlo en este fichero
local L = {};
L["CARGADO"] = "Macros and rest of 'Monturas' AddOn LOADED, version 10.1. Type /monturas for help.";
L["HELP01"] = " /monturas terrestre: ground mount \n /monturas voladora: flyable mount \n /monturas dragon: dragon mount \n /monturas azar: flyable mount, gorund mount if not flyable area \n /monturas criatura: random pet";
L["HELP02"] = " /monturas mterrestre, /monturas mvoladora, /monturas mdragon, /monturas azar, /monturas mcriatura: same commands, but call previous summoned pet or mount";
L["HELP03"] = " /monturas macros: build macros for this commands that can be used in action bars. These macros have been created at login";
if GetLocale() == "esES" then
    L["CARGADO"] = "Cargado las macros y el AddOn de 'Monturas' version 10.1. Teclee /monturas para acceder a la ayuda.";
	L["HELP01"] = " /monturas terrestre: montura terrestre \n /monturas voladora: montura voladora \n /monturas dragon: montura dragon \n /monturas azar: montura voladora o si no se puede terrestre \n /monturas criatura: mascota al azar";
	L["HELP02"] = " /monturas mterrestre, /monturas mvoladora, /monturas mdragon, /monturas azar, /monturas mcriatura: como las anteriores pero llama a la montura o mascota que usamos justo anteriormente";
    L["HELP03"] = " /monturas macros: crea macros para estas ordenes que pueden usarse en las barras de acciones. Estas macros también se crean automáticamente al entrar";
end


-- Función de inicio llamada desde el evento OnLoad definido en el XML.
function Monturas_OnLoad()
	--Registramos nuestro propio comando /monturas
	SLASH_MONTURAS1 = "/monturas";
	SlashCmdList["MONTURAS"] = Monturas_Command; --se pone como valor la función que será llamada al escribir o lanzar una macro con /monturas	
	
	_MonturasOptionsCharacter = {
		tuid = 0,
		vuid = 0,
		duid = 0,		
		puid = 0
	}
	
	-- Opcionalmente se pueden incluir alias al mismo comando
	-- SLASH_MONTURAS1 = "/monturas";
	-- SLASH_MONTURAS2 = "/mont";
	-- SlashCmdList["MONTURAS"] = Monturas_Command; --se pone como valor la función que será llamada al escribir o lanzar una macro con /monturas

	-- Nótese, que el nombre puesto en SlashCmdList["NOMBRE"] debe ser el mismo que en SLASH_NOMBRE1, SLASH_NOMBRE2...
end


-- Función invocada a través de nuestro comando /monturas. msg contendrá todo lo que vaya detrás del comando
-- (ej. para "/chispas help", contendrá "help"). De este modo podemos hacer comandos con parámetros.
function Monturas_Command(msg)
	if msg == "macros" then
		Montura_Macro_Command()
	end
	if msg == "" or msg == "help" or msg == nil then
		Montura_Help_Command()
	end
	if msg == "terrestre" then
		Montura_Terrestre_Command("otra")
	end
	if msg == "voladora" then
		Montura_Voladora_Command("otra")
	end
	if msg == "dragon" then
		Montura_Dragon_Command("otra")
	end	
	if msg == "azar" then
		Montura_Azar_Command("otra")
	end
	if msg == "criatura" then
		Criatura_Azar_Command("otra")
	end
	if msg == "mterrestre" then
		Montura_Terrestre_Command("misma")
	end
	if msg == "mvoladora" then
		Montura_Voladora_Command("misma")
	end
	if msg == "mdragon" then
		Montura_Dragon_Command("misma")
	end	
	if msg == "mazar" then
		Montura_Azar_Command("misma")
	end
	if msg == "mcriatura" then
		Criatura_Azar_Command("misma")
	end
end


function Montura_Help_Command()
	Monturas_Mensaje(L["HELP01"])
	Monturas_Mensaje(L["HELP02"])
	Monturas_Mensaje(L["HELP03"])
end


function Montura_Macro_Command()

    classDisplayName, class, classID = UnitClass("player");
	
	local cancelar = "";
	if classID == 11 then
		cancelar = "/cancelform [stance:1/2/3] \n";
	end

	if GetMacroIndexByName("mterrestre") ~= 0 then 
		EditMacro("mterrestre", "mterrestre", "Ability_Mount_Ridinghorse", cancelar .. "/monturas terrestre", 1, nil)
	else
		CreateMacro("mterrestre", "Ability_Mount_Ridinghorse", cancelar .. "/monturas terrestre", 1, nil)
	end

	if GetMacroIndexByName("mvoladora") ~= 0 then
		EditMacro("mvoladora", "mvoladora", "Ability_Mount_Drake_Bronze", cancelar .. "/monturas voladora", 1, nil)
	else
		CreateMacro("mvoladora", "Ability_Mount_Drake_Bronze", cancelar .. "/monturas voladora", 1, nil)
	end

	if GetMacroIndexByName("mdragon") ~= 0 then
		EditMacro("mdragon", "mdragon", "Inv_companionpterrordaxdrake", cancelar .. "/monturas dragon", 1, nil)
	else
		CreateMacro("mdragon", "Inv_companionpterrordaxdrake", cancelar .. "/monturas dragon", 1, nil)
	end	

	if GetMacroIndexByName("mazar") ~= 0 then
		EditMacro("mazar", "mazar", "Ability_Mount_Goldengryphon", cancelar .. "/monturas azar", 1, nil)
	else
		CreateMacro("mazar", "Ability_Mount_Goldengryphon", cancelar .. "/monturas azar", 1, nil)
	end

	if GetMacroIndexByName("crazar") ~= 0 then
		EditMacro("crazar", "crazar", "Inv_Pet_Pettrap01", "/monturas criatura", 1, nil)
	else
		CreateMacro("crazar", "Inv_Pet_Pettrap01", "/monturas criatura", 1, nil)
	end

	-- message("Creadas/Modificadas las macros del addon MONTURAS")
end


function Montura_Terrestre_Command(msg)
	if GetMouseButtonClicked() ~= "LeftButton" then
		msg = "misma"
	end
	
	if IsMounted() then
		-- Si esta montado desmonta
		Dismount()
	else
		-- Si no se le ha dicho repe para usar la anterior, o no hubiera ninguna anterior definida
		if msg ~= "misma" or _MonturasOptionsCharacter["tuid"] == 0 then
			tt={}
			tn=0
			local mifaccion = select(1,UnitFactionGroup("player"))
			local mifaccionn = nil
			if mifaccion == "Alliance" then
				mifaccionn = 1
			else
				mifaccionn = 0
			end
			local mountIDs = C_MountJournal.GetMountIDs()
			for i=1,#mountIDs do
				local q = select(5,C_MountJournal.GetMountInfoExtraByID(mountIDs[i]))
				local usable = select(5,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local aprendido = select(11,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local faccion = select(9,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local faccionn = faccion
				if faccion == nil then
					faccionn = mifaccionn
				end
				if q == 230 and usable == true and aprendido == true and mifaccionn == faccionn then -- 230 es terrestre
					tn = tn + 1
					tt[tn] = mountIDs[i]
				end
			end
			if tn > 0 then
				_MonturasOptionsCharacter["tuid"] = tt[random(tn)]
			end
		end
		if tn > 0 then
			-- Para los druidas cancela cualquier forma que tuviese
			CancelShapeshiftForm() -- Aunque no funciona porque es una función protegida
			C_MountJournal.SummonByID(_MonturasOptionsCharacter["tuid"])
			-- local nombre = select(1,C_MountJournal.GetMountInfoByID(_MonturasOptionsCharacter["tuid"]))
			-- Monturas_Mensaje(nombre)
		end
	end
end


function Montura_Voladora_Command(msg)
	if GetMouseButtonClicked() ~= "LeftButton" then
		msg = "misma"
	end

	if IsMounted() then
		-- Si esta montado desmonta
		Dismount()
	else
		-- Si no se le ha dicho repe para usar la anterior, o no hubiera ninguna anterior definida
		if msg ~= "misma" or _MonturasOptionsCharacter["vuid"] == 0 then
			vt={}
			vn=0
			local mifaccion = select(1,UnitFactionGroup("player"))
			local mifaccionn = nil
			if mifaccion == "Alliance" then
				mifaccionn = 1
			else
				mifaccionn = 0
			end
			local mountIDs = C_MountJournal.GetMountIDs()
			for i=1,#mountIDs do
				local q = select(5,C_MountJournal.GetMountInfoExtraByID(mountIDs[i]))
				local usable = select(5,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local aprendido = select(11,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local faccion = select(9,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local faccionn = faccion
				if faccion == nil then
					faccionn = mifaccionn
				end
				if q == 248 and usable == true and aprendido == true and mifaccionn == faccionn then -- voladora
					vn = vn + 1
					vt[vn] = mountIDs[i]
				end
			end
			if vn > 0 then
				_MonturasOptionsCharacter["vuid"] = vt[random(vn)]
			end
		end
		if vn > 0 then
			-- Para los druidas cancela cualquier forma que tuviese
			CancelShapeshiftForm() -- Aunque no funciona porque es una función protegida
			C_MountJournal.SummonByID(_MonturasOptionsCharacter["vuid"])
			-- local nombre = select(1,C_MountJournal.GetMountInfoByID(_MonturasOptionsCharacter["vuid"]))
			-- Monturas_Mensaje(nombre)
		end
	end
end


function Montura_Dragon_Command(msg)
	if GetMouseButtonClicked() ~= "LeftButton" then
		msg = "misma"
	end

	if IsMounted() then
		-- Si esta montado desmonta
		Dismount()
	else
		-- Si no se le ha dicho repe para usar la anterior, o no hubiera ninguna anterior definida
		if msg ~= "misma" or _MonturasOptionsCharacter["duid"] == 0 then
			dt={}
			dn=0
			local mifaccion = select(1,UnitFactionGroup("player"))
			local mifaccionn = nil
			if mifaccion == "Alliance" then
				mifaccionn = 1
			else
				mifaccionn = 0
			end
			local mountIDs = C_MountJournal.GetMountIDs()
			for i=1,#mountIDs do
				local q = select(5,C_MountJournal.GetMountInfoExtraByID(mountIDs[i]))
				local usable = select(5,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local aprendido = select(11,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local faccion = select(9,C_MountJournal.GetMountInfoByID(mountIDs[i]))
				local faccionn = faccion
				if faccion == nil then
					faccionn = mifaccionn
				end
				if q == 402 and usable == true and aprendido == true and mifaccionn == faccionn then -- dragon
					dn = dn + 1
					dt[dn] = mountIDs[i]
				end
			end
			if dn > 0 then
				_MonturasOptionsCharacter["duid"] = dt[random(dn)]
			end
		end
		if dn > 0 then
			-- Para los druidas cancela cualquier forma que tuviese
			CancelShapeshiftForm() -- Aunque no funciona porque es una función protegida
			C_MountJournal.SummonByID(_MonturasOptionsCharacter["duid"])
			-- local nombre = select(1,C_MountJournal.GetMountInfoByID(_MonturasOptionsCharacter["duid"]))
			-- Monturas_Mensaje(nombre)
		end
	end
end


function Montura_Azar_Command(msg)
	-- Si se puede usar montura dragon
	if IsAdvancedFlyableArea() then
		Montura_Dragon_Command(msg)
	else
		-- Si se puede volar montura voladora
		if IsFlyableArea() then
			Montura_Voladora_Command(msg)
		-- Si no terrestre
		else
			Montura_Terrestre_Command(msg)
		end
	end
end


function Criatura_Azar_Command(msg)

	if GetMouseButtonClicked() ~= "LeftButton" then
		msg = "misma"
	end

	q=C_PetJournal;
	actual = q.GetSummonedPetGUID()
	-- Si no tiene ningun acompanante fuera saca uno
	if actual == nil then
		-- Si no se le ha dicho repe para usar la anterior, o no hubiera ninguna anterior definida
		if msg ~= "misma" or _MonturasOptionsCharacter["puid"] == 0 then
			v={q.GetNumPets()}
			if v[2] > 0 then
				r=random(v[2])
				p={q.GetPetInfoByIndex(r)}
				_MonturasOptionsCharacter["puid"] = p[1]
			end
		end
		if v[2] > 0 then
			q.SummonPetByGUID(_MonturasOptionsCharacter["puid"])
		end
	-- Si tiene un acompanante fuera lo quita
	else
	    q.SummonPetByGUID(actual)
	end
end


function Monturas_Mensaje(texto)
	local tag = "MONTURAS"
	local frame = DEFAULT_CHAT_FRAME
	frame:AddMessage(("|cffff7d0a<|r|cffffd200%s|r|cffff7d0a>|r %s"):format(tostring(tag), tostring(texto)), 0.41, 0.8, 0.94)
end


function Monturas_OnEvent(self, event, ...) 
	if event == "PLAYER_ALIVE" then
		-- Después de este evento ya se ha entrado con el usuario. Entonces se ejecuta el comando de creación de macros.
		Montura_Macro_Command()
		Monturas_Mensaje(L["CARGADO"])
		self:UnregisterEvent("PLAYER_ALIVE")
	end
end
