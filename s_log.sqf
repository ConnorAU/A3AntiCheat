/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _log = {
params [
	['_type','',['']],
	['_reason','',['']],
	['_pInfo',[],[[]]],
	['_sendViaWebhook',false,[true]]
];
_pInfo params [
	['_name',-1,['']],
	['_uid',-1,['']],
	['_actions',[],[[]]],
	['_params',[]],
	['_clientActions',[],[[]]]
];

/*
b	-	Ban
	↳	A3	-	Arma 3 (Single server ban)
	↳	BM	-	BattleMetrics (All Servers)
	↳	C 	-	Client profile was marked as banned, but no ban was placed

k	-	Kick
	↳	S 	-	Server (kicked from the server)
	↳	L	-	Lobby (kicked to lobby)

l 	- 	Logged
 */
_actions = switch true do {
	case ('banA3' in _actions):{'b.A3'};
	case ('ban' in _actions):{'b.BM'};
	case ('kick' in _actions):{'k.S'};
	case ('ban' in _clientActions):{'b.C'};
	case ('kick' in _clientActions):{'k.L'};
	default {'l'};
};

_reason = [_reason,if (
    !(_params isEqualTypeAny [[],'']) OR
    ((_params isEqualType []) && {count _params > 0}) OR 
    ((_params isEqualType '') && {_params != '[]'})
) then {[': ',_params] joinString ''} else {''}] joinString '';
private _log = text ([
	"[AntiCheat][",_type,"]",
	if (-1 in [_name,_uid]) then {''} else {'['+([_actions,_name,_uid] joinString ',')+']'},
	' ',_reason
] joinstring '');

diag_log _log;
[false,"AntiCheatLog",[_log]] call CAU_s_command_extUtilities;
if _sendViaWebhook then {
	['anticheat_d',_log] call CAU_s_command_sendWebhook;
};
_reason
};