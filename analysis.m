% 未使用控制变量的亚氏看涨看跌期权
rng;% 重置随机数生成器
S0 = 100; % 股票初始价格
K = 130; % 行权价格
r = 0.2; % 无风险利率
T = 1; % 到期时间
sigma = 0.2; % 波动率
N = 100; % 时间步数
M = 100000; % 模拟路径数
type = 'arithmetic'; % 亚氏期权类型 ('arithmetic' or 'geometric')
useControlVariate = false;

[callPrice, putPrice, callPayoff, putPayoff, S] = AsianOptionPricing(S0, K, r, T, sigma, N, M, type,useControlVariate);
fprintf('Asian put option price: %f\n', putPrice);
fprintf('Asian call option price: %f\n',callPrice);
% 下面画的图显示了看涨看跌亚氏期权的收益分布（直方图），是MC模拟的收益频率
figure('Name','figure 1', 'units','normalized','outerposition',[0 0 1 1]); 

subplot(1, 2, 1);
histogram(callPayoff, 50);
title('Histogram of Call Option Payoffs');
xlabel('Call Payoff');
ylabel('Frequency');
text(0.5,0.95,'Figure 1','Units','normalized');

subplot(1, 2, 2);
histogram(putPayoff, 50);
title('Histogram of Put Option Payoffs');
xlabel('Put Payoff');
ylabel('Frequency');
text(0.5,0.95,'Figure 2','Units','normalized');


%使用BSM模型实现欧式期权定价，在这里使用了基于相同变量的欧式期权的控制变量的方差缩减技术来提高性能

rng;% reset the random number generator
S0 = 100; % 重置随机数生成器
K = 76; % 行权价格
r = 0.02; % 无风险利率
T = 1; % 到期时间
sigma = 0.2; % 波动率
N = 100; % 时间步数
M = 100000                                                                                                                                                     ; % Number of simulated paths
type = 'arithmetic'; % 亚氏期权类型 ('arithmetic' or 'geometric')
useControlVariate = false;

%初始化无控制变量的亚洲期权定价
[callPrice, putPrice, callPayoff, putPayoff, S,discountFactor] = AsianOptionPricing(S0, K, r, T, sigma, N, M, type, useControlVariate);
fprintf('Asian put option price (no control variate): %f\n', putPrice);
fprintf('Asian call option price (no control variate): %f\n', callPrice);

% 初始化有控制变量的亚洲期权定价
useControlVariate = true;
[callPriceCV, putPriceCV, callPayoffCV, putPayoffCV, SCV,discountFactorCV] = AsianOptionPricing(S0, K, r, T, sigma, N, M, type, useControlVariate);
fprintf('Asian put option price (control variate): %f\n', putPriceCV);
fprintf('Asian call option price (control variate): %f\n', callPriceCV);
% 下面的直方图比较了加入控制变量的亚洲看涨看跌期权与无控制变量的亚氏看涨看跌期权

figure('units','normalized','outerposition',[0 0 1 1]);

% 无控制变量的亚氏看涨
subplot(2, 2, 1);
histogram(callPayoff, 50);
title('Histogram of Call Option Payoffs (No Control Variate)');
xlabel('Call Payoff');
ylabel('Frequency');
text(0.5,0.95,'Figure 3','Units','normalized');

%无控制变量的亚氏看跌
subplot(2, 2, 2);
histogram(putPayoff, 50);
title('Histogram of Put Option Payoffs (No Control Variate)');
xlabel('Put Payoff');
ylabel('Frequency');
text(0.5,0.95,'Figure 4','Units','normalized');

%加入控制变量的亚氏看涨
subplot(2, 2, 3);
histogram(callPayoffCV, 50);
title('Histogram of Call Option Payoffs (Control Variate)');
xlabel('Call Payoff');
ylabel('Frequency');
text(0.5,0.95,'Figure 7','Units','normalized');

%加入控制变量的亚氏看跌
subplot(2, 2, 4);
histogram(putPayoffCV, 50);
title('Histogram of Put Option Payoffs (Control Variate)');
xlabel('Put Payoff');
ylabel('Frequency');
text(0.5,0.95,'Figure 6','Units','normalized');


