/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _serverTasksMasterThread = {
    scriptName "[AntiCheat: Server Tasks Master Thread]";
    params ["_log","_flagged","_heartbeatParams","_lagSwitchTickVar"];
    private _safeMarkers = allMapMarkers + ["bankrob","gasrob","ad_dropZone","ad_dropMarker","tw_marker","tw_zone","ds_marker","ds_zone"];

    private _heartbeatTick = 0;
    private _lagSwitchTick = 0;

    CAU_anticheat_manual_trigger = [];

    while {true} do {
        uisleep 0.1;

        // Heartbeat
        if (diag_tickTime > _heartbeatTick) then {
            if (count allPlayers > 0) then {
                _heartbeatParams remoteExec ['spawn',-2];
                ['SYSTEM','Heartbeat sent to '+str(count allPlayers)+' player'+(['','s'] select (count allPlayers > 1))] call _log;
            };
            _heartbeatTick = diag_tickTime + 15;
        };

        // Lag switch
        /*if (diag_tickTime > _lagSwitchTick) then {
            [_lagSwitchTickVar,{missionnamespace setvariable [_this,diag_tickTime]}] remoteExec ['call',-2];
            _lagSwitchTick = diag_tickTime + 5;
        };*/


        // Remote execution checks
        if !(isNil 'inf') then {
        	inf = nil;
        	['SERVER','Remote execution var "inf" found'] call _log;
        };
        if !(isNil {bis_functions_mainscope getVariable ["REA2",nil]}) then {
        	bis_functions_mainscope setVariable ["REA2",nil];
        	['SERVER','Remote execution var "REA2" found on bis_functions_mainscope',nil,true] call _log;
        };
        //removeAllMissionEventHandlers "Eachframe";

        // Markers can be used for remote execution, so we remove the sus ones
        {
        	if !(_x in _safeMarkers) then {
        		if (
        			markertext _x == '....' OR
        			([';',markertext _x] call BIS_fnc_instring) OR
        			markerAlpha _x < 1 OR
        			tolower(markerType _x) in ['empty'] OR
        			tolower(markerShape _x) in ['ellipse','rectangle','polyline']
        		) then {
        			['SERVER',format['Suspicous marker deleted: %1',[_x,markerpos _x,markerAlpha _x,markerType _x,markerShape _x,markertext _x]],nil,true] call _log;
        			deleteMarker _x;
        		};
        	};
        }foreach allMapMarkers;

        // unhide invisible units and check lag switch var
        {
        	if (isObjectHidden _x && !(_x in CAU_AC_hiddenObjs)) then {
        		_x hideObjectGlobal false;
        		['SERVER',format['Invisible unit detected: %1',[_x,name _x,getplayeruid _x]],nil,true] call _log;
        	};
        }foreach playableUnits;

        if (count CAU_anticheat_manual_trigger > 0) then {
        	{_x call _flagged} foreach CAU_anticheat_manual_trigger;
        	CAU_anticheat_manual_trigger = [];
        };
    };
};
