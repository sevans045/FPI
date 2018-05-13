class FPI_VeterancyMutator extends Rx_Mutator;

function InitThisMutator()
{
  `log("################################");
  `log("[Veterancy Mutator] Successfully inited!");
  `log("################################");
}

function MHOnPlayerKill(Controller Killer, Controller Victim, Pawn KilledPawn, class<DamageType> damageType)
{
	local string VPString;
	local int KillerVRank;
	local int VictimVRank;
	local int LostVP;
	local class<Rx_FamilyInfo> Victim_FamInfo;
	local Rx_PRI VictimPRI;
	local Rx_PRI KillerPRI;

	KillerPRI = Rx_PRI(Killer.PlayerReplicationInfo);
	VictimPRI = Rx_PRI(Victim.PlayerReplicationInfo);

	Victim_FamInfo=Rx_Pawn(KilledPawn).GetRxFamilyInfo();

	if(Rx_Vehicle(Killer.Pawn) != none ) //I got shot by a vehicool  
	{
		//KillerisVehicle = true; 
		//Killer_VehicleType = class<Rx_Vehicle>(Killer.Pawn.class); Shouldn't really come into play.
		//Get Veterancy Rank
		KillerVRank = Rx_Vehicle(Killer.Pawn).GetVRank(); 

	}
	else 
	//They're a Pawn, Harry
	if(Rx_Pawn(Killer.Pawn) != none )
	{
		//KillerisPawn = true; //Disabled for compile. Reenable this later.
		//Killer_FamInfo = Rx_Pawn(Killer.Pawn).GetRxFamilyInfo();
		//Get Veterancy Rank
		KillerVRank = Rx_Pawn(Killer.Pawn).GetVRank(); 
	}

	VictimVRank = VictimPRI.VRank;

	if(KillerVRank < VictimVRank)
	{

	}

	VPString = VPString $ "[Death]&-" $ LostVP $ "&";
}
