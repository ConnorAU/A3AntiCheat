/*──────────────────────────────────────────────────────┐
│   Author: Connor                                      │
│   Steam:  https://steamcommunity.com/id/_connor       │
│   Github: https://github.com/ConnorAU                 │
│                                                       │
│   Please do not modify or remove this comment block   │
└──────────────────────────────────────────────────────*/

private _lastCashVar = '_lastCashVar' call _genRandString;
private _lastBankVar = '_lastBankVar' call _genRandString;
private _moneyMultiplier = '_moneyMultiplier' call _genRandString;
private _sessionLoaded = '_sessionLoaded' call _genRandString;

private _checkClientInitVariables = "
	private ['_mcWeight','_NOBJ','_"+_lastCashVar+"','_"+_lastBankVar+"','_"+_moneyMultiplier+"','_vC','_vB','_dC','_dB','_evhID','_asCount'];
	private _side = switch playerside do {
		case west:{'cop'};
		case civilian:{'civ'};
		case independent:{'med'};
		default {''};
	};

	private _"+_sessionLoaded+" = false;

	private _currEditCheckTick = 0;

	private _asCountTick = 0;

	private _camOnTick = 0;

	private _evhListMission = [
		['EachFrame',2],
		['MapSingleClick',1]
	];
	private _evhListPlayer = [
		['Explosion',1],
		['Fired',1],
		['GetInMan',1],
		['GetOutMan',1],
		['HandleDamage',2],
		['InventoryClosed',1],
		['InventoryOpened',1],
		['Killed',1],
		['PostReset',1],
		['Put',1],
		['Respawn',2],
		['SeatSwitchedMan',1],
		['SoundPlayed',1],
		['Take',2]
	];
";
//['Loaded',2],

private _checkClient = "

if (_"+_sessionLoaded+" OR {missionNamespace getVariable ['life_session_completed',false]}) then {
_"+_sessionLoaded+" = true;

if (isNil '_"+_lastCashVar+"' OR isNil '_"+_lastBankVar+"') then {
	_"+_moneyMultiplier+" = random 6.75 max 1.75;
	_"+_lastCashVar+" = CAU_cash_inHand/_"+_moneyMultiplier+";
	_"+_lastBankVar+" = CAU_cash_inAccount/_"+_moneyMultiplier+";
};

if ((['CAU_cash_inHand','CAU_cash_inAccount'] findif {isNil _x}) > -1) then {
	_"+_reasonVar+" = ['cc01',[missionNamespace getVariable['CAU_cash_inHand','nil'],missionNamespace getVariable['CAU_cash_inAccount','nil']]];
	call _"+_checkFlaggedStatusVar+";
};

if !([CAU_cash_inHand,CAU_cash_inAccount] isEqualTypeAll 0) then {
	_"+_reasonVar+" = ['cc02',[CAU_cash_inHand,CAU_cash_inAccount]];
	call _"+_checkFlaggedStatusVar+";
};

if (isNil 'CAU_cash_modifiedValues') then {
	_"+_reasonVar+" = ['cc03'];
};

if !(CAU_cash_modifiedValues isEqualType []) then {
	_"+_reasonVar+" = ['cc04',CAU_cash_modifiedValues];
	CAU_cash_modifiedValues = [0,0];
	call _"+_checkFlaggedStatusVar+";
};

if (diag_ticktime > _currEditCheckTick) then {
	_currEditCheckTick = diag_tickTime + 5;
	isNil {
		_vC = _"+_lastCashVar+"*_"+_moneyMultiplier+";
		_vB = _"+_lastBankVar+"*_"+_moneyMultiplier+";
		_cC = CAU_cash_inHand;
		_cB = CAU_cash_inAccount;
		if ({(_x select 0) isequalto (_x select 1)} count ([[_vC,_cC],[_vB,_cB]]) < 2) then {
			_dC = (abs(_vC - _cC)) > 200;
			_dB = (abs(_vB - _cB)) > 200;
			if (!life_cashTransactionPerformed && (_dC OR _dB)) then {
				_cDiff = _cC - (_"+_lastCashVar+"*_"+_moneyMultiplier+");
				_bDiff = _cB - (_"+_lastBankVar+"*_"+_moneyMultiplier+");
				_"+_reasonVar+" = ['cc05',[
					[
						format['%1%2',['','-'] select (_cDiff < 0),(abs _cDiff) call life_fnc_numberText],
						(_"+_lastCashVar+"*_"+_moneyMultiplier+") call life_fnc_numberText,
						_cC call life_fnc_numberText
					],
					[
						format['%1%2',['','-'] select (_bDiff < 0),(abs _bDiff) call life_fnc_numberText],
						(_"+_lastBankVar+"*_"+_moneyMultiplier+") call life_fnc_numberText,
						_cB call life_fnc_numberText
					]
				]];
				call _"+_checkFlaggedStatusVar+";
			};
			life_cashTransactionPerformed = false;

			_dC = _vC + (CAU_cash_modifiedValues param [0,0,[0]]);
			_dB = _vB + (CAU_cash_modifiedValues param [1,0,[0]]);

			_"+_moneyMultiplier+" = random 6.75 max 1.75;
			_"+_lastCashVar+" = CAU_cash_inHand/_"+_moneyMultiplier+";
			_"+_lastBankVar+" = CAU_cash_inAccount/_"+_moneyMultiplier+";
			CAU_cash_modifiedValues = [0,0];

			if !(_dC isequalto _cC) then {
				_diff = _cC - _dC;
				if ((abs _diff) > 200) then {
					_"+_reasonVar+" = ['cc06',[
						'CASH',
						format['%1%2',['','-'] select (_diff < 0),(abs _diff) call life_fnc_numberText],
						_dC call life_fnc_numberText,
						_cC call life_fnc_numberText
					]];
					call _"+_checkFlaggedStatusVar+";
				};
			};
			if !(_dB isequalto _cB) then {
				_diff = _cB - _dB;
				if ((abs _diff) > 200) then {
					_"+_reasonVar+" = ['cc06',[
						'BANK',
						format['%1%2',['','-'] select (_diff < 0),(abs _diff) call life_fnc_numberText],
						_dB call life_fnc_numberText,
						_cB call life_fnc_numberText
					]];
					call _"+_checkFlaggedStatusVar+";
				};
			};
			_dC = nil;_dB = nil;

		};
		_vC = nil;_vB = nil;_cC = nil;_cB = nil;
	};
};

if (missionNamespace getVariable [format['license_%1_notSoSus',_side],false]) then {
	_"+_reasonVar+" = ['cc07'];
	call _"+_checkFlaggedStatusVar+";
};

if (life_carryWeight < 0) then {
	private _items = ('true' configClasses (missionConfigFile >> 'VirtualItems')) select {
		(missionNamespace getVariable [format['life_inv_%1',getText(_x >> 'variable')],0]) > 0
	};
	_"+_reasonVar+" = ['cc08',[life_carryWeight]+(_items apply {
		[configname _x,missionNamespace getVariable [format['life_inv_%1',getText(_x >> 'variable')],0]]
	})];
	{missionNamespace setVariable [format['life_inv_%1',getText(_x >> 'variable')],0];} forEach _items;
	life_carryWeight = 0;
	call _"+_checkFlaggedStatusVar+";
	[
		'Please contact Connor and tell him what you were doing when this popup opened.',
		'Error 0x175CC',
		'Proceed'
	] spawn BIS_fnc_guiMessage;
};

_mcWeight = getNumber(missionConfigFile >> 'Life_Settings' >> 'total_maxWeight');
if (backpack player == '') then {
	if (life_maxWeight > _mcWeight) then {
		life_maxWeight = _mcWeight;
	};
} else {
	_mcWeight = _mcWeight + getNumber(missionConfigFile >> 'CfgBackpacks' >> backpack player);
	if (life_maxWeight > _mcWeight) then {
		life_maxWeight = _mcWeight;
	};
};

};

