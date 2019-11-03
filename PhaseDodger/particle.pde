class particle {

PVector pos;
PVector vel;
float size;
float sizeOverLiftime;
int lifetime; //how long the particle should live for in milliseconds
int age; //how long we've been alive for in milliseconds
boolean killme;
PImage image;

	public particle(PVector pos, PVector vel, float size, float sizeOverLiftime, int lifetime, PImage image) {
		this.pos = pos;
		this.vel = vel;
		this.size = size;
		this.sizeOverLiftime = sizeOverLiftime;
		this.lifetime = lifetime;
		this.image = image;
		age = 0;
		killme = false;
	}


	public boolean update(int dt) { //returns killme to see if we should delete
		pos.x += vel.x * dt / 16;
		pos.y += vel.y * dt / 16;
		age += dt;
		if (age >= lifetime) {
			killme = true;
		}
		return killme;
	}

	public void drawMe() {
		float currentSize = (((((float)age/(float)lifetime)) * sizeOverLiftime) + 1) * size;
		imageMode(CENTER);
		image(image, pos.x, pos.y, currentSize, currentSize);
		imageMode(CORNER);
	}


}
