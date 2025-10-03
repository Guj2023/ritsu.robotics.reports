body = RigidBody_Cylinder(1, 2, 6);
clf;
body.draw;
xlim([-10,10]); ylim([-10,10]); zlim([-10,10]);
xlabel('x'); ylabel('y'); zlabel('z');
pbaspect([1 1 1]);
grid on;
view([-75, 30]);
