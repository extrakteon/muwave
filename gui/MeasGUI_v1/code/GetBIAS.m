function BIAS = GetBIAS(handles)
% resave measurement info
DC1 = handles.instr.measure_dc1;
DC2 = handles.instr.measure_dc2;

BIAS.V1 = []; 
BIAS.V2 = []; 
BIAS.I1 = []; 
BIAS.I2 = [];

BIAS.REGION = [];

BIAS.NUMPOINTS = 1; % set to at least one bias point

for Idx = 1:handles.num_regions
    % read out each bias region
    if DC1
        v1 = handles.bias.v1{Idx};
        i1 = handles.bias.i1{Idx};
        p1 = handles.bias.p1{Idx};
    end
    if DC2
        v2 = handles.bias.v2{Idx};
        i2 = handles.bias.i2{Idx};
        p2 = handles.bias.p2{Idx};
    end
    
    % generate bias grid
    if DC1 && DC2
        [v1 v2] = meshgrid(v1,v2);
        v1 = v1(:);
        v2 = v2(:);
        i1 = i1.*ones(length(v1),1);
        i2 = i2.*ones(length(v2),1);
        if p1 > 0 % port 1 power compliance
            pcomp_ix = find(abs(i1.*v1) > p1);
            i1(pcomp_ix) = abs(p1./v1(pcomp_ix));
        end
        if p2 > 0 % port 2 power compliance
            pcomp_ix = find(abs(i2.*v2) > p2);
            i2(pcomp_ix) = abs(p2./v2(pcomp_ix));
        end
        % append each region to the complete bias list
        BIAS.V1 = [BIAS.V1; v1];
        BIAS.I1 = [BIAS.I1; i1];
        BIAS.V2 = [BIAS.V2; v2];
        BIAS.I2 = [BIAS.I2; i2];
        
        % append witch region the grid belongs to
        BIAS.REGION = [BIAS.REGION; Idx.*ones(length(v1),1)];
        
        % update number of biaspoints
        BIAS.NUMPOINTS = length(BIAS.V1);
    elseif DC1 && ~DC2
        v1 = v1(:);
        i1 = i1.*ones(length(v1),1);
        if p1 > 0 % port 1 power compliance
            pcomp_ix = find(abs(i1.*v1) > p1);
            i1(pcomp_ix) = abs(p1./v1(pcomp_ix));
        end
        % append each region to the complet bias list
        BIAS.V1 = [BIAS.V1; v1];
        BIAS.I1 = [BIAS.I1; i1];
        
        % append witch region the grid belongs to
        BIAS.REGION = [BIAS.REGION; Idx.*ones(length(v1),1)];
        
        % update number of biaspoints
        BIAS.NUMPOINTS = length(BIAS.V1);
    elseif ~DC1 && DC2
        v2 = v2(:);
        i2 = i2.*ones(length(v2),1);
        if p2 > 0 % port 2 power compliance
            pcomp_ix = find(abs(i2.*v2) > p2);
            i2(pcomp_ix) = abs(p2./v2(pcomp_ix));
        end
        % append each region to the complet bias list
        BIAS.V2 = [BIAS.V2; v2];
        BIAS.I2 = [BIAS.I2; i2];
        
        % append witch region the grid belongs to
        BIAS.REGION = [BIAS.REGION; Idx.*ones(length(v2),1)];
        
        % update number of biaspoints
        BIAS.NUMPOINTS = length(BIAS.V2);
    end
end