class particleSystem {

PVector pos;
ArrayList<particle> children;
ArrayList<Integer> indexOfDeadChildren;
PImage particleImage;
float minSpeed;
float maxSpeed;
int maxLife; //max life in milliseconds
int minLife; //min life in milliseconds
int spawnRate;
int spawnTimer;
float size;
float sizeOverLifetime;
int timer;




	public particleSystem(PVector pos, PImage particleImage, float minSpeed, float maxSpeed, int minLife, int maxLife, int spawnRate, float size, float sizeOverLifetime) {
		this.pos = pos;
		this.particleImage = particleImage;
		this.minSpeed = minSpeed;
		this.maxSpeed = maxSpeed;
		this.minLife = minLife;
		this.maxLife = maxLife;
		this.spawnRate = spawnRate;
		this.size = size;
		this.sizeOverLifetime = sizeOverLifetime;
		children = new ArrayList();
		indexOfDeadChildren = new ArrayList();
		timer = millis();
		spawnTimer = 0;
	}

	public void drawMe() {
		indexOfDeadChildren.clear();
		int dt = millis() - timer;
		timer = millis();
		spawnTimer += dt;

		if (spawnTimer >= spawnRate) {
			float speed = random(minSpeed, maxSpeed);
			float angle = random(TWO_PI);
			PVector vel = new PVector(speed, 0);
			int lifeTime = floor(random(minLife, maxLife) + 0.5);
			vel.rotate(angle);
			children.add(new particle(new PVector(pos.x, pos.y), vel, size, sizeOverLifetime, lifeTime, particleImage));
			spawnTimer = 0;
			//println("Particle spawned, lifetime:" + lifeTime);
		}

		if (!children.isEmpty()) {
			for (int i = children.size() - 1; i >= 0; i--) {
				if (children.get(i).drawMe(dt)) {
					indexOfDeadChildren.add(i);
				}
			}
			if (!indexOfDeadChildren.isEmpty()) {
				for (int i = 0; i < indexOfDeadChildren.size(); i++) {
					children.remove((int)indexOfDeadChildren.get(i));
				}
			}
		}
	}
}