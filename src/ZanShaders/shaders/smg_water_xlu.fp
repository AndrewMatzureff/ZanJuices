//Super Mario Galaxy-esque water shader (Zandronum, translucent).
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
	else if(texel.r > 0.75) {texel = vec4(1.0, 1.0, 1.0, 0.6);}
	else if(texel.r > 0.65) {texel = vec4(1.0, 1.0, 1.0, 0.5);}
	else {texel = vec4(1.0, 1.0, 1.0, 0.0);}
	
	return texel * color;
}