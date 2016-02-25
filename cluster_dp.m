% Labels = szy_cluster_dp(dist, k, isPlot) �� Labels = szy_cluster_dp(dist, k)
% �����ܶȷ�ֵ�ľ����㷨��dist���������ݵ�ľ������k��Ҫ�����Ŀ������
% isPlot==true��ʾ��Ҫ��ͼ��isPlot==false��ʾ��Ҫ��ͼ��Ĭ��ֵ��false.
% Labels��һ��2xSize(dist, 1)��С�ľ���ÿһ�ж�Ӧһ�����ݵ㣬
% ��һ�б�ʾû��halo���Ƶľ��������ڶ��б�ʾ��halo���Ƶľ�������
% isKernal=true ��kernal����
function Labels = cluster_dp(data, k, isPlot, isKernal)
ND = max(data(:,2));
NL = max(data(:,1));
if (NL>ND)
    ND = NL;   %% ȷ�� DN ȡΪ��һ�������ֵ�еĽϴ��ߣ���������Ϊ���ݵ�����
end

%% data ��һ��ά�ȵĳ��ȣ��൱���ļ�����������������ܸ�����   
 N = size(data,1);
 
%% ��ʼ��Ϊ�� 
 for i = 1:ND
   for j = 1:ND
     dist(i,j) = 0;
     c(i,j) = 0;
   end
 end
 
 %% �����˺���

%% ���� data Ϊ dist ���鸳ֵ��ע������ֻ���� 0.5*DN(DN-1) ��ֵ�����ｫ�䲹����������  �����ﲻ���ǶԽ���Ԫ�� ��
for i = 1:N-1
    ix = data(i,1);
    iy = data(i,2);
    for  j=i+1:N;
        jx = data(j,1);
        jy = data(j,2);
        if isKernal == true
            dist(i,j) = kernal(ix,iy,ix,iy)-2*kernal(ix,iy,jx,jy)+ kernal(jx,jy,jx,jy);
            dist(j,i) = dist(i,j);
        else
            c(i,j) = sqrt((ix-jx)^2+(iy-jy)^2);
            c(j,i) = sqrt((ix-jx)^2+(iy-jy)^2);
        end
    end
end

for i = 1:N
    if isKernal == true
        dist(i,i) = 0;
    else
        c(i,i) = 0;
    end 
end

if nargin == 2
    isPlot = false;
else
    isPlot = true;
end

if isKernal == true
    N = size(dist, 1) * (size(dist, 2) - 1) / 2;
    ND = size(dist, 1);
else
    N = size(c, 1) * (size(c, 2) - 1) / 2;
    ND = size(c, 1);
end


%%ȷ��dc
percent = 2;
% fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

position = round(N*percent/100);  %% round ��һ���������뺯��  
if isKernal == true
    sda = sort(squareform(dist));
    dc = sda(position);
else
    sda = sort(squareform(c));
    dc = sda(position);
end
%% ����ֲ��ܶ� rho (���� Gaussian ��)  
 fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

%% ��ÿ�����ݵ�� rho ֵ��ʼ��Ϊ��  
rho = [];
for i = 1:ND
    rho(i) = 0.;
end

% Gaussian kernel
for i = 1:ND-1
    for j = i+1:ND
        if isKernal == true % ��kernal����������rho
            rho(i) = rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
            rho(j) = rho(j)+exp(-(dist(j,i)/dc)*(dist(j,i)/dc));
        else % ����ͨ����������rho
            rho(i) = rho(i)+exp(-(c(i,j)/dc)*(c(i,j)/dc));
            rho(j) = rho(j)+exp(-(c(j,i)/dc)*(c(j,i)/dc));
        end
    end
end

%% ������������ֵ���������ֵ�����õ����о���ֵ�е����ֵ
if isKernal == true
    maxd=max(max(dist));
else
    maxd=max(max(c));
end

%% �� rho ���������У�ordrho ������
[rho_sorted, ordrho]=sort(rho,'descend');

