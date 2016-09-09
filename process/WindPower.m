function [P] = WindPower(V,Table,cutin,cutoff)
%  This function uses a look-up table to interpolate linearly a power 
%  curve value for a wind turbine.
%--------------------------------------------------------------------------
for i = 1:length(V)
    
    if (V(i) < min(Table(1,1))) | (V(i) > max(Table(length(Table(:,1)),1)))
        %disp('Wind velocity outside table range');
    %----------------------------------------------------------------------
    elseif V(i) <= Table(2,1)
        P(i) = Table(1,2)+((Table(2,2)-Table(1,2))*((V(i)- ...
            Table(1,1))/(Table(2,1)-Table(1,1))));
    %----------------------------------------------------------------------
    elseif V(i) > Table((length(Table(:,1))-1),1)
        P(i) = Table((length(Table(:,1))-1),2)+ ...
         ((Table(length(Table(:,1)),2)- ...
         Table((length(Table(:,1))-1),2))*((V(i)- ...
         Table((length(Table(:,1))-1),1))/(Table(length(Table(:,1)),1)- ...
         Table((length(Table(:,1))-1),1))));
    %----------------------------------------------------------------------    
    else
        for j = 2:(length(Table(:,1))-2)
            if (V(i) > Table(j,1)) & (V(i) <= Table(j+1,1))
                P(i) = Table(j,2)+((Table(j+1,2)-Table(j,2))*((V(i) ...
                    - Table(j,1))/(Table(j+1,1)-Table(j,1))));
                break
            end
        end
    %----------------------------------------------------------------------    
    end
    if (V(i) < cutin) | (V(i) > cutoff)
        P(i) = 0;
    end
    
end