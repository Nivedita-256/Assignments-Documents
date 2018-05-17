%% Source and target image selections

source=im2double(imread('dolphin.jpg')); % source
target=im2double(imread('underwater.png')); % target image
[hs ws ds]=size(source);
[ht wt dt]=size(target);

%% vector U for inner and boundary pixels
Us = double(reshape(source,ws*hs,ds))/255;

Ut =  double(reshape(target,wt*ht,dt))/255;


%% Inner and boundary gradient for the source image
G = gradient(hs,ws);

% for each channel, creates the g vector
for i=1:ds
g(:,i)=G*Us(:,i);
end


%% NOT WORKING - Defining are where cropped image will be in te target
imshow(target);
[x,y] = getpts;


%% uncomment to test for freehand
imshow(source, []);
freehand = imfreehand(); 
% does not allow go outside the borders
fcn = makeConstrainToRectFcn('impoly',get(gca,'XLim'),get(gca,'YLim'));
setPositionConstraintFcn(freehand,fcn);

wait(freehand);

mask = freehand.createMask();

combinedImage = target;

x= int16(x);
y=int16(y);

s = size(source);
[hsc wsc dsc]=size(target);
combinedImage(x:x+s(1)-1, y:y+s(2)-1, :) = source;
%imshow(combinedImage);

%% Defining the gradient for the target
Gt = gradient(ht,wt);

% for each channel, creates the g vector
for i=1:ds
gt(:,i)=Gt*Ut(:,i);
end

%% Matrix X with the size of target but defining the boundary 
x_new=x+s(1)-1;
y_new=y+s(2)-1;
c = zeros(wt,ht);



for i=x:x+s(1)-1
    c(i,y)=1;
    c(i,y_new)=1;
end
for j=y:y+s(2)-1
    c(x,j)=1;  
    c(x_new,j)=1;
end      

%% get only the gradient values for the positions in the matrix X

%ub = Ub * gt;

% source image perimeter
%P = 2*ws+2*hs

%% calculate the selector matrix


%% find the indexes for the boundaries 
%% convert the positions of the matrix into vector positions ( put it in j )
%% for 1 to P -> put in i 
r=1; c=1;

rows=[r*ones(1,ws) r+1:r+hs-1  (r+hs-1)*ones(1,ws-2) r+hs-1:-1:r+1];
cols=[c:c+ws-1 (c+ws-1)*ones(1,hs-2) c+ws-1:-1:c (c)*ones(1,hs-2)];

par = 2*(ws+hs)-4;
i1= 1:par;
j1= (cols-1)*ht+rows;
v = ones(par,1);

Selector = sparse(i1,j1,v,par,wt*ht-1);

boundGrad = Selector * gt;

%%%%%%  put the boundary values to zero on the source gradient gb
r=1; c=1; 
rows=[r*ones(1,ws) r+1:r+hs-1  (r+hs-1)*ones(1,ws-2) r+hs-1:-1:r+1];
cols=[c:c+ws-1 (c+ws-1)*ones(1,hs-2) c+ws-1:-1:c (c)*ones(1,hs-2)];

j1= (cols-1)*hs+rows;
v = ones(par,1);

gb = g;

for i=1:length(j1)
    if j1(i)~=max(j1)
        gb(j1(i),:)=[0 0 0]; 
    end
end

%% Storing the boundary pixels of the target
Ub = target(rows,cols,:);
a= 1;

temp1= a*(Selector'*Selector);

%% formula
LHS = Gt'*Gt + a*(Selector'*Selector);
RHS = Gt'*gb+ a*Selector'*Ub;

Ufinal = LHS/RHS;
image1 =uint8(reshape(Ufinal,ht,wt,dt)*255); 
imshow(image1);