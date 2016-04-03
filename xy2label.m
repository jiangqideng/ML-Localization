function label = xy2label(x, y)
%关于类标签：
%20m * 15m的房间，划分为300个方格，类标签从1-300，实际的坐标范围为：x \in [1, 199]; y \in [1, 149];
%使用函数label2xy计算类所对应的实际位置
%使用函数xy2label计算实际位置所在的类

label = (ceil(y) - 1) * 20 + ceil(x);

end