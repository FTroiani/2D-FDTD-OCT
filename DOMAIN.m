dx = 8.5e-9;
Dm = 1.5e-3;
size_y = 2000;

water = [175 221 255]/255;
peri = [147 112 219]/255;
ela = [65 105 225]/255;
endo = [205 246 205]/255;
fibre = [176 196 222]/255;


D = round(Dm/dx);
R = D/2;
df = 100;
XF = 10000;
dtheta = 1/R;
TH = pi/2;
w = 6000;
XM = D/2+w;
YM = 2000*9*2;
Re11 = R - 950;
Re12 = Re11 - df;
Re21 =  Re12 - 900;
Re22 = Re21 - df;
Re31 = Re22 - 900;
Re32 = Re31 - df;
Rf = R - 4000;
Rx = R - 2000;
x = 0:1199;
theta = linspace(0,2*pi,length(x));

xp = round(R*cos(theta)) + XM;
yp = round(R*sin(theta)) + YM;
%plot(xp,yp)
xe11 = round(Re11*cos(theta)) + XM;
ye11 = round(Re11*sin(theta)) + YM;
xe12 = round(Re12*cos(theta)) + XM;
ye12 = round(Re12*sin(theta)) + YM;
xe21 = round(Re21*cos(theta)) + XM;
ye21 = round(Re21*sin(theta)) + YM;
xe22 = round(Re22*cos(theta)) + XM;
ye22 = round(Re22*sin(theta)) + YM;
xe31 = round(Re31*cos(theta)) + XM;
ye31 = round(Re31*sin(theta)) + YM;
xe32 = round(Re32*cos(theta)) + XM;
ye32 = round(Re32*sin(theta)) + YM;
xf = round(Rf*cos(theta)) + XM;
yf = round(Rf*sin(theta)) + YM;
Xm = -Rf + 2000;
xq1 = -Rf*ones(1,length(xp)) + XM;
xq2 = Xm*ones(1,length(xp)) + XM;
XW = zeros(1,length(xp));
YDM = 2*YM*ones(1,length(xp));
YDm = zeros(1,length(xp));
XDm = linspace(0,Xm+XM,length(xp));

YiM = 3*YM;
Yim = -YM;
XiM = 1.9*XM;

index = find(yp<YiM & yp>Yim & xp<XiM);
xp1 = xp(index) - XM;
yp1 = yp(index) - YM;
thM = asin(YM/R);
thm = asin(-YM/R);
th = linspace(thm,thM,2*YM);
yp_2 = R*sin(th) + YM;
xp_2 = -R* cos(th) + XM;
clear thM thm th;

index1 = find(ye11<YiM & ye11>Yim & xe11<XiM);
xe11_1 = xe11(index1) - XM;
ye11_1 = ye11(index1) - YM;
thM = asin(YM/Re11);
thm = asin(-YM/Re11);
th = linspace(thm,thM,2*YM);
ye11_2 = Re11*sin(th) + YM;
xe11_2 = -Re11* cos(th) + XM;
clear thM thm th;

index2 = find(ye12<YiM & ye12>Yim & xe12<XiM);
xe12_1 = xe12(index2) - XM;
ye12_1 = ye12(index2) - YM;
thM = asin(YM/Re12);
thm = asin(-YM/Re12);
th = linspace(thm,thM,2*YM);
ye12_2 = Re12*sin(th) + YM;
xe12_2 = -Re12* cos(th) + XM;
clear thM thm th;

index3 = find(ye21<YiM & ye21>Yim & xe21<XiM);
xe21_1 = xe21(index3) - XM;
ye21_1 = ye21(index3) - YM;
thM = asin(YM/Re21);
thm = asin(-YM/Re21);
th = linspace(thm,thM,2*YM);
ye21_2 = Re21*sin(th) + YM;
xe21_2 = -Re21* cos(th) + XM;
clear thM thm th;

index4 = find(ye22<YiM & ye22>Yim & xe22<XiM);
xe22_1 = xe22(index4) - XM;
ye22_1 = ye22(index4) - YM;
thM = asin(YM/Re22);
thm = asin(-YM/Re22);
th = linspace(thm,thM,2*YM);
ye22_2 = Re22*sin(th) + YM;
xe22_2 = -Re22* cos(th) + XM;
clear thM thm th;

