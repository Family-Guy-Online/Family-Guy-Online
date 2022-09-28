//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FG Character" {
Properties {
 _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
 _MainTex ("Base (RGB)", 2D) = "white" {}
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