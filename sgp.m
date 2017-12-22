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
            % base
            basePointAngles = linspace(0, 2*pi*5/6, 6);
            this.base.X = []; this.base.Y = []; this.base.Z = []; this.base.vectors = {};
            
            for bpa = basePointAngles
                currentVector = [real(exp(1i*bpa)), imag(exp(1i*bpa)), 0];
                this.base.vectors{end+1} = currentVector;
                this.base.X(end+1) = currentVector(1);
                this.base.Y(end+1) = currentVector(2);
                this.base.Z(end+1) = currentVector(3);
            end;
            this.base.color = [0.2, 0.2, 0.5];
            
            % Stage
            stagePointAngles = linspace(2*pi/12, 2*pi*11/12, 6);
            this.stage.X = []; this.stage.Y = []; this.stage.Z = []; this.stage.vectors = {};
            this.stage.offset = [0, 0, 1];
            this.stage.radius = 0.5;
            
            for spa = stagePointAngles
                currentVector = this.stage.offset + this.stage.radius*[real(exp(1i*spa)), imag(exp(1i*spa)), 0];
                this.stage.vectors{end+1} = currentVector;
                this.stage.X(end+1) = currentVector(1);
                this.stage.Y(end+1) = currentVector(2);
                this.stage.Z(end+1) = currentVector(3);
            end;
            this.stage.color = [0.5, 0.2, 0.2];
        end;    
        
        function visualize(this)
            figure;
            patch (this.base.X, this.base.Y, this.base.Z, this.base.color); hold on;
            patch (this.stage.X, this.stage.Y, this.stage.Z, this.stage.color); hold on;
            
            rotate3d on;
            axis equal;
            view([45, 45]);
            grid on;
            
        end;
    end
    
end


