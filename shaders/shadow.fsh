#version 120
#include "constants.glsl"

void
main()
{
    gl_FragData[0] = texture2D( texture, tex_coords ) * color;
}