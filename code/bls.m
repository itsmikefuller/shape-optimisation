function t = bls(V,alpha,beta);
    t = 1;
    while J(f,g+t*V) > J(f,g) + alpha*t*dJ(f,g,V);
        t=beta*t;
    end
end