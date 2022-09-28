//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "FG Character Eyes" {
Properties {
 _MainTex ("Base (RGB)", 2D) = "white" {}
 _EyeLid ("Detail (RGB)", 2D) = "black" {}
 _Pupil ("Pupil (RGB)", 2D) = "black" {}
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "BASE"
  Tags { "RenderType"="Opaque" }
  Cull Off
Program "vp" {
SubProgram "opengl " {
Bind "vertex" ATTR0
Bind "texcoord" ATTR1
Bind "texcoord1" ATTR2
"!!ARBvp1.0
# 10 ALU
PARAM c[17] = { program.local[0],
		state.matrix.mvp,
		state.matrix.texture[0],
		state.matrix.texture[1],
		state.matrix.texture[2] };
DP4 result.position.w, vertex.attrib[0], c[4];
DP4 result.position.z, vertex.attrib[0], c[3];
DP4 result.position.y, vertex.attrib[0], c[2];
DP4 result.position.x, vertex.attrib[0], c[1];
DP4 result.texcoord[0].y, vertex.attrib[1], c[6];
DP4 result.texcoord[0].x, vertex.attrib[1], c[5];
DP4 result.texcoord[1].y, vertex.attrib[2], c[10];
DP4 result.texcoord[1].x, vertex.attrib[2], c[9];
DP4 result.texcoord[2].y, vertex.attrib[2], c[14];
DP4 result.texcoord[2].x, vertex.attrib[2], c[13];
END
# 10 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
Matrix 8 [glstate_matrix_texture1]
Matrix 12 [glstate_matrix_texture2]
"vs_2_0
; 10 ALU
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
dp4 oT2.y, v2, c13
dp4 oT2.x, v2, c12
"
}
}
Program "fp" {
SubProgram "opengl " {
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_EyeLid] 2D
SetTexture 2 [_Pupil] 2D
"!!ARBfp1.0
# 11 ALU, 3 TEX
PARAM c[1] = { { 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[1], texture[1], 2D;
TEX R1, fragment.texcoord[2], texture[2], 2D;
TEX R2.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R1.w, R0, R1;
MUL R0.xyz, R0, R0.w;
ADD R0.w, -R0, c[0].x;
MAD R0.xyz, R2, R0.w, R0;
MUL R1.xyz, R1.w, R1;
ADD R0.w, -R1, c[0].x;
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[0].x;
END
# 11 instructions, 3 R-regs
"
}
SubProgram "d3d9 " {
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_EyeLid] 2D
SetTexture 2 [_Pupil] 2D
"ps_2_0
; 9 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c0, 1.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xy
dcl t2.xy
texld r3, t0, s0
texld r2, t2, s2
texld r1, t1, s1
mul_pp r4.xyz, r1, r1.w
mul_pp r0.x, r1.w, r2.w
add_pp r1.x, -r1.w, c0
mad r3.xyz, r3, r1.x, r4
add r1.x, -r0, c0
mul r0.xyz, r0.x, r2
mov r0.w, c0.x
mad r0.xyz, r3, r1.x, r0
mov_pp oC0, r0
"
}
}
 }
}
Fallback "FG Flat"
}