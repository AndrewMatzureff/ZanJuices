//Specular mapping with one fake light (Zandronum).
//Written by TDRR, used LZDoom's implementations as a reference.
#ifdef DOOMLIGHTFACTOR

vec3 specularity(vec3 lightPos, vec3 viewDir, vec3 normal, float specmap)
{	
	vec3 lightDir = normalize(lightPos - pixelpos.xyz);  
	
	vec3 reflectDir = reflect(-lightDir, normal);
	
	vec3 spec = vec3(pow(max(dot(viewDir, reflectDir), 0.0), 32));
	return spec * (specmap * 0.3);
}

vec4 Process(vec4 color)
{
	vec4 texel = getTexel(gl_TexCoord[0].st);
	
	//specular
	vec3 viewDir = normalize(camerapos - pixelpos.xyz);
	
	vec3 lightPos = vec3(4000.0) + camerapos; //vec3(0.0, 4000.0, 0.0);
	
	vec3 norm = normalize(cross(dFdx(pixelpos.xyz),dFdy(pixelpos.xyz)));
	
	vec3 spec = specularity(lightPos, viewDir, norm, texel.a);
	
	color.rgb = clamp( (texel.rgb * color.rgb) + spec, 0.0, 1.4);
	
	return vec4(color.rgb, color.a);
}

//Only to supress errors in Zandronum, in practice there's no difference.
#else

vec4 Process(vec4 color)
{
	vec4 texel = getTexel(gl_TexCoord[0].st);
	
	return texel * color;
}

#endif