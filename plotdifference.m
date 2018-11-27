function plotdifference(file,out)
load(file);
n = 1.3272;
I_0 = 6e12;
dx = 8.5e-9;
Sc = 1./sqrt(2);
dt = 1/sqrt(2)*dx/3e8*n*10;
% i_inactive = i_inactive(1:6000);
% i_active = i_active(1:6000); 
i_inactive = sum(inactive_signal)/100;
i_active = sum(active_signal)/100;
% i_active = sum(elec_act.^2);
% i_inactive = sum(elec_inact.^2);
fig1=figure('position',[100 100 1200 600],'Color','white');
% [en_in,~] = envelope(i_inactive);
% [en_ac,~] = envelope(i_active);
[en_in,~] = envelope(i_inactive(2000:end),1,'peak');
[en_ac,~] = envelope(i_active(2000:end),1,'peak');
en_in = en_in - en_in(end);
en_ac = en_ac - en_ac(end);
% [en_in,~] = envelope(i_inactive,100,'rms');
% [en_ac,~] = envelope(i_active,100,'rms');
% [en_in,~] = envelope(i_inactive,1000,'analytic');
% [en_ac,~] = envelope(i_active,1000,'analytic');
t = linspace(0,size(en_in,2)*dt,size(en_in,2))*1e15;

% subplot(2,1,1);
shadedErrorBar(t,abs(en_in),sqrt(abs(en_in)));
%xlim([-5 57]);
%plot(up2)
hold on
%plot(su22(100:end))
%xlim([-1 57]);
xlabel('Time (fs)');
ylabel('N');
%title('OCT signal for inactive nerve');
set(gca,'fontsize',18)
fig2=figure('position',[100 100 1200 600],'Color','white');
% subplot(2,1,2);
y = (en_ac-en_in)/I_0;
% y = (en_ac-en_in)./en_in;
dy = (sqrt(abs(en_ac))+sqrt(abs(en_in)))/I_0;  % made-up error values
% dy = abs(sqrt(en_ac)./en_in) + abs(sqrt(en_in).*en_ac./(en_in.*en_in));
shadedErrorBar(t,y,dy)
%plot(dy)
% ylabel('');
xlabel('Time (fs)')
%xlim([-5 57]);
%title('Difference of active/inactive OCT signals');
set(gca,'fontsize',18)
ylabel('$\frac{\rm N_{ac}-N_{in}}{\rm N_{0}}$','Interpreter','latex','Fontsize',28);
if nargin < 2 return
else
    export_fig(fig1,sprintf('%s_photons.pdf', out),'-Transparent','-r600','-q101');
    export_fig(fig1,sprintf('%s_photons.png', out),'-Transparent','-r600','-q101');
    export_fig(fig2,sprintf('%s_Pdifference.pdf', out),'-Transparent','-r600','-q101');
    export_fig(fig2,sprintf('%s_Pdifference.png', out),'-Transparent','-r600','-q101');
end
end