/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _patchDev = ['CAU_DevAddon'] apply {tolower _X};
private _patchTmp = [] apply {tolower _X};
private _patchProhib = [];
private _checkPatches = "
private _prohibList = [];
private _prohibPatch = (getArray(missionConfigFile >> 'CfgAntiCheat' >> 'PAP') + "+(str _patchProhib)+") apply {tolower _x};
private _addonNames = ((
	(configProperties[missionConfigFile >> 'CfgAntiCheat' >> 'GAP','isArray _x'])+
	(configProperties[missionConfigFile >> 'CfgAntiCheat' >> 'OAP','isArray _x'])
) apply {tolower(configname _x)}) + "+(str (_patchDev+_patchTmp))+";
private _emptySourceList = [];

{
	if !(tolower(configname _x) in _addonNames) then {
		if !(tolower(configname _x) in _prohibPatch) then {
			_"+_flagInitQueueVar+" pushback ['patch01',[1,_x]];
		} else {
			_prohibList pushback (configname _x);
		};
	} else {
		if !(tolower(configname _x) in "+(str _patchTmp)+") then {
			_csml = configSourceModList _x apply {tolower _x};
			if (isArray(missionConfigFile >> 'CfgAntiCheat' >> 'GAP' >> configname _x)) then {
				_scsml = getArray(missionConfigFile >> 'CfgAntiCheat' >> 'GAP' >> configname _x);
				if (_scsml isEqualTo []) then {_csml = _csml - ['arma 3'];};
				if !(_csml isequalto _scsml) then {
					if (_csml isequalto []) then {
						_emptySourceList pushback [1,configname _x,_csml,_scsml];
					} else {
						_"+_flagInitQueueVar+" pushback ['patch02',[1,configname _x,_csml,_scsml]];
					};
				};
			} else {
				if (isArray(missionConfigFile >> 'CfgAntiCheat' >> 'OAP' >> configname _x)) then {
					_scsml = getArray(missionConfigFile >> 'CfgAntiCheat' >> 'OAP' >> configname _x);
					if (_scsml isEqualTo []) then {_csml = _csml - ['arma 3'];};
					if !(_csml isequalto _scsml) then {
						if (_csml isequalto []) then {
							_emptySourceList pushback [2,configname _x,_csml,_scsml];
						} else {
							_"+_flagInitQueueVar+" pushback [
								['patch02','patch02J'] select (
									(_csml isEqualTo ['861133494']) && 
									(_scsml isEqualTo ['@jsrs soundmod'])
								),
								[2,configname _x,_csml,_scsml]
							];
						};
					} else {
						if (tolower(configname _x) in "+(str _patchDev)+") then {
							if !(getPlayerUID player in ['76561198090361580']) then {
								_"+_flagInitQueueVar+" pushback ['patch01',[2,_x]];
							} else {
								if !(isNumber(_x >> 'CAU_C')) then {
									_"+_flagInitQueueVar+" pushback ['patch01',[3,_x]];
								} else {
									if !((count preprocessFile format['%1\config.sqf',configname _x]) isequalto getNumber(_x >> 'CAU_C')) then {
										_"+_flagInitQueueVar+" pushback ['patch01',[4,_x]];
									};
								};
							};
						};
					};
				} else {
					_"+_flagInitQueueVar+" pushback ['patch03',[configname _x,_csml]];
				};
			};
		};
	};
}foreach ('true' configClasses (configFile >> 'CfgPatches'));
if (count _emptySourceList > 0) then {
	if (count _emptySourceList <= 5) then {
		{_"+_flagInitQueueVar+" pushback ['patch02R',_x]} foreach _emptySourceList;
	} else {
		_"+_flagInitQueueVar+" pushBack ['patch02R',format['%1 addons',count _emptySourceList]];
	};
};
if (count _prohibList > 0) then {
	_"+_flagInitQueueVar+" pushback ['patch04',_prohibList];
	[[_prohibList],{
		params [['_patches',[],[[]]]];
		[
			[
				'We have detected prohibited addon(s) on your client.',
				'',
				'Prohibited addons can be either of the following:',
				'- Deprecated addons: game files that are no longer available for download from steam as they serve no purpose, but still exist in your arma install.',
				'- Unsupported mods: some mods share their bisign keys, so while we may allow the key we do not support all the mods it is used on.',
				'',
				'The following addons are prohibited:',
				_patches joinString '<br/>',
				'',
				'If you have any questions please contact support.',
				'Click <a href=''https://discord.gg/UXHg3Bh''>here</a> to join our Discord.'
			] joinstring '<br/>',
			'Prohibited addon(s) detected',
			'Proceed'
		] call BIS_fnc_guiMessage;
		[] call BIS_fnc_forceEnd;
		endLoadingScreen;
		while {true} do {
			endMission 'CAU_AC_Triggered';
			failMission 'CAU_AC_Triggered';
		};
	}] spawn {
		"+SET_SCRIPT_NAME+"
		(_this select 0) call (_this select 1)
	};
};
";