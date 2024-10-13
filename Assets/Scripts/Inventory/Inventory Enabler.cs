using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class InventoryEnabler : MonoBehaviour
{
    private bool isInventoryEnabled = false;
    void Start()
    {
        foreach (Transform child in transform)
            {
                child.gameObject.SetActive(isInventoryEnabled);
            }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.I)) 
        {
            isInventoryEnabled = !isInventoryEnabled;

            foreach (Transform child in transform)
            {
                child.gameObject.SetActive(isInventoryEnabled);
            }
        }
    }

}
