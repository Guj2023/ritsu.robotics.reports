% Define symbolic variables
syms theta_1 theta_2 theta_4 d_3

% Define the transformation matrices
T1 = [cos(theta_1), -sin(theta_1), 0, 0;
    sin(theta_1), cos(theta_1), 0, 0;
    0, 0, 1, 1;
    0, 0, 0, 1];

T2 = [cos(theta_2), -sin(theta_2), 0, 1;
    0, 0, -1, 0;
    sin(theta_2), cos(theta_2), 0, 0;
    0, 0, 0, 1];

T3 = [1, 0, 0, 1;
    0, 1, 0, 0;
    0, 0, 1, d_3;
    0, 0, 0, 1];

T4 = [cos(theta_4), -sin(theta_4), 0, 0;
    sin(theta_4), cos(theta_4), 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1];

T5 = [1, 0, 0, 0;
    0, -1, 0, 0;
    0, 0, -1, -0.1;
    0, 0, 0, 1];

% Calculate the product of the matrices

T = T1 * T2 * T3 * T4 * T5;

% Substitute the given values into the transformation matrix
T_subs1 = subs(T, {theta_1, theta_2, d_3, theta_4}, {0, 0, 0.5, 0});
T_subs2 = subs(T, {theta_1, theta_2, d_3, theta_4}, {pi/4, pi/4, 1, pi/4});
T_subs3 = subs(T, {theta_1, theta_2, d_3, theta_4}, {pi/2, pi/2, 1.5, 0});

% Display the substituted matrices
disp('T when theta_1 = 0, theta_2 = 0, d_3 = 0.5, theta_4 = 0:');
disp(T_subs1);

disp('T when theta_1 = pi/4, theta_2 = pi/4, d_3 = 1, theta_4 = pi/4:');
disp(T_subs2);

disp('T when theta_1 = pi/2, theta_2 = pi/2, d_3 = 1.5, theta_4 = 0:');
disp(T_subs3);

% Display the result
disp(T)

