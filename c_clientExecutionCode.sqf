/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _clientExecutionCode = "
if (!isServer && {hasInterface}) then {
    waituntil {
        (missionNamespace getVariable ['CAU_AC_START',false]) && 
        (missionNamespace getVariable ['BIS_fnc_init',false]) && 
        (missionNamespace getVariable ['BIS_fnc_preload_init',false]) && 
        !isNull (findDisplay 46)
    };
    "+_clientExecutionExecuted+" = diag_tickTime;
    for '_i' from 1 to 3 do {uisleep random 0.5};
    isNil compile(tostring((toarray _this)apply{_x-19}));
};
";