/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

#define PARAM_BAD confignull
private _flagged = {
	scriptName "[AntiCheat: Flag Handler]";

	#include "\CAU_AntiCheat\s_log.sqf"

	if !(_this isEqualType []) exitwith {
		['ERROR','PARAMS_NOT_ARRAY',[nil,nil,nil,_this],true] call _log;
	};

	params [
		['_flag',PARAM_BAD,['']],
		['_params',[]],
		['_playerid',PARAM_BAD,['']],
		['_owner',PARAM_BAD,[0]],
		['_name',PARAM_BAD,['']],
		['_clientActions',[],[[]]]
	];

	if (PARAM_BAD in [_flag,_playerid,_owner,_name]) exitwith {
		['ERROR','BAD_PARAMS',[nil,nil,nil,_this],true] call _log;
	};

	_playerid = _this call {
		private _unit = allPlayers select {owner _x == _owner} param [0,objNull];
		if (isNull _unit) then {_playerid} else {
			private _p = getPlayerUID _unit;
			if (count _p == 17 && {_p != _playerid}) then {
				['ERROR','UID_MISMATCH',[nil,nil,nil,[_p,_playerid,_this]],true] call _log;
				_p
			} else {_playerid};
		};
	};

	(switch _flag do {

		// Thread Checker
		case 'tc01':{[['ban'],'Thread terminated']};
		case 'tc02':{[['webhook'],'Thread hijack var nil']};
		case 'tc03';
		case 'tc03d':{[['webhook'],'Thread hijack var exceeded max value']};
		case 'tc03b':{[['ban'],'Thread hijack var exceeded max value']};
		case 'tc04':{[['ban'],'Invalid thread name']};
		case 'tc05':{[['webhook'],'AC init received but failed to complete execution']};
		case 'tc05k':{[['kick'],'AC init received but failed to complete execution']};
		case 'tc06':{[['ban'],'Current thread does not match thread variable']};

		// Init AC
		case 'ia01':{[['ban'],'Modified functions init filepath']};
		case 'ia02':{[['webhook'],'AntiCheat config failed to load']};
		case 'ia03':{[['webhook'],'Active thread attempted overwrite']};
		case 'ia04':{[['webhook'],'JSRS version incompatible']};
		case 'ia05':{[['webhook'],'Discord Rich Presence version incompatible']};
		case 'ia06':{[['webhook'],'Arma 3 client version higher than server']};

		// PID Cache + PID Checks
		case 'pid01':{[['webhook'],'PID cache not an array']};
		case 'pid02':{[['webhook'],'PID cache format incorrect']};
		case 'pid03':{[['webhook'],'Banned a3profile flag removed']};
		//case 'pid13':{[[],'Alt account, a3profile has been used by multiple steamids']};
		case 'pid04':{[['webhook','alertStaff','alertHistory'],'New PID using previously banned a3profile']};
		case 'pid05':{[['ban'],'New PID using banned a3profile']};
		case 'pid06':{[['webhook','alertStaff','alertHistory'],'New PID using registered a3profile']};
		case 'pid11':{[['webhook'],'New PID(s) added from Infistar PID cache']};
		case 'pid07':{[['ban'],'SteamID is infiSTAR global banned']};
		case 'pid12':{[['ban'],'SteamID is WSKOTH global banned']};
		case 'pid08':{[['kick'],'SteamID is BattleMetrics banned for hacking']};
		case 'pid08b':{[['ban'],'SteamID is BattleMetrics banned for hacking']};
		case 'pid14':{[['ban','reason:AltAcc'],'Alt SteamID is BattlEye banned']};
		case 'pid09':{[['kick'],'Queried UID not connected on RCon']};
		case 'pid10':{[['kick'],'Player info mismatch']};

		// Patches
		case 'patch01':{[['ban'],'Unknown addon patch detected']};
		case 'patch02J';
		case 'patch02':{[['webhook'],'Incorrect addon patch source']};
		case 'patch02R':{[['webhook'],'Empty addon patch source']};
		case 'patch03':{[['ban'],'Addon patch source not found']};
		case 'patch04':{[['webhook'],'Prohibited addon patch detected']};

		// Display EVHs
		case 'deh01':{[['ban'],'Modified Display Eventhandler']};

		// ProfNS Scalar
		case 'pnsvs01':{[[],'PROFNS corrected non-scalar value']};
		case 'pnsvs02':{[['ban'],'PROFNS expecting SCALAR value']};

		// Interrupt Children
		case 'eichld01':{[['ban'],'Modified MPInterrupt Display']};

		// Function Thread
		case 'ft01':{[['ban'],'Unknown code variable detected']};
		case 'ft02':{[['webhook'],'Variable cache not loaded']};
		case 'ft03':{[['ban'],'Filepath mismatch']};
		case 'ft04':{[['ban'],'File character count mismatch']};
		case 'ft05':{[['ban'],'Unknown function source addon']};
		case 'ft06':{[['ban'],'Unknown function source mod']};
		case 'ft07':{[['ban'],'Function cache config not found']};
		case 'ft08':{[['ban'],'Unknown function class']};

		// Display Thread
		case 'dt01':{[['webhook'],'Blacklisted display detected']};
		case 'dt02':{[['ban'],'Modified Display']};
		case 'dt03':{[['ban'],'Dynamic text display']};
		case 'dt04':{[['webhook'],'Escape menu overlap']};
		case 'dt05':{[['ban'],'Blacklisted variable found in UI']};
		case 'dt06':{[['ban'],'EVH ID did not return expected value']};
		case 'dt07':{[['ban'],'Map display has unexpected number of controls']};

		// Client
		case 'cc01':{[['ban'],'Money variable is nil']};
		case 'cc02':{[['ban'],'Money variable not a number']};
		case 'cc03':{[['ban'],'Money monitor is nil']};
		case 'cc04':{[['ban'],'Money monitor not an array']};
		case 'cc05':{[['ban'],'Unauthorised money modification']};
		case 'cc06':{[['webhook'],'Incorrect money modification']};
		case 'cc07':{[['ban'],'Get all licenses hack']};
		case 'cc08':{[['webhook'],'Carryweight below zero']};
		case 'cc09':{[['ban'],'Local cash pile detected']};
		case 'cc10':{[['webhook'],'Unregistered dropped item detected']};
		case 'cc11':{[['webhook','alertStaff'],'Duplicate uniform detected']};
		case 'cc12':{[['webhook','alertStaff'],'Duplicate vest detected']};
		case 'cc13':{[['webhook','alertStaff'],'Duplicate backpack detected']};
		case 'cc14':{[['ban'],'No recoil hacks']};
		case 'cc15':{[['ban'],'No sway hacks']};
		case 'cc16':{[['ban'],'Speed hacks']};
		case 'cc17':{[['webhook'],'Camera is not on player']};
		case 'cc18':{[['ban'],'EVH ID did not return expected value']};
		case 'cc19':{[['ban'],'Filepatching enabled on client']};
		case 'cc20':{[['webhook'],'Active scheduled scripts count exceeded max value']};

		// Scroll Menu
		case 'sm01':{[['ban'],'Blacklisted text detected in addAction']};
		case 'sm02':{[['ban'],'Blacklisted code detected in addAction']};

		// Blacklisted Variables
		case 'cv01':{[['ban'],'Blacklisted variable detected']};

		// Config source lists
		case 'csl01':{[['ban'],'Config class does not exist in cache']};
		case 'csl02':{[['webhook'],'Config class inherited an unknown addon']};
		case 'csl03':{[['webhook'],'Config class inherited an unknown mod']};

		// Active Scripts
		case 'as01':{[['ban'],'Active script running with blacklisted name']};
		case 'as02':{[['ban'],'Active script running from blacklisted path']};

		// Spawn Vehicle
		case 'sv01':{[['webhook'],'Bad vehicle class spawned']};

		// Client Events
		case 'cefm01w':{[['webhook'],'Fired weapon does not match current weapon']};
		case 'cefm01m':{[['webhook'],'Fired muzzle does not match current muzzle']};
		case 'cefm02':{[['webhook'],'Abnormal bullet speed']};
		case 'cefm03':{[['webhook'],'Weapon fired but ammo remains at or above max capacity']};
		case 'cefm04':{[['webhook'],'Bullet reload speed is faster than config value']};
		case 'cefm05':{[['webhook'],'Weapon ammo increased and fired faster than reload speed']};
		case 'cehd01':{[['webhook'],'Bullet hit position not visible to shooter']};
		case 'cemtp01':{[['ban'],'Map teleported']};

		// Item Dupe Monitor
		case 'idm01':{[['webhook'],'Uncached container interaction']};
		case 'idm02':{[
			if ([_params param [1,'',['']],'Supply'] call life_fnc_stringStartsWith) then
			{[]} else {['webhook']},
			'Possible item duplication'
		]};

		// Lag Switch
		case 'ls01':{[[],'Network connection temporarily lost']};

		default {[]};
	}) params [
		['_actions',PARAM_BAD],
		['_info',PARAM_BAD]
	];

	if (PARAM_BAD in [_actions,_info]) exitwith {
		['ERROR','UNK_FLAG',[nil,nil,nil,_this],true] call _log;
	};

	if ('ban' in _actions) then {
		_actions pushBack 'webhook';
		private _banned = (call CAU_isDevServer) OR {
			(diag_tickTime < (missionNamespace getVariable ['CAU_AC_FLAG_BANNED_'+_playerid,-1])) OR {
				missionNamespace setVariable ['CAU_AC_FLAG_BANNED_'+_playerid,diag_tickTime + 15];
				life_ext_cau_utilities_loaded && {
					([true,'AddBattleMetricsBan',[
						["reason:AltAcc" in _actions] call {
							["AntiCheatAltBan"] param [_this find true,'AntiCheatHackBan']
						},
						'BM_API_SID',
						_playerid,
						(missionNamespace getVariable ['CAU_AC_USER_ALT_PIDS_'+_playerid,[]]) joinstring ':'
					]] call CAU_s_command_extUtilities) param [2,false,[true]]
				};
			}
		};
		if _banned then {
			_actions pushBack 'kick';
		} else {
			_actions pushBack 'banA3';
			_actions = _actions - ['ban'];
		};
	};
	if !(call CAU_isDevServer) then {
		if ('banA3' in _actions) then {
			gettext(configFile >> 'CfgServerSettings' >> 'theReallyImportantString') serverCommand format["#exec ban '%1'",_owner];
		};
		if ('kick' in _actions) then {
			_actions pushBack 'webhook';
			gettext(configFile >> 'CfgServerSettings' >> 'theReallyImportantString') serverCommand format["#kick '%1'",_owner];
		};
	};
	['CLIENT',_info,[_name,_playerid,_actions,_params,_clientActions],'webhook' in _actions] call _log;
	if ('alertStaff' in _actions) then {
		["useTemplate",["AntiCheat",[],[_name,_playerid,_info]]] remoteExecCall ["CAU_c_system_notifications",-2];
	};
	if ('alertHistory' in _actions) then {
		["addAdminMsg",["__SERVER__","Anticheat Trigger",format[[
			"ANTICHEAT WARNING",
			"Name: %1",
			"PID: %2",
			"",
			"Report:",
			"%3",
			"",
			"If you are unsure about this message, please contact Connor ASAP."
		]joinString endl,_name,_playerid,_info]],"Server Anticheat"] call life_fnc_handleMsgHistory;
	};
};
