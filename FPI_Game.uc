/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 * This file contains source code from Renegade-X, with additional code.
 */

class FPI_Game extends Rx_Game
config(FPI);


var config int ArcticML;
var config int CanyonML;
var config int CliffSideML;
var config int ComplexML;
var config int Crash_SiteML;
var config int EyesML;
var config int FieldML;
var config int FieldXML;
var config int FortML;
var config int GobiML;
var config int GoldRushML;
var config int IslandsML;
var config int LakeSideML;
var config int MesaML;
var config int OutpostsML;
var config int ReservoirML;
var config int SnowML;
var config int SunriseML;
var config int TombML;
var config int TunnelsML;
var config int UnderML;
var config int VolcanoML;
var config int WallsML;
var config int WhiteoutML;
var config int XMountainML;

var int OldMineLimit;
var int NewMineLimit;

function MGetMapName()
{
     if (WorldInfo.GetmapName() ~= "Arctic_Stronghold")
  {
    SetML(ArcticML);
  } else if (WorldInfo.GetmapName() ~= "Canyon")
  {
    SetML(CanyonML);
  } else if (WorldInfo.GetmapName() ~= "CliffSide")
  {
    SetML(CliffSideML);
  } else if (WorldInfo.GetmapName() ~= "Complex")
  {
    SetML(ComplexML);
  } else if (WorldInfo.GetmapName() ~= "Crash_Site")
  {
    SetML(Crash_SiteML);
  } else if (WorldInfo.GetmapName() ~= "Eyes")
  {
    SetML(EyesML);
  } else if (WorldInfo.GetmapName() ~= "Field")
  {
    SetML(FieldML);
  } else if (WorldInfo.GetmapName() ~= "Field_X")
  {
    SetML(FieldXML);
  } else if (WorldInfo.GetmapName() ~= "Fort")
  {
    SetML(FortML);
  } else if (WorldInfo.GetmapName() ~= "Gobi")
  {
    SetML(GobiML);
  } else if (WorldInfo.GetmapName() ~= "GoldRush")
  {
    SetML(GoldRushML);
  } else if (WorldInfo.GetmapName() ~= "Islands")
  {
    SetML(IslandsML);
  } else if (WorldInfo.GetmapName() ~= "LakeSide")
  {
    SetML(LakeSideML);
  } else if (WorldInfo.GetmapName() ~= "Mesa")
  {
    SetML(MesaML);
  } else if (WorldInfo.GetmapName() ~= "Outposts")
  {
    SetML(OutpostsML);
  } else if (WorldInfo.GetmapName() ~= "Reservoir")
  {
    SetML(ReservoirML);
  } else if (WorldInfo.GetmapName() ~= "Snow")
  {
    SetML(SnowML);
  } else if (WorldInfo.GetmapName() ~= "Tomb")
  {
    SetML(TombML);
  } else if (WorldInfo.GetmapName() ~= "Tunnels")
  {
    SetML(TunnelsML);
  } else if (WorldInfo.GetmapName() ~= "Under")
  {
    SetML(UnderML);
  } else if (WorldInfo.GetmapName() ~= "Volcano")
  {
    SetML(VolcanoML);
  } else if (WorldInfo.GetmapName() ~= "Walls_Flying")
  {
    SetML(WallsML);
  } else if (WorldInfo.GetmapName() ~= "Walls")
  {
    SetML(WallsML);
  } else if (WorldInfo.GetmapName() ~= "Walls (Flying)")
  {
    SetML(WallsML);
  }
   else if (WorldInfo.GetmapName() ~= "Whiteout")
  {
    SetML(WhiteoutML);
  } else if (WorldInfo.GetmapName() ~= "Xmountain")
  {
    SetML(XMountainML);
  } else {
    SetML(0);
  }
}

