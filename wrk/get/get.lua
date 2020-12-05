--- API
--- GET /miaosha/i/miaosha?goodsRandomName=0e67e331-c521-406a-b705-64e557c4c06c&mobile=15050033920 HTTP/1.1
--- Host: 127.0.0.1:8080

local counter = 1
local threads = {}

function setup(thread)
   thread:set("id", counter)
   table.insert(threads, thread)
   counter = counter + 1
end

function init(args)
   requests  = 0
   responses = 0

   local msg = "thread %d created"
   print(msg:format(id))
end

function request()
   requests = requests + 1
   local returnRequest = "/miaosha/i/miaosha?goodsRandomName=0e67e331-c521-406a-b705-64e557c4c06c"
                        .. "&mobile=" .. math.random(15000000000,19999999999)
   print(wrk.format(nil, returnRequest))
   return wrk.format(nil, returnRequest)
end

function response(status, headers, body)
   responses = responses + 1
end

function done(summary, latency, requests)
   for index, thread in ipairs(threads) do
      local id        = thread:get("id")
      local requests  = thread:get("requests")
      local responses = thread:get("responses")
      local msg = "thread %d made %d requests and got %d responses"
      print(msg:format(id, requests, responses))
   end
end
