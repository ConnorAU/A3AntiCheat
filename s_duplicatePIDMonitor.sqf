/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _dpPIDIsServerOnline = "
private _apiRET = [true,'GetServerStatus',['BM_API_SID']] call CAU_s_command_extUtilities;
 _apiRET param [2,false,[true]];
";

private _dpPIDWFSListVar = '_dpPIDWFSListVar' call _genRandString;
private _dpPIDWFSThreadVar = '_dpPIDWFSThreadVar' call _genRandString;
private _dpPIDWFSThreadCode = "
scriptName '[AntiCheat: Duplicate PID WFS Thread]';
private _log = "+str _log+";
['SERVER','Battlemetrics lost connection to the server',nil,true] call _log;
"+_dpPIDWFSListVar+" = [];

for '_i' from 0 to 1 step 0 do {
	if ([] call "+(str compile _dpPIDIsServerOnline)+") exitwith {};
	uisleep 5;
};

['SERVER','Battlemetrics reestablished connection with the server',nil,true] call _log;
_tmp = +"+_dpPIDWFSListVar+";
"+_dpPIDWFSListVar+" = nil;
"+_dpPIDWFSThreadVar+" = nil;
{
	_x params ['','','','_cOwner','','','_code'];
	if (({alive _x && {owner _x == _cOwner}}count allPlayers)>0) then {
		_x call _code;
	} else {
		['SERVER',format['Owner unit not found, skipping pid validation %1',_x select [0,3]]] call _log;
	};
} foreach _tmp;
";

private _dpPIDValidate = "
scriptName '[AntiCheat: Duplicate PID Validator]';
if !(isNil 'CAU_AC_validatePID_skipBMAPIChecks') exitwith {};
params [
	['_qOwner',0,[0]],
	['_qName','',['']],
	['_qUID','',['']],
	['_cOwner',0,[0]],
	['_cName','',['']],
	['_cUID','',['']],
	['_thisCode',{},[{}]]
];
private _log = "+str _log+";
if ([] call "+(str compile _dpPIDIsServerOnline)+") then {
	['SERVER',format['Requesting data from battlemetrics %1',[_cUID,_cName]]] call _log;
	private _apiRET = [true,'GetPlayerInfo',['BM_API_SID',_cUID]] call CAU_s_command_extUtilities;
	switch true do {
		case ((_apiRET select 0) == -1):{
			['SERVER',format['Duplicate PID query did not expect a return %1',[1,_cUID,_cName,_apiRET]],nil,true] call _log;
		};
		case ((_apiRET select 0) == -2):{
			['SERVER',format['Duplicate PID query failed to add to queue %1',[1,_cUID,_cName,_apiRET]],nil,true] call _log;
		};
		case ((_apiRET select 0) == -3):{
			['SERVER',format['Error sending query to battlemetrics %1',[1,_cUID,_cName,_apiRET]],nil,true] call _log;
		};
		case ((_apiRET select 0) == -4):{
			['SERVER',format['Error sending query to battlemetrics %1',[2,_cUID,_cName,_apiRET]],nil,true] call _log;
		};
		case ((_apiRET select 0) == 1):{
			comment '[player id, battlemetrics id, name, is on server, last online, guid]';
			['SERVER',format['Data received from battlemetrics %1',_apiRET]] call _log;
			(_apiRET param [2,[],[[]]]) params [
				'','','',
				['_rOnline',0,[true]]
			];
			if (({alive _x && {owner _x == _cOwner}}count allPlayers)>0) then {
				if (_rOnline isEqualType true) then {
					if !_rOnline then {
						CAU_anticheat_manual_trigger pushback ['pid09',[_qName,_qUID,_cUID],_cUID,_qOwner,_cName];
					};
				} else {
					['SERVER',format['BattleMetrics error querying UID:  %1',[_cUID,_cName,_apiRET]],nil,true] call _log;
				};
			};
		};
	};
} else {
	if (isNil "+(str _dpPIDWFSThreadVar)+") then {
		"+_dpPIDWFSThreadVar+" = [] spawn "+(str compile _dpPIDWFSThreadCode)+";
	};
	waituntil {!(isNil "+(str _dpPIDWFSListVar)+")};
	"+_dpPIDWFSListVar+" pushback _this;
	['SERVER',format['PID validation data added to the queue %1',_this select [0,3]]] call _log;
};
";
/*
				if (_qName != _rName) then {
					[
						format['Name mismatch detected %1',[_qName,_rName,_qUID]],
						true,
						_qOwner,
						_qUID
					] call "+(str compile _dpPIDTakeAction)+";
				};
 */
