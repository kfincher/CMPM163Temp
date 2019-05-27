using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class sliderVolume : MonoBehaviour
{
    Slider slider;
    public AudioSource audioM;
    // Start is called before the first frame update
    void Start()
    {
        slider = GetComponent<Slider>();
        slider.value = audioM.volume;
    }

    // Update is called once per frame
    void Update()
    {
        audioM.volume = slider.value;
    }
}
