# TensorFlow 分类器预测股票价格

## 说明
◎ 原始数据

■ 加工数据
- Ⅰ JSON
- Ⅱ CSV

★ 目标数据
- ❶ 检证用
- ❷ 训练用

◆ 执行脚本
- ① Python
- ② Bash Script

```
.
├── readCsv2.py                      ◆①
├── tfCsv2.py                        ◆①
├── writeCsv2.py                     ◆①
├── 1570
│   ├── data.json                   ■Ⅰ
│   ├── data.csv                    ■Ⅱ
│   ├── iris_test.csv               ★❶  ─┐
│   ├── iris_training.csv           ★❷  ─┼┐
│   ├── stocks_1570-T_1d_2013.csv   ◎      ││
│   ├── stocks_1570-T_1d_2014.csv   ◎      ││
│   ├── stocks_1570-T_1d_2015.csv   ◎      ││
│   ├── stocks_1570-T_1d_2016.csv   ◎      ││
│   ├── stocks_1570-T_1d_2017.csv   ◎      ││
│   └── stocks_1570-T.csv           ◎      ││
├── 4536                                     ││
│   ├── data.json                   ■Ⅰ    ││
│   ├── data.csv                    ■Ⅱ    ││
│   ├── iris_test.csv               ★❶  ─┤│
│   ├── iris_training.csv           ★❷  ─┼┤
│   ├── stocks_4536-T_1d_2008.csv   ◎      ││
│   ├── stocks_4536-T_1d_2009.csv   ◎      ││
│   ├── stocks_4536-T_1d_2010.csv   ◎      ││
│   ├── stocks_4536-T_1d_2011.csv   ◎      ││
│   ├── stocks_4536-T_1d_2012.csv   ◎      ││
│   ├── stocks_4536-T_1d_2013.csv   ◎      ││
│   ├── stocks_4536-T_1d_2014.csv   ◎      ││
│   ├── stocks_4536-T_1d_2015.csv   ◎      ││
│   ├── stocks_4536-T_1d_2016.csv   ◎      ││
│   ├── stocks_4536-T_1d_2017.csv   ◎      ││
│   └── stocks_4536-T.csv           ◎      ││
└── iris                                     ││
     ├── iris_test.csv       ←───────┘│
     ├── iris_training.csv   ←────────┘
     ├── start.sh                    ◆②
     └── tflearn.py                  ◆①
```

### **readCsv2.py**: 读入**原始数据◎**，生成**加工数据■Ⅰ**
  * E.g.

  ```
  $ python readCsc2.py 1570
  ```

### **writeCsv2.py**: 读入**加工数据■Ⅰ**，生成**加工数据■Ⅱ**
  * E.g.

  ```
  $ python writeCsv2.py 1570
  ```

  * 内部参数
- dim = 40：输入数据维数
- ma  = 5 ：成交量加权 5 日 Close 均价
- p   = 3 ：前 3 天（用于计算 Close 均价）
- q   = 3 ：后 3 天（用于计算 Close 均价）

### **tfCsv2.py**: 读入**加工数据■Ⅱ**，按**20%** - **80%**比例生成**检证用目标数据★❶** - **训练用目标数据★❷**
  * E.g.

  ```
  $ python tfCsv2.py 1570
  ```

  * 内部参数
- dim = 40：输入数据维数

### **tflearn.py**: 读入**检证用目标数据★❶**及**训练用目标数据★❷**
  * 参考： [Deep Neural Network Classifier](https://www.tensorflow.org/tutorials/tflearn/).
  * E.g.

  ```
  $ cd iris
  $ python tflearn.py
  ```

  * 内部参数
- dimension=40：输入数据维数
- classes=3 ：预测区间数 _[0] < -4% < [1] < +4% < [2]_

### **start.sh**:自动执行脚本
  * E.g.

  ```
  $ cd iris
  $ ./start.sh 1570
  ```

## 数据源

- http://k-db.com/stocks/4536-T/1d/2011?download=csv
- http://k-db.com/stocks/4536-T/1d/2012?download=csv
- ...
- http://k-db.com/stocks/1570-T/1d/2013?download=csv
- http://k-db.com/stocks/1570-T/1d/2014?download=csv
- http://k-db.com/stocks/1570-T/1d/2015?download=csv
- http://k-db.com/stocks/1570-T/1d/2016?download=csv
- http://k-db.com/stocks/1570-T/1d/2017?download=csv
- http://k-db.com/stocks/1570-T?download=csv


## 执行结果
  * 4536:

  ```
  $ cd iris
  $ ./start.sh 
  ...
  Instructions for updating:
  Estimator is decoupled from Scikit Learn interface by moving into
  separate class SKCompat. Arguments x, y and batch_size are only
  available in the SKCompat class, Estimator will only accept input_fn.
  Example conversion:
    est = Estimator(...) -> est = SKCompat(Estimator(...))
  Accuracy: 0.790123
  WARNING:tensorflow:From /usr/local/lib/python2.7/dist-packages/tensorflow/contrib/learn/python/learn/estimators/dnn.py:348 in predict.: calling predict (from tensorflow.contrib.learn.python.learn.estimators.estimator) with x is deprecated  and will be removed after 2016-12-01.
  ...
  Example conversion:
    est = Estimator(...) -> est = SKCompat(Estimator(...))
  WARNING:tensorflow:float64 is not supported by many models, consider casting to float32.
  Predictions: [1, 1, 1]
  ```
