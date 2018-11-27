function [data_i,data_a,data_m]=datacreation(w)
%fid = fopen(sprintf('sugar_%s',w),'rb');
fid = fopen(sprintf('%dobs_i',w),'rb');
a = fread(fid,inf,'single');
size_y = size(a,1)/200;
size_x = 200;
data_i = reshape(a,size_x,size_y);
fclose(fid);
% fid = fopen(sprintf('sugar_%s',w),'rb');
fid = fopen(sprintf('%dobs_a',w),'rb');
a = fread(fid,inf,'single');
size_y = size(a,1)/200;
size_x = 200;
data_a = reshape(a,size_x,size_y);
data_a = data_a(:,1:6000);
fclose(fid);

%filename3 = 'mirror/tobs';
% fid = fopen(sprintf('%dobs_m',w),'rb');
% a = fread(fid,inf,'single');
% size_y = size(a,1)/200;
% size_x = 200;
% data_m = reshape(a,size_x,size_y);
%fid = fopen(sprintf('%dobs_a',w),'rb');
%fid = fopen('sugar_mirror','rb');
[~,data_m] = tobsread(sprintf('%dobs_m',w));
fclose('all');
end