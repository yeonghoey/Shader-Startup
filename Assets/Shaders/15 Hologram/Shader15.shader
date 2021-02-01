Shader "Custom/Shader15"
{
    Properties
    {
        _BumpMap ("NormalMap", 2D) = "bump" {}
        _RimColor ("RimColor", Color) = (1, 1, 1, 1)
        _RimPower ("RimPower", Range(1, 10)) = 3
    }
    SubShader
    {
        // Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf NoLight noambient alpha:fade

        sampler2D _BumpMap;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_BumpMap;
            float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Emission = _RimColor.rgb;
            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, _RimPower);
            rim = rim + pow(frac(IN.worldPos.g * 3 - _Time.y), 5);
            rim = rim * 0.5;
            
            o.Alpha = rim;
        }

        float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, s.Alpha);
        }
        ENDCG
    }
    FallBack "Transparent/Diffuse"
}
