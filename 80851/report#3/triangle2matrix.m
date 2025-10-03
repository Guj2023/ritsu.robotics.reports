function [J_lambda, J_mu] = triangle2matrix(i, j, k)
    a = [j(2) -  k(2); k(2) - i(2); i(2) - j(2)];
    b = -[j(1) -  k(1); k(1) - i(1); i(1) - j(1)];
    H_lambda = [a * a', a * b'; b * a', b * b'];
    H_mu = [(2 * a * a') + b * b', b * a'; a * b', 2 * b * b' + a * a'];
    J_lambda = [H_lambda(1, 1), H_lambda(1, 4), H_lambda(1, 2), H_lambda(1, 5), H_lambda(1, 3), H_lambda(1, 6);
                H_lambda(4, 1), H_lambda(4, 4), H_lambda(4, 2), H_lambda(4, 5), H_lambda(4, 3), H_lambda(4, 6);
                H_lambda(2, 1), H_lambda(2, 4), H_lambda(2, 2), H_lambda(2, 5), H_lambda(2, 3), H_lambda(2, 6); 
                H_lambda(5, 1), H_lambda(5, 4), H_lambda(5, 2), H_lambda(5, 5), H_lambda(5, 3), H_lambda(5, 6); 
                H_lambda(3, 1), H_lambda(3, 4), H_lambda(3, 2), H_lambda(3, 5), H_lambda(3, 3), H_lambda(3, 6); 
                H_lambda(6, 1), H_lambda(6, 4), H_lambda(6, 2), H_lambda(6, 5), H_lambda(6, 3), H_lambda(6, 6)];
    J_mu = [H_mu(1, 1), H_mu(1, 4), H_mu(1, 2), H_mu(1, 5), H_mu(1, 3), H_mu(1, 6);
            H_mu(4, 1), H_mu(4, 4), H_mu(4, 2), H_mu(4, 5), H_mu(4, 3), H_mu(4, 6);
            H_mu(2, 1), H_mu(2, 4), H_mu(2, 2), H_mu(2, 5), H_mu(2, 3), H_mu(2, 6); 
            H_mu(5, 1), H_mu(5, 4), H_mu(5, 2), H_mu(5, 5), H_mu(5, 3), H_mu(5, 6); 
            H_mu(3, 1), H_mu(3, 4), H_mu(3, 2), H_mu(3, 5), H_mu(3, 3), H_mu(3, 6); 
            H_mu(6, 1), H_mu(6, 4), H_mu(6, 2), H_mu(6, 5), H_mu(6, 3), H_mu(6, 6)];
end