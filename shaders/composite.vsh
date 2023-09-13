#version 120
#include "headers/constants.glsl"

/*
    Composite Vertex Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

varying vec3 Normal;
attribute vec4 at_tangent;
varying mat3 tbn;
varying vec3 pos;

void
main()
{
   vec4 vert = gl_ModelViewMatrix * gl_Vertex;
   pos = vert.xyz;
   Normal = normalize(gl_NormalMatrix * gl_Normal);
   vec3 tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
   vec3 bitangent = cross(Normal, tangent);
   mat3 tbn = mat3(Normal, tangent, bitangent);

   gl_Position = ftransform();
   tex_coords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
   
}