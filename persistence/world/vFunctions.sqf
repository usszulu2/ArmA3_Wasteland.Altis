diag_log "vFunctions.sqf loading ...";

#include "macro.h"

v_restoreVehicle = {
  //diag_log format["%1 call v_restoreVehicle", _this];
  ARGVX3(0,_data_pair,[]);
  ARGV4(1,_ignore_expiration,false,false);
  ARGV3(2,_create_array,[]);

  _this = _data_pair;
  ARGVX3(0,_vehicle_key,"");
  ARGVX2(1,_vehicle_hash);


  def(_vehicle_data);
  if (isCODE(_vehicle_hash)) then {
    _vehicle_data = call _vehicle_hash;
  }
  else { if(isARRAY(_vehicle_hash)) then {
    _vehicle_data = _vehicle_hash;
  };};

  if (isNil "_vehicle_data") exitWith {};

  //diag_log _vehicle_data;


  def(_hours_alive);
  def(_hours_abandoned);
  def(_pos);
  def(_class);
  def(_dir);
  def(_damage);
  def(_texture);
  def(_variables);
  def(_cargo_weapons);
  def(_cargo_magazines);
  def(_cargo_backpacks);
  def(_cargo_items);
  def(_cargo_ammo);
  def(_cargo_fuel);
  def(_cargo_repair);
  def(_fuel);
  def(_hitPoints);
  def(_turret0);
  def(_turret1);
  def(_turret2);
  def(_lock_state);


  def(_key);
  def(_value);

  {
    _key = _x select 0;
    _value = _x select 1;
    switch (_key) do {
      case "Class": { _class = OR(_value,nil);};
      case "Position": { _pos = OR(_value,nil);};
      case "Direction": { _dir = OR(_value,nil);};
      case "Damage": { _damage = OR(_value,nil);};
      case "Weapons": { _cargo_weapons = OR(_value,nil);};
      case "Items": { _cargo_items = OR(_value,nil);};
      case "Magazines": { _cargo_magazines = OR(_value,nil);};
      case "Backpacks": { _cargo_backpacks = OR(_value,nil);};
      case "HoursAlive": { _hours_alive = OR(_value,nil);};
      case "HoursAbandoned": { _hours_abandoned = OR(_value,nil);};
      case "Variables": { _variables = OR(_value,nil);};
      case "AmmoCargo": { _cargo_ammo = OR(_value,nil);};
      case "FuelCargo": { _cargo_fuel = OR(_value,nil);};
      case "RepairCargo": { _cargo_repair = OR(_value,nil);};
      case "TurretMagazines": { _turret0 = OR_ARRAY(_value,nil);};
      case "TurretMagazines2": { _turret1 = OR_ARRAY(_value,nil);};
      case "TurretMagazines3": { _turret2 = OR_ARRAY(_value,nil);};
      case "Fuel": { _fuel = OR(_value,nil);};
      case "Hitpoints": { _hitPoints = OR(_value,nil);};
      case "LockState": { _lock_state = OR(_value,nil);};
    };
  } forEach _vehicle_data;

  //if there is no class and position, there is no point to recreating the vehicle
  if (not(isSTRING(_class)) || {not(isARRAY(_pos))}) exitWith {
    diag_log format["No class or position available for vehicle: %1", _vehicle_key];
  };

  //AgentRev changed how position is saved, put this fail-safe to handle position with values as strings
  { if (isSTRING(_x)) then { _pos set [_forEachIndex, parseNumber _x] } } forEach _pos;

  diag_log format["%1(%2) is being restored.", _vehicle_key, _class];


  if (not(_ignore_expiration) && {isSCALAR(_hours_alive) && {A3W_vehicleLifetime > 0 && {_hours_alive > A3W_vehicleLifetime}}}) exitWith {
    diag_log format["vehicle %1(%2) has been alive for %3 (max=%4), skipping it", _vehicle_key, _class, _hours_alive, A3W_vehicleLifetime];
  };

  if (not(_ignore_expiration) && {isSCALAR(_hours_abandoned) && {A3W_vehicleMaxUnusedTime > 0 && {_hours_abandoned > A3W_vehicleMaxUnusedTime}}}) exitWith {
    diag_log format["vehicle %1(%2) has been abandoned for %3 hours, (max=%4), skipping it", _vehicle_key, _class, _hours_abandoned, A3W_vehicleMaxUnusedTime];
  };


  def(_is_flying);
  _is_flying = [_pos] call sh_isFlying;

  def(_obj);
  if (isARRAY(_create_array)) then {
    _obj = createVehicle _create_array;
  }
  else {
    def(_special);
    _special = if (_is_flying) then {"FLY"} else {"CAN_COLLIDE"};
    _obj = createVehicle [_class, _pos, [], 0, _special];
  };

  if (!isOBJECT(_obj)) exitWith {
    diag_log format["Could not create vehicle of class: %1", _class];
  };

  _obj allowDamage false;
  [_obj] spawn { ARGVX3(0,_obj,objNull); sleep 3; _obj allowDamage true;}; //hack so that vehicle does not take damage while spawning


  [_obj, false] call vehicleSetup;

  _obj setVariable ["vehicle_key", _vehicle_key, true];
  missionNamespace setVariable [_vehicle_key, _obj];

  if (!isARRAY(_create_array)) then {
    _obj setPosWorld ATLtoASL _pos;
  };

  if (isARRAY(_dir)) then {
    _obj setVectorDirAndUp _dir;
  };

  _obj setVariable ["baseSaving_spawningTime", diag_tickTime, true];
  if (isSCALAR(_hours_alive)) then {
    _obj setVariable ["baseSaving_hoursAlive", _hours_alive, true];
  };

  _obj setVariable ["vehicle_abandoned_time", diag_tickTime, true];  //the moment the vehicle is restored, consider it abandoned
  if (isSCALAR(_hours_abandoned)) then {
    _obj setVariable ["vehicle_abandoned_hours", _hours_abandoned, true];
  };

  // disables thermal equipment on loaded vehicles, comment out if you want thermal
  _obj disableTIEquipment true;

  //enables thermal equipment on loaded vehicles for UAVs and UGVs
  if ({_obj isKindOf _x} count ["UAV_01_base_F", "UAV_02_base_F", "UGV_01_base_F"] > 0) then {
    _obj disableTIEquipment false;
  };

  if (_obj isKindOf "O_Heli_Light_02_F") then {
    _obj removeWeaponTurret ["missiles_DAGR",[-1]];
    _obj addWeaponTurret ["missiles_DAR",[-1]];
  };  
  
  if ({_obj isKindOf _x} count ["B_Heli_Light_01_F", "B_Heli_Light_01_armed_F", "O_Heli_Light_02_unarmed_F", "C_Heli_Light_01_civil_F"] > 0) then {
    _obj removeWeaponTurret ["CMFlareLauncher",[-1]];
    _obj addWeaponTurret ["CMFlareLauncher",[-1]];
  };    
  
  //override the lock-state for vehicles form this this
  if ({_obj isKindOf _x} count A3W_locked_vehicles_list > 0) then {
    _lock_state = 2;
  };

  if (isSCALAR(_lock_state)) then {
    _obj lock _lock_state;
    _obj setVariable ["R3F_LOG_disabled", (_lock_state > 1) , true];
  };

  if (isSCALAR(_damage)) then {
    _obj setDamage _damage;
  };

  if (isSCALAR(_fuel)) then {
    _obj setFuel _fuel;
  };

  if (isARRAY(_hitPoints)) then {
    { _obj setHitPointDamage _x } forEach _hitPoints;
  };

  [_obj,_variables] call sh_restoreVariables;


  def(_textures);
  _textures = _obj getVariable ["A3W_objectTextures",[]];
  if (isARRAY(_textures)) then {
    _obj setVariable ["BIS_enableRandomization", false, true];
    {
      _obj setObjectTextureGlobal _x;
    } forEach _textures;
  };

  //Add AI to vehicle
  if ([_obj] call sh_isUAV_UGV) then {
    createVehicleCrew _obj;
  };

  if (_is_flying && {[_obj] call sh_isUAV}) then {
    _obj flyInHeight (((_obj call fn_getPos3D) select 2) max 500);
    [_obj] spawn {
      ARGVX3(0,_obj,objNull);
      waitUntil {!isNull driver _obj};
      def(_wp);
      _wp = (group _obj) addWaypoint [getPosATL _obj, 0];
      _wp setWaypointType "MOVE";
    };
  };


  //restore the stuff inside the vehicle
  clearWeaponCargoGlobal _obj;
  clearMagazineCargoGlobal _obj;
  clearItemCargoGlobal _obj;
  clearBackpackCargoGlobal _obj;

  [_obj, OR(_turret0,nil), OR(_turret1,nil), OR(_turret2,nil)] call sh_restoreVehicleTurrets;

  if (isARRAY(_cargo_weapons)) then {
    { _obj addWeaponCargoGlobal _x } forEach _cargo_weapons;
  };

  if (isARRAY(_cargo_backpacks)) then {
    {
      def(_value);
      def(_is_weapon_bag);
      def(_is_allowed_bag);
      
      _value = _x select 0;
      _is_weapon_bag = _value isKindOf "Weapon_Bag_Base";
      _is_allowed_bag = ({_value isKindOf _x} count ["B_UAV_01_backpack_F", "B_Static_Designator_01_weapon_F", "O_Static_Designator_02_weapon_F"] == 0);
      
      if (not(_is_weapon_bag) || {_is_allowed_bag}) then {
        _obj addBackpackCargoGlobal _x
      };
    } forEach _cargo_backpacks;
  };

  if (isARRAY(_cargo_items)) then {
    { _obj addItemCargoGlobal _x } forEach _cargo_items;
  };

  if (isARRAY(_cargo_magazines)) then {
    { _obj addMagazineCargoGlobal _x } forEach _cargo_magazines;
  };

  if (isSCALAR(_cargo_ammo)) then {
    _obj setAmmoCargo _cargo_ammo;
  };

  if (isSCALAR(_cargo_fuel)) then {
    _obj setFuelCargo _cargo_fuel;
  };

  if (isSCALAR(_cargo_repair)) then {
    _obj setRepairCargo _cargo_repair;
  };


  tracked_vehicles_list pushBack _obj;

  _obj
};


