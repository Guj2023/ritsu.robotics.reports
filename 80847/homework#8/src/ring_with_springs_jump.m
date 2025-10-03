% g, cm, sec

addpath('../two_dim_fea');

period01 = 0.1; period12 = 0.9;
time1 =  0 + period01; time2 = time1 + period12;
tinterval = 0.02;
vinterval = 0.002;
[ 0, time1, time2 ]

m = 32; n = 3; router = 5; rinner = 4; thickness = 1;
[points, triangles] = ring_object(m, n, router, rinner);
points = points + [ 0; router ];

npoints = size(points, 2);
ntriangles = size(triangles, 1);
ring = Body(npoints, points, ntriangles, triangles, thickness);

% E = 0.1 MPa; c = 0.04 kPa s; rho = 1 g/cm^3
Young = 1.0*1e+6; c = 0.4*1e+3; nu = 0.48; density = 1.00;
[ lambda, mu ] = Lame_constants( Young, nu );
[ lambda_vis, mu_vis ] = Lame_constants( c, nu );
ring = ring.mechanical_parameters(density, lambda, mu);
ring = ring.viscous_parameters(lambda_vis, mu_vis);

ring = ring.calculate_stiffness_matrix;
ring = ring.calculate_damping_matrix;
ring = ring.calculate_inertia_matrix;
ring = ring.calculate_coefficient_matrices_for_Green_strain;

% g = 9.8 m/s^2 = 980 cm/s^2
grav = [0; -980];
ring = ring.calculate_gravitational_vector(grav);

mass = 1;

for i=1:8
    springs(i) = Spring(2e+4, 0.0, rinner);
end
connect = [0:7]*(m/8)*n + 1;
%extensional_forces = [ 0; -1e+5; 0; 0; 0; 0; 0; 0 ];
% N = Kg m/s^2 = 10^3 g 10^2 cm/s^2 = 10^5 g cm/s^2

uninit = zeros(2*npoints,1);
vninit = zeros(2*npoints,1);
xcinit = [ 0; router ];
vcinit = [ 0; 0 ];
qinit = [ uninit; vninit; xcinit; vcinit ];

figure('position', [0, 0, 800, 800]);
set(0,'defaultAxesFontSize',32);
set(0,'defaultTextFontSize',32);
floor_color = [0.85 0.85 0.85];

clf;
%ring.draw;
disps = reshape(uninit, [2,npoints]);
ring.draw_individual(disps);
draw_mass_and_springs(ring, xcinit, connect, disps);
fill([8, 8, -8, -8], [-2, 0, 0, -2], floor_color, 'FaceAlpha', 0.2, 'EdgeColor','none');
xlim([-8,8]); ylim([-2,14]);
pbaspect([1 1 1]);
grid on;
drawnow;

interval = [0, time1];
extensional_forces = @(t) (t/time1)*[ -1.0e+5; 0; 0; 0; -1.0e+5; 0; 0; 0 ];
ring_free = @(t,q) ring_free_param(t,q, ring, grav, mass, springs, connect, extensional_forces);
[t1, q1] = ode45(ring_free, interval, qinit);
draw_ring_and_springs ( gcf, t1, q1, tinterval, ring, connect, floor_color );
qinit = q1(end,:);
M01 = make_video_clip( gcf, t1, q1, vinterval, ring, connect, floor_color );
save('ring_and_springs_jump_period01.mat', 't1', 'q1', 'M01', '-v7.3');
clear t1 q1;

interval = [time1, time2];
extensional_forces = @(t) [ 0; 0; 0; 0; 0; 0; 0; 0 ];
ring_free = @(t,q) ring_free_param(t,q, ring, grav, mass, springs, connect, extensional_forces);
[t2, q2] = ode45(ring_free, interval, qinit);
draw_ring_and_springs ( gcf, t2, q2, tinterval, ring, connect, floor_color );
qinit = q2(end,:);
M12 = make_video_clip( gcf, t2, q2, vinterval, ring, connect, floor_color );
save('ring_and_springs_jump_period12.mat', 't2', 'q2', 'M12', '-v7.3');
clear t2 q2;

% video clip
M = [ M01, M12(2:end) ];
v = VideoWriter('ring_with_springs_jump', 'MPEG-4');
open(v);
writeVideo(v, M);
close(v);

