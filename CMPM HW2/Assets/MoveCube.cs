using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveCube : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKey(KeyCode.UpArrow)) {
            Vector3 temp = transform.position;
            temp.z += 0.01f;
            transform.position = temp;
        }
        if (Input.GetKey(KeyCode.DownArrow)) {
            Vector3 temp = transform.position;
            temp.z -= 0.01f;
            transform.position = temp;
        }
    }
}
