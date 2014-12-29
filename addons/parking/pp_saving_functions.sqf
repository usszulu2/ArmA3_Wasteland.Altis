if (!isNil "parking_saving_functions_defined") exitWith {};
diag_log format["Loading parking saving functions ..."];

#include "macro.h"

if (not(isClient)) then {
  pp_notify = {
    diag_log format["%1 call pp_notify", _this];
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_msg,"");



    pp_notify_request = _msg;
    (owner _player) publicVariableClient "pp_notify_request";
  };

  pp_park_vehicle_request_handler = {
    ARGVX3(1,_this,[]);
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_vehicle,objNull);

    if (not(alive _vehicle)) exitWith {};

    def(_uid);
    _uid = getPlayerUID _player;

    diag_log format["Parking vehicle %1(%2) for player %3(%4)", typeOf _vehicle, netId _vehicle,  (name _player), _uid];

    def(_parked_vehicles);
    _parked_vehicles = _player getVariable "parked_vehicles";
    _parked_vehicles = OR(_parked_vehicles,[]);

    def(_added);
    _added = [_parked_vehicles, _vehicle, false] call v_addSaveVehicle;
    if (isNil "_added") exitWith {
      diag_log format["ERROR: Could not park vehicle %1(%2) for player %3(%4)", typeOf _vehicle, netId _vehicle,  (name _player), _uid];
      [_player, format["ERROR: %1, your vehicle could not be parked. Please report this error to the server administrator.", (name _player)]] call pp_notify;
    };

    def(_display_name);
    _display_name = [typeOf _vehicle] call generic_display_name;

    deleteVehicle _vehicle;

    _player setVariable ["parked_vehicles", _parked_vehicles, true];
    [_player, format["%1, your %2 has been parked.", (name _player), _display_name]] call pp_notify;
  };

  pp_retrieve_vehicle_request_handler = {
    ARGVX3(1,_this,[]);
    ARGVX3(0,_player,objNull);
    ARGVX3(1,_vehicle_id, "");

    def(_uid);
    _uid = getPlayerUID _player;

    diag_log format["Retrieving parked vehicle %1 for player %2(%3)", _vehicle_id,  (name _player), _uid];

    def(_parked_vehicles);
    _parked_vehicles = _player getVariable "parked_vehicles";
    _parked_vehicles = OR(_parked_vehicles,[]);

    def(_vehicle_data);
    _vehicle_data = [_parked_vehicles, _vehicle_id] call fn_getFromPairs;

    if (!isARRAY(_vehicle_data)) exitWith {
      diag_log format["ERROR: Could not retrieve vehicle %1 for player %2(%3)", _vehicle_id,  (name _player), _uid];
      [_player, format["ERROR: %1, your vehicle (%2) could not be retrieved. Please report this error to the server administrator.", (name _player), _vehicle_id]] call pp_notify;
    };

    def(_vehicle);
    _vehicle = [[_vehicle_id, _vehicle_data], true] call v_restoreVehicle;

    if (isNil "_vehicle") exitWith {
      diag_log format["ERROR: Could not restore vehicle %1 for player %2(%3)", _vehicle_id,  (name _player), _uid];
      [_player, format["ERROR: %1, your vehicle (%2) could not be restored. Please report this error to the server administrator.", (name _player), _vehicle_id]] call pp_notify;
    };

    [_parked_vehicles, _vehicle_id] call fn_removeFromPairs;
    _player setVariable ["parked_vehicles", _parked_vehicles, true];

    def(_display_name);
    _display_name = [typeOf _vehicle] call generic_display_name;
    [_player, format["%1, your %2 has been retrieved.", (name _player), _display_name]] call pp_notify;
  };

  "pp_park_vehicle_request" addPublicVariableEventHandler {_this call pp_park_vehicle_request_handler;};
  "pp_retrieve_vehicle_request" addPublicVariableEventHandler {_this call pp_retrieve_vehicle_request_handler;};

};

if (isClient) then {
  pp_notify_request_handler = {
    //diag_log format["%1 call pp_notify_request_handler", _this];
    ARGVX3(1,_msg,"");
    player groupChat _msg;
  };

  "pp_notify_request" addPublicVariableEventHandler {_this call pp_notify_request_handler;};

  pp_park_vehicle = {
    pp_park_vehicle_request = _this;
    publicVariableServer "pp_park_vehicle_request";
  };

  pp_retrieve_vehicle = {
    pp_retrieve_vehicle_request = _this;
    publicVariableServer "pp_retrieve_vehicle_request";
  };
};


diag_log format["Loading parking saving functions complete"];
parking_saving_functions_defined = true;