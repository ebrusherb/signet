green=importdata('green.txt');
blue=importdata('blue.txt');
red=importdata('red.txt');
black=importdata('black.txt');
%%
axislw=1.25;
lw=3;
labfontsz=15 ;
textfontsz=15;
alpha=.7;
ticklength=[.02,.0250];
markersz=5;
markercol='white';

%%

figure
set(gcf,'Color','w')
v=get(gcf,'Position');
ratio=v(4)/v(3);
w=6.83*2;
h=w/2;
set(gcf,'Units','inches');
set(gcf,'Position',[v(1) v(2) w h]);

textlabels={'a' 'b'};

p=zeros(1,2*Nd);

for k=1:2
    subplot_tight(1,4,(1:2)+2*(k-1),[.1 .07])
    set(gca,'FontSize',labfontsz)
    hold on
    switch k
        case 2
            for i=2:Nd
            p(i)=plot(reshape(diag(reshape(twooutput(k,i,:,:,2),Nt,[])),1,[]),reshape(diag(reshape(twooutput(k,i,:,:,1),Nt,[])),1,[]),'Color',blue(i,:),'LineWidth',lw);
            p(i+Nd)=plot(reshape(onemat(k,i,1:40,2),1,[]),reshape(onemat(k,i,1:40,1),1,[]),'Color',red(i,:),'LineWidth',lw);
            end
        otherwise 
            for i=2:Nd
            plot(reshape(diag(reshape(twooutput(k,i,:,:,2),Nt,[])),1,[]),reshape(diag(reshape(twooutput(k,i,:,:,1),Nt,[])),1,[]),'Color',blue(i,:),'LineWidth',lw);
            plot(reshape(onemat(k,i,1:40,2),1,[]),reshape(onemat(k,i,1:40,1),1,[]),'Color',red(i,:),'LineWidth',lw)
            end
    end
    ylabel('Probability of correct output','FontSize',textfontsz)
    xlabel('Expected time to output','FontSize',textfontsz)
text(-.4, 1.03,textlabels(k),'HorizontalAlignment','center','Color','k','Clipping','off','FontSize',textfontsz)
end

leg=legend([p(Nd) p(Nd+Nd) p(Nd+(Nd:-1:2))],'Two dimensions','One dimension',['d=' num2str(domvals(Nd))],['d=' num2str(domvals(Nd-1))],['d=' num2str(domvals(Nd-2))],['d=' num2str(domvals(Nd-3))],['d=' num2str(domvals(Nd-4))]);
legend boxoff
leg_line=findobj(leg,'type','Line');
for i = 1:5
     set(leg_line(2*i), 'Color', black(i+1,:));
     set(leg_line(2*i-1),'Color',black(i+1,:));
end

set(leg,'Position',[.85 .75 .1 .1])
    
set(gcf,'PaperSize',[w h]);
set(gcf,'PaperPosition',[0 0 w h]);

filename=strcat('/Users/eleanorbrush/Dropbox/signaling_network/','1d_v_2d_symmetric','.pdf');
% print(filename,'-dpdf','-r300');

%%
l=lvals(2);
d=domvals(end-1);


ratios=[.1 .5];
Nr=length(ratios);

twoflexthresh=zeros(Nr,Nt,2);

for i=1:Nr
    r=ratios(i);
    for j=1:Nt
        twoflexthresh(i,j,1)=interp2(threshvals,threshvals,reshape(twomat(1,end-1,:,:,1),Nt,[]),threshvals,r*threshvals);
    end
end


%%
figure
set(gcf,'Color','w')
v=get(gcf,'Position');
ratio=v(4)/v(3);
w=6.83*2;
h=w/2;
set(gcf,'Units','inches');
set(gcf,'Position',[v(1) v(2) w h]);

p=zeros(1,Nt);

subplot_tight(1,2,1:2,[.1 .07])
set(gca,'FontSize',labfontsz)
hold on

for i=1:Nr
    p(i)=plot(reshape(twoflexthresh(i,:,2),1,[]),reshape(twoflexthresh(i,:,1),1,[]),'Color',blue(Nr-i+2,:),'LineWidth',lw);
end

ylabel('Probability of correct output','FontSize',textfontsz)
xlabel('Expected time to output','FontSize',textfontsz)

legendlabels={};
for i=1:Nr
    legendlabels(i)=cellstr(['\rho=' num2str(ratios(i))]);
end

% leg=legend(p(1:5),['d=' num2str(ratios(1))],['d=' num2str(ratios(2))],['d=' num2str(ratios(3))],['d=' num2str(ratios(4))],['d=' num2str(ratios(5))]);
leg=legend(p,legendlabels);
legend boxoff
% leg_line=findobj(leg,'type','Line');
% for i = 1:Nr
%      set(leg_line(2*i), 'Color', black(i+1,:));
%      set(leg_line(2*i-1),'Color',black(i+1,:));
% end

set(leg,'Position',[.85 .75 .1 .1])
    
set(gcf,'PaperSize',[w h]);
set(gcf,'PaperPosition',[0 0 w h]);

filename=strcat('/Users/eleanorbrush/Dropbox/signaling_network/','2d_flexible_thresholds','.pdf');
print(filename,'-dpdf','-r300');