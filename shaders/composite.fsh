#version 120
#include "headers/constants.glsl"
#include "headers/lightmap.glsl"
#include "headers/shadow.glsl"
#include "headers/composite_utils.glsl"

/*
    Composite Fragment Shader
    The composite programs are fullscreen passes that run after all the gbuffers programs have finished executing.
*/

void
main()
{
    vec3 init_color = texture2D( colortex0, tex_coords ).rgb;
    vec3 albedo = pow( init_color, vec3( gamma_correction ) );
    float depth = texture2D( depthtex0, tex_coords ).z;

    if( sky_box_check( albedo, depth ) ) return;

    if( day_time_check() ) { day_time( albedo, depth ); return; }
    if( night_time_check() ) { night_time( albedo, depth ); return; }
    default_time( albedo, depth );
}