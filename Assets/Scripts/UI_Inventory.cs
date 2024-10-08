using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UI_Inventory : MonoBehaviour
{
    private Inventory inventory;
    private Transform inventoryScreenBackground;
    private Transform itemTemplate;

    private void Start()
    {
        inventoryScreenBackground = transform.Find("InventoryScreenBackground");
        itemTemplate = transform.Find("Item Template");
    }

    public void SetInventory(Inventory inventory)
    {
        this.inventory = inventory;
        RefreshInventoryItems();
    }

    private void RefreshInventoryItems()
    {
        int x = 0;
        int y = 0;
        float itemSlotCellSize = 100f;
        foreach (InventoryItem item in inventory.GetItemList())
        {
            RectTransform itemSlotRectTransform = Instantiate(itemTemplate).GetComponent<RectTransform>();
            itemSlotRectTransform.gameObject.SetActive(true);
            itemSlotRectTransform.SetParent(inventoryScreenBackground, false);
            itemSlotRectTransform.anchoredPosition = new Vector2(x * itemSlotCellSize, y * itemSlotCellSize);
            x++;
            if (x > 3)
            {
                x = 0;
                y++;
            }
        }
    }




}
