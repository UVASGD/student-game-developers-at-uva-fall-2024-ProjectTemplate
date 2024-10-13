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
        inventoryItems.Add(new InventoryItem{ itemType = InventoryItem.ItemType.MattressSpring});
    }

    public void AddInventoryItem(InventoryItem item)
    {
        if (item.itemType != InventoryItem.ItemType.None)
        {
             inventoryItems.Add(item);
        }

    }

    public List<InventoryItem> GetItemList()
    {
        return inventoryItems;
    }

}
