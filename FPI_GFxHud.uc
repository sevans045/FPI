/* Copyright (C) taisho.xyz - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Sarah Evans <sarahevans045@gmail.com>, 2017-2018
 */
 
class FPI_GFxHud extends Rx_GFxHud;

function UpdateWeapon(UTWeapon Weapon)
{
    Super.UpdateWeapon(Weapon);

    if (Weapon.IsA('Rx_Weapon_RepairTool'))
    {
        super.UpdateWeapon(Weapon);
    } else if(Weapon.IsA('Rx_Weapon_RepairGun'))
    {
        AmmoInClipN.SetText("1337");
        AmmoReserveN.SetText("");
    }
}

DefaultProperties
{
}
