classdef RigidBody_Cylinder < RigidBody
    properties
        r, h;
    end
    methods
        function obj = RigidBody_Cylinder (rho, r, h)
            obj@RigidBody(1,eye(3));
            m = rho*pi*r^2*h;
            Jz = (1/2)*m*r^2;
            Jx = (1/12)*m*(3*r^2 + h^2);
            Jy = Jx;
            J = diag([Jx, Jy, Jz]);
            obj = obj.mass_and_inertia_matrix(m, J);
            obj.density = rho;
            obj.r = r;
            obj.h = h;
        end
        
        function draw(obj, pos, q)
            arguments
                obj;
                pos = zeros(3,1);
                q = [1; 0; 0; 0];
            end
            % Define the cylinder
            [X, Y, Z] = cylinder(obj.r, 200);
            Z = Z * obj.h;
            obj = obj.quaternion(q);
            rotation_matrix = obj.rotation_matrix;
            for i = 1:size(X, 1)
            for j = 1:size(X, 2)
                point = rotation_matrix * [X(i,j); Y(i,j); Z(i,j)];
                X(i,j) = point(1);
                Y(i,j) = point(2);
                Z(i,j) = point(3);
            end
            end
            
            % Translate the cylinder
            X = X + pos(1);
            Y = Y + pos(2);
            Z = Z + pos(3);
            % Draw the cylinder
            surf(X, Y, Z, 'FaceColor', [0.8, 0.8, 0.8], 'EdgeColor', 'none');
            hold on;
            fill3(X(1,:), Y(1,:), Z(1,:), [0.8, 0.8, 0.8]);
            fill3(X(2,:), Y(2,:), Z(2,:), [0.8, 0.8, 0.8]);
            hold off;
        end
    end
end
