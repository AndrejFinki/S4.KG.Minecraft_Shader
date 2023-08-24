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
    vec3 shadow_accumulated = vec3( 0.0 );
    float random_angle = texture2D( noisetex, tex_coords * 20.0 ).r * 100.0;
    float cos_theta = cos( random_angle );
    float sin_theta = sin( random_angle );
    mat2 rotation = mat2( cos_theta, -sin_theta, sin_theta, cos_theta ) / shadowMapResolution;
    for( int x = -SHADOW_SAMPLES ; x <= SHADOW_SAMPLES ; x++ ) {
        for( int y = -SHADOW_SAMPLES ; y <= SHADOW_SAMPLES ; y++ ){
            vec2 offset = rotation * vec2( x, y );
            vec3 current_sample_coordinate = vec3( sample_coords.xy + offset, sample_coords.z );
            shadow_accumulated += transparent_shadow( current_sample_coordinate );
        }
    }
    shadow_accumulated /= total_samples;
    return shadow_accumulated;
}

#endif