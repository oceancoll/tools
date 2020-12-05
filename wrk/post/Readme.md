# 要使用wrk进行post请求，需要借助lua脚本进行
***
假设有
```text
Url: http://127.0.0.1:8888/add
Method:POST
Body:{
    "book": "test",
    "price": 1
}
```
需要对该接口进行，post性能测试。<br>
wrk -t1 -c1 -d1s --latency -s post.lua "http://127.0.0.1:8888" <br>
对该post请求，发起线程数为1，模拟1个请求，持续1s
```text
Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     9.01ms    2.73ms  24.86ms   80.33%
    Req/Sec   109.91     11.77   121.00     81.82%
  Latency Distribution
     50%    8.30ms
     75%    9.59ms
     90%   12.56ms
     99%   18.18ms
  121 requests in 1.10s, 14.06KB read
Requests/sec:    109.61
Transfer/sec:     12.74KB
```




