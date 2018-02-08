
[num_time, num_data] = size(HI_Np);

for i = 1:num_time
    for j = 1:num_data
        % For HI_Np
        if HI_Np(i,j)> 0
            HI_Np_log10(i,j) = log10(HI_Np(i,j));
        elseif HI_Np(i,j)< 0
            HI_Np_log10(i,j) = (-1)*log10(abs(HI_Np(i,j)));
        else
            HI_Np_log10(i,j) = NaN;
        end
        % For HI_Wp
        if HI_Wp(i,j)> 0
            HI_Wp_log10(i,j) = log10(HI_Wp(i,j));
        elseif HI_Wp(i,j)< 0
            HI_Wp_log10(i,j) = (-1)*log10(abs(HI_Wp(i,j)));
        else
            HI_Wp_log10(i,j) = NaN;
        end
    end
end

% % % Colors by cluster or Chan plot flag
cc = [1 0 0; 0.8 0.68 0.08; 0 0.95 0.2; 0 0.05 0.88; 0.8 0 1];
figure;
gscatter(HI_Np_log10(num_time,:), HI_Wp_log10(num_time,:), ChanPlotFlag, cc, '+');
xlabel('HI.Oil');
ylabel('HI.Water');
grid on;
