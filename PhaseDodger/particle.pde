class particle {

PVector pos;
PVector vel;
int lifetime; //how long the particle should live for in milliseconds
int age; //how long we've been alive for in milliseconds
boolean killme;
PImage image;

public particle(PVector pos, PVector vel, int lifetime, PImage image) {
	this.pos = pos;
	this.vel = vel;
	this.lifetime = lifetime;
	this.image = image;
	age = 0;
	killme = false;
}


public void drawMe(int dt) {
	pos.x += vel.x * dt / 16;
	pos.y += vel.y * dt / 16;
	age += dt;
	imageMode(CENTER);
	image(image, pos.x, pos.y);
	imageMode(CORNER);
	if (age >= lifetime) {
		killme = true;
	}

}


}