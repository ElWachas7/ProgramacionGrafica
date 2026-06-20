using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DistanceShader : MonoBehaviour
{
    [SerializeField] Material mat;
    [SerializeField] Transform reference;

    private void Update()
    {
        mat.SetVector("_Reference", new Vector4(reference.position.x, reference.position.y, reference.position.z,0f));
    }
}
