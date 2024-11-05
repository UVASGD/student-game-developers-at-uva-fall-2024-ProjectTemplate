using UnityEngine;
using UnityEngine.UI;

public class InventoryEnabler : MonoBehaviour
{
    private bool inventoryEnabledState = false;
    private Image parentCanvasImage;

    void Start()
    {
        // Find the parent Canvas and get its Image component
        Canvas parentCanvas = GetComponentInParent<Canvas>();
        if (parentCanvas != null)
        {
            parentCanvasImage = parentCanvas.GetComponent<Image>();
            if (parentCanvasImage == null)
            {
                Debug.LogWarning("Parent Canvas does not have an Image component.");
            }
        }
        else
        {
            Debug.LogError("No parent Canvas found.");
        }

        // Set initial state
        SetInventoryState(inventoryEnabledState);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.I)) 
        {
            inventoryEnabledState = !inventoryEnabledState;
            SetInventoryState(inventoryEnabledState);
        }
    }

    private void SetInventoryState(bool state)
    {
        // Set state for all child objects
        foreach (Transform child in transform)
        {
            child.gameObject.SetActive(state);
        }

        // Set state for parent Canvas Image
        if (parentCanvasImage != null)
        {
            parentCanvasImage.enabled = state;
        }
    }

    public bool GetCurrentUIState()
    {
        return inventoryEnabledState;
    }
}