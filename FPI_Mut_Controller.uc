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
var float PrivateServerDeltaTime;
var repnotify float ServerDeltaTime;
var repnotify int StaffMembersIngame;
var repnotify int GDICP;
var repnotify int NodCP;
var repnotify int MaxCP;

replication
{
	if(bNetDirty || bNetInitial)
		ServerFPS,CurrentActors,ServerDeltaTime,StaffMembersIngame,GDICP,NodCP,MaxCP;
}

simulated function PostBeginPlay()
{
	setTimer(1, true, 'CollectData');
}

function CollectData()
{
	local int counter, adminingame, gcp, ncp, mcp;
	local Actor thisActor;
	local Controller c;
	
	if(`WorldInfoObject.NetMode != NM_DedicatedServer)
		return;
	
	// Actors in game
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'Actor', thisActor)
	{
		counter ++;
	}

	// Ingame admins stats
  	foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
  	{
    	if ( c != None )
 		    if ( Rx_Controller(c) != none && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo) != None && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo).bAdmin )
    	   	 	adminingame++;
  	}

  	// Commander point counts
  	gcp = Rx_TeamInfo(WorldInfo.GRI.Teams[0]).GetCommandPoints();
	ncp = Rx_TeamInfo(WorldInfo.GRI.Teams[1]).GetCommandPoints();
	mcp = Rx_TeamInfo(WorldInfo.GRI.Teams[0]).GetMaxCommandPoints();

	CurrentActors = counter;
	ServerFPS = PrivateServerFPS;
	ServerDeltaTime = PrivateServerDeltaTime;
	StaffMembersIngame = adminingame;
	GDICP = gcp;
	NodCP = ncp;
	MaxCP = mcp;
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
