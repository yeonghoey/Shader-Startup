Shader "Custom/Shader27"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Matcap ("Matcap", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf NoLight noambient

        sampler2D _MainTex;
        sampler2D _Matcap;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float3 viewNormal = mul((float3x3)UNITY_MATRIX_V, IN.worldNormal);
            float2 matcapUV = viewNormal.xy * 0.5 + 0.5;
            o.Emission = c.rgb * tex2D(_Matcap, matcapUV);
            o.Alpha = c.a;
        }

        float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, s.Alpha);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
