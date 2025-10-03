% Define DH parameters: [a alpha d theta]
theta1 = 0;
theta2 = 0;
theta3 = 0;
dhparams = [0   	0   	1   	0;
            1	    pi/2       0    0;
            1	    0	    -0.2	0;
            0   	0   	0   	0;
            0       -pi 	0.1   	0;];
% Create a rigid body tree
robot = robotics.RigidBodyTree;

bodies = cell(5,1);
joints = cell(5,1);
for i = 1:5
    bodies{i} = rigidBody(['body' num2str(i)]);
    if i == 3
        joints{i} = rigidBodyJoint(['jnt' num2str(i)],"prismatic");
    else
        joints{i} = rigidBodyJoint(['jnt' num2str(i)],"revolute");
    end
    setFixedTransform(joints{i},dhparams(i,:),"mdh");
    bodies{i}.Joint = joints{i};
    if i == 1 % Add first body to base
        addBody(robot,bodies{i},"base")
    else % Add current body to previous body by name
        addBody(robot,bodies{i},bodies{i-1}.Name)
    end
end

% Show the robot
figure;
config = homeConfiguration(robot);
config(4).JointPosition = pi/4;
show(robot, config, 'PreservePlot', false, 'Visuals', 'on');
axis equal;

% Define configurations based on the table
configurations = [
    0, 0, 0.5, 0;
    pi/4, pi/4, 1, pi/4;
    pi/2, pi/2, 1.5, 0
];

% % Loop through each configuration and display the robot
% for i = 1:size(configurations, 1)
%     config = homeConfiguration(robot);
%     config(1).JointPosition = configurations(i, 1);
%     config(2).JointPosition = configurations(i, 2);
%     config(3).JointPosition = configurations(i, 3);
%     config(4).JointPosition = configurations(i, 4);
%     tform = getTransform(robot, config, 'body5');
    
%     % Extract the position from the transformation matrix
%     position = tform(1:3, 4);

%     % Show the robot with the updated configuration
%     show(robot, config, 'PreservePlot', false, 'Visuals', 'on');
    
%     % Plot the position of the end effector
%     hold on;
%     plot3(position(1), position(2), position(3), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
%     text(position(1), position(2), position(3), sprintf('(%0.2f, %0.2f, %0.2f)', position(1), position(2), position(3)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
%     hold off;
%     % Save the figure as 'configuration_i.pdf'
%     saveas(gcf, ['configuration_' num2str(i) '.pdf']);
%     % Get the transformation from the base to the end effector

    
%     % Display the position of the end effector
%     disp(['End effector position for configuration ' num2str(i) ':']);
%     disp(position);
%     title(['Configuration ' num2str(i)]);
%     drawnow;
%     pause(1); % Pause to visualize each configuration
% end
