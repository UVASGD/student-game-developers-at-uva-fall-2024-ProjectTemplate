using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;



public static class DialogueInventory
{
    public enum flags
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

    public static SortedDictionary<name, Tuple<String[], flags[]>[]> dialogues = new SortedDictionary<name, Tuple<String[], flags[]>[]>()
    {
        {name.InnerMonologue, new Tuple<String[], flags[]>[] {
            new (
                new []{ "test dialogue", "test", "test2"},
                new []{ flags.monologueFlag1}),
            new (
                new []{  "yo baby. I have 7 cds", "And three jam boxes"},
                new []{ flags.monologueFlag2}),
        }},
        {name.NPC1, new Tuple<String[], flags[]>[] { 
            new (
                new []{ "Hey!!", "You should go talk to John"},
                new []{ flags.defaultFlag }),
            new (
                new []{  "Some weird things are going on here...", "I heard john might know something", "May do you well to go talk with him"},
                new []{ flags.defaultFlag, flags.testFlag1}),
            new (
                new []{  "ME????", "I don't know ANYTHING"},
                new []{ flags.defaultFlag, flags.testFlag1, flags.testFlag2, flags.testFlag3}),
        }},
        {name.NPC2, new Tuple<String[], flags[]>[] {
            new (
                new []{ "Go away bud"},
                new []{ flags.defaultFlag }),
            new (
                new []{  "Whoever said I know something must hiding something", "They're the real culprit"},
                new []{ flags.defaultFlag, flags.testFlag1, flags.testFlag2}),
            new (
                new []{  "Whoah, cool Icon.SVG dude"},
                new []{ flags.defaultFlag, flags.testItemFlag, flags.testFlag4}),
        }},
    };
}