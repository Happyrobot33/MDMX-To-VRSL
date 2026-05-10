
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.None)]
public class BinaryToVRSLManager : UdonSharpBehaviour
{
    [Header("Assign your video player texture here.")]
    public RenderTexture VideoTexture;
    [Header("Don't Touch Below.")]
    public RenderTexture MDMXRT;
    public Material MDMXMat;
    public RenderTexture VerticalBladeRecreation;
    public RenderTexture VRSLRT;

    const string dmxRawKeyword = "_Udon_MDMXRaw";

    void Start()
    {
        var id = VRCShader.PropertyToID(dmxRawKeyword);
        VRCShader.SetGlobalTexture(id, MDMXRT);

        //set the texture in the MDMX Material
        MDMXMat.SetTexture("_MainTex", VideoTexture);

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
