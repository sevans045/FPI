/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

class FPI_LoginMessageMutator extends Rx_Mutator;

function InitThisMutator()
{
  `log("################################");
  `log("[Credit Mutator] Successfully inited!");
  `log("################################");
}

function MHOnPlayerConnect(PlayerController NewPlayer, string SteamID)
{
  CheckLoginSteamID(NewPlayer, SteamID);                    // Pass the SteamID of the newly connected player to our check function.
}

function CheckLoginSteamID(PlayerController NewPlayer, string SteamID)
{
  if (SteamID ~= "0x0110000108C01817")            // The person's steam ID.
    {
      SendLoginMessage(NewPlayer, "Sarah is here! Everyone run!!!");     // Obviously trigger the message login.
      PlayLoginSound("Sarah");
    } else if (SteamID ~= "0x01100001099ACC74D"){
      return;
    }
  }

function SendLoginMessage(PlayerController P, string message)
{
  local Controller c;
    foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', c) // Loop through every player's controller.
  	{
  		if ( c != None )
  			if (Rx_Controller(c) != none)
  				Rx_Controller(c).CTextMessage(message, 'Blue'); // Send our message.
  	}
}

function PlayLoginSound(string HumanName)
{
  local PlayerController PC;
  local SoundCue LoginSound;

  if (HumanName ~= "Sarah")
      LoginSound = SoundCue'FPI_FX.Sounds.S_ExtraCrispy';
  `log("Playing login sound for " $ HumanName);

  foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'PlayerController', PC) // Loop through every player's controller.
  {
      PC.ClientPlaySound(LoginSound);
  }
}

DefaultProperties
{
}

// reliable client function CTextMessage(string TEXT, optional name Colour = 'White', optional float TIME = 60.0, optional float Size = 1.0, optional bool bIsCommandMessage)

/*
case 'White':
case 'Red':
case 'Green':
case 'LightGreen':
case 'Blue':
case 'LightBlue':
case 'Pink':
case 'Yellow':
case 'Orange':
*/
