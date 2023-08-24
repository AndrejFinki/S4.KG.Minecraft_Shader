#version 120
#include "constants.glsl"
#include "distort.glsl"

void
main()
{
    gl_Position    = ftransform();
    gl_Position.xy = distort_position( gl_Position.xy );
    tex_coords = gl_MultiTexCoord0.st;
    color = gl_Color;
}