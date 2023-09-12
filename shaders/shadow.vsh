#version 120
#include "headers/constants.glsl"
#include "headers/distort.glsl"

/*
    Shadow Vertex Shader
    The Shadow pass is a stage that runs for all types of blocks, entities, etc.
    It is optional, but it can be used to improve the look of shadows in general.
*/

void
main()
{
    gl_Position    = ftransform();
    gl_Position.xy = distort_position( gl_Position.xy );
    tex_coords = gl_MultiTexCoord0.st;
    color = gl_Color;
}