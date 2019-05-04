/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _interruptChildren = ["Title","MissionTitle","PlayersName","ButtonCancel","ButtonSAVE","ButtonSkip","ButtonRespawn","ButtonOptions","ButtonVideo","ButtonAudio","ButtonControls","ButtonGame","ButtonTutorialHints","ButtonAbort","DebugConsole","Version","TraffLight","Feedback","MessageBox"] apply {tolower _x};
private _checkInterruptChildren = "
private _children = ([configFile >> 'RscDisplayMPInterrupt' >> 'controls',0] call BIS_fnc_returnChildren) apply {tolower configname _x};
private _excess = "+str _interruptChildren+" - _children;
if (count _excess > 0) then {
	_"+_flagInitQueueVar+" pushback ['eichld01',_excess];
};
";

private _checkDisplayEVHs = "
private _checkClass = {
	private ['_retM','_retC'];
	private _cfgDirC = (str _this) splitString '/';
	private _cfgDirR = _cfgDirC select [3,count _cfgDirC];
	private _cfgDirC = ([configFile]+_cfgDirR) call BIS_fnc_getCfg;
	{
		_retM = [[_this >> _x] call BIS_fnc_getCfgData] param [0,''];
		_retC = [[_cfgDirC >> _x] call BIS_fnc_getCfgData] param [0,''];
		if !(_retM isEqualTo _retC) then {
			_"+_flagInitQueueVar+" pushback ['deh01',[_cfgDirR+[_x],_retC]];
		};
	} foreach ['onload','onunload','onchilddestroyed','onmouseenter','onmouseexit','onsetfocus','onkillfocus','ontimer','onkeydown','onkeyup','onchar','onimechar','onimecomposition','onjoystickbutton','onmousebuttondown','onmousebuttonup','onmousebuttonclick','onmousebuttondblclick','onmousemoving','onmouseholding','onmousezchanged','oncandestroy','ondestroy','onbuttonclick','onbuttondblclick','onbuttondown','onbuttonup','onlbselchanged','onlblistselchanged','onlbdblclick','onlbdrag','onlbdragging','onlbdrop','ontreeselchanged','ontreelbuttondown','ontreedblclick','ontreeexpanded','ontreecollapsed','ontreemousemove','ontreemousehold','ontreemouseexit','onchecked','oncheckedchanged','oncheckboxesselchanged','ontoolboxselchanged','onhtmllink','onsliderposchanged','onobjectmoved','onmenuselected','ondraw','onvideostopped'];
};
private _checkSubClasses = {
	{
		_x call _checkClass;
		_x call _checkSubClasses;
	} foreach ('true' configClasses _this);
};
(missionConfigFile >> 'CfgAntiCheat' >> 'DEV') call _checkSubClasses;
";


