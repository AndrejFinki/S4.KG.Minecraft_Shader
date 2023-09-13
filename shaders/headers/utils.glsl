#ifndef UTILS_H
#define UTILS_H

uint rngState = 185730u * uint( frameCounter ) + uint( gl_FragCoord.x + gl_FragCoord.y * aspectRatio );

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

void
pcg( inout uint seed )
{
    uint state = seed * 747796405u + 2891336453u;
    uint word = ( ( state >> ( ( state >> 28u ) + 4u ) ) ^ state ) * 277803737u;
    seed = ( word >> 22u ) ^ word;
}

float
rand_float()
{
    pcg( rngState );
    return float( rngState ) / float( 0xffffffffu );
}

mat2
rotate_matrix( float rad )
{
    return mat2( vec2( cos( rad ), -sin( rad ) ), vec2( sin( rad ), cos( rad ) ) );
}

#endif