%% ���� rho ֵ�������ݵ�
delta(ordrho(1))=-1.;
nneigh(ordrho(1))=0;

%% ���� delta �� nneigh ����
if isKernal == true
    for ii=2:ND
        delta(ordrho(ii))=maxd;
        for jj=1:ii-1
            if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
                delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));
                nneigh(ordrho(ii))=ordrho(jj);
            end
        end
    end
else
    for ii=2:ND
        delta(ordrho(ii))=maxd;
        for jj=1:ii-1
            if(c(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))
                delta(ordrho(ii))=c(ordrho(ii),ordrho(jj));
                nneigh(ordrho(ii))=ordrho(jj);
            end
        end
    end
end

%% ���� rho ֵ������ݵ�� delta ֵ
delta(ordrho(1))=max(delta(:));

%% ����ͼ
 disp('Generated file:DECISION GRAPH');
 disp('column 1:Density');
 disp('column 2:Delta');

 fid = fopen('DECISION_GRAPH', 'w');
 for i=1:ND
     fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));
 end
 
%% ѡ��һ��Χס�����ĵľ���
 disp('Select a rectangle enclosing cluster centers')

%% ÿ̨�����������ĸ�����ֻ��һ����������Ļ�����ľ������ 0

%% >> scrsz = get(0,'ScreenSize')

%% scrsz =

%            1           1        1280         800

% 1280 �� 800 ���������õļ�����ķֱ��ʣ�scrsz(4) ���� 800��scrsz(3) ���� 1280
% scrsz = get(0,'ScreenSize');

%% ��Ϊָ��һ��λ�ã��о���û����ô auto �� :-)
% figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);

%% ind �� gamma �ں��沢û���õ�
for i=1:ND
    ind(i)=i;
    gamma(i)=rho(i)*delta(i);
end

%% ���� rho �� delta ����һ����ν�ġ�����ͼ��
if isPlot
%     subplot(2,1,1)
    figure(1) % ������
    tt = plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
    title ('Decision Graph','FontSize',15.0)
    xlabel ('\rho')
    ylabel ('\delta')
end


% subplot(2,1,1)
% rect = getrect(1);
%% getrect ��ͼ��������ȡһ���������� rect �д�ŵ���
%% �������½ǵ����� (x,y) �Լ����ؾ��εĿ�Ⱥ͸߶�
% rhomin=rect(1);
% deltamin=rect(2);%% ���߳������Ǹ� error������ 4 ��Ϊ 2 ��!

%% ��ʼ�� cluster ����
% NCLUST=0;

NCLUST = k;

%% cl Ϊ������־���飬cl(i)=j ��ʾ�� i �����ݵ�����ڵ� j �� cluster
%% ��ͳһ�� cl ��ʼ��Ϊ -1
for i=1:ND
    cl(i)=-1;
end

[B, Index] = sort(gamma, 'descend');

% cl��ÿ�����ݵ����������
% icl�����о������ĵ����
icl = Index(1:k);
cl(Index(1:k)) = 1:k;

%% �ھ���������ͳ�����ݵ㣨���������ģ��ĸ���
% for i=1:ND
%   if ( (rho(i)>rhomin) && (delta(i)>deltamin))
%       % �޸�������ж����������ݽ������к�gamma��ǰ������仯������������
%      NCLUST=NCLUST+1;
%      cl(i)=NCLUST;  %% �� i �����ݵ����ڵ� NCLUST �� cluster

%       icl(NCLUST)=i; %% ��ӳ��,�� NCLUST �� cluster ������Ϊ�� i �����ݵ�
%   end
% end

% fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);

% disp('Performing assignation')

%assignation  ���������ݵ����
for i=1:ND 
    if (cl(ordrho(i))==-1)
        cl(ordrho(i))=cl(nneigh(ordrho(i)));
    end
end
%% �����ǰ��� rho ֵ�Ӵ�С��˳�����,ѭ��������, cl Ӧ�ö��������ֵ��. 

 

