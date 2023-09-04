#version 120
#include "headers/constants.glsl"

/*
    Composite Vertex Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

varying vec3 Normal;


void
main()
{
   vec4 vert = gl_ModelViewMatrix * gl_Vertex;
   
   gl_Position = ftransform();
   tex_coords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
   Normal = gl_NormalMatrix * gl_Normal;
}