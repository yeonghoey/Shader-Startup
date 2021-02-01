Shader "Custom/Shader18"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "black" {}
        _OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineThickness ("Outline Thickness", Range(0, 100)) = 1
        _CelLevel ("Cel Level", Range(0, 5)) = 3.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        // cull front

        // CGPROGRAM
        // #pragma surface surf NoLight vertex:vert noshadow noambient

        // sampler2D _MainTex;
        // float4 _OutlineColor;
        // float _OutlineThickness;

        // void vert(inout appdata_full v)
        // {
        //     v.vertex.xyz = v.vertex.xyz + v.normal.xyz * 0.01 * _OutlineThickness;
        // }

        // struct Input
        // {
        //     float color:COLOR;
        // };

        // void surf (Input IN, inout SurfaceOutput o)
        // {
        // }

        // float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten)
        // {
        //     return _OutlineColor;
        // }
        // ENDCG

        cull back

        CGPROGRAM
        #pragma surface surf Toon noambient

        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _CelLevel;
        float4 _OutlineColor;
        float _OutlineThickness;


        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) ;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));;
            o.Alpha = c.a;
        }

        float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
            ndotl = ndotl * _CelLevel;
            ndotl = ceil(ndotl) / _CelLevel;
            float3 diffColor = s.Albedo * _LightColor0.rgb * ndotl;

            float rim = saturate(dot(s.Normal, viewDir));
            rim = rim > _OutlineThickness ? 1 : 0;

            return float4(diffColor * rim, s.Alpha);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
