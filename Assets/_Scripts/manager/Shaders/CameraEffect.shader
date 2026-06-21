// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CameraEffect"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Center("_Center", Vector) = (0.5,0.5,0,0)
		_FadeStart("FadeStart", Range( 0 , 1.2)) = 0
		_FadeEnd("FadeEnd", Range( 0.1 , 1)) = 0.1
		_GrainyScale("Grainy Scale", Float) = 300
		_GrainyIntensity("Grainy Intensity", Range( 0 , 1.5)) = 0
		_GrainyContrast("Grainy Contrast", Range( 0 , 1)) = 0.5
		_FishEyeZoom("FishEyeZoom", Range( 0.3 , 3)) = 0.5
		_FishEyePower("FishEyePower", Range( 0 , 2)) = 1
		_Radius("Radius", Range( 0 , 1)) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float2 _Center;
			uniform float _Radius;
			uniform float _FishEyePower;
			uniform float _FishEyeZoom;
			uniform float _FadeStart;
			uniform float _FadeEnd;
			uniform float _GrainyScale;
			uniform float _GrainyContrast;
			uniform float _GrainyIntensity;
			uniform sampler2D _TextureSample1;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float4 color10 = IsGammaSpace() ? float4(0,0,0,1) : float4(0,0,0,1);
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 ScreenCenter72 = ( (ase_screenPosNorm).xy - _Center );
				float2 break30 = ScreenCenter72;
				float2 appendResult32 = (float2(( break30.x * ( _ScreenParams.x / _ScreenParams.y ) ) , break30.y));
				float ScreenLength74 = length( appendResult32 );
				float clampResult87 = clamp( ( ScreenLength74 / _Radius ) , 0.0 , 1.0 );
				float2 FIshEye98 = ( ( ( pow( clampResult87 , _FishEyePower ) * _FishEyeZoom ) * ScreenCenter72 ) + 0.5 );
				float smoothstepResult12 = smoothstep( _FadeStart , _FadeEnd , ScreenLength74);
				float4 lerpResult11 = lerp( color10 , tex2D( _MainTex, FIshEye98 ) , smoothstepResult12);
				float temp_output_52_0 = ( _Time.y * 3.0 );
				float2 texCoord34 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float2 GrainyUV60 = ( texCoord34 * _GrainyScale );
				float2 panner55 = ( temp_output_52_0 * float2( 2,-0.1 ) + GrainyUV60);
				float simplePerlin2D33 = snoise( panner55 );
				simplePerlin2D33 = simplePerlin2D33*0.5 + 0.5;
				float2 panner58 = ( temp_output_52_0 * float2( -0.6,-0.05 ) + GrainyUV60);
				float simplePerlin2D57 = snoise( panner58 );
				simplePerlin2D57 = simplePerlin2D57*0.5 + 0.5;
				float GrainyNoise89 = ( ( (0.0 + (( simplePerlin2D33 * simplePerlin2D57 ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) - _GrainyContrast ) * _GrainyIntensity );
				float4 CameraView104 = ( lerpResult11 + GrainyNoise89 );
				float2 texCoord102 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode101 = tex2D( _TextureSample1, texCoord102 );
				float4 appendResult106 = (float4(tex2DNode101.r , tex2DNode101.g , tex2DNode101.b , 0.0));
				float4 OverlayTexture110 = appendResult106;
				float OverlayAlpha109 = tex2DNode101.a;
				float4 lerpResult103 = lerp( CameraView104 , 0 , OverlayAlpha109);
				

				finalColor = lerpResult103;

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
0;399.2;769.4;376.2;6559.965;2060.394;9.184782;True;False
Node;AmplifyShaderEditor.CommentaryNode;93;-3594.791,-353.6759;Inherit;False;838.1824;296.6495;Screen Center;5;1;2;5;3;72;Screen Center;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1;-3544.791,-303.6759;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;5;-3314.963,-219.2264;Inherit;False;Property;_Center;_Center;0;0;Create;True;0;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;2;-3332.524,-302.5705;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-3117.871,-271.2287;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;94;-2695.1,-354.0337;Inherit;False;1137.615;333.6038;Center Length;8;27;73;30;28;31;32;6;74;Center Length;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-2981.409,-275.65;Inherit;False;ScreenCenter;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenParams;27;-2645.1,-224.4299;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;73;-2576.844,-300.5354;Inherit;False;72;ScreenCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;30;-2384.007,-295.2591;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleDivideOpNode;28;-2378.373,-201.2941;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-2226.086,-295.2295;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;-2056.031,-295.3782;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;95;-4308.169,-354.2909;Inherit;False;661.7646;293.4001;Grainy UV;4;34;36;35;60;Grainy UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.LengthOpNode;6;-1906.911,-294.9615;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;100;-3555.344,-819.0746;Inherit;False;1532.584;322.878;Fish Eye;13;77;86;88;87;85;83;76;78;80;82;79;81;98;Fish Eye;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-4258.169,-304.291;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-1782.285,-304.0337;Inherit;False;ScreenLength;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-4242.169,-176.2909;Inherit;False;Property;_GrainyScale;Grainy Scale;3;0;Create;True;0;0;0;False;0;False;300;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-3505.344,-769.0746;Inherit;False;74;ScreenLength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;96;-3985.559,70.13943;Inherit;False;2436.35;644.36;Grainy Noise;17;53;51;52;71;61;56;55;58;57;33;69;70;38;40;37;39;89;Grainy Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-4002.17,-256.291;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-3565.897,-686.6783;Inherit;False;Property;_Radius;Radius;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-3871.205,-260.263;Inherit;False;GrainyUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;88;-3271.563,-741.7515;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;-3935.559,308.6728;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3921.917,386.3168;Inherit;False;Constant;_TimeSpeed;TimeSpeed;8;0;Create;True;0;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-3537.808,329.1734;Inherit;False;60;GrainyUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;56;-3673.931,146.0183;Inherit;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;0;False;0;False;2,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-3745.917,322.3167;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;71;-3666.081,479.9757;Inherit;False;Constant;_Vector1;Vector 1;9;0;Create;True;0;0;0;False;0;False;-0.6,-0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ClampOpNode;87;-3136.775,-741.7682;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-3359.857,-611.4028;Inherit;False;Property;_FishEyePower;FishEyePower;7;0;Create;True;0;0;0;False;0;False;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;58;-3175.791,463.6711;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-3088.943,-615.2179;Inherit;False;Property;_FishEyeZoom;FishEyeZoom;6;0;Create;True;0;0;0;False;0;False;0.5;0.5;0.3;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;55;-3172.855,126.0438;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;83;-2969.394,-742.1522;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-2745.011,-740.6672;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;33;-2966.538,120.1394;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-2797.356,-645.9962;Inherit;False;72;ScreenCenter;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;57;-2979.769,456.0993;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-2583.436,-640.2642;Inherit;False;Constant;_CenterEyeFish;CenterEyeFish;9;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-2541,-741.5102;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2660.757,341.438;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;70;-2520.068,342.2418;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;81;-2386.65,-740.9448;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2617.985,510.2973;Inherit;False;Property;_GrainyContrast;Grainy Contrast;5;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;105;-1467.689,-288.7505;Inherit;False;1250.059;715.6578;Assemble Effects;12;99;24;13;14;75;10;26;12;97;11;41;104;EyeFish + BlackCircle + Grainy;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2302.87,447.7834;Inherit;False;Property;_GrainyIntensity;Grainy Intensity;4;0;Create;True;0;0;0;False;0;False;0;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;37;-2293.671,344.8333;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-2247.56,-743.4883;Inherit;False;FIshEye;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-1417.689,311.5073;Inherit;False;Property;_FadeEnd;FadeEnd;2;0;Create;True;0;0;0;False;0;False;0.1;0;0.1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1396.803,0.7870455;Inherit;False;98;FIshEye;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1983.23,334.4117;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1415.524,232.3523;Inherit;False;Property;_FadeStart;FadeStart;1;0;Create;True;0;0;0;False;0;False;0;0;0;1.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-1335.293,145.6042;Inherit;False;74;ScreenLength;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;-1973.964,-821.5623;Inherit;False;1196.295;303.4172;Overlay;5;102;101;109;106;110;Overlay;1,1,1,1;0;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;24;-1354.457,-80.16067;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;12;-1126.461,213.1533;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-1222.938,-56.62954;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;102;-1923.964,-742.7624;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;10;-1137.795,-238.7505;Inherit;False;Constant;_Color0;Color 0;3;0;Create;True;0;0;0;False;0;False;0,0,0,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;89;-1774.009,334.3195;Inherit;False;GrainyNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-783.7217,12.60906;Inherit;False;89;GrainyNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;101;-1699.964,-771.5623;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-768.0837,-131.8601;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-566.7151,-130.6657;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;106;-1142.818,-742.9078;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-1362.097,-633.5452;Inherit;False;OverlayAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;104;-442.4299,-135.7762;Inherit;False;CameraView;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-1008.069,-747.6984;Inherit;False;OverlayTexture;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;-532.1278,-623.0459;Inherit;False;110;OverlayTexture;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-520.1277,-539.8459;Inherit;False;109;OverlayAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;-521.0333,-712.363;Inherit;False;104;CameraView;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;103;-249.2284,-634.0553;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-81.36115,-633.8778;Float;False;True;-1;2;ASEMaterialInspector;0;2;CameraEffect;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;2;0;1;0
WireConnection;3;0;2;0
WireConnection;3;1;5;0
WireConnection;72;0;3;0
WireConnection;30;0;73;0
WireConnection;28;0;27;1
WireConnection;28;1;27;2
WireConnection;31;0;30;0
WireConnection;31;1;28;0
WireConnection;32;0;31;0
WireConnection;32;1;30;1
WireConnection;6;0;32;0
WireConnection;74;0;6;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;60;0;35;0
WireConnection;88;0;77;0
WireConnection;88;1;86;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;87;0;88;0
WireConnection;58;0;61;0
WireConnection;58;2;71;0
WireConnection;58;1;52;0
WireConnection;55;0;61;0
WireConnection;55;2;56;0
WireConnection;55;1;52;0
WireConnection;83;0;87;0
WireConnection;83;1;85;0
WireConnection;78;0;83;0
WireConnection;78;1;76;0
WireConnection;33;0;55;0
WireConnection;57;0;58;0
WireConnection;79;0;78;0
WireConnection;79;1;80;0
WireConnection;69;0;33;0
WireConnection;69;1;57;0
WireConnection;70;0;69;0
WireConnection;81;0;79;0
WireConnection;81;1;82;0
WireConnection;37;0;70;0
WireConnection;37;1;38;0
WireConnection;98;0;81;0
WireConnection;39;0;37;0
WireConnection;39;1;40;0
WireConnection;12;0;75;0
WireConnection;12;1;13;0
WireConnection;12;2;14;0
WireConnection;26;0;24;0
WireConnection;26;1;99;0
WireConnection;89;0;39;0
WireConnection;101;1;102;0
WireConnection;11;0;10;0
WireConnection;11;1;26;0
WireConnection;11;2;12;0
WireConnection;41;0;11;0
WireConnection;41;1;97;0
WireConnection;106;0;101;1
WireConnection;106;1;101;2
WireConnection;106;2;101;3
WireConnection;109;0;101;4
WireConnection;104;0;41;0
WireConnection;110;0;106;0
WireConnection;103;0;107;0
WireConnection;103;1;112;0
WireConnection;103;2;113;0
WireConnection;0;0;103;0
ASEEND*/
//CHKSM=2B8413D205F69370D180926A5B00D391794DE8BA