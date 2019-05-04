/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

scriptName "[AntiCheat: Initialization]";

missionNamespace setVariable ['CAU_AC_RVL',[]];

#define SET_SCRIPT_NAME "scriptName 'Unsuspicious Thread Name';"
#define SET_SCOPE_NAME "scopeName 'Unsuspicious Thread Name';"

#include "\cau\anticheat\s_genRandString.sqf"
#include "\cau\anticheat\s_genThreadChecker.sqf"
#include "\cau\anticheat\s_genThreadCheckerIndependent.sqf"
#include "\cau\anticheat\s_log.sqf"
#include "\cau\anticheat\s_flagged.sqf"
#include "\cau\anticheat\s_serverTasksMasterThread.sqf"
#include "\cau\anticheat\s_changeScriptCasing.sqf"

['SYSTEM','Initializing'] call _log;
['SYSTEM',format['Decryption took %1 seconds',diag_ticktime - _this]] call _log;

private _rndObj = objNull;
while {isNull _rndObj} do {_rndObj = nearestObject [(selectRandom getArray(missionConfigFile >> "CfgModules" >> "CfgFunction" >> "CfgInfostands" >> "positions")),"Land_Infostand_V1_F"];};
private _rndObjID = netID _rndObj;
['SYSTEM',format['_rndObj = %1 %2',_rndObj,str(getPos _rndObj)]] call _log;
['SYSTEM','_rndObjID = '+ _rndObjID] call _log;

private _reasonVar = '_reasonVar' call _genRandString;
private _masterThreadVar = '_masterThreadVar' call _genRandString;
private _clientExecutionExecuted = '_clientExecutionExecuted' call _genRandString;
private _checkFlaggedStatusVar = '_checkFlaggedStatusVar' call _genRandString;
private _flagInitQueueVar = '_flagInitQueueVar' call _genRandString;
private _dumpCooldownVar = '_dumpCooldownVar' call _genRandString;
private _lagSwitchTickVar = '_lagSwitchTickVar' call _genRandString;

private _acInitFailedVar = '_acInitFailedVar' call _genRandString;
private _MThreadHijackVar = '_MThreadHijackVar' call _genRandString;
private _DThreadHijackVar = '_DThreadHijackVar' call _genRandString;
private _FThreadHijackVar = '_FThreadHijackVar' call _genRandString;

private _DThreadHeartbeat = '_DThreadHeartbeat' call _genRandString;
private _FThreadHeartbeat = '_FThreadHeartbeat' call _genRandString;

_reasonVar addPublicVariableEventHandler compile("(param [1,[]]) spawn "+str _flagged);

