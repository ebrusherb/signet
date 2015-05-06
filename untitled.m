vals=worstaccuracy;
scaledvals=scaledworst;
coords=transformed;
highlight=interestingi;
pointlabels={'b','c','d','e','f','g'};
lw=2;
m=min(vals);
M=max(vals);

c=colormap;
spaced=linspace(0,1,size(c,1));
l=size(coords,1);
cstep=(coords(1,1)-coords(2,1))/2;

xoffset=.25;
yoffset=.2;

hold on
axis off
axis equal

for i=1:l
    p=coords(i,:);
    valnow=vals(i);
    valnow=interp1([m M],[0 1],valnow);
    ind=sum(spaced<=valnow);
    if ind==size(c,1)
        valcol=c(end,:);
    else
        valcol=c(ind,:)+(valnow-spaced(ind))/(spaced(ind+1)-spaced(ind))*(c(ind+1,:)-c(ind,:));
    end
    fill([p(1),p(1)+cstep,p(1)+cstep,p(1),p(1)-cstep,p(1)-cstep],[p(2)-2/sqrt(3)*cstep,p(2)-1/sqrt(3)*cstep,p(2)+1/sqrt(3)*cstep,p(2)+2/sqrt(3)*cstep,p(2)+1/sqrt(3)*cstep,p(2)-1/sqrt(3)*cstep],valcol,'EdgeColor','none');
end

if strcmp(highlight,'on') && ~strcmp(color,'none')
    for i=1:length(tohighlight)
        p=coords(tohighlight(i),:);
        plot([p(1),p(1)+cstep,p(1)+cstep,p(1),p(1)-cstep,p(1)-cstep,p(1)],[p(2)-2/sqrt(3)*cstep,p(2)-1/sqrt(3)*cstep,p(2)+1/sqrt(3)*cstep,p(2)+2/sqrt(3)*cstep,p(2)+1/sqrt(3)*cstep,p(2)-1/sqrt(3)*cstep,p(2)-2/sqrt(3)*cstep],'Color',color,'LineWidth',lw);
        text(p(1),p(2),cellstr(pointlabels{i}),'Color',color,'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',textfontsz,'FontName',fontname)
    end
end

text(0-xoffset,-yoffset,cellstr(cornerlabels{1}),'Color','k','HorizontalAlignment','left','FontSize',textfontsz,'FontName',fontname)
text(2+xoffset,-yoffset,cellstr(cornerlabels{2}),'Color','k','HorizontalAlignment','right','FontSize',textfontsz,'FontName',fontname)
text(1,sqrt(3)+yoffset,cellstr(cornerlabels{3}),'HorizontalAlignment','center','Color','k','Clipping','off','FontSize',textfontsz,'FontName',fontname)

mybar=colorbar;
tickvec=0:.2:1;
ticklabvec=interp1([0 1],[m M],tickvec);
% ticklabvec=tickvec*(M-m)+m;
ticklabvec=round(ticklabvec*100)/100;
set(mybar,'YTick',tickvec,'YTickLabel',ticklabvec,'FontSize',labfontsz,'FontName',fontname)
yl=get(mybar,'YLabel');
v=get(yl,'Position');
set(yl,'String',cellstr(mainlabel),'FontSize',textfontsz,'Rotation',270,'Position',v+[2.5 0 0],'FontName',fontname)