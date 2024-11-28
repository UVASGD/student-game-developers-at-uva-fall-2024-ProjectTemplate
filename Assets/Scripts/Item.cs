using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Item : MonoBehaviour
{

    private GameObject player;
    private Player playerScript;

    private InventoryItem item = new InventoryItem();

    [SerializeField] private InventoryItem.ItemType type = InventoryItem.ItemType.None;
    [SerializeField] private DialogueInventory.Flag flag;
    [SerializeField] private GameObject self;
    private InnerMonologue imScript;

    // Start is called before the first frame update
    void Start()
    {
        imScript = InnerMonologue.GetImScript();
        player = GameObject.Find("Player");
        playerScript = player.GetComponent<Player>();

        if (playerScript.dialogueFlags.Contains(flag))
        {
            Destroy(self);
        }

        item.itemType = type;
    }

    // Update is called once per frame
    void Update()
    {
        double dist = Mathf.Sqrt(Mathf.Pow(player.transform.position.x - transform.position.x, 2) + Mathf.Pow(player.transform.position.z - transform.position.z, 2));
        double height = Mathf.Abs(player.transform.position.y - transform.position.y);
        if (dist <= 25 && height <= 20 && Input.GetButtonDown("E"))
        {
            playerScript.dialogueFlags.Add(flag);
            playerScript.AddToInventory(item);
            imScript.monologueCheck(flag);
            Destroy(self);
        }
    }
}
