//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Toon/Basic" {
Properties {
 _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
 _MainTex ("Base (RGB)", 2D) = "white" {}
 _ToonShade ("ToonShader Cubemap(RGB)", CUBE) = "" { TexGen CubeNormal }
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "BASE"
  Tags { "RenderType"="Opaque" }
  Cull Off
  SetTexture [_MainTex] { ConstantColor [_Color] combine texture * constant }
  SetTexture [_ToonShade] { combine texture * previous double, previous alpha }
 }
}
Fallback "VertexLit"
}