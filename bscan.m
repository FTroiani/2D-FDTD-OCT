function bscan(w,simN,out)
    tic
    s = 10;
    SizeY_a = 2000/s;
    file = sprintf('../%d_m',w);
    [~,mirror] = tobsread(file);
    for i = 1:simN
        fid = fopen(sprintf('%d_%d',w,i),'rb');
%       fid = fopen('3000obs_i','rb');
        clear a;
        a = fread(fid,inf,'single');
        SizeT = size(a,1)/SizeY_a;
        data1 = reshape(a,SizeY_a,SizeT);
        fclose(fid);
        if SizeT>7000
            SizeT=7000;
        end
        data1 = data1(:,1:SizeT);
        
        SizeM = SizeT-size(mirror,2);
        electric = zeros(SizeY_a,SizeT);
        signal = zeros(SizeY_a,SizeT);
        slidingmirror = [mirror zeros(SizeY_a,SizeM)]; 
  
         
            for l=1:SizeT-2
                slidingmirror = [zeros(SizeY_a,1) slidingmirror(:,1:SizeT-1)];
                %sum the electric fields to obtain the interference signal
                slidingmirror1D = slidingmirror(SizeY_a/2,:);
                %sum the electric fields to obtain the interference signal
                index = find(~slidingmirror1D);
                inactive2 = data1;
                inactive2(:,index) = 0;
                interference = slidingmirror + inactive2; 
                signal = signal + interference.*interference;
                electric = electric + interference;
            end
        if i==1
            interferenceB = signal;
            electricB = electric;
        else
            interferenceB = [interferenceB; signal];
            electricB = [electricB; electric];
        end
    end
file = sprintf('%d_%s.mat',w,out);
save(file,'interferenceB','electricB');
fclose('all');
toc
end