function [s] = kernal( i,j,a,b)

%% �������ﾶ����˺���(RBF)
% delta = 16;
% s =exp(-((i-a)*(i-a)+(j-b)*(j-b))/(2*delta^2)); % Ч����

%% ����Ҷ�˺���
% delta = 5;
% s = (1-delta^2)/(2*(1-2*delta*cos(sqrt(((i-a)*(i-a)+(j-b)*(j-b))))+delta^2));
 
%% ���������
%  delta = 24;
%  s = 1-(i-a)*(i-a)+(j-b)*(j-b)/((i-a)*(i-a)+(j-b)*(j-b)+delta);
 
 %% ��Ԫ���κ�
%  delta = 2;
%  s = sqrt((i-a)*(i-a)+(j-b)*(j-b)+delta^2);
 
 %% ���Ԫ���κ�
 delta = 2.5;
 s = 1/sqrt((i-a)*(i-a)+(j-b)*(j-b)+delta^2); %Ч����
end