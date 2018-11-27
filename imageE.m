function [data] = imageE(filename,z_norm,decades,cmap)
% raw2image Creates a plot from a "raw" file.
%
% The absolute value of the data is used together with logarithmic
% scaling.  The user may specify one to four arguments.
% raw2image(filename,z_norm,decades,cmap) or
% raw2image(filename,z_norm,decades) or
% raw2image(filename,z_norm) or
% raw2image(filename).
%
% filename = name of data file
% z_norm   = value used to normalize data, typically this
%            would be the maximum value.
%            Default value is 1.
% decades  = decades to be used in the display.  The normalized
%            data is assumed to vary between 1.0 and 10^(-decades)
%            so that after taking the log (base 10), the values
%            vary between 0 and -decades.  Default value is 3.
% cmap     = colormap to apply.
%
% raw file format:
% Raw files are assumed to consist of all floats (in binary
% format).  The first two elements specify the horizontal and vertical
% dimensions.  Then the data itself is given in English book-reading
% order, i.e., from the upper left corner of the image and then
% scanned left to right.

% set defaults if we have less than four arguments
if nargin < 4, cmap=jet(128); end
if nargin < 3, decades=3; end
if nargin < 2, z_norm=1e6; end

% open the first frame
fid = fopen(filename,'rb');
if fid == -1
  error(['raw2image: could not open data file ',filename])
end

% determine image size
size_y = fread(fid,1,'single');
size_x = fread(fid,1,'single');
fig = figure('units','normalized','outerposition',[0 0.25 1 0.5],'color','white');
set(gcf,'doublebuffer','on');
x = linspace(0,100,size_y);
y = linspace(0,17,size_x);
Mx = max(x);
My = max(y);
mx = min(x);
my = min(y);
%drawbrace([mx+1 My],[50 My],5,'Color', 'k') ;
h1=drawbrace([mx+1 My],[50 My], 0.8, 'Color', 'k'); 
%hold on;
h2=drawbrace([50 My],[84 My],0.8,'Color', 'k') ;
h3=drawbrace([84,My],[Mx,My],0.8,'Color', 'k') ;
h = gca;
axis([1 Mx 1 My+8.5]);
%set(gca,'ytick',[])
%set(gca,'YColor','w')
set(h1,'clipping','off');
set(h2,'clipping','off');
set(h3,'clipping','off');
%h.Position = [0.04 -0.06 0.93 1];
set(h,'Position',[0.04 -0.06 0.93 1]);
text(25.5, 19,'Water',...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center','FontSize',20);
text(67, 19,{'Endonerium','with elastic fibers'},...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center','FontSize',20);
text(92, 19,'Nerve fibers',...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center','FontSize',20)
% t = title('Electric field reflection for inactive nerve');
% P = get(t,'Position');
% set(t,'Position',[P(1) P(2)-4 P(3)]);
hold on;

% read data
data = flipud((reshape(fread(fid,size_x*size_y,'single'),size_x,size_y)));
size(data)
  pcolor(x,y,log10(abs((data+realmin)/z_norm)));
  shading flat;
  axis equal;
  %h2.Box = 'off';
  ylim([0 17]);
  %axis([1 Mx 1 My+2]);   
  caxis([-decades 0]);
  colormap(cmap);
  colorbar
  xlabel('x (\mum)');
  ylabel('y (\mum)');
%  set(h2, 'YTick', [0:5:15], 'YTickLabel', [0 5 10 15])
  hold on;
  plot(50*ones(1,size(y,2)),y,'w','LineWidth',2);
  plot(84*ones(1,size(y,2)),y,'w','LineWidth',2);
set(gca,'fontsize',18)
fclose('all');
  hold off;
return;