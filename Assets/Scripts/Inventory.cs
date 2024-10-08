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
        Debug.Log("invetory created");
        inventoryItems.Add(new InventoryItem{ itemType = InventoryItem.ItemType.MattressSpring});
        inventoryItems.Add(new InventoryItem{ itemType = InventoryItem.ItemType.Shoes});
        inventoryItems.Add(new InventoryItem{ itemType = InventoryItem.ItemType.Note});
        Debug.Log(inventoryItems.Count);
    }

    public void AddInventoryItem(InventoryItem item)
    {
        inventoryItems.Add(item);
    }

    public List<InventoryItem> GetItemList()
    {
        return inventoryItems;
    }

}
