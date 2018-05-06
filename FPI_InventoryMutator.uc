/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 * This file contains source code from Renegade-X, with additional code.
 */

class FPI_InventoryMutator extends UTMutator;

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('Rx_InventoryManager_GDI_Engineer'))
	{
		Rx_InventoryManager_GDI_Engineer(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGun';
		Rx_InventoryManager_GDI_Engineer(Other).PrimaryWeapons[1] = class'Rx_Weapon_RemoteC4';
		Rx_InventoryManager_GDI_Engineer(Other).SidearmWeapons[0] = class'Rx_Weapon_Pistol';
	} else if (Other.IsA('Rx_InventoryManager_GDI_Hotwire'))
	{
		Rx_InventoryManager_GDI_Hotwire(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGunAdvanced';
		Rx_InventoryManager_GDI_Hotwire(Other).PrimaryWeapons[1] = class'Rx_Weapon_RemoteC4';
		Rx_InventoryManager_GDI_Hotwire(Other).PrimaryWeapons[2] = class'Rx_Weapon_TimedC4_Multiple';
		Rx_InventoryManager_GDI_Hotwire(Other).SidearmWeapons[0] = class'Rx_Weapon_Pistol';
		Rx_InventoryManager_GDI_Hotwire(Other).ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
		Rx_InventoryManager_GDI_Hotwire(Other).AvailableExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
	} else if (Other.IsA('Rx_InventoryManager_Nod_Engineer'))
	{
		Rx_InventoryManager_Nod_Engineer(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGun';
		Rx_InventoryManager_Nod_Engineer(Other).PrimaryWeapons[1] = class'Rx_Weapon_RemoteC4';
		Rx_InventoryManager_Nod_Engineer(Other).SidearmWeapons[0] = class'Rx_Weapon_Pistol';
	} else if (Other.IsA('Rx_InventoryManager_Nod_Technician'))
	{
		Rx_InventoryManager_Nod_Technician(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGunAdvanced';
		Rx_InventoryManager_Nod_Technician(Other).PrimaryWeapons[1] = class'Rx_Weapon_RemoteC4';
		Rx_InventoryManager_Nod_Technician(Other).PrimaryWeapons[2] = class'Rx_Weapon_TimedC4_Multiple';
		Rx_InventoryManager_Nod_Technician(Other).ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
		Rx_InventoryManager_Nod_Technician(Other).AvailableExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
		Rx_InventoryManager_Nod_Technician(Other).SidearmWeapons[0] = class'Rx_Weapon_Pistol';
	}
	return true;
}