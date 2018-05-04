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

	if(PlayerCount < MinimumPlayersForSuperweapon)	// Is there less people than required by the config?
		if(CharID == 0)    // Is the item being purchased a beacon? Beacon ID is 0
		{
			CTextMessage("[FPI] Not enough players for that.",'Red',300.0,1.5);    // Notify our purchaser that they can not purchase that.
			return;
		} else
		if (ValidPTUse(PT))
			Rx_Game(WorldInfo.Game).GetPurchaseSystem().PurchaseItem(self,GetTeamNum(),CharID);
}
