%简单长方体的射线跟踪
% E(m)=cos(pi*cos(theta(m))/2)/sin(theta(m));%垂直面的方向函数，水平为圆（全向天线）
%参数说明：x_max,y_max,z_max为房间尺寸(m),s为网格尺寸(m)，房间尺寸必须是网格尺寸的倍数。f为电磁波频率(Mhz)
%为了对不同需求使用下面计算出的数据，这部分不做成函数的形式，所以在设置参数之前请先clear
%注意：运行前先设置parameters数组，其中的参数以此为：x_max,y_max,z_max,x_s,y_s,z_s,s,f;
%运行完毕后：        可用watch_the_results来观察数据
%E0-E6为每跟射线电场的衰减%
%Power_direct和power_all为功率衰减系数
%各种t分别为每根射线的延时
%各种p分别为每根射线的相位
%所有上边这些得到的数据均为一维数组，长度为总网格点数目
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2014.12.1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%2014.12.1---修正：考虑复反射系数。  
%%%%以前的直接认为反射系数为-0.7，而且真正计算的时候好像把负号给忘了。还有最后那个由距离引起的相位应该加个负
%现在认为：                               900MHz              1800MHz
%天花板和地板(Ceiling/Floor)   epsilon=     10-1.2j           7.9-0.89j   
%墙壁(RC Wall)                epsilon=     6.1-1.2j           6.2-0.69j   
%假设这个电磁波是垂直极化波，电场向z轴，天线的极化方式匹配。  这样的话，上下平面都是水平方式，其他平面是垂直方式
%然后，现在只想得到与发射源在同一水平面上的各点信息。可以稍微减少下计算量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2014.12.1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2014.12.5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%2014.12.5---修正：考虑天线辐射方向图。改正之前上下平面反射路径的错误
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2014.12.5%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parameters=[40,40,4,10,10,1,0.1,900];%第一次试用这个程序可使用这个参数
%房间尺寸x, y, z. 天线位置x, y, z.   网格尺寸（m）;   频率（MHz）
epsilon_c=10-1.2j;
epsilon_w=6.1-1.2j;
%或者4介电常数和导电系数为：4.44，0.08
% epsilon_c=7.9-0.89j;
% epsilon_w=6.2-0.69j;
x_max=parameters(1)*1000;y_max=parameters(2)*1000;z_max=parameters(3)*1000;%刚开始写这个用的都是mm,所以改成mm计算
x_s=parameters(4)*1000;y_s=parameters(5)*1000;z_s=parameters(6)*1000;s=parameters(7)*1000;f=parameters(8);

if x_max*y_max*z_max/s^3>7000000
    %1000000次计算大概3s时间吧
    disp('提示：本程序将计算出空间中所有网格点的功率时延等信息，您刚刚输入的设置计算量有点大,真的要计算？');
    input('继续-输入回车；退出请ctrl+c');
end

T=1/(f*10^6);%周期
c=3.0e8;%光速
lambda=c/(f*10^6);%lambda就是'南么哒'
% reflect_coefficient=0.7;%反射系数    电场强度乘以反射系数后得到反射后的电场强度

[X, Y, Z] = meshgrid(s:s:(x_max-s), s:s:(y_max-s), s:s:(z_max-s));%得到网格点坐标
L = [X(:) Y(:) Z(:)];
%下面这句用来简化计算，只求出某一个平面上的接收点状况
start=(x_max/s-1)*(y_max/s-1)*(z_s/s-1);
L = L(start+1:start+(x_max/s-1)*(y_max/s-1),:);%将L变小点%发射源所在的z平面上

%直射路径
%%之前写的这些都是没考虑复反射系数的，现在在之前的基础上修改，将反射引起的相位变化加入E的计算里面。而下面的注释所说的相位只是由于距离引起的相位
d_direct = sqrt((L(:,1)-x_s).^2+(L(:,2)-y_s).^2+(L(:,3)-z_s).^2);    %每个网格点距发射源的欧式距离
t_direct_0 = d_direct./1000./c;                                              %直射时延
p_direct = mod(t_direct_0*2*pi/T,2*pi);                                    %直射相位
E_direct = (lambda./(4.*pi.*d_direct./1000));                               %这里和下面的E不一定正好是场强大小，但和场强成正比
E0=E_direct.* exp(1i.*(-p_direct));
%上面计算的L为所有网格点的坐标。每行为一组坐标。
%下面的Li相应的为所有网格点所对应的镜像点
%下面对六组反射路径分别计算

