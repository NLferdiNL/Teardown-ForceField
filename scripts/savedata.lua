moddataPrefix = "savegame.mod.forcefield"

range = GetFloat(moddataPrefix .. "Range", 20)
forceStrength = GetFloat(moddataPrefix .. "ForceStrength", 3)
forcefieldKey = GetString(moddataPrefix .. "ForceFieldKey")

function saveFileInit()
	saveVersion = GetInt(moddataPrefix .. "Version")
	
	if saveVersion < 1 or saveVersion == nil then
		saveVersion = 1
		SetInt(moddataPrefix .. "Version", saveVersion)
		
		range = 20
		SetFloat(moddataPrefix .. "Range", range)
		
		forceStrength = 3
		SetFloat(moddataPrefix .. "ForceStrength", forceStrength)
		
		forcefieldKey = "c"
		SetString(moddataPrefix .. "ForceFieldKey", forcefieldKey)
	end
end