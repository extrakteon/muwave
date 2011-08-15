 function [Lg Ld Ls Rd Rs] = ...
     ParasiticLR(fwd_swp,Rg,Rc,Cpg,Cpd,idxLF1,idxLF2,idxHF1,idxHF2,max_iteration,plotmode)
%% Starting values & parameteters
Lg = 0;
Ld = 0;
Rdy_in = 0;
Cg_in = 0;
dLg = 0;
Ri = 0;

Rd_array = [];
Rs_array = [];
Lg_array = [];
Ld_array = [];
Ls_array = [];
Ri_array = [];
Rdy_array =[];
Cg_array =[];
dLg_array =[];


%% Iterations
for k=1:max_iteration
    % Remove pad parasitics
    deembedded = DeembedExtrinsic(fwd_swp,Cpg,Cpd,Lg,Ld,0,0,0,0,0);
    % Extract parasitics
    [Cg_out dLd dLg Ls Rd Rdy_out dRi Rs] = ...
        ExtractExtrinsic(deembedded,Rc,Rg,Ri,dLg,Rdy_in,Cg_in,idxLF1,idxLF2,idxHF1,idxHF2,k);
    Ld = Ld+dLd;
    Ld_array = [Ld_array Ld];
    Ls_array = [Ls_array Ls];
    Rd_array = [Rd_array Rd];
    Rs_array = [Rs_array Rs];
    
    if mod(k,2) ==1 % Odd(1,3, 5,...)
        Cg_in = Cg_out;
        Cg_array = [Cg_array Cg_out];
        Rdy_in = Rdy_out;
        Rdy_array = [Rdy_array Rdy_out];
    end
    if mod(k,2)==0 % Even (2,4,6,...)
        Lg=Lg+dLg;
        dLg_array =[dLg_array dLg];
        Lg_array = [Lg_array Lg];
        Ri = dRi;
        Ri_array = [Ri_array Ri];
        
        %Finished?
        if (abs(dLg*1e12)<0.01 && abs(dLg*1e12)<0.01)
            break
        end
    end
end
if plotmode
    PlotExtrinsicParameters(Rs_array,Ls_array,Rd_array,Ld_array,Ri_array,Lg_array,dLg_array)
end