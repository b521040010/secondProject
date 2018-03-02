function exampleGeo()
%the location of a Mosek toolbox
addpath 'c:\Program Files\mosek\8\toolbox\r2014a'
%Minimize: log(e^4x_1 + 3e^{-x_2})
%Subject to: x1>=-2 and 2x_2<=3
%set the weights for the objective
w=[1 3]';
%the coefficients of the variables for the objective function
ao=[4 0; 0 -2];
%the coefficients of the variables for the constraints
ac=[1/(-2) 0; 0 2/3];
u=[1 1]';
a=[ao;ac];
c = [w ;1./exp(u)];
map=[0 0 1 2]';
[res] = mskgpopt(c,a,map);
%the solution
x=res.sol.itr.xx;
    function assertApproxEqual( a, b, e )
        if ((abs(b-a)<e)~=1)
        error( 'Expected %d, actual %d',a,b);
        end
    end
%verify if the solution is correct
assertApproxEqual(x(1),-2.0, 0.001);
assertApproxEqual(x(2),1.5, 0.001);
end