M_simvalue = round(linspace(100, M, 100)); % 模拟路径数量
callPrices_noCV = zeros(size(M_simvalue)); % 无控制变量的亚氏看涨
putPrices_noCV = zeros(size(M_simvalue)); % 无控制变量的亚氏看跌
callPrices_CV = zeros(size(M_simvalue)); % 加入控制变量的亚氏看涨
putPrices_CV = zeros(size(M_simvalue)); % 加入控制变量的亚氏看跌

useControlVariate = false; 
for i = 1:length(M_simvalue)
    M_i = M_simvalue(i);
    [callPrice, putPrice, ~, ~, ~, ~] = AsianOptionPricing(S0, K, r, T, sigma, N, M_i, type, useControlVariate);
    callPrices_noCV(i) = callPrice;
    putPrices_noCV(i) = putPrice;
end

useControlVariate = true;
for i = 1:length(M_simvalue)
    M_i = M_simvalue(i);
    [callPrice, putPrice, ~, ~, ~, ~] = AsianOptionPricing(S0, K, r, T, sigma, N, M_i, type, useControlVariate);
    callPrices_CV(i) = callPrice;
    putPrices_CV(i) = putPrice;
end

% 绘制加入控制变量和无控制变量时的看涨期权价格的收敛情况。
figure;
plot(M_simvalue, callPrices_noCV, 'r', 'LineWidth', 2); hold on;
plot(M_simvalue, callPrices_CV, 'b', 'LineWidth', 2);
xlabel('Number of simulation paths (M)');
ylabel('Call option price');
legend('Without control variate', 'With control variate');
title('Convergence of call option prices');
text(0.3,0.95,'Figure 7','Units','normalized');

% 绘制加入控制变量和无控制变量时的看跌期权价格的收敛情况。
figure;
plot(M_simvalue, putPrices_noCV, 'r', 'LineWidth', 2); hold on;
plot(M_simvalue, putPrices_CV, 'b', 'LineWidth', 2);
xlabel('Number of simulation paths (M)');
ylabel('Put option price');
legend('Without control variate', 'With control variate');
title('Convergence of put option prices');
text(0.3,0.95,'Figure 8','Units','normalized');

% 从python导入yfinance
yfinance = py.importlib.import_module('yfinance');

% 使用微软股票2020年3月6日至2024年1月5日的数据
symbol = 'MSFT';
start_date = '2020-03-06'; 
end_date = char(py.importlib.import_module('datetime').date.today()); 

% 下载数据，转换python数据格式为Matlab适用的数据格式
data = yfinance.download(symbol, pyargs('start', start_date, 'end', end_date, 'interval', '1d'));
disp(class(data)); 
data_cell_py = cell(data.values.tolist());
column_names_py = cellfun(@char, cell(data.columns.tolist()), 'UniformOutput', false);

data_cell = cell(numel(data_cell_py), numel(column_names_py));
for i = 1:numel(data_cell_py)
    data_cell(i, :) = cell(data_cell_py{i});
end

column_names = cell(size(column_names_py));
for i = 1:numel(column_names_py)
    column_names{i} = char(column_names_py{i});
end

data_mat = cell2table(data_cell, 'VariableNames', column_names);

close_prices = data_mat.Close;

% 计算对数收益率和对应的历史波动率
l_returns = diff(log(close_prices));
historicvol = std(l_returns);

rng;
S0 = close_prices(end);
ONTM = S0; % On The Money, 行权价=初始价格
OUTM = S0 * 1.02; % Out Of The Money， 行权价比初始价格高2%
ITM = S0 * 0.98; % In The Money ，行权价比初始价格低2%
K = ONTM; % 行权价格，可设置为ONTM,OUTM,ITM
r = 0.05; %无风险利率
T = 1; % 到期时间
sigma = historicvol; % 从起始日到现在的股票历史波动率来预测当前股票的波动率
N = 100; 
M = 100000; 
type = 'arithmetic'; % 亚氏期权类型 ('arithmetic' or 'geometric')
useControlVariate = false;

