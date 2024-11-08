using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
//using UnityEngine.UIElements;
using UnityEngine.UI;

public class SpriteChange : MonoBehaviour
{

    [SerializeField] private Image body;
    [SerializeField] private Image hair;
    [SerializeField] private Image eyes;
    [SerializeField] private Image mouth;
    [SerializeField] private Image top;
    [SerializeField] private Image bottom;

    [SerializeField] private Sprite[] bodies;
    [SerializeField] private Sprite[] hairs;
    [SerializeField] private Sprite[] eyePairs;
    [SerializeField] private Sprite[] mouths;
    [SerializeField] private Sprite[] tops;
    [SerializeField] private Sprite[] bottoms;

    private int bodyIndex = 0;
    private int hairIndex = 0;
    private int eyeIndex = 0;
    private int mouthIndex = 0;
    private int topIndex = 0;
    private int bottomIndex = 0;

    /*private void Start()
    {

    }*/

    public void exit()
    {
        PlayerPrefs.SetInt("bodyIndex", bodyIndex);
        PlayerPrefs.SetInt("hairIndex", hairIndex);
        PlayerPrefs.SetInt("eyeIndex", eyeIndex);
        PlayerPrefs.SetInt("mouthIndex", mouthIndex);
        PlayerPrefs.SetInt("topIndex", topIndex);
        PlayerPrefs.SetInt("bottomIndex", bottomIndex);
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
    }
    public void hairDown()
    {
        hairIndex--;
        if (hairIndex < 0)
        {
            hairIndex = hairs.Length - 1;
        }
        hair.sprite = hairs[hairIndex];
    }

    public void eyesUp()
    {
        eyeIndex++;
        if (eyeIndex >= eyePairs.Length)
        {
            eyeIndex = 0;
        }
        eyes.sprite = eyePairs[eyeIndex];
    }
    public void eyesDown()
    {
        eyeIndex--;
        if (eyeIndex < 0)
        {
            eyeIndex = eyePairs.Length - 1;
        }
        eyes.sprite = eyePairs[eyeIndex];
    }

    public void mouthUp()
    {
        mouthIndex++;
        if (mouthIndex >= mouths.Length)
        {
            mouthIndex = 0;
        }
        mouth.sprite = mouths[mouthIndex];
    }
    public void mouthDown()
    {
        mouthIndex--;
        if (mouthIndex < 0)
        {
            mouthIndex = mouths.Length - 1;
        }
        mouth.sprite = mouths[mouthIndex];
    }

    public void topUp()
    {
        topIndex++;
        if (topIndex >= tops.Length)
        {
            topIndex = 0;
        }
        top.sprite = tops[topIndex];
    }
    public void topDown()
    {
        topIndex--;
        if (topIndex < 0)
        {
            topIndex = tops.Length - 1;
        }
        top.sprite = tops[topIndex];
    }

    public void bottomUp()
    {
        bottomIndex++;
        if (bottomIndex >= bottoms.Length)
        {
            bottomIndex = 0;
        }
        bottom.sprite = bottoms[bottomIndex];
    }
    public void bottomDown()
    {
        bottomIndex--;
        if (bottomIndex < 0)
        {
            bottomIndex = bottoms.Length - 1;
        }
        bottom.sprite = bottoms[bottomIndex];
    }
}
