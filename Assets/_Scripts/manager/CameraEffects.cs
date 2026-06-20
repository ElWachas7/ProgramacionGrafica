using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CameraEffects : MonoBehaviour
{
    public Material viewfinderMaterial;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (viewfinderMaterial != null)
            Graphics.Blit(src, dest, viewfinderMaterial);
        else
            Graphics.Blit(src, dest);
    }
}
