#ifndef SCHLICK_FRESNEL_H
#define SCHLICK_FRESNEL_H

float
schlick_fresnel( float cosTheta, float F0 )
{
    return F0 + ( 1.0 - F0 ) * pow( 1.0 - cosTheta, 5.0 );
}

#endif