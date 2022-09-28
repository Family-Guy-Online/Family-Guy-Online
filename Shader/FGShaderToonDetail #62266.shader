//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FG Character (with detail)" {
Properties {
 _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
 _MainTex ("Base (RGB)", 2D) = "white" {}
 _Detail ("Detail (RGB)", 2D) = "black" {}
 _OutlineColor ("Outline Color", Color) = (0,0,0,1)
 _Outline ("Outline width", Range(0.002,0.03)) = 0.005
 _OutlineShortRange ("Outline Short Range", Range(0.01,10)) = 5
 _OutlineMidRange ("Outline Mid Range", Range(1,100)) = 15
 _OutlineLongRange ("Outline Long Range", Range(1,100)) = 33
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
Program "vp" {
SubProgram "opengl " {
Bind "vertex" ATTR0
Bind "texcoord" ATTR1
Bind "texcoord1" ATTR2
"!!ARBvp1.0
# 8 ALU
PARAM c[13] = { program.local[0],
		state.matrix.mvp,
		state.matrix.texture[0],
		state.matrix.texture[1] };
DP4 result.position.w, vertex.attrib[0], c[4];
DP4 result.position.z, vertex.attrib[0], c[3];
DP4 result.position.y, vertex.attrib[0], c[2];
DP4 result.position.x, vertex.attrib[0], c[1];
DP4 result.texcoord[0].y, vertex.attrib[1], c[6];
DP4 result.texcoord[0].x, vertex.attrib[1], c[5];
DP4 result.texcoord[1].y, vertex.attrib[2], c[10];
DP4 result.texcoord[1].x, vertex.attrib[2], c[9];
END
# 8 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Matrix 8 [glstate_matrix_texture1]
"vs_2_0
; 8 ALU
dcl_position v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.y, v1, c5
dp4 oT0.x, v1, c4
dp4 oT1.y, v2, c9
dp4 oT1.x, v2, c8
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Detail] 2D
"!!ARBfp1.0
# 7 ALU, 2 TEX
PARAM c[2] = { program.local[0],
		{ 1 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[1], texture[1], 2D;
MUL R1.xyz, R1, R1.w;
MUL R0.xyz, R0, c[0];
ADD R1.w, -R1, c[1].x;
MAD result.color.xyz, R0, R1.w, R1;
MOV result.color.w, R0;
END
# 7 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Detail] 2D
"ps_2_0
; 5 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c1, 1.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
texld r1, t0, s0
texld r0, t1, s1
mul r1.xyz, r1, c0
mul_pp r0.xyz, r0, r0.w
add_pp r2.x, -r0.w, c1
mad r1.xyz, r1, r2.x, r0
mov_pp oC0, r1
"
}
}
 }
 UsePass "Shader Outline/OUTLINE"
}
Fallback "FG Character"
}