% 23 September 2016
% plot simulation

function plot_outputs(t,q,qd,constants)

% extract constants
Cbeta = constants.Cbeta;
S = constants.S;
Omega = constants.Omega;
Len = constants.L;
m = constants.m;

% calculate the total energy of the pendulum and make sure it's consistent
T = zeros(length(t),1);
V = zeros(length(t),1);
L = zeros(length(t),1);
E = zeros(length(t),1);

pend_pos = constants.L*q;

% calculate total energy
for ii = 1:length(t)
    body_pos = constants.Re*[1;0;0]+constants.L*q(ii,:)';
    
    
    % need the kinetic energy in the inertial frame
    switch constants.eom
        case 'full'
            T(ii) = 1/2*m*Len^2*norm(qd(ii,:))^2 + ...
            m*Len*qd(ii,:)*S*body_pos + ...
            1/2*m*Omega^2*body_pos'*Cbeta*body_pos;
        case 'rot'
            T(ii) = 1/2*m*Len^2*norm(qd(ii,:))^2;
        case 'len'
            T(ii) = 1/2*m*Len^2*norm(qd(ii,:))^2 + ...
            m*Len*qd(ii,:)*S*body_pos + ...
            1/2*m*Omega^2*body_pos'*Cbeta*body_pos;
    end
     
    V(ii) = - constants.m*constants.g*constants.Re^2 / norm(body_pos);
    L(ii) = T(ii)-V(ii);
    E(ii) = T(ii)+V(ii);
    

    
end

% energy variation
E_diff = abs(E - E(1)); 


%% plot outputs
fontsize = 18;
fontname = 'Times';

e_fig = figure;
grid on;hold on
plot(t,abs(E_diff./E))


title('Relative Energy Difference','interpreter','latex','FontName',fontname,'FontSize',fontsize);
xlabel('Time (sec)','interpreter','latex','FontName',fontname,'FontSize',fontsize);
ylabel('$\Delta E / E$','interpreter','latex','FontName',fontname,'FontSize',fontsize);

set(gca,'FontName',fontname,'FontSize',fontsize);

% 2-D projections
pos_fig = figure;

% ground track of pendulum (b2 vs b3 frame)
subplot(2,2,1)
grid on;hold all
plot(pend_pos(:,2),pend_pos(:,3))
title('$b_2$ vs $b_3$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
set(gca,'FontName',fontname,'FontSize',fontsize);

% vertical frame
subplot(2,2,3)
grid on;hold all
plot(pend_pos(:,2),pend_pos(:,1))

title('$b_2$ vs $b_1$','interpreter','latex','FontName',fontname,'FontSize',fontsize);
set(gca,'FontName',fontname,'FontSize',fontsize);

subplot(2,2,4)
grid on;hold all
plot(pend_pos(:,3),pend_pos(:,1))

title('$b_3$ vs $b_1$','interpreter','latex','FontName',fontname,'FontSize',fontsize);

set(gca,'FontName',fontname,'FontSize',fontsize);