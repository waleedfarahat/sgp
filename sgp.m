classdef sgp < handle
    % SGP: Class to analyze Stewart-Gough mechanisms
    % WAF: 12/2017
    
    properties
        base
        platform
        links
    end
    
    methods (Access = public)
        function this = sgp
            this.define;
            this.computeIK;
            this.visualize;
        end;
        
        function define(this)
            % base
            this.base.angles = linspace(0, 2*pi*5/6, 6);
            this.base.radii = ones(1,6);
            this.base.origin = [0; 0; 0];
            
            this.base.vectors = [real(this.base.radii.*exp(1i*this.base.angles)); ...
                imag(this.base.radii.*exp(1i*this.base.angles)); ...
                zeros(size(this.base.angles))];
            
            this.base.X = this.base.vectors(1,:);
            this.base.Y = this.base.vectors(2,:);
            this.base.Z = this.base.vectors(3,:);
            
            this.base.color = [0.2, 0.2, 0.5];
            
            % Platform
            this.platform.angles = (pi/180)*[-10, 10, 110, 130, 230, 250]; %linspace(2*pi/12, 2*pi*11/12, 6);
            this.platform.radii = 0.75*ones(1,6);
            this.platform.localVectors = [real(this.platform.radii.*exp(1i*this.platform.angles)); ...
                imag(this.platform.radii.*exp(1i*this.platform.angles)); ...
                zeros(size(this.platform.angles))];
            
            this.platform.origin = [-0.1; 0.2; 1];
            this.platform.rotation.RPY = (pi/180)*[20, -10, 42]; % roll, pitch, yaw
            this.platform.rotation.rotMatrix = this.getRotationMatrix(this.platform.rotation.RPY);
            this.platform.vectors = this.platform.rotation.rotMatrix*this.platform.localVectors + ...
                repmat(this.platform.origin, 1, 6);
            
            this.platform.X = this.platform.vectors(1,:);
            this.platform.Y = this.platform.vectors(2,:);
            this.platform.Z = this.platform.vectors(3,:);
            
            this.platform.color = [0.5, 0.2, 0.2];
        end;
        
        function visualize(this)
            figure;
            
            subplot 121;
            % plot patches for stages
            pBase = patch (this.base.X, this.base.Y, this.base.Z, this.base.color); hold on;
            pPlatform = patch (this.platform.X, this.platform.Y, this.platform.Z, this.platform.color); hold on;
            set(pBase, 'facealpha', 0.5); set(pPlatform, 'facealpha', 0.5);
            this.plotCoordinateFrame([0, 0, 0], eye(3), 0.3)
            this.plotCoordinateFrame(this.platform.origin, this.platform.rotation.rotMatrix, 0.3)
            
            for k = 1:6
                line([this.base.X(k), this.platform.X(k)], ...
                     [this.base.Y(k), this.platform.Y(k)], ...
                     [this.base.Z(k), this.platform.Z(k)], 'color', [0, 0, 0], 'linewidth', 2)
            end;
            
            
            xlabel ('x'); ylabel ('y'); zlabel ('z');
            rotate3d on;
            axis equal;
            view([45, 45]);
            grid on;
            
            subplot 122;
            bar(this.links.lengths);
            title ('Link lengths IK');
            xlabel ('Link');
            ylabel ('Length')
            
        end;
        
        function computeIK(this)
            this.links.vectors = this.platform.vectors - this.base.vectors;
            for k = 1:size(this.links.vectors, 2)
                this.links.lengths(1, k) = norm(this.links.vectors(:,k));
            end;
            
        end;
        
    end
    
    methods (Access = private)
        function rotMatrix = getRotationMatrix(~, RPY)
            % returns rotation matrix rotMatrix as a function for
            % roll-pitch-yaw transforms
            
            g = RPY(3); % gamma, yaw, rotation about z
            b = RPY(2); % beta, pitch, rotation about y
            a = RPY(1); % alpha, roll, rotation about x
            
            sina = sin(a); cosa = cos(a);
            sinb = sin(b); cosb = cos(b);
            sing = sin(g); cosg = cos(g);
            
            rotMatrix = [(cosb*cosg        ), (cosg*sina*sinb - cosa*sing), (sina*sing + cosa*cosg*sinb); ...
                (cosb*sing        ), (cosa*cosg + sina*sinb*sing), (cosa*sinb*sing - cosg*sina); ...
                (-sinb            ), (cosb*sina)                 , (cosa*cosb);                ];
            
        end;
        
        function plotCoordinateFrame(~, origin, rotMatrix, scaleFactor)
            % plots rgb xyz coordinate frame with origin, rotMatrix and
            % scaleFactor
            if size(origin, 1) == 1, origin = origin'; end;
            
            x_axis = [scaleFactor; 0; 0]; y_axis = [0; scaleFactor; 0]; z_axis = [0; 0; scaleFactor];
            
            x_axis = rotMatrix*x_axis + origin; 
            y_axis = rotMatrix*y_axis + origin; 
            z_axis = rotMatrix*z_axis + origin; 
            
            plot3( [origin(1), x_axis(1)], [origin(2), x_axis(2)], [origin(3), x_axis(3)], 'r', 'linewidth', 2); hold on;
            plot3( [origin(1), y_axis(1)], [origin(2), y_axis(2)], [origin(3), y_axis(3)], 'g', 'linewidth', 2); hold on;
            plot3( [origin(1), z_axis(1)], [origin(2), z_axis(2)], [origin(3), z_axis(3)], 'b', 'linewidth', 2); hold on;
            
        end;
        
        function plotLinePoints(~, firstPoints, secondPoints, varargin)
            % plots line segments defined by between firstPoints and
            % secondPoints
            
            % make points a 3 x X matrix
            if size(firstPoints, 1) ~= 3, firstPoints = firstPoints'; end;
            if size(secondPoints, 1) ~= 3, secondPoints = secondPoints'; end;
            
                            
        end;
        
    end;
    
end


