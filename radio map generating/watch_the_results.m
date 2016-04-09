% E = E1+E2+E3+E4+E5+E6+E0;

E=E6+E0;
Power_all=20*log10(abs(E));%合成的功率。实际上是一个衰减系数，因为假设初始E为1.
% Power_all=abs(E);

xxx=reshape(Power_all,y_max/s-1,x_max/s-1)';
plot(xxx(100,:),'r');figure;
mesh(xxx);
% 
% xxx=reshape(E2,y_max/s-1,x_max/s-1)';
% mesh(20*log10(abs(xxx)));

% % % % % % xx=reshape(Power_all,y_max/s-1,x_max/s-1,z_max/s-1);%得到的xx为三维数组，代表了每个网格点上的数据，需要注意的是这个三维数组第一维为房间的y，第二维为x，第三维为z
% % % % % % %yy=reshape(Power_direct,y_max/s-1,x_max/s-1,z_max/s-1);
% % % % % % %%%%%%%%%%%%%%%%显示z=z0平面上的数据分布%%%%%%%%%%%%%%%%%%%%%
% % % % % % z0=z_s/1000;%默认与发射源同高
% % % % % % %z0=1;%高度为1m
% % % % % % figure;mesh(xx(:,:,z0*1000/s));
% % % % % % 
% % % % % % %%%%%%%%%%%%%%%%显示z和x都确定后的线上的数据分布%%%%%%%%%%%%%%%%%%%%%
% % % % % % z0=z_s/1000;%默认与发射源同高同y
% % % % % % x0=x_s/1000;
% % % % % % %z0=1;%设置z     m
% % % % % % %x0=1;%设置x     m
% % % % % % figure;plot(xx(:,x0*1000/s,z0*1000/s))
% % % % % % 
% % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % nn=floor(size(Power_all,1)/8);%随便找了个点，nn处，来看看这个点的各条路径的实验及其功率
% % % % % % delay = [t_direct_0(nn) t_reflect_1(nn) t_reflect_2(nn) t_reflect_3(nn) t_reflect_4(nn) t_reflect_5(nn) t_reflect_6(nn)];
% % % % % % mag = abs([E0(nn) E1(nn) E2(nn) E3(nn) E4(nn) E5(nn) E6(nn)]);
% % % % % % figure;stem(delay,mag);