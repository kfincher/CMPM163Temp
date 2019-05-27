using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class meatballScript : MonoBehaviour
{
    AudioSource aud;
    bool played = false;
    float buffer = 2.2f;
    // Start is called before the first frame update
    void Start()
    {
        aud = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Time.time > buffer && played == false) {
            played = true;
            aud.Play();
        } 
    }
}
