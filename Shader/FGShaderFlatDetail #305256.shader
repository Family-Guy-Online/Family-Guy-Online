//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FG Flat (with detail)" {
Properties {
 _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
 _MainTex ("Base (RGB)", 2D) = "white" {}
 _Detail ("Detail (RGB)", 2D) = "black" {}
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "BASE"
  Tags { "RenderType"="Opaque" }
  BindChannels {
   Bind "vertex", Vertex
   Bind "normal", Normal
   Bind "texcoord", TexCoord0
   Bind "texcoord1", TexCoord1
  }
  Cull Off
  SetTexture [_MainTex] { Matrix [_MainTexControl] ConstantColor [_Color] combine texture * constant }
  SetTexture [_Detail] { Matrix [_DetailControl] combine texture lerp(texture) previous, previous alpha }
 }
}
Fallback "FG Flat"
}