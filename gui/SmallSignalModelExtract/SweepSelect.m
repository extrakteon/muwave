function swp_out = SweepSelect(swp,Vgs,Vds,all)

idx = find(round(swp.V1_SET.*100)./100 == Vgs & round(swp.V2_SET.*100)./100 == Vds);
if all ==0
        idx = idx(1);
else
    idx = idx;
end   
swp_out = swp(idx);