%% ������ε㣬halo��δ���Ӧ���Ƶ� if (NCLUST>1) ��ȥ�ȽϺð�
%halo
for i=1:ND
    halo(i)=cl(i);
end

% ��ȡÿһ�� cluster ��ƽ���ܶȵ�һ���� bord_rho
if (NCLUST>1)

    % ��ʼ������ bord_rho Ϊ 0,ÿ�� cluster ����һ�� bord_rho ֵ
    for i=1:NCLUST
        bord_rho(i)=0.;
    end
    
     % ��ȡÿһ�� cluster ��ƽ���ܶȵ�һ���� bord_rho
    for i=1:ND-1
        for j=i+1:ND
             %% �����㹻С��������ͬһ�� cluster �� i �� j
            if ((cl(i)~=cl(j))&&((isKernal==true&&(dist(i,j)<=dc))||((isKernal==false&&c(i,j)<=dc))))
                rho_aver=(rho(i)+rho(j))/2.;%% ȡ i,j �����ƽ���ֲ��ܶ�
                if (rho_aver>bord_rho(cl(i)))
                    bord_rho(cl(i))=rho_aver;
                end
                if (rho_aver>bord_rho(cl(j)))
                    bord_rho(cl(j))=rho_aver;
                end
            end
        end
    end

%% halo ֵΪ 0 ��ʾΪ outlier
    for i=1:ND
        if (rho(i)<bord_rho(cl(i)))
            halo(i)=0;
        end
    end

%% ��һ����ÿ�� cluster
for i=1:NCLUST
    nc=0; %% �����ۼƵ�ǰ cluster �����ݵ�ĸ���
    nh=0; %% �����ۼƵ�ǰ cluster �к������ݵ�ĸ���
    for j=1:ND
        if (cl(j)==i)
            nc=nc+1;
        end
        if (halo(j)==i)
            nh=nh+1;
        end
    end
         fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);
end

if isPlot
    cmap=colormap;
    for i=1:NCLUST
        ic=int8((i*64.)/(NCLUST*1.));
%         subplot(3,1,1);
%         hold on
        figure(2) % ���ĵ�
        plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
        hold on
    end
%     subplot(3,1,2);
    figure(3) 
    disp('Performing 2D nonclassical multidimensional scaling');
    plot(data(:,1),data(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
    hold on
    xlabel ('X');
    ylabel ('Y');
    for i=1:ND
        A(i,1)=0.;
        A(i,2)=0.;
    end
    
    for i=1:NCLUST
        nn=0;
        ic=int8((i*64.)/(NCLUST*1.));
        for j=1:ND
            if (cl(j)==i) %clΪ�ص����ݵ�  haloΪ�������ݵ�
                nn=nn+1;
                A(nn,1)=data(j,1);
                A(nn,2)=data(j,2);
            end
        end
%         hold on
        figure(4)
        grid on
        plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',4,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
% plot3(A(1:nn,1),sqrt(2).*A(1:nn,1).*A(1:nn,2),A(1:nn,2),'o','MarkerSize',4,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));        
hold on
        if isKernal == true
%             title ('density peak based on kernel function','FontSize',15.0);
        else
%             title ('density peak','FontSize',15.0);
        end
    end
end

%% ����ԭʼ����ͼ add by hshi
% % subplot(3,1,3);
% plot(data(:,1),data(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
% title ('the original clusters','FontSize',15.0);
% xlabel ('X');
% ylabel ('Y');
% 
% for i=1:ND
%     A(i,1)=0.;
%     A(i,2)=0.;
% end
% 
for i=1:NCLUST
    nn=0;
    ic=int8((i*64.)/(NCLUST*1.));
    for j=1:ND
        if (data(j,3)==i)
            nn=nn+1;
            A(nn,1)=data(j,1);
            A(nn,2)=data(j,2);
        end
    end
%     hold on
    figure(5)
    plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',4,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    hold on
end

%% =============================
for i=1:ND
    Labels(:, i) = [cl(i) halo(i)]';
end
end
