Shader "Custom/Toon"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (0,0.5,0.5,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    }
    SubShader
    {
        CGPROGRAM
        #pragma surface surf ToonRamp

        struct Input
        {
            float3 viewDir;
            float2 uv_MainTex;
        };

        float4 _Color;
        float4 _RimColor;
        float _RimPower;
        sampler2D _RampTex;

        float4 LightingToonRamp (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            //Getting the ramp needed for the shader
            float diff = dot (s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;
            float2 rh = h;
            float3 ramp = tex2D(_RampTex, rh).rgb;

            //Colour of the shader
            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            //Colour of rim
            o.Albedo = _Color.rgb;

            //Adding the rim light
            half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow (rim, _RimPower);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
