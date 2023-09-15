#ifndef WAVY_TERRAIN_H
#define WAVY_TERRAIN_H

#include "constants.glsl"

#ifndef MC_ENTITY
#define MC_ENTITY
attribute vec4 mc_Entity;
#endif
attribute vec4 mc_midTexCoord;

vec3
movement_vector_sin( const float d0, const float d1, const float d2, const float dx, const float dy, const float dz, const vec3 world_pos )
{
    vec3 movement = vec3( 0.0 );
    float tm = 2 * PI * frameTimeCounter * 0.5;
    float mag = sin( tm + world_pos.x * 0.4 + world_pos.y * 0.6 + world_pos.z * 0.3 ) * 0.2 + 0.0381;
    float dev0 = sin( tm * d0 );
    float dev1 = sin( tm * d1 );
    float dev2 = sin( tm * d2 );
    movement.x = sin( tm * dx + dev0 + dev1 - world_pos.x + world_pos.z + world_pos.y ) * mag;
    movement.y = sin( tm * dy + dev2 + dev0 + world_pos.x + world_pos.z - world_pos.y ) * mag;
    movement.z = sin( tm * dz + dev1 + dev2 + world_pos.x - world_pos.z + world_pos.y ) * mag;
    return movement;
}

vec3
movement_vector_cos( const float d0, const float d1, const float d2, const float dx, const float dy, const float dz, const vec3 world_pos )
{
    vec3 movement = vec3( 0.0 );
    float tm = 2 * PI * frameTimeCounter * 0.5;
    float mag = sin( tm + world_pos.x * 0.4 + world_pos.y * 0.6 + world_pos.z * 0.3 ) * 0.2 + 0.0381;
    float dev0 = cos( tm * d0 );
    float dev1 = cos( tm * d1 );
    float dev2 = cos( tm * d2 );
    movement.x = sin( tm * dx + dev0 + dev1 - world_pos.x + world_pos.z + world_pos.y ) * mag;
    movement.y = sin( tm * dy + dev2 + dev0 + world_pos.x + world_pos.z - world_pos.y ) * mag;
    movement.z = sin( tm * dz + dev1 + dev2 + world_pos.x - world_pos.z + world_pos.y ) * mag;
    return movement;
}

void
wave_glsl()
{
    vec4 relative_pos = gl_ModelViewMatrix * gl_Vertex;
    vec4 view_pos = gbufferModelViewInverse * relative_pos;
    vec3 world_pos = view_pos.xyz + cameraPosition;
    const float amp1 = 0.15;
    const float amp2 = 0.2;
    vec3 movement1 = movement_vector_sin( 0.0051, 0.0078, 0.0012, 0.3, 0.5, 0.9, world_pos );
    vec3 movement2 = movement_vector_cos( 0.0083, 0.0151, 0.0057, 0.7, 0.6, 0.4, world_pos );
    view_pos.xyz += amp1 * movement1 + amp2 * movement2;
    view_pos = gbufferModelView * view_pos; 
    gl_Position = gl_ProjectionMatrix * view_pos;
}

bool
wave_check()
{
    bool is_top_value = gl_MultiTexCoord0.t < mc_midTexCoord.t;
    bool is_grass = mc_Entity.x == 10031.0;
    bool is_tall_grass = mc_Entity.x == 10075.0 && is_top_value || mc_Entity.x == 10076.0;
    bool is_leaves = mc_Entity.x == 10081.0;
    return is_grass || is_tall_grass || is_leaves;
}

#endif