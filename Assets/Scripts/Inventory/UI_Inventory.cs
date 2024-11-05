using System.Collections;
using System.Collections.Generic;
using Microsoft.Unity.VisualStudio.Editor;
using UnityEngine;
using UnityEngine.UI;

public class UI_Inventory : MonoBehaviour
{
    private Inventory inventory;
    private Transform itemTemplate;

    private Transform inventoryEnabler;

    private List<RectTransform> instantiatedItems = new List<RectTransform>();

    private void Start()
    {
        itemTemplate = transform.Find("Item Template");
        inventoryEnabler = transform.Find("Inventory Enabler");
    }

    public void SetInventory(Inventory inventory)
    {
        this.inventory = inventory;
        RefreshInventoryItems();
    }

    public void RefreshInventoryItems()
    {
        List<InventoryItem> itemList = inventory.GetItemList();

        int x = 0;
        int y = 0;
        float itemSlotCellSize = 100f;


        for (int i = 0; i < itemList.Count; i++)
        {
            InventoryItem item = itemList[i];

            RectTransform itemSlotRectTransform;

            if (i < instantiatedItems.Count)
            {
                itemSlotRectTransform = instantiatedItems[i];
            }
            
            else
            {
                // If the slot doesn't exist, instantiate a new one
                itemSlotRectTransform = Instantiate(itemTemplate).GetComponent<RectTransform>();
                itemSlotRectTransform.SetParent(inventoryEnabler, false);
                itemSlotRectTransform.gameObject.SetActive(true);
                instantiatedItems.Add(itemSlotRectTransform);
            }

            // Set the position and image of the slot (whether new or existing)
            itemSlotRectTransform.anchoredPosition = new Vector2(x * itemSlotCellSize, y * itemSlotCellSize);
            UnityEngine.UI.Image image = itemSlotRectTransform.Find("image").GetComponent<UnityEngine.UI.Image>();
            
            image.sprite = item.GetSprite();

            x++;
            
            if (x > 3) // Assume a 4-column grid
            {
                x = 0;
                y++;
            }
        }
    }




}