tracked_vehicles_list = OR_ARRAY(tracked_vehicles_list,[]);

v_getTrackedVehicleIndex = {
  ARGVX4(0,_obj,objNull,-1);
  if (isNull _obj) exitWith {-1};

  (tracked_vehicles_list find _obj)
};

v_trackVehicle = {
  private["_index","_object"];
  _object = _this select 0;
  _index = [OR(_object,nil)] call v_getTrackedVehicleIndex;
  if (_index >= 0) exitWith {};

  //forward to HC
  ["trackVehicle", _object] call sh_hc_forward;

  //diag_log format["%1 is being added to the tracked list", _object];
  tracked_vehicles_list pushBack _object;
};


//event handlers for object tracking, and untracking
"trackVehicle" addPublicVariableEventHandler { [_this select 1] call v_trackVehicle;};

v_untrackVehicle = {
  private["_index","_object"];
  _object = _this select 0;
  _index = [OR(_object,nil)] call v_getTrackedVehicleIndex;
  if (_index < 0) exitWith {};

  //forward to HC
  ["untrackVehicle", _object] call sh_hc_forward;

  //diag_log format["%1 is being removed from the tracked list", _object];
  tracked_vehicles_list deleteAt _index;
};

//event handlers for object tracking, and untracking
"untrackVehicle" addPublicVariableEventHandler { [_this select 1] call v_untrackVehicle;};

