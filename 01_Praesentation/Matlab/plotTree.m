function plotTree(varargin)
    tree = varargin{1};
    %load tree;
    p = tree.Parent';
    c = tree.Children';
    
    [x,y,h] = treelayout(p);

    f = find(p~=0);
    pp = p(f);
    %X = [x(f); x(pp); NaN(size(f))];
    %Y = [y(f); y(pp); NaN(size(f))];      
    X = [x(f); x(pp)];
    Y = [y(f); y(pp)];    

    figure, plot (x, y, 'ro', X, Y, 'r-');
    axis off;
    if nargin > 1
        name = varargin{2};
        % settings
        baseURL = '/Users/michaeldorner/Dropbox/Entscheidungsbaeume/Praesentation/src/';
        matlab2tikz([baseURL name '.tikz'], 'height', '\figureheight', 'width', '\figurewidth')
        h
    end
end 
    

