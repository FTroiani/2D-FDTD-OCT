function [size_y,data_r] = tobsread(filename,plot_yn)
fid = fopen(filename,'rb');
a = fread(fid,inf,'single');
size_y = size(a,1)/200;
size_x = 200;
data1 = reshape(a,size_x,size_y);
data = data1(100,:);
%imagesc(data1/1e6);
% z_norm =1e6;
% pcolor(log10(abs((data1+realmin)/z_norm)))
%   shading flat;
% %  axis equal;
%   axis([1 size(data1,2) 1 size_x]);   
%   caxis([-4 0]);
%   colormap(jet(128));
%   colorbar
%plot(a)
a = find(data==max(data));
% for i=1:length(data)
%     if (data(i)>max(data)*1e-4) && (data(i)<a)
%         r1 = find(data == data(i));
%         break
%     end
% end
en = envelope(data);
f = fit((1:length(en))',en','gauss1');
r = floor(f.b1-3*f.c1):floor(f.b1+3*f.c1);
data_r = data1(:,r);
if nargin < 2 return
else
    if plot_yn == 'y'
        % plot((data)/max(data))
        subplot(2,1,1)
        plot(data)
        subplot(2,1,2)
        plot(r,data_r)
        hold on
        plot(r,en(r))
        plot(r,f(r))
        hold off
        else return
    end
%r = r+2000;
fclose('all');
end