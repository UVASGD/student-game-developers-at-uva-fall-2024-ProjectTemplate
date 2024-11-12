using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;

public class InnerMonologue : MonoBehaviour
{
    // Start is called before the first frame update
    private GameObject player;
    private Player playerScript;
    public bool dialogueMode = false;

    private InventoryEnabler uiEnabler;

    [SerializeField] private Canvas textbox;
    [SerializeField] private TextMeshProUGUI textMeshPro;

    private string[] dialogueSplit;
    private int monologueIndex = 0;
    private int dialogueIndex = 0;
    private int curDialogue;
    
    private static InnerMonologue _singleton;

    private string[] dialogue = {
        "test dialogue|test|test2", 
        "yo baby. I have 7 cds|And three jam boxes"
    };
    private DialogueInventory.flags[] flags = {
        DialogueInventory.flags.monologueFlag1,
        DialogueInventory.flags.monologueFlag2
    };

    public static InnerMonologue GetImScript()
    {
        if (_singleton == null)
        {
            GameObject playerRef = GameObject.Find("Player");
            if (playerRef == null)
            {
                Debug.LogError("Player ref is an error in InnerMonologue, rename player to Player");
                return null;
            }
            _singleton = playerRef.AddComponent<InnerMonologue>();
            _singleton.player = playerRef;
        }
        return _singleton;
    }
    
    void Start()
    {
        if (_singleton != this)
        {
            Destroy(this);
            return;
        }
        player = GameObject.Find("Player");
        playerScript = player.GetComponent<Player>();
        textbox = GameObject.Find("Inner Monologue").GetComponent<Canvas>();
        textMeshPro = textbox.GetComponentInChildren<TextMeshProUGUI>();
        uiEnabler = GameObject.Find("Inventory Enabler").GetComponent<InventoryEnabler>();
        textbox.enabled = false;
    }

    void Update()
    {
        if (Input.GetButtonDown("Space") && !uiEnabler.GetCurrentUIState() && dialogueMode)
        {
            displayDialogue();
        }
    }

    public void monologueCheck(DialogueInventory.flags f)
    {
        //test conditions
        //needed both to test, but both can't be active at once
        /*if (f == DialogueInventory.flags.testFlag2 && playerScript.dialogueFlags.Contains(DialogueInventory.flags.testFlag1))
        {
            monologueStart(0, true);
        }
        else if (f == DialogueInventory.flags.testFlag1 && playerScript.dialogueFlags.Contains(DialogueInventory.flags.testFlag2))
        {
            monologueStart(0, true);
        }*/

        if (f == DialogueInventory.flags.testFlag2 && playerScript.dialogueFlags.Contains(DialogueInventory.flags.testItemFlag))
        {
            monologueStart(1, true);
        }
        else if (f == DialogueInventory.flags.testItemFlag && playerScript.dialogueFlags.Contains(DialogueInventory.flags.testFlag2))
        {
            monologueStart(1, false);
        }
    }

    //If monologueStart is activated by picking up an item isDialogue=false, if it is activated by talking to an NPC isDialogue=true
    void monologueStart(int index, bool isDialogue)
    {
        monologueIndex = index;
        dialogueSplit = dialogue[monologueIndex].Split('|');
        dialogueMode = true;
        textbox.enabled = true;
        playerScript.moveLock = true;
        dialogueIndex = 0;
        if (!isDialogue)
        {
            displayDialogue();
        }
    }

    void displayDialogue()
    {
        if (dialogueIndex < dialogueSplit.Length)
        {
            textMeshPro.SetText(dialogueSplit[dialogueIndex]);
            dialogueIndex++;
        }
        else
        {
            textbox.enabled = false;
            playerScript.dialogueFlags.Add(flags[monologueIndex]);
            playerScript.moveLock = false;
            dialogueIndex = 0;
            dialogueMode = false;
        }
    }
}
