-- Aqui puedo definir las variables globales. También se pueden poner en otro .LUA
-- (como se hace para las localizaciones por idioma) siempre y cuando se incluya la referencia en el TOC o en el XML.

_MonturasOptions= {}
_MonturasOptionsCharacter= {}

local tt={}
local tn=0
local vt={}
local vn=0
local puid=0

-- Función de inicio llamada desde el evento OnLoad definido en el XML.


function Monturas_OnLoad()
	--Registramos nuestro propio comando /monturas
	SLASH_MONTURAS1 = "/monturas";
	SlashCmdList["MONTURAS"] = Monturas_Command; --se pone como valor la función que será llamada al escribir o lanzar una macro con /monturas	
	
	_MonturasOptionsCharacter = {
		tuid = 0,
		vuid = 0,
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
	if msg == "" then
		Montura_Azar_Command("otra")
	end
	if msg == nil then
		Montura_Azar_Command("otra")
	end
	if msg == "terrestre" then
		Montura_Terrestre_Command("otra")
	end
	if msg == "voladora" then
		Montura_Voladora_Command("otra")
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
	if msg == "mazar" then
		Montura_Azar_Command("misma")
	end
	if msg == "mcriatura" then
		Criatura_Azar_Command("misma")
	end
end


function Montura_Macro_Command()
	if GetMacroIndexByName("mterrestre") ~= 0 then 
		EditMacro("mterrestre", "mterrestre", "Ability_Mount_Ridinghorse", "/monturas terrestre", 1, nil)
	else
		CreateMacro("mterrestre", "Ability_Mount_Ridinghorse", "/monturas terrestre", 1, nil)
	end

	if GetMacroIndexByName("mvoladora") ~= 0 then
		EditMacro("mvoladora", "mvoladora", "Ability_Mount_Drake_Bronze", "/monturas voladora", 1, nil)
	else
		CreateMacro("mvoladora", "Ability_Mount_Drake_Bronze", "/monturas voladora", 1, nil)
	end

	if GetMacroIndexByName("mazar") ~= 0 then
		EditMacro("mazar", "mazar", "Ability_Mount_Goldengryphon", "/monturas azar", 1, nil)
	else
		CreateMacro("mazar", "Ability_Mount_Goldengryphon", "/monturas azar", 1, nil)
	end

	if GetMacroIndexByName("crazar") ~= 0 then
		EditMacro("crazar", "crazar", "Inv_Pet_Pettrap01", "/monturas criatura", 1, nil)
	else
		CreateMacro("crazar", "Inv_Pet_Pettrap01", "/monturas criatura", 1, nil)
	end
	
	message("Creadas/Modificadas las macros del addon MONTURAS")
end


function Montura_Terrestre_Command(msg)
	-- Si esta montado desmonta
	
	if GetMouseButtonClicked() ~= "LeftButton" then
		msg = "misma"
	end
	
	if IsMounted() then
		Dismount()
	else
		local mifaccion = select(1,UnitFactionGroup("player"))
		local mifaccionn = nil
		if mifaccion == "Alliance" then
			mifaccionn = 1
		else
			mifaccionn = 0
		end
		-- Si no se le ha dicho repe para usar la anterior, o no hubiera ninguna anterior definida
		if msg ~= "misma" or _MonturasOptionsCharacter["tuid"] == 0 then
			tt={}
			tn=0
			for i=1,C_MountJournal.GetNumMounts() do
				local q = select(5,C_MountJournal.GetMountInfoExtra(i))
				local aprendido = select(11,C_MountJournal.GetMountInfo(i))
				local faccion = select(9,C_MountJournal.GetMountInfo(i))
				local faccionn = faccion
				if faccion == nil then
					faccionn = mifaccionn
				end
				if q == 230 and aprendido == true and mifaccionn == faccionn then -- 230 es terrestre
					tn = tn + 1
					tt[tn] = i
				end
			end
			_MonturasOptionsCharacter["tuid"] = tt[random(tn)]
		end
		-- Para los druidas cancela cualquier forma que tuviese
		CancelShapeshiftForm()
		C_MountJournal.Summon(_MonturasOptionsCharacter["tuid"])
	end
end


function Montura_Voladora_Command(msg)
	-- Si esta montado desmonta
	
	if GetMouseButtonClicked() ~= "LeftButton" then
		msg = "misma"
	end

	if IsMounted() then
		Dismount()
	else
		local mifaccion = select(1,UnitFactionGroup("player"))
		local mifaccionn = nil
		if mifaccion == "Alliance" then
			mifaccionn = 1
		else
			mifaccionn = 0
		end
		-- Si no se le ha dicho repe para usar la anterior, o no hubiera ninguna anterior definida
		if msg ~= "misma" or _MonturasOptionsCharacter["vuid"] == 0 then
			vt={}
			vn=0
			for i=1,C_MountJournal.GetNumMounts() do
				local q = select(5,C_MountJournal.GetMountInfoExtra(i))
				local aprendido = select(11,C_MountJournal.GetMountInfo(i))
				local faccion = select(9,C_MountJournal.GetMountInfo(i))
				local faccionn = faccion
				if faccion == nil then
					faccionn = mifaccionn
				end
				if q == 248 and aprendido == true and mifaccionn == faccionn then -- voladora
					vn = vn + 1
					vt[vn] = i
				end
			end
			_MonturasOptionsCharacter["vuid"] = vt[random(vn)]
		end
		-- Para los druidas cancela cualquier forma que tuviese
		CancelShapeshiftForm()
		C_MountJournal.Summon(_MonturasOptionsCharacter["vuid"])
	end
end


function Montura_Azar_Command(msg)
	-- Si se puede volar montura voladora
	if IsFlyableArea() then
		 Montura_Voladora_Command(msg)
	-- Si no terrestre
	else
		Montura_Terrestre_Command(msg)
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
			r=random(v[2])
			p={q.GetPetInfoByIndex(r)}
			_MonturasOptionsCharacter["puid"] = p[1]
		end
		q.SummonPetByGUID(_MonturasOptionsCharacter["puid"])
	-- Si tiene un acompanante fuera lo quita
	else
	    q.SummonPetByGUID(actual)
	end
end
