
function  X=SpaceBound(X,Up,Low,Dim)
    S=(X>Up)+(X<Low);    
    X=(rand(1,Dim).*(Up-Low)+Low).*S+X.*(~S);
end
