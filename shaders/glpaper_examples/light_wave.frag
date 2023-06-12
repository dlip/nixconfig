#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

uniform vec2 resolution;

#define PI 30


void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xy ) -0.5;
	
	float sx = 0.3 * (p.x*p.x*5.0 - 0.7) * cos( 45.0 * p.x - 15. * pow(time*0.03, 0.7)*9.);
	
	float dy = 9./ ( 423. * abs(p.y - sx));
	
	dy += 11./ (200. * length(p - vec2(p.x, 0.0
					 )));
	
	gl_FragColor = vec4( (p.x + 0.2
			     ) * dy, 0.3 * dy, dy, 6.1 );

}
