// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: playerSetup.sqf
//	@file Author: AgentRev

private ["_uid","_handle"];
_uid = getPlayerUID player;

if ([_uid, serverDonors] call isAdmin || isServer) then
	{
		_this call playerSetupStart;
		_this call playerSetupDonorGear;
		_this call playerSetupEnd;
	} else {
		_this call playerSetupStart;
		_this call playerSetupGear;
		_this call playerSetupEnd;
	};