using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;

public class ScrollBarText : MonoBehaviour
{

     TextMeshProUGUI textMeshPro;
     string combinedDialogueStrings = "";

    void Start()
    {
        textMeshPro = GetComponent<TextMeshProUGUI>();
    }

    // Update is called once per frame

    public void ShowDialogue()
    {
        List<String> dialogueStrings = DialogueInventory.Get().learnedDialogueStrings;

        foreach (string dialogueString in dialogueStrings)
        {
            if (!combinedDialogueStrings.Contains(dialogueString))
            {
                combinedDialogueStrings += dialogueString;
                combinedDialogueStrings += "\n\n"; 
            }
        }

        textMeshPro.text = combinedDialogueStrings;
    }

}