function dotq = ring_free_param(t,q, ring, grav, mass, springs, connect, extensional_forces)
    %disp(t);
    disp(num2str(t,"%8.6f"));
    
    persistent npoints xn thickness M B K gravitational_force;
    persistent Kcontact Bcontact friction_damping;
    if isempty(npoints)
        npoints = ring.numNodalPoints;
        for k=1:npoints
            xn = [ xn; ring.NodalPoints(k).Coordinates ];
        end
        thickness = ring.Thickness;
        M = ring.Inertia_Matrix;
        B = ring.Damping_Matrix;
        K = ring.Stiffness_Matrix;
        gravitational_force = ring.Gravitational_Vector;
        Kcontact = 1e+6; % N/m = kg/s^2 = 10^3 g/s^2
        Bcontact = 0;
        friction_damping = 20000; % Ns/m = 10^3 g/s
    end
    
    un = q(1:2*npoints);
    vn = q(2*npoints+1:4*npoints);
    xc = q(4*npoints+1:4*npoints+2);
    vc = q(4*npoints+3:4*npoints+4);
    
    disps = reshape(un, [2,npoints]);
    
    % Cauchy strain
    %elastic_force = -K*un -B*vn;
    % Green strain
    elastic_force = ring.nodal_forces_Green_strain(disps) -B*vn;
    
    rn = xn + un;
    contact_force = zeros(2*npoints,1);
    for k=1:npoints
        if rn(2*k) < 0
            contact_force(2*k-1) = -friction_damping*vn(2*k-1);
            contact_force(2*k) = -Kcontact*rn(2*k) -Bcontact*vn(2*k);            
        end
    end

    f = elastic_force + gravitational_force + contact_force;
    
    fc_all = zeros(2,1);
    ext_forces = extensional_forces(t);
    for i=1:8
        j = connect(i);
        [fc,fj] = springs(i).end_forces( xc, vc, rn(2*j-1:2*j), vn(2*j-1:2*j), ext_forces(i) );
        fc_all = fc_all + fc;
        f(2*j-1:2*j) = f(2*j-1:2*j) + fj;
    end
    
    dotun = vn;
    
    coef = M;
    vec = f;
    sol = coef\vec;
    dotvn = sol(1:2*npoints);
    
    dotxc = vc;
    dotvc = (1/mass)*(mass*grav + fc_all);
    
    dotq = [dotun; dotvn; dotxc; dotvc];
end

function draw_ring_and_springs ( gcf, time, q, tinterval, ring, connect, floor_color )

    persistent npoints;
    if isempty(npoints)
        npoints = ring.numNodalPoints;
    end

    clf;
    tstart = time(1);
    tend = time(end);
    for t = tstart:tinterval:tend
        fprintf("time %f\n", t);
        index = nearest_index(time, t);
        disps = reshape(q(index, 1:npoints*2), [2,npoints]);
        ring.draw_individual(disps);
        draw_mass_and_springs(ring, q(index, 4*npoints+1:4*npoints+2), connect, disps);
        fill([8, 8, -8, -8], [-2, 0, 0, -2], floor_color, 'FaceAlpha', 0.2, 'EdgeColor','none');
        hold off;
        xlim([-8,8]); ylim([-2,14]);
        pbaspect([1 1 1]);
        grid on;
        filename = strcat('ring_with_springs_jump/deform_', num2str(floor(1000*t),'%04d'), '.png');
        saveas(gcf, filename, 'png');
    end
end

function M = make_video_clip ( gcf, time, q, vinterval, ring, connect, floor_color )

    persistent npoints;
    if isempty(npoints)
        npoints = ring.numNodalPoints;
    end
    
    clf('reset');
    tstart = time(1);
    tend = time(end);
    fr = 1;
    clear M;
    
    for t = tstart:vinterval:tend
        fprintf("video time %f\n", t);
        index = nearest_index(time, t);
        disps = reshape(q(index, 1:npoints*2), [2,npoints]);
        ring.draw_individual(disps);
        draw_mass_and_springs(ring, q(index, 4*npoints+1:4*npoints+2), connect, disps);
        fill([8, 8, -8, -8], [-2, 0, 0, -2], floor_color, 'FaceAlpha', 0.2, 'EdgeColor','none');
        hold off;
        xlim([-8,8]); ylim([-2,14]);
        pbaspect([1 1 1]);
        title(['time ' num2str(t,"%3.2f")]);
        grid on;
        drawnow;
        M(fr) = getframe(gcf);
        fr = fr + 1;
    end
end
