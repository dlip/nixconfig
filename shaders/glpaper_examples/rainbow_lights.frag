// v!
// 
#extension GL_OES_standard_derivatives : enable

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
#define r resolution
#define t time*2.0
void main( void ) {
	
	vec2 p= gl_FragCoord.xy/resolution.xy*2.-1.0;
	
	vec3 n = normalize(vec3(p,p.y));
	 
	vec3 c=vec3(-cos(t)*2.*n.y, 3.*sin(t+(cos(4.*p.y))),  1.-cos(t+sin(4.*n.z)));
	 
	  c.y +=  n.z-    length(2.5*n.y*n.z)*tan(sin(50.0*n.z+n.x));
	  c.x -= -c.y-length(2.5*n.y*n.z)*tan(sin(50.0*n.z+n.x));
	  c.z *= -c.x*length(2.5*n.y*n.z)*tan(sin(50.0*n.z+n.x));
	 
	
	gl_FragColor=vec4(c*0.8, 1.0);
	
}
