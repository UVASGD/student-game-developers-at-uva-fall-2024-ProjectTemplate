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

    private bool firstTimeRead = true;

    private InventoryEnabler uiEnabler;

    [SerializeField] private InventoryItem[] inventoryItem;

    [SerializeField] private new Camera camera;

    [SerializeField] private Canvas textbox;


    [SerializeField] private TextMeshProUGUI textMeshPro;
    private InnerMonologue imScript;
    [SerializeField] private SpriteRenderer spriteRenderer;
    [SerializeField] private Sprite[] dialogueQueue; //0-empty, 1-?, 2-!

    private float minXBoundary; // Minimum x boundary in screen space
    private float maxXBoundary; // Maximum x boundary in screen space
    
    private RectTransform arrowRectTransform;
    private string[] dialogueSplit;
    private int dialogueIndex = 0;
    private int curDialogue;


    [SerializeField] private string[] dialogue;
    [SerializeField] private string[] reqsToConv;
    private Player.flags[][] reqs;

    void Start()
    {
        minXBoundary = Screen.width * 0.25f;
        maxXBoundary = Screen.width * 0.75f;
        player = GameObject.Find("Player");
        playerScript = player.GetComponent<Player>();
        imScript = InnerMonologue.GetImScript();
        arrowRectTransform = GameObject.Find("TextBubbleArrow").GetComponent<RectTransform>();
        uiEnabler = GameObject.Find("Inventory Enabler").GetComponent<InventoryEnabler>();

        string[] tempStr;
        reqs = new Player.flags[reqsToConv.Length][];
        for (int i=0; i < reqsToConv.Length; i++)
        {
            tempStr = reqsToConv[i].Split(',');
            reqs[i] = new Player.flags[tempStr.Length];
            for(int j=0; j < tempStr.Length; j++)
            {
                if (!Enum.TryParse<Player.flags>(tempStr[j], out reqs[i][j]))
                {
                    reqs[i][j] = 0;
                    Debug.Log("Error in parsing " + tempStr [j] + " for reqs " + reqsToConv[i]);
                }

            }
        }

        textbox.enabled = false;
    }

    void Update()
    {
        if (!imScript.dialogueMode)
        {
            double dist = Mathf.Sqrt(Mathf.Pow(player.transform.position.x - transform.position.x, 2) + Mathf.Pow(player.transform.position.z - transform.position.z, 2));
            double height = Mathf.Abs(player.transform.position.y - transform.position.y);
            if (dist <= 50 && height <= 20 && !curDisplay && !dialogueMode)
            {
                curDisplay = true;
                dialogueCheck();
            }
            else if ((dist > 70 || height > 20) && curDisplay)
            {
                curDisplay = false;
                spriteRenderer.sprite = dialogueQueue[0];
            }

            if (Input.GetButtonDown("E") && !uiEnabler.GetCurrentUIState() && curDisplay)
            {
                AdjustDialogueArrow();
                dialogueMode = true;
                playerScript.moveLock = true;
                spriteRenderer.sprite = dialogueQueue[0];
                curDisplay = false;
                displayDialogue();
            }

            if (Input.GetButtonDown("Space") && !uiEnabler.GetCurrentUIState() && dialogueMode)
            {
                displayDialogue();
            }
        }
    }

    void dialogueCheck()
    {
        bool toRead = false;
        for (int i = 1; i < dialogue.Length; i++)
        {
            toRead = true;
            if (!playerScript.dialogueFlags.Contains(reqs[i].Last()))
            {
                int len = reqs[i].Length - 1;
                for (int j = 0; j < len; j++)
                {
                    if (!playerScript.dialogueFlags.Contains(reqs[i][j]))
                    {
                        toRead = false;
                    }
                }
            }
            else
            {
                toRead = false;
            }

            if (toRead)
            {
                //add if statement that gets boolean from specific quest "can move on" function
                dialogueSplit = dialogue[i].Split('|');
                curDialogue = i;
                break;
            }
        }

        if (!toRead)
        {
            dialogueSplit = dialogue[0].Split('|');
            curDialogue = 0;
            spriteRenderer.sprite = dialogueQueue[1];
        }
        else
        {
            spriteRenderer.sprite = dialogueQueue[2];
        }
    }

    void displayDialogue()
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
    }
}
