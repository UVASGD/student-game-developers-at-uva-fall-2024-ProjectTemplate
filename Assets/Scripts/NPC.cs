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

    [SerializeField] private InventoryItem.ItemType itemtype;

    [SerializeField] private new Camera camera;

    [SerializeField] private Canvas textbox;


    [SerializeField] private TextMeshProUGUI textMeshPro;
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
        arrowRectTransform = GameObject.Find("TextBubbleArrow").GetComponent<RectTransform>();

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
                    Debug.Log("Error in parsing " + tempStr[j] + " for reqs " + reqsToConv[i]);
                }

            }
        }

        textbox.enabled = false;
    }

    void Update()
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

        if (Input.GetButtonDown("E"))
        {
            if (curDisplay)
            {
                UnityEngine.Vector3 npcPosition = transform.position;
                UnityEngine.Vector3 npcScreenPosition = camera.WorldToScreenPoint(npcPosition);
                
                if (npcScreenPosition.x > minXBoundary && npcScreenPosition.x < maxXBoundary)
                {
                    arrowRectTransform.anchoredPosition = new UnityEngine.Vector2(npcScreenPosition.x, Screen.height * .55f);

                } else if (npcScreenPosition.x < minXBoundary)
                {
                    arrowRectTransform.anchoredPosition = new UnityEngine.Vector2(minXBoundary, Screen.height * .55f);
                }  else if (npcScreenPosition.x > maxXBoundary)
                {
                    arrowRectTransform.anchoredPosition = new UnityEngine.Vector2(maxXBoundary, Screen.height * .55f);
                }
                


                dialogueMode = true;
                playerScript.moveLock = true;
                spriteRenderer.sprite = dialogueQueue[0];
                curDisplay = false;
            }
            
            if (dialogueMode)
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
        }
    }
}
