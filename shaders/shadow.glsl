#ifndef SHADOW_H
#define SHADOW_H

#include "distort.glsl"

float
visibility( in sampler2D shadow_map, in vec3 sample_coords )
{
    return step( sample_coords.z - 0.001, texture2D( shadow_map, sample_coords.xy ).r );
}

vec3
transparent_shadow( in vec3 sample_coords )
{
    float shadow_visibility_0 = visibility( shadowtex0, sample_coords );
    float shadow_visibility_1 = visibility( shadowtex1, sample_coords );
    vec4 shadow_color_0 = texture2D( shadowcolor0, sample_coords.xy );
    vec3 transmitted_color = shadow_color_0.rgb * ( 1.0 - shadow_color_0.a );
    return mix( transmitted_color * shadow_visibility_1, vec3( 1.0 ), shadow_visibility_0 );
}

vec3
get_shadow( float depth )
{
    vec3 clip_space = vec3( tex_coords, depth ) * 2.0 - 1.0;
    vec4 view_w = gbufferProjectionInverse * vec4( clip_space, 1.0 );
    vec3 view = view_w.xyz / view_w.w;
    vec4 world = gbufferModelViewInverse * vec4( view, 1.0 );
    vec4 shadow_space = shadowProjection * shadowModelView * world;
    shadow_space.xy = distort_position( shadow_space.xy );
    vec3 sample_coords = shadow_space.xyz * 0.5 + 0.5;
    return transparent_shadow( sample_coords );
}

#endif