fn_manualVehicleSave = {
  ARGVX2(0,_object);

  if (isSTRING(_object)) then {
    _object = objectFromNetId _object;
  };

  if (!isOBJECT(_object)) exitWith {};
  if (diag_tickTime - (_object getVariable ["vehSaving_lastSave", 0]) <= 5) exitWith {};

  _object setVariable ["vehSaving_lastUse", diag_tickTime, true];
  _object setVariable ["vehSaving_lastSave", diag_tickTime, true];
  [_object] call v_trackVehicle;
};


v_trackedVehiclesListCleanup = {
  //post cleanup the array
  init(_cleanup_start, diag_tickTime);
  init(_nulls,[]);
  init(_index,-1);
  init(_start_size,count(tracked_vehicles_list));
  while {true} do {
    _index = tracked_vehicles_list find objNull;
    if (_index < 0) exitWith {};
    tracked_vehicles_list deleteAt _index;
  };
  init(_end_size,count(tracked_vehicles_list));
  init(_cleanup_end, diag_tickTime);
  diag_log format["v_saveLoop: count(tracked_vehicles_list) = %1, %2 nulls deleted in %3 ticks", count(tracked_vehicles_list), (_start_size - _end_size), (_cleanup_end - _cleanup_start)];
};


//build list of object that should not be saved
v_skipList = [];
def(_obj);
{if (true) then {
  if (!isARRAY(_x) || {count(_x) == 0}) exitWith {};
  _obj = _x select 1;
  if (isOBJECT(_obj)) then {
    v_skipList pushBack _obj;
  };
  v_skipList pushBack _obj;
}} forEach [OR(civilianVehicles,[]), OR(call allVehStoreVehicles,[])];


