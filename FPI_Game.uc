/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */

class FPI_Game extends Rx_Game;

function SetMaxPlayers(int NewMaxPlayers)
{
	if (NewMaxPlayers > 64)
		return;
	else 
		MaxPlayers = NewMaxPlayers;
}

DefaultProperties
{
    HudClass                   = class'FPI_HUD'
    PlayerControllerClass      = class'FPI_Controller'
    PlayerReplicationInfoClass = class'FPI_PRI'
    AccessControlClass         = class'FPI_AccessControl'
    PurchaseSystemClass        = class'FPI_PurchaseSystem'
}
