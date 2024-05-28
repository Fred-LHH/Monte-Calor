function [callPrice, putPrice] = EuropeanOptionPricing(S0, K, r, T, sigma)

%S0 = 初始股票价格
%K = 行权价格
%r = 无风险利率
%T = 到期时间
%sigma = 波动率

%计算中间值d1和d2
d1 = (log(S0/K) + (r + 0.5 * sigma^2) * T) / (sigma * sqrt(T));

d2 = d1 - sigma * sqrt(T);

%计算标准正态分布的累计函数
normcdf_d1 = 0.5 * (1 + erf(d1 / sqrt(2)));

normcdf_d2 = 0.5 * (1 + erf(d2 / sqrt(2)));

normcdf_minus_d1 = 0.5 * (1 + erf(-d1 / sqrt(2)));

normcdf_minus_d2 = 0.5 * (1 + erf(-d2 / sqrt(2)));

%计算看涨看跌价格
callPrice = S0 * normcdf_d1 - K * exp(-r * T) * normcdf_d2;

putPrice = K * exp(-r * T) * normcdf_minus_d2 - S0 * normcdf_minus_d1;
end
