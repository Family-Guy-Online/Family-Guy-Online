//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FG Character" {
Properties {
 _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
 _MainTex ("Base (RGB)", 2D) = "white" {}
 _ToonLight ("Toon Light Direction", Vector) = (-1,0.1,0,1)
 _ShadowBrightness ("Shadow Dimmer", Range(0,2)) = 0.9
 _ShadowSaturation ("Shadow Saturation", Range(-1,1)) = 0
 _ShadowSize ("Shadow Size", Range(-1,1)) = -1
 _GlimmerBrightness ("Glimmer Dimmer", Range(0,2)) = 1.2
 _GlimmerSaturation ("Glimmer Saturation", Range(-1,1)) = 0
 _GlimmerSize ("Glimmer Size", Range(-1,1)) = 1
 _OutlineColor ("Outline Color", Color) = (0,0,0,1)
 _Outline ("Outline width", Range(0.002,0.03)) = 0.002
 _OutlineShortRange ("Outline Short Range", Range(0.01,10)) = 3.968
 _OutlineMidRange ("Outline Mid Range", Range(1,100)) = 4.736
 _OutlineLongRange ("Outline Long Range", Range(1,100)) = 23.66
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 UsePass "Shader Highlight/HIGHLIGHT"
 UsePass "Shader Outline/OUTLINE"
}
Fallback "FG Flat"
}