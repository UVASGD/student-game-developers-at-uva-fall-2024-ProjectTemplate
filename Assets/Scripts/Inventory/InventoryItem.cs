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

    public Sprite GetSprite()
    {
        switch (itemType)
        {
            default:
            case ItemType.MattressSpring:   return ItemAssets.Instance.mattressSpringSprite;
            case ItemType.Note:             return ItemAssets.Instance.noteSprite;
            case ItemType.Shoes:            return ItemAssets.Instance.shoesSprite;
            case ItemType.Pencil:           return ItemAssets.Instance.pencilSprite;
        }
    }


}
