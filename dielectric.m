decades = 5;
filename = 'dielectric_1';
fid = fopen(filename,'rb');
size_y = 12000;
size_x = 2000;
data1 = reshape(fread(fid,size_x*size_y,'single'),size_x,size_y);
fclose(fid);
fig = figure('units','normalized','outerposition',[0 0.25 1 0.5],'color','white');
%fig = figure('Position', [1 1 2000 600],'color','white');
x = linspace(0,100,12000);
y = linspace(0,17,2000);
Mx = max(x);
My = max(y);
mx = min(x);
my = min(y);
nx = [5e-2 50 linspace(50,100,6000)];
m = size_y - length(nx);
data = [zeros(size_x,length(nx))];
for i = 1:size_x
    for j = 5999:size_y
        data(i,j-m) = data1(i,j);
    end
end
%drawbrace([mx+1 My],[50 My],5,'Color', 'k') ;
h1=drawbrace([mx My],[50 My], 0.8, 'Color', 'k'); 
%hold on;
h2=drawbrace([50 My],[83.3 My],0.8,'Color', 'k') ;
h3=drawbrace([83.3,My],[Mx,My],0.8,'Color', 'k') ;
h = gca;
hold on;
% %axis([0 Mx 0 My+10]);
axis([0 Mx 0 My+10]);
set(h1,'clipping','off');
set(h2,'clipping','off');
set(h3,'clipping','off');
%h.Position = [0.04 -0.06 0.93 1];
set(h,'Position',[0.04 -0.06 0.93 1]);
text(25, 19,'Water',...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center','FontSize',20);
text(66.5, 19,{'Epineurium','with elastic fibres'},...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center','FontSize',20);
text(91.5, 19,'Nerve fibres',...
   'VerticalAlignment','bottom',...
   'HorizontalAlignment','center','FontSize',20);
axis on;
box on;
%pcolor(x(10:size_y-10),y,data1(:,10:size_y-10));
pcolor(nx(1:length(nx)),y,data(:,(1:length(nx))));
shading interp;
axis equal;
ylim([0 17])
xlabel('x (\mum)');
ylabel('y (\mum)');
% t = title('Simulation geometry');
% P = get(t,'Position');
% set(t,'Position',[P(1) P(2)+10 P(3)]);
set(gca,'fontsize',24)
set(gca,'YColor','k')
set(gca,'XColor','k')
%set(gca,'layer','top')
fclose('all');