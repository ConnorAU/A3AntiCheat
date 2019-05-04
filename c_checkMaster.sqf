/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _checkMaster = "
if (!isNil '"+_masterThreadVar+"') then {
	_"+_flagInitQueueVar+" pushback ['ia03','Master'];
} else {
_"+_DThreadHeartbeat+" = {"+(['Display',_reasonVar,_rndObjID,_checkDisplaysThreadVar,_DThreadHijackVar,4] call _genThreadChecker)+"};
_"+_FThreadHeartbeat+" = {"+(['Function',_reasonVar,_rndObjID,_funcCheckThreadVar,_FThreadHijackVar,4] call _genThreadChecker)+"};

"+_clientEvent_MapTP+"
"+_clientEvent_FiredMan+"
"+_clientEvent_HandleDamage+"
"+_clientEvent_Take+"

"+_masterThreadVar+" = [[_"+_checkFlaggedStatusVar+",_"+_DThreadHeartbeat+",_"+_FThreadHeartbeat+"],{
	params ['_"+_checkFlaggedStatusVar+"','_"+_DThreadHeartbeat+"','_"+_FThreadHeartbeat+"'];

	private _"+_checkVarsThread+" = scriptNull;
	private _"+_checkActiveScriptsThread+" = scriptNull;
	private _"+_lagSwitchTickVar+" = 0;

	"+_checkClientInitVariables+"

	while {true} do {
		"+SET_SCOPE_NAME+"
		_"+_reasonVar+" = [];
		"+_MThreadHijackVar+" = 0;

		if !("+_masterThreadVar+" isequalto _thisScript) then {
			_"+_reasonVar+" = ['tc06',['Master',str "+_masterThreadVar+"]];
			call _"+_checkFlaggedStatusVar+";
			terminate "+_masterThreadVar+";
			"+_masterThreadVar+" = _thisScript;
		};

		if (!isNil '"+_infBannedTrig+"') then {
			_"+_reasonVar+" = ['pid07',"+_infBannedTrig+"];
			call _"+_checkFlaggedStatusVar+";
		};
		if (!isNil '"+_wskothBannedTrig+"') then {
			_"+_reasonVar+" = ['pid12',"+_wskothBannedTrig+"];
			call _"+_checkFlaggedStatusVar+";
		};
		if (!isNil '"+_bmBannedTrig+"') then {
			_"+_reasonVar+" = ['pid08',"+_bmBannedTrig+"];
			if ("+_bmBannedTrig+" != (getPlayerUID player)) then {
				_"+_reasonVar+" set [0,'pid08b'];
			};
			call _"+_checkFlaggedStatusVar+";
		};
		if (!isNil '"+_beBannedTrig+"') then {
			_"+_reasonVar+" = ['pid14',"+_beBannedTrig+"];
			call _"+_checkFlaggedStatusVar+";
		};

		if isFilePatchingEnabled then {
			_"+_reasonVar+" = ['cc19'];
			call _"+_checkFlaggedStatusVar+";
		};


		call _"+_DThreadHeartbeat+";
		call _"+_FThreadHeartbeat+";

		"+_checkClient+"
		"+_checkScrollMenu+"
		"+_checkVars+"
		"+_checkActiveScripts+"

		call _"+_checkFlaggedStatusVar+";

		uisleep (random 0.7 max 0.5);
	};
}] spawn {
	"+SET_SCRIPT_NAME+"
	(_this select 0) call (_this select 1);
};

(objectFromNetId "+str _rndObjID+") setVariable ["+str _masterThreadVar+","+_masterThreadVar+"];
};
";
/*
		if ((diag_tickTime - "+_lagSwitchTickVar+") < 8) then {
			if (_"+_lagSwitchTickVar+" > 0) then {
				_"+_reasonVar+" = ['ls01',_"+_lagSwitchTickVar+"];
				call _"+_checkFlaggedStatusVar+";
				_"+_lagSwitchTickVar+" = 0;
			};
		} else {
			_"+_lagSwitchTickVar+" = diag_tickTime - "+_lagSwitchTickVar+";
		};*/