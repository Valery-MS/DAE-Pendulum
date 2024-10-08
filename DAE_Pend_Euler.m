% DAEs  z'' = F(t,z),  G(z) = 0  for pendulum motion

m  = 1;   L = 5;      % масса и длина маятника
x  = 3;   y = -4;     % координаты начального положения маятника
v  = 1;               % модуль начальной скорости
s = -1;               % знак, определяющий направление скорости
t0 = 0;   tf = 2;     % границы интервала интегрирования
n  = 50;              % число шагов 
[z,T] = Pend(m,L,t0,tf,x,y,v,s,n);

function [z,T] = Pend(m,L,t0,tf,x,y,v,s,n)

                            % Анонимные функции
g  = @(t) 9.81 + 0.05*sin(2*pi*t);
F  = @(t,z,T,c) [ z(3); z(4); c*z(1)*T; c*z(2)*T-g(t) ];           % п.ч. ДУ

                            % Параметры
mL = m/L;
c  = -1/(m*L);
h  = (tf-t0)/n;  
                            % Начальные значения
t  = t0;
tt = t0:h:tf; 
z0 = [ x; y; s*v*abs(y)/L; s*v*abs(x)/L ];
z  = nan(4,n+1);    z(:,1) = z0; 
T  = nan(1,n+1);    T(1)   = (m/L)*(z0(3)^2 + z0(4)^2 - g(t0)*z(2));
f  = z;             f(:,1) = F(tt(1),z(:,1),T(1),c);

                            % Рабочий цикл  
for i = 2:n+1
    z(:,i) = z(:,i-1) + h*f(:,i-1);                              % м. Эйлера    
    T(i)   = mL*(z(3,i)^2 + z(4,i)^2 - g(tt(i))*z(2,i));         % из усл.связи
    f(:,i) = F(tt(i),z(:,i),T(i),c);
end 
                            % Графики
plot(tt,[ z(1:2,:);sqrt(z(1,:).^2+z(2,:).^2)], [t0;tf],[0;0],':k')
title(sprintf('h = %g   n = %g',h,n))
xlabel('t');  ylabel('x, y');
legend('x(t)',  'y(t)', 'x^2 +y^2');
end  
