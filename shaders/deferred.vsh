#version 120
#include "constants.glsl"

varying vec2 texcoord;
varying mat3 tbn;
varying vec3 Normal;
attribute vec4 at_tangent;


void main() {
   gl_Position = ftransform();
   vec4 vert = gl_ModelViewMatrix * gl_Vertex;

   Normal = normalize(gl_NormalMatrix * gl_Normal);
   vec3 tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
   vec3 bitangent = cross(Normal, tangent);
   mat3 tbn = mat3(Normal, tangent, bitangent);
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}