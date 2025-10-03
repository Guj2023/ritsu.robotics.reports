classdef Contour
    properties
        numEdges;
        Edges;
        Area;
    end
    methods
        function obj = Contour(nedges, edges, area)
            obj.numEdges = nedges;
            obj.Edges = edges;
            obj.Area = area;
        end
        
        function forces = nodal_forces_equivalent_to_pressure(obj, npoints, positions, pressure)
            forces = zeros(2, npoints);
            edges = obj.Edges;
            for p = 1:obj.numEdges
                i=edges(p,1); j=edges(p,2);
                ri = positions(:,i);
                rj = positions(:,j);
                fequiv = (1/2)*pressure*[0,-1;1,0]*(rj-ri);
                forces(:,i) = forces(:,i) + fequiv;
                forces(:,j) = forces(:,j) + fequiv;
            end
        end
        
    end
end
