/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _genThreadChecker = {
params ['_threadType','_reasonVar','_objID','_threadVar','_hijackVar','_hijackValueMax'];
("
if (!isNil "+str _threadVar+" && {"+_threadVar+" isEqualType scriptNull}) then {
	if (isNull "+_threadVar+") then {
		_"+_reasonVar+" = ['tc01','"+_threadType+"'];
	} else {
		if !(['Unsuspicious Thread Name',str "+_threadVar+"] call BIS_fnc_inString) then {
			(getplayeruid player) call {"+_clientDataDump+"};
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
			(getplayeruid player) call {"+_clientDataDump+"};
			_"+_reasonVar+" = ['tc04',['"+_threadType+"',"+_threadVar+"]];
		};
	};
};
call _"+_checkFlaggedStatusVar+";
" + (if (count _hijackVar == 0) then {""} else {"
if (isNil "+(str _hijackVar)+") then {
	_"+_reasonVar+" = ['tc02','"+_threadType+"'];
	"+_hijackVar+" = 1;
} else {
	if ("+_hijackVar+" >= "+(str _hijackValueMax)+") then {
		_"+_reasonVar+" = ['tc03',['"+_threadType+"',"+_hijackVar+",round diag_fps,getpos player]];
	};
	"+_hijackVar+" = "+_hijackVar+" + 1;
};
call _"+_checkFlaggedStatusVar+";
"}));
};