private _dpPIDCacheVar = '_dpPIDCacheVar' call _genRandString;
private _infBannedTrig = '_infBannedTrig' call _genRandString;
private _wskothBannedTrig = '_wskothBannedTrig' call _genRandString;
private _bmBannedTrig = '_bmBannedTrig' call _genRandString;
private _beBannedTrig = '_beBannedTrig' call _genRandString;
private _dpPIDCheckMainVar = '_dpPIDCheckMainVar' call _genRandString;
missionnamespace setvariable [_dpPIDCheckMainVar,compileFinal("
	scopeName 'CAU_AC_validatePID';
	scriptName 'CAU_AC_validatePID';
	params [
		['_qOwner',0,[0]],
		['_qName','',['']],
		['_qUID','',['']],
		['_altIDs',[],[[]]]
	];
	private _log = "+str _log+";
	private _cVar = "+(str _dpPIDCacheVar)+"+'_'+(str _qOwner);
	if (isNil {missionNamespace getVariable _cVar}) exitwith {
		['SERVER',format['Data cache doesn''t exist %1',[_qOwner,_qName,_qUID]],nil,true] call _log;
		if (_qOwner > 2) then {
			[[],{endMission 'genericError'}] remoteExec ['call',_qOwner];
		};
	};
	(missionNamespace getVariable [_cVar,[]]) params [
		['_cOwner',0,[0]],
		['_cName','',['']],
		['_cUID','',['']]
	];
	missionNamespace setVariable [_cVar,nil];

	missionNamespace setVariable ['CAU_AC_USER_ALT_PIDS_'+_cUID,_altIDs];

	if ([_qOwner,_qName,_qUID] isequalto [_cOwner,_cName,_cUID]) then {
		if life_ext_cau_utilities_loaded then {
			{
				_x params [
					['_pid','',['']],
					['_infistarBanned',false,[true]],
					['_wskothBanned',false,[true]],
					['_battlemetricsBanned',false,[true]],
					['_battleyeBanned',false,[true]]
				];
				['SERVER',format['SteamID ban check results: %1',[_cName,_cUID,_x]]] call _log;
				if _infistarBanned then {
					private _infistarBanExcused = ['checkInfistarBanIgnored:'+_pid,2] call DB_fnc_asyncCall;
					if ((_infistarBanExcused param [0,0,[0]]) isEqualTo 0) then {
						missionNamespace setVariable ['"+_infBannedTrig+"',_pid,_cOwner];
						breakOut 'CAU_AC_validatePID';
					} else {
						['SERVER',format['SteamID is Infistar banned but ignored: %1',[_pid,_cName,_cUID]]] call _log;
					};
				};
				if _wskothBanned then {
					private _wskothBanExcused = ['checkWSKOTHBanIgnored:'+_pid,2] call DB_fnc_asyncCall;
					if ((_wskothBanExcused param [0,0,[0]]) isEqualTo 0) then {
						missionNamespace setVariable ['"+_wskothBannedTrig+"',_pid,_cOwner];
						breakOut 'CAU_AC_validatePID';
					} else {
						['SERVER',format['SteamID is WSKOTH banned but ignored: %1',[_pid,_cName,_cUID]]] call _log;
					};
				};
				if _battlemetricsBanned then {
					missionNamespace setVariable ['"+_bmBannedTrig+"',_pid,_cOwner];
					breakOut 'CAU_AC_validatePID';
				};
				if (_forEachIndex > 0) then {
					if _battleyeBanned then {
						missionNamespace setVariable ['"+_beBannedTrig+"',_pid,_cOwner];
						breakOut 'CAU_AC_validatePID';
					};
				};
			} foreach (([true,'CheckExternalBans',[([_cUID]+_altIDs) joinstring ':']] call CAU_s_command_extUtilities)param[2,[],[[]]]);
			missionNamespace setVariable ['CAU_AC_PID_CHECKS_COMPLETE',true,_cOwner];
			if (isNil 'CAU_AC_validatePID_skipBMAPIChecks') then {
				[_qOwner,_qName,_qUID,_cOwner,_cName,_cUID,"+(str compile _dpPIDValidate)+"] spawn "+(str compile _dpPIDValidate)+";
			};
		};
	} else {
		CAU_anticheat_manual_trigger pushback ['pid10',[[_qOwner,_qName,_qUID],[_cOwner,_cName,_cUID]],_cUID,_cOwner,_cName];
	};
")];
CAU_AC_validatePID_skipBMAPIChecks = true;


private _dpPIDPEVHVar = '_dpPIDPEVHVar' call _genRandString;
_dpPIDPEVHVar addPublicVariableEventHandler compile("(_this param [1,[]]) spawn "+_dpPIDCheckMainVar);

private _dpPIDCheckFailoverVar = '_dpPIDCheckFailoverVar' call _genRandString;
missionnamespace setvariable [_dpPIDCheckFailoverVar,compileFinal("
	scopeName 'CAU_AC_validatePID';
	scriptName 'CAU_AC_validatePID (Failover)';
	params [
		['_owner',0,[0]],
		['_name','',['']],
		['_uid','',['']]
	];

	private _log = "+str _log+";
	private _flagged = "+str _flagged+";
	private _doFlag = {[_this,_uid + ' (Failover)',_uid,_owner,_name,[]] spawn _flagged;};

	if life_ext_cau_utilities_loaded then {
		['SERVER',format['OPC failover global ban check: %1',_uid]] call _log;
		private _ret = ([true,'CheckExternalBans',[_uid]] call CAU_s_command_extUtilities) param[2,[],[[]]] param [0,[],[[]]];

		if (true in _ret) then {
			['SERVER',format['OPC failover found global ban: %1',_ret]] call _log;
			_ret params ['',
				['_infistarBanned',false,[true]],
				['_wskothBanned',false,[true]],
				['_battlemetricsBanned',false,[true]]
			];

			private _preKickTasks = {
				uisleep 27;
				if (isNull(['uid',[_uid]] call life_fnc_getUnitFromPID)) then {
					breakOut 'CAU_AC_validatePID';
				};
				['SERVER',format['OPC failover enforcing global ban: %1',_uid]] call _log;

				[_uid,{"+_clientDataDump+"}] remoteExec ['call',_owner];

				uisleep 3;
				if (isNull(['uid',[_uid]] call life_fnc_getUnitFromPID)) then {
					breakOut 'CAU_AC_validatePID';
				};
			};

			if _infistarBanned then {
				private _infistarBanExcused = ['checkInfistarBanIgnored:'+_uid,2] call DB_fnc_asyncCall;
				if ((_infistarBanExcused param [0,0,[0]]) isEqualTo 0) then {
					call _preKickTasks;
					'pid07' call _doFlag;
					breakOut 'CAU_AC_validatePID';
				};
			};
			if _wskothBanned then {
				private _wskothBanExcused = ['checkWSKOTHBanIgnored:'+_uid,2] call DB_fnc_asyncCall;
				if ((_wskothBanExcused param [0,0,[0]]) isEqualTo 0) then {
					call _preKickTasks;
					'pid12' call _doFlag;
					breakOut 'CAU_AC_validatePID';
				};
			};
			if _battlemetricsBanned then {
				call _preKickTasks;
				'pid08' call _doFlag;
				breakOut 'CAU_AC_validatePID';
			};
		};
		['SERVER',format['OPC failover finished: %1',_uid]] call _log;
	};
")];

addMissionEventHandler ['PlayerConnected',"
params ['_id','_uid','_name','_jip','_owner'];
if (_owner < 3) exitwith {};
private _log = "+(str _log)+";

missionNamespace setVariable ['"+_dpPIDCacheVar+"_'+(str _owner),[_owner,_name,_uid]];
['SERVER',format['Caching info for player data query %1',[_owner,_name,_uid]]] call _log;
[_owner,_name,_uid] spawn "+_dpPIDCheckFailoverVar+";

private _v = '"+_dpPIDCacheVar+"_'+(str _owner)+'_reCheck';
private _t = diag_ticktime;
missionNameSpace setVariable [_v,_t];
[_v,{
	missionNamespace setVariable [_this,[diag_fps,getClientState,productVersion],2];
}] remoteExec ['call',_owner];
[
	'add',
	[
		[_v,_t,_owner,_uid,_log],
		{
			['remove',[_thisEventhandler]] call CAU_c_system_perFrameHandler;
			params ['_v','_t','_o','_u','_log'];
			private _g = missionNamespace getVariable [_v,[]];
			missionNamespace setVariable [_v,nil];
			if (_g isEqualType 0 && {_g != _t}) exitWith {};
			_g params [['_f','nil'],['_c','nil'],['_p','nil']];
			['SERVER',format['RemoteExec response: %1',[_o,_u,diag_tickTime - _t,_f,_c,_p]]] call _log;
		},
		0,
		{
			params ['_v','_t'];
			!((missionNamespace getVariable [_v,0]) isEqualTo _t) || (diag_tickTime - _t) > 300
		},
		true,
		false
	]
] call CAU_c_system_perFrameHandler;
"];