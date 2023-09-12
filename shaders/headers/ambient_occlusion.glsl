#ifndef AMBIENT_OCCLUSION_H
#define AMBIENT_OCCLUSION_H

#include "constants.glsl"

float
get_linear_depth( float depth )
{
    return ( 2.0 * near ) / ( far + near - depth * ( far - near ) );
}

vec2
offset_dist( float x, int s )
{
    float n = fract( x * 1.414 ) * PI;
    return ( vec2( cos( n ), sin( n ) ) * x / s ) *( vec2( cos( n ), sin( n ) ) * x / s );
}

float ambient_occlusion()
{
    float z0 = texture2D( depthtex0, tex_coords, 0 ).r;
    float linear_z0 = get_linear_depth( z0 );
    float dither = texture2D( noisetex, tex_coords * vec2( viewWidth, viewHeight ) / 128.0 ).b;
    float dither_animate = 1.61803398875 * mod( float( frameCounter ), 3600.0 );
    dither = fract( dither + dither_animate );
    
    if( z0 < 0.56 ) return 1.0;
    
    float ao = 0.0;
    int samples = 12;
    float scm = 0.6;
    float sample_depth = 0.0, angle = 0.0, dist = 0.0;
    float fov_scale = gbufferProjection[1][1];
    float dist_scale = max( ( far - near ) * linear_z0 + near, 3.0 );
    vec2 scale = vec2( scm / aspectRatio, scm ) * fov_scale / dist_scale;
    
    for( int i = 1 ; i <= samples ; i++ ) {
        vec2 offset = offset_dist( i + dither, samples ) * scale;
        if( mod( i, 2 ) == 0 ) offset.y = - offset.y;
        vec2 coord_1 = tex_coords + offset;
        vec2 coord_2 = tex_coords - offset;
        sample_depth = get_linear_depth( texture2D( depthtex0, coord_1 ).r );
        float ao_sample = ( far - near ) * ( linear_z0 - sample_depth ) * 2.0;
        angle = clamp( 0.5 - ao_sample, 0.0, 1.0 );
        dist = clamp( 0.5 * ao_sample - 1.0, 0.0, 1.0 );
        sample_depth = get_linear_depth( texture2D( depthtex0, coord_2 ).r );
        ao_sample = ( far - near ) * ( linear_z0 - sample_depth ) * 2.0;
        angle += clamp( 0.5 - ao_sample, 0.0, 1.0 );
        dist += clamp( 0.5 * ao_sample - 1.0, 0.0, 1.0 );
        ao += clamp( angle + dist, 0.0, 1.0 );
    }

    ao /= samples;
    return pow( ao, SSAO_IM );
}

#endif