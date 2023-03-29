%% Task execution setup file
% After checked input experiment parameters, set corresponding block numbers


for i = 1:task.runs
    
    if subject_run == i

    b_start = (task.blocksprun * (i-1))+1;         
    b_end = (task.blocksprun * i); 
    
    else
    end
    
end

clear i 