% 无控制变量的亚氏期权
[callPrice, putPrice, callPayoff, putPayoff, S] = AsianOptionPricing(S0, K, r, T, sigma, N, M, type,useControlVariate);
 
fprintf('Asian put option price: %f\n', putPrice);
fprintf('Asian call option price: %f\n', callPrice);
useControlVariate = true;

% 加入控制变量的亚氏期权
[callPriceCV, putPriceCV, callPayoffCV, putPayoffCV, S] = AsianOptionPricing(S0, K, r, T, sigma, N, M, type,useControlVariate);
 
fprintf('Asian put option price: %f\n', putPriceCV);
fprintf('Asian call option price: %f\n', callPriceCV);


figure('units','normalized','outerposition',[0 0 1 1]);

%无控制变量的看涨
subplot(2, 2, 1);
histogram(callPayoff, 50);
title('Histogram of Call Option Payoffs (No Control Variate)');
xlabel('Call Payoff');
ylabel('frequency');
text(0.5,0.95,'Figure 9','Units','normalized');

%无控制变量的看跌
subplot(2, 2, 2);
histogram(putPayoff, 50);
title('Histogram of Put Option Payoffs (No Control Variate)');
xlabel('Put Payoff');
ylabel('Frequency');
text(0.5,0.95,'Figure 10','Units','normalized');

subplot(2, 2, 3);

%加入控制变量的看涨
histogram(callPayoffCV, 50);
title('Histogram of Call Option Payoffs (Control Variate)');
xlabel('Call Payoff');
ylabel('Frequency');
text(0.7,0.95,'Figure 11','Units','normalized');

%加入控制变量的看跌
subplot(2, 2, 4);
histogram(putPayoffCV, 50);
title('Histogram of Put Option Payoffs (Control Variate)');
xlabel('Put Payoff');
ylabel('Frequency');
text(0.5,0.95,'Figure 12','Units','normalized');

% 使用yfinance导入的数据和MC模拟绘制亚氏看涨看跌的收敛图标，包括加入控制变量和无控制变量
M_simvalue = round(linspace(100, M, 100)); % 模拟路径数
callPrices_noCV = zeros(size(M_simvalue)); % 无控制变量的亚氏看涨
putPrices_noCV = zeros(size(M_simvalue)); % 无控制变量的亚氏看跌
callPrices_CV = zeros(size(M_simvalue)); % 加入控制变量的亚氏看涨
putPrices_CV = zeros(size(M_simvalue)); % 加入控制变量的亚氏看跌

useControlVariate = false;
for i = 1:length(M_simvalue)
    M_i = M_simvalue(i);
    [callPrice, putPrice, ~, ~, ~, ~] = AsianOptionPricing(S0, K, r, T, sigma, N, M_i, type, useControlVariate);
    callPrices_noCV(i) = callPrice;
    putPrices_noCV(i) = putPrice;
end

useControlVariate = true;
for i = 1:length(M_simvalue)
    M_i = M_simvalue(i);
    [callPrice, putPrice, ~, ~, ~, ~] = AsianOptionPricing(S0, K, r, T, sigma, N, M_i, type, useControlVariate);
    callPrices_CV(i) = callPrice;
    putPrices_CV(i) = putPrice;
end

% 绘制加入控制变量和无控制变量的亚氏看涨期权的收敛情况
figure;
plot(M_simvalue, callPrices_noCV, 'r', 'LineWidth', 2); hold on;
plot(M_simvalue, callPrices_CV, 'b', 'LineWidth', 2);
xlabel('Number of simulation paths (M)');
ylabel('Call option price');
legend('Without control variate', 'With control variate');
title('Convergence of call option prices');
text(0.3,0.95,'Figure 13','Units','normalized');

% 绘制加入控制变量和无控制变量的亚氏看跌期权的收敛情况
figure;
plot(M_simvalue, putPrices_noCV, 'r', 'LineWidth', 2); hold on;
plot(M_simvalue, putPrices_CV, 'b', 'LineWidth', 2);
xlabel('Number of simulation paths (M)');
ylabel('Put option price');
legend('Without control variate', 'With control variate');
title('Convergence of put option prices');
text(0.3,0.95,'Figure 14','Units','normalized');