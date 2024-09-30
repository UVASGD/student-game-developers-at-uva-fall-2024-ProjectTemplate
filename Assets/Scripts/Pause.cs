using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pause : MonoBehaviour
{

private GameObject pauseMenu;
private bool isPaused = false;



    // Start is called before the first frame update
    void Start()
    {  
        pauseMenu = GameObject.Find("PauseMenu");        
        pauseMenu.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (isPaused)
            {
                ResumeGame();

            } else {

                PauseGame();
            }

        }
        
    }

    public void PauseGame(){
        
        Cursor.lockState = CursorLockMode.None;
        Cursor.visible = true;

        pauseMenu.SetActive(true);

        Time.timeScale = 0f;
        isPaused = true;



    }

    public void ResumeGame(){

        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;

        pauseMenu.SetActive(false);
        
        Time.timeScale = 1f;
        isPaused = false;


        
    }

    public void QuitApp(){
        Application.Quit();
    }
}
