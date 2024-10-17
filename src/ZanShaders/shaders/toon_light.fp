//Toon lighting shader (Zandronum).

//Original code by Cherno, dpJudas and Graf Zahl.

#ifdef DOOMLIGHTFACTOR

vec3 getSurfaceNormal()
{
    vec3 u = dFdx(pixelpos.xyz);
    vec3 v = dFdy(pixelpos.xyz);
    vec3 normal = cross(u, v);
    return normalize(normal);
}

vec4 Process(vec4 color)
{
	vec4 texel = getTexel(gl_TexCoord[0].st);
	
	vec3 lightDir = vec3(1.0, -1.0, 0.0);
	
	vec3 l = normalize(lightDir);
	vec3 n = getSurfaceNormal();
	
	float lightLevel = clamp(dot(l,n), 0.0, 1.0);
	
	if(lightLevel < 0.15) {return texel * (color*0.75);}
	return texel * color;
}

//Only to supress errors in Zandronum, in practice there's no difference.
#else

vec4 Process(vec4 color)
{
	vec4 texel = getTexel(gl_TexCoord[0].st);
	
	return texel * color;
}

#endif