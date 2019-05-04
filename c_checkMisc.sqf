/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/


// Check ProfNS Vars
private _uiVarsList = [];
private _permittedStrings = [
	"(10 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25))",
	"(safezoneY + 0.5 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25))",
	"(10 * 			(			((safezoneW / safezoneH) min 1.2) / 40))",
	"(safezoneX + safezoneW - 10.5 * 			(			((safezoneW / safezoneH) min 1.2) / 40))",
	"(safezoneY + safezoneH - 15.5 * 			(			(			((safezoneW / safezoneH) min 1.2) / 1.2) / 25))",
	"((safezoneW / safezoneH) min 1.2)",
	"(safezoneX)",
	"(safezoneY + safezoneH - 			(			((safezoneW / safezoneH) min 1.2) / 1.2))",
	"(safezoneX + safezoneW / 2 - 2.8 * 			(			((safezoneW / safezoneH) min 1.2) / 40))",
	"(			((safezoneW / safezoneH) min 1.2) / 1.2)",
	"(safezoneX + (safezoneW - 					((safezoneW / safezoneH) min 1.2))/2)",
	"(safezoneY + (safezoneH - 					(			((safezoneW / safezoneH) min 1.2) / 1.2))/2)"
];
private _checkProfNSVarsSCALAR = "
private _v = 0;
{
	_v = profileNamespace getVariable [_x,0];
	if !(_v isEqualType 0) then {
		if (_v in "+str _permittedStrings+") then {
			_"+_flagInitQueueVar+" pushback ['pnsvs01',[_x,_v]];
			profileNamespace setVariable [_x,call compile _v];
			saveProfileNamespace;
		} else {
			_"+_flagInitQueueVar+" pushback ['pnsvs02',[_x,_v]];
		};
	};
}foreach (getArray(missionConfigFile >> 'CfgAntiCheat' >> 'SCP')+"+str _uiVarsList+");
";


// Scroll Menu
private _badText = '_badText' call _genRandString;
private _badCode = '_badCode' call _genRandString;
private _badTextList = [];
private _badCodeList = [];
private _checkScrollMenu = "
private ['_actionID'];
private _"+_badText+" = compilefinal str(getArray(missionConfigFile >> 'CfgAntiCheat' >> 'AAT') + "+str _badTextList+");
private _"+_badCode+" = compilefinal str(getArray(missionConfigFile >> 'CfgAntiCheat' >> 'AAC') + "+str _badCodeList+");
{
	_actionID = _x;
	(player actionParams _actionID) params ['_text','_code'];
	if (!isNil '_text' && !isNil '_code') then {
		{
			if ([_x,_text] call BIS_fnc_inString) then {
				_"+_reasonVar+" = ['sm01',[_x,_text,_code]];
				player removeAction _actionID;
				call _"+_checkFlaggedStatusVar+";
			};
		}foreach (call _"+_badText+");
		{
			if ([_x,_code] call BIS_fnc_inString) then {
				_"+_reasonVar+" = ['sm02',[_x,_text,_code]];
				player removeAction _actionID;
				call _"+_checkFlaggedStatusVar+";
			};
		}foreach (call _"+_badCode+");
	};
}foreach (actionIDs player);
";


// Check Vars
private _checkVarsThread = '_checkVarsThread' call _genRandString;
private _badVarsList = [];
private _checkVars = "
if (scriptDone _"+_checkVarsThread+") then {
	_"+_checkVarsThread+" = [_"+_checkFlaggedStatusVar+",{
		{
			_v = _x;
			{
				if !(isNil {_x getVariable _v}) exitwith {
					_"+_reasonVar+" = ['cv01',[
						['MNS','UINS'] param [_forEachIndex,'UNK'],
						_v,
						if ((_x getVariable [_v,'nil']) isequaltype '') then {str(_x getVariable [_v,'nil'])} else {_x getVariable [_v,'nil']}
					]];
					_x setVariable [_v,nil];
					call _this;
				};
			} foreach [missionNamespace,uiNamespace];
		} foreach (getArray(missionConfigFile >> 'CfgAntiCheat' >> 'BV') + "+str _badVarsList+");
		{
			if !(isNil {profileNamespace getVariable _x}) exitwith {
				_"+_reasonVar+" = ['cv01',['PROFNS',_x,profileNamespace getVariable [_x,'nil']]];
				profileNamespace setVariable [_x,nil];
				call _this;
			};
		} foreach (getArray(missionConfigFile >> 'CfgAntiCheat' >> 'BV2') + "+str _badVarsList+");
	}] spawn {
		"+SET_SCRIPT_NAME+"
		(_this select 0) call (_this select 1);
	};
};
";
			//uisleep ([0,0.001] select (diag_fps < 40));


