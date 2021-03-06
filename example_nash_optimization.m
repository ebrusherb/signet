function [optthresh, dmatssaved, pairwiseaccuracy, pairwisetime] = example_nash_optimization(cvals,domvals,twomat)

its=100;
N=20;
dist='unif';
Nd=size(twomat,2);
Nt=size(twomat,3);
extendeddomvals=[1-domvals(end:-1:2) domvals];
v=1:(Nd+Nd-1);
deps=.05;
l=1;
opt_its=20;

totalc=size(cvals,1);

optthresh=zeros(its,totalc+5,N);
dmatssaved=zeros(its,N,N);
% perfvalssaved=zeros(its,totalc+1,N);
pairwiseaccuracy=zeros(its,totalc+5,N,N);
pairwisetime=zeros(its,totalc+5,N,N);

for c=1:its

    fighting_abilities=20*rand(1,N);
    fighting_abilities=sort(fighting_abilities,'descend');

    dmat=zeros(N);
    
    for i=1:N
        for j=[1:(i-1),(i+1):N]
            diff=fighting_abilities(i)-fighting_abilities(j);
            d=exp(diff)/(exp(diff)+1);
            d=floor(round(d/deps))*deps;
            dmat(i,j)=v(abs(d-extendeddomvals)<=deps/2);
        end
    end

    dmatssaved(c,:,:)=dmat;
    
    for ic=1:totalc
%     for ic=2:-1:1
 
        c1=cvals(ic,1);
        c2=cvals(ic,2);
        c3=cvals(ic,3);
        

        perf=zeros(2,Nd,Nt,Nt); %individual, dominance, thresholds

        perf(1,2:Nd,:,:)=c1*(1-twomat(l,2:Nd,:,:,1))+c2*(twomat(l,2:Nd,:,:,2))+c3*(1-twomat(l,2:Nd,:,:,1));
        perf(2,2:Nd,:,:)=c1*(1-twomat(l,2:Nd,:,:,1))+c2*(twomat(l,2:Nd,:,:,2))+c3*(twomat(l,2:Nd,:,:,1));

        perf(1,1,:,:)=c2*(twomat(l,1,:,:,2))+c3*(1-twomat(l,1,:,:,1));
        perf(2,1,:,:)=c2*(twomat(l,1,:,:,2))+c3*(twomat(l,1,:,:,1));

        Tvals=zeros(N,opt_its);
        Tvals(:,1)=2*ones(N,1);
        % Tvals(:,1)=randi([1 Nt],N,1);
        perfvals=zeros(N,opt_its);

        for i=1:N
            opp_thresh=Tvals([1:(i-1),(i+1):N],1);
            ds=dmat(i,[1:(i-1),(i+1):N]);
            perfsum=0;
                    for q=1:(N-1)
                        if ds(q)<=Nd-1
                            perfsum=perfsum+perf(2,Nd-ds(q)+1,opp_thresh(q),Tvals(i,1)); 
                        else 
                            perfsum=perfsum+perf(1,ds(q)-Nd+1,Tvals(i,1),opp_thresh(q));
                        end
                    end  
            perfvals(i,1)=perfsum;
        end

        count=1;
        while count<=opt_its
            for i=1:N
                opp_thresh=Tvals([1:(i-1),(i+1):N],count);
                ds=dmat(i,[1:(i-1),(i+1):N]);
                perftest=zeros(1,Nt);
                for j=1:Nt
                    perfsum=0;
                    for q=1:(N-1)
                        if ds(q)<=Nd-1
                            perfsum=perfsum+perf(2,Nd-ds(q)+1,opp_thresh(q),j);
                        else 
                            perfsum=perfsum+perf(1,ds(q)-Nd+1,j,opp_thresh(q));
                        end
                    end 
                    perftest(j)=perfsum;
                end
                [p,n]=min(perftest);
                Tvals(i,count+1)=n;
                perfvals(i,count+1)=p;
            end
            if sum(Tvals(:,count+1)==Tvals(:,count))==N
                maxit=count+2;
                count=opt_its+1;
                Tvals(:,maxit:end)=[];
                perfvals(:,maxit:end)=[];
            end
            count=count+1;
        end
        optthresh(c,ic,:)=Tvals(:,end);
%         perfvalssaved(c,ic,:)=thresh2perf(cvals(ic,:),Tvals(:,end),twomat,dmat,l);
        
        probmat=zeros(N,N);
        timemat=zeros(N,N);

        %size(twomat)=[Nl,Nd,Nt,Nt,2];

        for i=1:N
            for j=[1:(i-1),(i+1):N]
                if dmat(i,j)<=Nd-1
                    probmat(i,j)=1-twomat(l,Nd-dmat(i,j)+1,Tvals(j,end),Tvals(i,end),1);
                    timemat(i,j)=twomat(l,Nd-dmat(i,j)+1,Tvals(j,end),Tvals(i,end),2);
                else
                    probmat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals(i,end),Tvals(j,end),1);
                    timemat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals(i,end),Tvals(j,end),2);
                end
            end
        end
        
        pairwisetime(c,ic,:,:)=timemat;
        pairwiseaccuracy(c,ic,:,:)=probmat;

%         binsigmat=zeros(N,N);
% 
%         for i=1:N
%             for j=(i+1):N
%                 draw=rand;
%                 if draw <=probmat(i,j)
%                     binsigmat(i,j)=1;
%                 else binsigmat(j,i)=1;
%                 end
%             end
%         end
% 
%         pairwiseaccuracy(c,ic,:,:)=binsigmat;
        
        
    end
        Tvals2=col(optthresh(c,1,:));
