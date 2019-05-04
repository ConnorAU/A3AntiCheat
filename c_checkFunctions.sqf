/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _funcCheckThreadVar = '_funcCheckThreadVar' call _genRandString;

// obfuscated stuff is from back when I used obfusqf, have made my own proper script encryption & pbo "obfuscator" since then but never bothered removing it here
private _obfuscatedFncTags = ('true' configClasses (missionConfigFile >> 'CfgFunctions')) apply {[tolower(configName _x + '_fnc_')]};
private _mnsApprovedSegments = [['BIS_fnc_'],['life_fnc_'],['TON_fnc_'],['SOCK_fnc_'],['CAU_fnc_'],'rscmissionstatus_buttonclick','life_server_isready','DiscordRichPresence_fnc_init','DiscordRichPresence_fnc_update'] + _obfuscatedFncTags;
private _uinsApprovedSegments =[['BIS_fnc_'],'ammobox_script',['display3den','_script'],['rsc','_script'],['rscattribute'],['bis_functions_list'],['bis_handlerespawnmenu_fnc_'],'splasharma3orange_script','DiscordRichPresence_fnc_init','DiscordRichPresence_fnc_init_meta','DiscordRichPresence_fnc_update','DiscordRichPresence_fnc_update_meta'];


private _genFncList = {
	params [['_cfg',configNull,[configNull]],['_mod',[],[[]]]];
	private _out = [];
	{
		{
			if!((configSourceModList _x apply {tolower _x}in _mod)) then {
				_fPD=isText(_x>>'file');
				_fP=if _fPD then{getText(_x>>'file')}else{configName _x};
				{
					_fT=if(isText(_x>>'ext'))then{getText(_x>>'ext')}else{'.sqf'};
					if(_fT=='.sqf')then{
						_fPFinal=if(isText(_x>>'file'))then{getText(_x>>'file')}else{['functions\'+_fp,_fP]select _fPD};
						_fPFinal=if(['.sqf',_fPFinal]call BIS_fnc_inString)then{_fpFinal}else{_fPFinal+format['\fn_%1%2',configname _x,_fT]};
						_out pushbackunique (tolower _fpFinal);
					};
				}foreach('true' configClasses _x);
			};
		}foreach('true' configClasses _x);
	}foreach('true' configClasses _cfg);
	_out
};
private _obfuscatedFilePaths = [missionConfigFile >> 'CfgFunctions'] call _genFncList;


private _checkFunctions_MNSVars_generateCheck = { "
_v = missionNamespace getVariable _vN;
if !(isNil '_v') then {
	_scannedFncs pushback _vN;
	if (_v isEqualType {}) then {
		if (("+str (_mnsApprovedSegments call BIS_fnc_arrayShuffle)+" findIf {
			if (_x isequaltype '') then {
				(_vN == _x)
			} else {
				([_vN,_x param [0,'',['']]] call life_fnc_stringStartsWith) &&
				([_vN,_x param [1,'',['']]] call life_fnc_stringEndsWith)
			};
		}) < 0) then {
			missionNamespace setVariable [_vN,nil];
			"+([
			    "_"+_flagInitQueueVar+" pushback ['ft01',['MNS',_vN,_v]];",
			    "_"+_reasonVar+" = ['ft01',['MNS',_vN,_v]];call _this;"
			] select _this)+"

		};
	};
};
"};

private _checkFunctions = "
if (!isNil '"+_funcCheckThreadVar+"') then {
	_"+_reasonVar+" = ['ia03','Function'];
	call _"+_checkFlaggedStatusVar+";
} else {
"+_funcCheckThreadVar+" = [[_mnsScannedFunctions,_"+_checkFlaggedStatusVar+"],{
	disableSerialization;
	private ['_v','_vN','_"+_reasonVar+"','_vars','_index'];
	private _scannedFncs = param[0,[],[[]]];
	_this = param[1,{},[{}]];
	while {true} do {
		"+SET_SCOPE_NAME+"
		_"+_reasonVar+" = [];
		uisleep (random 0.7 max 0.5);
		_index = 0;
		while {_index > -1} do {
			_vars = allVariables missionNamespace;
			_index = _vars findIf {
				"+_FThreadHijackVar+" = 0;
				!(_x in _scannedFncs)
			};
			if (_index > 0) then {
				_vN = _vars select _index;
				"+(true call _checkFunctions_MNSVars_generateCheck)+"
			};
		};

		if !("+_funcCheckThreadVar+" isequalto _thisScript) then {
			_"+_reasonVar+" = ['tc06',['Function',str "+_funcCheckThreadVar+"]];
			call _this;
			terminate "+_funcCheckThreadVar+";
			"+_funcCheckThreadVar+" = _thisScript;
		};
	};
}] spawn {
	"+SET_SCRIPT_NAME+"
	(_this select 0) call (_this select 1);
};
(objectFromNetId "+str _rndObjID+") setVariable ["+str _funcCheckThreadVar+","+_funcCheckThreadVar+"];
};
";



private _checkFunctions_MNSVars = "
private ['_v','_vN'];
private _scannedFncs = [];
{
	_vN = tolower _x;
	"+(false call _checkFunctions_MNSVars_generateCheck)+"
}foreach (allVariables missionNamespace);
_scannedFncs
";

private _checkFunctions_UINSVars = "
disableSerialization;
if !(istext(missionConfigFile >> 'CAU_AC_UIV')) then {
	_"+_flagInitQueueVar+" pushback ['ft02','UINS'];
};
{
	"+SET_SCOPE_NAME+"
	_vN = tolower _x;
	_v = uiNameSpace getVariable _vN;
	if !(isNil '_v') then {
		if (_v isEqualType {}) then {
				if (("+str (_uinsApprovedSegments call BIS_fnc_arrayShuffle)+" findIf {
					if (_x isequaltype '') then {
						(_vN == _x)
					} else {
						([_vN,_x param [0,'',['']]] call life_fnc_stringStartsWith) &&
						([_vN,_x param [1,'',['']]] call life_fnc_stringEndsWith)
					};
				}) < 0) then {
				uiNameSpace setVariable [_vN,nil];
				_"+_flagInitQueueVar+" pushback ['ft01',['UINS',_vN,_v]];
			};
		};
	};
}foreach (parseSimpleArray getText(missionConfigFile >> 'CAU_AC_UIV'));
";

private _checkFunctions_PROFNSVars = "
disableSerialization;
if !(istext(missionConfigFile >> 'CAU_AC_PROFV')) then {
	_"+_flagInitQueueVar+" pushback ['ft02','PROFNS'];
};
private _blacklisted = (parseSimpleArray getText(missionConfigFile >> 'CAU_AC_PROFV')) select {(profilenamespace getVariable [_x,'']) isEqualType {}};
if (count _blacklisted > 0) then {
	{
		_vN = tolower _x;
		_v = profileNameSpace getVariable _vN;
		if (_v isequaltype {}) then {
			profileNameSpace setVariable [_vN,nil];
			_"+_flagInitQueueVar+" pushback ['ft01',['PROFNS',_vN,_v]];
		};
	} foreach _blacklisted;
};
";
private _checkFunctions_PARNSVars = "
disableSerialization;
{
	_vN = toLower _x;
	_v = parsingNamespace getVariable _vN;
	parsingNamespace setVariable[_x,nil];
	if (_v isEqualType {}) then {
		_"+_flagInitQueueVar+" pushback ['ft01',['PARNS',_vN,_v]];
	};
}foreach (allVariables parsingNamespace);
";
private _checkFunctions_fileDetails = " 
private _verify = {
	params [
		['_cfgDirArr',[],[[]],3],
		['_filepath','',['']],
		['_funcName','',['']],
		['_addonList',[],[[]]],
		['_modList',[],[[]]]
	];
	_cfgDirArr params ['_cfgTop','_cfgMid','_cfgLow'];
	
	private _gfdDirTop = missionConfigFile >> 'CfgAntiCheat' >> 'GFD' >> _cfgTop;
	private _gfdDirMid = _gfdDirTop >> _cfgMid;
	private _gfdDirLow = _gfdDirMid >> _cfgLow;
	private _gfdDirExist = isClass _gfdDirLow;

	private _ofdDirTop = missionConfigFile >> 'CfgAntiCheat' >> 'OFD' >> _cfgTop;
	private _ofdDirMid = _ofdDirTop >> _cfgMid;
	private _ofdDirLow = _ofdDirMid >> _cfgLow;
	private _ofdDirExist = isClass _ofdDirLow;

	if (_gfdDirExist OR _ofdDirExist) then {
		private _cCfgDir = [_gfdDirLow,_ofdDirLow] param [[_gfdDirExist,_ofdDirExist] find true,configNull,[configNull]];
		if !(isNull _cCfgDir) then {
			private _cfileinfo = getArray(_cCfgDir >> 'f');
			_cfileinfo params [['_cfilepath','',['']],['_cfilechar',0,[0]]];
			private _addonList = _addonList-getArray(_cCfgDir >> 'a');
			private _modList = _modList-getArray(_cCfgDir >> 'm');

			if (_filepath != _cfilepath) then {
				_"+_flagInitQueueVar+" pushback ['ft03',[_cfgDirArr,_filepath,_cfilepath,missionNamespace getVariable [_funcName,'nil_var']]];
			};
			if (
				(_gfdDirExist && {(count preprocessFile _filepath) != _cfilechar}) OR 
				(_ofdDirExist && {abs((count preprocessFile _filepath)-_cfilechar)>3})
			) then {
				_"+_flagInitQueueVar+" pushback ['ft04',[_cfgDirArr,_filepath,count preprocessFile _filepath,_cfilechar,missionNamespace getVariable [_funcName,'nil_var']]];
			};
			if (count _addonList > 0) then {
				_"+_flagInitQueueVar+" pushback ['ft05',[_cfgDirArr,_addonList,missionNamespace getVariable [_funcName,'nil_var']]];
			};
			if (count _modList > 0) then {
				_"+_flagInitQueueVar+" pushback ['ft06',[_cfgDirArr,_modList,missionNamespace getVariable [_funcName,'nil_var']]];
			};
		} else {
			_"+_flagInitQueueVar+" pushback ['ft07',[_cfgDirArr,_gfdDirExist,_ofdDirExist,missionNamespace getVariable [_funcName,'nil_var']]];
		};
	} else {
		_"+_flagInitQueueVar+" pushback ['ft08',[_cfgDirArr,_filepath,missionNamespace getVariable [_funcName,'nil_var']]];
	};
};
{
	_fCNameTop=configname _x;
	_ftTop = if (isText(_x >> 'tag')) then {getText(_x >> 'tag')} else {_fCNameTop};
	{
		_fCNameMid=configname _x;
		_fPD=isText(_x>>'file');
		_fP=if _fPD then{getText(_x>>'file')}else{_fCNameMid};
		{
			_fCNameLow=configname _x;
			_fT=if(isText(_x>>'ext'))then{getText(_x>>'ext')}else{'.sqf'};
			if(_fT=='.sqf')then{
				_fPFinal=if(isText(_x>>'file'))then{
					getText(_x>>'file')
				}else{
					['functions\'+_fp,_fP]select _fPD
				};
				_fPFinal=if(['.sqf',_fPFinal]call BIS_fnc_inString)then{
					_fpFinal
				}else{  
					_fPFinal+format['\fn_%1%2',_fCNameLow,_fT]
				};
				_ftFinal = format['%1_fnc_%2',_ftTop,_fCNameLow];
				_fSAL = configSourceAddonList _x apply {tolower _x};
				_fSML = configSourceModList _x apply {tolower _x};
				[[_fCNameTop,_fCNameMid,_fCNameLow],_fpFinal,_ftFinal,_fSAL,_fSML] call _verify;
			};
		}foreach('true' configClasses _x);
	}foreach('true' configClasses _x);
}foreach('true' configClasses (configFile >> 'CfgFunctions'));
";
