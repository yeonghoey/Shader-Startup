Shader "Custom/Shader25"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Cut ("Alpha Cut", Range(0, 1)) = 0
        [HDR] _OutColor ("OutColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float _Cut;
        float4 _OutColor;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            float4 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
            o.Albedo = c.rgb;
            float st = abs(_SinTime.z) * 0.15;
            float cut = st;
            o.Emission = noise.r >= cut * 1.15 ? 0 : _OutColor.rgb;
            o.Alpha = noise.r >= cut ? 1 : 0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
