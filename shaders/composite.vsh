#version 120
#include "constants.glsl"

varying vec3 Normal;


void
main()
{
   vec4 vert = gl_ModelViewMatrix * gl_Vertex;
   
   gl_Position = ftransform();
   tex_coords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
   Normal = gl_NormalMatrix * gl_Normal;
}