#extension GL_OES_standard_derivatives : enable

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159265;

mat2 rot(float a){
	float c = cos(a),s = sin(a);
	return mat2(c,s,-s,c);
}

mat3 rot3D(float a){
	float c = cos(a),s = sin(a);
	return mat3(c,-s,0.,
		    s,c,0.,
		   0.,0.,1.0);
}

float sphere(vec3 p){
	return length(p)-0.5;
}



float deMengerSponge2(vec3 p, vec3 offset, float scale) {
    vec4 z = vec4(p, 1.0);
    for (int i = 0; i < 10; i++) {
        z = abs(z);
        if (z.x < z.y) z.xy = z.yx;
        if (z.x < z.z) z.xz = z.zx;
        if (z.y < z.z) z.yz = z.zy;
        z *= scale;
        z.xyz -= offset * (scale - 1.0);
        if (z.z < -0.5 * offset.z * (scale - 1.0))
            z.z += offset.z * (scale - 1.0);
    }
    return (length(max(abs(z.xyz) - vec3(1.0, 1.0, 1.0), 0.0))) / z.w;
}



float de(vec3 p) {
	p.xy *= rot(time);
	p.yz *= rot(time);
    return deMengerSponge2(p, vec3(1.0), 3.0);
}

float dist(vec3 p){
	
	
	
	float d = de(p);
	//p.xy = vec2(0.0);
	p.xyz *= rot3D(time);
	p = abs(p);
	
	for(int i = 0; i < 10; i++){
		//p.xy = mod(p.xy,4.0);
		
		p.xzy *= rot3D(0.3);
		p.xyz *= rot3D(0.3);
		p.yz = mod(p.yz,2.0);
		
	}
	
	p.xyz *= rot3D(sin(time));
	d = min(d,sphere(p));
	
	return d; 
}

vec3 getnormal(vec3 p){
	float d = 0.0001;
	return normalize(vec3(
		dist(p+vec3(d,0.,0.))-dist(p+vec3(-d,0.,0.)),
		dist(p+vec3(0.,d,0.))-dist(p+vec3(0.,-d,0.)),
		dist(p+vec3(0.,0.,d))-dist(p+vec3(0.,0.,-d))
		));
}


void main( void ) {

	vec2 p = ( gl_FragCoord.xy *2.0 -resolution ) / min(resolution.x,resolution.y); 

	float angle = 60.0;
	float fov = angle * 0.5 * PI/180.0;
	vec3 cPos = vec3(0.0,0.0,4.0);
	vec3 LightDir = vec3(-0.577,0.577,0.577);
	
	vec3 ray = normalize(vec3(sin(fov)*p.x,sin(fov)*p.y,-cos(fov)));
	
	vec2 d = vec2(float(0.0));
	float rLen = 0.0;
	vec3 rPos = cPos;
	
	for(int i = 0; i <99; i++){
		d.x = dist(rPos);
		d.y = de(rPos);
		rLen +=d.x;
		rPos = rLen*ray+cPos;
	}
	
	if(abs(d.x)<0.001){
		vec3 normal = getnormal(rPos);
		float diff = clamp(dot(normal,LightDir),0.2,1.0);
		gl_FragColor = vec4( vec3(cos(time)*diff*cos(time)+0.5,cos(time)+0.5*diff,sin(time)*diff+0.5),1.0);
		if(abs(d.y)<0.001){
		gl_FragColor = vec4(vec3(diff*ray*cos(time)+0.25),1.0);
		}
	}else{
		gl_FragColor = vec4( vec3(0.0),1.0);
	}

}
