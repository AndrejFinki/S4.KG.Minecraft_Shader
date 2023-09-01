#ifndef UTILS_H
#define UTILS_H

float
rand( vec2 co )
{
    return fract( sin( dot( co, vec2( 12.9898, 78.233 ) ) ) * 43758.5453 );
}

float
lerp( float a, float b, float f )
{
    return a + f * ( b - a );
}  

#endif