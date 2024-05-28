function [callPrice, putPrice, callPayoff, putPayoff, S,discountFactor] = AsianOptionPricing(S0, K, r, T, sigma, N, M, type,useControlVariate)
% AsianOptionPricing - 使用蒙特卡洛估计亚氏期权看涨看跌价格
% 输入:
% S0 : 初始股票价格
% K : 行权价格
% r : 无风险利率
% T : 到期时间
% sigma : 波动率
% N : 时间步数
% M : 模拟路径数
% type : 'arithmetic'（算术） or 'geometric'（几何）

% 基于T和N的时间步长
dt = T/N;

%股票价格矩阵：行为时间步，列是不同的模拟路径
S = zeros(N+1, M);

% 所有路径初始股票价格S0
S(1, :) = S0;

% 使用几何布朗运动GBM模拟股票价格
for i = 1:N
    
    % 生成随机数dW模拟股票价格随机过程
    dW = sqrt(dt) * randn(1, M);
    
    % 利用GBM更新股票价格
    S(i+1, :) = S(i, :) .* exp((r - 0.5 * sigma^2) * dt + sigma * dW);
end

% 计算每个路径的平均股票价格
if strcmp(type, 'arithmetic')
    A = mean(S(2:end, :));
elseif strcmp(type, 'geometric')
    A = exp(mean(log(S(2:end, :))));
else
    error('无效参数. 请选择 ''arithmetic'' or ''geometric''.');
end


% 计算看涨看跌收益
callPayoff = max(A - K, 0);

putPayoff = max(K - A, 0);

% 折现因子
discountFactor = exp(-r * T);

% 计算平均折现收益
callPrice = discountFactor * mean(callPayoff);

putPrice = discountFactor * mean(putPayoff);


% 欧式期权价格
[europeanCallPrice, europeanPutPrice] = EuropeanOptionPricing(S0, K, r, T, sigma);

% 欧式期权收益
europeanCallPayoff = max(S(end, :) - K, 0);
europeanPutPayoff = max(K - S(end, :), 0);

if useControlVariate
    % 看涨期权协方差和方差
    covarianceCall = cov(callPayoff, europeanCallPayoff);
    varianceCall = var(europeanCallPayoff);

    % 看涨的控制变量
    cCall = -covarianceCall(1, 2) / varianceCall;

    % 利用控制变量调整看涨收益
    callPayoff = callPayoff + cCall * (europeanCallPayoff - europeanCallPrice);

    % 看跌期权协方差和方差
    covariancePut = cov(putPayoff, europeanPutPayoff);
    variancePut = var(europeanPutPayoff);

    % 看跌的控制变量
    cPut = -covariancePut(1, 2) / variancePut;

    % 利用控制变量调整看跌收益
    putPayoff = putPayoff + cPut * (europeanPutPayoff - europeanPutPrice);
    
    % 看涨看跌期权的平均折现收益
    callPrice = discountFactor * mean(callPayoff);
    
    putPrice = discountFactor * mean(putPayoff);


end




end


