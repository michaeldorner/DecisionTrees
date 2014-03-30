function loadingModel
    [trainAccelerationLevel, ...
        trainMotionType, ...
        testAccelerationLevel, ...
        testMotionType, ...
        normAccelerationLevel, ...
        normMotionType] = loadData;  
%     
     tree = ClassificationTree.fit(normAccelerationLevel', normMotionType', 'prune', 'on', 'PredictorNames', {'AL', 'SP'});   
     tree.predict(
     plotTree(tree, 'perfTree')
        


    
    %overfittingExample();
    %pruningExample();
    %optimizationExample();
    
    
%     neuralNetwork = patternnet(7);   
%     
%     %neuralNetwork.trainParam.showWindow = true;
%     %neuralNetwork.divideFcn = 'divideblock';
%     
%     target = zeros(4, length(normMotionType));
%     for i = 1:length(normMotionType)
%         switch normMotionType{i}
%             case 'stationary'
%                 target(:, i) = [1 0 0 0]';
%             case 'moving'
%                 target(:, i) = [0 1 0 0]';
%             case 'bike'
%                 target(:, i) = [0 0 1 0]';
%             case 'car'
%                 target(:, i) = [0 0 0 1]';
%         end
%     end
%     
%     
%     
%     [net, tr] = train(neuralNetwork, normAccelerationLevel, target);
% 
%     y = net(selectedInputMatrix);
%     performance = perform(net, target, y); 
%     [c,cm,ind,per] = confusion(target, y)
    





end


function overfittingExample
    [trainAccelerationLevel, ...
        trainMotionType, ...
        testAccelerationLevel, ...
        testMotionType, ...
        normAccelerationLevel, ...
        normMotionType] = loadData;
    
    % overfitting
    % ------------
    l = 60;
    leafs = logspace(1,2.6,l);
    leafs = leafs(end:-1:1);
    %leafs = zeros(l,1);
    accuracyTrain = zeros(l,1);
    accuracyTest = zeros(l,1);
    for n = 1:l
        tree = ClassificationTree.fit(trainAccelerationLevel', trainMotionType', 'prune', 'off', 'PredictorNames', {'AL', 'SP'}, 'MergeLeaves', 'off', 'MinLeaf', leafs(n));
        prediction = tree.predict(trainAccelerationLevel');
        C = confusionmat(trainMotionType', prediction);
        C = C./repmat(sum(C,2),1,size(C,2));
        C = C*100;
        accuracyTrain(n) = (C(1,1)+C(2,2)+C(3,3)+C(4,4))/4;
            
        prediction = tree.predict(testAccelerationLevel');
        C = confusionmat(testMotionType', prediction);
        C = C./repmat(sum(C,2),1,size(C,2));
        C = C*100;
        accuracyTest(n) = (C(1,1)+C(2,2)+C(3,3)+C(4,4))/4;
        
        leafNumbers(n) = tree.NumNodes;
    end
    
    [x, invx] = unique(leafNumbers);
    y1 = accuracyTrain(invx);
    y2 = accuracyTest(invx);
    f1 = figure(1);
    hold on; 
    %r = 1:40;
    plot(x(), y1(), 'r')
    plot(x(), y2(), 'b')
    hold off;
    legend('Training', 'Test', 'location', 'NorthWest');
    
    name = 'overfitting';
    baseURL = '/Users/michaeldorner/Dropbox/Entscheidungsbaeume/Praesentation/src/';
    matlab2tikz([baseURL name '.tikz'], 'height', '\figureheight', 'width', '\figurewidth')
    
    
    
%     leafs = logspace(1,2,10);
%     N = numel(leafs);
%     err = zeros(N,1);
%     for n = 1:N
%         t = ClassificationTree.fit(normAccelerationLevel', normMotionType', 'crossval', 'on', 'minleaf',leafs(n));
%         err(n) = kfoldLoss(t);
%     end
%     plot(leafs,err);
%     xlabel('Min Leaf Size');
%     ylabel('cross-validated error');
end

function optimizationExample

    [trainAccelerationLevel, ...
        trainMotionType, ...
        testAccelerationLevel, ...
        testMotionType, ...
        normAccelerationLevel, ...
        normMotionType] = loadData;  
    
    tree = ClassificationTree.fit(trainAccelerationLevel', trainMotionType', 'prune', 'off', 'PredictorNames', {'AL', 'SP'}, 'MinLeaf', 1);
    [~,~,~,bestlevel] = cvLoss(tree, 'subtrees', 'all', 'treesize', 'min');
    
    for prune = 1:bestlevel+1
        pTree{prune} = tree.prune('level', prune-1);
        
        prediction = pTree{prune}.predict(trainAccelerationLevel');
        C = confusionmat(trainMotionType', prediction);
        C = C./repmat(sum(C,2),1,size(C,2));
        C = C*100;
        accuracyTrain(prune) = (C(1,1)+C(2,2)+C(3,3)+C(4,4))/4;
        
        prediction = pTree{prune}.predict(testAccelerationLevel');
        C = confusionmat(testMotionType', prediction);
        C = C./repmat(sum(C,2),1,size(C,2));
        C = C*100;
        accuracyTest(prune) = (C(1,1)+C(2,2)+C(3,3)+C(4,4))/4;
    end
    
    figure(2)
    hold on;
    plot(1:bestlevel+1, accuracyTrain, 'r');
    plot(1:bestlevel+1, accuracyTest, 'b');
    hold on;
end


function pruningExample
    [trainAccelerationLevel, ...
        trainMotionType, ...
        testAccelerationLevel, ...
        testMotionType, ...
        normAccelerationLevel, ...
        normMotionType] = loadData;
    
    % unpruned
    tree = ClassificationTree.fit(trainAccelerationLevel', trainMotionType', 'prune', 'off', 'PredictorNames', {'AL', 'SP'}, 'MinLeaf', 1);
    
    prediction = tree.predict(testAccelerationLevel');
    C = confusionmat(testMotionType', prediction);
    C = C./repmat(sum(C,2),1,size(C,2));
    C = C*100;
    a = (C(1,1)+C(2,2)+C(3,3)+C(4,4))/4
    plotTree(tree, 'fullTree');
    
    % pruned 
    [~,~,~,bestlevel] = cvLoss(tree, 'subtrees', 'all', 'treesize', 'min');

    prunedTree = tree.prune('level', bestlevel);
    prediction = prunedTree.predict(testAccelerationLevel');
    C = confusionmat(testMotionType', prediction);
    C = C./repmat(sum(C,2),1,size(C,2));
    C = C*100;
    a = (C(1,1)+C(2,2)+C(3,3)+C(4,4))/4   
    
    
    plotTree(prunedTree, 'bestTree');
end

function [trainAccelerationLevel, trainMotionType, testAccelerationLevel, testMotionType, normAccelerationLevel, normMotionType] = loadData
    load accelerationLevel;
    load motionType;
    
    isStationary = strcmp(motionType, 'stationary');
    isMoving = strcmp(motionType, 'moving');
    isBike = strcmp(motionType, 'bike');
    isCar = strcmp(motionType, 'car');
    
    % normalizing
    % AL = Acceleration Level
    % MT = Motion Type
    
    stationaryAL = accelerationLevel(:, isStationary);
    movingAL = accelerationLevel(:, isMoving);
    bikeAL = accelerationLevel(:, isBike);
    carAL = accelerationLevel(:, isCar);
    
    stationaryMT = motionType(:, isStationary);
    movingMT = motionType(:, isMoving);
    bikeMT = motionType(:, isBike);
    carMT = motionType(:, isCar);
    
    selStationary = randsample(length(stationaryAL), 876);
    selMoving = randsample(length(movingAL), 876);
    % all bike samples
    selCar = randsample(length(carAL), 876);
        
    normAccelerationLevel = [ stationaryAL(:, selStationary) movingAL(:, selMoving) bikeAL carAL(:, selCar) ];
    normMotionType = [ stationaryMT(:, selStationary) movingMT(:, selMoving) bikeMT carMT(:, selCar) ];
    
    
    firstSelection = rand(length(normAccelerationLevel), 1) <= 0.7;
    trainAccelerationLevel = normAccelerationLevel(:, firstSelection);
    trainMotionType = normMotionType(:, firstSelection);

    restAccelerationLevel = normAccelerationLevel(:, ~firstSelection);     
    restMotionType = normMotionType(:, ~firstSelection);

    secondSelection = rand(length(restAccelerationLevel), 1) >= 0.0;
    testAccelerationLevel = restAccelerationLevel(:, secondSelection);
    testMotionType = restMotionType(:, secondSelection);

    verificationAccelerationLevel = restAccelerationLevel(:, ~secondSelection); 
    verificationMotionType = restMotionType(:, ~secondSelection); 
end


