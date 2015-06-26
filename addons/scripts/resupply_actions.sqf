
A3W_fnc_setVehicleAmmoDef = {
  private["_left", "_right"];
  _left = _this select 0;
  _right  = _this select 1;
  if (isNil "_left" || { typeName _left != typeName objNull || { isNull _left}}) exitWith {};
  if (isNil "_right" || { typeName _right != typeName 0}) exitWith {};
  diag_log format["%1 call A3W_fnc_setVehicleAmmoDef--->", _this];
  _left setVehicleAmmoDef _right;
};

A3W_fnc_removeMagazinesTurret = {
  private["_left", "_right"];
  _left = _this select 0;
  _right  = _this select 1;
  if (isNil "_left" || { typeName _left != typeName objNull || { isNull _left}}) exitWith {};
  if (isNil "_right" || { typeName _right != typeName []}) exitWith {};
  _left removeMagazineTurret _right;
};

A3W_fnc_addMagazineTurret = {
  private["_left", "_right"];
  _left = _this select 0;
  _right  = _this select 1;
  if (isNil "_left" || { typeName _left != typeName objNull || { isNull _left}}) exitWith {};
  if (isNil "_right" || { typeName _right != typeName []}) exitWith {};
  _left addMagazineTurret _right;
};

if (isServer) exitWith {};

resupply_vehicles = [
  'O_Heli_Transport_04_ammo_F',
  'I_Truck_02_ammo_F',
  'O_Truck_03_ammo_F',
  'B_Truck_01_ammo_F'
];

do_resupply = {
  (_this select 3) execVM "addons\scripts\fn_resupplytruck.sqf";
};


#define VEHICLE_NAME(x) (getText ((configFile >> "CfgVehicles" >> (typeOf x)) >> "displayName"))

uav_resupply_watch = {
  diag_log format["%1 call uav_resupply_watch", _this];
  private["_uavCheck"];
  _uavCheck = {
    private["_uav", "_action_id"];
    _uav = getConnectedUAV player;
    (!(isNull _uav) && {(count(nearestObjects [getPos _uav, resupply_vehicles, 15]) > 0)})
  };

  waitUntil {
    waitUntil {sleep 3; (call _uavCheck)};
    private["_uav"];
    _uav = getConnectedUAV player;
    _action_id = _uav addAction [
      format["<img image='client\icons\repair.paa'/> Resupply %1",VEHICLE_NAME(_uav)],
      {_this call do_resupply;}, _uav, 15,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"
    ];
    waitUntil {sleep 3; not(call _uavCheck)};
    _uav removeAction _action_id;
    sleep 3;
 };
};

static_weapon_resupply_watch = {
  diag_log format["%1 call static_weapon_resupply_watch", _this];
  private["_staticCheck"];
  _staticCheck = {
    private["_static"];
    _static = (vehicle player);
    if (not(isNull _static) && {
         _static isKindOf "StaticWeapon" && {
         player == gunner(_static) && {
         (count(nearestObjects [getPos _static, resupply_vehicles, 15]) > 0)}}}) exitWith {
      _static
    };
    nil
  };

  private["_static", "_action_id"];
  waitUntil {
    waitUntil { sleep 3; _static = call _staticCheck; !isNil "_static"};
    _action_id = _static addAction [
      format["<img image='client\icons\repair.paa'/> Resupply %1",VEHICLE_NAME(_static)],
      {_this call do_resupply;}, _static, 15,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"
    ];
    waitUntil { sleep 3; isNil {call _staticCheck}};
    _static removeAction _action_id;
    sleep 3;
 };
};

vehicle_resupply_watch = {
  diag_log format["%1 call vehicle_resupply_watch", _this];
  private["_vehicleCheck"];
  _vehicleCheck = {
    private["_vehicle"];
    _vehicle = (vehicle player);
    if !(!isNull _vehicle && {
         player != _vehicle && {
         player == driver(_vehicle) && {
         not(_vehicle isKindOf "StaticWeapon") && {
         (count(nearestObjects [getPos _vehicle, resupply_vehicles, 15]) > 0)}}}}) exitWith {
      nil
    };
    _vehicle
  };

  private["_vehicle", "_action_id"];
  waitUntil {
    waitUntil { sleep 3; _vehicle = call _vehicleCheck; !isNil "_vehicle"};
    _action_id = _vehicle addAction [
      format["<img image='client\icons\repair.paa'/> Resupply %1",VEHICLE_NAME(_vehicle)],
      {_this call do_resupply;}, _vehicle, 15,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"
    ];
    waitUntil { sleep 3; isNil {call _vehicleCheck}};
    _vehicle removeAction _action_id;
    sleep 3;
 };
};

[] spawn uav_resupply_watch;
[] spawn static_weapon_resupply_watch;
[] spawn vehicle_resupply_watch;
