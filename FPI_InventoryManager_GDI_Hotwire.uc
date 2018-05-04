/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

class FPI_InventoryManager_GDI_Hotwire extends Rx_InventoryManager_Adv_GDI;

function int GetPrimaryWeaponSlots() { return 3; }

DefaultProperties
{
	PrimaryWeapons[0] = class'FPI_Weapon_RepairGunAdvanced' 
	PrimaryWeapons[1] = class'Rx_Weapon_RemoteC4' 
	SidearmWeapons[0] = class'Rx_Weapon_Pistol'
	AvailableSidearmWeapons(0) = class'Rx_Weapon_Pistol' 
	PrimaryWeapons[2] = class'Rx_Weapon_TimedC4_Multiple' 
 	ExplosiveWeapons[0] = class'Rx_Weapon_ProxyC4'  
}