#version 120
#extension GL_EXT_gpu_shader4 : enable
#include "headers/constants.glsl"
#include "headers/utils.glsl"
#include "headers/ambient_occlusion.glsl"

void
main()
{
    vec3 color = texture2D( colortex0, tex_coords ).rgb;
    color *= ambient_occlusion();

    /* DRAWBUFFERS:0 */
    gl_FragData[0] = vec4( color, 1.0 );
}