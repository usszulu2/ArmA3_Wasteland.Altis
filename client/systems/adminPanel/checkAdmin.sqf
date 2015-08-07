// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.1
//	@file Name: checkAdmin.sqf
//	@file Author: [404] Deadbeat, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_uid","_handle"];
_uid = getPlayerUID player;
_uniform = uniform _unit

if (!isNull (uiNamespace getVariable ["AdminMenu", displayNull]) && !(player call A3W_fnc_isUnconscious)) exitWith {};

switch (true) do
{
	case ([_uid, serverOwners] call isAdmin || isServer):
	{
		execVM "client\systems\adminPanel\loadServerAdministratorMenu.sqf";
		hint "Welcome Boss";
	};
	case ([_uid, highAdmins] call isAdmin):
	{
		execVM "client\systems\adminPanel\loadAdministratorMenu.sqf";
		hint "Welcome Admin";
	};
	case ([_uid, lowAdmins] call isAdmin):
	{
		execVM "client\systems\adminPanel\loadModeratorMenu.sqf";
		hint "Welcome Moderator";
	};
	case ([_uid, serverDonors] call isAdmin):
	{
		if (player _uniform == "U_I_Protagonist_VR") 
			then {
				hint "You're already wearing a donor uniform, dufus.";
			};
		else {
			hint "Uniform being spawned in 10 seconds. If you have gear in your uniform, move it out now.";
			sleep 10;
			execVM "client\systems\donors\spawnuniform.sqf";
			hint "Uniform added. It has been superglued to your body.";
			};
		};
	};
	case (serverCommandAvailable "#kick"):
	{
		execVM "client\systems\adminPanel\loadServerAdministratorMenu.sqf";
		hint "Welcome Boss";
	};
};
