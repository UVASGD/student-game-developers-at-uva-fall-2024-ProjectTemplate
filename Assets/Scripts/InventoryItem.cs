using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InventoryItem
{
    public enum ItemType
    {
        MattressSpring,
        Note,
        Shoes,
        Pencil
    }

    public ItemType itemType;
    public int amount;


}
