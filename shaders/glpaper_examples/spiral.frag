/*
	@machine_shaman
*/
#extension GL_OES_standard_derivatives : enable

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 rotate(float a) {
	float c = cos(a);
	float s = sin(a);
	return mat2(c, -s, s, c);
}

void main() {

	vec2 uv = (2. * gl_FragCoord.xy - resolution) / resolution.y;
	vec3 col = vec3(0.);
	
	vec3 ro = vec3(0.0, 0.0, -3.0);
	vec3 rd = vec3(uv, 1.0);
	vec3 p = vec3(0.0);
	float t = 0.;
	
	for (int i = 0; i < 64; i++) {
		p = ro + rd * t;	
		p.xz *= rotate(p.y * 6.28 * 0.5 + time * 0.5);
		vec2 q = vec2(length(p.xy) - 1., p.z);
		float d = length(q) - .1;	
		d = min(d, length(p.xz) - (.3 - .2 * sin(time + p.y * 6.28 * 0.5)));
		t += 0.5 * d;
		col += .15 / (1. + t * t * t * 0.8);
	}
	
	
	
	
	
	gl_FragColor = vec4(col, 1.);


}
