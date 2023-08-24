#version 120
#include "constants.glsl"

void
main()
{
   gl_Position = ftransform();
   tex_coords = gl_MultiTexCoord0.st;
}