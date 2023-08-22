#version 120

uniform sampler2D lightmap;
uniform sampler2D texture;
uniform vec3 sunPosition;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 Normal;
varying vec3 wpos;
varying vec3 viewDir;



void main() {
	vec4 color = texture2D(texture, texcoord);
	//color.rgb = pow(color.rgb, vec3(1.0/2.2));
	//color *= texture2D(lightmap, lmcoord); 

	//vec3 viewDir = normalize(cameraPosition);

	vec3 reflectDir = reflect(-normalize(viewDir), Normal);

	//float spec = pow(max(dot(normalize(sunPosition),reflectDir), 0.0),32);
	float spec = clamp( dot( reflectDir,normalize(sunPosition) ), 0,1 );

	vec3 finalColor;
	if(spec >= 0.45){
		vec3 specularColor = vec3(0.65f);

		finalColor = color.rgb + pow(spec,1024)*specularColor;
	}else{
		finalColor = color.rgb ;
	}
	

	/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(finalColor,0.85f); //gcolor
}
