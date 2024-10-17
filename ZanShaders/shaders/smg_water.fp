//Super Mario Galaxy-esque water shader (Zandronum, opaque).
//Written by TDRR.
uniform float timer;

vec4 Process(vec4 color)
{
	float timer2 = timer * 0.05;
	
	vec2 uv = gl_TexCoord[0].st;
	
	vec2 uv1 = uv + (timer2*0.5);
	vec2 uv2 = vec2(uv.x - timer2, uv.y + (timer2*0.6));
	
	vec4 texel1 = getTexel(uv1);
	
	vec4 texel = texel1 + getTexel(uv2);
	
	if(texel.r > 0.85) {return vec4(1.0, 1.0, 1.0, 1.0);}
	else if(texel.r > 0.7) {texel = vec4(0.4, 0.9, 1.0, 1.0);}
	else if(texel.r > 0.6) {texel = vec4(0.15, 0.75, 0.8, 1.0);}
	else {texel = vec4(0.05, 0.65, 0.7, 1.0);}
	
	return texel * color;
}