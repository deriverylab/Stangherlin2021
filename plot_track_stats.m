% Pool_MSDfit1 corresponds to 24a
% Pool_MSDfit2 corresponds to 24b
% Pool_MSDfit3 corresponds to 24c
% Pool_MSDfit_24 has all of them

% Pool_MSDfit_24NA1 corresponds to 24NAa
% Pool_MSDfit_24NA2 corresponds to 24NAb
% Pool_MSDfit_24NA3 corresponds to 24NAc
% Pool_MSDfit_24NA has all of them

%1 D by linear fit
%2 D conf interval linear fit
%3 r2 linear fit
%4 D by loglog fit
%5 D conf interval loglog fit
%6 a loglog fit
%7 a conf interval loglog fit
%8 r2 loglog fit
%9 mean intensity of track

r2threhold=0.9; %threshold in r² to keep the tracks
alphathrehold=0.45; %threshold in alpha bellow which to remove tracks for Deff

nbinDeff=50; %nbins for Deff distrib
Deffmax=0.5;   %Deff max for Deff distrib in um²/s
binDeff=0:Deffmax/nbinDeff:Deffmax;
binDeff2=0:Deffmax/nbinDeff:(Deffmax-Deffmax/nbinDeff);
binDeff2=binDeff2';



h=figure;
subplot(2,4,1)
b=find(Pool_MSDfit1(:,8)>r2threhold);
sub=Pool_MSDfit1(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha dataset 24a');
subplot(2,4,2)
b=find(Pool_MSDfit2(:,8)>r2threhold);
sub=Pool_MSDfit2(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha dataset 24b');
subplot(2,4,3)
b=find(Pool_MSDfit3(:,8)>r2threhold);
sub=Pool_MSDfit3(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha dataset 24c');
subplot(2,4,4)
b=find(Pool_MSDfit_24(:,8)>r2threhold);
sub=Pool_MSDfit_24(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha dataset pool 24');

subplot(2,4,5)
b=find(Pool_MSDfit_24NA1(:,8)>r2threhold);
sub=Pool_MSDfit_24NA1(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha dataset 24a low NA');
subplot(2,4,6)
b=find(Pool_MSDfit_24NA2(:,8)>r2threhold);
sub=Pool_MSDfit_24NA2(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha dataset 24b low NA');
subplot(2,4,7)
b=find(Pool_MSDfit_24NA3(:,8)>r2threhold);
sub=Pool_MSDfit_24NA3(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha dataset 24c low NA');
subplot(2,4,8)
b=find(Pool_MSDfit_24NA(:,8)>r2threhold);
sub=Pool_MSDfit_24NA(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha dataset pool 24 low NA');



h2=figure;
subplot(2,4,1)
b=find(Pool_MSDfit1(:,8)>r2threhold);
sub=Pool_MSDfit1(b,:);
b=find(sub(:,6)>alphathrehold);
sub=sub(b,:);
[Distrib,Databinned] = bindistrib(sub(:,4),binDeff);
bar(binDeff2,Distrib);
xlim([0 Deffmax]);
ylim([0 max(Distrib)]);
title('Deff dataset 24a');
subplot(2,4,2)
b=find(Pool_MSDfit2(:,8)>r2threhold);
sub=Pool_MSDfit2(b,:);
b=find(sub(:,6)>alphathrehold);
sub=sub(b,:);
[Distrib,Databinned] = bindistrib(sub(:,4),binDeff);
bar(binDeff2,Distrib);
xlim([0 Deffmax]);
ylim([0 max(Distrib)]);
title('Deff  dataset 24b');
subplot(2,4,3)
b=find(Pool_MSDfit3(:,8)>r2threhold);
sub=Pool_MSDfit3(b,:);
b=find(sub(:,6)>alphathrehold);
sub=sub(b,:);
[Distrib,Databinned] = bindistrib(sub(:,4),binDeff);
bar(binDeff2,Distrib);
xlim([0 Deffmax]);
ylim([0 max(Distrib)]);
title('Deff  dataset 24c');
subplot(2,4,4)
b=find(Pool_MSDfit_24(:,8)>r2threhold);
sub=Pool_MSDfit_24(b,:);
b=find(sub(:,6)>alphathrehold);
sub=sub(b,:);
[Distrib,Databinned] = bindistrib(sub(:,4),binDeff);
mean(sub(:,4))
bar(binDeff2,Distrib);
xlim([0 Deffmax]);
ylim([0 max(Distrib)]);
title('Deff  dataset pool 24');
display('Deff  dataset pool 24');
display(cat(2,'Estimating D through loglogfit ', num2str(mean(sub(:,4))),'+/-',num2str(std(sub(:,4))/sqrt(length((sub(:,4))))),' um²/sec ntracks=',num2str(length((sub(:,4))))));


subplot(2,4,5)
b=find(Pool_MSDfit_24NA1(:,8)>r2threhold);
sub=Pool_MSDfit_24NA1(b,:);
b=find(sub(:,6)>alphathrehold);
sub=sub(b,:);
[Distrib,Databinned] = bindistrib(sub(:,4),binDeff);
bar(binDeff2,Distrib);
xlim([0 Deffmax]);
ylim([0 max(Distrib)]);
title('Deff  dataset 24a low NA');
subplot(2,4,6)
b=find(Pool_MSDfit_24NA2(:,8)>r2threhold);
sub=Pool_MSDfit_24NA2(b,:);
b=find(sub(:,6)>alphathrehold);
sub=sub(b,:);
[Distrib,Databinned] = bindistrib(sub(:,4),binDeff);
bar(binDeff2,Distrib);
xlim([0 Deffmax]);
ylim([0 max(Distrib)]);
title('Deff  dataset 24b low NA');
subplot(2,4,7)
b=find(Pool_MSDfit_24NA3(:,8)>r2threhold);
sub=Pool_MSDfit_24NA3(b,:);
b=find(sub(:,6)>alphathrehold);
sub=sub(b,:);
[Distrib,Databinned] = bindistrib(sub(:,4),binDeff);
bar(binDeff2,Distrib);
xlim([0 Deffmax]);
ylim([0 max(Distrib)]);
title('Deff  dataset 24c low NA');
subplot(2,4,8)
b=find(Pool_MSDfit_24NA(:,8)>r2threhold);
sub=Pool_MSDfit_24NA(b,:);
b=find(sub(:,6)>alphathrehold);
sub=sub(b,:);
[Distrib,Databinned] = bindistrib(sub(:,4),binDeff);
bar(binDeff2,Distrib);

xlim([0 Deffmax]);
ylim([0 max(Distrib)]);
title('Deff  dataset pool 24 low NA');

display('Deff  dataset pool 24 low NA');
display(cat(2,'Estimating D through loglogfit ', num2str(mean(sub(:,4))),'+/-',num2str(std(sub(:,4))/sqrt(length((sub(:,4))))),' um²/sec ntracks=',num2str(length((sub(:,4))))));

h3=figure;
Poolall=cat(1,Pool_MSDfit_24,Pool_MSDfit_24NA);
b=find(Poolall(:,8)>r2threhold);
sub=Poolall(b,:);
hist(sub(:,6),50);
xlim([0 2]);
title('alpha ALL');








% h2=figure
% scatter(sub(:,6),sub(:,4)/1000);
% title('Deff =f(alpha)');
% ylim([0 0.5]);
% xlim([0 2]);
% % 
% 
% 
% 
% r2threhold=0.9;
% b=find(MSDfit(:,8)>0.9);
% sub=MSDfit(b,:);
% b=find(sub(:,6)>0.5);
% sub=sub(b,:);
% %hist(sub(:,4),100);
% scatter(sub(:,6),sub(:,4))