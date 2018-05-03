/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

 class FPI_Mut_Controller extends ReplicationInfo;

var repnotify float ServerFPS;
var float PrivateServerFPS;
var repnotify int CurrentActors;
var repnotify int CurrentVehiclesNod;
var repnotify int CurrentVehiclesGDI;
var repnotify int CurrentVehiclesUnoccupied;
var float PrivateServerDeltaTime;
var repnotify float ServerDeltaTime;
var repnotify int ServerGDICredits;
var repnotify int ServerNodCredits;
var repnotify int StaffMembersIngame;

replication
{
	if(bNetDirty || bNetInitial)
		ServerFPS,CurrentActors,CurrentVehiclesNod,CurrentVehiclesGDI,CurrentVehiclesUnoccupied,ServerDeltaTime,ServerGDICredits,ServerNodCredits,StaffMembersIngame;
}

simulated function PostBeginPlay()
{
	setTimer(1, true, 'CollectData');
}

function CollectData()
{
	local int counter, cvnod, cvgdi, cvun, gdicredits, nodcredits, adminingame;
	local Actor thisActor;
	local Controller c;
	local Rx_Vehicle thisVehicle;
	
	if(`WorldInfoObject.NetMode != NM_DedicatedServer)
		return;
	
	// Actors in game
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Actor', thisActor)
	{
		counter ++;
	}
	
	// Vehicles in game
	foreach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Vehicle', thisVehicle)
	{			
		if ( thisVehicle.Driver != None )
		{
			if ( thisVehicle.Driver.GetTeamNum() == TEAM_GDI )
				cvgdi++;
			else
				cvnod++;
		} else {
			cvun++;
		}
	}
	
	// Player stats
	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
	{
		if ( Rx_PRI(c.PlayerReplicationInfo) != None )
		{
			if ( c.GetTeamNum() == TEAM_GDI )
			{
				gdicredits += Rx_PRI(c.PlayerReplicationInfo).GetCredits();
			} else {
				nodcredits += Rx_PRI(c.PlayerReplicationInfo).GetCredits();
			}
		}
	}

	// Ingame admins stats
  	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
  	{
    	if ( c != None )
 		    if ( Rx_Controller(c) != none && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo) != None && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo).bAdmin )
    	   	 	adminingame++;
  	}
	
	CurrentActors = counter;
	CurrentVehiclesGDI = cvgdi;
	CurrentVehiclesNod = cvnod;
	CurrentVehiclesUnoccupied = cvun;
	ServerFPS = PrivateServerFPS;
	ServerDeltaTime = PrivateServerDeltaTime;
	ServerGDICredits = gdicredits;
	ServerNodCredits = nodcredits;
	StaffMembersIngame = adminingame;
}

function OnTick(float DeltaTime)
{
	CalcServerFPS(DeltaTime);
}

reliable server function CalcServerFPS(float DeltaTime)
{
	// Are we a dedicated server?
	if(`WorldInfoObject.NetMode == NM_DedicatedServer)
	{
		// Calc servers FPS on this tick
		PrivateServerFPS = 1 / DeltaTime;
		PrivateServerDeltaTime = DeltaTime;
	}
}
