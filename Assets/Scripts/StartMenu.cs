using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class StartMenu : MonoBehaviour
{
    SaveData data;
    [SerializeField] Image loadButton;

    void Start()
    {
        data = SaveSystem.LoadPlayer();

        if(data == null)
        {
            loadButton.color = new Color(32, 65, 29, 0.5f);
        }
    }

    public void newGame()
    {
        SaveSystem.NewPlayer();
        
        SceneManager.LoadScene(sceneName: "CharacterCreation");
    }

    public void loadGame()
    {
        if(data != null)
        {
            SceneManager.LoadScene(sceneName: "Sandbox");
        }
    }

    public void quit()
    {
        Application.Quit();
    }

    public void deleteSave()
    {
        if (data != null)
        {
            string path = Application.persistentDataPath + "/player.data";
            File.Delete(path);
            data = null;
            loadButton.color = new Color(32, 65, 29, 0.5f);
        }
    }

    public void loadCredits()
    {
        SceneManager.LoadScene(sceneName: "Credits");
    }
}
