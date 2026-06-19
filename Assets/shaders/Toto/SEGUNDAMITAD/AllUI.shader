// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AllUI"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_ColorFlow("ColorFlow", Color) = (0.8113208,0.1576717,0.1576717,0)
		_ColorRotation("ColorRotation", Color) = (0.8566037,0.03717327,0.03717327,0)
		_PositionScale("PositionScale", Vector) = (0,0,0,0)
		_Ramp("Ramp", 2D) = "white" {}
		_DistAmount("DistAmount", Range( 0 , 1)) = 0.5258461
		_FlowMask("FlowMask", 2D) = "white" {}
		_DistNormal("DistNormal", 2D) = "white" {}
		_RotateTexture("RotateTexture", 2D) = "white" {}
		_MainTexture("MainTexture", 2D) = "white" {}
		_MaskTexture("MaskTexture", 2D) = "white" {}

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityStandardUtils.cginc"
			#include "UnityShaderVariables.cginc"

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform sampler2D _MainTexture;
			uniform sampler2D _DistNormal;
			uniform float4 _MainTexture_ST;
			uniform float _DistAmount;
			uniform sampler2D _MaskTexture;
			uniform sampler2D _RotateTexture;
			uniform float4 _PositionScale;
			uniform float4 _ColorRotation;
			uniform sampler2D _Ramp;
			uniform sampler2D _FlowMask;
			uniform float4 _FlowMask_ST;
			uniform float4 _ColorFlow;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_MainTexture = IN.texcoord.xy * _MainTexture_ST.xy + _MainTexture_ST.zw;
				float2 MainUvs222_g7 = uv_MainTexture;
				float4 tex2DNode65_g7 = tex2D( _DistNormal, MainUvs222_g7 );
				float4 appendResult82_g7 = (float4(0.0 , tex2DNode65_g7.g , 0.0 , tex2DNode65_g7.r));
				float2 temp_output_84_0_g7 = (UnpackScaleNormal( appendResult82_g7, _DistAmount )).xy;
				float2 panner179_g7 = ( 1.0 * _Time.y * float2( 0,0 ) + MainUvs222_g7);
				float2 temp_output_71_0_g7 = ( ( temp_output_84_0_g7 * tex2D( _MaskTexture, MainUvs222_g7 ).g ) + panner179_g7 );
				float4 tex2DNode96_g7 = tex2D( _MainTexture, temp_output_71_0_g7 );
				float4 temp_output_8_0 = tex2DNode96_g7;
				float4 temp_output_57_0_g5 = _PositionScale;
				float2 temp_output_2_0_g5 = (temp_output_57_0_g5).zw;
				float2 temp_cast_0 = (1.0).xx;
				float2 temp_output_13_0_g5 = ( ( ( IN.texcoord.xy + (temp_output_57_0_g5).xy ) * temp_output_2_0_g5 ) + -( ( temp_output_2_0_g5 - temp_cast_0 ) * 0.5 ) );
				float TimeVar197_g5 = _Time.y;
				float cos17_g5 = cos( TimeVar197_g5 );
				float sin17_g5 = sin( TimeVar197_g5 );
				float2 rotator17_g5 = mul( temp_output_13_0_g5 - float2( 0.5,0.5 ) , float2x2( cos17_g5 , -sin17_g5 , sin17_g5 , cos17_g5 )) + float2( 0.5,0.5 );
				float4 tex2DNode97_g5 = tex2D( _RotateTexture, rotator17_g5 );
				float temp_output_115_0_g5 = step( ( (temp_output_13_0_g5).y + -0.5 ) , 0.0 );
				float lerpResult125_g5 = lerp( 1.0 , tex2D( _MaskTexture, IN.texcoord.xy ).g , ( 1.0 - temp_output_115_0_g5 ));
				float4 temp_output_192_0_g5 = temp_output_8_0;
				float2 uv_FlowMask = IN.texcoord.xy * _FlowMask_ST.xy + _FlowMask_ST.zw;
				float4 tex2DNode14_g8 = tex2D( _FlowMask, uv_FlowMask );
				float2 appendResult20_g8 = (float2(tex2DNode14_g8.r , tex2DNode14_g8.g));
				float TimeVar197_g8 = _Time.y;
				float2 temp_cast_1 = (TimeVar197_g8).xx;
				float2 temp_output_18_0_g8 = ( appendResult20_g8 - temp_cast_1 );
				float4 tex2DNode72_g8 = tex2D( _Ramp, temp_output_18_0_g8 );
				
				half4 color = ( temp_output_8_0 + ( ( ( tex2DNode97_g5 * lerpResult125_g5 * tex2DNode97_g5.a ) * _ColorRotation ) + temp_output_192_0_g5 ) + ( ( tex2DNode72_g8 * tex2DNode14_g8.a ) * _ColorFlow ) );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;412.8;888.6;362.6;2605.065;828.8444;3.252454;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;21;-2019.631,-450.8622;Inherit;True;Property;_MainTexture;MainTexture;15;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;23;-2006.327,-244.5073;Inherit;True;Property;_MaskTexture;MaskTexture;16;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;25;-1294.42,-758.1385;Inherit;False;739.2126;791.9561;Distortion;5;28;29;5;4;35;Distortion;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-1778.397,-246.799;Inherit;False;MaskTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1779.42,-452.0726;Inherit;False;Maintexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;26;-1588.19,19.75718;Inherit;False;1005.909;886.8459;Rotation;3;14;31;13;Rotation;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-1366.133,977.7161;Inherit;False;701.5472;660;Flow;1;18;Flow;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1059.304,-307.5579;Inherit;False;24;MaskTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1231.568,-570.8489;Inherit;True;Property;_DistNormal;DistNormal;13;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;28;-1221.584,-667.835;Inherit;False;22;Maintexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1275.902,-382.9004;Inherit;False;Property;_DistAmount;DistAmount;11;0;Create;True;0;0;0;False;0;False;0.5258461;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-859.607,-534.4552;Inherit;False;UI-Sprite Effect Layer;0;;7;789bf62641c5cfe4ab7126850acc22b8;18,74,0,204,0,191,0,225,0,242,0,237,0,249,0,186,1,177,1,182,0,229,0,92,0,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.Vector4Node;13;-1087.847,702.4031;Inherit;False;Property;_PositionScale;PositionScale;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;-1437.695,275.9658;Inherit;False;Property;_ColorRotation;ColorRotation;8;0;Create;True;0;0;0;False;0;False;0.8566037,0.03717327,0.03717327,0;0.8566037,0.03717327,0.03717327,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1429.865,456.4953;Inherit;True;Property;_RotateTexture;RotateTexture;14;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;18;-1290.534,1027.716;Inherit;False;Property;_ColorFlow;ColorFlow;7;0;Create;True;0;0;0;False;0;False;0.8113208,0.1576717,0.1576717,0;0.8113208,0.1576717,0.1576717,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1316.133,1214.916;Inherit;True;Property;_Ramp;Ramp;10;0;Create;True;0;0;0;False;0;False;131633c45b26caa4f9673a16077a1970;131633c45b26caa4f9673a16077a1970;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;17;-1300.134,1407.716;Inherit;True;Property;_FlowMask;FlowMask;12;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;31;-1433.334,672.5826;Inherit;False;24;MaskTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.FunctionNode;9;-859.4806,418.0654;Inherit;False;UI-Sprite Effect Layer;0;;5;789bf62641c5cfe4ab7126850acc22b8;18,74,2,204,2,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,0,98,1,234,0,126,0,129,1,130,1,31,1;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.FunctionNode;19;-974.5861,1210.607;Inherit;False;UI-Sprite Effect Layer;0;;8;789bf62641c5cfe4ab7126850acc22b8;18,74,1,204,1,191,1,225,0,242,0,237,0,249,0,186,0,177,0,182,0,229,0,92,1,98,0,234,0,126,0,129,1,130,0,31,0;18;192;COLOR;1,1,1,1;False;39;COLOR;1,1,1,1;False;37;SAMPLER2D;;False;218;FLOAT2;0,0;False;239;FLOAT2;0,0;False;181;FLOAT2;0,0;False;75;SAMPLER2D;;False;80;FLOAT;1;False;183;FLOAT2;0,0;False;188;SAMPLER2D;;False;33;SAMPLER2D;;False;248;FLOAT2;0,0;False;233;SAMPLER2D;;False;101;SAMPLER2D;;False;57;FLOAT4;0,0,0,0;False;40;FLOAT;0;False;231;FLOAT;1;False;30;FLOAT;1;False;2;COLOR;0;FLOAT2;172
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-164.373,319.5259;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1279.628,-56.4653;Inherit;False;24;MaskTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;11;-1262.81,103.6903;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1494.054,100.2626;Inherit;False;22;Maintexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-10.79053,346.9485;Float;False;True;-1;2;ASEMaterialInspector;0;4;AllUI;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;24;0;23;0
WireConnection;22;0;21;0
WireConnection;8;37;28;0
WireConnection;8;75;4;0
WireConnection;8;80;5;0
WireConnection;8;188;35;0
WireConnection;9;192;8;0
WireConnection;9;39;12;0
WireConnection;9;37;14;0
WireConnection;9;101;31;0
WireConnection;9;57;13;0
WireConnection;19;39;18;0
WireConnection;19;37;16;0
WireConnection;19;33;17;0
WireConnection;32;0;8;0
WireConnection;32;1;9;0
WireConnection;32;2;19;0
WireConnection;11;0;30;0
WireConnection;0;0;32;0
ASEEND*/
//CHKSM=D908D1B211FCFCA2776FB13E33DD08E9DA2C6401