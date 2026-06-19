using UnityEngine;

public class PixelCam : MonoBehaviour
{
    [Header("Textures")]
    [SerializeField] Texture text1;

    [SerializeField] private Shader shader;
    private Material material;


    public void Awake()
    {
        material = new Material(shader);
        material.SetTexture("_bayerpng", text1);
    }
    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
            Graphics.Blit(source, destination, material);
    }
}
