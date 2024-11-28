using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

[System.Serializable]
public class InventoryItem
{
    public enum ItemType
    {
        MattressSpring,
        Note,
        Shoes,
        Pencil,
        None
    }

    public InventoryItem()
    {
        this.itemType = ItemType.None;
    }

    public ItemType itemType;

    public string itemDescription;

    public Sprite GetSprite()
    {
        switch (itemType)
        {
            default:
            case ItemType.MattressSpring:   return ItemAssets.Instance.mattressSpringSprite;
            case ItemType.Note:             return ItemAssets.Instance.noteSprite;
            case ItemType.Shoes:            return ItemAssets.Instance.shoesSprite;
            case ItemType.Pencil:           return ItemAssets.Instance.pencilSprite;
            case ItemType.None:             return null;
        }
    }

    public string GetItemDescription()
    {
        return itemDescription;
    }


}
