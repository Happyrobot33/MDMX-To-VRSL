// Made with Amplify Shader Editor v1.9.9.9
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MDMXToVRSL"
{
    Properties
    {
		_MDMXBuffer( "MDMX Buffer", 2D ) = "white" {}

    }

	SubShader
	{
		LOD 0

		

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZClip True
		ZTest LEqual
		Offset 0 , 0
		

		
        Pass
        {
			Name "Custom RT Update"
            CGPROGRAM
            #define ASE_VERSION 19909

            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex ASECustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.5

			#define ASE_NEEDS_TEXTURE_COORDINATES0
			#define ASE_NEEDS_FRAG_TEXTURE_COORDINATES0


			struct ase_appdata_customrendertexture
			{
				uint vertexID : SV_VertexID;
				
			};

			struct ase_v2f_customrendertexture
			{
				float4 vertex           : SV_POSITION;
				float3 localTexcoord    : TEXCOORD0;    // Texcoord local to the update zone (== globalTexcoord if no partial update zone is specified)
				float3 globalTexcoord   : TEXCOORD1;    // Texcoord relative to the complete custom texture
				uint primitiveID        : TEXCOORD2;    // Index of the update zone (correspond to the index in the updateZones of the Custom Texture)
				float3 position         : TEXCOORD3;    // For cube textures, position of the pixel being rendered in the cubemap
				
			};

			uniform sampler2D _MDMXBuffer;
			float SampleChannel1( int channel, sampler2D _Udon_MDMX )
			{
				#define __DMXWIDTH 128
				#define __DMXHEIGHT 128
				    channel--;
				    float2 t = float2(floor(channel % __DMXWIDTH),floor(channel / __DMXWIDTH));
				    float2 offsets = float2(1./__DMXWIDTH,1./__DMXHEIGHT);
				    t *= offsets;
				    t += offsets/2.; //center pixel sample
				//return float3(t,0);
				    return tex2Dlod(_Udon_MDMX,float4(t,0,0)).r;
			}
			
			float SampleChannel14( int channel, sampler2D _Udon_MDMX )
			{
				#define __DMXWIDTH 128
				#define __DMXHEIGHT 128
				    channel--;
				    float2 t = float2(floor(channel % __DMXWIDTH),floor(channel / __DMXWIDTH));
				    float2 offsets = float2(1./__DMXWIDTH,1./__DMXHEIGHT);
				    t *= offsets;
				    t += offsets/2.; //center pixel sample
				//return float3(t,0);
				    return tex2Dlod(_Udon_MDMX,float4(t,0,0)).r;
			}
			
			float SampleChannel15( int channel, sampler2D _Udon_MDMX )
			{
				#define __DMXWIDTH 128
				#define __DMXHEIGHT 128
				    channel--;
				    float2 t = float2(floor(channel % __DMXWIDTH),floor(channel / __DMXWIDTH));
				    float2 offsets = float2(1./__DMXWIDTH,1./__DMXHEIGHT);
				    t *= offsets;
				    t += offsets/2.; //center pixel sample
				//return float3(t,0);
				    return tex2Dlod(_Udon_MDMX,float4(t,0,0)).r;
			}
			


			float3 CustomRenderTextureComputeCubePosition( float2 globalTexcoord )
			{
				float2 xy = globalTexcoord * 2.0 - 1.0;
				float3 position;
				if ( _CustomRenderTextureCubeFace == 0.0 )
				{
					position = float3( 1.0, -xy.y, -xy.x );
				}
				else if ( _CustomRenderTextureCubeFace == 1.0 )
				{
					position = float3( -1.0, -xy.y, xy.x );
				}
				else if ( _CustomRenderTextureCubeFace == 2.0 )
				{
					position = float3( xy.x, 1.0, xy.y );
				}
				else if ( _CustomRenderTextureCubeFace == 3.0 )
				{
					position = float3( xy.x, -1.0, -xy.y );
				}
				else if ( _CustomRenderTextureCubeFace == 4.0 )
				{
					position = float3( xy.x, -xy.y, 1.0 );
				}
				else if ( _CustomRenderTextureCubeFace == 5.0 )
				{
					position = float3( -xy.x, -xy.y, -1.0 );
				}
				return position;
			}

			ase_v2f_customrendertexture ASECustomRenderTextureVertexShader( ase_appdata_customrendertexture IN  )
			{
				ase_v2f_customrendertexture OUT;

				

			#if UNITY_UV_STARTS_AT_TOP
				const float2 vertexPositions[6] =
				{
					{ -1.0f,  1.0f },
					{ -1.0f, -1.0f },
					{  1.0f, -1.0f },
					{  1.0f,  1.0f },
					{ -1.0f,  1.0f },
					{  1.0f, -1.0f }
				};

				const float2 texCoords[6] =
				{
					{ 0.0f, 0.0f },
					{ 0.0f, 1.0f },
					{ 1.0f, 1.0f },
					{ 1.0f, 0.0f },
					{ 0.0f, 0.0f },
					{ 1.0f, 1.0f }
				};
			#else
				const float2 vertexPositions[6] =
				{
					{  1.0f,  1.0f },
					{ -1.0f, -1.0f },
					{ -1.0f,  1.0f },
					{ -1.0f, -1.0f },
					{  1.0f,  1.0f },
					{  1.0f, -1.0f }
				};

				const float2 texCoords[6] =
				{
					{ 1.0f, 1.0f },
					{ 0.0f, 0.0f },
					{ 0.0f, 1.0f },
					{ 0.0f, 0.0f },
					{ 1.0f, 1.0f },
					{ 1.0f, 0.0f }
				};
			#endif

				uint primitiveID = IN.vertexID / 6;
				uint vertexID = IN.vertexID % 6;
				float3 updateZoneCenter = CustomRenderTextureCenters[primitiveID].xyz;
				float3 updateZoneSize = CustomRenderTextureSizesAndRotations[primitiveID].xyz;
				float rotation = CustomRenderTextureSizesAndRotations[primitiveID].w * UNITY_PI / 180.0f;

			#if !UNITY_UV_STARTS_AT_TOP
				rotation = -rotation;
			#endif

				// Normalize rect if needed
				if (CustomRenderTextureUpdateSpace > 0.0) // Pixel space
				{
					// Normalize xy because we need it in clip space.
					updateZoneCenter.xy /= _CustomRenderTextureInfo.xy;
					updateZoneSize.xy /= _CustomRenderTextureInfo.xy;
				}
				else // normalized space
				{
					// Un-normalize depth because we need actual slice index for culling
					updateZoneCenter.z *= _CustomRenderTextureInfo.z;
					updateZoneSize.z *= _CustomRenderTextureInfo.z;
				}

				// Compute rotation

				// Compute quad vertex position
				float2 clipSpaceCenter = updateZoneCenter.xy * 2.0 - 1.0;
				float2 pos = vertexPositions[vertexID] * updateZoneSize.xy;
				pos = CustomRenderTextureRotate2D(pos, rotation);
				pos.x += clipSpaceCenter.x;
			#if UNITY_UV_STARTS_AT_TOP
				pos.y += clipSpaceCenter.y;
			#else
				pos.y -= clipSpaceCenter.y;
			#endif

				// For 3D texture, cull quads outside of the update zone
				// This is neeeded in additional to the preliminary minSlice/maxSlice done on the CPU because update zones can be disjointed.
				// ie: slices [1..5] and [10..15] for two differents zones so we need to cull out slices 0 and [6..9]
				if (CustomRenderTextureIs3D > 0.0)
				{
					int minSlice = (int)(updateZoneCenter.z - updateZoneSize.z * 0.5);
					int maxSlice = minSlice + (int)updateZoneSize.z;
					if (_CustomRenderTexture3DSlice < minSlice || _CustomRenderTexture3DSlice >= maxSlice)
					{
						pos.xy = float2(1000.0, 1000.0); // Vertex outside of ncs
					}
				}

				OUT.vertex = float4(pos, UNITY_NEAR_CLIP_VALUE, 1.0);
				OUT.primitiveID = asuint(CustomRenderTexturePrimitiveIDs[primitiveID]);
				OUT.localTexcoord = float3(texCoords[vertexID], CustomRenderTexture3DTexcoordW);
				OUT.globalTexcoord = float3(pos.xy * 0.5 + 0.5, CustomRenderTexture3DTexcoordW);
			#if UNITY_UV_STARTS_AT_TOP
				OUT.globalTexcoord.y = 1.0 - OUT.globalTexcoord.y;
			#endif
				OUT.position = CustomRenderTextureComputeCubePosition( OUT.globalTexcoord.xy );
				return OUT;
			}

            float4 frag( ase_v2f_customrendertexture IN  ) : COLOR
            {
				half3 PositionWS = IN.position;
				half3 NormalWS = normalize( IN.position );

				float temp_output_31_0 = floor( ( IN.localTexcoord.xy.x * _CustomRenderTextureWidth ) );
				float temp_output_60_0 = floor( ( temp_output_31_0 / 40.0 ) );
				float temp_output_32_0 = ( floor( ( ( _CustomRenderTextureHeight *  (1.0 + ( IN.localTexcoord.xy.y - 0.0 ) * ( 0.0 - 1.0 ) / ( 1.0 - 0.0 ) ) ) + ( ( temp_output_31_0 - ( temp_output_60_0 * 40.0 ) ) * 13.0 ) ) ) + 1.0 );
				float temp_output_63_0 = ( temp_output_32_0 + ( temp_output_60_0 * 512.0 ) );
				int channel1 = (int)temp_output_63_0;
				sampler2D _Udon_MDMX1 = _MDMXBuffer;
				float localSampleChannel1 = SampleChannel1( channel1 , _Udon_MDMX1 );
				float temp_output_16_0 = ( temp_output_63_0 + 1536.0 );
				int channel14 = (int)temp_output_16_0;
				sampler2D _Udon_MDMX14 = _MDMXBuffer;
				float localSampleChannel14 = SampleChannel14( channel14 , _Udon_MDMX14 );
				int channel15 = (int)( temp_output_16_0 + 1536.0 );
				sampler2D _Udon_MDMX15 = _MDMXBuffer;
				float localSampleChannel15 = SampleChannel15( channel15 , _Udon_MDMX15 );
				float4 appendResult13 = (float4(localSampleChannel1 , localSampleChannel14 , localSampleChannel15 , 0.0));
				

                float4 finalColor = appendResult13;

				return finalColor;
            }
            ENDCG
		}
    }
	
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
	Fallback Off
}
/*ASEBEGIN
Version=19909
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;43;-2672,-640;Inherit;False;Global;_CustomRenderTextureWidth;_CustomRenderTextureWidth;1;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;59;-1328,64;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;40;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;27;-1776,-48;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;13;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;60;-1184,64;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;62;-1008,64;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;40;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;42;-2256,-192;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;31;-1584,-16;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;44;-2672,-560;Inherit;False;Global;_CustomRenderTextureHeight;_CustomRenderTextureHeight;1;0;Fetch;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;11;-1744,-400;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;61;-1024,-96;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;24;-1472,-512;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;13;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;28;-784,-256;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;13;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;10;-512,-560;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-240,-560;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;32;16,-560;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;64;-1009.177,236.9076;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;512;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;2;-528,32;Inherit;True;Property;_MDMXBuffer;MDMX Buffer;0;0;Create;True;0;0;0;False;0;False;None;6da2c92c818c4cd4eb578cc7aa0291fc;False;white;Auto;Texture2D;False;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;63;516.1855,-244.4207;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;18;1072,-32;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1536;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;16;1104,-176;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1536;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;1488,0;Inherit;False;#define __DMXWIDTH 128$#define __DMXHEIGHT 128$$    channel--@$    float2 t = float2(floor(channel % __DMXWIDTH),floor(channel / __DMXWIDTH))@$    float2 offsets = float2(1./__DMXWIDTH,1./__DMXHEIGHT)@$$    t *= offsets@$    t += offsets/2.@ //center pixel sample$//return float3(t,0)@$$    return tex2Dlod(_Udon_MDMX,float4(t,0,0)).r@;1;Create;2;True;channel;INT;0;In;;Inherit;False;True;_Udon_MDMX;SAMPLER2D;_Sampler11;In;;Inherit;False;Sample Channel;True;False;0;;False;2;0;INT;0;False;1;SAMPLER2D;_Sampler11;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;15;1488,128;Inherit;False;#define __DMXWIDTH 128$#define __DMXHEIGHT 128$$    channel--@$    float2 t = float2(floor(channel % __DMXWIDTH),floor(channel / __DMXWIDTH))@$    float2 offsets = float2(1./__DMXWIDTH,1./__DMXHEIGHT)@$$    t *= offsets@$    t += offsets/2.@ //center pixel sample$//return float3(t,0)@$$    return tex2Dlod(_Udon_MDMX,float4(t,0,0)).r@;1;Create;2;True;channel;INT;0;In;;Inherit;False;True;_Udon_MDMX;SAMPLER2D;_Sampler11;In;;Inherit;False;Sample Channel;True;False;0;;False;2;0;INT;0;False;1;SAMPLER2D;_Sampler11;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;1;1488,-128;Inherit;False;#define __DMXWIDTH 128$#define __DMXHEIGHT 128$$    channel--@$    float2 t = float2(floor(channel % __DMXWIDTH),floor(channel / __DMXWIDTH))@$    float2 offsets = float2(1./__DMXWIDTH,1./__DMXHEIGHT)@$$    t *= offsets@$    t += offsets/2.@ //center pixel sample$//return float3(t,0)@$$    return tex2Dlod(_Udon_MDMX,float4(t,0,0)).r@;1;Create;2;True;channel;INT;0;In;;Inherit;False;True;_Udon_MDMX;SAMPLER2D;_Sampler11;In;;Inherit;False;Sample Channel;True;False;0;;False;2;0;INT;0;False;1;SAMPLER2D;_Sampler11;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;13;1872,-64;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;55;1962.419,-347.3826;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleDivideOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;36;-256,-1056;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;512;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;37;-64,-1056;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;40;752,-880;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;39;352,-1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;8;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;66;2416,-272;Float;False;True;-1;3;AmplifyShaderEditor.MaterialInspector;0;11;MDMXToVRSL;32120270d1b3a8746af2aca8bc749736;True;Custom RT Update;0;0;Custom RT Update;1;False;True;0;1;False;;0;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;False;;True;0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;3;False;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;59;0;31;0
WireConnection;27;0;42;1
WireConnection;27;1;43;0
WireConnection;60;0;59;0
WireConnection;62;0;60;0
WireConnection;31;0;27;0
WireConnection;11;0;42;2
WireConnection;61;0;31;0
WireConnection;61;1;62;0
WireConnection;24;0;44;0
WireConnection;24;1;11;0
WireConnection;28;0;61;0
WireConnection;10;0;24;0
WireConnection;10;1;28;0
WireConnection;5;0;10;0
WireConnection;32;0;5;0
WireConnection;64;0;60;0
WireConnection;63;0;32;0
WireConnection;63;1;64;0
WireConnection;18;0;16;0
WireConnection;16;0;63;0
WireConnection;14;0;16;0
WireConnection;14;1;2;0
WireConnection;15;0;18;0
WireConnection;15;1;2;0
WireConnection;1;0;63;0
WireConnection;1;1;2;0
WireConnection;13;0;1;0
WireConnection;13;1;14;0
WireConnection;13;2;15;0
WireConnection;55;0;60;0
WireConnection;55;1;1;0
WireConnection;36;0;32;0
WireConnection;37;0;36;0
WireConnection;40;0;32;0
WireConnection;40;1;39;0
WireConnection;39;0;37;0
WireConnection;66;0;13;0
ASEEND*/
//CHKSM=78CAD2B3948DA229D1111AC86BEF48E69F42998E