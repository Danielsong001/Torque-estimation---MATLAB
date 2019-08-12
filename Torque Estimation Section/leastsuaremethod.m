clear;
C1 = importdata('C.xlsx');
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
%原始数据平均值处理
% for  i=10:length(C1)
%      tf(i)=(tf(i)+tf(i-1)+tf(i-2)+tf(i-3)+tf(i-4)+tf(i-5)+tf(i-6)+tf(i-7)+tf(i-8)+tf(i-9))/10;
%      I(i)=(I(i)+I(i-1)+I(i-2)+I(i-3)+I(i-4)+I(i-5)+I(i-6)+I(i-7)+I(i-8)+I(i-9))/10;
%      fso(i)=(fso(i)+fso(i-1)+fso(i-2)+fso(i-3)+fso(i-4)+fso(i-5)+fso(i-6)+fso(i-7)+fso(i-8)+fso(i-9))/10;
%      dtheta(i)=(dtheta(i)+dtheta(i-1)+dtheta(i-2)+dtheta(i-3)+dtheta(i-4)+dtheta(i-5)+dtheta(i-6)+dtheta(i-7)+dtheta(i-8)+dtheta(i-9))/10;
%      vlink(i)=(vlink(i)+vlink(i-1)+vlink(i-2)+vlink(i-3)+vlink(i-4)+vlink(i-5)+vlink(i-6)+vlink(i-7)+vlink(i-8)+vlink(i-9))/10;
%      alink(i)=(alink(i)+alink(i-1)+alink(i-2)+alink(i-3)+alink(i-4)+alink(i-5)+alink(i-6)+alink(i-7)+alink(i-8)+alink(i-9))/10;
% end

for  i=1:length(C1)
    if tf(i)<=-2/3*tor0
        tfnew(k)=tf(i);%录入新值
        Inew(k)=I(i);
        fsonew(k)=fso(i);
        motornew(k)=motor(i);
        dthetanew(k)=dtheta(i);
        vlinknew(k)=vlink(i);
        alinknew(k)=alink(i);
        vmotornew(k)=vmotor(i);
        timenew(k)=time(i);
        thetabian(k)=dthetanew(k)+4.16*tfnew(k)-11.6;
        k=k+1;
    end
end
for i=1:k-1
    C1A1(i,1)=dthetanew(i);
    C1A1(i,2)=fsonew(i);
    C1A1(i,3)=motornew(i);
    C1A1(i,4)=Inew(i);
    C1A1(i,5)=tfnew(i);
    C1A1(i,6)=timenew(i);
    C1A1(i,7)=vlinknew(i);
    C1A1(i,8)=0;%alink
    C1A1(i,9)=vmotornew(i);
    C1A1(i,10)=0;%amotor
end
k=1;

for  i=1:length(C1)
    if tf(i)>=-2/3*tor0 && tf(i)<=-1/3*tor0
        tfnew(k)=tf(i);%录入新值
        Inew(k)=I(i);
        fsonew(k)=fso(i);
        motornew(k)=motor(i);
        dthetanew(k)=dtheta(i);
        vlinknew(k)=vlink(i);
        alinknew(k)=alink(i);
        vmotornew(k)=vmotor(i);
        timenew(k)=time(i);
        thetabian(k)=dthetanew(k)+4.16*tfnew(k)-11.6;
        k=k+1;
    end
end
for i=1:k-1
    C1A2(i,1)=dthetanew(i);
    C1A2(i,2)=fsonew(i);
    C1A2(i,3)=motornew(i);
    C1A2(i,4)=Inew(i);
    C1A2(i,5)=tfnew(i);
    C1A2(i,6)=timenew(i);
    C1A2(i,7)=vlinknew(i);
    C1A2(i,8)=0;%alink
    C1A2(i,9)=vmotornew(i);
    C1A2(i,10)=0;%amotor
end
k=1;

for  i=1:length(C1)
    if tf(i)>=-1/3*tor0 && tf(i)<=1/3*tor0
        tfnew(k)=tf(i);%录入新值
        Inew(k)=I(i);
        fsonew(k)=fso(i);
        motornew(k)=motor(i);
        dthetanew(k)=dtheta(i);
        vlinknew(k)=vlink(i);
        alinknew(k)=alink(i);
        vmotornew(k)=vmotor(i);
        timenew(k)=time(i);
        thetabian(k)=dthetanew(k)+4.16*tfnew(k)-11.6;
        k=k+1;
    end
end
for i=1:k-1
    C1A3(i,1)=dthetanew(i);
    C1A3(i,2)=fsonew(i);
    C1A3(i,3)=motornew(i);
    C1A3(i,4)=Inew(i);
    C1A3(i,5)=tfnew(i);
    C1A3(i,6)=timenew(i);
    C1A3(i,7)=vlinknew(i);
    C1A3(i,8)=0;%alink
    C1A3(i,9)=vmotornew(i);
    C1A3(i,10)=0;%amotor
