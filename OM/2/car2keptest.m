clc
clear
r = [-4578.219,-801.084,-7929.708];
v = [0.8;-6.037;1.385];
mu_E = astroConstants(13);

[a,e,i,bOmega,sOmega,theta] = car2kep(r,v,mu_E,'deg');

% Function car2kep
function [a,e,i,bOmega,sOmega,theta] = car2kep( r, v, mu, angleUnit )
%Conversion from cartesian coordinates to keplerian elements
%
% PROTOTYPE
% T, tname = timescaling( T )
%
% INPUT:
% r[3x1] Position vector
% v[3x1] Velocity vector
% angleUnit[str] Possibles 'rad' or 'deg'. Radians by default
%
% OUTPUT:
% a[1] Semi-major axis
% e[1] Eccentricity
% i[1] Inclination
% bOmega[1] Right ascension of the ascending node
% sOmega[1] Argument of periapsis
% theta[1] True anomaly
%
% CONTRIBUTORS:
% Pablo Arbelo Cabrera
%
% VERSIONS
% 2022-10-13: v1
%
% -------------------------------------------------------------------------
rNorm = vecnorm(r);
vNorm = vecnorm(v);
a = mu/(2*mu/rNorm-vNorm^2);

h = cross(r,v);
i = acos(h(3)/vecnorm(h));

%If inclination is 0, N / line of nodes is not defined.
% Convention -> N = [1;0;0]
if i == 0
    N = [1;0;0];
else
    N = cross([0;0;1],h);
    N = N/vecnorm(N);
end

eVersor = 1/mu*cross(v,h)-r./rNorm;
e = vecnorm(eVersor);

%In circular orbits, e / line of apses is not defined.
% Convention -> e = N
if e == 0
    eVersor = N;
else
    eVersor = eVersor/e;
end

theta = acos(dot(eVersor,r)/rNorm);
if sign(dot(v,r))<0
    theta = 2*pi-theta;
end

bOmega = acos(N(1));
if N(2)<0
    bOmega = 2*pi-bOmega;
end

temp = dot(N,eVersor);
sOmega = acos(temp);

%Conversion to other angle units if it's necessary
if isequal(angleUnit,'deg')
    i = rad2deg(i);
    bOmega = rad2deg(bOmega);
    sOmega = rad2deg(sOmega);
    theta = rad2deg(theta);
end
end