function SetML(int MLToSet)
{
  if(MLToSet == 0){
    NewMintLimit = Rx_MapInfo(WorldInfo.GetMapInfo()).MineLimit;
    `log("[FPI] Could not find a custom mine limit for this map. Using the map's default.");
    } else {
      NewMineLimit = MLToSet;
    }
}


event InitGame( string Options, out string ErrorMessage )
{
    //local int MapIndex;
    MGetMapName();

    if(Rx_MapInfo(WorldInfo.GetMapInfo()).bIsDeathmatchMap)
    {
        if(TimeLimit != 10)
            CnCModeTimeLimit = TimeLimit;
        TimeLimit = 10;
        bSpawnInTeamArea = false;
    } else if(CnCModeTimeLimit > 0 && CnCModeTimeLimit != TimeLimit)
    {
        TimeLimit = CnCModeTimeLimit;
    }

    if (WorldInfo.NetMode == NM_Standalone)
        TeamMode = 4;

    super.InitGame(Options, ErrorMessage);
    TeamFactions[TEAM_GDI] = "GDI";
    TeamFactions[TEAM_NOD] = "Nod";
    DesiredPlayerCount = 1;
    bCanPlayEvaBuildingUnderAttackGDI = true;
    bCanPlayEvaBuildingUnderAttackNOD = true;

    if (Role == ROLE_Authority )
    {
        FindRefineries(); // Find the refineries so we can give players credits
    }

    IgnoreGameServerVersionCheck = HasOption( Options, "IgnoreGameServerVersionCheck");

    GDIBotCount = GetIntOption( Options, "GDIBotCount",0);
    NODBotCount = GetIntOption( Options, "NODBotCount",0);
    AdjustedDifficulty = 5;
    GDIDifficulty = GetIntOption( Options, "GDIDifficulty",4);
    NODDifficulty = GetIntOption( Options, "NODDifficulty",4);
    GDIDifficulty += 3;
    NODDifficulty += 3;

    if (WorldInfo.NetMode == NM_DedicatedServer) //Static limits on-line
    {
        if(bUseCustomMineLimits)
        {
            `log("[FPI] " $ WorldInfo.GetmapName() "'s custom mine limit is " $ NewMineLimit $ ". Default value is: " $ Rx_MapInfo(WorldInfo.GetMapInfo()).MineLimit $ "Applying custom mine limit.");
            MineLimit = NewMineLimit;
        } else {
            `log("[FPI] Custom mine limit disabled or not found for this map. Using default: " Rx_MapInfo(WorldInfo.GetMapInfo()).MineLimit);
            MintLimit = Rx_MapInfo(WorldInfo.GetMapInfo()).MineLimit;
        }

        VehicleLimit = Rx_MapInfo(WorldInfo.GetMapInfo()).VehicleLimit;
    }
    else if(WorldInfo.NetMode == NM_Standalone)
    {
        MineLimit = GetIntOption( Options, "MineLimit", MineLimit);
        VehicleLimit = GetIntOption( Options, "VehicleLimit", VehicleLimit);
        bDelayedStart = false;
        //AddInitialBots();
    }

    InitialCredits = GetIntOption(Options, "StartingCredits", InitialCredits);
    PlayerTeam = GetIntOption( Options, "Team",0);
    GDIAttackingValue = GetIntOption( Options, "GDIAttackingStrengh",0.7);
    NodAttackingValue = GetIntOption( Options, "NodAttackingStrengh",0.7);
    //Port = GetIntOption( Options, "PORT",7777);
    Port = `GamePort;
    //GamePassword = ParseOption( Options, "GamePassword");


    // Initialize the maplist manager
    InitializeMapListManager();

    //adding fort mutator (nBab)
    if (WorldInfo.GetmapName() == "Fort")
    {
        AddMutator("RenX_nBabMutators.Fort");
        BaseMutator.InitMutator(Options, ErrorMessage);
    }
}


DefaultProperties
{
    HudClass                   = class'FPI_HUD'
 //   VictoryMessageClass        = class'Rx_VictoryMessage'
 //   DeathMessageClass          = class'Rx_DeathMessage'
 //   bUndrivenVehicleDamage     = true
    PlayerControllerClass      = class'FPI_Controller'
    PlayerReplicationInfoClass = class'FPI_PRI'
 //  BroadcastHandlerClass      = class'FPI_BroadcastHandler'
    AccessControlClass         = class'FPI_AccessControl'

 //   GameReplicationInfoClass   = class'Rx_GRI'
 //   PurchaseSystemClass        = class'Rx_PurchaseSystem'
 //   VehicleManagerClass        = class'Rx_VehicleManager'
 //   CommanderControllerClass   = class'FPI_CommanderController'
}
