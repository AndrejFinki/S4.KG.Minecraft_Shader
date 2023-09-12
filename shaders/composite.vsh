#version 120
#include "headers/constants.glsl"

/*
    Composite Vertex Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

void
main()
{
   gl_Position = ftransform();
   tex_coords = gl_MultiTexCoord0.st;
}