#ifndef SHADOW_H
#define SHADOW_H

float
get_shadow( void )
{
    vec3 clip_space = vec3( tex_coords, texture2D( depthtex0, tex_coords ).r ) * 2.0 - 1.0;
    vec4 view_w = gbufferProjectionInverse * vec4( clip_space, 1.0 );
    vec3 view = view_w.xyz / view_w.w;
    vec4 world = gbufferModelViewInverse * vec4( view, 1.0 );
    vec4 shadow_space = shadowProjection * shadowModelView * world;
    vec3 sample_coords = shadow_space.xyz * 0.5 + 0.5;
    return step( sample_coords.z - 0.001, texture2D( shadowtex0, sample_coords.xy ).r );
}

#endif