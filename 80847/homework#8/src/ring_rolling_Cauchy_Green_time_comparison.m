% g, cm, sec

addpath('../two_dim_fea');

m = 16; n = 3; router = 4; rinner = 2; thickness = 1;
[points, triangles] = ring_object(m, n, router, rinner);
points = points + [ 0; router ];

npoints = size(points, 2);
ntriangles = size(triangles, 1);
ring = Body(npoints, points, ntriangles, triangles, thickness);

% E = 0.1 MPa; c = 0.04 kPa s; rho = 1 g/cm^3
Young = 1.0*1e+6; c = 0.4*1e+3; nu = 0.48; density = 1.00;
density_heavy = 10*density;
[ lambda, mu ] = Lame_constants( Young, nu );
[ lambda_vis, mu_vis ] = Lame_constants( c, nu );

ring = ring.define_subregion([1:32]);
ring = ring.subregion_mechanical_parameters(density_heavy, lambda, mu);
ring = ring.subregion_viscous_parameters(lambda_vis, mu_vis);
ring = ring.subregion_color( [0.85 0.85 0.85] );

ring = ring.define_subregion([33:64]);
ring = ring.subregion_mechanical_parameters(density, lambda, mu);
ring = ring.subregion_viscous_parameters(lambda_vis, mu_vis);
ring = ring.subregion_color( [0.95 0.95 0.95] );

ring = ring.calculate_stiffness_matrix;
ring = ring.calculate_coefficient_matrices_for_Green_strain;

%disps = rand(2, npoints);
%fn1 = ring.nodal_forces_Cauchy_strain(disps);
%fn2 = ring.nodal_forces_Cauchy_strain_original(disps);
%[ fn1, fn2 ]

%disps = rand(2, npoints);
%fn1 = ring.nodal_forces_Green_strain(disps);
%fn2 = ring.nodal_forces_Green_strain_original(disps);
%[ fn1, fn2 ]

count = 10000;

tic
for k=1:count
disps = rand(2, npoints);
fn = ring.nodal_forces_Cauchy_strain(disps);
end
toc

%tic
%for k=1:count
%disps = rand(2, npoints);
%fn = ring.nodal_forces_Cauchy_strain_original(disps);
%end
%toc

tic
for k=1:count
disps = rand(2, npoints);
fn = ring.nodal_forces_Green_strain(disps);
end
toc

tic
for k=1:count
disps = rand(2, npoints);
fn = ring.nodal_forces_Green_strain_original(disps);
end
toc
