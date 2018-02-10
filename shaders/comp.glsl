#version 430
precision highp float;
precision highp int;

uniform int roll;

// What this shader will write to
layout(rgba32f, binding = 0) uniform image2D destTex;

layout(std140, binding = 2) uniform camData
{
	vec4 cPos;
	mat4 view;
	mat4 proj;
};

mat4 invViewProjMat; 

vec4 start00; 
vec4 start10; 

vec4 start01; 
vec4 start11; 

vec4 end00; 
vec4 end10; 

vec4 end01; 
vec4 end11; 

struct object{
	//MATERIAL
	// TODO: Refraction, texture
	vec4 color;
	vec4 reflectivity;
	vec4 specularity;

	//GENERAL
	int type;
	mat4 trans;
} objects[3];

struct intersection{
	vec3 norm;
	vec3 coord;
};

layout (local_size_x = 1, local_size_y = 1) in;

bool approx(vec3 val, vec3 compare, vec3 maxDiff){
	return all(lessThan( abs(val - compare) , maxDiff));
}

vec3 transformPoint(vec3 vec, mat4 trans){

	vec4 vecTrans = vec4(vec.x, vec.y, vec.z, 1);
	return ((trans) * vecTrans).xyz;
}

vec3 transformRay(vec3 ray, mat4 trans){

	vec4 rayTrans = vec4(ray.x, ray.y, ray.z, 0);
	return (inverse(transpose((trans))) * rayTrans).xyz;
}

intersection intersectPlane(vec3 D, vec3 E){
	vec3 ray = normalize(D - E); // Ray's direction

	vec3 N = (vec3(0,1,0));
	vec3 Q = (vec3(0,0,0));

	float d = -dot(Q, N);
	float v = dot(ray, N);
	float t = (-(dot(E, N) + d) / v);
	intersection intersec = intersection(D,D);

	if(t>0){
		intersec.coord =  E + t*D;
		intersec.norm = normalize(N);
	}
	return intersec;
}

intersection intersectSphere(vec3 D, vec3 E){
	vec3 ray = normalize(D-E);
	float a = dot(ray,ray);
	float b = 2*dot(E,ray);
	float c = dot(E,E)-1;
	intersection intersec = intersection(D,D);

	float t1 =  (-b + sqrt(b*b -4*a*c))/2*a;
	float t2 =  (-b - sqrt(b*b -4*a*c))/2*a;

	if(b*b -4*a*c < 0.0){
		return intersec;
	}
	else if(b*b -4*a*c == 0.0){
		intersec.coord =  (t1 > t2) ? E + t2*D : E + t1*D;
		intersec.norm  = normalize(intersec.coord);
	}
	else {
		intersec.coord =  E + t2*D;
		intersec.norm  = normalize(intersec.coord);
	}
	return intersec;

}

intersection intersectObject(vec3 D, vec3 E, int type){

	switch(type){
		case 1:
			return intersectSphere(D, E);
		case 2:
			return intersectPlane(D, E);

	}
}

void main() {


	// CALCULATION OF RAY TO BE EVAULUATED
	invViewProjMat = inverse(proj * view);

	/* Calculate the positions of the bounds of this NDC space in
	world space */
	start00 =  invViewProjMat * vec4(-1.0, 1.0, -1.0, 1.0);
	start00.xyz /=  start00.w;

	start01 =  invViewProjMat * vec4(-1.0, 1.0, -1.0, 1.0);
	start01.xyz /=  start01.w;

	start10 =  invViewProjMat * vec4(1.0, -1.0, -1.0, 1.0);
	start10.xyz /=  start10.w;

	start11 = invViewProjMat * vec4(1.0, 1.0, -1.0, 1.0);
	start11.xyz /= start11.w;

	end00 =  invViewProjMat * vec4(-1.0, -1.0, 1.0, 1.0);
	end00.xyz /= end00.w;

	end01 =  invViewProjMat * vec4(-1.0, 1.0, 1.0, 1.0);
	end01.xyz /=  end01.w;

	end10 =  invViewProjMat * vec4(1.0, -1.0, 1.0, 1.0);
	end10.xyz /=  end10.w;

	end11 = invViewProjMat * vec4(1.0, 1.0, 1.0, 1.0);
	end11.xyz /=  end11.w;

	/* Calculate this local work group's ray by interpolating its x y position
	with the frustrum's bounds */
	ivec2 texPos = ivec2(gl_GlobalInvocationID.xy);
	vec2 pos =  texPos / vec2(gl_NumWorkGroups.xy);

	vec3 start = mix(mix(start00.xyz, start01.xyz, pos.y), mix(start10.xyz, start11.xyz, pos.y), pos.x).xyz;
	vec3 end = mix(mix(end00.xyz, end01.xyz, pos.y), mix(end10.xyz, end11.xyz, pos.y), pos.x).xyz;

	end = start + 1000*normalize(end - start);

	mat4 trans1 = (transpose(mat4(1.0, 0.0, 0.0, 1.0, 
										  0.0, 2.0, 0.0, 1.0, 
										  0.0, 0.0, 1.0,  3.0,  
										  0.0, 0.0, 0.0,  1.0)));

	mat4 trans2 = (transpose(mat4(2.0, 0.0, 0.0, 0.0, 
										  0.0, 1.0, 0.0, -1.0, 
										  0.0, 0.0, 1.0,  1.0,  
										  0.0, 0.0, 0.0,  1.0)));

	mat4 trans3 = (transpose(mat4(1.0, 0.0, 0.0, 0.0, 
										  0.0, 1.0, 0.0, -1.0, 
										  0.0, 0.0, 1.0,  0.0,  
										  0.0, 0.0, 0.0,  1.0)));
	objects[0].type =1;
	objects[0].trans =trans1;
	objects[0].color = vec4(1,0,1,1);

	objects[1].type =1;
	objects[1].trans =trans2;
	objects[1].color = vec4(0,0,1,1);

	objects[2].type =2;
	objects[2].trans =trans3;
	objects[2].color = vec4(1,0,1,1);

	// Color sky
	imageStore(destTex, texPos, vec4(.22,.67,0.9,1));

	int currReflect = 0;
	int maxReflect = 4;
	bool isDone = false;
	float closestDist = 100000;
	object closestObj;
	closestObj.type = -1;
	intersection  closestIntersect;

	vec3 ambientMask = vec3(.2, .2, .2);
	vec3 lightRay = normalize(vec3(1,1,0));

	while(currReflect < maxReflect && !isDone){

		//Test every object in scene, if intersect with current ray
		for(int i=0; i< objects.length; i++){

			// Transform vectors in object's space to prep for testing
			vec3 E = transformPoint(start, inverse(objects[i].trans));
			vec3 D = transformPoint(end, inverse(objects[i].trans));

			intersection intersec = intersectObject(D, E, objects[i].type);

			vec3 intersectCoord = intersec.coord;

			if(intersectCoord != D && distance(start, transformPoint(intersectCoord, objects[i].trans))<closestDist){
				closestDist = distance(start, transformPoint(intersectCoord, objects[i].trans));
				closestObj = objects[i];
				closestIntersect = intersec;

				vec4 illum;   
				illum.xyz = ambientMask + 1 * (dot(lightRay, transformRay(intersec.norm, objects[i].trans)) );
				illum.w  = 1;
				illum = objects[i].color * illum;

				imageStore(destTex, texPos, illum);
			}

			/*
			if( i < 1 && approx(end, transformPoint(intersectCoord, objects[i].trans), ambientMask.xyz)){
				imageStore(destTex, texPos, objects[i].color/2);
			}
			*/

		}
		isDone=true;
	}

}



