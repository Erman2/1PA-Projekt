% MATLAB controller for Webots
% File:          ketchup_house_controller.m
% Date:
% Description:
% Author: Roman Krček, Karel Hejl

addpath('../')

storage_positions = [7 1;
                     7 2;
                     7 7;
					 7 6];
					 
robot_position = [7 4];

% Borders of scan angle
scan_angle = [65 300];

can_bot = CanBot('motor_left', 'motor_right', 'dst_front_can', ...
				'dst_front_bot', 'compass', 'infra_left', 'infra_right', ...
				robot_position, storage_positions, scan_angle, ...
				32);


% Main can collection program
while true
	
	% Initiate scan
	cans = can_bot.scan_cans();

	% End collecting cans
	if isempty(cans)
		wb_console_print(sprintf('No more cans to pick up'), WB_STDOUT);
		can_bot.align(can_bot.default_alignment);
		break;
	end
	
	% Pickup cans 
	for i = 1:size(cans, 1)
		target_coords = cans(i, :);
		can_bot.go_coordinates(target_coords);
	end
	
	% Store cans
	can_bot.store_cans()
	
end

while wb_robot_step(64) ~= -1

end