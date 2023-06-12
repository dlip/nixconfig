// Lightning
// By: Brandon Fogerty
// bfogerty at gmail dot com 
// xdpixel.com


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float Hash( vec2 p)
{
     vec3 p2 = vec3(p.xy,2.0);
    return fract(sin(dot(p2,vec3(27.1,20.7, 2.4)))*0.5453123);
}

float noise(in vec2 p)
{
    vec2 i = floor(p);
     vec2 f = fract(p);
     f *= f * (3.0-2.0*f);
    return mix(mix(Hash(i + vec2(0.,0.)), Hash(i + vec2(1.,0.)),f.x),
               mix(Hash(i + vec2(0.,1.)), Hash(i + vec2(1.,1.)),f.x),
               f.y);
}

float fbm(vec2 p)
{
     float v = 0.0;
     v += noise(p*1.0) * .5;
     v += noise(p*2.)  * .25;
     v += noise(p*4.)  * .15;
     return v;
}

void main( void ) 
{

	vec2 uv = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;

	vec2 center = vec2(0.0, 0.0);
	float angle = time * 10.0;
	
	//uv.x = cos(angle) * (uv.x - center.x) - sin(angle) * (uv.y - center.y) + center.x;
	//uv.y = sin(angle) * (uv.x - center.y) + cos(angle) * (uv.y - center.y) + center.y;
	
	vec3 finalColor = vec3( 0.0 );
	for( int i=0; i < 3; ++i )
	{
		float t = abs( 1.4 / (sin(uv.y + fbm( uv + time * 0.4 )) * 100.0) );
		
		finalColor +=  t * vec3( 2.9, 1.5, .25 );
		finalColor = vec3(t);
	}
	
	gl_FragColor = vec4( finalColor, 1.0 );

}
