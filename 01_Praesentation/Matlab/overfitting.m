  close all;

  N = 20;
  %R = randn(N,1)+2; R(end) = R(1);
  x = linspace(0,2,N).';
  y = (x-1).^3 + 1;
  data = y+0.5*randn(N,1)+(-1).^(randn(N,1)>0.5)*0.1 ;
  
  d = data > y;
  y1 = data(d);
  y2 = data(~d);
  x1 = x(d);
  x2 = x(~d);
  
  p1 = polyfit(x,data,1);
  p2 = polyfit(x,data,3);
  p3 = polyfit(x,data,19);
  
  baseURL = '/Users/michaeldorner/Dropbox/Entscheidungsbaeume/Praesentation/src/';

  figure(1), plot(x, y, 'g--', x1, y1, 'b+', x2, y2, 'bo' );   
  set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
  set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
  xlabel('$x$');
  ylabel('$y$');
  
  name = 'actualSample';    
  matlab2tikz([baseURL name '.tikz'], 'height', '\figureheight', 'width', '\figurewidth');
  
  
  
  figure(2), plot(x, y, 'g--', x1, y1, 'b+', x2, y2, 'bo', x, polyval(p1,x), 'r-'); 
  
  set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
  set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
  xlabel('$x$');
  ylabel('$y$');
  
  name = 'underfittingSample';    
  matlab2tikz([baseURL name '.tikz'], 'height', '\figureheight', 'width', '\figurewidth')
  
  
  figure(3), plot(x, y, 'g--', x1, y1, 'b+', x2, y2, 'bo', x, polyval(p2,x),'r-'); 

  set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
  set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
  xlabel('$x$');
  ylabel('$y$');
  
  name = 'goodfittingSample';    
  matlab2tikz([baseURL name '.tikz'], 'height', '\figureheight', 'width', '\figurewidth')
  
  
  figure(4), plot(x, y, 'g--', x1, y1, 'b+', x2, y2, 'bo', x, polyval(p3,x),'r-'); 
  
  %legend('actual splitting line', 'class 1', 'class 2', 'found splitting line', 'Location', 'northwest');
  set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
  set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
  xlabel('$x$');
  ylabel('$y$');
  
  name = 'overfittingSample';    
  matlab2tikz([baseURL name '.tikz'], 'height', '\figureheight', 'width', '\figurewidth')
  
  
