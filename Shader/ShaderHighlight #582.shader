//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Shader Highlight" {
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
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "HIGHLIGHT"
  Tags { "RenderType"="Opaque" }
  Cull Off
Program "vp" {
SubProgram "opengl " {
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
"!!ARBvp1.0
# 9 ALU
PARAM c[13] = { program.local[0],
		state.matrix.mvp,
		state.matrix.texture[0],
		state.matrix.modelview[0].invtrans };
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].y, vertex.texcoord[0], c[6];
DP4 result.texcoord[0].x, vertex.texcoord[0], c[5];
DP3 result.texcoord[1].z, vertex.normal, c[11];
DP3 result.texcoord[1].y, vertex.normal, c[10];
DP3 result.texcoord[1].x, vertex.normal, c[9];
END
# 9 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Matrix 8 [glstate_matrix_invtrans_modelview0]
"vs_2_0
; 9 ALU
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.y, v2, c5
dp4 oT0.x, v2, c4
dp3 oT1.z, v1, c10
dp3 oT1.y, v1, c9
dp3 oT1.x, v1, c8
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
"!!ARBfp1.0
# 23 ALU, 1 TEX
PARAM c[10] = { program.local[0..7],
		{ 1, 0 },
		{ 0.22, 0.70700002, 0.071000002 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1, R0, c[0];
DP3 R2.x, c[1], c[1];
RSQ R0.w, R2.x;
MUL R2.xyz, R0.w, c[1];
DP3 R3.x, fragment.texcoord[1], R2;
DP3 R0.xyz, R1, c[9];
MOV R0.w, R1;
ADD R2, R1, -R0;
SLT R0.w, R3.x, c[4].x;
ABS R3.y, R0.w;
ADD R0.z, R3.x, -c[4].x;
MOV R0.xy, c[8];
SLT R0.w, c[7].x, R3.x;
CMP R3.x, -R3.y, c[8].y, c[8];
MUL R3.y, R3.x, R0.w;
CMP R0.x, R0.z, c[2], R0;
CMP R3.x, -R3.y, c[5], R0;
CMP R0.x, R0.z, c[3], R0.y;
MOV R0.w, c[8].y;
CMP R0.xyz, -R3.y, c[6].x, R0.x;
MAD R0, R2, R0, R1;
MUL result.color, R0, R3.x;
END
# 23 instructions, 4 R-regs
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
"ps_2_0
; 26 ALU, 1 TEX
dcl_2d s0
def c8, 0.22000000, 0.70700002, 0.07100000, 0.00000000
def c9, 0.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
texld r1, t0, s0
mul r4, r1, c0
dp3 r0.x, c1, c1
rsq r0.x, r0.x
mul r0.xyz, r0.x, c1
dp3 r0.x, t1, r0
add r1.x, r0, -c4
cmp r1.x, r1, c9, c9.y
abs_pp r1.x, r1
dp3 r2.xyz, r4, c8
mov r2.w, r4
add r5, r4, -r2
add r2.x, -r0, c7
cmp r2.x, r2, c9, c9.y
cmp_pp r1.x, -r1, c9.y, c9
mul_pp r1.x, r1, r2
add r2.x, r0, -c4
mov r3.x, c2
cmp r0.x, r2, c9.y, r3
mov r3.x, c3
cmp r0.x, -r1, r0, c5
cmp r2.x, r2, c8.w, r3
mov r1.w, c8
cmp r1.xyz, -r1.x, r2.x, c6.x
mad r1, r5, r1, r4
mul r0, r1, r0.x
mov_pp oC0, r0
"
}
}
 }
}
Fallback "Shader Flat"
}