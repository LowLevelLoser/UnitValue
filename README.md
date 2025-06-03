
# UnitValue – A MATLAB Runtime Unit Checking Library

**UnitValue** is a MATLAB library for associating SI unit metadata with values (scalars or arrays), enabling basic arithmetic and dimensional consistency checks at runtime. It is primarily intended for **debugging and validation**, catching errors like adding quantities with incompatible units.
I suggest that you rewrite your progam without after you finish when using thia library.

## Getting Started

### 1. Add the class to your path

Place `UnitValue.m` in a directory and add it to your MATLAB path:

```matlab
addpath('path_to_file');
````

### 2. Create values with units

```matlab
% Create a 5-meter quantity
u = UnitValue.known_units();
length = UnitValue(5, u("m"));
```

### 3. Perform operations

```matlab
% Multiply to get area (m^2)
area = length * length;  % Unit exponents add

% Exponentiate
volume = length ^ 3;

% Add two compatible values
height = UnitValue(2, u("m"));
total_height = length + height;

% This will throw an error (unit mismatch)
bad = length + UnitValue(3, u("s"));  % meters + seconds
```

### 4. Display result

```matlab
disp(volume);  % prints value and unit vector
```

## Example: Kinetic Energy

```matlab
u = UnitValue.known_units();

mass = UnitValue(2, u("kg"));       % 2 kg
velocity = UnitValue(3, u("m/s"));  % 3 m/s = [1 0 -1 0 0 0 0]

v2 = velocity ^ 2;                  % Square velocity: [2 0 -2 ...]
energy = 0.5 * mass * v2;           % Multiply with mass: [2 1 -2 ...] = Joules

disp(energy);
```

## Supported Operations

| Operator                  | Behavior                               |
| ------------------------- | -------------------------------------- |
| `+`, `-`                  | Values must have the same unit vector  |
| `*`, `/`                  | Unit vectors are added/subtracted      |
| `^`, `.^`                 | Scalar exponent multiplies unit vector |
| `disp()`                  | Displays value and unit vector         |
| `UnitValue.known_units()` | Returns map of common SI units         |

## Static Methods

```matlab
UnitValue.known_units()
```

Returns a `containers.Map` object mapping names like `"m"`, `"s"`, `"kg"` to their corresponding unit vectors.

## Planned Features
- more derived units
- conversion functions to different units
- maybe calculus
