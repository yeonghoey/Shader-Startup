Shader "Custom/Shader29"
{
    Properties
    {
        _BumpMap ("NormalMap", 2D) = "bump" {}
        _Cube ("Cube", Cube) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        GrabPass{}

        CGPROGRAM
        #pragma surface surf WaterSpecular alpha:fade vertex:vert

        sampler2D _GrabTexture;

        sampler2D _BumpMap;
        samplerCUBE _Cube;

        struct Input
        {
            float2 uv_BumpMap;
            float3 viewDir;
            float3 worldRefl; INTERNAL_DATA
            float4 grabUV;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            const float PI = 3.14159265f;
            float movement = 0;
            movement += sin(abs(v.texcoord.x*2-1)*30 + _Time.y) * 0.005;
            movement += sin(abs(v.texcoord.y*2-1)*30 + _Time.y) * 0.005;
            v.vertex.y += movement * 0.5;

            float4 clipPos = UnityObjectToClipPos(v.vertex);
            o.grabUV = ComputeGrabScreenPos(clipPos);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            float3 normal1 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap + _Time.x*0.1));
            float3 normal2 = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap - _Time.x*0.1));
            o.Normal = (normal1 + normal2) / 2;
            
            float3 refColor = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, 1.5);

            float2 refUV = IN.grabUV.xy + (o.Normal.xy * 0.05);
            float3 refraction = tex2D(_GrabTexture, refUV);

            o.Emission = (refraction + refColor * rim) * 0.5;
            o.Alpha = 0.2;
        }

        float4 LightingWaterSpecular(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(H, s.Normal));
            spec = pow(spec, 150);

            float4 finalColor;
            finalColor.rgb = spec * 10;
            finalColor.a = s.Alpha + spec;
            return finalColor;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
