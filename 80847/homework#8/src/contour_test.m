points = [ 0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3; ...
           0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3 ];
triangles = [ 1,2,5; 2,3,6; 3,4,7; 6,5,2; 7,6,3; 8,7,4; ...
              5,6,9; 7,8,11; 10,9,6; 12,11,8; ...
              9,10,13; 10,11,14; 11,12,15; 14,13,10; 15,14,11; 16,15,12 ];
elastic = Body(16, points, 16, triangles, 1);
edges = elastic.BoundaryEdges;
edges

[ nloops, loops, order ] = edges_to_loops (edges);

[ loop_1, area_1 ] = extract_loop(1, loops, order, edges, points );
loop_1
area_1

[ loop_2, area_2 ] = extract_loop(2, loops, order, edges, points );
loop_2
area_2

elastic.Loops(1).Edges
elastic.Loops(2).Edges
