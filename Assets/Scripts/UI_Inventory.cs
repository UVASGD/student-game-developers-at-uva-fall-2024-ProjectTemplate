using System.Collections;
using System.Collections.Generic;
using Microsoft.Unity.VisualStudio.Editor;
using UnityEngine;
using UnityEngine.UI;

public class UI_Inventory : MonoBehaviour
{
    private Inventory inventory;
    private Transform inventoryScreenBackground;
    private Transform itemTemplate;

    private Transform inventoryEnabler;

    private void Start()
    {
        inventoryScreenBackground = transform.Find("InventoryScreenBackground");
        itemTemplate = transform.Find("Item Template");
        inventoryEnabler = transform.Find("Inventory Enabler");

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
            itemSlotRectTransform.SetParent(inventoryEnabler, false);
            itemSlotRectTransform.gameObject.SetActive(true);
            itemSlotRectTransform.anchoredPosition = new Vector2(x * itemSlotCellSize, y * itemSlotCellSize);
            UnityEngine.UI.Image image = itemSlotRectTransform.Find("image").GetComponent<UnityEngine.UI.Image>();
            image.sprite = item.GetSprite();
            x++;
            if (x > 3)
            {
                x = 0;
                y++;
            }
        }
    }




}
