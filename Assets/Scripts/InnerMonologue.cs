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
    private int dialogueIndex = 0;
    private int curDialogue;
    
    private static InnerMonologue _singleton;

    private string[] dialogue = {
        "test dialogue", 
        "yo baby. I have 7 cds|And three jam boxes"
    };
    private Player.flags[] flags = {
        Player.flags.monologueFlag1,
        Player.flags.monologueFlag2
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

        playerScript = player.GetComponent<Player>();
        textbox = GameObject.Find("Dialogue - Canvas").GetComponent<Canvas>();
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

    public void monologueCheck(Player.flags f)
    {
        //test conditions
        if (f == Player.flags.testFlag2 && playerScript.dialogueFlags.Contains(Player.flags.testFlag1))
        {
            monologueStart(0);
        }
        else if (f == Player.flags.testFlag1 && playerScript.dialogueFlags.Contains(Player.flags.testFlag2))
        {
            monologueStart(0);
        }
    }
    void monologueStart(int index)
    {
        dialogueSplit = dialogue[index].Split('|');
        dialogueMode = true;
        textbox.enabled = true;
        playerScript.moveLock = true;
        displayDialogue();
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
            playerScript.dialogueFlags.Add(flags[dialogueIndex]);
            playerScript.moveLock = false;
            dialogueIndex = 0;

            dialogueMode = true;
        }
    }
}
