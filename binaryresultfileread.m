function binaryresultfileread(filename,plot_yn)
fid = fopen(filename,'rb');
binaryfileread = fread(fid,inf,'single');
size_y = 200;
size_t = size(binaryfileread,1)/size_y;
data = reshape(binaryfileread,size_y,size_t);
Sc = 1/sqrt(2);
dx = 8.5e-9;
c = 3e8;
dt = Sc*dx/c*10;
if nargin < 2 return
else
    if plot_yn == 'y'
        t = linspace(0,dt*size_t,size_t);
        y = linspace(0,17,size_y);
        fig = figure('units','normalized','outerposition',[0 0.25 1 0.5],'color','white');
        pcolor(t,y,log10(abs((data+realmin)/1e6)));
        shading flat;
        caxis([-3 0]);
        colormap(jet(128));
        xlabel('t (s)');
        ylabel('y (\mum)');
        else return
    end
fclose(fid);
end