private _badDisplays = [[3030,"RscConfigEditor_Main"],[162,"RscDisplayFieldManual"],[125,"RscDisplayEditDiaryRecord"],[69,"RscDisplayPort"],[19,"RscDisplayIPAddress"],[71,"RscDisplayFilter"],[45,"RscDisplayArcadeMarker"],[132,"RscDisplayHostSettings"],[132,"RscDisplaySetupServer"],[32,"RscDisplayIntel"],[165,"RscDisplayPublishMission"],[165,"display3DENPublishMission"],[2727,"RscDisplayLocWeaponInfo"],[157,"RscDisplayPhysX3Debug"],[157,"RscDisplayModLauncher"],[30,"RscDisplayTemplateLoad"],[166,"RscDisplayPublishMissionSelectTags"],[166,"display3DENPublishMissionSelectTags"],[167,"RscDisplayFileSelect"],[167,"RscDisplayFileSelectImage"],[167,"display3DENPublishMissionSelectImage"],["RscDisplayMultiplayer","RscDisplayMultiplayer"],["RscDisplayRemoteMissions","RscDisplayRemoteMissions"],["RscDisplayMovieInterrupt","RscDisplayMovieInterrupt"],["RscDisplayArsenal","RscDisplayArsenal"],[129,"RscDisplayDiary"]];
private _badUIStrings = ["menu loaded","rustler","hangender","hungender","douggem","monstercheats","bigben","fireworks"," is god","hydroxus","kill target","no recoil","rapid fire","explode all","teleportall","destroyall","destroy all","code to execute","g-e-f","box-esp","god on","god mode","unlimited mags","_execscript","_theban","rhynov1","b1g_b3n","infishit","e_x_t_a_s_y","weppp3","att4chm3nt","f0od_dr1nk","m3d1c4l","t0ol_it3ms","b4ckp4cks","it3m5","cl0th1ng","lystic","extasy","glasssimon_flo","remote_execution","gladtwoown","_pathtoscripts","flo_simon","sonicccc_","fury_","phoenix_","_my_new_bullet_man","_jm3","thirtysix","dmc_fnc_4danews","w_o_o_k_i_e_m_e_n_u","xbowbii_","jm3_","wuat","menutest_","listening to jack","dmcheats.de","kichdm","_news_banner","fucked up","lystics menu","rsccombo_2100","\dll\datmalloc","rsclistbox_1501","rsclistbox_1500","\dll\tcmalloc_bi","___newbpass","updated_playerlist","recking_ki","gg_ee_ff","ggggg_eeeee_fffff","gggg_eeee_ffff","mord all","teleport all","__byass","_altislifeh4x","antifrezze","ownscripts","ownscripted","mesnu","mystic_","init re","init life re","spoody","gef_","throx_","_adasaasasa","_dsfnsjf","cheatmenu","in54nity","markad","fuck_me_","_v4fin","a3randvar","infinite ammo","player markers","+ _code +","menu","infistar","target","T e l e p o r t","N u K e","Crash","Spawn","Money","Remote","Scripts"];
private _badUIVariables = ['_obscuratedmain','_gitmadistrack','_lb1','_lb2','_lb3','_eggsrcute','_popedit','_infobox','_lb3mode','_loadouts','_fhandler','_colortogges','_colortogges','_lb3mode','_lb3mode','_lb3mode','_lb3mode','_lb3mode','_lb3mode','_lb3mode','_PlayahVision','_playerdraw','_PlayahVision','_bombehicleVission','_Vehiclerdraw','_bombehicleVission','_safeviz','_safedraw','_safeviz','_messiahmode','_messiahmode','_speeeeeedy','_speeeeeedy','_staminup','_staminup','_murdurmode','_muderenabled','_murdurmode','_fastaskeem','_fastaskeem','_neverrunsout','_neverrunsout','_nocoil','_nocoil','_explooammo','_exploammo','_explooammo','_flareamooo','_flareamooo','_noosway','_noosway',"ExileIsLocked","ExileIsLocked",'_animalfarmers','_animalfarmers','_ghettoflyy','_ghettoflyy',"ExileLocker",'_spawntabs','_PlayahVision','_bombehicleVission','_murdurmode','_messiahmode','_ghettoflyy','_fastaskeem','_neverrunsout','_explooammo','_noosway','_animalfarmers','_nocoil','_staminup','_safeviz','_speeeeeedy','_slidersetup','_flareamooo','_infohandler','_spectator','_nearvehicss','_bantyplayers','_bantah2add','_lbvihics','_vehcisarrayy','_bags','_magazines','_weapons','_bombests','_heads','_uniforms','_fillemup','_remotemethod','_safezz','_kissmyballs','_colortogges','_colorfunccs',"w_1","w_2","w_3","b_1","b_2","ac","bc"];

