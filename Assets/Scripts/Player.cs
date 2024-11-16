using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class Player : MonoBehaviour
{
    public bool moveLock = true;

    private bool firstTimeInventoryOpen = true;
    
    //private Vector2 _input;
    private CharacterController _characterController;
    private float speed = 50f;

    public Inventory inventory;

    [SerializeField] private SpriteRenderer body;
    [SerializeField] private SpriteRenderer hair;
    [SerializeField] private SpriteRenderer hairColor;
    [SerializeField] private SpriteRenderer eye;
    [SerializeField] private SpriteRenderer eyeColor;

    [SerializeField] private Sprite[] bodies;
    [SerializeField] private Sprite[] hairs;
    [SerializeField] private Sprite[] hairColors;
    [SerializeField] private Sprite[] eyes;
    [SerializeField] private Sprite[] eyeColors;
    
    [SerializeField] private UI_Inventory uI_Inventory;
    [SerializeField] private List<DialogueInventory.ConvoMetadata> knownDialoguesSaveLocation;
    
    public HashSet<DialogueInventory.Flag> dialogueFlags = new HashSet<DialogueInventory.Flag>();

    private void Start()
    {
        body.sprite = bodies[PlayerPrefs.GetInt("bodyIndex")];
        int hairIndex = PlayerPrefs.GetInt("hairIndex");
        hair.sprite = hairs[hairIndex];
        hairColor.sprite = hairColors[PlayerPrefs.GetInt("hairCIndex") + hairIndex*5];
        int eyeIndex = PlayerPrefs.GetInt("eyeIndex");
        eye.sprite = eyes[eyeIndex];
        eyeColor.sprite = eyeColors[PlayerPrefs.GetInt("eyeCIndex") + eyeIndex*5];
        inventory = new Inventory();

        _characterController = GetComponent<CharacterController>();

        SaveData data = SaveSystem.LoadPlayer();

        for(int i=0; i < data.flags.Length; i++)
        {
            dialogueFlags.Add((DialogueInventory.Flag)data.flags[i]);
        }

        for(int i=0; i < data.inventoryItems.Length; i++)
        {
            InventoryItem inventoryItemData = new InventoryItem();
            inventoryItemData.itemType = (InventoryItem.ItemType) data.inventoryItems[i];
            inventory.AddInventoryItem(inventoryItemData);
        }

        knownDialoguesSaveLocation = data.learnedDialogues;
        if(knownDialoguesSaveLocation == null){
            knownDialoguesSaveLocation = new List<DialogueInventory.ConvoMetadata>{};
        }
        DialogueInventory.LoadData(this, in knownDialoguesSaveLocation);
        
        transform.position = new Vector3(data.playerPosition[0], data.playerPosition[1], data.playerPosition[2]);
        moveLock = true;
        Invoke("moveLockOff", 0.5f);

        DialogueInventory.MarkDialogueDisplayed(DialogueInventory.Name.Timothy, 0);
        DialogueInventory.MarkDialogueDisplayed(DialogueInventory.Name.Timothy, 1);
        DialogueInventory.MarkDialogueDisplayed(DialogueInventory.Name.Janet, 1);
        DialogueInventory.MarkDialogueDisplayed(DialogueInventory.Name.Janet, 0);
    }

    // Update is called once per frame
    void Update()
    {
        if (!moveLock)
        {
            Vector3 move = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical"));
            _characterController.Move(move * Time.deltaTime * speed);
        }

        if (Input.GetKeyDown(KeyCode.I) && firstTimeInventoryOpen)
        {
            firstTimeInventoryOpen = false;
            uI_Inventory.SetInventory(inventory);

        } else if (Input.GetKeyDown(KeyCode.I))
        {
            uI_Inventory.RefreshInventoryItems();
        }
    }

    void moveLockOff()
    {
        moveLock = false;
    }

    //testing purposes
    public void printFlags()
    {
        DialogueInventory.Flag[] flagsEnum = new DialogueInventory.Flag[dialogueFlags.Count];
        dialogueFlags.CopyTo(flagsEnum);
        string output = "";
        for (int i = 0; i < flagsEnum.Length; i++)
        {
            output += flagsEnum[i];
            output += " ";
        }
        Debug.Log(output);
    }

    public void AddToInventory(InventoryItem inventoryItem)
    {
        inventory.AddInventoryItem(inventoryItem);
    }

    public void SaveLearnedDialogues(in List<DialogueInventory.ConvoMetadata> inList)
    {
        knownDialoguesSaveLocation = inList;
    }
}
