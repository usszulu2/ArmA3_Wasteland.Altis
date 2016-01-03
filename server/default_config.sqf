// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
// A3Wasteland config file
// You will need to shutdown the server to edit settings in this file!
// All saving is done via the server's profileNamespace by default; iniDBI will be automatically used if you have if installed
// if you have any doubts and/or questions about the mission find us at a3wasteland.com
// This file is overriden by the external file "A3Wasteland_settings\main_config.sqf" if present

// General settings
A3W_startHour = 4;                 // In-game hour at mission start (0 to 23)
A3W_timeMultiplierDay = 2.0;       // Sets the speed of time between 5 AM and 8 PM (for example, 6.0 means 6 hours in-game will pass in 1 real hour)
A3W_timeMultiplierNight = 4.0;     // Sets the speed of time between 8 PM and 5 AM
A3W_moonLight = 1;                 // Moon light during night (0 = no, 1 = yes)
A3W_teamPlayersMap = 1;            // Show all friendly players on the map at all times, regardless of difficulty level (0 = no, 1 = yes)
A3W_disableGlobalVoice = 1;        // Auto-switch channel to Direct communication whenever broadcasting voice on global (0 = no, 1 = yes, 2 = allow admin)
A3W_disableSideVoice = 1;          // Auto-switch channel to Direct communication whenever broadcasting voice on side (0 = no, 1 = block Ind team, 2 = block all teams)
A3W_antiHackUnitCheck = 1;         // Detect players who spawn unauthorized AI units (0 = no, 1 = yes) - disable if you have custom unit scripts/mods like AI recruitment or ALiVE
A3W_antiHackMinRecoil = 1.0;       // Mininum recoil coefficient enforced by the antihack (recommended values: default = 1.0, TMR Mod = 0.5, VTS Weapon Resting = 0.25) (minimum: 0.02)
A3W_townSpawnCooldown = 5*60;      // Number of seconds to wait between each use of a spawn on friends in towns (0 = disabled)
A3W_spawnBeaconCooldown = 15*60;   // Number of seconds to wait between each use of an individual spawn beacon (0 = disabled)
A3W_spawnBeaconSpawnHeight = 1500; // Altitude in meters at which players will spawn when using spawn beacons (0 = ground/sea)
A3W_maxSpawnBeacons = 2;		   // Maxmimum number of spawn beacons (0 = disabled)
A3W_uavControl = "group";          // Restrict connection to UAVs based on ownership ("owner", "group", "side")

// Store settings
A3W_showGunStoreStatus = 1;        // Show enemy and friendly presence at gunstores on map (0 = no, 1 = yes)
A3W_gunStoreIntruderWarning = 1;   // Warn players in gunstore areas of enemy intruders (0 = no, 1 = yes)
A3W_remoteBombStoreRadius = 75;    // Prevent players from placing remote explosives within this distance from any store (0 = disabled)
A3W_vehiclePurchaseCooldown = 45;  // Number of seconds to wait before allowing someone to purchase another vehicle, don't bother setting it too high because it can be bypassed by rejoining

// Player settings
A3W_startingMoney = 1500;          // Amount of money that players start with
A3W_unlimitedStamina = 1;          // Allow unlimited sprinting, jumping, etc. (0 = no, 1 = yes) - this also removes energy drinks from the mission
A3W_bleedingTime = 80;             // Time in seconds for which to allow revive after a critical injury (minimum 10 seconds)
A3W_survivalSystem = 1;            // Food and water are required to stay alive (0 = no, 1 = yes) - 0 removes food and water items from the mission

// ATM settings
A3W_atmEnabled = 1;
A3W_atmMaxBalance = 300000;        // Maximum amount of money that can be stored in a bank account (recommended: 1 million)
A3W_atmTransferFee = 10;           // Fee in percent charged to players for money transfers to other players (0 to 50)
A3W_atmTransferAllTeams = 0;       // Allow money transfers between players of all teams/sides (0 = same team only, 1 = all teams)
A3W_atmEditorPlacedOnly = 0;       // Only allow access via ATMs placed from the mission editor (0 = all ATMs from towns & editor allowed, 1 = ATMs from editor only) Note: Stratis has no town ATMs, only editor ones.
A3W_atmMapIcons = 1;               // Draw small icons on the map that indicate ATM locations (0 = no, 1 = yes)
A3W_atmRemoveIfDisabled = 0;       // Remove all ATMs from map if A3W_atmEnabled is set to 0 (0 = no, 1 = yes)

A3W_healthTime = 60*5;             //seconds till death
A3W_hungerTime = 80*60;            //seconds till starving
A3W_thirstTime = 65*60;            //seconds till dehydrated

