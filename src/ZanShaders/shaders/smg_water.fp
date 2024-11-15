//Super Mario Galaxy-esque water shader (Zandronum, opaque).
//Originally written by TDRR and then modified by Andrew Matzureff.
uniform float timer;

// Cubic Polynomial Visualization: https://www.desmos.com/calculator/fs4q2r1o8t.
// Cubic Polynomial Coefficients: https://quickmath.com/webMathematica3/quickmath/equations/solve/advanced.jsp#c=solve_solveequationsadvanced&v1=0.05%253Da0%255E3%2Bb0%255E2%2Bc0%2Bd%250A0.15%253Da0.6%255E3%2Bb0.6%255E2%2Bc0.6%2Bd%250A0.4%253Da0.7%255E3%2Bb0.7%255E2%2Bc0.7%2Bd%250A1%253Da0.85%255E3%2Bb0.85%255E2%2Bc0.85%2Bd%250A%250A0.65%253De0%255E3%2Bf0%255E2%2Bg0%2Bh%250A0.75%253De0.6%255E3%2Bf0.6%255E2%2Bg0.6%2Bh%250A0.9%253De0.7%255E3%2Bf0.7%255E2%2Bg0.7%2Bh%250A1%253De0.85%255E3%2Bf0.85%255E2%2Bg0.85%2Bh%250A%250A0.7%253Di0%255E3%2Bj0%255E2%2Bk0%2Bl%250A0.8%253Di0.6%255E3%2Bj0.6%255E2%2Bk0.6%2Bl%250A1%253Di0.7%255E3%2Bj0.7%255E2%2Bk0.7%2Bl%250A1%253Di0.85%255E3%2Bj0.85%255E2%2Bk0.85%2Bl&v2=a%250Ab%250Ac%250Ad%250Ae%250Af%250Ag%250Ah%250Ai%250Aj%250Ak%250Al.
const vec4 coeRed = vec4(
	160.0	/ 51,
	-38.0	/ 51,
	-263.0	/ 510,
	1.0		/ 20
);

const vec4 coeGreen = vec4(
	-2200.0	/ 357,
	1180.0	/ 119,
	-2545.0	/ 714,
	13.0	/ 20
);

const vec4 coeBlue = vec4(
	-4460.0		/ 357,
	6733.0		/ 357,
	-23747.0	/ 3570,
	7.0			/ 10
);
// System of Equations:
// red
// 0.05=a0^3+b0^2+c0+d
// 0.15=a0.6^3+b0.6^2+c0.6+d
// 0.4=a0.7^3+b0.7^2+c0.7+d
// 1=a0.85^3+b0.85^2+c0.85+d

// green
// 0.65=e0^3+f0^2+g0+h
// 0.75=e0.6^3+f0.6^2+g0.6+h
// 0.9=e0.7^3+f0.7^2+g0.7+h
// 1=e0.85^3+f0.85^2+g0.85+h

// blue
// 0.7=i0^3+j0^2+k0+L
// 0.8=i0.6^3+j0.6^2+k0.6+L
// 1=i0.7^3+j0.7^2+k0.7+L
// 1=i0.85^3+j0.85^2+k0.85+L

vec4 Process(vec4 color)
{
	float timer2 = timer * 0.05;
	
	vec2 uv = gl_TexCoord[0].st;
	
	vec2 uv1 = uv + (timer2*0.5);
	vec2 uv2 = vec2(uv.x - timer2, uv.y + (timer2*0.6));
	
	vec4 texel1 = getTexel(uv1);
	
	vec4 texel = texel1 + getTexel(uv2);
	
	// Cubic Polynomial curves per color channel.
	float cr = coeRed[0] * pow(texel.r, 3) + coeRed[1] * pow(texel.r, 2) + coeRed[2] * texel.r + coeRed[3];
	float cg = coeGreen[0] * pow(texel.g, 3) + coeGreen[1] * pow(texel.g, 2) + coeGreen[2] * texel.g + coeGreen[3];
	float cb = coeBlue[0] * pow(texel.b, 3) + coeBlue[1] * pow(texel.b, 2) + coeBlue[2] * texel.b + coeBlue[3];
	
	// Numer of brightness levels per color channel.
	float rsmoothness = 9;
	float gsmoothness = 9;
	float bsmoothness = 9;
	
	// Texel brightness as the parameter (x) of the polynomial function.
// 	float brightness = max(max(texel.r, texel.g), texel.b);
// 	if(brightness > 0.85) {return vec4(1.0, 1.0, 1.0, 1.0);}
// 	else if(brightness > 0.7) {texel = vec4(0.4, 0.9, 1.0, 1.0);}
// 	else if(brightness > 0.6) {texel = vec4(0.15, 0.75, 0.8, 1.0);}
// 	else {texel = vec4(0.05, 0.65, 0.7, 1.0);}
	
	// Scale, round & un-scale to chop the curve up into discrete steps.
	texel = vec4(round(cr * rsmoothness) / rsmoothness, round (cg * gsmoothness) / gsmoothness, round(cb * bsmoothness) / bsmoothness, 1);
	
	// test
	vec4 tint = vec4(0.25,0.5,1,1);// + vec4(sin(timer + length(uv + cos(timer * 0.5) * 2)) * 0.375 + 0.375, sin(timer + length(uv + cos(timer * 0.5) * 2)) * 0.25 + 0.25, 0, 0);
	tint.a = 1;
	
	// 3 full-bright channels -> constant white
	if (texel.r + texel.g + texel.b > 3) { return vec4(1.0, 1.0, 1.0, 1.0); }
	// 3 channels' cummulative brightness totaling to less than half the max brightness of a single channel -> constant dark
	else if (texel.r + texel.g + texel.b < 0.5) { return vec4(0.0125, 0.05, 0.0625, 1.0);}
	// Otherwise, blend texel color with environmental shading and then clamp the components to [0,1].
	else { return clamp(texel * color * tint, vec4(0.0,0.0,0.0,1.0), vec4(1.0,1.0,1.0,1.0)); }
}