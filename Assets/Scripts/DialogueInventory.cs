using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Serialization;


public class DialogueInventory : MonoBehaviour
{
    public enum flag
    {
        defaultFlag, //flag put on all dialogue
        testFlag1,
        testFlag2,
        testFlag3,
        testFlag4,
        testItemFlag,
        monologueFlag1,
        monologueFlag2//demo test flags
    };

    public enum name
    {
        InnerMonologue,
        NPC1,
        NPC2,
    };

    private static readonly SortedDictionary<name, Tuple<String[], flag[]>[]> AllDialogues = new ()
    {
        {name.InnerMonologue, new Tuple<String[], flag[]>[] {
            new (
                new []{ "test dialogue", "test", "test2"},
                new []{ flag.monologueFlag1}),
            new (
                new []{  "yo baby. I have 7 cds", "And three jam boxes"},
                new []{ flag.monologueFlag2}),
        }},
        {name.NPC1, new Tuple<String[], flag[]>[] { 
            new (
                new []{ "Hey!!", "You should go talk to John"},
                new []{ flag.defaultFlag }),
            new (
                new []{  "Some weird things are going on here...", "I heard john might know something", "May do you well to go talk with him"},
                new []{ flag.defaultFlag, flag.testFlag1}),
            new (
                new []{  "ME????", "I don't know ANYTHING"},
                new []{ flag.defaultFlag, flag.testFlag1, flag.testFlag2, flag.testFlag3}),
        }},
        {name.NPC2, new Tuple<String[], flag[]>[] {
            new (
                new []{ "Go away bud"},
                new []{ flag.defaultFlag }),
            new (
                new []{  "Whoever said I know something must hiding something", "They're the real culprit"},
                new []{ flag.defaultFlag, flag.testFlag1, flag.testFlag2}),
            new (
                new []{  "Whoah, cool Icon.SVG dude"},
                new []{ flag.defaultFlag, flag.testItemFlag, flag.testFlag4}),
        }},
    };

    
    /*
     * This system has three parts:
     * 1. AllDialogues have their flags stripped out, with the text of the dialogues stored in _flattenedDialogues
     * 2. learnedDialogueStrings is a list of Strings in the order they were learned. This makes it easy to access
     * 3. _learnedDialogueMetadata has the data necessary to quickly save the dialogue in a space efficient manner
     * The existence of _singleton is not necessary, this could be done with static functions and objects,
     * and a boolean that indicated if the class is set up. However, I am comfortable with the Singleton pattern
     */
    
    private static SortedDictionary<name, String[]> _flattenedDialogues;
    private static DialogueInventory _singleton;
    private Player _player;
    // LearnedDialogues holds all the necessary strings in one list of easy access,
    // and holds all the metadata in another list 
    [FormerlySerializedAs("learnedDialogues")] public List<String> learnedDialogueStrings;
    private List<SerializableTuple<name, int>> _learnedDialogueMetadata;
   
    
    private static void SetupSingleton(Player inPlayer = null)
    {
        // setup flattened dialogue
        _flattenedDialogues.Clear();
        foreach (var npc in AllDialogues)
        {
            foreach (var dialogue in npc.Value)
            {
                _flattenedDialogues.Add(npc.Key, dialogue.Item1);
            }
        }
        
        if (_singleton != null)
        {
            return;
        }
        if (inPlayer == null)
        {
            inPlayer = GameObject.Find("Player").GetComponent<Player>();
        }
        _singleton = inPlayer.AddComponent<DialogueInventory>();
        _singleton._player = inPlayer;
    }
    
    public static bool GetDialogues(name inName, out Tuple<String[], flag[]>[] npcTuple)
    {
        return AllDialogues.TryGetValue(inName, out npcTuple);
    }
    
    // the metadata lets us turn the strings easily into saved references
    public static void MarkDialogueDisplayed(name inName, int index)
    {
        SetupSingleton();
        _singleton.learnedDialogueStrings.Add(_flattenedDialogues[inName][index]);
        _singleton._learnedDialogueMetadata.Add(new SerializableTuple<name, int>(inName, index));
    }

    //called in SavePlayer, before saving player data. Stores the data in the player's knownDialoguesSaveLocation var
    public static void SaveData() 
    {
        SetupSingleton();
        _singleton._player.GetComponent<Player>().SaveLearnedDialogues(_singleton._learnedDialogueMetadata);
    }
    
    // turns loaded tuple array into string array
    // stores loaded tuple array as metadata
    public static void LoadData(Player player, ref List<SerializableTuple<name, int>> data)
    {
        SetupSingleton(player);
        _singleton.learnedDialogueStrings.Clear();
        _singleton._learnedDialogueMetadata.Clear();
        foreach (SerializableTuple<name, int> tuple in data)
        {
            _singleton._learnedDialogueMetadata.Add(tuple);
            _singleton.learnedDialogueStrings.Add(_flattenedDialogues[tuple.term1][tuple.term2]);
        }
    }
}