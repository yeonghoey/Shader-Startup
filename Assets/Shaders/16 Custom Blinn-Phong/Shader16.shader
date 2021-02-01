Shader "Custom/Shader16"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}

        _SpecularMap ("Specular Map", 2D) = "white" {}
        _SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecularPower ("Specular Power", Range(10, 200)) = 100
        _SpecularColor2 ("Specular Color 2", Color) = (1, 1, 1, 1)
        _SpecularPower2 ("Specular Power 2", Range(10, 200)) = 100

        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _RimPower ("Rim Power", Range(10, 200)) = 100
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Test

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _SpecularMap;

        float4 _SpecularColor;
        float _SpecularPower;

        float4 _SpecularColor2;
        float _SpecularPower2;

        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_SpecularMap;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            fixed4 m = tex2D(_SpecularMap, IN.uv_SpecularMap);
            o.Gloss = m.r;
            o.Alpha = c.a;
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            float ndotl = saturate(dot(s.Normal, lightDir));
            float3 diffColor = s.Albedo * _LightColor0.rgb * atten * ndotl;

            float3 H = normalize(lightDir + viewDir);
            float spec = pow(saturate(dot(H, s.Normal)), _SpecularPower);
            float3 specColor = spec * _SpecularColor * s.Gloss;

            float rim = abs(dot(viewDir, s.Normal));
            float3 specColor2 = pow(rim, _SpecularPower2) * _SpecularColor2 * s.Gloss;

            float invrim = 1 - rim;
            float3 rimColor = _RimColor.rgb * pow(invrim, _RimPower);         

            return float4(diffColor + specColor + specColor2 + rimColor, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
