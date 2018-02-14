#version 430

/* TODO:
quadratic function DRYness
*/

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

// border rays used in interpolation to current ray
vec4 start00; 
vec4 start10; 

vec4 start01; 
vec4 start11; 

vec4 end00; 
vec4 end10; 

vec4 end01; 
vec4 end11; 

float clipDist = 400; // Max distance

struct object{
	//MATERIAL
	// TODO: Refraction, texture
	vec4 color;
	float reflectivity;
	float specularity;

	//GENERAL
	int type;
	mat4 trans;
} objects[5];

struct light{
	bool directional;
	vec3 position;

} lights[1];

struct intersection{
	vec3 norm;
	vec3 coord;
	float distance;
};

layout (local_size_x = 8, local_size_y = 8) in;

// Transforms a point in space given matrix
vec3 transformPoint(vec3 vec, mat4 trans){
	vec4 vecTrans = vec4(vec.x, vec.y, vec.z, 1);
	return ((trans) * vecTrans).xyz;
}

// Transforms a "ray" in space given matrix (no translation applied)
vec3 transformRay(vec3 ray, mat4 trans){
	vec4 rayTrans = vec4(ray.x, ray.y, ray.z, 0);
	return (transpose(inverse((trans))) * rayTrans).xyz;
}


intersection intersectPlane(vec3 D, vec3 E){
	vec3 ray = normalize(D - E); // Ray's direction

	vec3 N = normalize(vec3(0,1,0));
	vec3 Q = (vec3(0,0,0));

	// init default values, if still same, no intersection
	intersection intersec;
	intersec.distance = clipDist;
	intersec.coord = D;

	// Calc intersection point along ray
	float t = dot(N, Q-E)/dot(N,D);

	if(t>0.001 ){
		intersec.coord =  E + t*D;
		intersec.norm = N;
		intersec.distance = t;
	}
	return intersec;
}

intersection intersectSphere(vec3 D, vec3 E){

	vec3 ray = normalize(D-E);

	intersection intersec;
	intersec.distance = clipDist;
	intersec.coord = D;

    float a = dot(ray, ray);
    float b = 2.0 * dot(ray, E);
    float c = dot(E, E) - 1;

	float discriminant = (b*b) - 4.0*a*c;

    if (discriminant > 0.0){ // negative discriminant means no real intersection

		float t = (-b - sqrt(discriminant))/(2.0*a);

		if(t>0.001){
			intersec.coord =  E + t*ray;
			intersec.norm  = normalize(intersec.coord);
			intersec.distance = t;
		}
	}
	return intersec;

}

intersection intersectCylinder(vec3 D, vec3 E){
	intersection intersec;
	intersec.distance = clipDist;
	intersec.coord = D;

	vec3 ray = normalize(D-E);

	float a = dot(ray.xy, ray.xy);
	float b = 2*dot(E.xy, ray.xy);
	float c = dot(E.xy, E.xy) -1;

	float discriminant = b*b - 4.0*a*c;

    if (discriminant > 0.0) {

		float t = (-b - sqrt(discriminant))/(2.0*a);

		if(t>0.001){
			vec3 line = (E + t*ray);
			if( line.z <= 1 &&  line.z >= -1 ){
				intersec.coord =  E + t*ray;
				intersec.norm  = normalize(intersec.coord);
				intersec.distance = t;
			}
		}
	}
	return intersec;

}

intersection intersectCone(vec3 D, vec3 E){
	intersection intersec;
	intersec.distance = clipDist;
	intersec.coord = D;

	vec3 ray = normalize(D-E);

	float a = dot(ray.xy, ray.xy) - ray.z*ray.z;
	float b = 2*dot(E.xy, ray.xy) - 2*E.z*ray.z;
	float c = dot(E.xy, E.xy) - E.z*E.z;

	float discriminant = b*b - 4.0*a*c;

    if (discriminant > 0.0) {
		float t = (-b - sqrt(discriminant))/(2.0*a);

		vec3 line = (E + t*ray);
		if(t>0 && line.z >0 && line.z < 1){
			intersec.coord =  E + t*ray;
			intersec.norm  = normalize(intersec.coord);
			intersec.distance = t;
		}
	}
	return intersec;

}

intersection intersectObject(vec3 D, vec3 E, int type){

	switch(type){
		case 1:
			return intersectSphere(D, E);
		case 2:
			return intersectPlane(D, E);
		case 3:
			return intersectCylinder(D, E);
		case 4:
			return intersectCone(D, E);
	}
}

