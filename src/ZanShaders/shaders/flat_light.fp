//Flat lighting shader (Zandronum).

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
	
	float lightLevel = 0.4 + 0.6 * clamp(dot(l,n), 0.0, 1.0);
	
	return texel * vec4(color.rgb * lightLevel, color.a);
}

//Only to supress errors in Zandronum, in practice there's no difference.
#else

vec4 Process(vec4 color)
{
	vec4 texel = getTexel(gl_TexCoord[0].st);
	
	return texel * color;
}

#endif