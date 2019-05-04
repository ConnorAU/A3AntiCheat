/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _genThreadCheckerIndependent = {
params ['_threadType','_reasonVar','_objID','_threadVar','_hijackVar','_hijackValueMax','_acInitFailedVar'];
"
if (isNil '"+_clientExecutionExecuted+"') exitwith {"+_clientExecutionExecuted+" = diag_tickTime;};
_"+_reasonVar+" = [];
"+([1] call _checkFlaggedStatus)+"
if ("+_clientExecutionExecuted+" isequaltype 0) exitwith {
	private _e = diag_tickTime - "+_clientExecutionExecuted+";
	if (_e >= 60) then {
		_info = [_e,getposatl player,diag_fps,[
			!isNull(findDisplay 46),
			missionNameSpace getvariable ['CAU_mission_functions_ready',false]
		],missionNameSpace getVariable ['CAU_setup_loadingScreenData',[1]]];
		_"+_reasonVar+" = ['tc05k',_info];
		if (isNil '"+_acInitFailedVar+"' && ((_info select 2) < 10 OR (_info select 3 select 0))) then {
			_"+_reasonVar+" set [0,'tc05'];
			"+_acInitFailedVar+" = true;
		};
		call _"+_checkFlaggedStatusVar+";
	};
};
disableSerialization;
if (!isNil "+str _threadVar+" && {"+_threadVar+" isEqualType scriptNull}) then {
	if (isNull "+_threadVar+") then {
		_"+_reasonVar+" = ['tc01','"+_threadType+"'];
	} else {
		if !(['Unsuspicious Thread Name',str "+_threadVar+"] call BIS_fnc_inString) then {
			_"+_reasonVar+" = ['tc04',['"+_threadType+"',"+_threadVar+"]];
		};
	};
} else {
	private _o = objectFromNetId "+str _objID+";
	private _s = _o getVariable ["+str _threadVar+",scriptNull];
	if (isNull _s) then {
		_"+_reasonVar+" = ['tc01','"+_threadType+"'];
	} else {
		"+_threadVar+" = _s;
		if !(['Unsuspicious Thread Name',str "+_threadVar+"] call BIS_fnc_inString) then {
			_"+_reasonVar+" = ['tc04',['"+_threadType+"',"+_threadVar+"]];
		};
	};
};
call _"+_checkFlaggedStatusVar+";
if (isNil "+(str _hijackVar)+") then {
	_"+_reasonVar+" = ['tc02','"+_threadType+"'];
	"+_hijackVar+" = 1;
} else {
	if ("+_hijackVar+" >= "+(str _hijackValueMax)+") then {
		_"+_reasonVar+" = ['tc03',['"+_threadType+"',"+_hijackVar+",round diag_fps,getpos player]];
		if ("+_hijackVar+" == "+(str _hijackValueMax)+") then {
			_"+_reasonVar+" set [0,'tc03d'];
		};
		if (diag_fps > 10 && "+_hijackVar+" >= 12) then {
			_"+_reasonVar+" set [0,'tc03b'];
		};
	};
	"+_hijackVar+" = "+_hijackVar+" + 1;
};
call _"+_checkFlaggedStatusVar+";
";
};