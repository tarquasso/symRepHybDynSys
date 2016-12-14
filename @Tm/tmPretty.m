function exprSym = tmPretty(evalstr)
% NOTE: input must be return value from call to 'gpreformat'

verReallyOld = 0;
simplifySteps = 100;

%construct full symbolic expression
fullExpr = sym(evalstr{1});

%simplify the overall expression
try
    fullExprSimplified = gpsimplify(fullExpr,2*simplifySteps,verReallyOld);
catch
    fullExprSimplified = fullExpr;
end

%set the display precision via Mupad
existingPrecision =  char(feval(symengine,'Pref::outputDigits'));
evalin(symengine,'Pref::outputDigits(4)');

exprSym = fullExprSimplified;

%reset display precision to what it was
evalin(symengine,['Pref::outputDigits('  existingPrecision  ')']);

end