/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */
 
class FPI_ServerTravelMutator extends Rx_Mutator
config(FPI);

var config string ServerDestination;
var config bool bAutomaticallySplitServer;
var config int PlayerAmountSplit;

function InitThisMutator()
{
  `log("################################");
  `log("[Server Travel Mutator] Successfully inited!");
  `log("################################");
}

function FPIServerTravel()
{
	local string NextMap;
	local Guid NextMapGuid;
	local PlayerController c;
	local int i;
	local int PlayerCount;

  	PlayerCount = `WorldInfoObject.Game.NumPlayers-1;
  	NextMap = string(WorldInfo.GetPackageName());
	NextMapGuid = GetPackageGuid(name(NextMap));

  	if(bAutomaticallySplitServer == true)
  	{
  		if(PlayerCount > PlayerAmountSplit || PlayerCount == PlayerAmountSplit)
  		{
  			foreach WorldInfo.AllControllers(class'PlayerController', c)
  			{
  		if(Rx_Controller(c) != none && i == 0)
  		{
  			C.ClientTravel(ServerDestination, TRAVEL_Relative, false, NextMapGuid);
  			i++;
  			`log("[FPI Server Travel] Sending someone to other server. Int: " $ i);
  		} else if (Rx_Controller(c) != none && i > 0)
  		{
  			i--;
  			`log("[FPI Server Travel] Not sending someone to other server. Int: " $ i);
  			return;
  		}
  			}
		}
  	}
}



DefaultProperties
{
}