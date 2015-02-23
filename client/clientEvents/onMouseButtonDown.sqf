// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: onMouseButtonDown.sqf
//	@file Author: micovery, Gigatek
//	@file Created: 23/2/2015
//	@file Args:

private["_handled", "_display", "_button", "_x", "_y", "_shift", "_control"];

_handled = false;
_display = _this select 0;
_button = _this select 1;
_x = _this select 2;
_y = _this select 3;
_shift = _this select 4;
_control = _this select 5;


if (!_handled && (inputAction "LockTarget" > 0 || inputAction "LockTargets" > 0)) then {
  private["_cweapon"];
  _cweapon = currentWeapon player;
  if (_cweapon == "launch_Titan_short_F" || {
      _cweapon == "launch_I_Titan_short_F" || {
      _cweapon == "launch_O_Titan_short_F"}}) then {
    player groupChat format["Locking with Titan launchers is disabled. You have to manually guide the misile by aiming."];
    player action ["WeaponOnBack", player];
    _handled = true;
  };
};


_handled
