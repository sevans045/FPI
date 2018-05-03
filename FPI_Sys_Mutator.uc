/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

 class FPI_Sys_Mutator extends Rx_Mutator;

var float ourServerFPS;
var FPI_Mut_Controller FPIController;
var int calcServerFPS;

function OnTick(float DeltaTime)
{
	// Keep server FPS here as well for Log file logging.
	ourServerFPS = 1 / DeltaTime;
	calcServerFPS++;
	
	if ( FPIController != None ) 
		FPIController.OnTick(DeltaTime);
}

function InitSystem()
{
	ourServerFPS = 0;
	
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		`log("[Sys Mutator] Server Found - Starting FPS Timer");
		setTimer(10, true, 'PrintourServerFPS');
	} else {
		`log("[Sys Mutator] Client Found, not logging FPS");
	}
	
	if ( Rx_Game(WorldInfo.Game) != None )
	{
		FPIController = Rx_Game(WorldInfo.Game).Spawn(class'FPI_Mut_Controller');
		
		`log("[Sys Mutator] Spawned Controller and Replication Info classes");
	}
}

function PrintourServerFPS()
{
	`log("[Sys Mutator] Server FPS: " $ ourServerFPS $ " Calc Server FPS: " $ string((calcServerFPS/10)));	
	calcServerFPS = 0;
}