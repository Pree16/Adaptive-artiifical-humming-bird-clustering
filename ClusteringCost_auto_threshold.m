function [z, out] = ClusteringCost_auto_threshold(s, X)

    % Extract the cluster centers (m) from the solution 's'
    m = s(:,1:end-1);
    
    % Compute the Threshold and Weights
    [Threshold, Weight] = thres(m, X);

    % Initialize weight vector 'a' with the weights (transposed)
    a = transpose(Weight);
    
    % Ensure there are at least two clusters retained
    if sum(a >= Threshold) < 2
        [~, SortOrder] = sort(a, 'descend');
        a(SortOrder(1:2)) = 1;  % Force the top two clusters to be retained
    end
    
    % Store the original weights, but set the ones below the threshold to zero
    final_weights = a;  % Initialize with original weights
    final_weights(a < Threshold) = 0;  % Set weights below the threshold to 0
    
    % Keep only clusters with weights greater than or equal to the threshold
    m_selected = m(a >= Threshold, :);  % Retain only the cluster centers above threshold
    
    % Calculate the clustering cost using the modified CSIndex
    [z, out] = ModifiedCSIndex(m_selected, X);

    % Store output information
    out.a = double(a >= Threshold);      % Binary vector indicating selected clusters
    out.Threshold = Threshold;           % Threshold value
    out.Weight = final_weights;          % Weight vector with zero for non-selected clusters
    out.a1 = transpose(Weight);          % Store all original weights for reference
    
end