// Check Active Scripts
private _checkActiveScriptsThread = '_checkActiveScriptsThread' call _genRandString;
private _badScriptNamesList = [];
private _badScriptPathsList = ["scratch\scratch.sqf","[CHANGETHIS"];
private _checkActiveScripts = "
if (scriptDone _"+_checkActiveScriptsThread+") then {
	_"+_checkActiveScriptsThread+" = [_"+_checkFlaggedStatusVar+",{
		{
			_script = _x;
			_script params [['_name','',['']],['_path','',['']]];

			{
				if ([_x,_name] call BIS_fnc_instring) then {
					_"+_reasonVar+" = ['as01',[_x,_script]];
					call _this;
				};
			} foreach "+str _badScriptNamesList+";
			{
				if ([_x,_path] call BIS_fnc_instring) then {
					_"+_reasonVar+" = ['as02',[_x,_script]];
					call _this;
				};
			} foreach "+str _badScriptPathsList+";
		}foreach diag_activeSQFScripts;
	}] spawn {
		"+SET_SCRIPT_NAME+"
		(_this select 0) call (_this select 1);
	};
};
";

// Check Config Root Sources
private _checkConfigRootSources = "
private ['_gcslA','_gcslM','_gcslE','_ocslA','_ocslM','_ocslE','_csal','_csml'];
private _gcslCfg = missionConfigFile >> 'CfgAntiCheat' >> 'GCSL';
private _ocslCfg = missionConfigFile >> 'CfgAntiCheat' >> 'OCSL';
{
	_gcslE = isClass(_gcslCfg >> configName _x);
	_gcslA = getArray(_gcslCfg >> configname _x >> 'a');
	_gcslM = getArray(_gcslCfg >> configname _x >> 'm');

	_ocslE = isClass(_ocslCfg >> configName _x);
	_ocslA = getArray(_ocslCfg >> configname _x >> 'a');
	_ocslM = getArray(_ocslCfg >> configname _x >> 'm');

	_csal = (configSourceAddonList _x apply {tolower _x})-(_gcslA+_ocslA);
	_csml = (configSourceModList _x apply {tolower _x})-(_gcslM+_ocslM);
	if ((_gcslM+_ocslM) isEqualTo []) then {
		_csml = _csml - ['arma 3'];
	};

	if ((!_gcslE && !_ocslE) && {count(_csal+_csml) > 0}) then {
		_"+_flagInitQueueVar+" pushback ['csl01',_x];
	} else {
		if (count _csal > 0) then {
			_"+_flagInitQueueVar+" pushback ['csl02',[_x,_csal]];
		};
		if (count _csml > 0) then {
			_"+_flagInitQueueVar+" pushback ['csl03',[_x,_csml]];
		};
	};
} foreach ('true' configClasses configFile);
";


// Check for duplicate unit containers
private _checkUnitContainers = "
_NOBJ = (playableUnits-[player]) select {!isNull (uniformContainer _x) && {(uniformContainer _x) isEqualTo (uniformContainer player)}};
if (count _NOBJ>0) then {
	_"+_reasonVar+" = ['cc11',[uniform player,getpos player]+(_NOBJ apply {[name _x,getplayeruid _x,side _x,getpos _x]})];
	{removeUniform _x} foreach (_NOBJ+[player]);
	call _"+_checkFlaggedStatusVar+";
};

_NOBJ = (playableUnits-[player]) select {!isNull (vestContainer _x) && {(vestContainer _x) isEqualTo (vestContainer player)}};
if (count _NOBJ>0) then {
	_"+_reasonVar+" = ['cc12',[vest player,getpos player]+(_NOBJ apply {[name _x,getplayeruid _x,side _x,getpos _x]})];
	{removeVest _x} foreach (_NOBJ+[player]);
	call _"+_checkFlaggedStatusVar+";
};

_NOBJ = (playableUnits-[player]) select {!isNull (backpackContainer _x) && {(backpackContainer _x) isEqualTo (backpackContainer player)}};
if (count _NOBJ>0) then {
	_"+_reasonVar+" = ['cc13',[backpack player,getpos player]+(_NOBJ apply {[name _x,getplayeruid _x,side _x,getpos _x]})];
	{removeBackpackGlobal _x} foreach (_NOBJ+[player]);
	call _"+_checkFlaggedStatusVar+";
};
";
