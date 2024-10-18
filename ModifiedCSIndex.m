function [CS, out] = ModifiedCSIndex(m, X)

    k = size(m,1);  % Number of clusters
    n = size(X,1);  % Number of data points
    
    % Calculate the distance matrix between data points and cluster centers
    d = pdist2(X, m);
    
    % Assign data points to the nearest cluster and store minimum distances
    [dmin, ind] = min(d, [], 2);

    % Compute maximum intra-cluster distances
    dmax = zeros(n,1);
    dxx = pdist2(X,X);
    for p = 1:n
        dmax(p) = max(dxx(p, ind == ind(p)));
    end
    
    % Calculate the average intra-cluster distance for each cluster
    dbar = zeros(k,1);
    for i = 1:k
        if sum(ind == i) > 0
            dbar(i) = mean(dmax(ind == i));
            m(i,:) = mean(X(ind == i,:));  % Update cluster centers based on data points
        else
            dbar(i) = 10 * norm(max(X) - min(X));  % Handle empty clusters
        end
    end
    
    % Calculate the inter-cluster distances
    D = pdist2(m, m);
    for i = 1:k
        D(i,i) = inf;  % Ignore self-distances by setting them to infinity
    end
    Dmin = min(D);  % Minimum inter-cluster distance

    % Sort the cluster centers for further processing
    m1 = sort(m);
    new_m = diff(m1);  % Differences between consecutive cluster centers
    
    % Replace inf and NaN values in the distance matrix for further calculations
    D(isinf(D) | isnan(D)) = 0;
    Dmax = max(D);  % Maximum inter-cluster distance

    % Calculate the clustering similarity index
    CS = mean(dbar) / mean(Dmin);

    % Store additional outputs for analysis
    inter = sum(dmin);
    intra = sum(Dmax);
    out.d = d;
    out.dmin = dmin;
    out.ind = ind;
    out.CS = CS;
    out.dmax = dmax;
    out.Dmax = Dmax;
    out.dbar = dbar;
    out.D = D;
    out.Dmin = Dmin;
    out.m = m;
    out.inter = inter;
    out.intra = intra;
    out.m1 = m1;
    out.new_m = new_m;
end
