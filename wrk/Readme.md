# wrk
***
wrk is a tools to test http performance
***
wrk -h
```shell
Usage: wrk <options> <url>   
使用方法: wrk <选项> <被测HTTP服务的URL>                            
  Options:                                            
    -c, --connections <N>  跟服务器建立并保持的TCP连接数量  
    -d, --duration    <T>  压测时间           
    -t, --threads     <N>  使用多少个线程进行压测   
                                                      
    -s, --script      <S>  指定Lua脚本路径       
    -H, --header      <H>  为每一个HTTP请求添加HTTP头      
        --latency          在压测结束后，打印延迟统计信息   
        --timeout     <T>  超时时间     
    -v, --version          打印正在使用的wrk的详细版本信息
                                                      
  <N>代表数字参数，支持国际单位 (1k, 1M, 1G)
  <T>代表时间参数，支持时间单位 (2s, 2m, 2h)
```
***
example:<br>
wrk -t12 -c400 -d30s http://www.baidu.com <br>
对www.baidu.com发起压力测试，线程数为12，模拟400个并发请求，持续30s
***
response
```shell
Running 30s test @ http://www.baidu.com （压测时间30s）
  12 threads and 400 connections （共12个测试线程，400个连接）
              （平均值） （标准差）  （最大值）（正负一个标准差所占比例）
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    （延迟）
    Latency   386.32ms  380.75ms   2.00s    86.66%
    (每秒请求数)
    Req/Sec    17.06     13.91   252.00     87.89%
  Latency Distribution （延迟分布）
     50%  218.31ms
     75%  520.60ms
     90%  955.08ms
     99%    1.93s 
  4922 requests in 30.06s, 73.86MB read (30.06s内处理了4922个请求，耗费流量73.86MB)
  Socket errors: connect 0, read 0, write 0, timeout 311 (发生错误数)
Requests/sec:    163.76 (QPS 163.76,即平均每秒处理请求数为163.76)
Transfer/sec:      2.46MB (平均每秒流量2.46MB)
```
***
lua example in other demo
```text
说明：
    wrk的全局属性(也就是默认值，如果不覆盖则默认值), 可以直接拿到lua中使用
    
    wrk = {
        scheme  = "http",
        host    = "localhost",
        port    = nil,
        method  = "GET",
        path    = "/",
        headers = {},
        body    = nil,
        thread  = <userdata>,
    }
```
对于一些动态构建的请求，比如：认证、校验、MD加密、http请求参数化， ab、http_load、siege都不能满足需求，倒是jmeter、wrk可以。 更多的lua示例可以参照<a href="https://github.com/wg/wrk/tree/master/scripts">github</a> wrk请求压测，调用lua分下面3个阶段：setup、running、done
<img src="http://type.so/usr/uploads/2016/08/970528889.png"></img>

<ul>
<ol>
wrk的全局方法, 可以直接拿到lua中使用的
</ol>
</ul>

```text
-- 生成整个request的string，例如：返回
-- GET / HTTP/1.1
-- Host: tool.lu
function wrk.format(method, path, headers, body)

-- 获取域名的IP和端口，返回table，例如：返回 `{127.0.0.1:80}`
function wrk.lookup(host, service)

-- 判断addr是否能连接，例如：`127.0.0.1:80`，返回 true 或 false
function wrk.connect(addr)
```

<ul>
<ol>
Setup阶段 setup是在线程创建之后，启动之前。
</ol>
</ul>

```text
function setup(thread)

-- thread提供了1个属性，3个方法
-- thread.addr 设置请求需要打到的ip
-- thread:get(name) 获取线程全局变量
-- thread:set(name, value) 设置线程全局变量
-- thread:stop() 终止线程
```

<ul>
<ol>
Running阶段
</ol>
</ul>

```text
function init(args)
-- 每个线程仅调用1次，args 用于获取命令行中传入的参数, 例如 --env=pre

function delay()
-- 每个线程调用多次，发送下一个请求之前的延迟, 单位为ms

function request()
-- 每个线程调用多次，返回http请求

function response(status, headers, body)
-- 每个线程调用多次，返回http响应
```

<ul>
<ol>
可以用于自定义结果报表，整个过程中只执行一次
</ol>
</ul>

```text
function done(summary, latency, requests)


latency.min              -- minimum value seen
latency.max              -- maximum value seen
latency.mean             -- average value seen
latency.stdev            -- standard deviation
latency:percentile(99.0) -- 99th percentile value
latency(i)               -- raw value and count

summary = {
  duration = N,  -- run duration in microseconds
  requests = N,  -- total completed requests
  bytes    = N,  -- total bytes received
  errors   = {
    connect = N, -- total socket connection errors
    read    = N, -- total socket read errors
    write   = N, -- total socket write errors
    status  = N, -- total HTTP status codes > 399
    timeout = N  -- total request timeouts
  }
}
```