v_isSaveable = {
  ARGVX4(0,_obj,objNull,false);

  //it's a wreck, don't save it
  if (not(alive _obj)) exitWith {false};

  //not a vehicle, don't save it
  if (not([_obj] call sh_isSaveableVehicle)) exitWith {false};

  def(_purchasedVehicle);
  def(_missionVehicle);
  def(_usedVehicle);
  def(_townVehicle);
  def(_usedOnce);


  _purchasedVehicle = ([_obj] call sh_isAPurchasedVehicle);
  _missionVehicle = ([_obj] call sh_isAMissionVehicle);
  _staticWeapon = [_obj] call sh_isStaticWeapon;
  _townVehicle = not(_missionVehicle || {_purchasedVehicle || {_staticWeapon}});
  _usedOnce = not([_obj] call v_isVehicleVirgin);

  //diag_log format["%1, _purchasedVehicle = %2, _missionVehicle = %3, _usedOnce = %4, _townVehicle = %5, _staticWeapon = %6",_obj, _purchasedVehicle,_missionVehicle,_usedOnce,_townVehicle, _staticWeapon];

  //it's a purchased vehicle, and saving purchased vehicles has been enabled, save it
  if (_purchasedVehicle && {cfg_purchasedVehicleSaving_on}) exitWith {true};

  //it's a mission spawned vehicle, and saving mission vehicles has been enabled, save it
  if (_missionVehicle && {cfg_missionVehicleSaving_on}) exitWith {true};

  //if it's a static weapon, and saving static weapons has been enabled, save it
  if (_staticWeapon && {cfg_staticWeaponSaving_on}) exitWith {true};

  //if it's a town vehicle that has been used at least once, save it
  if (_townVehicle && {_usedOnce && {cfg_townVehicleSaving_on}}) exitWith {true};

  false
};


v_trackVehicleHoursAlive = {
  ARGVX3(0,_obj,objNull);

  def(_spawnTime);
  def(_hoursAlive);

  _spawnTime = _obj getVariable "baseSaving_spawningTime";
  _hoursAlive = _obj getVariable "baseSaving_hoursAlive";

  if (isNil "_spawnTime") then {
    _spawnTime = diag_tickTime;
    _obj setVariable ["baseSaving_spawningTime", _spawnTime, true];
  };

  if (isNil "_hoursAlive") then {
    _hoursAlive = 0;
    _obj setVariable ["baseSaving_hoursAlive", _hoursAlive, true];
  };

  def(_totalHours);
  _totalHours = _hoursAlive + (diag_tickTime - _spawnTime) / 3600;

  (_totalHours)
};

v_trackVehicleHoursAbandoned = {
  ARGVX3(0,_obj,objNull);

  //if the vehicle is not empty, it can't possibly be abandoned
  if (not([_obj] call v_isVehicleEmpty)) exitWith {0};

  //if the vehicle has never been used, it's not technically abandoned, just un-used
  if (isNil{_obj getVariable "vehicle_first_user"}) exitWith {0};

  /*
   * past this point, we know for sure that the vehicle is in 'abandoned' state
   * which means that it has been used at least once, and left empty somewhere
   * by a player
   */

  def(_hoursAbandoned);
  def(_abandonedTime);

  _abandonedTime = _obj getVariable "vehicle_abandoned_time";
  _hoursAbandoned = _obj getVariable "vehicle_abandoned_hours";

  if (!isSCALAR(_abandonedTime)) then {
    _abandonedTime = diag_tickTime;
    _obj setVariable ["vehicle_abandoned_time", _abandonedTime, true];
  };

  if (!isSCALAR(_hoursAbandoned)) then {
    _hoursAbandoned = 0;
    _obj setVariable ["vehicle_abandoned_hours", _hoursAbandoned, true];
  };


  def(_totalHours);
  _totalHours = _hoursAbandoned + (diag_tickTime - _abandonedTime) / 3600;

  (_totalHours)
};

