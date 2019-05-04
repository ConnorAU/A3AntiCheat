/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _clientEvent_MapTP = "
addMissionEventHandler['MapSingleClick',{
    if ((call CAU_admin_rank) >= 2) exitWith {};
    (_this select 1) spawn {
        private _tick = diag_tickTime + 2;
        private _clickPos = _this select [0,2];
        private _true = false;
        waitUntil {
        	_true = (getpos player select [0,2]) isEqualTo _clickPos;
        	_true OR {diag_tickTime > _tick}
       	};
        if _true then {
        	"+([2] call _checkFlaggedStatus)+"
			_"+_reasonVar+" = ['cemtp01',_clickPos];
			call _"+_checkFlaggedStatusVar+";
        };
    };
}];
";

private _clientEvent_FiredMan_CDV = '_clientEvent_FiredMan_CDV' call _genRandString;
private _clientEvent_FiredMan_LastFiredInfo = '_clientEvent_FiredMan_LastFiredInfo' call _genRandString;
private _clientEvent_FiredMan = "";/*
"+_clientEvent_FiredMan_CDV+" = 0;
"+_clientEvent_FiredMan_LastFiredInfo+" = [];
player addEventHandler ['FiredMan',{
	if !(missionNamespace getVariable ['CAU_AC_CEFM_KS',false]) exitwith {};
	if ("+_clientEvent_FiredMan_CDV+" > diag_tickTime) exitwith {};
	params ['_unit','_weapon','_muzzle','_mode','_ammo','_magazine','_projectile','_vehicle'];
	if (_weapon in [primaryWeapon _unit,secondaryWeapon _unit,handgunWeapon _unit]) then {
		"+([] call _checkFlaggedStatus)+"
		private _curWeapon = currentWeapon _unit;
		private _curMuzzle = currentMuzzle _unit;
		"+_clientEvent_FiredMan_LastFiredInfo+" params [
			['_lfi_tick',0],
			['_lfi_weap',''],
			['_lfi_mags',''],
			['_lfi_ammo',0]
		];
		if (_weapon != _curWeapon) then {
			"+_clientEvent_FiredMan_CDV+" = diag_tickTime + 2;
			_"+_reasonVar+" = ['cefm01w',[
				_weapon,_curWeapon,_mode,
				_ammo,_magazine,_projectile,
				vehicle _unit isequalto _unit
			]];
			call _"+_checkFlaggedStatusVar+";
		};
		if (_muzzle != _curMuzzle) then {
			"+_clientEvent_FiredMan_CDV+" = diag_tickTime + 2;
			_"+_reasonVar+" = ['cefm01m',[
				_weapon,_curWeapon,_mode,
				_ammo,_magazine,_projectile,
				vehicle _unit isequalto _unit
			]];
			call _"+_checkFlaggedStatusVar+";
		};
		private _maxAmmo = getNumber(configfile >> 'CfgMagazines' >> _magazine >> 'count');
		private _curAmmo = _unit ammo _muzzle;
		if (_maxAmmo > 0) then {
			if (_curAmmo >= _maxAmmo) then {
				"+_clientEvent_FiredMan_CDV+" = diag_tickTime + 2;
				_"+_reasonVar+" = ['cefm03',[
					_curAmmo,_maxAmmo,_muzzle,
					_mode,_ammo,_magazine,
					vehicle _unit isequalto _unit
				]];
				call _"+_checkFlaggedStatusVar+";
			};
			if (_muzzle == _lfi_weap) then {
				private _lastShotTickDiff = diag_tickTime - _lfi_tick;
				private _reloadBulletTimeC = configFile >> 'CfgWeapons' >> _muzzle >> _mode >> 'reloadTime';
				private _reloadBulletTime = (if (isNumber _reloadBulletTimeC) then {
					getNumber _reloadBulletTimeC
				} else {
					getNumber(configFile >> 'CfgWeapons' >> _weapon >> _muzzle >> 'reloadTime')
				}) * 0.8;
				if (_reloadBulletTime > 0) then {
					if (_lastShotTickDiff < _reloadBulletTime) then {
						"+_clientEvent_FiredMan_CDV+" = diag_tickTime + 2;
						_"+_reasonVar+" = ['cefm04',[
							_lastShotTickDiff,_reloadBulletTime,
							_muzzle,_mode,_ammo,_magazine,
							vehicle _unit isequalto _unit
						]];
						call _"+_checkFlaggedStatusVar+";
					};
					if (_lfi_mags == _magazine && {_curAmmo >= _lfi_ammo}) then {
							if (_lastShotTickDiff < (_reloadBulletTime*3)) then {
							"+_clientEvent_FiredMan_CDV+" = diag_tickTime + 2;
							_"+_reasonVar+" = ['cefm05',[
								_lfi_ammo,_curAmmo,
								_lastShotTickDiff,_reloadBulletTime*3,
								_muzzle,_mode,_magazine,
								vehicle _unit isequalto _unit
							]];
							call _"+_checkFlaggedStatusVar+";
						};
					};
				};
			};
		};
		private _speed = speed _projectile;
		if (_speed > 4000) then {
			"+_clientEvent_FiredMan_CDV+" = diag_tickTime + 2;
			_"+_reasonVar+" = ['cefm02',[
				_speed,_muzzle,_mode,
				_ammo,_magazine,_projectile,
				vehicle _unit isequalto _unit
			]];
			call _"+_checkFlaggedStatusVar+";
		};
		"+_clientEvent_FiredMan_LastFiredInfo+" = [diag_tickTime,_muzzle,_magazine,_curAmmo];
	};
}];
";*/

