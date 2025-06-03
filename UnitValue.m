classdef UnitValue
    properties
        Value               
        Unit (1,7) double   % using 7 SI units
    end

    methods
        function obj = UnitValue(val, unit)
            if ~isnumeric(val)
                error('Value must be numeric.');
            end
            if ~isnumeric(unit) || numel(unit) ~= 7
                error('Unit must be a 7-element numeric vector.');
            end
            obj.Value = val;
            obj.Unit = reshape(unit, 1, 7);
        end

        function result = plus(a, b)
            [a, b] = UnitValue.coerce_pair(a, b);
            if ~isequal(a.Unit, b.Unit)
                error('Cannot add UnitValues with different units.');
            end
            result = UnitValue(a.Value + b.Value, a.Unit);
        end

        function result = minus(a, b)
            [a, b] = UnitValue.coerce_pair(a, b);
            if ~isequal(a.Unit, b.Unit)
                error('Cannot subtract UnitValues with different units.');
            end
            result = UnitValue(a.Value - b.Value, a.Unit);
        end

        function result = mtimes(a, b)
            [a, b] = UnitValue.coerce_pair(a, b);
            result = UnitValue(a.Value .* b.Value, a.Unit + b.Unit);
        end

        function result = mrdivide(a, b)
            [a, b] = UnitValue.coerce_pair(a, b);
            result = UnitValue(a.Value ./ b.Value, a.Unit - b.Unit);
        end

        function result = power(a, n)
            if ~isscalar(n)
                error('Exponent must be scalar.');
            end
            result = UnitValue(a.Value.^n, a.Unit * n);
        end

        function result = dot(a, b)
            [a, b] = UnitValue.coerce_pair(a, b);
            if ~isequal(size(a.Value), size(b.Value))
                error('Dot product values must have the same size.');
            end
            result = UnitValue(dot(a.Value, b.Value), a.Unit + b.Unit);
        end

        function result = cross(a, b)
            [a, b] = UnitValue.coerce_pair(a, b);
            if ~isequal(size(a.Value), [1 3]) || ~isequal(size(b.Value), [1 3])
                error('Cross product requires 1x3 vectors.');
            end
            result = UnitValue(cross(a.Value, b.Value), a.Unit + b.Unit);
        end

        function result = convert_to(obj, new_unit, scale_factor)
            if ~isequal(obj.Unit, new_unit)
                error('Units incompatible for conversion.');
            end
            result = UnitValue(obj.Value * scale_factor, new_unit);
        end

        function disp(obj) % Display value with unit
            unit_str = obj.unit_vector_to_string(obj.Unit);
            disp([num2str(obj.Value), ' ', unit_str]);  
        end
    end

    methods (Static)
        function [a, b] = coerce_pair(a, b)
            if ~isa(a, 'UnitValue')
                a = UnitValue(a, zeros(1, 7));
            end
            if ~isa(b, 'UnitValue')
                b = UnitValue(b, zeros(1, 7));
            end
        end

        function dict = known_units()
            % SI base units
            dict = containers.Map();
            dict("kg")  = [1 0 0 0 0 0 0];
            dict("m")   = [0 1 0 0 0 0 0];
            dict("s")   = [0 0 1 0 0 0 0];
            dict("A")   = [0 0 0 1 0 0 0];
            dict("K")   = [0 0 0 0 1 0 0];
            dict("mol") = [0 0 0 0 0 1 0];
            dict("cd")  = [0 0 0 0 0 0 1];

            % Derived units
            dict("N") = dict("kg") + dict("m") + dict("s") * -2;
            dict("J") = dict("N") + dict("m");
            dict("W") = dict("J") + dict("s") * -1;
            dict("Pa") = dict("N") + dict("m") * -2;
            dict("Hz") = dict("s") * -1;
            dict("C") = dict("A") + dict("s");
            dict("V") = dict("W") + dict("A") * -1;
            dict("Ohm") = dict("V") + dict("A") * -1;
            dict("F") = dict("C") + dict("V") * -1;
        end

        function ustr = unit_vector_to_string(u)
            labels = {'kg','m','s','A','K','mol','cd'};
            parts = {};
            for i = 1:7
                if u(i) ~= 0
                    parts{end+1} = [labels{i}, '^', num2str(u(i))];
                end
            end
            if isempty(parts)
                ustr = 'unitless';
            else
                ustr = strjoin(parts, '*');
            end
        end
    end
end
