// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: server\donators.sqf

if (!isServer) exitWith {};

if (loadFile (externalConfigFolder + "\donators.sqf") != "") then
{
	call compile preprocessFileLineNumbers (externalConfigFolder + "\donators.sqf");
}
else
{

	/*******************************************************
	 Player UID examples :

		"1234567887654321", // Meatwad
		"8765432112345678", // Master Shake
		"1234876543211234", // Frylock
		"1337133713371337"  // Carl

	 Important: The player UID must always be placed between
	            double quotes (") and all lines need to have
	            a comma (,) except the last one.
	********************************************************/

	// Low Donator
	lowDonators = compileFinal str
	[
		// Put player UIDs here
	];

	// Mid Donator
	midDonators = compileFinal str
	[
		// Put player UIDs here
	];

	// High Donator
	highDonators = compileFinal str
	[
		// Put player UIDs here
	];

	/********************************************************/
};

if (typeName lowDonators == "ARRAY") then { lowDonators = compileFinal str lowDonators };
if (typeName midDonators == "ARRAY") then { midDonators = compileFinal str midDonators };
if (typeName highDonators == "ARRAY") then { highDonators = compileFinal str highDonators };

publicVariable "lowDonators";
publicVariable "midDonators";
publicVariable "highDonators";
