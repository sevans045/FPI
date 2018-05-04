class FPI_InventoryMutator extends UTMutator;

function bool CheckReplacement(Actor Other)
{
	if (Other.IsA('Rx_InventoryManager_GDI_Engineer'))
	{
		Rx_InventoryManager_GDI_Engineer(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGun';
	} else if (Other.IsA('Rx_InventoryManager_GDI_Hotwire'))
	{
		Rx_InventoryManager_GDI_Hotwire(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGunAdvanced';
		Rx_InventoryManager_GDI_Hotwire(Other).ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
		Rx_InventoryManager_GDI_Hotwire(Other).AvailableExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
	} else if (Other.IsA('Rx_InventoryManager_Nod_Engineer'))
	{
		Rx_InventoryManager_Nod_Engineer(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGun';
	} else if (Other.IsA('Rx_InventoryManager_Nod_Technician'))
	{
		Rx_InventoryManager_Nod_Technician(Other).PrimaryWeapons[0] = class'FPI_Weapon_RepairGunAdvanced';
		Rx_InventoryManager_Nod_Technician(Other).ExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
		Rx_InventoryManager_Nod_Technician(Other).AvailableExplosiveWeapons[0] = class'FPI_Weapon_ProxyC4';
	}
	return true;
}