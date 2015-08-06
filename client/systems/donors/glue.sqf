// ******************************************************************************************
// * This file will disable removing uniform to prevent giving them out or continuing to spawn them*
// ******************************************************************************************
//	@file Name: \client\systems\donor\glue.sqf

waitUntil {!(isNull (findDisplay 602))};
while {!(isNull (findDisplay 602))} do {// Keep the "uniform slot" control on lockdown. Else there are loop holes. No pun intended.
	ctrlEnable [6331, false]; 
};