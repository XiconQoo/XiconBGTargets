if( GetLocale() ~= "frFR" ) then
	return
end

XiconBGTargetsLocals = setmetatable({

}, {__index = SSPVPLocals})