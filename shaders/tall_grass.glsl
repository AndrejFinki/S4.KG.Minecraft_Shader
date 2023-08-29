#ifndef TALL_GRASS_H
#define TALL_GRASS_H
#include "constants.glsl"

void
tall_grass_glsl()
{
    vec4 relative_pos = gl_ModelViewMatrix * gl_Vertex;
    vec4 view_pos = gbufferModelViewInverse * relative_pos;
    vec3 world_pos = view_pos.xyz + cameraPosition;
    float displacement = 0.0;
    float fy = fract( world_pos.y + 0.001 );
    if( fy > 0.1 ) {
        float amp2 = 0.05;
        float phase2 = ( frameTimeCounter * 0.6 + world_pos.x / 11.0 + world_pos.z / 5.0 );
        float angle2 = 2 * PI * phase2;
        float wave = amp2 * sin( angle2 );
        displacement = clamp( wave, -fy, 1.0 - fy );
        view_pos.x += displacement;
        view_pos.z += displacement * 0.2;
    }
    view_pos = gbufferModelView * view_pos; 
    gl_Position = gl_ProjectionMatrix * view_pos;
}

#endif