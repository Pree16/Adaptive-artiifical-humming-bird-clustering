clc;
clear;
close all;

%% Problem Definition
data = load('sample.mat');
X = data.X;
k = 7;

X = normalize(X, 'norm');
runs = 2;
dim = size(X, 2);

for l = 1:runs
    tic
    CostFunction = @(s) ClusteringCost_auto_threshold(s, X);  % Cost Function
    VarSize = [k size(X, 2) + 1];  % Decision Variable
    numP = size(X, 1);
    Dim = dim + 1;

    VarMin = repmat([min(X) 0], k, 1);  % Lower Bound of Variables
    VarMax = repmat([max(X) 1], k, 1);  % Upper Bound of Variables

    %% AHA Parameters
    MaxIt = 200;  % Maximum Number of Iterations
    nPop = 30;  % Population Size

    %% Initialization
    empty_bird.Position = [];
    empty_bird.Cost = [];
    empty_bird.Out = [];

    bird = repmat(empty_bird, nPop, 1);
    Newbird = repmat(empty_bird, 1, 1);
    BestSol.Cost = inf;

    % Initialize Population
    for i = 1:nPop
        bird(i).Position = unifrnd(VarMin, VarMax, VarSize);
        [bird(i).Cost, bird(i).Out] = CostFunction(bird(i).Position);
        if bird(i).Cost <= BestSol.Cost
            BestSol = bird(i);
        end
    end

    HisBestFit = zeros(MaxIt, 1);
    VisitTable = zeros(nPop);
    VisitTable(logical(eye(nPop))) = NaN;

    for It = 1:MaxIt
        DirectVector = zeros(nPop, Dim);

        for i = 1:nPop
            % Choose Direction Vector
            r = rand;
            if r < 1/3
                RandDim = randperm(Dim);
                if Dim >= 3
                    RandNum = ceil(rand * (Dim - 2) + 1);
                else
                    RandNum = ceil(rand * (Dim - 1) + 1);
                end
                DirectVector(i, RandDim(1:RandNum)) = 1;
            elseif r > 2/3
                DirectVector(i, :) = 1;
            else
                RandNum = ceil(rand * Dim);
                DirectVector(i, RandNum) = 1;
            end

            % Guided foraging
            if rand < 0.5
                [MaxUnvisitedTime, TargetFoodIndex] = max(VisitTable(i, :));
                MUT_Index = find(VisitTable(i, :) == MaxUnvisitedTime);
                if length(MUT_Index) > 1
                    [~, Ind] = min([bird(MUT_Index).Cost]);
                    TargetFoodIndex = MUT_Index(Ind);
                end
                Newbird.Position = bird(TargetFoodIndex).Position + randn * DirectVector(i, :) .* (bird(i).Position - bird(TargetFoodIndex).Position);
                Newbird.Position = SpaceBound(Newbird.Position, VarMax, VarMin, Dim);
                [Newbird.Cost, Newbird.Out] = CostFunction(Newbird.Position);

                if Newbird.Cost < bird(i).Cost
                    bird(i) = Newbird;
                    VisitTable(i, :) = VisitTable(i, :) + 1;
                    VisitTable(i, TargetFoodIndex) = 0;
                    VisitTable(:, i) = max(VisitTable, [], 2) + 1;
                    VisitTable(i, i) = NaN;
                else
                    VisitTable(i, :) = VisitTable(i, :) + 1;
                    VisitTable(i, TargetFoodIndex) = 0;
                end
            else
                Newbird.Position = bird(i).Position + randn * DirectVector(i, :) .* bird(i).Position;
                Newbird.Position = SpaceBound(Newbird.Position, VarMax, VarMin, Dim);
                [Newbird.Cost, Newbird.Out] = CostFunction(Newbird.Position);

                if Newbird.Cost < bird(i).Cost
                    bird(i) = Newbird;
                    VisitTable(i, :) = VisitTable(i, :) + 1;
                    VisitTable(:, i) = max(VisitTable, [], 2) + 1;
                    VisitTable(i, i) = NaN;
                else
                    VisitTable(i, :) = VisitTable(i, :) + 1;
                end
            end
        end

        if mod(It, 2 * nPop) == 0
            [~, MigrationIndex] = max([bird.Cost]);
            bird(MigrationIndex).Position = rand(1, Dim) .* (VarMax - VarMin) + VarMin;
            [bird(MigrationIndex).Cost, bird(MigrationIndex).Out] = CostFunction(bird(MigrationIndex).Position);
            VisitTable(MigrationIndex, :) = VisitTable(MigrationIndex, :) + 1;
            VisitTable(:, MigrationIndex) = max(VisitTable, [], 2) + 1;
            VisitTable(MigrationIndex, MigrationIndex) = NaN;
        end

        for i = 1:nPop
            if bird(i).Cost <= BestSol.Cost
                BestSol = bird(i);
            end
        end

        HisBestFit(It) = BestSol.Cost;
    end

    %% Saving Results
    pred_Y = BestSol.Out.ind;
    si = size(BestSol.Out.m, 1);
    timeElapsed = toc;

    % Define Headers
    headers_main = {'Cost', 'Inter', 'Intra', 'TimeElapsed', 'k', 'Threshold'};
    headers_ind = {'Indices'};
    headers_weights = {'Weights'};

    % Save Results with Headers
    writecell(headers_main, 'AHO_main.xlsx', 'Sheet', 1, 'Range', 'A1');
    writematrix([BestSol.Cost, BestSol.Out.inter, BestSol.Out.intra, timeElapsed, si, BestSol.Out.Threshold], 'AHO_main.xlsx', 'Sheet', 1, 'Range', sprintf('A%d', l + 1));

    writematrix(transpose(HisBestFit), 'AHO_convergence.xlsx', 'Sheet', 1, 'Range', sprintf('A%d', l));

    filename = ['AHA_Cluster_Centre', num2str(l), '.xlsx'];
    writematrix(BestSol.Out.m, filename, 'Sheet', 1, 'Range', 'A1');

end
