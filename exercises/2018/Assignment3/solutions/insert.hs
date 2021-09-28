 
insert _ n [] = [n]
insert 0 n l = n:l
insert i n (x:xs) = x : insert (i-1) n xs