v_setupVehicleSavedVariables = {
  ARGVX3(0,_obj,objNull);
  ARGVX3(1,_variables,[]);

  def(_ownerUID);
  _ownerUID = _obj getVariable ["ownerUID", nil];
  if (isSTRING(_ownerUID) && {_ownerUID != ""}) then {
    _variables pushBack ["ownerUID", _ownerUID];;
  };

  def(_ownerN);
  _ownerN = _obj getVariable ["ownerN", nil];
  if (isSTRING(_ownerN) && {_ownerN != ""}) then {
    _variables pushBack ["ownerN", _ownerN];
  };

  def(_firstUser);
  _firstUser = _obj getVariable ["vehicle_first_user", nil];
  if (isSTRING(_firstUser) && {_firstUser != ""}) then {
    _variables pushBack ["vehicle_first_user", _firstUser];
  };

  _variables pushBack ["vehicle_abandoned_by", (_obj getVariable "vehicle_abandoned_by")];
  _variables pushBack ["A3W_purchasedVehicle", (_obj getVariable ["A3W_purchasedVehicle",false])];
  _variables pushBack ["A3W_missionVehicle", (_obj getVariable ["A3W_missionVehicle",false])];



  def(_r3fSide);
  _r3fSide = _obj getVariable "R3F_Side";
  if (isSIDE(_r3fSide)) then {
    _variables pushBack ["R3F_Side", str _r3fSide];
  };

  if ([_obj] call sh_isBoomerang) then {
    _variables pushBack ["has_boomerang", (_obj getVariable "has_boomerang")];
    _variables pushBack ["boomerang_owner_type", (_obj getVariable "boomerang_owner_type")];
    _variables pushBack ["boomerang_owner_value", (_obj getVariable "boomerang_owner_value")];
  };

  _variables pushBack ["A3W_objectTextures", (_obj getVariable ["A3W_objectTextures",[]])];

};


v_getSavePosition = {
  ARGVX3(0,_obj,objNull);

  def(_pos);
  _pos = ASLtoATL getPosWorld _obj;
  _pos set [2, (_pos select 2) + 0.3];

  def(_on_ground);
  _on_ground = isTouchingGround _obj;

  def(_flying);
  _flying = [_obj] call sh_isFlying;

  //diag_log format["_flying = %1, _on_ground = %2", _flying, _on_ground];

  if ([_obj] call sh_isUAV && {_flying}) exitWith {_pos}; //save flying UAVs as-is
  if (_on_ground) exitWith {_pos}; //directly in contact with ground, or on a roof
  if ((getPos _obj) select 2 < 0.5) exitWith {_pos}; //FIXME: not exactly sure what this one is for
  if ((getPosASL _obj) select 2 < 0.5) exitWith {_pos}; //underwater

  //force the Z-axis if the vehicle is high above ground, or deep underwater (bring it to the surface)
  _pos set [2, 0];
  if (surfaceIsWater _pos) then {
    _pos = ASLToATL (_pos);
  };

  (_pos)
};

