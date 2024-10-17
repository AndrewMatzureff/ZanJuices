//Super Mario Galaxy-esque water shader (Zandronum, opaque).
//Written by TDRR.
uniform float timer;

#define STRENGTH 0.1

vec4 Process(vec4 color)
{	
	float timer2 = timer * 0.05;
	
	vec2 uv = gl_TexCoord[0].st;
	
	vec2 uv1 = uv + (timer2*0.5);
	
	float warpmap = getTexel(uv1).a;
	
	vec4 texture = getTexel(uv + (warpmap * STRENGTH));
	
	return vec4(texture.rgb * color.rgb, color.a);
}