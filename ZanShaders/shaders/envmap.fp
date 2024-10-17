//Original shader by... HAL9000 I believe? Then modified by Striker, and finally
//by TDRR to add Zandronum compatibility.
#ifdef DOOMLIGHTFACTOR

vec4 Process(vec4 color)
{
    vec3 eyedir = normalize(camerapos.xyz - pixelpos.xyz);
    
    vec3 x = dFdx(pixelpos.xyz);
    vec3 y = dFdy(pixelpos.xyz);
    vec3 normal = normalize(cross(x, y));

    vec3 norm = reflect(eyedir, normalize(normal.xyz));
    return getTexel(norm.xz * 0.5) * color;
}

//Only to supress errors in Zandronum, in practice there's no difference.
#else

vec4 Process(vec4 color) {return getTexel(gl_TexCoord[0].st) * color;}

#endif