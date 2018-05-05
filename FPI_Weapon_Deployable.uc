/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 * This file contains source code from Renegade-X, with additional code.
 */
 
class FPI_Weapon_Deployable extends Rx_Weapon_Deployable;

function OvermineBroadcast()
{
	local Rx_Controller PC;
	local string Message;

	Message = Instigator.Controller.PlayerReplicationInfo.PlayerName $ " is over-mining " $ Rx_Controller(Instigator.Controller).GetSpottargetLocationInfo(self);
	foreach WorldInfo.AllControllers(class'Rx_Controller', PC)
		if (Instigator.GetTeamNum() == PC.GetTeamNum())
			PC.ClientMessage(Message, 'EVA');
		Rx_Controller(Instigator.Controller).ClientPlaySound(SoundCue'FPI_FX.Sounds.S_Yo');
		Rx_Controller(Instigator.Controller).CTextMessage("[FPI] You're overmining!",'Red',300.0,1.5);
		Rx_Controller(Instigator.Controller).CTextMessage("[FPI] Do you know what you're doing?",'Red',300.0,1.5);

	`LogRx("GAME" `s "OverMine;" `s `PlayerLog(Instigator.Controller.PlayerReplicationInfo) `s "near" `s Rx_Controller(Instigator.Controller).GetSpottargetLocationInfo(self));
}
