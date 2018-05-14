/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 * This file contains source code from Renegade-X, with additional code.
 */
 
class FPI_Controller extends Rx_Controller
config(FPI);

//var FPI_CommanderMenuHandler Com_Menu;
var config int MinimumPlayersForSuperweapon;
var config bool bConsiderBuildingCount;

var bool OverrideBeacons;

reliable server function ServerPurchaseItem(int CharID, Rx_BuildingAttachment_PT PT)	// Called when someone attempts to purchase an item
{
	if(CharID == 0)	// Is the item being purchased a beacon? Beacon ID is 0
	{	  
		if (CanPurchaseBeacon() == false)
		{
			CTextMessage("[FPI] Not enough players for that.\nThere needs to be more than "$MinimumPlayersForSuperweapon$" players.",'Red');    // Notify our purchaser that they can not purchase that.
			ClientPlaySound(SoundCue'FPI_FX.Sounds.S_AccessDenied');  // Play a nice little sound for them.
			return;
		} else {
			if (ValidPTUse(PT))
				Rx_Game(WorldInfo.Game).GetPurchaseSystem().PurchaseItem(self,GetTeamNum(),CharID);
		}
	} else {
		if (ValidPTUse(PT))
			Rx_Game(WorldInfo.Game).GetPurchaseSystem().PurchaseItem(self,GetTeamNum(),CharID);
	}
}

reliable server function bool CanPurchaseBeacon()
{
	local int AliveBuildings;
	local int AllBuildings;
	local int PlayerCount;
	PlayerCount = `WorldInfoObject.Game.NumPlayers-1;

	AliveBuildings = CountAliveBuildings();
	AllBuildings   = CountAllBuildings();
	`log(AliveBuildings @ AllBuildings);

	if(OverrideBeacons == true)
	{
		return true;
	} else if (MinimumPlayersForSuperweapon > PlayerCount)
	{
		return false;
	} else if (PlayerCount == MinimumPlayersForSuperweapon || PlayerCount > MinimumPlayersForSuperweapon) {
		return true;
	} else if (AliveBuildings * 2 < AllBuildings && bConsiderBuildingCount == true)
	{
		return true;
	} else {
		return false;
	}
}

static function OverrideBeaconPurchasing()
{
	//OverrideBeacons = true;
}

function int CountAliveBuildings()
{
    local Rx_Building_Team_Internals thisBuilding;
    local Rx_Building_Techbuilding_Internals thisTBuilding;
    local Rx_Building_Airstrip AirStrip;
    local int AliveBuildings;

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Team_Internals', thisBuilding)
    {
    if(thisBuilding.IsDestroyed() == false)
      	AliveBuildings++;
    }

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Techbuilding_Internals', thisTBuilding)	// Because I am dumb and cant get ClassIsAChild to work or IsA to check if it's a tech building.
    {
    	AliveBuildings--;
    }

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Airstrip', AirStrip)	// I really hate looping through all these, but apparently the airstrip counts as 2. 
    {
    	AliveBuildings--;
    }
    return AliveBuildings;
}

function int CountAllBuildings()
{
    local Rx_Building_Team_Internals thisBuilding;
    local Rx_Building_Techbuilding_Internals thisTBuilding;
    local Rx_Building_Airstrip AirStrip;
    local int AllBuildings;

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Team_Internals', thisBuilding)
    {
        AllBuildings++;
    }

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Techbuilding_Internals', thisTBuilding)
    {
    	AllBuildings--;
    }

    foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Rx_Building_Airstrip', AirStrip)	
    {
    	AllBuildings--;
    }
    return AllBuildings;
}

exec function DonateCredits(int playerID, float amount)
{
	ServerDonateCredits(playerID, amount);
}

exec function Donate(string PlayerName, int Credits)
{
	local PlayerReplicationInfo PRI;
	local string error;
	PRI = ParsePlayer(PlayerName, error);
	if (PRI != None)
		if(PRI.GetTeamNum() != self.GetTeamNum()){
			ClientMessage("You can not donate to the enemy team.");
		} else if (PRI.GetTeamNum() == self.GetTeamNum()){
		DonateCredits(PRI.PlayerID, Credits);
		ClientMessage("You donated " $ PRI.GetHumanReadableName() $ " " $ Credits $ " credits.");
		}
	else
		ClientMessage(error);
}	

reliable server function ServerDonateCredits(int playerID, float amount)
{
	local int i;

	if(Worldinfo.GRI.ElapsedTime < Rx_Game(Worldinfo.Game).DonationsDisabledTime)
	{
		ClientMessage("Donations are disallowed for the first " $ Rx_Game(Worldinfo.Game).DonationsDisabledTime $ " seconds.");	
		return;
	}

	if (amount < 0 || Rx_PRI(PlayerReplicationInfo).GetCredits() < amount) return; // not enough money
	else if (amount == 0) amount = Rx_PRI(PlayerReplicationInfo).GetCredits();

	for (i = 0; i < WorldInfo.GRI.PRIArray.Length; i++)
	{
		if (WorldInfo.GRI.PRIArray[i].PlayerID == playerID)
		{
			Rx_PRI(WorldInfo.GRI.PRIArray[i]).AddCredits(amount);
			Rx_PRI(PlayerReplicationInfo).RemoveCredits(amount);
			`LogRxPub("GAME" `s "Donated;" `s amount `s "to" `s `PlayerLog(WorldInfo.GRI.PRIArray[i]) `s "by" `s `PlayerLog(PlayerReplicationInfo));
			if (Rx_Controller(WorldInfo.GRI.PRIArray[i].Owner) != none)
			{
				Rx_Controller(WorldInfo.GRI.PRIArray[i].Owner).ClientMessage(PlayerReplicationInfo.PlayerName $ " donated you " $ amount $" credits.");
				Rx_Controller(WorldInfo.GRI.PRIArray[i].Owner).ClientPlaySound(SoundCue'FPI_FX.Sounds.S_Yo');
			}

			return;
		}
	}
}
/*
function EnableCommanderMenu()
{
	
	if(VoteHandler != none || Rx_GRI(WorldInfo.GRI).bEnableCommanders == false) return; 
	
	if(Com_Menu != none ) 
	{
		DestroyOldComMenu() ;
		return; 
	}

	if(!bPlayerIsCommander())
	{
		CTextMessage("You are NOT a commander", 'Red'); 
		return; 
	}
	
	Com_Menu = new (self) class'FPI_CommanderMenuHandler';
	Com_Menu.Enabled(self);
}
*/

DefaultProperties
{
	OverrideBeacons = false;
}