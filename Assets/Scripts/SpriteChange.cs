using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.SceneManagement;
//using UnityEngine.UIElements;
using UnityEngine.UI;

public class SpriteChange : MonoBehaviour
{

    [SerializeField] private Image body;
    [SerializeField] private Image hair;
    [SerializeField] private Image hairColor;
    [SerializeField] private Image eye;
    [SerializeField] private Image eyeColor;

    [SerializeField] private Sprite[] bodies;
    [SerializeField] private Sprite[] hairs;
    [SerializeField] private Sprite[] hairColorsRaw;
    [SerializeField] private Sprite[] eyes;
    [SerializeField] private Sprite[] eyeColorsRaw;

    private Sprite[][] eyeColors;
    private Sprite[][] hairColors;

    private int bodyIndex = 0;
    private int hairIndex = 0;
    private int hairCIndex = 0;
    private int eyeIndex = 0;
    private int eyeCIndex = 0;

    private void Start()
    {
        int eyeLen = eyeColorsRaw.Length / eyes.Length;
        int index = 0;
        eyeColors = new Sprite[eyes.Length][];
        for(int i=0; i<eyes.Length; i++)
        {
            eyeColors[i] = new Sprite[eyeLen];
            for (int j = 0; j < eyeLen; j++)
            {
                eyeColors[i][j] = eyeColorsRaw[index];
                index++;
            }
        }

        int hairLen = hairColorsRaw.Length / hairs.Length;
        index = 0;
        hairColors = new Sprite[hairs.Length][];
        for (int i = 0; i < hairs.Length; i++)
        {
            hairColors[i] = new Sprite[hairLen];
            for (int j = 0; j < hairLen; j++)
            {
                hairColors[i][j] = hairColorsRaw[index];
                index++;
            }
        }
    }

    public void exit()
    {
        PlayerPrefs.SetInt("bodyIndex", bodyIndex);
        PlayerPrefs.SetInt("hairIndex", hairIndex);
        PlayerPrefs.SetInt("hairCIndex", hairCIndex);
        PlayerPrefs.SetInt("eyeIndex", eyeIndex);
        PlayerPrefs.SetInt("eyeCIndex", eyeCIndex);
        SceneManager.LoadScene(sceneName: "Sandbox");
    }

    public void bodyUp()
    {
        bodyIndex++;
        if(bodyIndex >= bodies.Length)
        {
            bodyIndex = 0;
        }
        body.sprite = bodies[bodyIndex];
    }
    public void bodyDown()
    {
        bodyIndex--;
        if (bodyIndex < 0)
        {
            bodyIndex = bodies.Length-1;
        }
        body.sprite = bodies[bodyIndex];
    }

    public void hairUp()
    {
        hairIndex++;
        if (hairIndex >= hairs.Length)
        {
            hairIndex = 0;
        }
        hair.sprite = hairs[hairIndex];
        hairColor.sprite = hairColors[hairIndex][hairCIndex];
    }
    public void hairDown()
    {
        hairIndex--;
        if (hairIndex < 0)
        {
            hairIndex = hairs.Length - 1;
        }
        hair.sprite = hairs[hairIndex];
        hairColor.sprite = hairColors[hairIndex][hairCIndex];
    }

    public void hairCUp()
    {
        hairCIndex++;
        if (hairCIndex >= hairColors[hairIndex].Length)
        {
            hairCIndex = 0;
        }
        hairColor.sprite = hairColors[hairIndex][hairCIndex];
    }
    public void hairCDown()
    {
        hairCIndex--;
        if (hairCIndex < 0)
        {
            hairCIndex = hairColors[hairIndex].Length - 1;
        }
        hairColor.sprite = hairColors[hairIndex][hairCIndex];
    }

    public void eyeUp()
    {
        eyeIndex++;
        if (eyeIndex >= eyes.Length)
        {
            eyeIndex = 0;
        }
        eye.sprite = eyes[eyeIndex];
        eyeColor.sprite = eyeColors[eyeIndex][eyeCIndex];
    }
    public void eyeDown()
    {
        eyeIndex--;
        if (eyeIndex < 0)
        {
            eyeIndex = eyes.Length - 1;
        }
        eye.sprite = eyes[eyeIndex];
        eyeColor.sprite = eyeColors[eyeIndex][eyeCIndex];
    }
    public void eyeCUp()
    {
        eyeCIndex++;
        if (eyeCIndex >= eyeColors[eyeIndex].Length)
        {
            eyeCIndex = 0;
        }
        eyeColor.sprite = eyeColors[eyeIndex][eyeCIndex];
    }
    public void eyeCDown()
    {
        eyeCIndex--;
        if (eyeCIndex < 0)
        {
            eyeCIndex = eyeColors[eyeIndex].Length - 1;
        }
        eyeColor.sprite = eyeColors[eyeIndex][eyeCIndex];
    }
}
