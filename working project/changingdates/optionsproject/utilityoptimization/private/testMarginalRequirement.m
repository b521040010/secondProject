function testMarginalRequirement()
tol=10^-6;
put1=PutOption(80,2.5,2.5,10,10);
assertApproxEqual(put1.marginal20(81.25)*6,10500,tol);
assertApproxEqual(put1.marginal10(81.25)*6,6300,tol);

put2=PutOption(70,0.75,0.75,10,10);
assertApproxEqual(put2.marginal20(81.25)*6,3450,tol);
assertApproxEqual(put2.marginal10(81.25)*6,4650,tol);

call1=CallOption(260,4.25,4.25,10,10);
assertApproxEqual(call1.marginal20(257.14)*10,52818,tol);
assertApproxEqual(call1.marginal10(257.14)*10,29964,tol);

put3=PutOption(280,1,1,10,10);
assertApproxEqual(put3.marginal20(321.30)*20,47920,tol);
assertApproxEqual(put3.marginal10(321.30)*20,58000,tol);

end