v_addSaveVehicle = {
  ARGVX3(0,_list,[]);
  ARGVX3(1,_obj,objNull);
  ARGV4(2,_hashify,false,true);

  if (not([_obj] call v_isSaveable)) exitWith {};

  def(_class);
  def(_netId);
  def(_pos);
  def(_dir);
  def(_damage);
  def(_hoursAlive);
  def(_hoursAbandoned);

  _class = typeOf _obj;
  _netId = netId _obj;
  _dir = [vectorDir _obj, vectorUp _obj];
  _damage = damage _obj;

  _hoursAlive = [_obj] call v_trackVehicleHoursAlive;
  _hoursAbandoned = [_obj] call v_trackVehicleHoursAbandoned;

  //diag_log format["%1: _hoursAlive = %2", _obj,_hoursAlive];
  //diag_log format["%1: _hoursAbandoned = %2", _obj,_hoursAbandoned];

  def(_variables);
  _variables = [];
  [_obj,_variables] call v_setupVehicleSavedVariables;


  init(_weapons,[]);
  init(_magazines,[]);
  init(_items,[]);
  init(_backpacks,[]);

  // Save weapons & ammo
  _weapons = (getWeaponCargo _obj) call cargoToPairs;
  _magazines = (getMagazineCargo _obj) call cargoToPairs;
  _items = (getItemCargo _obj) call cargoToPairs;
  _backpacks = (getBackpackCargo _obj) call cargoToPairs;



  def(_all_turrets);
  _all_turrets = [_obj] call sh_getVehicleTurrets;
  init(_turret0,_all_turrets select 0);
  init(_turret1,_all_turrets select 1);
  init(_turret2,_all_turrets select 2);


  init(_hitPoints,[]);
  {
    _hitPoint = configName _x;
    _hitPoints pushBack [_hitPoint, _obj getHitPointDamage _hitPoint];
  } forEach (_obj call getHitPoints);

  init(_ammoCargo,getAmmoCargo _obj);
  init(_fuelCargo,getFuelCargo _obj);
  init(_repairCargo,getRepairCargo _obj);
  init(_fuel, fuel _obj);

  def(_objName);
  _objName = _obj getVariable ["vehicle_key", nil];

  if (isNil "_objName") then {
    _objName = format["veh_%1_%2",ceil(time), ceil(random 10000)];
    _obj setVariable ["vehicle_key", _objName, true];
  };

  _pos = [_obj] call v_getSavePosition;

  def(_lock_state);
  _lock_state = locked _obj;
  
  def(_result);
  _result = [
    ["Class", _class],
    ["Position", _pos],
    ["Direction", _dir],
    ["HoursAlive", _hoursAlive],
    ["HoursAbandoned", _hoursAbandoned],
    ["Damage", _damage],
    ["Fuel", _fuel],
    ["Variables", _variables],
    ["Weapons", _weapons],
    ["Magazines", _magazines],
    ["Items", _items],
    ["Backpacks", _backpacks],
    ["TurretMagazines", OR(_turret0,nil)],
    ["TurretMagazines2", OR(_turret1,nil)],
    ["TurretMagazines3", OR(_turret2,nil)],
    ["AmmoCargo", _ammoCargo],
    ["FuelCargo", _fuelCargo],
    ["RepairCargo", _repairCargo],
    ["Hitpoints", _hitPoints],
    ["LockState", _lock_state]
  ];

  _result = if (_hashify) then {_result call sock_hash} else {_result};
  _list pushBack [_objName, _result];

  true
};

v_isVehicleEmpty = {
  ARGVX4(0,_obj,objNull,false);
  not({isPlayer _x} count crew _obj > 0 || isPlayer ((uavControl _obj) select 0))
};

//a virgin vehicle is one that no-one has ever used
v_isVehicleVirgin = {
  ARGVX4(0,_obj,objNull,false);
  (isNil {_obj getVariable "vehicle_first_user"})
};

v_GetIn_handler = {
  //diag_log format["%1 call v_GetIn_handler", _this];
  ARGVX3(0,_obj,objNull);
  ARGVX3(2,_player,objNull);

  //only track players
  if (!(isPlayer _player)) exitWith {};
  init(_uid,getPlayerUID _player);

  if ([_obj] call v_isVehicleVirgin) then {
    _obj setVariable ["vehicle_first_user", _uid, true];
  };

  //diag_log format["%1 entered vehicle by %2", _obj, _player];
  _obj setVariable ["vehicle_abandoned_by", nil, true];
  _obj setVariable ["vehicle_abandoned_time", nil, true];
  _obj setVariable ["vehicle_abandoned_hours", nil, true];

  [_obj] call v_trackVehicle;
};


"trackGetInVehicle" addPublicVariableEventHandler {
  diag_log format["%1 call trackGetInVehicle", _this];
  ARGVX3(1,_this,[]);
  _this call v_GetIn_handler;
};


v_GetOut_handler = {
  //diag_log format["%1 call v_GetOut_handler", _this];
  ARGVX3(0,_obj,objNull);
  ARGVX3(2,_player,objNull);

  //only track players
  if (!(isPlayer _player)) exitWith {};
  init(_uid,getPlayerUID _player);

  //in case the player was already inside the vehicle ... (the get-in handler did not catch it)
  if ([_obj] call v_isVehicleVirgin) then {
    _obj setVariable ["vehicle_first_user", _uid, true];
  };

  if ([_obj] call v_isVehicleEmpty) then {
    //diag_log format["%1 left abandoned by %2", _obj, _player];
    _obj setVariable ["vehicle_abandoned_by", _uid, true];
    _obj setVariable ["vehicle_abandoned_time", diag_tickTime, true];
    _obj setVariable ["vehicle_abandoned_hours", nil, true]; //start counting the hours form 0 again

  };
};

