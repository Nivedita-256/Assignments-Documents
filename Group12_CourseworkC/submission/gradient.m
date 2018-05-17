function [ G ] = gradient( h, w )
%GRADIENT Summary of this function goes here
%   Detailed explanation goes here
%h=354; w=204; 

% h*(w-1) + h*(w-1) is for 0.5 and -0.5 in G2 and 
% w*(h-1) + w*(h-1) is for 0.5 and -0.5 in G1 
i = zeros(2*h*(w-1)+2*w*(h-1),1);
j = zeros(2*h*(w-1)+2*w*(h-1),1);
v = zeros(2*h*(w-1)+2*w*(h-1),1);

%filling up i,j
i = [1:w*h-1 1:w*h-1 1:h*w-h 1:h*w-h]';
j = [1:w*h-1 2:w*h 1:h*w-h h+1:h*w]';
v = [0.5*ones(w*h-1,1); -0.5*ones(w*h-1,1); -0.5*ones(h*w-h,1); 0.5*ones(h*w-h,1)];

% collect triplets here

 G = sparse(i,j,v);

 

