#ifndef SHADOW_H
#define SHADOW_H

#include "distort.glsl"

float
get_shadow( float depth )
{
    vec3 clip_space = vec3( tex_coords, depth ) * 2.0 - 1.0;
    vec4 view_w = gbufferProjectionInverse * vec4( clip_space, 1.0 );
    vec3 view = view_w.xyz / view_w.w;
    vec4 world = gbufferModelViewInverse * vec4( view, 1.0 );
    vec4 shadow_space = shadowProjection * shadowModelView * world;
    shadow_space.xy = distort_position( shadow_space.xy );
    vec3 sample_coords = shadow_space.xyz * 0.5 + 0.5;
    return step( sample_coords.z - 0.001, texture2D( shadowtex0, sample_coords.xy ).r );
}

#endif