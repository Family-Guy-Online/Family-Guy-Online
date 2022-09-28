//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FG Flat (with Transparency)" {
Properties {
 _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
 _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
 _AlphaThreshold ("Alpha Threshold", Range(0,1)) = 0.8
}
SubShader { 
 Tags { "QUEUE"="Transparent" }
 Pass {
  Name "BASE"
  Tags { "QUEUE"="Transparent" }
  Cull Off
  Blend SrcAlpha OneMinusSrcAlpha
  AlphaTest Greater [_AlphaThreshold]
  SetTexture [_MainTex] { ConstantColor [_Color] combine texture * constant }
 }
}
Fallback "FG Flat"
}