private _checkDisplaysThreadVar = '_checkDisplaysThreadVar' call _genRandString;
private _checkDisplays = "
if (!isNil '"+_checkDisplaysThreadVar+"') then {
	_"+_reasonVar+" = ['ia03','Display'];
	call _"+_checkFlaggedStatusVar+";
} else {
"+_checkDisplaysThreadVar+" = [_"+_checkFlaggedStatusVar+",{
	disableSerialization;
	private _"+_reasonVar+" = [];

	private ['_evhID','_d12cCount'];
	private _d46EvhList = [
		['KeyDown',1],
		['KeyUp',1],
		['Load',1],
		['Unload',2]
	];

	if !(missionNamespace getVariable ['DiscordRichPresence_LoadSuccess',false]) then {
		(findDisplay 46) displayAddEventHandler ['Unload',{ }];
	};

	{if ((_x select 0) isequaltype '') then {uinamespace setVariable [_x select 0,nil]}}foreach "+str _badDisplays+";

	while {true} do {
		"+SET_SCOPE_NAME+"
		_"+_reasonVar+" = [];
		"+_DThreadHijackVar+" = 0;

		if !("+_checkDisplaysThreadVar+" isequalto _thisScript) then {
			_"+_reasonVar+" = ['tc06',['Display',str "+_checkDisplaysThreadVar+"]];
			call _this;
			terminate "+_checkDisplaysThreadVar+";
			"+_checkDisplaysThreadVar+" = _thisScript;
		};

		{
			_x params ['_r','_n','_d'];
			_d = switch (typename _r) do {
				case (typename 0):{findDisplay _r};
				case (typename ''):{uinamespace getVariable [_r,displayNull]};
			};
			if !(isNull _d) then {
				_d closeDisplay 0;
				_"+_reasonVar+" = ['dt01',_n];
				call _this;
			};
		}foreach "+str _badDisplays+";

		{
			if (!isNull _x) then {
				_d = _x;
				_f = _forEachIndex;
				{
					if (!isNil {_d getVariable _x}) then {
						_"+_reasonVar+" = ['dt05',[_f,_x,_d getVariable _x]];
						call _this;
					};
				} foreach "+str _badUIVariables+";
			};
		} foreach [findDisplay 0,findDisplay 0 displayCtrl 999];

		if (!isNull (findDisplay 24)) then {
			if (count(allControls findDisplay 24) > 2) then {
				_"+_reasonVar+" = ['dt02',['RscDisplayChat',count (allControls (findDisplay 24))]];
				(findDisplay 24) closeDisplay 0;
				call _this;
			};
		};

		if (!isNull (findDisplay 602) && {count (allControls (findDisplay 602)) > 87}) then {
			_"+_reasonVar+" = ['dt02',['RscDisplayInventory',count (allControls (findDisplay 602))]];
			(findDisplay 602) closeDisplay 0;
			call _this;
		};

		if !(isNull (findDisplay 148)) then {
		    if ((lbSize ((findDisplay 148) displayctrl 104))-1 > 3) then {
		    	(findDisplay 148) closeDisplay 0;
				_"+_reasonVar+" = ['dt02',['RscDisplayConfigureControllers',(lbSize ((findDisplay 148) displayctrl 104))-1]];
				call _this;
		    };
		};

		if (!isNull (findDisplay 54)) then {
			if ((count allControls (findDisplay 54)) != 9) then {
				_"+_reasonVar+" = ['dt02',['RscDisplayInsertMarker',['Control Count',(count allControls (findDisplay 54))]]];
				call _this;
			};
			if ((toLower ctrlText ((findDisplay 54) displayCtrl 1001) != toLower localize 'STR_A3_RscDisplayInsertMarker_Title')) then {
				_"+_reasonVar+" = ['dt02',['RscDisplayInsertMarker',['Title Text',ctrlText ((findDisplay 54) displayCtrl 1001)]]];
				call _this;
			};
			for '_i' from 1 to 2 do {
				if (buttonAction((findDisplay 54)displayCtrl _i) != '') then {
					_"+_reasonVar+" = ['dt02',['RscDisplayInsertMarker',['Button Action',_i,buttonAction((findDisplay 54)displayCtrl _i)]]];
					call _this;
				};
			};
		};

		if (!isNull (findDisplay 131)) then {
		    ((findDisplay 131) displayCtrl 102) ctrlRemoveAllEventHandlers 'LBDblClick';
		    ((findDisplay 131) displayCtrl 102) ctrlRemoveAllEventHandlers 'LBSelChanged';
		    {
		        if (_x && !isNull (findDisplay 131)) exitWith {
					(findDisplay 131) closeDisplay 0;
					_"+_reasonVar+" = ['dt02',['RscDisplayConfigureAction',_forEachIndex]];
					call _this;
		        };
		    } forEach [
		        (toLower ctrlText ((findDisplay 131) displayCtrl 1000) != toLower localize 'STR_A3_RscDisplayConfigureAction_Title'),
		        {if (buttonAction ((findDisplay 131) displayCtrl _x) != '') exitWith {true}; false} forEach [1,104,105,106,107,108,109]
		    ];
		};

		if (!isNull (findDisplay 163)) then {
		    ((findDisplay 163) displayCtrl 101) ctrlRemoveAllEventHandlers 'LBDblClick';
		    ((findDisplay 163) displayCtrl 101) ctrlRemoveAllEventHandlers 'LBSelChanged';
		    {
		        if (_x && !isNull (findDisplay 163)) exitWith {
					(findDisplay 163) closeDisplay 0;
					_"+_reasonVar+" = ['dt02',['RscDisplayControlSchemes',_forEachIndex]];
					call _this;
		        };
		    } forEach [
		        (toLower ctrlText ((findDisplay 163) displayCtrl 1000) != toLower localize 'STR_DISP_OPTIONS_SCHEME'),
		        {if (buttonAction ((findDisplay 163) displayCtrl _x) != '') exitWith {true}; false} forEach [1,2]
		    ];
		};

		if !(isNull (uinamespace getvariable ['BIS_dynamicText',displayNull])) then {
			{
				private _s = _x;
				{
					if ([_s,ctrlText _x] call BIS_fnc_instring) exitwith {
						_"+_reasonVar+" = ['dt03',["+str _badUIStrings+" find _s,_s]];
						(uinamespace getvariable ['BIS_dynamicText',displayNull]) closeDisplay 0;
						call _this;
					};
				}foreach (allControls (uinamespace getvariable ['BIS_dynamicText',displayNull]));
			} foreach "+str _badUIStrings+";
		};

		if !(isNull (findDisplay 49)) then {
			{
				if !(isNull(findDisplay (_x select 0))) then {
					(findDisplay (_x select 0)) closeDisplay 2;
					if (count _x > 1)then{
						_"+_reasonVar+" = ['dt04',_x+[getPosATL player]];
						call _this;
					};
				};
			} foreach [
				[24,'Chat'],
				[602],
				[7410,'House Inventory'],
				[3500,'Multi-purpose Virtual Inventory Menu'],
				[3501,'Vehicle Virtual Inventory'],
				[6900,'Locker Inventory']
			];

          	{
          		private _c = _x;
          		{
          			if ([_x,ctrlText _c] call BIS_fnc_inString) exitwith {
						_"+_reasonVar+" = ['dt02',['RscDisplayInterrupt',_foreachindex,_x]];
						(findDisplay 49) closeDisplay 0;
						call _this;
					};
      			} forEach "+str _badUIStrings+";
     		} forEach [((findDisplay 49) displayCtrl 2),((findDisplay 49) displayCtrl 103)];

	     	_c = findDisplay 49 displayCtrl 1010;
	     	if !(isNull _c) then {
	     		_c = ctrlPosition _c param [3,-1];
	     		if (_c >= 0) then {
	     			if (_c >= 0.06) then {
						_"+_reasonVar+" = ['dt02',['RscDisplayInterrupt_RespawnButton',_c,ctrlText _c]];
						(findDisplay 49) closeDisplay 0;
						call _this;
	     			};
	     		};
	     	};
		};


		{
			_x params ['_evhN','_evhC'];
			_evhID = (findDisplay 46) displayAddEventHandler [_evhN,{ }];

			if (_evhID != _evhC && {_evhID != -1 && getClientState != 'NONE'}) then {
				_"+_reasonVar+" = ['dt06',['Display 46',_evhN,_evhID,_evhC]];
				call _this;
			};

			for '_i' from _evhC to _evhID do {(findDisplay 46) displayRemoveEventHandler [_evhN,_i];};
			_x set [1,_evhID + 1];
			_d46EvhList set [_forEachIndex,_x];
		} foreach _d46EvhList;

		{
			_evhID = (findDisplay 46) displayAddEventHandler [_x,{ }];
			if (_evhID > 0 && {getClientState != 'NONE'}) then {
				_"+_reasonVar+" = ['dt06',['Display 46',_x,_evhID,0]];
				call _this;
			};
			(findDisplay 46) displayRemoveAllEventHandlers _x;
		} foreach ['ChildDestroyed','MouseEnter','MouseExit','SetFocus','KillFocus','Timer','Char','IMEChar','IMEComposition','MouseButtonDown','MouseButtonUp','MouseButtonClick','MouseButtonDblClick','MouseMoving','MouseHolding','MouseZChanged','CanDestroy','Destroy','ButtonClick','ButtonDblClick','ButtonDown','ButtonUp','LBSelChanged','LBListSelChanged','LBDblClick','LBDrag','LBDragging','LBDrop','TreeSelChanged','TreeLButtonDown','TreeDblClick','TreeExpanded','TreeCollapsed','TreeMouseMove','TreeMouseHold','TreeMouseExit','Checked','CheckedChanged','CheckBoxesSelChanged','ToolBoxSelChanged','HTMLLink','SliderPosChanged','ObjectMoved','MenuSelected','Draw','VideoStopped'];
			
		{
			_evhID = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler [_x,{ }];
			if (_evhID > 0 && {getClientState != 'NONE'}) then {
				_"+_reasonVar+" = ['dt06',['Display 12 Control 51',_x,_evhID,0]];
				call _this;
			};
			(findDisplay 12 displayCtrl 51) ctrlRemoveAllEventHandlers _x;
		} foreach ['Load','Unload','ChildDestroyed','MouseEnter','MouseExit','SetFocus','KillFocus','Timer','KeyUp','Char','IMEChar','IMEComposition','MouseButtonDown','MouseButtonUp','MouseButtonDblClick','MouseHolding','MouseZChanged','CanDestroy','Destroy','ButtonClick','ButtonDblClick','ButtonDown','ButtonUp','LBSelChanged','LBListSelChanged','LBDblClick','LBDrag','LBDragging','LBDrop','TreeSelChanged','TreeLButtonDown','TreeDblClick','TreeExpanded','TreeCollapsed','TreeMouseMove','TreeMouseHold','TreeMouseExit','Checked','CheckedChanged','CheckBoxesSelChanged','ToolBoxSelChanged','HTMLLink','SliderPosChanged','ObjectMoved','MenuSelected','VideoStopped'];

		_d12cCount = count allControls findDisplay 12;  
		if !(_d12cCount in [0,113,114]) then {
			_"+_reasonVar+" = ['dt07',_d12cCount];
			call _this;
		};

		if (commandingMenu != '') then {showCommandingMenu ''};

		uisleep (random 0.7 max 0.5);
	};
}] spawn {
	"+SET_SCRIPT_NAME+"
	(_this select 0) call (_this select 1);
};
(objectFromNetId "+str _rndObjID+") setVariable ["+str _checkDisplaysThreadVar+","+_checkDisplaysThreadVar+"];

[_"+_checkFlaggedStatusVar+",{
	disableSerialization;
	private _"+_reasonVar+" = [];

	private ['_evhID'];
	private _d12C51EvhList = [
		['Draw',1],
		['KeyDown',1],
		['MouseButtonClick',1],
		['MouseMoving',1]
	];

	waitUntil {!isNull(findDisplay 12 displayCtrl 51)};
	{
		_x params ['_evhN','_evhC'];
		_evhID = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler [_evhN,{ }];

		if (_evhID != _evhC && {_evhID != -1 && getClientState != 'NONE'}) then {
			_"+_reasonVar+" = ['dt06',['Display 12 Control 51',_evhN,_evhID,_evhC]];
			call _this;
		};

		for '_i' from _evhC to _evhID do {(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler [_evhN,_i];};
		_x set [1,_evhID + 1];
		_d12C51EvhList set [_forEachIndex,_x];
	} foreach _d12C51EvhList;
}] spawn {
	"+SET_SCRIPT_NAME+"
	(_this select 0) call (_this select 1);
};
};
";