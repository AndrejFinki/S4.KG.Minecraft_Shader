#ifndef COMPOSITE_UTILS_H
#define COMPOSITE_UTILS_H

#include "constants.glsl"

bool
sky_box_check( vec3 albedo, float depth )
{
    if( depth == 1.0 ) {
        /* DRAWBUFFERS:0 */
        gl_FragData[0] = vec4( albedo, 1.0 );
        return true;
    }
    return false;
}

#endif