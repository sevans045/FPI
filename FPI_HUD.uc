/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

 class FPI_HUD extends Rx_HUD;

var FPI_HUD_AdminComponent FPI_HUDAdminComponent;
var FPI_MutatorHandler MutatorHandler;
var int DefaultTargettingRangex;

function CreateHudCompoenents()
{
	super.CreateHudCompoenents();

	`log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
	`log("~ Creating FPI HUD Components ~");
	`log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

	FPI_HUDAdminComponent = new class'FPI_HUD_AdminComponent';
}



function UpdateHudCompoenents(float DeltaTime, Rx_HUD HUD)
{
	super.UpdateHudCompoenents(DeltaTime, HUD);
	if ( FPI_HUDAdminComponent != None ) FPI_HUDAdminComponent.Update(DeltaTime, HUD);
}

function DrawHudCompoenents()
{
	super.DrawHudCompoenents();
	if ( FPI_HUDAdminComponent != None ) FPI_HUDAdminComponent.Draw();
}


function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType, optional float LifeTime )
{
	local string cName, fMsg, rMsg;
	local bool bEVA;
	`log("Message event from HUD fired.");

	if (Len(Msg) == 0)
		return;

	if ( bMessageBeep )
		PlayerOwner.PlayBeepSound();

	// Create Raw and Formatted Chat Messages
	
	if (PRI != None)
	{	
		// We have a player, let's sort this out
		cName = CleanHTMLMessage(PRI.PlayerName);
	
		if ( PRI.bAdmin )
			cName = "<font color='#02FF00'><b>[STAFF]</b></font> " $ cName;
	}
	else
		cName = "Host";
		
	if (MsgType == 'Say') {
		if (PRI == None)
			fMsg = "<font color='" $HostColor$"'>" $cName$"</font>: <font color='#FFFFFF'>"$CleanHTMLMessage(Msg)$"</font>";
		else if (PRI.Team.GetTeamNum() == TEAM_GDI){
					fMsg = "<font color='" $GDIColor $"'>" $cName $"</font>: ";
					MutatorHandler.MHChatMessage(Msg, PRI);
				}
		else if (PRI.Team.GetTeamNum() == TEAM_NOD){
					fMsg = "<font color='" $NodColor $"'>" $cName $"</font>: ";
					MutatorHandler.MHChatMessage(Msg, PRI);
				}
	
		if ( cName != "Host" ) {
			fMsg $= CleanHTMLMessage(Msg);
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'TeamSay') {
		if (PRI.GetTeamNum() == TEAM_GDI)
		{
			fMsg = "<font color='" $GDIColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
		else if (PRI.GetTeamNum() == TEAM_NOD)
		{
			fMsg = "<font color='" $NodColor $"'>" $ cName $": "$ CleanHTMLMessage(Msg) $"</font>";
			PublicChatMessageLog $= "\n" $ fMsg;
			rMsg = cName $": "$ Msg;
		}
	}
	else if (MsgType == 'Radio')
	{
		if(Rx_PRI(PRI).bGetIsCommander())
			fMsg = "<font color='" $CommandTextColor $"'>" $ "[Commander]" $ cName $": "$ Msg $"</font>"; 
		else
			fMsg = "<font color='" $RadioColor $"'>" $ cName $": "$ Msg $"</font>"; 
		
		fMsg = HighlightStructureNames(fMsg); 
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
	}
	else if (MsgType == 'Commander') 
	{
		if(Left(Caps(msg), 2) == "/C") 
		{
			msg = Right(msg, Len(msg)-2);
			Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 120.0,,true);
		}
		else
		if(Left(Caps(msg), 2) == "/R") 
		{
			msg = Right(msg, Len(msg)-2);
			Rx_Controller(PlayerOwner).CTextMessage(msg,'Pink', 360.0,,true);
		}
		fMsg = "<b><font color='" $CommandTextColor $"'>" $ "[Commander]"$ cName $": "$ CleanHTMLMessage(Msg) $"</font></b>";
		//PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = cName $": "$ Msg;
	}
	else if (MsgType == 'System') {
		if(InStr(Msg, "entered the game") >= 0)
			return;
		fMsg = Msg;
		PublicChatMessageLog $= "\n" $ fMsg;
		rMsg = Msg;
	}
	else if (MsgType == 'PM') {
		if (PRI != None)
			fMsg = "<font color='"$PrivateFromColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		else
			fMsg = "<font color='"$HostColor$"'>Private from "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private from "$ cName $": "$ Msg;
	}
	else if (MsgType == 'PM_Loopback') {
		fMsg = "<font color='"$PrivateToColor$"'>Private to "$cName$": "$CleanHTMLMessage(Msg)$"</font>";
		PrivateChatMessageLog $= "\n" $ fMsg;
		rMsg = "Private to "$ cName $": "$ Msg;
	}
	else
		bEVA = true;

	// Add to currently active GUI | Edit by Yosh : Don't bother spamming the non-HUD chat logs with radio messages... it's pretty pointless for them to be there.
	if (bEVA)
	{
		if (HudMovie != none && HudMovie.bMovieIsOpen)
			HudMovie.AddEVAMessage(Msg);
	}
	else
	{
		if (HudMovie != none && HudMovie.bMovieIsOpen)
			HudMovie.AddChatMessage(fMsg, rMsg);

		if (Scoreboard != none && MsgType != 'Radio' && Scoreboard.bMovieIsOpen) {
			if (PlayerOwner.WorldInfo.GRI.bMatchIsOver) {
				Scoreboard.AddChatMessage(fMsg, rMsg);
			}
		}

		if (RxPauseMenuMovie != none && MsgType != 'Radio' && RxPauseMenuMovie.bMovieIsOpen) {
			if (RxPauseMenuMovie.ChatView != none) {
				RxPauseMenuMovie.ChatView.AddChatMessage(fMsg, rMsg, MsgType=='PM' || MsgType=='PM_Loopback');
			}
		}

	}
}

DefaultProperties
{
	DefaultTargettingRangex = 10000;
}
