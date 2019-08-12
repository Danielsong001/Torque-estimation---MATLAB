x=0.001:0.001:2;
y=0.001:0.001:2;
z=0.001:0.001:2;
f=sin(x)+y.^2/2+log(z);
figure(1);
plot3(x,y,f);


%RBF identification
clear all;
close all;

alfa=0.05;
xite=0.5;      
input_vector=[0,0,0]';

%The parameters design of Guassian Function
%The input of RBF (u(k),y(k)) must be in the effect range of Guassian function overlay

%The value of b represents the widenth of Guassian function overlay
Mb=1;
if Mb==1        %The width of Guassian function is moderate
    b=1.5*ones(4,1);   
elseif Mb==2    %The width of Guassian function is too narrow, most overlap of Guassian function is near to zero
    b=0.0005*ones(4,1);   
elseif Mb==3    %The width of Guassian function is too widew,  most overlap of Guassian function is near to one, 
                %h=1, RBF invalidate
    b=5000*ones(4,1);   
end

%The value of c represents the center position of Guassian function overlay
Mc=2;
if Mc==1
    c=0.5*ones(3,4);  %u(k)=0.50*sin(1*2*pi*k*ts) and y(k) are in the center of Guassian function overlay
elseif Mc==2
    c=0.4*ones(3,4);  %u(k)=0.50*sin(1*2*pi*k*ts) and y(k) are near to the center of Guassian function overlay
elseif Mc==3
    c=5*ones(3,4);   %u(k)=0.50*sin(1*2*pi*k*ts) and y(k) are far to the center of Guassian  function overlay
elseif Mc==4
    c=-5*ones(3,4);   %u(k)=0.50*sin(1*2*pi*k*ts) and y(k) are far to the center of Guassian  function overlay
end

w=rands(4,1);   
w_1=w;w_2=w_1;

b_1=b;b_2=b_1;

ts=0.001;
for k=1:1:2000
   
x(k)=log(k)*ts;
y(k)=k*ts;
z(k)=sqrt(k)*ts;
 
f(k)=sin(x(k))*cos(y(k))+y(k)^4/2+log(z(k))^2;

% x(1)=u(k);
% x(2)=y(k);
input_vector(1)=x(k);
input_vector(2)=y(k);
input_vector(3)=z(k);
   
for j=1:1:4
    h(j)=exp(-norm(input_vector-c(:,j))^2/(2*b(j)*b(j)));
end
fm(k)=w'*h';
em(k)=f(k)-fm(k);

d_w=xite*em(k)*h';
w=w_1+ d_w+alfa*(w_1-w_2);   
w_2=w_1;w_1=w;

% for j=1:1:4
%     p(j)=norm(input_vector-c(:,j))^2/(b(j)*b(j)*b(j));
% end
% 
% d_b=em(k)*w.*h'.*p';
% b=b_1+xite*d_b+alfa*(b_1-b_2);
% b_2=b_1;b_1=b;

end
figure(1);
subplot(3,1,1),plot(x,f,'r',x,fm,'g');
xlabel('x');ylabel('y and ym'); 
subplot(3,1,2),plot(y,f,'r',y,fm,'g');
xlabel('y');ylabel('y and ym'); 
subplot(3,1,3),plot(z,f,'r',z,fm,'g');
xlabel('z');ylabel('y and ym'); 