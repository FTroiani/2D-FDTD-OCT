function mirrormoving3(w,otputfile)
tic;
%inactive is the path to the folder containing the binary file in time for
%the inactive nerve
%Active is the path to the folder containing the binary file in time for
%the active nerve
%outputfile - name of the .mat file in which the OCT signal for the
%inactive and active nerve are going to be saved.

[inactive,active,mirror] = datacreation(w); %call to the function to create the data for the nerve and the mirror
inactive_signal = zeros(size(inactive));
active_signal= zeros(size(active));
elec_inact = zeros(size(inactive));
elec_act= zeros(size(active));
file1 = sprintf('%s.mat',otputfile);
slidingmirror = zeros(size(inactive));
for j = 1:size(mirror,1)
    slidingmirror(j,:) = [mirror(j,:) zeros(1,size(inactive,2)-size(mirror,2))]; 
    slidingmirror1D = slidingmirror(j,:);
    in_si = zeros(1,size(inactive,2));
    ac_si = zeros(1,size(inactive,2));
    in_el = zeros(1,size(inactive,2));
    ac_el = zeros(1,size(inactive,2));
for i=1:size(inactive,2)
    inactive2 = 0;
    active2 = 0;
    slidingmirror1D = [zeros(1,1) slidingmirror1D(1:(size(slidingmirror1D,2)-1))];
    %sum the electric fields to obtain the interference signal
    index = find(~slidingmirror1D);
    inactive2 = inactive(j,:);
    active2 = active(j,:);
    inactive2(index) = 0;
    active2(index) = 0;
    inactive_elec = slidingmirror1D + inactive2; 
    active_elec = slidingmirror1D + active2;

    in_si = in_si + inactive_elec.^2;
    ac_si = ac_si + active_elec.^2;
    in_el = in_el + inactive_elec;
    ac_el = ac_el + active_elec;
end
inactive_signal(j,:) = in_si;
active_signal(j,:) = ac_si;
elec_inact(j,:) = in_el;
elec_act(j,:) = ac_el;
end

save(file1,'inactive_signal','active_signal','elec_inact','elec_act');
toc;
end