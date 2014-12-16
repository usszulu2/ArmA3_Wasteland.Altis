if (!isNil "shFunctions_loased") exitWith {};
diag_log "shFunctions loading ...";

#include "macro.h"

call compile preProcessFileLineNumbers "persistence\lib\normalize_config.sqf";

sh_isSaveableVehicle = {
  ARGVX4(0,_obj,objNull,false);

  init(_result, false);
  {
    if (_obj isKindOf _x) exitWith {
      _result = true;
    };
  } forEach A3W_saveable_vehicles_list;

  (_result)
};

sh_strToSide = {
  def(_result);
  _result = switch (toUpper _this) do {
    case "WEST":  { BLUFOR };
    case "EAST":  { OPFOR };
    case "GUER":  { INDEPENDENT };
    case "CIV":   { CIVILIAN };
    case "LOGIC": { sideLogic };
    default       { sideUnknown };
  };
  (_result)
};


sh_restoreVariables = {
  ARGVX3(0,_obj,objNull);
  ARGVX3(1,_variables,[]);

  def(_name);
  def(_value);

  {
    _name = _x select 0;
    _value = _x select 1;

    if (!isNil "_value") then {
      switch (_name) do {
        case "side": { _value = _value call sh_strToSide};
        case "R3F_Side": { _value = _value call sh_strToSide };
        case "ownerName": {
          switch (typeName _value) do {
            case "ARRAY": { _value = toString _value };
            case "STRING": { /* do nothing, it's already a string */ };
            default { _value = "[Unknown]" };
          };
        };
      };
    };

    _obj setVariable [_name, OR(_value,nil), true];
  } forEach _variables;
};

sh_isStaticWeapon = {
  ARGVX4(0,_obj,objNull,false);
  init(_class,typeOf _obj);
  (_class isKindOf "StaticWeapon")
};

sh_isBeacon = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["a3w_spawnBeacon", false])
};

sh_isCamera = {
  ARGVX4(0,_obj,objNull,false);
  (_obj getVariable ["a3w_cctv_camera", false])
};

sh_isBox = {
  ARGVX4(0,_obj,objNull,false);
  init(_class,typeOf _obj);
  (_class isKindOf "ReammoBox_F")
};

sh_isWarchest = {
  ARGVX4(0,_obj,objNull,false);
  (
    _obj getVariable ["a3w_warchest", false] && {
    (_obj getVariable ["side", sideUnknown]) in [WEST,EAST]}
  )
};

sh_mineAmmo2Vehicle = {
  ARGVX3(0,_class,"");

  if (_class isKindOf "MineBase") exitWith {_class};
  _class = (([_class, "_"] call BIS_fnc_splitString) select 0);

  //hopefully after splitting, and taking the first part, we have the actual vehicle class name
  (_class)
};

sh_isSaveableMine ={
  ARGVX2(0,_arg);
  
  def(_class);
  if (isOBJECT(_arg)) then {
    _class = typeOf _arg;
  }
  else { if(isSTRING(_arg)) then {
    _class = _arg;
  };};
  
  if (isNil "_class") exitWith {false};
  
  if (_class in minesList) exitWith {true};
};


sh_isMine = {
  ARGVX2(0,_arg);

  def(_class);
  if (isOBJECT(_arg)) then {
    _class = typeOf _arg;
  }
  else { if(isSTRING(_arg)) then {
    _class = _arg;
  };};

  if (isNil "_class") exitWith {false};

  if (_class isKindOf "MineBase") exitWith {true};

  //try conveting to the vehicle class
  _class = [_class] call sh_mineAmmo2Vehicle;

  (_class isKindOf "MineBase")
};

sh_isAMissionVehicle = {
  ARGVX4(0,_obj,objNull,false);
  def(_mission);
  _mission = _obj getVariable "A3W_missionVehicle";
  (isBOOLEAN(_mission) && {_mission})
};


sh_isAPurchasedVehicle = {
  ARGVX4(0,_obj,objNull,false);
  def(_purchased);
  _purchased = _obj getVariable "A3W_purchasedVehicle";
  (isBOOLEAN(_purchased) && {_purchased})
};

sh_isUAV = {
  ARGVX4(0,_obj,objNull,false);
  (getNumber(configFile >> "CfgVehicles" >> typeOf _obj >> "isUav") > 0)
};



shFunctions_loased = true;
diag_log "shFunctions loading complete";