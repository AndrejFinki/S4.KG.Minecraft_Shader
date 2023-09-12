#version 120
#include "headers/constants.glsl"

attribute vec4 at_tangent;

void
main()
{
    gl_Position = ftransform();
    vec4 vertex = gl_ModelViewMatrix * gl_Vertex;
    normal = normalize( gl_NormalMatrix * gl_Normal );
    vec3 tangent = normalize( gl_NormalMatrix * at_tangent.xyz );
    vec3 bitangent = cross( normal, tangent );
    tangent_bitangent_normal = mat3( normal, tangent, bitangent );
    tex_coords = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
}