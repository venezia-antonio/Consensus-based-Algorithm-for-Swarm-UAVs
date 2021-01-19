function [lambda] = fix_lambda2(check1,check2)
    if check2 < 0.4 
        lambda = 0.008*exp(check2-check1);
    else
        lambda =0.1*exp(check2-check1);
    end
    if exp(check2-check1)>10
        lambda = 0.5;
    end
end