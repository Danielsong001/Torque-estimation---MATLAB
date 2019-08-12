clear;
C1 = importdata('C.xlsx');
tor0=300;%基本量定义
N=160;
tf=C1(1:end,5);%录入原始数据
I=0.001*C1(1:end,4);
fso=C1(1:end,2);
dtheta=C1(1:end,1);
time=C1(1:end,6);
tfnew=[0];%新数据
Inew=[0];
fsonew=[0];
dthetanew=[0];
timenew=[0];
k=1;%用于循环
h=1;
coefficient=[0];%用于计算
A=[0];
X=[0];%标定结果
tfcal=[0];
error=[0];
errorrate=[0];
errorratenew=[0];

% for  i=10:length(C1)
%      tf(i)=(tf(i)+tf(i-1)+tf(i-2)+tf(i-3)+tf(i-4)+tf(i-5)+tf(i-6)+tf(i-7)+tf(i-8)+tf(i-9))/10;
%      I(i)=(I(i)+I(i-1)+I(i-2)+I(i-3)+I(i-4)+I(i-5)+I(i-6)+I(i-7)+I(i-8)+I(i-9))/10;
%      fso(i)=(fso(i)+fso(i-1)+fso(i-2)+fso(i-3)+fso(i-4)+fso(i-5)+fso(i-6)+fso(i-7)+fso(i-8)+fso(i-9))/10;
%      dtheta(i)=(dtheta(i)+dtheta(i-1)+dtheta(i-2)+dtheta(i-3)+dtheta(i-4)+dtheta(i-5)+dtheta(i-6)+dtheta(i-7)+dtheta(i-8)+dtheta(i-9))/10;
%      vlink(i)=(vlink(i)+vlink(i-1)+vlink(i-2)+vlink(i-3)+vlink(i-4)+vlink(i-5)+vlink(i-6)+vlink(i-7)+vlink(i-8)+vlink(i-9))/10;
%      alink(i)=(alink(i)+alink(i-1)+alink(i-2)+alink(i-3)+alink(i-4)+alink(i-5)+alink(i-6)+alink(i-7)+alink(i-8)+alink(i-9))/10;
% end

for  i=1:length(C1)
    %if tf(i)>=-tor0 && tf(i)<=-2/3*tor0
     %if tf(i)>=-2/3*tor0 && tf(i)<=-1/3*tor0
    %if tf(i)>=-12/18*tor0 && tf(i)<=-11/18*tor0
         tfnew(k)=tf(i);%录入新值
         Inew(k)=I(i);
         fsonew(k)=fso(i);
         dthetanew(k)=dtheta(i);
         timenew(k)=time(i);
         i=i+1;
         k=k+1;
    %end
end

for  i=1:k-1
    k0c=1;
    w1c=(1/N)*Inew(h);
    w2c=(1/N)*Inew(h)^2;
    w3c=(1/N)*Inew(h)^3;
    w4c=(1/N)*Inew(h)^4;
    w5c=(1/N)*Inew(h)^5;
    a1c=cos(1*fsonew(h));
    a2c=cos(2*fsonew(h));
    a3c=cos(3*fsonew(h));
    b1c=sin(1*fsonew(h));
    b2c=sin(2*fsonew(h));
    b3c=sin(3*fsonew(h));
    k1c=-1/3*tor0;
    k2c=-1/3*tor0;
    k3c=tfnew(h)+2/3*tor0;
    coefficient=[k0c,w1c,w2c,w3c,w4c,w5c,a1c,a2c,a3c,b1c,b2c,b3c,k1c,k2c,k3c];
    for  d=1:15
        A(h,d)=coefficient(d);
    end
    h=h+1;
end
X=A\(dthetanew');
k0=X(1);
w1=X(2);
w2=X(3);
w3=X(4);
w4=X(5);
w5=X(6);
a1=X(7);
a2=X(8);
a3=X(9);
b1=X(10);
b2=X(11);
b3=X(12);
k1=X(13);
k2=X(14);
k3=X(15);
for  i=1:k-1
    tfcal(i)=(dthetanew(i)-k0-(1/N)*(w1*Inew(i)+w2*Inew(i)^2+w3*Inew(i)^3+w4*Inew(i)^4+w5*Inew(i)^5)-(a1*cos(1*fsonew(i))+a2*cos(2*fsonew(i))+a3*cos(3*fsonew(i))+b1*sin(1*fsonew(i))+b2*sin(2*fsonew(i))+b3*sin(3*fsonew(i)))+(tor0/3)*(k1+k2))/k3-2*tor0/3;
    error(i)=tfnew(i)-tfcal(i);
    errorrate(i)=100*error(i)/tfnew(i);
    if 100*error(i)/tfnew(i)>=-200 && 100*error(i)/tfnew(i)<=200
    errorrate(i)=100*error(i)/400;%录入新值
    else
        errorrate(i)=0;
    end
end

for  i=10:k-1
     tfcal(i)=(tfcal(i)+tfcal(i-1)+tfcal(i-2)+tfcal(i-3)+tfcal(i-4)+tfcal(i-5)+tfcal(i-6)+tfcal(i-7)+tfcal(i-8)+tfcal(i-9))/10;
end

for  i=1:k-1
    error(i)=tfnew(i)-tfcal(i);
    errorrate(i)=100*error(i)/tfnew(i);
    if 100*error(i)/tfnew(i)>=-200 && 100*error(i)/tfnew(i)<=200
    errorrate(i)=70*error(i)/400;%录入新值
    else
        errorrate(i)=0;
    end
end


figure(1);
plot(timenew,errorrate,'o');
figure(2);
plot(timenew,error,'o');
figure(3);
plot(timenew,tfnew,'o',timenew,tfcal,'r');
figure(4);
plot(timenew,tfnew,'o',timenew,tfcal,'r',timenew,error,'g',timenew,errorrate,'b');
