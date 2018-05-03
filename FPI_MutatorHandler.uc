/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

class FPI_MutatorHandler extends Rx_Mutator
config(FPI);

var FPI_CreditMutator CreditMutator;
var FPI_LoginMessageMutator LoginMessageMutator;
var FPI_ServerTravelMutator ServerTravelMutator;
var FPI_Sys_Mutator SystemMutator;
//var FPI_AdminHandler FPIAdminHandler; // Don't need this, it's for commands.
//var FPI_MineLimitMutator MineLimitMutator;

var config bool bEnableCreditMutator;
var config bool bEnableLoginMessageMutator;
var config bool bEnableServerTravelMutator;
//var config bool bEnableMineLimitMutator;

function PostBeginPlay()
{
  `log("################################");
  `log("Init for Mutator Handler finished!");
  `log("################################");
}

function InitMutator(string Options, out string ErrorMessage)
{
    SystemMutator = spawn(class'FPI_Sys_Mutator');
    if ( SystemMutator != None )
      SystemMutator.InitSystem();
    // FPIAdminHandler = spawn(class'FPI_AdminHandler');

}

simulated function Tick(float DeltaTime) // Tick for our Admin HUD
{
  if ( SystemMutator != None )
    SystemMutator.OnTick(DeltaTime);
}

/***************** Mutator Hooks *****************/

function OnMatchStart()
{
  MessageAll("             Welcome to FPI!\nPlease review the rules and have fun.\nDon't forget to vote for a commander!");

  if(bEnableCreditMutator == true)
  CreditMutator = spawn(class'FPI_CreditMutator');
    if ( CreditMutator != None )
    {
       CreditMutator.InitThisMutator();
       `log("[Mutator Handler] Initing Credit Mutator");
       MessageAdminsGreen("Initing Credit Mutator!");
    } else {
      `log("[Mutator Handler] Credit mutator was disabled via config. Not loading.");
      MessageAdminsRed("Not Initing Credit Mutator!");
    }

    if(bEnableLoginMessageMutator == true)
    LoginMessageMutator = spawn(class'FPI_LoginMessageMutator');
      if ( LoginMessageMutator != None )
    {
        LoginMessageMutator.InitThisMutator();
       `log("[Mutator Handler] Initing Login Message Mutator");
        MessageAdminsGreen("Initing Login Message Mutator!");
    } else {
       `log("[Mutator Handler] Login message mutator was disabled via config. Not loading.");
       MessageAdminsRed("Not Initing Login Message Mutator!");
    }

    if(bEnableServerTravelMutator == true)
    ServerTravelMutator = spawn(class'FPI_ServerTravelMutator');
      if ( ServerTravelMutator != None )
    {
        ServerTravelMutator.InitThisMutator();
       `log("[Mutator Handler] Initing Server Travel Mutator");
        MessageAdminsGreen("Initing Server Travel Mutator!");
    } else {
       `log("[Mutator Handler] Server travel mutator was disabled via config. Not loading.");
       MessageAdminsRed("Not Initing Server Travel Mutator!");
    }

     // SetTimer(90, true, 'CommanderReminder');
}


function OnMatchEnd()
{
  if ( ServerTravelMutator != None )
    {
      `log("################################");
      `log("[Mutator Handler] OwO the match has ended.");
      `log("################################");
     // ServerTravelMutator.FPIServerTravel();                // Enable this if we want to split servers. However, the function currently does not support having it enabled and not split people.
    }
}

function OnPlayerConnect(PlayerController NewPlayer,  string SteamID)
{
    if(LoginMessageMutator != None)
         LoginMessageMutator.MHOnPlayerConnect(NewPlayer, SteamID);
}

