
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.None)]
public class BinaryToVRSLManager : UdonSharpBehaviour
{
    [Header("Assign your video player texture here.")]
    public RenderTexture VideoTexture;
    [Tooltip("The resolution of the video you are using. This is the EXPECTED resolution, so if you are streaming a canvas in OBS of 1920x1080, and have a 720p fallback stream, this should still be 1920x1080.")]
    public Vector2Int BaseVideoResolution = new Vector2Int(1920, 1080);
    [Header("Don't Touch Below.")]
    public RenderTexture MDMXRT;
    public Material MDMXMat;
    public RenderTexture VerticalBladeRecreation;
    public RenderTexture VRSLRT;

    public float thresholdTolerance = 0.2f;

    const string dmxRawKeyword = "_Udon_MDMXRaw";

    void Start()
    {
        var id = VRCShader.PropertyToID(dmxRawKeyword);
        VRCShader.SetGlobalTexture(id, MDMXRT);

        //set the texture in the MDMX Material
        MDMXMat.SetTexture("_MainTex", VideoTexture);
        MDMXMat.SetFloat("_ThresholdTolerance", thresholdTolerance);
        MDMXMat.SetFloat("_Width", BaseVideoResolution.x);
        MDMXMat.SetFloat("_Height", BaseVideoResolution.y);

        if (VideoTexture == null)
        {
            Debug.LogError("VideoTexture is not assigned.");
        }
    }

    void Update()
    {
        VRCGraphics.Blit(VerticalBladeRecreation, VRSLRT);
    }
}
