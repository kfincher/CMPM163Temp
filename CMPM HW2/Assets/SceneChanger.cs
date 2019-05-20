using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class SceneChanger : MonoBehaviour
{
    public Button PartA;
    public Button PartB;
    // Start is called before the first frame update
    void Start()
    {
        if(PartA!=null)
            PartA.onClick.AddListener(PartAStart);
        if (PartB != null)
            PartB.onClick.AddListener(PartBStart);
    }
    // Update is called once per frame
    void PartAStart()
    {
        SceneManager.LoadScene("SampleScene");
    }
    void PartBStart()
    {
        SceneManager.LoadScene("PartB");
    }
}
