/*
 * This file is in the public domain, furnished "as is", without technical
 * support, and with no warranty, express or implied, as to its usefulness for
 * any purpose.
 *
 * Written by Sarah Evans <sarahevans045@gmail.com>
 * Created for Fair Play Renegade-X Community
 * This file contains source code from Renegade-X, with additional code.
 */
 
class FPI_GFxHud extends Rx_GFxHud;

function UpdateWeapon(UTWeapon Weapon)
{
    local Rx_Controller rxPC;

    // End:0x4A1
    if(Weapon != lastWeaponHeld)
    {
        AmmoInClipValue = -1;
        AmmoInReserveValue = -1;
        UpdateHUDVars();
        WeaponName.SetText(class'FPI_MutatorHandler'.static.GetCustomWeaponNames(Weapon));
        if(Rx_Weapon(Weapon).HasInfiniteAmmo())
        {
            AmmoReserveN.SetVisible(false);
            InfinitAmmo.SetVisible(true);
        }
        else
        {
            AmmoReserveN.SetVisible(true);
            InfinitAmmo.SetVisible(false);
        }
        rxPC = Rx_Controller(GetPC());
        PrevWeapon = rxPC.GetPrevWeapon(Weapon);
        NextWeapon = rxPC.GetNextWeapon(Weapon);
        if(lastWeaponHeld == PrevWeapon)
        {
            ChangedWeapon("switchedToNextWeapon");
        }
        else
        {
            ChangedWeapon("switchedToPrevWeapon");
        }
        lastWeaponHeld = Weapon;
        LoadTexture(((Rx_Weapon(Weapon).WeaponIconTexture != none) ? "img://" $ PathName(Rx_Weapon(Weapon).WeaponIconTexture) : PathName(texture2d'T_WeaponIcon_MissingCameo')), WeaponMC);
        if((PrevWeapon != none) && Rx_Weapon(PrevWeapon) != none)
        {
            WeaponPrevMC.SetVisible(true);
            LoadTexture(((Rx_Weapon(PrevWeapon).WeaponIconTexture != none) ? "img://" $ PathName(Rx_Weapon(PrevWeapon).WeaponIconTexture) : PathName(texture2d'T_WeaponIcon_MissingCameo')), WeaponPrevMC);
        }
        else
        {
            WeaponPrevMC.SetVisible(false);
        }
        if((NextWeapon != none) && Rx_Weapon(PrevWeapon) != none)
        {
            WeaponNextMC.SetVisible(true);
            LoadTexture(((Rx_Weapon(NextWeapon).WeaponIconTexture != none) ? "img://" $ PathName(Rx_Weapon(NextWeapon).WeaponIconTexture) : PathName(texture2d'T_WeaponIcon_MissingCameo')), WeaponNextMC);
        }
        else
        {
            WeaponNextMC.SetVisible(false);
        }
    }
    if(Rx_Weapon_Reloadable(Weapon) != none)
    {
        if(AmmoInClipValue != Rx_Weapon_Reloadable(Weapon).GetUseableAmmo())
        {
            AmmoInClipValue = Rx_Weapon_Reloadable(Weapon).GetUseableAmmo();
            AmmoInClipN.SetText(string(AmmoInClipValue));
            AmmoBar.GotoAndStopI(int((float(AmmoInClipValue) / float(Rx_Weapon_Reloadable(Weapon).GetMaxAmmoInClip())) * float(100)));
        }
        if(AmmoInReserveValue != Rx_Weapon_Reloadable(Weapon).GetReserveAmmo())
        {
            AmmoInReserveValue = Rx_Weapon_Reloadable(Weapon).GetReserveAmmo();
            AmmoReserveN.SetText(string(AmmoInReserveValue));
        }
        if(((Rx_Weapon_Reloadable(Weapon) != none) && Rx_Weapon_Reloadable(Weapon).CurrentlyReloading) && !Rx_Weapon_Reloadable(Weapon).PerBulletReload)
        {
            AnimateReload(Weapon.WorldInfo.TimeSeconds - Rx_Weapon_Reloadable(Weapon).reloadBeginTime, Rx_Weapon_Reloadable(Weapon).currentReloadTime, AmmoBar);
        }
    }
    if(Weapon.IsA('Rx_Weapon_RepairGun'))
    {
        AmmoInClipN.SetText("1337");
    }
}

