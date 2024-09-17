using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class SaveData
{
    public bool hasSave = false;
    
    public float[] playerPosition;
    public int[] flags;

    public SaveData(Player player) 
    { 
        playerPosition = new float[3];
        playerPosition[0] = player.transform.position.x;
        playerPosition[1] = player.transform.position.y;
        playerPosition[2] = player.transform.position.z;

        int len = player.dialogueFlags.Count;
        Player.flags[] flagsEnum = new Player.flags[len];
        player.dialogueFlags.CopyTo(flagsEnum);
        flags = new int[len];
        for(int i=0; i < len; i++)
        {
            flags[i] = (int)flagsEnum[i];
        }
    }

    public SaveData()
    {
        playerPosition = new float[3];
        playerPosition[0] = 0;
        playerPosition[1] = 18;
        playerPosition[2] = 0;
        flags = new int[1];
        flags[0] = 0;
    }
}
