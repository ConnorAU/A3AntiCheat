/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _getPIDCache = {
private _log = param[0,false,[false]];
("
private _pidCache_defaultCache = [0,[getplayeruid player]];
private _pidCache = profileNamespace getVariable ['bis_account_id_history_caulapgl',_pidCache_defaultCache];
if !(_pidCache isEqualType []) then {
"+(if !_log then {""} else {"
	_"+_reasonVar+" = ['pid01',_pidCache];
	call _"+_checkFlaggedStatusVar+";
"})+"
	_pidCache = _pidCache_defaultCache;
};
private _pidCache_formatCorrect = _pidCache params[
	['_pidCache_prevBanned',0,[0]],
	['_pidCache_prevIDs',[],[[]]]
];
if !_pidCache_formatCorrect then {
"+(if !_log then {""} else {"
	_"+_reasonVar+" = ['pid02',_pidCache];
	call _"+_checkFlaggedStatusVar+";
"})+"
	_pidCache = _pidCache_defaultCache;
};
");
};

private _setPIDCache = "
profileNamespace setVariable ['bis_account_id_history_caulapgl',[_pidCache_prevBanned,_pidCache_prevIDs]];
saveProfileNamespace;
";

private _checkPIDCache = "
"+(true call _getPIDCache)+"
private _pIndex = _pidCache_prevIDs pushBackUnique (getplayeruid player);
private _iPUIDS = profileNamespace getVariable ['PUIDS',[]];
private _iPUIDSA = if !(_iPUIDS isEqualType []) then {[]} else {
	_iPUIDS select {_x isEqualType '' && {count _x == 17 && {!(_x in _pidCache_prevIDs)}}}
};
_pidCache_prevIDs append _iPUIDSA;
missionNamespace setVariable ['"+_dpPIDPEVHVar+"',[clientOwner,name player,getplayeruid player,_pidCache_prevIDs-[getplayeruid player]],2];
if (count _iPUIDSA > 0) then {
	_"+_flagInitQueueVar+" pushback ['pid11',[_iPUIDSA,_pidCache_prevIDs - _iPUIDSA]];
};
"+_setPIDCache+"
if (_pidCache_prevBanned in [1,2]) then {
	if (_pIndex < 0) then {
		if (_pidCache_prevBanned == 2) then {
			_pidCache_prevBanned = 1;
			"+_setPIDCache+"
			_"+_flagInitQueueVar+" pushback ['pid03',_pidCache_prevIDs];
		};
	} else {
		if (_pidCache_prevBanned == 1) then {
			_"+_flagInitQueueVar+" pushback ['pid04',_pidCache_prevIDs];
		} else {
			_"+_flagInitQueueVar+" pushback ['pid05',_pidCache_prevIDs];
		};
	};
} else {
	if (_pIndex > 0) then {
		_"+_flagInitQueueVar+" pushback ['pid06',_pidCache_prevIDs];
	};
};
";