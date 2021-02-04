Shader "Custom/Shader28"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        zwrite off

        GrabPass{}

        CGPROGRAM
        #pragma surface surf NoLight noambient alpha:fade vertex:vert

        sampler2D _MainTex;
        sampler2D _GrabTexture;

        struct Input
        {
            float2 uv_MainTex;
            float4 grabUV;
        };

        void vert(inout appdata_full v, out Input o) {
            UNITY_INITIALIZE_OUTPUT(Input,o);
            float4 clipPos = UnityObjectToClipPos(v.vertex);
            o.grabUV = ComputeGrabScreenPos(clipPos);
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Emission = tex2Dproj(_GrabTexture, IN.grabUV + c.r * 0.05);
        }

        float4 LightingNoLight(SurfaceOutput s, float3 lightDir, float atten)
        {
            return float4(0, 0, 0, 1);
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
