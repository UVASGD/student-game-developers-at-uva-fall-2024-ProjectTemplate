using System.Collections;
using System.Collections.Generic;
using Microsoft.Unity.VisualStudio.Editor;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UI_Inventory : MonoBehaviour
{
    private Inventory inventory;
    private Transform itemTemplate;


    private Transform inventoryEnabler;


    private bool itemTextState;

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

            Button button = itemSlotRectTransform.Find("Button").GetComponent<Button>();

        // Add a listener to the button that enables the itemText when clicked
             button.onClick.AddListener(() => ToggleItemText(itemSlotRectTransform, item));

            Transform itemText = itemSlotRectTransform.Find("ItemText");
            itemText.gameObject.SetActive(false);

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

private void ToggleItemText(Transform itemSlot, InventoryItem item)
{
    // Find the empty 'ItemText' parent object first
    Transform itemText = itemSlot.Find("ItemText");

    if (itemText != null)
    {
        // Find the actual TextMeshPro component inside 'ItemText'
        TextMeshProUGUI textComponent = itemText.Find("Iventory Item Text").GetComponent<TextMeshProUGUI>();

        if (textComponent != null)
        {
            // Toggle the active state of the 'ItemText' GameObject
            bool isActive = itemText.gameObject.activeSelf;

            if (isActive)
            {
                // If it's active, turn it off
                itemText.gameObject.SetActive(false);
            }
            else
            {
                // If it's inactive, enable it and update the text
                itemText.gameObject.SetActive(true);
                Debug.Log(item.itemDescription);
                textComponent.text = item.itemDescription;
                Debug.Log(textComponent.text);  // Set the text
            }
        }
        else
        {
            Debug.LogError("TextMeshProUGUI component not found!");
        }
    }
    else
    {
        Debug.LogError("ItemText not found!");
    }
}


}
