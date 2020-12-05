json = require('json')

counter = 0
-- lua 中 table {} 为字典
-- 构建字典
charset = {} do -- [0-9a-z-A-Z]
    for c = 48, 57 do
        table.insert(charset, string.char(c))
    end
    for c = 65, 90 do
        table.insert(charset, string.char(c))
    end
    for c = 97, 122 do
        table.insert(charset, string.char(c))
    end
end

-- 递归生成长度为lenght的字符串
function randomString(length)
    if not length or length <=0 then
        return ''
    end
    math.random(os.clock()^5)
    -- .. 是连接两个字符串的连接符，A..B, 若A=hello,B=world,则结果为hello world
    return randomString(length-1) .. charset[math.random(1, #charset)]
end


request = function()
    counter = counter + 1
    wrk.port = 8888
    wrk.method = "POST"
    wrk.path = "/add"
    local data = { }
    data.book = randomString(5)
    data.price = math.random(1,100)
    -- print(json.stringify(data))
    wrk.body = json.stringify(data)
    wrk.headers["Content-Type"] = "application/json"
    return wrk.format(nil)
end

