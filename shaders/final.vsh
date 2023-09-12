#version 120
#include "headers/constants.glsl"

/*
    Final Vertex Shader
    Final is a fullscreen pass, and also the last pass in the shader pipeline.
    Whatever color final outputs is the color that gets displayed in-game.
*/

void
main()
{
   gl_Position = ftransform();
   tex_coords = gl_MultiTexCoord0.st;
}