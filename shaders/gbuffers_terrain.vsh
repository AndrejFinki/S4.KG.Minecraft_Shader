#version 120
#define TWO_PI 6.28318530718

varying vec2 TexCoords;
varying vec2 LightmapCoords;
varying vec3 Normal;
varying vec4 Color;


attribute vec4 mc_Entity;
uniform float frameTimeCounter;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform vec3 cameraPosition;

void
main()
{
    gl_Position = ftransform();
    TexCoords = gl_MultiTexCoord0.st;
    LightmapCoords = mat2( gl_TextureMatrix[1] ) * gl_MultiTexCoord1.st;
    LightmapCoords = ( LightmapCoords * 33.05 / 32.0 ) - ( 1.05 / 32.0 );
    Normal = gl_NormalMatrix * gl_Normal;
    Color = gl_Color;
    if(mc_Entity.x == 10031.0){
            
            vec4 pos = gl_ModelViewMatrix * gl_Vertex;

            vec4 viewPos = gbufferModelViewInverse * pos;

            vec3 worldpos = viewPos.xyz + cameraPosition;

            float displacement = 0.0;
	
    
            float fy = fract(worldpos.y + 0.001);

            if (fy > 0.1) {

                    
                    float amp2 = 0.05;
                    
                    float phase2 = (frameTimeCounter*0.6 + worldpos.x / 11.0 + worldpos.z /  5.0);
                    
                    float angle2 = TWO_PI * phase2;

                    float wave = amp2 * sin(angle2);

                    displacement = clamp(wave, -fy, 1.0-fy);
                    viewPos.x += displacement;
                    viewPos.z += displacement*0.2;
                    

            }

            viewPos = gbufferModelView * viewPos; 
            gl_Position = gl_ProjectionMatrix * viewPos;
    }
}