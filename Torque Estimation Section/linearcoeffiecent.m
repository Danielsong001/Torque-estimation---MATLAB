% clear;
% C1 = importdata('C.xlsx');
%基本量定义
tor0=400;N=160;n=5;
%录入原始数据
tf=C1(1:end,5);I=0.001*C1(1:end,4);fso=360*C1(1:end,2)/2^21;motor=0.01*360*C1(1:end,3)/2^21;dtheta=-60*360*C1(1:end,1)/2^21;vlink=0.001*C1(1:end,7);
alink=0.00001*C1(1:end,8);vmotor=0.0001*C1(1:end,9);time=C1(1:end,6);
%新数据向量定义
tfnew=[0];Inew=[0];fsonew=[0];motornew=[0];dthetanew=[0];vlinknew=[0];alinknew=[0];vmotornew=[0];timenew=[0];
%其他变量
k=1;h=1;
coefficient=[0];%用于计算
A=[0];
X=[0];%标定结果
tfcal=[0];
error=[0];
errorrate=[0];
p=[0,0,0,0,0,0];
C1A1=[0];
C1A2=[0];
C1A3=[0];
C1A4=[0];
C1A5=[0];
thetabian=[0];
thetaleast=[0];


k1=6/42;
k2=(-1*k1*tor0/3+18)/(192-tor0/3);
k3=(-1*k1*tor0/3-1*k2*tor0/3+32)/(364-2*tor0/3);
k4=(-1*k1*tor0/3+42)/(176-tor0/3);
k5=(-1*k1*tor0/3+72-1*k4*tor0/3)/(322-2*tor0/3);
c=0;
for i=1:length(C1)
    if tf(i)<=-2/3*tor0
        thetaleast(i)=-1*k1*tor0/3-k2*tor0/3+k3*(tf(i)+2*tor0/3);
    elseif tf(i)>=-2/3*tor0 && tf(i)<=-1/3*tor0
        thetaleast(i)=-1*k1*tor0/3+k2*(tf(i)+tor0/3);
    elseif tf(i)>=-1/3*tor0 && tf(i)<=1/3*tor0
        thetaleast(i)=k1*tf(i);
    elseif tf(i)>=1/3*tor0 && tf(i)<=2/3*tor0
        thetaleast(i)=k1*tor0/3+k4*(tf(i)-1*tor0/3);
    elseif tf(i)>=2/3*tor0
        thetaleast(i)=k1*tor0/3+k4*tor0/3+k5*(tf(i)-2*tor0/3);
    else
        thetaleast(i)=dtheta(i);
        c=c+1;
    end
end
figure(1);
plot(tf,dtheta,'o',tf,thetaleast,'r');
p=[k1,k2,k3,k4,k5]
