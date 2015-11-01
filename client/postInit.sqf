// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2015 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: postInit.sqf
//	@file Author: AgentRev

if (hasInterface) then
{
	waitUntil {!isNull player};
	player setVariable ["playerSpawning", true, true];
	_uid = getPlayerUID player;
    _donorUID = ServerDonors;

    	for "_i" from 0 to count _donorUID do
    		{
    			if (_uid == (_donorUID select _i)) then
    				{
    					player setVariable ["isDonator", 1];
    				};
    		};
};

