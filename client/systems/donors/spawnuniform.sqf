// ******************************************************************************************
// * This file will add a custom uniform to donors that are specified in admins.sqf when U is pressed*
// ******************************************************************************************
//	@file Name: \client\systems\donor\spawnuniform.sqf

private ["_player", "_uniform"];
_player = _this;

if (!(isDedicated)) then 
{
	waitUntil {!(isNull player)};
	player addEventHandler ["inventoryOpened","_nul=execVM 'client\systems\donors\glue.sqf'"];
};
	[] spawn
{
while {true} do
	{
		_player addUniform "U_I_Protagonist_VR";
		_player setObjectTextureGlobal [0,"client\systems\donors\donoruniform.paa"];
		waitUntil {uniform player != "U_I_Protagonist_VR"};
	};
};