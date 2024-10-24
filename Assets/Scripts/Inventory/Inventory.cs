using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UIElements;

public class Inventory
{
    private List<InventoryItem> inventoryItems;

    public Inventory()
    {
        inventoryItems = new List<InventoryItem>();
    }

    public void AddInventoryItem(InventoryItem item)
    {
        if (item.itemType == InventoryItem.ItemType.None)
        {
            return;
        }

        inventoryItems.Add(item);

    }

    public bool HasItemOfType(InventoryItem.ItemType type)
    {

        bool typeFound = false;

        foreach (InventoryItem item in inventoryItems)
        {
            if (item.itemType == type)
            {
                return true;
            }
        }


        return typeFound;
    }


    public List<InventoryItem> GetItemList()
    {
        return inventoryItems;
    }

}
