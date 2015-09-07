//	@file Name: functions.sqf
//	@file Author: IvanMMM, micovery, AgentRev

private ["_perm", "_uav", "_connected"];
_perm = ["A3W_uavControl", "side"] call getPublicVar;

if (_perm == "side") exitWith {};

while {true} do
{
	waitUntil {sleep 0.1; _uav = getConnectedUAV player; !isNull _uav};


  _connected = true;
	// ignore quadcopters and remote designators
	if ({_uav isKindOf _x} count ["StaticWeapon"] == 0) then
	{
		_ownerUID = _uav getVariable ["ownerUID", ""];
		if (_ownerUID == "") exitWith {}; // UAV not owned by anyone
		if (getPlayerUID player == _ownerUID) exitWith {};
		if (_perm == "group" && {{getPlayerUID _x == _ownerUID} count units player > 0}) exitWith {};

    _connected = false;

		player connectTerminalToUAV objNull;
		playSound "FD_CP_Not_Clear_F";
		["You are not allowed to connect to this unmanned vehicle.", 5] call mf_notify_client;
	};

  //artifical GetIn event handler for UAVs
	if (_connected && {!isNull _uav}) then {
	  trackGetInVehicle = [_uav, getPos _uav, player, nil];
	  publicVariableServer "trackGetInVehicle";
	};

	waitUntil {sleep 0.1; _uav != getConnectedUAV player};

  //artificial GetOut event handler for UAVs
	if (_connected && {!isNull _uav}) then {
    trackGetOutVehicle = [_uav, getPos _uav, player, nil];
    publicVariableServer "trackGetOutVehicle";
  };

};
