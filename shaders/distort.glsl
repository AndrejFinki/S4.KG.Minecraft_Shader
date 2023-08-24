#ifndef DISTORT_H
#define DISTORT_H

vec2
distort_position( in vec2 position )
{
    float center_distance = length( position );
    float distortion_factor = mix( 1.0, center_distance, 0.9 );
    return position / distortion_factor;
}

#endif