private _clientEvent_HandleDamage_CDV = '_clientEvent_HandleDamage_CDV' call _genRandString;
private _clientEvent_HandleDamage = "";/*
"+_clientEvent_HandleDamage_CDV+" = 0;
player addEventHandler ['HandleDamage',{
	if !(missionNamespace getVariable ['CAU_AC_CEHD_KS',false]) exitwith {};
	if ("+_clientEvent_HandleDamage_CDV+" > diag_tickTime) exitwith {};
	params ['_unit','_hitPart','_damage','_source','_projectile','','_instigator'];
	if (!('' in [_hitPart,_projectile]) && {_damage > 0}) then {
		if (isNull _instigator) then {_instigator = _source};
		if !(isNull _instigator) then {
            private _iPos = eyePos _instigator;
            private _uPos = AGLToASL(_unit modelToWorld (_unit selectionPosition _hitPart));
			if (([_instigator,'VIEW',_unit] checkVisibility [_iPos,_uPos]) isEqualTo 0) then {
				"+_clientEvent_HandleDamage_CDV+" = diag_tickTime + 5;
				"+([] call _checkFlaggedStatus)+"
				_"+_reasonVar+" = ['cehd01',[
					_instigator getVariable ['realname',name _instigator],
					getPlayerUID _instigator,_projectile,_hitPart,_damage,
					_instigator distance _unit,_iPos,_uPos
				]];
				call _"+_checkFlaggedStatusVar+";
			};
		};
	};
	nil
}];
";*/


private _clientEvent_Take = "
player addEventHandler ['Take',{
    "+([] call _checkFlaggedStatus)+"
    "+_checkUnitContainers+"
}];

";


/*private _clientEvent_HandleDamage = "
"+_clientEvent_HandleDamage_CDV+" = 0;
player addEventHandler ['HandleDamage',{
	if !(missionNamespace getVariable ['CAU_AC_CEHD_KS',false]) exitwith {};
	if ("+_clientEvent_HandleDamage_CDV+" > diag_tickTime) exitwith {};
	params ['_unit','_hitPart','_damage','_source','_projectile','','_instigator'];
	if (_projectile != '') then {
		if (isNull _instigator) then {_instigator = _source};
		if !(isNull _instigator) then {
			private _posI = eyePos _instigator;
			private _posU = AGLToASL(_unit modelToWorld (_unit selectionPosition _hitPart));

			private _tIntersect = terrainIntersectASL[_posI,_posU];
			private _oIntersect = lineIntersectsWith[_posI,_posU,_instigator,_unit,false];

			if (_tIntersect || {count _oIntersect > 0}) then {
				"+_clientEvent_HandleDamage_CDV+" = diag_tickTime + 5;
				"+([] call _checkFlaggedStatus)+"
				_"+_reasonVar+" = ['cehd01',[
					_instigator getVariable ['realname',name _instigator],
					getPlayerUID _instigator,_instigator distance _unit,
					getpos _instigator,getpos _unit,_projectile,
					_tIntersect,_oIntersect
				]];
				call _"+_checkFlaggedStatusVar+";
			};
		};
	};
	nil
}];
";*/


/*private _clientEvent_HandleDamage = "
"+_clientEvent_HandleDamage_CDV+" = 0;
player addEventHandler ['HandleDamage',{
	if !(missionNamespace getVariable ['CAU_AC_CEHD_KS',false]) exitwith {};
	if ("+_clientEvent_HandleDamage_CDV+" > diag_tickTime) exitwith {};
	params ['_unit','','_damage','_source','_projectile','','_instigator'];
	if (_projectile != '') then {
		if (isNull _instigator) then {_instigator = _source};
		if !(isNull _instigator) then {
			private _eyePosI = eyePos _instigator;
			private _eyePosU = eyePos _unit;
			private _footPosU = getPosASL _instigator;
			private _bodyPosU = _footPosU vectorAdd [0,0,((_eyePosU select 2)-(_footPosU select 2))/2];

			private _eyeIntersect = lineIntersectsWith[_eyePosI,_eyePosU,_instigator,_unit];
			private _bodyIntersect = lineIntersectsWith[_eyePosI,_bodyPosU,_instigator,_unit];
			private _footIntersect = lineIntersectsWith[_eyePosI,_footPosU,_instigator,_unit];

			if !(0 in ([_eyeIntersect,_bodyIntersect,_footIntersect] apply {count _x})) then {
				private _intersectingObjects = [];
				{_intersectingObjects pushBackUnique _x} foreach (_eyeIntersect+_bodyIntersect+_footIntersect);
				"+_clientEvent_HandleDamage_CDV+" = diag_tickTime + 5;
				"+([] call _checkFlaggedStatus)+"
				_"+_reasonVar+" = ['cehd01',[
					_instigator getVariable ['realname',name _instigator],
					getPlayerUID _instigator,_instigator distance _unit,
					getpos _instigator,getpos _unit,_projectile,_intersectingObjects
				]];
				call _"+_checkFlaggedStatusVar+";
			};
		};
	};
	nil
}];
";*/
