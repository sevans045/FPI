/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

class FPI_HUD_AdminComponent extends Rx_Hud_Component;

var FPI_Mut_Controller FPI_MutController;

function Update(float DeltaTime, Rx_HUD HUD) 
{
	local FPI_Mut_Controller thisClass;
	super.Update(DeltaTime, HUD);
	
	if ( FPI_MutController == None )
	{
		// Find our controller.
		foreach RenxHud.PlayerOwner.AllActors(class'FPI_Mut_Controller', thisClass)
		{
			FPI_MutController = thisClass;
			break;
		}
	}
	
	// If we're still none, then oops?
	if ( FPI_MutController == None )
		return;
}

function Draw()
{
	DrawServerFPS();
}

simulated function DrawServerFPS()
{
	local float X,Y;
	local string hudMessage,fpsMessage;
	
	if ( RenxHud.PlayerOwner != None && RenxHud.PlayerOwner.PlayerReplicationInfo != None && !RenxHud.PlayerOwner.PlayerReplicationInfo.bAdmin )
		return;
	
	X = RenxHud.Canvas.SizeX*0.005;
	Y = RenxHud.Canvas.SizeY*0.60;
	Canvas.SetPos(X,Y);
	Canvas.SetDrawColor(0,255,0,255);
	Canvas.Font = Font'RenXHud.Font.RadioCommand_Medium';
	
	if ( FPI_MutController == None )
	{
		Canvas.DrawText("FPI Admin HUD Loading...");
	} else {
		//ServerFPS,CurrentActors,CurrentVehiclesNod,CurrentVehiclesGDI,CurrentVehiclesUnoccupied,ServerDeltaTime
		
		hudMessage = "[FPI Admin Panel]\n";
		fpsMessage = FPI_MutController.ServerFPS == 0 ? "Running As Client Or No Data!" : string(FPI_MutController.ServerFPS);
		hudMessage $= "  SFPS: " $ fpsMessage $ " | Delta Time: " $ FPI_MutController.ServerDeltaTime $ " | Actors: " $ string(FPI_MutController.CurrentActors) $ "\n";
		//hudMessage $= "  NodVeh: " $ string(FPI_MutController.CurrentVehiclesNod) $ " | GDIVeh: " $ string(FPI_MutController.CurrentVehiclesGDI) $ " | UnOcVeh: " $ string(FPI_MutController.CurrentVehiclesUnoccupied) $ " | Tot: " $ string((FPI_MutController.CurrentVehiclesNod+FPI_MutController.CurrentVehiclesGDI+FPI_MutController.CurrentVehiclesUnoccupied)) $ "\n";
		//hudMessage $= "  NodCredits: " $ string(FPI_MutController.ServerNodCredits) $ " | GDICredits: " $ string(FPI_MutController.ServerGDICredits) $ "\n";
		hudMessage $= "  Admins: " $ string(FPI_MutController.StaffMembersIngame) $ "\n";
		Canvas.DrawText(hudMessage);
	}
}

