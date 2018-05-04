/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

class FPI_CreditMutator extends Rx_Mutator
config(FPI);

var config float TickAmount;
var config float TickTime;

function InitThisMutator()
{
  `log("################################");
  `log("[Credit Mutator] Successfully inited!");
  `log("################################");
}

function MHOnBuildingDestroyed(PlayerReplicationInfo Destroyer, Rx_Building_Team_Internals BuildingInternals, Rx_Building Building, class<DamageType> DamageType)
{
local Rx_Building thisBuilding;

  ForEach Rx_Game(`WorldInfoObject.Game).AllActors(class'Rx_Building',thisBuilding)
  {
    if(Rx_Building_GDI_MoneyFactory(thisBuilding).IsDestroyed())
    {
      setTimer(TickTime, true, 'CreditTickGDI');
      `log("[Credit Mutator] GDI refinery has died. Starting credit tick for GDI.");
    } else if(Rx_Building_Nod_MoneyFactory(thisBuilding).IsDestroyed())
    {
      setTimer(TickTime, true, 'CreditTickNod');
      `log("[Credit Mutator] Nod refinery has died. Starting credit tick for Nod.");
    }
  }
}

function CreditTickGDI()
{
  local PlayerReplicationInfo PRI;

  foreach WorldInfo.GRI.PRIArray(pri)
  {
    if(Rx_PRI(pri) != None && Rx_PRI(pri).GetTeamNum() == TEAM_GDI) {
      Rx_PRI(pri).AddCredits(TickAmount); // Add credits to every GDI player.
    }
  }
}

function CreditTickNod()
{
  local PlayerReplicationInfo PRI;

  foreach WorldInfo.GRI.PRIArray(pri)
  {
    if(Rx_PRI(pri) != None && Rx_PRI(pri).GetTeamNum() == TEAM_NOD) {
      Rx_PRI(pri).AddCredits(TickAmount); // Add credits to every Nod player.
    }
  }
}

DefaultProperties
{
}
