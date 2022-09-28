//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Shader Outline" {
Properties {
 _OutlineColor ("Outline Color", Color) = (0,0,0,1)
 _Outline ("Outline width", Range(0.002,0.03)) = 0.002
 _OutlineShortRange ("Outline Short Range", Range(0.01,10)) = 3.968
 _OutlineMidRange ("Outline Mid Range", Range(1,100)) = 4.736
 _OutlineLongRange ("Outline Long Range", Range(1,100)) = 23.66
}
SubShader { 
 Tags { "RenderType"="Opaque" }
 Pass {
  Name "OUTLINE"
  Tags { "LIGHTMODE"="Always" "RenderType"="Opaque" }
  Cull Front
  Blend SrcAlpha OneMinusSrcAlpha
  ColorMask RGB
Program "vp" {
SubProgram "opengl " {
Bind "vertex" ATTR0
Bind "normal" ATTR1
Float 13 [_Outline]
Float 14 [_OutlineShortRange]
Float 15 [_OutlineMidRange]
Float 16 [_OutlineLongRange]
Vector 17 [_OutlineColor]
"!!ARBvp1.0
# 36 ALU
PARAM c[18] = { { 1, 0 },
		state.matrix.modelview[0],
		state.matrix.projection,
		state.matrix.mvp,
		program.local[13..17] };
TEMP R0;
TEMP R1;
DP4 R0.x, vertex.attrib[0], c[11];
MOV R0.y, c[16].x;
ADD R0.y, R0, c[15].x;
SLT R0.y, R0, R0.x;
ABS R0.z, R0.y;
SGE R0.w, c[0].y, R0.z;
SLT R0.z, R0.x, c[15].x;
ABS R1.y, R0.z;
SLT R1.x, R0, c[14];
ABS R1.x, R1;
SGE R1.z, c[0].y, R1.y;
SGE R1.y, c[0], R1.x;
MUL R1.x, R1.y, R1.z;
MUL R1.y, R1, R0.z;
ADD R0.z, R0.x, -c[14].x;
MAD R0.z, R0, R1.y, c[14].x;
MUL R0.w, R1.x, R0;
MUL R0.y, R1.x, R0;
MAD R1.x, -R0.z, R0.y, R0.z;
RCP R0.z, c[16].x;
ADD R0.y, R0.x, -c[15].x;
MAD R0.y, -R0, R0.z, c[0].x;
MAD R0.y, R0, c[15].x, -R1.x;
MAD R1.x, R0.y, R0.w, R1;
DP3 R0.y, vertex.attrib[1], c[2];
DP3 R0.z, vertex.attrib[1], c[1];
MUL R0.w, R0.y, c[6].y;
MUL R0.z, R0, c[5].x;
MUL R1.xy, R0.zwzw, R1.x;
DP4 R0.z, vertex.attrib[0], c[9];
DP4 R0.w, vertex.attrib[0], c[10];
MAD result.position.xy, R1, c[13].x, R0.zwzw;
MOV result.color, c[17];
DP4 result.position.w, vertex.attrib[0], c[12];
MOV result.position.z, R0.x;
MOV result.fogcoord.x, R0;
END
# 36 instructions, 2 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_projection]
Matrix 8 [glstate_matrix_mvp]
Float 12 [_Outline]
Float 13 [_OutlineShortRange]
Float 14 [_OutlineMidRange]
Float 15 [_OutlineLongRange]
Vector 16 [_OutlineColor]
"vs_2_0
; 49 ALU
def c17, 0.00000000, 1.00000000, 0, 0
dcl_position v0
dcl_normal v1
dp4 r0.x, v0, c10
mov r0.y, c14.x
add r0.y, c15.x, r0
slt r0.y, r0, r0.x
sge r0.w, c17.x, r0.y
sge r0.z, r0.y, c17.x
mul r1.x, r0.z, r0.w
slt r0.w, r0.x, c14.x
sge r1.z, c17.x, r0.w
sge r0.z, r0.w, c17.x
mul r0.z, r0, r1
slt r1.y, r0.x, c13.x
sge r1.z, c17.x, r1.y
sge r1.y, r1, c17.x
mul r1.y, r1, r1.z
mul r0.z, r1.y, r0
mul r1.y, r1, r0.w
mul r1.x, r0.z, r1
max r1.x, -r1, r1
slt r0.w, c17.x, r1.x
mul r0.y, r0.z, r0
max r1.y, -r1, r1
slt r1.y, c17.x, r1
add r0.z, -r1.y, c17.y
max r0.y, -r0, r0
mul r0.z, r0, c13.x
slt r0.y, c17.x, r0
add r1.x, -r0.w, c17.y
mad r0.z, r0.x, r1.y, r0
add r0.y, -r0, c17
mul r1.y, r0, r0.z
rcp r0.z, c15.x
add r0.y, r0.x, -c14.x
mad r0.y, -r0, r0.z, c17
mul r0.z, r1.x, r1.y
mul r0.y, r0, c14.x
mad r1.x, r0.w, r0.y, r0.z
dp3 r0.y, v1, c1
dp3 r0.z, v1, c0
mul r0.w, r0.y, c5.y
mul r0.z, r0, c4.x
mul r1.xy, r0.zwzw, r1.x
dp4 r0.z, v0, c8
dp4 r0.w, v0, c9
mad oPos.xy, r1, c12.x, r0.zwzw
mov oD0, c16
dp4 oPos.w, v0, c11
mov oPos.z, r0.x
mov oFog, r0.x
"
}
}
  SetTexture [_MainTex] { combine primary }
 }
}
}