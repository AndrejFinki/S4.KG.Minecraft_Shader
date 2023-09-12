#version 120
#include "headers/constants.glsl"

/*
    Composite Vertex Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

attribute vec4 at_tangent;

void
main()
{
   vec4 vertex = gl_ModelViewMatrix * gl_Vertex;
   vec3 pos = vertex.xyz;
   normal = normalize( gl_NormalMatrix * gl_Normal );
   vec3 tangent = normalize( gl_NormalMatrix * at_tangent.xyz );
   vec3 bitangent = cross( normal, tangent );
   mat3 tangent_bitangent_normal = mat3( normal, tangent, bitangent );
   gl_Position = ftransform();
   tex_coords = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
   normal = gl_NormalMatrix * gl_Normal;
}