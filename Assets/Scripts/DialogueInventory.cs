using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Serialization;



public class DialogueInventory : MonoBehaviour
{
    // Represents a list of dialogue and the required Flags to trigger it
    //
    
    
    public struct Convo
    {
        public string[] Dialogue;
        public Flag[] RequiredFlags;
        public Flag[] GrantedFlags;

        public Convo(string[] strings, Flag[] requiredFlags, Flag[] grantedFlags)
        {
            Dialogue = strings;
            RequiredFlags = requiredFlags;
            GrantedFlags = grantedFlags;
        }
        public Convo(string[] strings, Flag[] requiredFlags)
        {
            Dialogue = strings;
            RequiredFlags = requiredFlags[..^1]; //all items but the last one (^1)
            GrantedFlags = new []{requiredFlags[^1]}; //just the last one
        }
    }
    
    [Serializable]
    public struct ConvoMetadata
    {
        public Name npcName;
        public int dialogueIndex;

        public ConvoMetadata(Name npcName, int dialogueIndex)
        {
            this.npcName = npcName;
            this.dialogueIndex = dialogueIndex;
        }
        
    }
    // ReSharper disable InconsistentNaming
    public enum Flag
    {
        defaultFlag, //flag put on all dialogue
        monologueFlag1,
        monologueFlag2,
        weirdNoise,
        benTalk,
        edScare,
        janHelp,
        janCard,
    };

    public enum Name
    {
        InnerMonologue,
        Timothy,
        Ed,
        Janet,
    };

    private static readonly SortedDictionary<Name, Convo[]> AllDialogues = new ()
    {
        {Name.InnerMonologue, new Convo[] {
            new (
                new []{ "test dialogue", "test", "test2"},
                new []{ Flag.monologueFlag1}),
            new (
                new []{  "yo baby. I have 7 cds", "And three jam boxes"},
                new []{ Flag.monologueFlag2}),
        }},
        {Name.Timothy, new Convo[] { 
            new (
                new []{ "Ed...", "what was that noise?"},
                new []{ Flag.defaultFlag }),
            new (
                new []{  "I always hear weird noises coming from these woods,", "but Ed takes me here to get over my fears.", "I’m not exactly a fan of the dark either.","Ghosts though?","I'm chill with them", "I wouldn't be surprised if benny had something to do with it.","He's always causing trouble." },
                new []{ Flag.defaultFlag, Flag.weirdNoise}),
            new (
                new []{  "Oh, Benny's in the clear?", "That's a releif,", "but I hope he's done pulling pranks on the rest of the camp,","they always keep me on edge."},
                new []{ Flag.defaultFlag, Flag.weirdNoise /*, Flag. whatever benny's line is*/, Flag.benTalk}),
        }},
        {Name.Ed, new Convo[] {
            new (
                new []{ "Come on, Tim, it's just a forest.","Chill out."},
                new []{ Flag.defaultFlag }),
            new (
                new []{  "AHHHHHHHHHHHHHHHHHHHHHHHHH!!!!!??!!!?", "I mean....","whatever......","At least you don't have to feel anything anymore.", "So...you're trying to find out who killed you?","I feel like it's whoever you'd least expect, people surprise you like that."},
                new []{ Flag.defaultFlag, Flag.edScare}),
        }},
        {Name.Janet, new Convo[] {
            new (
                new []{ "Hope the tarot card helps you out!"},
                new []{ Flag.defaultFlag }),
            new (
                new []{  "Oh my gosh! Are you ok?","Why are you a ghost?"},
                new []{ Flag.defaultFlag, Flag.janHelp}),
            new (
                new []{  "Hey!","I didn't have anything to do with that!","I was getting a tarot reading... though I did hear some commotion when we flipped the firt card, but I really wanted to find out why I got the three of swords.","The last card seemed really important though..."},
                new []{ Flag.defaultFlag, Flag.janHelp, Flag.janCard}),
        }},

    };

    
    /*
     * This system has three parts:
     * 1. AllDialogues have their Flags stripped out, with the text of the dialogues stored in _flattenedDialogues
     * 2. learnedDialogueStrings is a list of Strings in the order they were learned. This makes it easy to access
     * 3. _learnedDialogueMetadata has the data necessary to quickly save the dialogue in a space efficient manner
     * The existence of _singleton is not necessary, this could be done with static functions and objects,
     * and a boolean that indicated if the class is set up. However, I am comfortable with the Singleton pattern
     */
    
    private static SortedDictionary<Name, String[]> _flattenedDialogues;
    private static DialogueInventory _singleton;
    private Player _player;
    // LearnedDialogues holds all the necessary strings in one list of easy access,
    // and holds all the metadata in another list 
    public List<String> learnedDialogueStrings;
    private List<ConvoMetadata> _learnedDialogueMetadata;
   
    
    private static void SetupSingleton(Player inPlayer = null)
    {
        // setup flattened dialogue
        _flattenedDialogues.Clear();
        foreach (var npc in AllDialogues)
        {
            foreach (var convo in npc.Value)
            {
                _flattenedDialogues.Add(npc.Key, convo.Dialogue);
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
    
    public static bool GetDialogues(Name inName, out Convo[] npcConvos)
    {
        return AllDialogues.TryGetValue(inName, out npcConvos);
    }
    
    // the metadata lets us turn the strings easily into saved references
    public static void MarkDialogueDisplayed(Name inName, int index)
    {
        SetupSingleton();
        _singleton.learnedDialogueStrings.Add(_flattenedDialogues[inName][index]);
        _singleton._learnedDialogueMetadata.Add(new ConvoMetadata(inName, index));
    }

    //called in SavePlayer, before saving player data. Stores the data in the player's knownDialoguesSaveLocation var
    public static void SaveData() 
    {
        SetupSingleton();
        _singleton._player.GetComponent<Player>().SaveLearnedDialogues(_singleton._learnedDialogueMetadata);
    }
    
    // turns loaded tuple array into string array
    // stores loaded tuple array as metadata
    public static void LoadData(Player player, in List<ConvoMetadata> data)
    {
        SetupSingleton(player);
        _singleton.learnedDialogueStrings.Clear();
        _singleton._learnedDialogueMetadata.Clear();
        foreach (ConvoMetadata metadata in data)
        {
            _singleton._learnedDialogueMetadata.Add(metadata);
            _singleton.learnedDialogueStrings.Add(_flattenedDialogues[metadata.npcName][metadata.dialogueIndex]);
        }
    }
}