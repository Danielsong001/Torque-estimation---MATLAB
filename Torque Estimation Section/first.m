clear;
C1 = importdata('Cx.xlsx');
%基本量定义
tor0=400;N=160;
%录入原始数据
tf=C1(1:end,5);I=0.001*C1(1:end,4);fso=360*C1(1:end,2)/2^21;motor=0.01*360*C1(1:end,3)/2^21;dtheta=-60*360*C1(1:end,1)/2^21;vlink=0.001*C1(1:end,7);
alink=0.00001*C1(1:end,8);vmotor=0.0001*C1(1:end,9);time=C1(1:end,6);
%新数据向量定义
tfnew=[0];Inew=[0];fsonew=[0];motornew=[0];dthetanew=[0];vlinknew=[0];alinknew=[0];vmotornew=[0];timenew=[0];
%其他变量
k=1;h=1;
coefficient=[0];%用于计算
A=[0];
X1=[0];%标定结果
tfcal=[0];
error=[0];
errorrate=[0];
p=[0,0,0,0,0,0];
C1new=[0];
thetabian=[0];
%原始数据平均值处理
% for  i=10:length(C1)
%      tf(i)=(tf(i)+tf(i-1)+tf(i-2)+tf(i-3)+tf(i-4)+tf(i-5)+tf(i-6)+tf(i-7)+tf(i-8)+tf(i-9))/10;
%      I(i)=(I(i)+I(i-1)+I(i-2)+I(i-3)+I(i-4)+I(i-5)+I(i-6)+I(i-7)+I(i-8)+I(i-9))/10;
%      fso(i)=(fso(i)+fso(i-1)+fso(i-2)+fso(i-3)+fso(i-4)+fso(i-5)+fso(i-6)+fso(i-7)+fso(i-8)+fso(i-9))/10;
%      dtheta(i)=(dtheta(i)+dtheta(i-1)+dtheta(i-2)+dtheta(i-3)+dtheta(i-4)+dtheta(i-5)+dtheta(i-6)+dtheta(i-7)+dtheta(i-8)+dtheta(i-9))/10;
%      vlink(i)=(vlink(i)+vlink(i-1)+vlink(i-2)+vlink(i-3)+vlink(i-4)+vlink(i-5)+vlink(i-6)+vlink(i-7)+vlink(i-8)+vlink(i-9))/10;
%      alink(i)=(alink(i)+alink(i-1)+alink(i-2)+alink(i-3)+alink(i-4)+alink(i-5)+alink(i-6)+alink(i-7)+alink(i-8)+alink(i-9))/10;
% end
k1=0.1429;
k2=-0.0179;
k3=0.1575;
k4=0.5379;
k5=-0.3393;
k1=k3;
for  i=1:length(C1)
     if tf(i)>=-1/3*tor0 && tf(i)<=1/3*tor0
     %if (tf(i)>=220 && tf(i)<=330) && time(i)>600
         tfnew(k)=tf(i);%录入新值
         Inew(k)=I(i);
         fsonew(k)=fso(i);
         motornew(k)=motor(i);
         dthetanew(k)=dtheta(i);
         vlinknew(k)=vlink(i);
         alinknew(k)=alink(i);
         vmotornew(k)=vmotor(i);
         timenew(k)=time(i);
         thetabian(k)=dthetanew(k);
         k=k+1;
     end
end

for  i=1:k-1
    k0c=1;
    w1c=(1/N)*Inew(h);
    w2c=(1/N)*Inew(h)^2;
    w3c=(1/N)*Inew(h)^3;
    w4c=(1/N)*Inew(h)^4;
    w5c=(1/N)*Inew(h)^5;
    w6c=(1/N)*Inew(h)^6;
    a1c=cos(fsonew(h)*vlinknew(h));
    a2c=cos(2*fsonew(h)*vlinknew(h));
    a3c=cos(motornew(h)*vmotornew(h));
    a4c=cos(2*motornew(h)*vmotornew(h));
    b1c=sin(fsonew(h)*vlinknew(h));
    b2c=sin(2*fsonew(h)*vlinknew(h));
    b3c=sin(motornew(h)*vmotornew(h));
    b4c=sin(2*motornew(h)*vmotornew(h));
    a5c=cos(3*fsonew(h)*vlinknew(h));
    a6c=cos(3*motornew(h)*vmotornew(h));
    b5c=sin(3*fsonew(h)*vlinknew(h));
    b6c=sin(3*motornew(h)*vmotornew(h));

    k1c=tfnew(h);
    coefficient=[k0c,w1c,w2c,w3c,w4c,w5c,w6c,a1c,a2c,a3c,a4c,b1c,b2c,b3c,b4c,a5c,a6c,b5c,b6c,k1c];
    
    for  d=1:20
        A(h,d)=coefficient(d);
    end
    h=h+1;
end

X1=A\(thetabian');
k0=X1(1);w1=X1(2);w2=X1(3);w3=X1(4);w4=X1(5);w5=X1(6);w6=X1(7);a1=X1(8);a2=X1(9);a3=X1(10);a4=X1(11);b1=X1(12);b2=X1(13);b3=X1(14);b4=X1(15);
a5=X1(16);a6=X1(17);b5=X1(18);b6=X1(19);k1=X1(20);

for  i=2:k-1
    tfcal(i)=(dthetanew(i)-k0-(1/N)*(w1*Inew(i)+w2*Inew(i)^2+w3*Inew(i)^3+w4*Inew(i)^4+w5*Inew(i)^5+w6*Inew(i)^6)-(a1*cos(fsonew(i)*vlinknew(i))+a2*cos(2*fsonew(i)*vlinknew(i))+a3*cos(motornew(i)*vmotornew(i))+a4*cos(2*motornew(i)*vmotornew(i))+b1*sin(fsonew(i)*vlinknew(i))+b2*sin(2*fsonew(i)*vlinknew(i))+b3*sin(motornew(i)*vmotornew(i))+b4*sin(2*motornew(i)*vmotornew(i))+a5*cos(3*fsonew(i)*vlinknew(i))+a6*cos(3*motornew(i)*vmotornew(i))+b5*sin(3*fsonew(i)*vlinknew(i))+b6*sin(3*motornew(i)*vmotornew(i))))/k1;
    d=15;%平均值
    if i>=d
        for c=1:d-1
            tfcal(i)=tfcal(i)+tfcal(i-c);
        end
        tfcal(i)=tfcal(i)/d;
    end
    error(i)=tfnew(i)-tfcal(i);
    errorrate(i)=100*error(i)/400;
    if errorrate(i)>=-200 && errorrate(i)<=200
    errorrate(i)=errorrate(i);%录入新值
    else
        errorrate(i)=errorrate(i-1);
    end
end

for i=1:k-1
    C1new(i,1)=dthetanew(i);
    C1new(i,2)=fsonew(i);
    C1new(i,3)=motornew(i);
    C1new(i,4)=Inew(i);
    C1new(i,5)=tfnew(i);
    C1new(i,6)=timenew(i);
    C1new(i,7)=vlinknew(i);
    C1new(i,8)=0;%alink
    C1new(i,9)=vmotornew(i);
    C1new(i,10)=0;%amotor
    C1new(i,11)=tfcal(i);
    C1new(i,12)=error(i);
    C1new(i,13)=errorrate(i);
end

figure(1);
plot(C1new(1:end,6),C1new(1:end,13),'o');
figure(2);
plot(C1new(1:end,6),C1new(1:end,5),'o',C1new(1:end,6),C1new(1:end,11),'r',C1new(1:end,6),C1new(1:end,12),'g',C1new(1:end,6),C1new(1:end,13),'b');
