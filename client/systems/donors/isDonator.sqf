// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: isDonator.sqf
//	@file Author: AgentRev
//	@file Created: 13/06/2013 18:02

private ["_result", "_findUIDinArray"];
_result = false;

_findUIDinArray =
{
	private ["_uid", "_DonatorType", "_DonatorList", "_found"];

	_uid = _this select 0;
	_donatorType = _this select 1;
	_DonatorList = [];
	_found = false;

	switch (typeName _donatorType) do
	{
		case (typeName {}):	{ _DonatorList = call _donatorType };
		case (typeName []):	{ _DonatorList = _donatorType };
		case (typeName 0):
		{
			switch (_donatorType) do
			{
				case 1:
				{
					_DonatorList = call lowDonators;
				};
				case 2:
				{
					_DonatorList = call midDonators;
				};
				case 3:
				{
					_DonatorList = call highDonators;
				};
			};
		};
	};

	_found || _uid in _DonatorList
};

if (typeName _this == "ARRAY") then
{
	_result = _this call _findUIDinArray;
}
else
{
	for "_i" from 1 to 3 do
	{
		_result = (_result || [_this, _i] call _findUIDinArray);
	};
};

_result
