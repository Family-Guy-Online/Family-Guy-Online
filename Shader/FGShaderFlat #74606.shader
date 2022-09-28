//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FG Flat" {
Properties {
 _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
 _MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "BASE"
  Tags { "RenderType"="Opaque" }
  Cull Off
  SetTexture [_MainTex] { ConstantColor [_Color] combine texture * constant }
 }
}
Fallback "Toon/Basic"
}