function OnBuildingDestroyed(PlayerReplicationInfo Destroyer, Rx_Building_Team_Internals BuildingInternals, Rx_Building Building, class<DamageType> DamageType)
{
  `log("################################");
  `log("[Mutator Handler] OwO! It seems a building has died. Reporting this to the appropriate mutators!");
  `log("################################");
  if ( ServerTravelMutator != None )
    CreditMutator.MHOnBuildingDestroyed(Destroyer, BuildingInternals, Building, DamageType);
}

/***************** Custom Functions *****************/

static function MessageAll(string message)
{
  local Controller c;
  foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
  {
    if ( c != None )
      if ( Rx_Controller(c) != none && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo) != None)
        Rx_Controller(c).CTextMessage(message,'Green',120);
  }
}

static function MessageAdminsGreen(string message)
{
  local Controller c;
  foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
  {
    if ( c != None )
      if ( Rx_Controller(c) != none && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo) != None && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo).bAdmin )
        Rx_Controller(c).CTextMessage("[FPI Admin] " $ message,'LightGreen',120);
  }
}

static function MessageAdminsRed(string message)
{
  local Controller c;
  foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
  {
    if ( c != None )
      if ( Rx_Controller(c) != none && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo) != None && Rx_PRI(Rx_Controller(c).PlayerReplicationInfo).bAdmin )
        Rx_Controller(c).CTextMessage("[FPI Admin] " $ message,'Red',120);
  }
}

static function MessageSpecific(PlayerController receiver, string message, optional name MsgColor = 'Green')
{
  if (receiver != None)
    if (Rx_Controller(receiver) != none && Rx_PRI(Rx_Controller(receiver).PlayerReplicationInfo) != None)
      Rx_Controller(receiver).CTextMessage(message,MsgColor,120);
}

static function MessageTeam(int TeamID, string message)
{
  local Controller c;

  foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c)
  {
    if ( c != None && c.GetTeamNum() == TeamID )
      if ( Rx_Controller(c) != none )
        Rx_Controller(c).CTextMessage("[FPI] " $ message,'Red',300.0,1.5);
  }
}

function CommanderReminder()
{
  local PlayerController PC;
  local bool NodHasCommander,GDIHasCommander;
  `log("Commander remined checking all controllers for a commander now.");
  foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'PlayerController', PC)
  {
    if (Rx_Controller(PC) != none && Rx_PRI(Rx_Controller(PC).PlayerReplicationInfo) != None && Rx_PRI(Rx_Controller(PC).PlayerReplicationInfo).bGetIsCommander())
    {
      `log("found a commander " $ PC.PlayerReplicationInfo.GetHumanReadableName() $ " " $ PC.GetTeamNum());
      if(PC.GetTeamNum() == 0)
      {
          GDIHasCommander = true;
          `log("GDI's commander is " $ PC.PlayerReplicationInfo.GetHumanReadableName());
      } else if (PC.GetTeamNum() == 1)
      {
          NodHasCommander = true;
          `log("Nod's commander is " $ PC.PlayerReplicationInfo.GetHumanReadableName());
      }
    } 
    }
      if(GDIHasCommander == false)
    {
      `log("No commander found for GDI");
      MessageTeam(0, "You have no commander, vote for one.");
    } if(NodHasCommander == false)
    {
      `log("No commander found for Nod");
      MessageTeam(1, "You have no commander, vote for one.");
}
  }


/***************** Commands *****************/

function Mutate(String MutateString, PlayerController Sender)
{
  local PlayerController PC;
  local array<string> MutateStringSplit;

    MutateStringSplit = SplitString ( MutateString, " ", true );
    if ( MutateStringSplit.Length == 0) return;

    `log("[FPI Admin] Command executed: " $ MutateString $ " from " $ Sender.PlayerReplicationInfo.GetHumanReadableName() $ ".");

    if ( MutateStringSplit.Length == 1 && MutateStringSplit[0] ~= "fpi" )
    {
        if (!Sender.PlayerReplicationInfo.bAdmin)
        {
            MessageSpecific(Sender, "[FPI Admin] You lack authentication for that.", 'Red');
            return;
        }

        MessageSpecific(Sender, "[FPI Admin] - Use 'fpi help' for help.", 'Red');
        return;
    }

    if ( MutateStringSplit.Length > 1 && MutateStringSplit[0] ~= "fpi" )
    {
        /*
         * [0] = fpi
         * [1] = cmd
         * (2) = params (optional, depends on cmd)
         */

        if (!Sender.PlayerReplicationInfo.bAdmin)
        {
            MessageSpecific(Sender, "[FPI Admin] You lack authentication for that.", 'Red');
            return;
        }

        //Sender.ClientMessage("1 = |" $ MutateStringSplit[1] $ "|");
        if ( MutateStringSplit[1] ~= "help" )
        {
            MessageSpecific(Sender, "[FPI Admin] Commands: split_server", 'Red');
        }else if (MutateStringSplit[1] ~= "split_server")
        {
            ServerTravelMutator.FPIServerTravel();
        } else if (MutateStringSplit[1] ~= "laser")
        {
            Foreach WorldInfo.AllControllers(class'PlayerController', PC)
  {
    if (PC != None)
        PC.ClientPlaySound(SoundCue'RX_Artic_033.Sounds.firinmalazah');
  }
        } else {
            MessageSpecific(Sender, "[FPI Admin] Unknown command", 'Red');
        }
    }
}

/***************** Custom Mutator Hooks *****************/

function MHChatMessage(string msg, PlayerReplicationInfo PRI)
{
local PlayerController PC;
local SoundCue TauntToPlay;

`log("[Mutator Handler]" @ msg);

if(msg ~= "laser")
{
  TauntToPlay = SoundCue'RX_Artic_033.Sounds.firinmalazah'; 
}
    foreach WorldInfo.AllControllers(class'PlayerController', PC)
  {
    if (PC != None)
        PC.ClientPlaySound(TauntToPlay);
  }

}

DefaultProperties
{
}
