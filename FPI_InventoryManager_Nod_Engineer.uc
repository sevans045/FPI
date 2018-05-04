/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 */

class FPI_InventoryManager_Nod_Engineer extends Rx_InventoryManager_Basic;

function int GetPrimaryWeaponSlots() { return 2; }

DefaultProperties
{
    PrimaryWeapons(0)=class'FPI_Weapon_RepairGun'
    PrimaryWeapons(1)=class'Rx_Weapon_RemoteC4'
    SidearmWeapons(0)=class'Rx_Weapon_Pistol'
    AvailableSidearmWeapons(0)=class'Rx_Weapon_Pistol'
}

