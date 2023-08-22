#version 120
#define TWO_PI 6.28318530718
#define Pi 3.14579

uniform sampler2D lightmap;
uniform sampler2D texture;
uniform vec3 sunPosition;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform float frameTimeCounter;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 Normal;
varying vec3 wpos;
varying vec3 viewDir;
varying vec3 FlatNormal;



void main() {
	vec4 color = texture2D(texture, texcoord);
	//color.rgb = pow(color.rgb, vec3(1.0/2.2));
	//color *= texture2D(lightmap, lmcoord); 

	//vec3 viewDir = normalize(cameraPosition);

	vec3 worldpos = wpos;

	float fy = fract(worldpos.y + 0.001);
    float displacement = 0.0;
	vec3 normal = vec3(0.0);
	if (fy > 0.1) {

            float amp1 = 0.03;
            float amp2 = 0.05;
            float phase1 = (frameTimeCounter*0.75 + worldpos.x /  7.0 + worldpos.z / 13.0);
            float phase2 = (frameTimeCounter*0.6 + worldpos.x / 11.0 + worldpos.z /  5.0);
            float angle1 = TWO_PI * phase1;
            float angle2 = TWO_PI * phase2;

			float wave = amp1 * sin(angle1) + amp2 * sin(angle2);

            vec3 derivative1 = normalize(vec3(1, amp1*cos(angle1), 0));
            vec3 derivative2 = normalize(vec3(0, amp2*cos(angle2), 1));
            
            normal = normalize(cross(derivative1, derivative2));
	}else{
		normal = FlatNormal;
	}

	vec3 reflectDir = reflect(-normalize(viewDir), normal);

	//float spec = pow(max(dot(normalize(sunPosition),reflectDir), 0.0),32);
	float spec = clamp( dot( reflectDir,normalize(sunPosition) ), 0,1 );

	vec3 finalColor;
	if(spec >= 0.05){
		vec3 specularColor = vec3(0.45f);

		finalColor = color.rgb + pow(spec,32)*specularColor;
	}else{
		finalColor = color.rgb ;
	}
	

	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(finalColor,0.85f); //gcolor
}