// Persistence settings
A3W_playerSaving = 1;              // Save player data like position, health, inventory, etc. (0 = no, 1 = yes)
A3W_moneySaving = 1;               // If playerSaving = 1, save player money amount (0 = no, 1 = yes)
A3W_combatAbortDelay = 60;         // If playerSaving = 1, delay in seconds for which to disable abort and respawn buttons after firing or being shot (0 = none)
A3W_purchasedVehicleSaving = 1;    // Save vehicles purchased at vehicle stores between server restarts (0 = no, 1 = yes)
A3W_missionVehicleSaving = 0;      // Save vehicles captured from missions between server restarts (0 = no, 1 = yes)
A3W_townVehicleSaving = 0;         // Save vehicles captured from missions between server restarts (0 = no, 1 = yes)
A3W_baseSaving = 1;                // Save locked base parts between server restarts (0 = no, 1 = yes)
A3W_boxSaving = 1;                 // Save locked weapon crates and their contents between server restarts (0 = no, 1 = yes)
A3W_staticWeaponSaving = 0;        // Save locked static weapons and their magazines between server restarts (0 = no, 1 = yes)
A3W_warchestSaving = 0;            // Save warchest objects deployed by players between server restarts (0 = no, 1 = yes)
A3W_warchestMoneySaving = 0;       // Save warchest team money between server restarts (0 = no, 1 = yes)
A3W_spawnBeaconSaving = 1;         // Save spawn beacons between server restarts (0 = no, 1 = yes)
A3W_objectLifetime = 7*24;         // Maximum lifetime in hours for saved objects (baseparts, crates, etc. except vehicles) across server restarts (0 = no time limit)
A3W_cctvCameraSaving = 1;          // Save cctv cameras between restarts (0 = no, 1 = yes)
A3W_mineSaving = 1;         	   // Save mines between server restarts (0 = no, 1 = yes)
                                   // List of mine ammo classes that can be saved
A3W_saveable_mines_list = ["APERSTripMine_Wire_Ammo", "APERSBoundingMine_Range_Ammo", "APERSMine_Range_Ammo", "ATMine_Range_Ammo", "SLAMDirectionalMine_Wire_Ammo" ];
A3W_mineLifetime = 2*24;           // Maximum lifetime in hours for mines across server restarts (0 = no time limit)
A3W_vehicleLifetime = 0;           // Maximum lifetime in hours for saved vehicles across server restarts, regardless of usage (0 = no time limit)
A3W_vehicleMaxUnusedTime = 2*24;   // Maximum parking time in hours after which unused saved vehicles will be marked for deletion (0 = no time limit)
A3W_storageLifetime = 0;           // Maximum lifetime in horus for player's private storage (0 = no time limit)

PDB_PlayerFileID = "A3W_";         // Player savefile prefix (change this in case you run multiple servers from the same folder)
PDB_ObjectFileID = "A3W_";         // Object savefile prefix (change this in case you run multiple servers from the same folder)
PDB_VehicleFileID = "A3W_";        // Vehicle savefile prefix (change this in case you run multiple servers from the same folder)
PDB_MessagesFileID = "A3W_";       // Messages savefile prefix (change this in case you run multiple servers from the same folder)
PDB_AdminLogFileID = "A3W_";       // Admin log savefile prefix (change this in case you run multiple servers from the same folder)
PDB_HackerLogFileID = "A3W_";      // Hacker log savefile prefix (change this in case you run multiple servers from the same folder)
PDB_PlayersListFileID = "A3W_";    // PlayerList savefile prefix (change this in case you run multiple servers from the same folder)

A3W_vehicle_saveInterval = 1200;     // Number of seconds between vehicle saves
A3W_object_saveInterval = 1200;      // Number of seconds between object saves
A3W_player_saveInterval = 1200;      // Number of seconds between player saves
A3W_playersList_saveInterval = 1200; // Number of seconds between player list saves

