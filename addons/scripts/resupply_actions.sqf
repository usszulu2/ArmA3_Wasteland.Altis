
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



uav_resupply_watch = {
  diag_log format["%1 call uav_resupply_watch", _this];
  private["_uavCheck"];
  _uavCheck = {
    private["_uav"];
    _uav = getConnectedUAV player;
    (!(isNull _uav) && {(count(nearestObjects [getPos _uav, resupply_vehicles, 10]) > 0)})
  };

  waitUntil {
    waitUntil {sleep 3; (call _uavCheck)};
    private["_uav"];
    _uav = getConnectedUAV player;
    _uav addAction ["<img image='client\icons\repair.paa'/>  Resupply UAV", {_this call do_resupply;}, _uav, 10,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"];
    waitUntil {sleep 3; not(call _uavCheck)};
    removeAllActions _uav;
    sleep 3;
 };
};

static_weapon_resupply_watch = {
  diag_log format["%1 call static_weapon_resupply_watch", _this];
  private["_staticCheck"];
  _staticCheck = {
    private["_static"];
    _static = cursorTarget;
    if !(!isNull _static && { _static isKindOf "StaticWeapon" &&  {(count(nearestObjects [getPos _static, resupply_vehicles, 10]) > 0)}}) exitWith {
      nil
    };
    _static
  };

  private["_static"];
  waitUntil {
    waitUntil { sleep 3; _static = call _staticCheck; !isNil "_static"};
    _static addAction ["<img image='client\icons\repair.paa'/>  Resupply Static Weapon", {_this call do_resupply;}, _static, 10,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"];
    waitUntil { sleep 3; isNil {call _staticCheck}};
    removeAllActions _static;
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
         not(_vehicle isKindOf "StaticWeapon") && {
         (count(nearestObjects [getPos _vehicle, resupply_vehicles, 10]) > 0)}}}) exitWith {
      nil
    };
    _vehicle
  };

  private["_vehicle"];
  waitUntil {
    waitUntil { sleep 3; _vehicle = call _vehicleCheck; !isNil "_vehicle"};
    _vehicle addAction ["<img image='client\icons\repair.paa'/>  Resupply vehicle", {_this call do_resupply;}, _vehicle, 10,false,true,"", "(isNil 'mutexScriptInProgress' || {not(mutexScriptInProgress)})"];
    waitUntil { sleep 3; isNil {call _vehicleCheck}};
    removeAllActions _vehicle;
    sleep 3;
 };
};

[] spawn uav_resupply_watch;
[] spawn static_weapon_resupply_watch;
[] spawn vehicle_resupply_watch;
