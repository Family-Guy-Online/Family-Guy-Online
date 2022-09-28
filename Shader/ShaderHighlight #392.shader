//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Shader Highlight" {
Properties {
 _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
 _MainTex ("Base (RGB)", 2D) = "white" {}
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
Bind "texcoord" TexCoord0
"!!ARBvp1.0
# 6 ALU
PARAM c[9] = { program.local[0],
		state.matrix.mvp,
		state.matrix.texture[0] };
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].y, vertex.texcoord[0], c[6];
DP4 result.texcoord[0].x, vertex.texcoord[0], c[5];
END
# 6 instructions, 0 R-regs
"
}
SubProgram "d3d9 " {
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_texture0]
"vs_2_0
; 6 ALU
dcl_position0 v0
dcl_texcoord0 v1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.y, v1, c5
dp4 oT0.x, v1, c4
"
}
}
Program "fp" {
SubProgram "opengl " {
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 2 ALU, 1 TEX
PARAM c[1] = { program.local[0] };
TEMP R0;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL result.color, R0, c[0];
END
# 2 instructions, 1 R-regs
"
}
SubProgram "d3d9 " {
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 2 ALU, 1 TEX
dcl_2d s0
dcl t0.xy
texld r0, t0, s0
mul r0, r0, c0
mov_pp oC0, r0
"
}
}
 }
}
Fallback "Shader Flat"
}