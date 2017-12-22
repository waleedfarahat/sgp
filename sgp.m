classdef sgp < handle
    % SGP: Class to analyze Stewart-Gough mechanisms
    % WAF: 12/2017
    
    properties
        base
        stage
    end
    
    methods
        function this = sgp
            
        end;
        
        function define(this)
            angles = linspace(0, 2*pi*5/6, 6);
            this.base.X = []; this.base.Y = []; this.base.Z = [];
            for k = 1:length(angles)
                currentVector = [real(exp(i*angles(k))), imag(exp(i*angles(k))), 0];
                this.base.(['vector_', num2str(k)]) = currentVector;
                this.base.X(end+1) = currentVector(1);
                this.base.Y(end+1) = currentVector(2);
                this.base.Z(end+1) = currentVector(3);
            end;
            
            angles = linspace(2*pi/12, 2*pi*11/12, 6);
            this.stage.X = []; this.stage.Y = []; this.stage.Z = [];
            this.stage.offset = [0, 0, 1];
            this.stage.radius = 0.5;
            for k = 1:length(angles)
                currentVector = this.stage.offset + this.stage.radius*[real(exp(i*angles(k))), imag(exp(i*angles(k))), 0];
                this.stage.(['vector_', num2str(k)]) = currentVector;
                this.stage.X(end+1) = currentVector(1);
                this.stage.Y(end+1) = currentVector(2);
                this.stage.Z(end+1) = currentVector(3);
            end;
        end;    
        
        function visualize(this)
            figure;
            patch (this.base.X, this.base.Y, this.base.Z, [0.2, 0.2, 0.5]); hold on;
            patch (this.stage.X, this.stage.Y, this.stage.Z, [0.5, 0.2, 0.2]); hold on;
            
            rotate3d on;
            axis equal;
            view([45, 45]);
            grid on;
            
        end;
    end
    
end