%%%%%%%%%%%%%%%%%%%%%%%%%%%前平面反射路径（前后左右上下的意思是：人站才这个长方体中，面朝y轴，这时的六个面分别称为前后左右上下）%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Li=[L(:,1) , 2.*y_max-L(:,2) , L(:,3)]; %计算镜像点
d_reflect = sqrt((Li(:,1)-x_s).^2+(Li(:,2)-y_s).^2+(Li(:,3)-z_s).^2);%反射路径总长度
t_reflect_1 = d_reflect./1000./c;%时延
p_reflect = mod(t_reflect_1*2*pi/T,2*pi);%相位
thet = abs(atan((Li(:,2)-y_s)./(Li(:,1)-x_s)));%入射角
reflect_coefficient = (sin(thet)-sqrt(epsilon_w-(cos(thet)).^2))./(sin(thet)+sqrt(epsilon_w-(cos(thet)).^2));%现在的反射系数也是矩阵了
E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
E1=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。
%%%%%%%%%%%%%%%%%%%%%%%%%%%后平面反射路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Li=[L(:,1) , -L(:,2) , L(:,3)]; %计算镜像点
d_reflect = sqrt((Li(:,1)-x_s).^2+(Li(:,2)-y_s).^2+(Li(:,3)-z_s).^2);%反射路径总长度
t_reflect_2 = d_reflect./1000./c;%时延
p_reflect = mod(t_reflect_2*2*pi/T,2*pi);%相位
thet = abs(atan((Li(:,2)-y_s)./(Li(:,1)-x_s)));%入射角
reflect_coefficient = (sin(thet)-sqrt(epsilon_w-(cos(thet)).^2))./(sin(thet)+sqrt(epsilon_w-(cos(thet)).^2));%现在的反射系数也是矩阵了
E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
E2=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。
%%%%%%%%%%%%%%%%%%%%%%%%%%%左平面反射路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Li=[-L(:,1) , L(:,2) , L(:,3)]; %计算镜像点
d_reflect = sqrt((Li(:,1)-x_s).^2+(Li(:,2)-y_s).^2+(Li(:,3)-z_s).^2);%反射路径总长度
t_reflect_3 = d_reflect./1000./c;%时延
p_reflect = mod(t_reflect_3*2*pi/T,2*pi);%相位
thet = abs(atan((Li(:,1)-x_s)./(Li(:,2)-y_s)));%入射角
reflect_coefficient = (sin(thet)-sqrt(epsilon_w-(cos(thet)).^2))./(sin(thet)+sqrt(epsilon_w-(cos(thet)).^2));%现在的反射系数也是矩阵了
E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
E3=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。
%%%%%%%%%%%%%%%%%%%%%%%%%%%右平面反射路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Li=[2*x_max-L(:,1) , L(:,2) , L(:,3)]; %计算镜像点
d_reflect = sqrt((Li(:,1)-x_s).^2+(Li(:,2)-y_s).^2+(Li(:,3)-z_s).^2);%反射路径总长度
t_reflect_4 = d_reflect./1000./c;%时延
p_reflect = mod(t_reflect_4*2*pi/T,2*pi);%相位
thet = abs(atan((Li(:,1)-x_s)./(Li(:,2)-y_s)));%入射角
reflect_coefficient = (sin(thet)-sqrt(epsilon_w-(cos(thet)).^2))./(sin(thet)+sqrt(epsilon_w-(cos(thet)).^2));%现在的反射系数也是矩阵了
E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
E4=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。
%%%%%%%%%%%%%%%%%%%%%%%%%%%上平面反射路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%2014.12.5：上下平面的反射路径进行修改，垂直极化波斜向上射的时候啊，由于方向图变小了一些，然后在分解为垂直方向的电场又要变小。
Li=[L(:,1) , L(:,2) , 2*z_max-L(:,3)]; %计算镜像点
d_reflect = sqrt((Li(:,1)-x_s).^2+(Li(:,2)-y_s).^2+(Li(:,3)-z_s).^2);%反射路径总长度
t_reflect_5 = d_reflect./1000./c;%时延
p_reflect = mod(t_reflect_5*2*pi/T,2*pi);%相位
thet = abs(atan((Li(:,3)-z_s)./sqrt((Li(:,1)-x_s).^2+(Li(:,2)-y_s).^2)));%入射角
reflect_coefficient = (-sin(thet).*epsilon_c+sqrt(epsilon_c-(cos(thet)).^2))./(epsilon_c.*sin(thet)+sqrt(epsilon_c-(cos(thet)).^2));%现在的反射系数也是矩阵了
E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
E5=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。
E5=E5  .*   cos(pi*sin(thet)/2)./(cos(thet)+0.00001)  .*  cos(thet); %上下平面的电场由于方向图以及垂直分解需要加上这个
%%%%%%%%%%%%%%%%%%%%%%%%%%%下平面反射路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Li=[L(:,1) , L(:,2) , -L(:,3)]; %计算镜像点
d_reflect = sqrt((Li(:,1)-x_s).^2+(Li(:,2)-y_s).^2+(Li(:,3)-z_s).^2);%反射路径总长度
t_reflect_6 = d_reflect./1000./c;%时延
p_reflect = mod(t_reflect_6*2*pi/T,2*pi);%相位
thet = abs(atan((Li(:,3)-z_s)./sqrt((Li(:,1)-x_s).^2+(Li(:,2)-y_s).^2)));%入射角
reflect_coefficient = (-sin(thet).*epsilon_c+sqrt(epsilon_c-(cos(thet)).^2))./(epsilon_c.*sin(thet)+sqrt(epsilon_c-(cos(thet)).^2));%现在的反射系数也是矩阵了
E_reflect = (lambda./(4.*pi.*d_reflect./1000)) .*  reflect_coefficient;
E6=E_reflect .* exp(1i.*(-p_reflect));%将延迟的相位加进来，与反射造成的衰减与相位变化合在一起。
E6=E6  .*   cos(pi*sin(thet)/2)./(cos(thet)+0.00001)  .*  cos(thet); %上下平面的电场由于方向图以及垂直分解需要加上这个

E = E0+E1+E2+E3+E4+E5+E6;%这里所有的电场强度代表的是随路径和反射的损耗倍数
Power_all=20*log10(abs(E))+2*2.15;%合成的功率。实际上是一个衰减系数，顺便在加上两个天线增益，假设为2.15dbi







