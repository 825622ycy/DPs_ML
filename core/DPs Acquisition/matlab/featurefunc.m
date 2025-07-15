function [sample,label,label_size]= featurefunc(data1,data2,samplemk)


label = [];
sample = [];
for k = 1:length(data1)
    id = 1:ndims(data1{k});
    t1 = permute(data1{k},[samplemk,id(~ismember(id,samplemk))]);
    t2 = permute(data2{k},[samplemk,id(~ismember(id,samplemk))]);
    tt1 = reshape(t1,prod(size(data1{k},samplemk)),[]);
    tt2 = reshape(t2,prod(size(data2{k},samplemk)),[]);
    sample = [sample;tt1,tt2];
    label = [label;(k-1)*ones(size(tt1,1),1)];
    if k==1
        p1 = [];
        for j = 1:size(t1,1)
            n = numel(t1)/(size(t1,1)*size(tt1,2));
            p1 = [p1;0.1*j*ones(1,n)];
        end
        label_size = p1(:);
    end
end