if ((call(missionNamespace getVariable ['CAU_admin_rank',{0}])) < 1 && {diag_ticktime > _camOnTick && {cameraOn != vehicle player}}) then {
	_camOnTick = diag_tickTime + 1;
	if (cameraOn isKindOf 'CAManBase') then {
		_"+_reasonVar+" = ['cc17',[cameraOn,typeof cameraOn,getpos cameraon,vehicle player,typeof vehicle player,getpos vehicle player]];
		call _"+_checkFlaggedStatusVar+";
		player switchCamera 'INTERNAL';
		_camOnTick = diag_tickTime + 10;
	};
};

_NOBJ = (nearestobjects [player,['Land_Money_F'],10]) select {local _x};
if (count _NOBJ > 0) then {
	{
		_"+_reasonVar+" = ['cc09',[getpos _x,allVariables _x]];
		deletevehicle _x;
	}foreach _NOBJ;
	call _"+_checkFlaggedStatusVar+";
};

_NOBJ = (nearestobjects [player,['Land_LuggageHeap_02_F'],10]) select {local _x};
if (count _NOBJ > 0) then {
	{
		if !(_x in life_droppedItems) then {
			_"+_reasonVar+" = ['cc10',[getpos _x,allVariables _x,typeof _x,getModelInfo _x,_x,life_droppedItems]];
			deletevehicle _x;
		};
	}foreach _NOBJ;
	call _"+_checkFlaggedStatusVar+";
};

"+_checkUnitContainers+"

if (unitRecoilCoefficient player < 1) then {
	_"+_reasonVar+" = ['cc14',unitRecoilCoefficient player];
	player setUnitRecoilCoefficient 1;
	call _"+_checkFlaggedStatusVar+";
};

if (getCustomAimCoef player < ([0.25,1] select (diag_tickTime > life_redgull_effect))) then {
	_"+_reasonVar+" = ['cc15',[getCustomAimCoef player,diag_tickTime > life_redgull_effect]];
	player setCustomAimCoef 1;
	call _"+_checkFlaggedStatusVar+";
};

if (getAnimSpeedCoef player != 1) then {
	_"+_reasonVar+" = ['cc16',getAnimSpeedCoef player];
	player setAnimSpeedCoef 1;
	call _"+_checkFlaggedStatusVar+";
};

