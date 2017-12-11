
	var SCREEN_WIDTH = window.innerWidth;
	var SCREEN_HEIGHT = window.innerHeight;
	var RADIUS = 200;
	var QUANTITY = 150;

	var container;

	var camera;
	var scene;
	var renderer;
	
	var descriptors = [];

	var mouseX = 0;
	var mouseY = 0;

	var windowHalfX = window.innerWidth / 2;
	var windowHalfY = window.innerHeight / 2;


	init();
	setInterval(loop, 1000 / 60);

	function init() {

		container = document.createElement('div');
		document.body.appendChild(container);				

		camera = new THREE.Camera(0, 0, 300);
		camera.focus = 50;

		scene = new THREE.Scene();

		renderer = new THREE.CanvasRenderer();
		renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
		
		createParticles();
		
		container.appendChild(renderer.domElement);

		document.addEventListener('mousemove', onDocumentMouseMove, false);
		document.addEventListener('touchstart', onDocumentTouchStart, false);
		document.addEventListener('touchmove', onDocumentTouchMove, false);
	}

	//

	function createParticles() {
		for (var i = 0; i < QUANTITY; i++) {
			var particle = new THREE.Particle(new THREE.ColorFillMaterial(Math.random() * 0x404040 + 0xaaaaaa, 1));
			particle.size = 10;
			
			particle.position.x = 0;
			particle.position.y = 0;
			particle.position.z = 0;
			
			particle.offset = { x: 0, y: 0, z: 0 };
			particle.shift = { x: 0, y: 0 };
			particle.speed = 0.01+Math.random()*0.04;
			particle.targetSize = particle.size;
			
			scene.add(particle);
		}
	}

	function onDocumentMouseMove(event) {

		mouseX = event.clientX - windowHalfX;
		mouseY = event.clientY - windowHalfY;
	}

	function onDocumentTouchStart(event) {

		if(event.touches.length == 1) {

			event.preventDefault();

			mouseX = event.touches[0].pageX - windowHalfX;
			mouseY = event.touches[0].pageY - windowHalfY;
		}
	}

	function onDocumentTouchMove(event) {

		if(event.touches.length == 1) {

			event.preventDefault();

			mouseX = event.touches[0].pageX - windowHalfX;
			mouseY = event.touches[0].pageY - windowHalfY;
		}
	}

	//

	function loop() {

		//camera.position.x += (mouseX - camera.position.x) * .05;
		//camera.position.y += (-mouseY - camera.position.y) * .05;
		camera.updateMatrix();
		
		renderer.render(scene, camera);
		
		var context = renderer.domElement.getContext("2d")
		
		for (var i = 0, len = scene.objects.length; i < len; i++) {
			var particle = scene.objects[i];
			
			particle.offset.x += particle.speed;
			particle.offset.y += particle.speed;
			
			particle.shift.x += ( mouseX - particle.shift.x) * (particle.speed);
			particle.shift.y += ( -mouseY - particle.shift.y) * (particle.speed);
			
			particle.position.x = particle.shift.x + Math.cos(i + particle.offset.x) * RADIUS;
			particle.position.y = particle.shift.y + Math.sin(i + particle.offset.y) * RADIUS;
			particle.position.z = i / QUANTITY * RADIUS;
			
			particle.size += ( particle.targetSize - particle.size ) * 0.05;
			
			if( Math.round( particle.size ) == Math.round( particle.targetSize ) ) {
				particle.targetSize = 1 + Math.random() * 10;
			}
		}
	}
	
	function distanceBetween(p1,p2) {
		var dx = p2.x-p1.x;
		var dy = p2.y-p1.y;
		return Math.sqrt(dx*dx + dy*dy);
	}
	
	
	
	