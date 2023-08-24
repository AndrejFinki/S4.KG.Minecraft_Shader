#version 120
#include "distort.glsl"

void
main()
{
    gl_Position    = ftransform();
    gl_Position.xy = distort_position( gl_Position.xy );
}