"trackGetOutVehicle" addPublicVariableEventHandler {
  diag_log format["%1 call trackGetOutVehicle", _this];
  ARGVX3(1,_this,[]);
  _this call v_GetOut_handler;
};

v_saveAllVechiles = {
  ARGVX3(0,_scope,"");
  init(_count,0);
  init(_request,[_scope]);

  [_scope] call stats_wipe;
  init(_bulk_size,100);
  init(_start_time, diag_tickTime);
  init(_last_save, diag_tickTime);


  {
    if (!isNil{[_request, _x] call v_addSaveVehicle}) then {
      _count = _count + 1;
    };

    //save vehicles in bulks
    if ((_count % _bulk_size) == 0 && {count(_request) > 1}) then {
      init(_save_start, diag_tickTime);
      _request call stats_set;
      init(_save_end, diag_tickTime);
      _request = [_scope];
      diag_log format["v_saveLoop: %1 vehicles saved in %2 ticks, save call took %3 ticks", (_bulk_size), (diag_tickTime - _start_time), (_save_end - _save_start)];
      _last_save = _save_end;
    };
  } forEach (tracked_vehicles_list);

  if (count(_request) > 1) then {
    init(_save_start, diag_tickTime);
    _request call stats_set;
    init(_save_end, diag_tickTime);
    diag_log format["v_saveLoop: %1 vehicles saved in %2 ticks, save call took %3 ticks", (count(_request) -1), (_save_end - _last_save), (_save_end - _save_start)];
  };

  diag_log format["v_saveLoop: total of %1 vehicles saved in %2 ticks", (_count), (diag_tickTime - _start_time)];

  call v_trackedVehiclesListCleanup;
};

v_saveLoop_iteration = {
  ARGVX3(0,_scope,"");
  diag_log format["v_saveLoop: Saving all objects ... "];
  [[_scope], v_saveAllVechiles] call sh_fsm_invoke;
  diag_log format["v_saveLoop: Saving all objects complete"];
};


v_saveLoop_iteration_hc = {
  ARGVX3(0,_scope,"");

  init(_hc_id,owner HeadlessClient);
  diag_log format["v_saveLoop: Offloading vehicles saving to headless client (id = %1)", _hc_id];

  v_saveLoop_iteration_hc_handler = [_scope];
  _hc_id publicVariableClient "v_saveLoop_iteration_hc_handler";

  call v_trackedVehiclesListCleanup;
};

if (!(hasInterface || isDedicated)) then {
  diag_log format["Setting up HC handler for objects"];
  "v_saveLoop_iteration_hc_handler" addPublicVariableEventHandler {
    //diag_log format["v_saveLoop_iteration_hc_handler = %1", _this];
    ARGVX3(1,_this,[]);
    ARGVX3(0,_scope,"");
    _this spawn v_saveLoop_iteration;
  };
};


v_saveLoop = {
  ARGVX3(0,_scope,"");
  while {true} do {
    sleep A3W_vehicle_saveInterval;
    if (not(isBOOLEAN(v_saveLoopActive) && {!v_saveLoopActive})) then {
      if (call sh_hc_ready) then {
        [_scope] call v_saveLoop_iteration_hc;
      }
      else {
        [_scope] call v_saveLoop_iteration;
      };
    };
  };
};

v_loadVehicles = {
  ARGVX3(0,_scope,"");

  def(_vehicles);
  _vehicles = [_scope] call stats_get;

  init(_vIds,[]);


  //nothing to load
  if (!isARRAY(_vehicles)) exitWith {
    diag_log format["WARNING: No vehicles loaded from the database"];
    _vIds
  };

  diag_log format["A3Wasteland - will restore %1 vehicles", count(_vehicles)];
  {
    _vIds pushBack (_x select 0);
    [_x] spawn v_restoreVehicle;
  } forEach _vehicles;

  v_loadVehicles_complete = true;

 ["tracked_vehicles_list"] call sh_hc_forward; //forward to headless client (if connected)


  (_vIds)
};

diag_log "vFunctions.sqf loading complete";
