/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _checkFlaggedStatus = {
private _triggers = +_this;
private _allTriggs = -1 in _triggers;
private _canAdd = {_allTriggs OR {_this in _triggers}};
("private _"+_checkFlaggedStatusVar+" = {
	if (count _"+_reasonVar+" > 0) then {
		if !((_"+_reasonVar+" param [1,[]]) isEqualType '') then {
			_"+_reasonVar+" set [1,str(_"+_reasonVar+" param [1,[]])];
		};
		private _actions = "+(if (_triggers isEqualTo []) then {"[]"} else {"
			switch (_"+_reasonVar+" select 0) do {

			"+(["","
			case 'tc01':{['ban']};
			case 'tc03b':{['ban']};
			case 'tc03d':{['dump']};
			case 'tc04':{['ban']};
			case 'tc05';
			case 'tc05k':{['kick','dump']};
			case 'tc06':{['ban']};
			"] select (1 call _canAdd))+"

			"+(["","
			case 'cemtp01':{['ban']};
			"] select (2 call _canAdd))+"

			"+(["","

			case 'ia01':{['ban']};
			case 'ia02':{['kick']};
			case 'ia04':{['kick','reason:jsrs_version']};
			case 'ia05':{['kick','reason:discordrichpresence_version']};
			case 'ia06':{['kick']};

			case 'pid05':{['ban']};
			case 'pid07':{['ban']};
			case 'pid08':{['kick']};
			case 'pid12':{['ban']};
			case 'pid14':{['kick']};

			case 'patch01':{['ban']};
			case 'patch02':{['kick']};
			case 'patch02J':{['kick','reason:jsrs_bad_install']};
			case 'patch02R':{['kick','reason:restart']};
			case 'patch03':{['ban']};

			case 'deh01':{['ban']};

			case 'pnsvs02':{['ban']};

			case 'eichld01':{['ban']};

			case 'ft01':{['ban']};
			case 'ft02':{['kick']};
			case 'ft03':{['ban']};
			case 'ft04':{['ban']};
			case 'ft05':{['ban']};
			case 'ft06':{['ban']};
			case 'ft07':{['ban']};
			case 'ft08':{['ban']};

			case 'dt02':{['ban']};
			case 'dt03':{['ban']};
			case 'dt05':{['ban']};
			case 'dt06':{['ban']};
			case 'dt07':{['ban']};

			case 'cc01':{['ban']};
			case 'cc02':{['ban']};
			case 'cc03':{['ban']};
			case 'cc04':{['ban']};
			case 'cc05':{['ban']};
			case 'cc07':{['ban']};
			case 'cc09':{['ban']};
			case 'cc14':{['ban']};
			case 'cc15':{['ban']};
			case 'cc16':{['ban']};
			case 'cc18':{['ban']};
			case 'cc19':{['ban']};
			case 'cc20':{['dump']};

			case 'sm01':{['ban']};
			case 'sm02':{['ban']};

			case 'cv01':{['ban']};

			case 'csl01':{['ban']};

			case 'as01':{['ban']};
			case 'as02':{['ban']};

			"] select (0 call _canAdd))+"

			default {[]};
		}"})+";
		missionNamespace setVariable ["+str _reasonVar+",_"+_reasonVar+" + [getplayeruid player,clientOwner,profileName,_actions],2];
		"+(if (_triggers isEqualTo []) then {"_"+_reasonVar+" = [];"} else {"
		if ('log' in _actions) then {
			diag_log text (['ConnorAC:',_"+_reasonVar+",[getClientState,isMultiplayer,isMultiplayerSolo,serverTime,time]] joinstring '');
		};
		_"+_reasonVar+" = [];
		if ('dump' in _actions OR {'ban' in _actions}) then {
			if (diag_tickTime > (missionNamespace getVariable ['"+_dumpCooldownVar+"',-1])) then {
				(getplayeruid player) call {"+_clientDataDump+"};
				missionNamespace setVariable ['"+_dumpCooldownVar+"',diag_ticktime + 5];
			};
		};
		if ('kick' in _actions OR {'ban' in _actions}) then {
			[
				'reason:jsrs_version' in _actions,
				'reason:jsrs_bad_install' in _actions,
				'reason:discordrichpresence_version' in _actions,
				'reason:restart' in _actions
			] spawn {
				"+SET_SCRIPT_NAME+"
				[] call BIS_fnc_forceEnd;
				private _reason = [
					'CAU_AC_JSRSBadVersion',
					'CAU_AC_JSRSBadInstall',
					'CAU_AC_DiscordRichPresenceBadVersion',
					'CAU_AC_RestartRequired'
				] param [_this find true,'CAU_AC_Triggered'];
				while {true} do {
					endMission _reason;
					failMission _reason;
				};
			};
		};
		if ('ban' in _actions && {!(call CAU_isDevServer)}) then {
			"+(false call _getPIDCache)+"
			_pidCache_prevBanned = 2;
			"+_setPIDCache+"
			disableSerialization;
			{_x closeDisplay 0} forEach allDisplays;
			breakTo 'Unsuspicious Thread Name';
		};
		"})+"
	};
};
");
};
