using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleScript : MonoBehaviour {

    ParticleSystem ps;
    public ParticleSystem psOne;
    public ParticleSystem psTwo;
    public ParticleSystem psThree;

    void Start () 
    {
        // Get Particle system component
        ps = GetComponent<ParticleSystem>();
        // Call particle play function
        ps.Play();
	}

	void Update () {

        int numPartitions = 8;
        float[] aveMag = new float[numPartitions];
        float partitionIndx = 0;
        int numDisplayedBins = 512 / 2; //NOTE: we only display half the spectral data because the max displayable frequency is Nyquist (at half the num of bins)

        for (int i = 0; i < numDisplayedBins; i++) {
            if (i < numDisplayedBins * (partitionIndx + 1) / numPartitions) {
                aveMag[(int)partitionIndx] += AudioPeer.spectrumData[i] / (512 / numPartitions);
            } else {
                partitionIndx++;
                i--;
            }
        }

        // scale and bound the average magnitude.
        for (int i = 0; i < numPartitions; i++) {
            aveMag[i] = (float)0.5 + aveMag[i] * 100;
            if (aveMag[i] > 100) {
                aveMag[i] = 100;
            }
        }

        float mag = aveMag[0];
        
        // if mag is greater than some threshold(0.6)
        // emit particle using emit function
        if (mag > 0.85 ) {
            ps.Emit(1);
        }
        if (aveMag[1] > 0.68 ) {
            psOne.Emit(1);
        }
        if (aveMag[2] > 0.6 ) {
            psTwo.Emit(1);
        }
        if (aveMag[3] > 0.55 ) {
            psThree.Emit(1);
        }

	}


}

