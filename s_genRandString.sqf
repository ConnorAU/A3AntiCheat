/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _genRandString = {
	private _b = {(["REDONE"] findIf {[_x,_v] call BIS_fnc_inString}) > -1};
	private _v = [];
	private _l = "abcdefghijklmnoprstuvwxyz";
	private _n = "";//0123456789
	private _c = ((toupper _l) + _l + _n) splitString '';
	_v resize (random 17 max 12);
	_v = _v apply {selectRandom _c} joinString '';
	if (_v in CAU_AC_RVL OR {!isNil _v OR {call _b}}) exitwith {call _genRandString};
	CAU_AC_RVL pushback _v;
	if (["development",servername] call BIS_fnc_inString) then {
		['SYSTEM',format["%1 = _%2",_this,_v]] call _log;
	};
	_v
};