A3W_saveable_vehicles_list = ["StaticWeapon", "C_Kart_01_F", "Quadbike_01_base_F", "Hatchback_01_base_F", "SUV_01_base_F", "Offroad_01_base_F", "Van_01_base_F", "MRAP_01_base_F", "MRAP_02_base_F", "MRAP_03_base_F", "Truck_01_base_F", "Truck_02_base_F", "Truck_03_base_F", "Wheeled_APC_F", "Tank_F", "Rubber_duck_base_F", "SDV_01_base_F", "Boat_Civil_01_base_F", "Boat_Armed_01_base_F", "Helicopter_Base_F", "Plane", "UGV_01_base_F"];		// List of classes for vehicles that are saveable
A3W_locked_vehicles_list = [];		// List of class names for vehicles that should be automatically locked upon restore
A3W_autosave_vehicles_list = ["B_MRAP_01_hmg_F", "B_MRAP_01_gmg_F", "O_MRAP_02_hmg_F", "O_MRAP_02_gmg_F", "I_MRAP_03_hmg_F", "I_MRAP_03_gmg_F", "B_Truck_01_ammo_F", "O_Truck_03_ammo_F", "I_Truck_02_ammo_F", "Wheeled_APC_F", "Tank_F", "O_Heli_Light_02_unarmed_F", "I_Heli_light_03_unarmed_F", "B_Heli_Transport_01_F", "B_Heli_Transport_01_camo_F", "B_Heli_Light_01_armed_F", "O_Heli_Light_02_F", "O_Heli_Light_02_v2_F", "I_Heli_light_03_F", "B_Heli_Attack_01_F", "O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F", "Heli_Transport_04_base_F", "B_Heli_Transport_03_unarmed_F", "B_Heli_Transport_03_F", "I_Heli_Transport_02_F", "I_Plane_Fighter_03_AA_F", "I_Plane_Fighter_03_CAS_F", "B_Plane_CAS_01_F", "O_Plane_CAS_02_F"];		// List of class names for vehicles that should be automatically locked and saved when bought

// Spawning settings
A3W_serverSpawning = 1;            // Vehicle, object, and loot spawning (0 = no, 1 = yes)
A3W_vehicleSpawning = 1;           // If serverSpawning = 1, spawn vehicles in towns (0 = no, 1 = yes)
A3W_vehicleQuantity = 200;         // Approximate number of land vehicles to be spawned in towns
A3W_boatSpawning = 1;              // If serverSpawning = 1, spawn boats at marked areas near coasts (0 = no, 1 = yes)
A3W_heliSpawning = 1;              // If serverSpawning = 1, spawn helicopters in some towns and airfields (0 = no, 1 = yes)
A3W_planeSpawning = 1;             // If serverSpawning = 1, spawn planes at some airfields (0 = no, 1 = yes)
A3W_boxSpawning = 0;               // If serverSpawning = 1, spawn weapon crates in 50% towns (0 = no, 1 = yes)
A3W_baseBuilding = 0;              // If serverSpawning = 1, spawn base parts in towns (0 = no, 1 = yes)

// Loot settings
A3W_buildingLootWeapons = 0;       // Spawn weapon loot in all buildings (0 = no, 1 = yes)
A3W_buildingLootSupplies = 0;      // Spawn supply loot (backpacks & player items) in all buildings (0 = no, 1 = yes)
A3W_buildingLootChances = 0;       // Chance percentage that loot will spawn at each spot in a building (0 to 100)
A3W_vehicleLoot = 2;               // Level of loot added to vehicles (0 = none, 1 = weapon OR items, 2 = weapon AND items, 3 = two weapons AND items) - 2 or 3 recommended if buildingLoot = 0

// Territory settings
A3W_territoryCaptureTime = 2*60;   // Time in seconds needed to capture a territory
A3W_territoryPayroll = 1;          // Periodically reward sides and indie groups based on how many territories they own (0 = no, 1 = yes)
A3W_payrollInterval = 30*60;       // Delay in seconds between each payroll
A3W_payrollAmount = 400;           // Amount of money rewarded per territory on each payroll

// Mission settings
A3W_serverMissions = 1;            // Enable server missions (0 = no, 1 = yes)
A3W_missionsDifficulty = 0;        // Missions difficulty (0 = normal, 1 = hard)
A3W_missionsQuantity = 5;          // Number of missions running at the same time (0 to 6)
A3W_missionFarAiDrawLines = 1;     // Draw small red lines on the map from mission markers to individual units & vehicles which are further away than 75m from the objective (0 = no, 1 = yes)
A3W_heliPatrolMissions = 1;        // Enable missions involving flying helicopters piloted by AI (0 = no, 1 = yes)
A3W_underWaterMissions = 1;        // Enable underwater missions which require diving gear (0 = no, 1 = yes)
A3W_mainMissionDelay = 5*60;       // Time in seconds between Main Missions
A3W_mainMissionTimeout = 60*60;    // Time in seconds that a Main Mission will run for, unless completed
A3W_sideMissionDelay = 5*60;       // Time in seconds between Side Missions
A3W_sideMissionTimeout = 60*60;    // Time in seconds that a Side Mission will run for, unless completed
A3W_moneyMissionDelay = 10*60;     // Time in seconds between Money Missions
A3W_moneyMissionTimeout = 60*60;   // Time in seconds that a Money Mission will run for, unless completed