%         Tvals2(end-4:end)=optthresh(c,2,end-4:end);
        Tvals2(end-4)=optthresh(c,2,end-4);
        optthresh(c,3,:)=Tvals2;
        
        probmat=zeros(N,N);
        timemat=zeros(N,N);

        %size(twomat)=[Nl,Nd,Nt,Nt,2];

        for i=1:N
            for j=[1:(i-1),(i+1):N]
                if dmat(i,j)<=Nd-1
                    probmat(i,j)=1-twomat(l,Nd-dmat(i,j)+1,Tvals2(j,end),Tvals2(i,end),1);
                    timemat(i,j)=twomat(l,Nd-dmat(i,j)+1,Tvals2(j,end),Tvals2(i,end),2);
                else
                    probmat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals2(i,end),Tvals2(j,end),1);
                    timemat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals2(i,end),Tvals2(j,end),2);
                end
            end
        end
        
        pairwisetime(c,3,:,:)=timemat;
        pairwiseaccuracy(c,3,:,:)=probmat;
        
        Tvals3=col(optthresh(c,2,:));
%         Tvals2(end-1:end)=optthresh(c,2,end-1:end);
        Tvals3(end-4)=optthresh(c,1,end-4);
        optthresh(c,4,:)=Tvals3;
        
        probmat=zeros(N,N);
        timemat=zeros(N,N);

        %size(twomat)=[Nl,Nd,Nt,Nt,2];

        for i=1:N
            for j=[1:(i-1),(i+1):N]
                if dmat(i,j)<=Nd-1
                    probmat(i,j)=1-twomat(l,Nd-dmat(i,j)+1,Tvals3(j,end),Tvals3(i,end),1);
                    timemat(i,j)=twomat(l,Nd-dmat(i,j)+1,Tvals3(j,end),Tvals3(i,end),2);
                else
                    probmat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals3(i,end),Tvals3(j,end),1);
                    timemat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals3(i,end),Tvals3(j,end),2);
                end
            end
        end
        
        pairwisetime(c,4,:,:)=timemat;
        pairwiseaccuracy(c,4,:,:)=probmat;
        
        Tvals4=col(optthresh(c,1,:));
        Tvals4(end-4:end)=optthresh(c,2,end-4:end);
%         Tvals4(end)=optthresh(c,2,end);
        optthresh(c,5,:)=Tvals4;
        
        probmat=zeros(N,N);
        timemat=zeros(N,N);

        %size(twomat)=[Nl,Nd,Nt,Nt,2];

        for i=1:N
            for j=[1:(i-1),(i+1):N]
                if dmat(i,j)<=Nd-1
                    probmat(i,j)=1-twomat(l,Nd-dmat(i,j)+1,Tvals4(j,end),Tvals4(i,end),1);
                    timemat(i,j)=twomat(l,Nd-dmat(i,j)+1,Tvals4(j,end),Tvals4(i,end),2);
                else
                    probmat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals4(i,end),Tvals4(j,end),1);
                    timemat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals4(i,end),Tvals4(j,end),2);
                end
            end
        end
        
        pairwisetime(c,5,:,:)=timemat;
        pairwiseaccuracy(c,5,:,:)=probmat;
  
        Tvals5=col(optthresh(c,2,:));
        Tvals5(end-9:end-5)=optthresh(c,1,end-9:end-5);
%         Tvals5(end)=optthresh(c,1,end);
        optthresh(c,6,:)=Tvals5;
        
        probmat=zeros(N,N);
        timemat=zeros(N,N);

        %size(twomat)=[Nl,Nd,Nt,Nt,2];

        for i=1:N
            for j=[1:(i-1),(i+1):N]
                if dmat(i,j)<=Nd-1
                    probmat(i,j)=1-twomat(l,Nd-dmat(i,j)+1,Tvals5(j,end),Tvals5(i,end),1);
                    timemat(i,j)=twomat(l,Nd-dmat(i,j)+1,Tvals5(j,end),Tvals5(i,end),2);
                else
                    probmat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals5(i,end),Tvals5(j,end),1);
                    timemat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals5(i,end),Tvals5(j,end),2);
                end
            end
        end
        
        pairwisetime(c,6,:,:)=timemat;
        pairwiseaccuracy(c,6,:,:)=probmat;
        
        Tvals6=col(optthresh(c,1,:));
        Tvals6(end-N/2+1:end)=optthresh(c,2,end-N/2+1:end);
%         Tvals5(end)=optthresh(c,1,end);
        optthresh(c,7,:)=Tvals6;
        
        probmat=zeros(N,N);
        timemat=zeros(N,N);

        %size(twomat)=[Nl,Nd,Nt,Nt,2];

        for i=1:N
            for j=[1:(i-1),(i+1):N]
                if dmat(i,j)<=Nd-1
                    probmat(i,j)=1-twomat(l,Nd-dmat(i,j)+1,Tvals6(j,end),Tvals6(i,end),1);
                    timemat(i,j)=twomat(l,Nd-dmat(i,j)+1,Tvals6(j,end),Tvals6(i,end),2);
                else
                    probmat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals6(i,end),Tvals6(j,end),1);
                    timemat(i,j)=twomat(l,dmat(i,j)-Nd+1,Tvals6(i,end),Tvals6(j,end),2);
                end
            end
        end
        
        pairwisetime(c,7,:,:)=timemat;
        pairwiseaccuracy(c,7,:,:)=probmat;
end


