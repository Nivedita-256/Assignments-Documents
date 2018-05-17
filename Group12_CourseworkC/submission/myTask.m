clear all
image=imread('C:\Users\Aishwarya\Documents\books\books q3\data science seminar\coursework c\poisson_nlend\glass.jpg');
[h w d]=size(image);
U = double(reshape(image,w*h,d))/255;
cs = 3.0;
cu = 0.5;
%% Write your method here
% number of image gradients m [g_k where (k=1.. m)] to be calculated for image pixels U size  
G = gradient(h,w);

for i=1:d
g(:,i)=G*U(:,i);
end

U1=zeros(h*w,d);

for i=1:d
LHS=G'*G+cu*speye(h*w);
RHS=cs*G'*g(:,i)+cu*U(:,i);
U1(:,i)=LHS\RHS;
end

image1 =uint8(reshape(U1,h,w,d)*255); 
subplot(1,2,1)
imshow(image1)
subplot(1,2,2)
imshow(image)
imwrite(image,'out.png')

