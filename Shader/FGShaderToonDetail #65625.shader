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
 _ToonLight ("Toon Light Direction", Vector) = (-1,0.1,0,1)
 _ShadowBrightness ("Shadow Dimmer", Range(0,2)) = 0.9
 _ShadowSaturation ("Shadow Saturation", Range(-1,1)) = 0
 _ShadowSize ("Shadow Size", Range(-1,1)) = -0.8
 _GlimmerBrightness ("Glimmer Dimmer", Range(0,2)) = 1.2
 _GlimmerSaturation ("Glimmer Saturation", Range(-1,1)) = 0
 _GlimmerSize ("Glimmer Size", Range(-1,1)) = 0.9
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
Bind "normal" ATTR1
Bind "texcoord" ATTR2
Bind "texcoord1" ATTR3
"!!ARBvp1.0
# 11 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		state.matrix.texture[0],
		state.matrix.texture[1],
		state.matrix.modelview[0].invtrans };
DP4 result.position.w, vertex.attrib[0], c[4];
DP4 result.position.z, vertex.attrib[0], c[3];
DP4 result.position.y, vertex.attrib[0], c[2];
DP4 result.position.x, vertex.attrib[0], c[1];
DP4 result.texcoord[0].y, vertex.attrib[2], c[6];
DP4 result.texcoord[0].x, vertex.attrib[2], c[5];
DP4 result.texcoord[1].y, vertex.attrib[3], c[10];
DP4 result.texcoord[1].x, vertex.attrib[3], c[9];
DP3 result.texcoord[2].z, vertex.attrib[1], c[15];
DP3 result.texcoord[2].y, vertex.attrib[1], c[14];
DP3 result.texcoord[2].x, vertex.attrib[1], c[13];
END
# 11 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Matrix 8 [glstate_matrix_texture1]
Matrix 12 [glstate_matrix_invtrans_modelview0]
"vs_2_0
; 11 ALU
dcl_position v0
dcl_normal v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.y, v2, c5
dp4 oT0.x, v2, c4
dp4 oT1.y, v3, c9
dp4 oT1.x, v3, c8
dp3 oT2.z, v1, c14
dp3 oT2.y, v1, c13
dp3 oT2.x, v1, c12
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_Color]
Vector 1 [_ToonLight]
Float 2 [_ShadowBrightness]
Float 3 [_ShadowSaturation]
Float 4 [_ShadowSize]
Float 5 [_GlimmerBrightness]
Float 6 [_GlimmerSaturation]
Float 7 [_GlimmerSize]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Detail] 2D
"!!ARBfp1.0
# 28 ALU, 2 TEX
PARAM c[10] = { program.local[0..7],
		{ 1, 0.22, 0.70700002, 0.071000002 },
		{ 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1, fragment.texcoord[1], texture[1], 2D;
MUL R1.xyz, R1, R1.w;
MUL R0.xyz, R0, c[0];
ADD R1.w, -R1, c[8].x;
MAD R1.xyz, R0, R1.w, R1;
DP3 R1.w, c[1], c[1];
RSQ R2.x, R1.w;
MUL R2.xyz, R2.x, c[1];
DP3 R3.x, fragment.texcoord[2], R2;
DP3 R0.xyz, R1, c[8].yzww;
MOV R1.w, R0;
ADD R2, R1, -R0;
SLT R0.z, R3.x, c[4].x;
ADD R0.x, R3, -c[4];
SLT R0.w, c[7].x, R3.x;
MOV R0.y, c[8].x;
ABS R0.z, R0;
CMP R0.z, -R0, c[9].x, R0.y;
MUL R0.z, R0, R0.w;
CMP R0.w, R0.x, c[2].x, R0.y;
CMP R3.x, -R0.z, c[5], R0.w;
MOV R0.y, c[9].x;
CMP R0.x, R0, c[3], R0.y;
MOV R0.w, c[9].x;
CMP R0.xyz, -R0.z, c[6].x, R0.x;
MAD R0, R2, R0, R1;
MUL result.color, R0, R3.x;
END
# 28 instructions, 4 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_Color]
Vector 1 [_ToonLight]
Float 2 [_ShadowBrightness]
Float 3 [_ShadowSaturation]
Float 4 [_ShadowSize]
Float 5 [_GlimmerBrightness]
Float 6 [_GlimmerSaturation]
Float 7 [_GlimmerSize]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Detail] 2D
"ps_2_0
; 30 ALU, 2 TEX
dcl_2d s0
dcl_2d s1
def c8, 1.00000000, 0.00000000, 0, 0
def c9, 0.22000000, 0.70700002, 0.07100000, 0
dcl t0.xy
dcl t1.xy
dcl t2.xyz
texld r0, t0, s0
texld r1, t1, s1
mul_pp r3.xyz, r1, r1.w
mul r2.xyz, r0, c0
add_pp r0.x, -r1.w, c8
mad r4.xyz, r2, r0.x, r3
dp3 r1.x, c1, c1
rsq r0.x, r1.x
mul r0.xyz, r0.x, c1
dp3 r0.x, t2, r0
add r1.x, r0, -c4
cmp r1.x, r1, c8.y, c8
abs_pp r1.x, r1
mov r4.w, r0
dp3 r2.xyz, r4, c9
mov r2.w, r0
add r5, r4, -r2
add r2.x, -r0, c7
cmp r2.x, r2, c8.y, c8
cmp_pp r1.x, -r1, c8, c8.y
mul_pp r1.x, r1, r2
add r2.x, r0, -c4
mov r3.x, c2
cmp r0.x, r2, c8, r3
mov r3.x, c3
cmp r0.x, -r1, r0, c5
cmp r2.x, r2, c8.y, r3
mov r1.w, c8.y
cmp r1.xyz, -r1.x, r2.x, c6.x
mad r1, r5, r1, r4
mul r0, r1, r0.x
mov_pp oC0, r0
"
}
}
 }
 UsePass "Shader Outline/OUTLINE"
}
Fallback "FG Character"
}