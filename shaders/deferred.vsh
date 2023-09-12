#version 120
#include "constants.glsl"

void
main()
{
    gl_Position = ftransform();
    vec4 vertex = gl_ModelViewMatrix * gl_Vertex;
    normal = normalize( gl_NormalMatrix * gl_Normal );
    vec3 tangent = normalize( gl_NormalMatrix * at_tangent.xyz );
    vec3 bitangent = cross( normal, tangent );
    mat3 tangent_bitangent_normal = mat3( normal, tangent, bitangent );
    texcoord = ( gl_TextureMatrix[0] * gl_MultiTexCoord0 ).xy;
}