function MostProductiveWells(case_data)

num_cases = length(case_data);
Time = case_data{1,1}.Tvar.Time.cumt;
TotalDaysIdx = length(Time);

for case_idx=1:num_cases    
    well_list = fieldnames(case_data{case_idx}.Tvar.Well);
    prod_well_list = well_list(contains(well_list, 'PRO'));
    num_prod_wells = length(prod_well_list);    
    for prod_well_idx=1:num_prod_wells
        prod_well_name = prod_well_list{prod_well_idx};
        Np(case_idx, prod_well_idx) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name, '.OilProductionCumulative.data(TotalDaysIdx)']);
        Wp(case_idx, prod_well_idx) = eval(['case_data{case_idx,1}.Tvar.Well.', prod_well_name, '.WaterProductionCumulative.data(TotalDaysIdx)']); 
    end    
end

[maxNp, maxNpidx] = max(Np, [], 2);
[maxWp, maxWpidx] = max(Wp, [], 2);

figure;
histogram(maxNpidx,'BinMethod','integers');
xlabel('Well number');
ylabel('Number of times ranked as best oil producer');

figure;
histogram(maxWpidx,'BinMethod','integers');
xlabel('Well number');
ylabel('Number of times ranked as highest water producer');

% figure;
% subplot(3,3,1);
% histogram(Np(:,1));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO1');
% subplot(3,3,2);
% histogram(Np(:,2));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO2');
% subplot(3,3,3);
% histogram(Np(:,3));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO3');
% subplot(3,3,4);
% histogram(Np(:,4));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO4');
% subplot(3,3,5);
% histogram(Np(:,5));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO5');
% subplot(3,3,6);
% histogram(Np(:,6));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO6');
% subplot(3,3,7);
% histogram(Np(:,7));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO7');
% subplot(3,3,8);
% histogram(Np(:,8));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO8');
% subplot(3,3,9);
% histogram(Np(:,9));
% xlabel('Np, STB');
% ylabel('Frequency');
% title('WPRO9');

end