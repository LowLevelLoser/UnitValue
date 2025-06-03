u = UnitValue.known_units();

% Define some physical quantities
mass = UnitValue(2, u("kg"));                         % 2 kg
acc = UnitValue([0, 9.8, 0], u("m") + u("s") * -2);  % Acceleration vector
Force = mass * acc;                                         % Force vector (N)

disp('Force:');
disp(Force);

% Work done = Force * Displacement
distance = UnitValue([3, 1, 1], u("m"));                  % 3m in x-direction
Work = dot(Force, distance);                                     % Scalar result: Work (J)
disp('Work:');
disp(Work);

% Cross product: Torque = r x F
Torque = cross(distance, F);                                   % Torque (N*m)
disp('Torque:');
disp(Torque);

%Area
length = UnitValue(2.5, u("m"));
Area = length^2;

disp('Area: ');
disp(Area);
% example error
Err= F+W;