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

var config int MinimumPlayersForSuperweapon;

reliable server function ServerPurchaseItem(int CharID, Rx_BuildingAttachment_PT PT)	// Called when someone attempts to purchase an item
{
	local int PlayerCount;
	PlayerCount = `WorldInfoObject.Game.NumPlayers-1;

	if(CharID == 0)	// Is the item being purchased a beacon? Beacon ID is 0
	{	  
		`log("Someone's buying a beacon.");
		if(PlayerCount < MinimumPlayersForSuperweapon)	// Is there less people than required by the config?
		{
			CTextMessage("[FPI] Not enough players for that.\nThere needs to be more than "$MinimumPlayersForSuperweapon$" players.",'Red');    // Notify our purchaser that they can not purchase that.
			ClientPlaySound(SoundCue'FPI_FX.Sounds.S_AccessDenied');
			`log("Someone just tried to purchase a beacon. Current players: " $ PlayerCount $ "/" $ MinimumPlayersForSuperweapon);
			return;
		} else if (PlayerCount > MinimumPlayersForSuperweapon || PlayerCount == MinimumPlayersForSuperweapon)
		{
			if (ValidPTUse(PT))
				Rx_Game(WorldInfo.Game).GetPurchaseSystem().PurchaseItem(self,GetTeamNum(),0);
		}
		}

	if(CharID == 1 || CharID == 2) 
	{
		`log("Someones buying something else");
		if (ValidPTUse(PT))
			Rx_Game(WorldInfo.Game).GetPurchaseSystem().PurchaseItem(self,GetTeamNum(),CharID);
	}
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
		ClientMessage("You donated " $ PRI.GetHumanReadableName() $ " " $ Credits $ " credits.")
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