private _clientDataDumpVar = '_clientDataDumpVar' call _genRandString;
_clientDataDumpVar addPublicVariableEventHandler compile("
	(param[1,[],[[]]]) params [
		['_uid','',['']],
		['_scripts',[],[[]]],
		['_displays',[],[[]]]
	];
	private _log = "+str _log+";
	['SERVER',format['Dumping client info: %1',_uid],nil,true] call _log;
	['SERVER',format['%1: Scripts',_uid]] call _log;
	{['SERVER',format['%1 S: %2',_uid,_x]] call _log;} foreach _scripts;
	['SERVER',format['%1: Displays',_uid]] call _log;
	{['SERVER',format['%1 D: %2',_uid,_x]] call _log;} foreach _displays;
	['SERVER',format['Dump complete: %1',_uid]] call _log;
");
private _clientDataDump = "missionNamespace setVariable ['"+_clientDataDumpVar+"',[_this,diag_activeSQFScripts,allDisplays apply {str _x}],2];";

#include "\cau\anticheat\s_duplicatePIDMonitor.sqf"
#include "\cau\anticheat\c_checkPIDCache.sqf"
#include "\cau\anticheat\c_checkFlaggedStatus.sqf"
#include "\cau\anticheat\c_clientExecutionCode.sqf"

#include "\cau\anticheat\c_checkDisplays.sqf"
#include "\cau\anticheat\c_checkFunctions.sqf"
#include "\cau\anticheat\c_checkMisc.sqf"
#include "\cau\anticheat\c_checkClient.sqf"
#include "\cau\anticheat\c_checkPatches.sqf"
#include "\cau\anticheat\c_clientEvents.sqf"
#include "\cau\anticheat\c_checkMaster.sqf"

['SYSTEM','Functions loaded'] call _log;

private _ACC = ("
if isserver exitwith {};
if (isNil 'CAU_AC_START') exitwith {};
CAU_AC_START = nil;
disableSerialization;
"+SET_SCRIPT_NAME+"
"+SET_SCOPE_NAME+"

"+([0,1] call _checkFlaggedStatus)+"
_"+_flagInitQueueVar+" = [];

private _"+_reasonVar+" = [];
call {"+_checkPIDCache+"};
if (getText(configFile >> 'CfgFunctions' >> 'init') != 'A3\functions_f\initFunctions.sqf') then {
	_"+_flagInitQueueVar+" pushback ['ia01',getText(configFile >> 'CfgFunctions' >> 'init')];
};
if !(isClass(missionConfigFile >> 'CfgAntiCheat')) then {
	_"+_flagInitQueueVar+" pushback ['ia02',[count([missionConfigFile,0] call BIS_fnc_returnChildren),(([missionConfigFile,0] call BIS_fnc_returnChildren) apply {configname _x}) call BIS_fnc_sortAlphabetically]];
};

if ((productVersion select 3) > "+str(productVersion select 3)+") exitWith {
	_"+_reasonVar+" = ['ia06',productVersion select [2,2]];
	call _"+_checkFlaggedStatusVar+";
};

if (isClass(configFile >> 'CfgPatches' >> 'jsrs_soundmod_framework') && {
	!(modParams['@JSRS SOUNDMOD',['name']] isequalto [getText(missionConfigFile >> 'CfgAntiCheat' >> 'JSRS_Version')])
}) exitwith {
	_"+_reasonVar+" = ['ia04',modParams['@JSRS SOUNDMOD',['name']]];
	call _"+_checkFlaggedStatusVar+";
};
if (isClass(configFile >> 'CfgPatches' >> 'DiscordRichPresence') && {
	!(modParams['@Discord Rich Presence',['name']] isequalto [getText(missionConfigFile >> 'CfgAntiCheat' >> 'DiscordRichPresence_Version')])
}) exitwith {
	_"+_reasonVar+" = ['ia05',modParams['@Discord Rich Presence',['name']]];
	call _"+_checkFlaggedStatusVar+";
};


call {"+_checkPatches+"};
call {"+_checkDisplayEVHs+"};
call {"+_checkConfigRootSources+"};
private _mnsScannedFunctions = call {"+_checkFunctions_MNSVars+"};
call {"+_checkFunctions_UINSVars+"};
call {"+_checkFunctions_PROFNSVars+"};
call {"+_checkFunctions_PARNSVars+"};
call {"+_checkFunctions_fileDetails+"};
call {"+_checkProfNSVarsSCALAR+"};
call {"+_checkInterruptChildren+"};

"+_MThreadHijackVar+" = 0;
"+_DThreadHijackVar+" = 0;
"+_FThreadHijackVar+" = 0;

"+_lagSwitchTickVar+" = diag_tickTime;

"+_checkFunctions+"
"+_checkDisplays+"
"+_checkMaster+"

{
	"+SET_SCOPE_NAME+"
	_"+_reasonVar+" = _x;
	call _"+_checkFlaggedStatusVar+";
} foreach _"+_flagInitQueueVar+";

"+_clientExecutionExecuted+" = true;
");

_ACC = _ACC call _changeScriptCasing;
['SYSTEM',format['Client monitor code: %1 characters',count _ACC]] call _log;
_HBCC = ['Master',_reasonVar,_rndObjID,_masterThreadVar,_MThreadHijackVar,8,_acInitFailedVar] call _genThreadCheckerIndependent;

_HBCC = _HBCC call _changeScriptCasing;
['SYSTEM',format['Client heartbeat code: %1 characters',count _HBCC]] call _log;

private _nil = false;
{
	if (isNil _x) exitwith {
		['SYSTEM',format['Nil value found: %1',_x]] call _log;
		_nil = true;
	};
}foreach[
// check client
'_lastCashVar','_lastBankVar','_moneyMultiplier','_sessionLoaded','_checkClient','_checkClientInitVariables',
// check displays
'_interruptChildren','_checkInterruptChildren','_checkDisplayEVHs','_badDisplays','_badUIStrings','_checkDisplaysThreadVar','_checkDisplays',
// check functions
'_funcCheckThreadVar','_mnsApprovedSegments','_uinsApprovedSegments','_checkFunctions','_obfuscatedFncTags','_genFncList','_obfuscatedFilePaths','_checkFunctions_UINSVars','_checkFunctions_PROFNSVars','_checkFunctions_PARNSVars','_checkFunctions_fileDetails','_checkFunctions_MNSVars','_checkFunctions_MNSVars_generateCheck',
// check patches
'_patchDev','_patchTmp','_patchProhib','_checkPatches',
// check scroll menu
'_badText','_badCode','_badTextList','_badCodeList','_checkScrollMenu',
// check vars
'_checkVarsThread','_badVarsList','_checkVars',
// check active scripts
'_checkActiveScriptsThread','_badScriptNamesList','_badScriptPathsList','_checkActiveScripts',
// check profns scalar vars
'_uiVarsList','_permittedStrings','_checkProfNSVarsSCALAR',
// check pid cache
'_getPIDCache','_setPIDCache','_checkPIDCache',
// duplicate PID detection & external ban list checks
'_dpPIDWFSListVar','_dpPIDWFSThreadVar','_dpPIDWFSThreadCode','_dpPIDValidate','_dpPIDCacheVar','_dpPIDCheckMainVar',_dpPIDCheckMainVar,'_infBannedTrig','_wskothBannedTrig','_bmBannedTrig','_dpPIDPEVHVar','_dpPIDCheckFailoverVar',_dpPIDCheckFailoverVar,
// misc
'_checkConfigRootSources',
// client events
'_clientEvent_MapTP','_clientEvent_FiredMan','_clientEvent_HandleDamage','_clientEvent_FiredMan_CDV','_clientEvent_FiredMan_LastFiredInfo','_clientEvent_HandleDamage_CDV',
// init
'_genRandString','_genThreadChecker','_genThreadCheckerIndependent','_acInitFailedVar','_rndObjID','_reasonVar','_masterThreadVar','_ACC','_HBCC','_log','_clientExecutionCode','_clientExecutionExecuted','_checkFlaggedStatus','_checkFlaggedStatusVar','_flagInitQueueVar','_dumpCooldownVar','_flagged','_MThreadHijackVar','_DThreadHijackVar','_FThreadHijackVar','_DThreadHeartbeat','_FThreadHeartbeat','_clientDataDumpVar','_clientDataDump'
];
if _nil exitwith {['SYSTEM','Fatal error occurred',nil,true] call _log};

/*[[tostring((toArray _ACC)apply{_x+19}),compile _clientExecutionCode],compile("
    "+_clientExecutionExecuted+" = diag_tickTime;
    _this spawn {"+SET_SCRIPT_NAME+"(_this select 0) call (_this select 1);};
")] remoteExec ['call',-2,true];*/
addMissionEventHandler ["PlayerConnected","
private _owner = _this select 4;
if (_owner < 3) exitwith {};
"+str([
    [tostring((toArray _ACC)apply{_x+19}),compile _clientExecutionCode],
    compile("
    	"+_clientExecutionExecuted+" = diag_tickTime;
    	_this spawn {"+SET_SCRIPT_NAME+"(_this select 0) call (_this select 1);};
	")
])+" remoteExec ['call',_owner];
"];

['SYSTEM','Client execution code broadcast'] call _log;

[_log,_flagged,call compile ("["+str compile _HBCC+",{"+SET_SCRIPT_NAME+"call _this}]"),_lagSwitchTickVar] spawn _serverTasksMasterThread;

['SYSTEM','Server monitor active'] call _log;
['SYSTEM','Initialization complete',nil,true] call _log;

missionNameSpace setVariable ['CAU_AC_RVL',nil];