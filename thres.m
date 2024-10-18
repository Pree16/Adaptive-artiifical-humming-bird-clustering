function [T, W] = thres(m, X)
    % Calculate Distance Matrix between data points and cluster centers
    d = pdist2(X, m);
    
    % Assign data points to the nearest cluster and get the minimum distances
    [dmin, ind] = min(d, [], 2);

    % Initialize Weights
    W = zeros(1, size(m, 1));

    % Calculate weight for each cluster based on the assigned points
    for i = 1:size(m, 1)
        % Ensure cluster i has at least one assigned point
        if sum(ind == i) > 0
            % Calculate the weight for cluster i based on the average distance of points assigned to it
            W(i) = sqrt(sum(dmin(ind == i)) / size(dmin(ind == i), 1));
        else
            % Set weight to NaN or a large value if no points are assigned to avoid division by zero
            W(i) = NaN;
        end
    end

    % Compute the threshold as the mean of the weights, ignoring NaN values
    T = nanmean(W);
end