intersection nearestPoint(vec3 end, vec3 start, inout object closestObj){

	float closestDist = 1000000;
	closestObj.type = -1;
	intersection  closestIntersect;

	for(int i=0; i< objects.length; i++){

		// Transform vectors in object's space to prep for testing
		vec3 E = transformPoint(start, inverse(objects[i].trans));
		vec3 D = transformPoint(end, inverse(objects[i].trans));

		intersection intersec = intersectObject(D, E, objects[i].type);

		if(intersec.coord != D ){ // If an intersection has been made

			// Get object data, convert back to world coords
			vec3 objIntersectCoord = transformPoint(intersec.coord, objects[i].trans);
			float objIntersectDist = distance(start, objIntersectCoord);

			if(objIntersectDist < closestDist && objIntersectDist > .005){
				closestDist = objIntersectDist;
				closestObj = objects[i];
				closestIntersect = intersec;
			}
		}
	}
	return closestIntersect;
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

	end = start + clipDist*normalize(end - start);

	mat4 trans1 = (transpose(mat4(1.0, 0.0, 0.0, 2.0, 
										  0.0, 1.0, 0.0, 0.5, 
										  0.0, 0.0, 1.0,  0.0,  
										  0.0, 0.0, 0.0,  1.0)));

	mat4 trans2 = (transpose(mat4(1.0, 0.0, 0.0, -2.0, 
										  0.0, roll, 0.0, 0.5, 
										  0.0, 0.0, 1.0,  0.0,  
										  0.0, 0.0, 0.0,  1.0)));

	mat4 trans3 = (transpose(mat4(1.0, 0.0, 0.0, 0.0, 
										  0.0, 1.0, 0.0, -1.0, 
										  0.0, 0.0, 1.0,  0.0,  
										  0.0, 0.0, 0.0,  1.0)));

	mat4 trans4 = (transpose(mat4(1.0, 0.0, 0.0, 0.0, 
										  0.0, 1.0, 0.0, 0.5, 
										  0.0, 0.0, 1.0,  2.0,  
										  0.0, 0.0, 0.0,  1.0)));

	mat4 trans5 = (transpose(mat4(1.0, 0.0, 0.0, 0.0, 
										  0.0, 1.0, 0.0, 0.5, 
										  0.0, 0.0, 1.0,  -2.0,  
										  0.0, 0.0, 0.0,  1.0)));

	objects[0].type =1;
	objects[0].trans =trans1;
	objects[0].color = vec4(0,0,0,1);
	objects[0].reflectivity = 1;
	objects[0].specularity = 1;

	objects[1].type =1;
	objects[1].trans =trans2;
	objects[1].color = vec4(0,0,1,1);
	objects[1].reflectivity = 1;
	objects[1].specularity = 0;

	objects[2].type =2;
	objects[2].trans =trans3;
	objects[2].color = vec4(1,1,1,1);
	objects[2].reflectivity = 1;
	objects[2].specularity = 1;

	objects[3].type =1;
	objects[3].trans =trans4;
	objects[3].color = vec4(0,0,1,1);
	objects[3].reflectivity = 1;
	objects[3].specularity = 1;

	objects[4].type =1;
	objects[4].trans =trans5;
	objects[4].color = vec4(0,0,1,1);
	objects[4].reflectivity = 1;
	objects[4].specularity = 0;

	// Color sky
	imageStore(destTex, texPos, vec4(.22,.67,0.9,1));

	int currReflect = 0;
	int maxReflect = 16;

	vec3 ambientMask = vec3(.15, .15, .15);

	vec3 lightRay=vec3(0,1,0);
	lights[0].directional= true;
	lights[0].position = lightRay;

	vec4 accumColor =vec4(0,0,0,1);

	object closestObj;
	closestObj.type = -1;
	intersection  closestIntersect;

	vec3 currEnd = end;
	vec3 currStart = start;

	bool isDone = false;

	while(currReflect < maxReflect && !isDone){

		closestIntersect = nearestPoint(currEnd, currStart, closestObj);

		vec4 illum;   
		illum.w  = 1;

		if(closestObj.type != -1){

			// Test if under shadow
			object closestObjShadow;
			intersection  closestIntersectShadow;

			vec3 E = transformPoint(closestIntersect.coord, (closestObj.trans));

			if(lights[0].directional)
				lightRay = normalize(lights[0].position - E);
			else
				lightRay = normalize(lights[0].position);

			vec3 D = E+ clipDist*lightRay;

			closestIntersectShadow = nearestPoint(D, E, closestObjShadow);

			// Variables for light calculation
			vec3 N = transformRay(closestIntersect.norm, closestObj.trans); 
			vec3 H =((-1*lightRay + normalize(E - currStart)))/length((-1*lightRay + normalize(E - currStart)));

			float spec; // shininess, specularity

			if(closestObjShadow.type == -1 ){
				illum.xyz = ambientMask + ((1 * (dot(lightRay, N))+0 ));
				spec = pow((1-dot(N, H))*.5, 64)*closestObj.specularity;
			}else{
				illum.xyz = ambientMask;
				spec = 0;
			}

			float attent = (lights[0].directional) ? (lights[0].position - E).length:1; // Light's decreasing brightness relative to distance
			illum = ((closestObj.color * illum ) + spec)/attent*1;

			if(closestObj.reflectivity >0){
				currEnd  = E + clipDist*(normalize(E - currStart) 
					-2*(dot(normalize(E  - currStart), closestIntersect.norm) * closestIntersect.norm)); // Calc reflect vector

				currStart =  E;
			}
		}
		else{
			illum = vec4(.22,.67,0.9,1);
			isDone = true;
		}

		accumColor += (currReflect < 1) ? illum : illum*.3/currReflect;
		currReflect++;
	}
	imageStore(destTex, texPos, accumColor);
}



