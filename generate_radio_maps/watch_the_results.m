% E = E1+E2+E3+E4+E5+E6+E0;

E=E6+E0;
Power_all=20*log10(abs(E));%�ϳɵĹ��ʡ�ʵ������һ��˥��ϵ������Ϊ�����ʼEΪ1.
% Power_all=abs(E);

xxx=reshape(Power_all,y_max/s-1,x_max/s-1)';
plot(xxx(100,:),'r');figure;
mesh(xxx);
% 
% xxx=reshape(E2,y_max/s-1,x_max/s-1)';
% mesh(20*log10(abs(xxx)));

% % % % % % xx=reshape(Power_all,y_max/s-1,x_max/s-1,z_max/s-1);%�õ���xxΪ��ά���飬������ÿ��������ϵ����ݣ���Ҫע����������ά�����һάΪ�����y���ڶ�άΪx������άΪz
% % % % % % %yy=reshape(Power_direct,y_max/s-1,x_max/s-1,z_max/s-1);
% % % % % % %%%%%%%%%%%%%%%%��ʾz=z0ƽ���ϵ����ݷֲ�%%%%%%%%%%%%%%%%%%%%%
% % % % % % z0=z_s/1000;%Ĭ���뷢��Դͬ��
% % % % % % %z0=1;%�߶�Ϊ1m
% % % % % % figure;mesh(xx(:,:,z0*1000/s));
% % % % % % 
% % % % % % %%%%%%%%%%%%%%%%��ʾz��x��ȷ��������ϵ����ݷֲ�%%%%%%%%%%%%%%%%%%%%%
% % % % % % z0=z_s/1000;%Ĭ���뷢��Դͬ��ͬy
% % % % % % x0=x_s/1000;
% % % % % % %z0=1;%����z     m
% % % % % % %x0=1;%����x     m
% % % % % % figure;plot(xx(:,x0*1000/s,z0*1000/s))
% % % % % % 
% % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % nn=floor(size(Power_all,1)/8);%������˸��㣬nn���������������ĸ���·����ʵ�鼰�书��
% % % % % % delay = [t_direct_0(nn) t_reflect_1(nn) t_reflect_2(nn) t_reflect_3(nn) t_reflect_4(nn) t_reflect_5(nn) t_reflect_6(nn)];
% % % % % % mag = abs([E0(nn) E1(nn) E2(nn) E3(nn) E4(nn) E5(nn) E6(nn)]);
% % % % % % figure;stem(delay,mag);