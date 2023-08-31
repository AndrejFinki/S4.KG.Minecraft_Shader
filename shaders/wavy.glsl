#ifndef WAVY_H
#define WAVY_H
#include "constants.glsl"

attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

void
wave_glsl()
{
    vec4 relative_pos = gl_ModelViewMatrix * gl_Vertex;
    vec4 view_pos = gbufferModelViewInverse * relative_pos;
    vec3 world_pos = view_pos.xyz + cameraPosition;
    float displacement = 0.0;
    float fy = fract( world_pos.y + 0.001 );
    float tm = 2 * PI * frameTimeCounter * 0.5;
    float amp1 = 0.15;
    float amp2 = 0.2;
    float mag = sin( tm + world_pos.x * 0.4 + world_pos.y * 0.6 + world_pos.z * 0.3 ) * 0.2 + 0.0381;
    float dev0 = sin( tm * 0.0051 );
    float dev1 = sin( tm * 0.0078 );
    float dev2 = sin( tm * 0.0012 );
    vec3 movement1 = vec3( 0.0 );
    movement1.x = sin( tm * 0.3 + dev0 + dev1 - world_pos.x + world_pos.z + world_pos.y ) * mag;
    movement1.z = sin( tm * 0.9 + dev1 + dev2 + world_pos.x - world_pos.z + world_pos.y ) * mag;
    movement1.y = sin( tm * 0.5 + dev2 + dev0 + world_pos.x + world_pos.z - world_pos.y ) * mag;
    vec3 movement2 = vec3( 0.0 );
    dev0 = cos( tm * 0.0083 );
    dev1 = cos( tm * 0.0151 );
    dev2 = cos( tm * 0.0057 );
    movement2.x = sin( tm * 0.7 + dev0 + dev1 - world_pos.x + world_pos.z + world_pos.y ) * mag;
    movement2.z = sin( tm * 0.4 + dev1 + dev2 + world_pos.x - world_pos.z + world_pos.y ) * mag;
    movement2.y = sin( tm * 0.6 + dev2 + dev0 + world_pos.x + world_pos.z - world_pos.y ) * mag;
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