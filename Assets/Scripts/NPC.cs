using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Runtime.CompilerServices;
using TMPro;
using TreeEditor;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class NPC : MonoBehaviour{

    private GameObject player;
    private Player playerScript;
    private bool curDisplay = false;
    private bool dialogueMode = false;

    //private bool firstTimeRead = true; unnecissary? <- this comment is for you Seb

    private InventoryEnabler uiEnabler;

    [SerializeField] private InventoryItem[] inventoryItem;

    [SerializeField] private new Camera camera;

    [SerializeField] private Canvas textbox;


    [SerializeField] private TextMeshProUGUI textMeshPro;
    private InnerMonologue imScript;
   // private DialogueManager dialogueManager;
    [SerializeField] private SpriteRenderer spriteRenderer;
    [SerializeField] private Sprite[] dialogueQueue; //0-empty, 1-?, 2-!
    [SerializeField] private DialogueInventory.Name NPCname;

    private float minXBoundary; // Minimum x boundary in screen space
    private float maxXBoundary; // Maximum x boundary in screen space
    
    private RectTransform arrowRectTransform;
    private string[] dialogueSplit;
    private int dialogueIndex = 0;
    private int curDialogue;


    private Tuple<String[], DialogueInventory.Flag[]>[] dialogueTuples;

    void Start()
    {
        minXBoundary = Screen.width * 0.25f;
        maxXBoundary = Screen.width * 0.75f;
        player = GameObject.Find("Player");
        playerScript = player.GetComponent<Player>();
        imScript = InnerMonologue.GetImScript();
        //dialogueManager = DialogueManager.GetDialogueManager();
        arrowRectTransform = GameObject.Find("TextBubbleArrow").GetComponent<RectTransform>();
        uiEnabler = GameObject.Find("Inventory Enabler").GetComponent<InventoryEnabler>();
        // if (!DialogueInventory.GetDialogues(NPCname, out dialogueTuples))
        // {
        //     Debug.LogError("NPC name '" + NPCname + "' not found");
        // }
        

        textbox.enabled = false;
    }

    void Update()
    {
        double dist = Mathf.Sqrt(Mathf.Pow(player.transform.position.x - transform.position.x, 2) + Mathf.Pow(player.transform.position.z - transform.position.z, 2));
        double height = Mathf.Abs(player.transform.position.y - transform.position.y);
        if (dist <= 50 && height <= 20 && !curDisplay && !dialogueMode)
        {
            curDisplay = true;
            if (Input.GetButtonDown("E") && !uiEnabler.GetCurrentUIState() && curDisplay)
            {
                //dialogueManager.StartDialogue(this, GetDialogue()); //Seb's function

                /*AdjustDialogueArrow();
                dialogueMode = true;
                playerScript.moveLock = true;
                spriteRenderer.sprite = dialogueQueue[0];
                curDisplay = false;
                displayDialogue();*/
            }
        }
        else if ((dist > 70 || height > 20) && curDisplay)
        {
            curDisplay = false;
            spriteRenderer.sprite = dialogueQueue[0];
        }

        

        /*if (Input.GetButtonDown("Space") && !uiEnabler.GetCurrentUIState() && dialogueMode)
        {
            displayDialogue();
        }*/
    }
    Tuple<String[], DialogueInventory.Flag[]> GetDialogue()
    {
        
        for (int i = 1; i < dialogueTuples.Length; i++)
        {
            var currentTuple = dialogueTuples[i];
            var flags = currentTuple.Item2;
            var flagAddedOnComplete = flags.Last();
            if (!playerScript.dialogueFlags.Contains(flagAddedOnComplete))
            {
                int numOfRequiredFlags = flags.Length - 1;
                for (int reqIndex = 0; reqIndex < numOfRequiredFlags ; reqIndex++)
                {
                    if (!playerScript.dialogueFlags.Contains(flags[reqIndex]))
                    {
                        spriteRenderer.sprite = dialogueQueue[1];
                        return dialogueTuples[i-1];
                    }
                }
            }
        }
        spriteRenderer.sprite = dialogueQueue[2];
        return dialogueTuples.Last();
    }
    

    /*void displayDialogue()
    {
        if(dialogueIndex < dialogueSplit.Length)
        {
            textbox.enabled = true;
            textMeshPro.SetText(dialogueSplit[dialogueIndex]);
            
            if (firstTimeRead && inventoryItem[dialogueIndex].itemType != InventoryItem.ItemType.None)
            {
                playerScript.AddToInventory(inventoryItem[dialogueIndex]);
            }

            dialogueIndex++;
        }
        else
        {
            textbox.enabled = false;
            if (curDialogue != 0)
            {
                playerScript.dialogueFlags.Add(reqs[curDialogue].Last());
            }
            dialogueIndex = 0;
            dialogueMode = false;
            playerScript.moveLock = false;
            firstTimeRead = false;
            if (curDialogue != 0)
            {
                playerScript.dialogueFlags.Add(reqs[curDialogue].Last());
                imScript.monologueCheck(reqs[curDialogue].Last());
            }
        }
    }

    void AdjustDialogueArrow()
    {
        UnityEngine.Vector3 npcPosition = transform.position;
        UnityEngine.Vector3 npcScreenPosition = camera.WorldToScreenPoint(npcPosition);
                
                if (npcScreenPosition.x > minXBoundary && npcScreenPosition.x < maxXBoundary)
                {
                    arrowRectTransform.anchoredPosition = new UnityEngine.Vector2(npcScreenPosition.x, Screen.height * .60f);

                } else if (npcScreenPosition.x < minXBoundary)
                {
                    arrowRectTransform.anchoredPosition = new UnityEngine.Vector2(minXBoundary, Screen.height * .60f);

                }  else if (npcScreenPosition.x > maxXBoundary)
                {
                    arrowRectTransform.anchoredPosition = new UnityEngine.Vector2(maxXBoundary, Screen.height * .60f);
                }
    }

    
    
    public int getCurrentDialogueIndex()
    {
        return curDialogue;
    }*/
}