index5 = find(ye31<YiM & ye31>Yim & xe31<XiM);
xe31_1 = xe31(index5) - XM;
ye31_1 = ye31(index5) - YM;
thM = asin(YM/Re31);
thm = asin(-YM/Re31);
th = linspace(thm,thM,2*YM);
ye31_2 = Re31*sin(th) + YM;
xe31_2 = -Re31* cos(th) + XM;
clear thM thm th;

index6 = find(ye32<YiM & ye32>Yim & xe32<XiM);
xe32_1 = xe32(index6) - XM;
ye32_1 = ye32(index6) - YM;
thM = asin(YM/Re32);
thm = asin(-YM/Re32);
th = linspace(thm,thM,2*YM);
ye32_2 = Re32*sin(th) + YM;
xe32_2 = -Re32* cos(th) + XM;
clear thM thm th;

index7 = find(yf<YiM & yf>Yim & xf<XiM);
xf_1 = xf(index7) - XM;
yf_1 = yf(index7) - YM;
thM = asin(YM/Rf);
thm = asin(-YM/Rf);
th = linspace(thm,thM,2*YM);
yf_2 = Rf*sin(th) + YM;
xf_2 = -Rf* cos(th) + XM;

fig = figure('position',[100 -300 600 1200],'Color','white');
%fill([0 xp_2],[0 yp_2],'b');
plot(xp_2,yp_2,'k')

fill([xp_2 xe11_2],[yp_2 ye11_2],'c');
hold on
plot(xe11_2,ye11_2,'k')
fill([xe11_2 xe12_2],[ye11_2 ye12_2],'b');
plot(xe12_2,ye12_2,'k');
fill([xe12_2 xe21_2],[ye12_2 ye21_2],'c');
plot(xe21_2,ye21_2,'k');
fill([xe21_2 xe22_2],[ye21_2 ye22_2],'b');
plot(xe22_2,ye22_2,'k');
fill([xe22_2 xe31_2],[ye22_2 ye31_2],'c');
plot(xe31_2,ye31_2,'k');
fill([xe31_2 xe32_2],[ye31_2 ye32_2],'b');
plot(xe32_2,ye32_2,'k');
fill([xe32_2 xf_2],[ye32_2 yf_2],'c');
plot(xf_2-5,yf_2,'k');
fill([xf_2+10 12000],[yf_2 2*YM],'g');

%plot(XW,yf,xq1,yf,xf,yq1,xq2,yf,xf,yq2)
%plot(xq2,yf,XDm,YDm,XDm,YDM)

%ylim([0 2*YM])
%axis equal
xlim([0 Xm+XM])
ylim([YM/2 3/2*YM])
%ylim([0 2*YM])
%cd gridfiles

    load('bigwithpos.mat');
    cx = C(:,1)+9900;
    cy = C(:,2) + YM/2;
    r = C(:,3);
    x_pos = x_coordinates_circles;
    y_pos = y_coordinates_circles;
    k = 1;
%     filetxt = sprintf('grid%d.txt',j);
%     filemat = sprintf('grid%d.mat',j);
%     fileID = fopen(filetxt,'w');
    for i = 1:length(r)
        A = (cx(i)-XM)^2+(cy(i)- YM)^2<(Rf^2-r(i)^2);
        if A
            cx1(k) = cx(i);
            cy1(k) = cy(i);
            r1(k) = r(i);
            xc(:,k) = x_pos(:,i) + 10000;
            yc(:,k) = y_pos(:,i) +YM/2;
%             fprintf(fileID,'%d %d %d\n',cx1(k),cy1(k),r1(k));
%            
            k = k+1;
        else
            continue
        end
%         save(filemat,'cx1','cy1','r1');
    end
    plot(xc(:,1:10:end),yc(:,1:10:end),'k');
    fill(xc(:,1:10:end),yc(:,1:10:end),'y');
%    C1 = [cx1; cy1; r1];
    fclose('all');
%cd ..
xlabel('x (\mum)');
xticks([0 3000 6000 9000 12000])
xticklabels({'0','25','50','75','100'})
ylabel('y (\mum)');
% % yticks([YM/2 17736 26471])
% % yticklabels({'0','75','150'})
% yticks([0 8824 17647 26471 35294])
% yticklabels({'0','75','150','225','300'})
yticks([18000 26471 35294 44118 52941])
yticklabels({'0','75','150','225','300'})
set(gca,'fontsize',18)
% export_fig(fig,'domain_big.pdf');
