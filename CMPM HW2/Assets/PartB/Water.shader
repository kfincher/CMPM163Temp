
Shader "Custom/Water"
{
    Properties
    {   
        _Color ("Color", Color) = (1, 1, 1, 1) //The color of our object
        _Shininess ("Shininess", Float) = 32 //Shininess
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) //Specular highlights color
        _DirtTex ("DirtTexture", 2D) = "white" {}
        _GrassTex ("GrassTexture", 2D) = "white" {}
        _SnowTex ("SnowTexture", 2D) = "white" {}
		_Cube("Cubemap", 2D) = "white" {}
        _HeightMapTex ("HeightMapTexture", 2D) = "white" {}


		[NoScaleOffset] _ReflectiveColor("Reflective color (RGB) fresnel (A) ", 2D) = "" {}
		[NoScaleOffset] _BumpMap("Normalmap ", 2D) = "bump" {}
        _DisplacementAmt ("DisplacementW", Float) = 1.0 
    }
    
    SubShader
    {
			Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};


			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normalInWorldCoords : NORMAL;
				float3 vertexInWorldCoords : TEXCOORD1;
			};

			v2f vert(appdata v)
			{
				v2f o;

				o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords

				o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); //Normal 

				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}

			float4 _Cube;

			fixed4 frag(v2f i) : SV_Target
			{

			 /*float3 P = i.vertexInWorldCoords.xyz;

			 //get normalized incident ray (from camera to vertex)
			 float3 vIncident = normalize(P - _WorldSpaceCameraPos);

			 //reflect that ray around the normal using built-in HLSL command
			 float3 vReflect = reflect(vIncident, i.normalInWorldCoords);


			 //use the reflect ray to sample the skybox
			 float4 reflectColor = tex2Dproj(_Cube, vReflect);


			 //refract the incident ray through the surface using built-in HLSL command
			 float3 vRefract = refract(vIncident, i.normalInWorldCoords, 0.5);

			 //float4 refractColor = texCUBE( _Cube, vRefract );


			 float3 vRefractRed = refract(vIncident, i.normalInWorldCoords, 0.1);
			 float3 vRefractGreen = refract(vIncident, i.normalInWorldCoords, 0.4);
			 float3 vRefractBlue = refract(vIncident, i.normalInWorldCoords, 0.7);

			 float4 refractColorRed = tex2D(_Cube, float3(vRefractRed));
			 float4 refractColorGreen = tex2D(_Cube, float3(vRefractGreen));
			 float4 refractColorBlue = tex2D(_Cube, float3(vRefractBlue));
			 float4 refractColor = float4(refractColorRed.r, refractColorGreen.g, refractColorBlue.b, 1.0);


			 return float4(lerp(reflectColor, refractColor, 0.5).rgb, 1.0);

			 */
				/*sampler2D _BumpMap;
				half3 bump1 = UnpackNormal(tex2D(_BumpMap, i.bumpuv0)).rgb;
			half3 bump2 = UnpackNormal(tex2D(_BumpMap, i.bumpuv1)).rgb;
			half3 bump = (bump1 + bump2) * 0.5;

			// fresnel factor
			half fresnelFac = dot(i.viewDir, bump);*/
				/*sampler2D _ReflectiveColor;
				half4 water = tex2D(_ReflectiveColor, float2(fresnelFac,fresnelFac));
				color.rgb = lerp(water.rgb, refl.rgb, water.a);
				color.a = refl.a * water.a;*/
				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldRefl);
				// decode cubemap data into actual color
				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

			}

			ENDCG
		}
        /*Pass {
            Tags { "LightMode" = "ForwardAdd" } //Important! In Unity, point lights are calculated in the the ForwardAdd pass
            // Blend One One //Turn on additive blending if you have more than one point light
          
            Cull off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
           
            uniform float4 _LightColor0; //From UnityCG
            uniform float4 _Color; 
            uniform float4 _SpecColor;
            uniform float _Shininess;     
            uniform sampler2D _DirtTex;     
            uniform sampler2D _SnowTex;     
            uniform sampler2D _GrassTex; 
            uniform sampler2D _HeightMapTex;    
            uniform float _DisplacementAmt;
            
          
            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                    float4 vertex : SV_POSITION;
                    float3 normal : NORMAL;       
                    float2 uv : TEXCOORD0;
                    float3 vertexInWorldCoords : TEXCOORD1;
                    float heightVal : TEXCOORD2;
            };

 
           v2f vert(appdata v)
           { 
                v2f o;
                
                //special texture sampler function to specify LOD (needed in order to access textures in vertex shader)
                //see http://developer.download.nvidia.com/cg/tex2Dlod.html
                float3 hmVal = tex2Dlod(_HeightMapTex, float4(v.uv, 0, 0)).rgb;
                
                float vDisplace = hmVal.r * _DisplacementAmt; 
                float4 newPosition = float4((v.vertex.xyz + v.normal.xyz * vDisplace).xyz, 1.0);
      
                
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, newPosition); //Vertex position in WORLD coords
                o.normal = UnityObjectToWorldNormal(v.normal); //Normal vector in WORLD coords 
                o.vertex = UnityObjectToClipPos(newPosition); 
                o.uv = v.uv;
                o.heightVal = newPosition.y;
                
              

                return o;
           }

           fixed4 frag(v2f i) : SV_Target
           {
                
                float3 P = i.vertexInWorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 V = normalize(_WorldSpaceCameraPos - P);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                float3 H = normalize(L + V);
                
                float3 Kd = _Color.rgb; //Color of object
                //float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
                float3 Ka = float3(0,0,0); //UNITY_LIGHTMODEL_AMBIENT.rgb; //Ambient light
                float3 Ks = _SpecColor.rgb; //Color of specular highlighting
                float3 Kl = _LightColor0.rgb; //Color of light
                
                
                //AMBIENT LIGHT 
                float3 ambient = Ka;
                
               
                //DIFFUSE LIGHT
                float diffuseVal = max(dot(N, L), 0);
                float3 diffuse = Kd * Kl * diffuseVal;
                
                
                //SPECULAR LIGHT
                float specularVal = pow(max(dot(N,H), 0), _Shininess);
                
                if (diffuseVal <= 0) {
                    specularVal = 0;
                }
                
                float3 specular = Ks * Kl * specularVal;
                
                //FINAL LIGHT COLOR OF FRAGMENT
                float3 lightColor = float3(ambient + diffuse + specular);
                
                
                
               
                float3 dirt = tex2D(_DirtTex, i.uv).rgb;
                float3 grass = tex2D(_GrassTex, i.uv).rgb;
                float3 snow = tex2D(_SnowTex, i.uv).rgb;
                
                float3 textureColor;
                
                if (i.heightVal < 0.5) {
                
                    textureColor = lerp(dirt, grass, i.heightVal*2);    
                }
                
                if (i.heightVal >= 0.5) {
                    textureColor = lerp(grass, snow, i.heightVal*2 - 1);   
                }
                
                return float4(lerp(textureColor, lightColor, 0.2), 1.0);
                

            }
            
            ENDCG
 
            
        }
		*/
            
    }
	/*SubShader{
	 Tags { "RenderType" = "Opaque" }
	 CGPROGRAM
	 #pragma surface surf Lambert
	 struct Input {
		 float2 uv_MainTex;
		 float3 worldRefl;
	 };
	 sampler2D _MainTex;
	 samplerCUBE _Cube;
	 void surf(Input IN, inout SurfaceOutput o) {
		 o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * 0.5;
		 o.Emission = texCUBE(_Cube, IN.worldRefl).rgb;
	 }
	 ENDCG
	}*/
}
