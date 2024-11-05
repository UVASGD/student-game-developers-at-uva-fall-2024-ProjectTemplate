using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class InventoryEnabler : MonoBehaviour
{
    private bool inventoryEnabledState = false;
    void Start()
    {
        foreach (Transform child in transform)
            {
                child.gameObject.SetActive(inventoryEnabledState);
            }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.I)) 
        {
            inventoryEnabledState = !inventoryEnabledState;

            foreach (Transform child in transform)
            {
                child.gameObject.SetActive(inventoryEnabledState);
            }
        }
    }

    public bool GetCurrentUIState()
    {
        return inventoryEnabledState;
    }

}