{
	_evhID = player addEventHandler [_x,{}];
	if (_evhID > 0 && {getClientState != 'NONE'}) then {
		_"+_reasonVar+" = ['cc18',['Player',_x,_evhID,0]];
		call _"+_checkFlaggedStatusVar+";
	};
	player removeAllEventHandlers _x;
} foreach ['AnimChanged','AnimDone','AnimStateChanged','ContainerClosed','ContainerOpened','ControlsShifted','Dammaged','Deleted','Engine','EpeContact','EpeContactEnd','EpeContactStart','FiredMan','FiredNear','Fuel','Gear','GetIn','GetOut','HandleHeal','HandleRating','HandleScore','Hit','HitPart','Init','HandleIdentity','IncomingMissile','LandedTouchDown','LandedStopped','Landing','LandingCanceled','Local','Reloaded','RopeAttach','RopeBreak','SeatSwitched','TaskSetAsCurrent','TurnIn','TurnOut','WeaponAssembled','WeaponDisassembled','WeaponDeployed','WeaponRested'];
{
	_x params ['_evhN','_evhC'];
	_evhID = player addEventHandler [_evhN,{}];
	if (_evhID != _evhC && {_evhID != -1 && getClientState != 'NONE'}) then {
		_"+_reasonVar+" = ['cc18',['Player',_evhN,_evhID,_evhC]];
		call _"+_checkFlaggedStatusVar+";
	};
	for '_i' from _evhC to _evhID do {player removeEventHandler [_evhN,_i];};
	_x set [1,_evhID + 1];
	_evhListPlayer set [_forEachIndex,_x];
} foreach _evhListPlayer;
{
	_evhID = addMissionEventHandler [_x,{}];
	if (_evhID > 0 && {getClientState != 'NONE'}) then {
		if (switch _x do {
			case 'Draw3D':{
				isNull(getAssignedCuratorLogic player) OR {
					!isNull(getAssignedCuratorLogic player) && {
						(call CAU_admin_rank < getNumber(missionConfigFile >> 'StaffMenu' >> 'zeus' >> 'requiredRank'))
					}
				}
			};
			default {true};
		}) then {
			_"+_reasonVar+" = ['cc18',['Mission',_x,_evhID,0]];
			call _"+_checkFlaggedStatusVar+";
		};
	};
	removeAllMissionEventHandlers _x;
} foreach ['BuildingChanged','CommandModeChanged','Draw3D','EntityKilled','EntityRespawned','GroupIconClick','GroupIconOverEnter','GroupIconOverLeave','HandleDisconnect','HCGroupSelectionChanged','Map','PlayerConnected','PlayerDisconnected','PlayerViewChanged','PreloadStarted','PreloadFinished','TeamSwitch'];
{
	_x params ['_evhN','_evhC'];
	_evhID = addMissionEventHandler [_evhN,{}];
	if (_evhID != _evhC && {_evhID != -1 && getClientState != 'NONE'}) then {
		_"+_reasonVar+" = ['cc18',['Mission',_evhN,_evhID,_evhC]];
		call _"+_checkFlaggedStatusVar+";
	};
	for '_i' from _evhC to _evhID do {removeMissionEventHandler [_evhN,_i];};
	_x set [1,_evhID + 1];
	_evhListMission set [_forEachIndex,_x];
} foreach _evhListMission;

if (diag_tickTime > _asCountTick) then {
	isNil {
		_asCountTick = diag_tickTime + 5;
		_asCount = diag_activeSQFScripts select {
			!((_x select [0,2]) in [
				['fn_animalBehaviour_mainLoop','A3\functions_f\ambient\fn_animalBehaviour.sqf [BIS_fnc_animalBehaviour]'],
				['fn_radialRed_mainLoop','A3\functions_f\Feedback\fn_radialRed.sqf [BIS_fnc_radialRed]'],
				['fn_bloodEffect_mainLoop','A3\functions_f\Feedback\fn_bloodEffect.sqf [BIS_fnc_bloodEffect]'],
				['fn_dirtEffect_mainLoop','A3\functions_f\Feedback\fn_dirtEffect.sqf [BIS_fnc_dirtEffect]']
			])
		};
		if (count _asCount > 75) then {
			_asCountTick = diag_ticktime + (5*60);
			_"+_reasonVar+" = ['cc20',diag_activeScripts];
			call _"+_checkFlaggedStatusVar+";
		};
	};
};

if (isNil 'life_adminTPActive') then {onMapSingleClick {}};
onEachFrame {};
";

/*

if (count CAU_anticheat_manual_trigger > 0) then {
	{
		_x params ['_v','_f'];
		_"+_reasonVar+" = switch _v do {
			case 0:{
				if (missionNamespace getVariable ['CAU_AC_MT_0_KS',false]) then {
					[]
				} else {
					[0,'Possible item duplication',format['Possible item duplication: %1',_f]]
				}
			};
			default {[]};
		};
		call _"+_checkFlaggedStatusVar+";
	} foreach CAU_anticheat_manual_trigger;
	CAU_anticheat_manual_trigger = [];
};

 */