end
k=1;

for  i=1:length(C1)
    if tf(i)>=1/3*tor0 && tf(i)<=2/3*tor0
        tfnew(k)=tf(i);%录入新值
        Inew(k)=I(i);
        fsonew(k)=fso(i);
        motornew(k)=motor(i);
        dthetanew(k)=dtheta(i);
        vlinknew(k)=vlink(i);
        alinknew(k)=alink(i);
        vmotornew(k)=vmotor(i);
        timenew(k)=time(i);
        thetabian(k)=dthetanew(k)+4.16*tfnew(k)-11.6;
        k=k+1;
    end
end
for i=1:k-1
    C1A4(i,1)=dthetanew(i);
    C1A4(i,2)=fsonew(i);
    C1A4(i,3)=motornew(i);
    C1A4(i,4)=Inew(i);
    C1A4(i,5)=tfnew(i);
    C1A4(i,6)=timenew(i);
    C1A4(i,7)=vlinknew(i);
    C1A4(i,8)=0;%alink
    C1A4(i,9)=vmotornew(i);
    C1A4(i,10)=0;%amotor
end
k=1;

for  i=1:length(C1)
    if tf(i)>=2/3*tor0
        tfnew(k)=tf(i);%录入新值
        Inew(k)=I(i);
        fsonew(k)=fso(i);
        motornew(k)=motor(i);
        dthetanew(k)=dtheta(i);
        vlinknew(k)=vlink(i);
        alinknew(k)=alink(i);
        vmotornew(k)=vmotor(i);
        timenew(k)=time(i);
        thetabian(k)=dthetanew(k)+4.16*tfnew(k)-11.6;
        k=k+1;
    end
end
for i=1:k-1
    C1A5(i,1)=dthetanew(i);
    C1A5(i,2)=fsonew(i);
    C1A5(i,3)=motornew(i);
    C1A5(i,4)=Inew(i);
    C1A5(i,5)=tfnew(i);
    C1A5(i,6)=timenew(i);
    C1A5(i,7)=vlinknew(i);
    C1A5(i,8)=0;%alink
    C1A5(i,9)=vmotornew(i);
    C1A5(i,10)=0;%amotor
end
k=min([size(C1A1,1),size(C1A2,1),size(C1A3,1),size(C1A4,1),size(C1A5,1)]);

for  i=1:35000
    k2c=C1A2(i,5);
    k4c=C1A4(i,5);
    if i<k
        b(i)=C1A1(i+1,1)+C1A2(i,1)+C1A3(i,1)+C1A4(i,1)+C1A5(i,1);
        k1c=C1A1(i+1,5);
        k5c=C1A5(i,5)-2/3*tor0;
        k3c=C1A1(i,5)+2/3*tor0;
    elseif i>k && i<2*k
        b(i)=C1A1(i-k+1,1)+C1A2(i,1)+C1A3(i,1)+C1A4(i,1)+C1A5(i-k,1);
        k1c=C1A1(i-1*k+1,5);
        k5c=C1A5(i-1*k,5)-2/3*tor0;
        k3c=C1A1(i-1*k,5)+2/3*tor0;
    elseif i>2*k && i<3*k
        b(i)=C1A1(i-2*k+1,1)+C1A2(i,1)+C1A3(i,1)+C1A4(i,1)+C1A5(i-2*k,1);
        k1c=C1A1(i-2*k+1,5);
        k5c=C1A5(i-2*k,5)-2/3*tor0;
        k3c=C1A1(i-2*k,5)+2/3*tor0;
    elseif i>3*k && i<4*k
        b(i)=C1A1(i-3*k+1,1)+C1A2(i,1)+C1A3(i,1)+C1A4(i,1)+C1A5(i-3*k,1);
        k1c=C1A1(i-3*k+1,5);
        k5c=C1A5(i-3*k,5)-2/3*tor0;
        k3c=C1A1(i-3*k,5)+2/3*tor0;
    elseif i>4*k && i<5*k
        b(i)=C1A1(i-4*k+1,1)+C1A2(i,1)+C1A3(i,1)+C1A4(i,1)+C1A5(i-4*k,1);
        k1c=C1A1(i-4*k+1,5);
        k5c=C1A5(i-4*k,5)-2/3*tor0;
        k3c=C1A1(i-4*k,5)+2/3*tor0;
    end
    coefficient=[k1c,k2c,k3c,k4c,k5c];
    for  d=1:5
        A(i,d)=coefficient(d);
    end
end

X=A\(b');
k1=X(1);
k2=X(2);
k3=X(3);
k4=X(4);
k5=X(5);
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
