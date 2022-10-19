-- Get Com Data But in Thread as Lua Does not have a timeout for io.read('*line')
local serial = [[
    local port = ''
    -- Lets Get Data 
    function GetComData(comPort)
        if comPort == nil then
            return  "No COM Connected"
        end
        local fileIn = io.open(comPort..":","r")
        local string = ""
        if fileIn then
            io.input(fileIn)
            string = io.read("*line")
            fileIn:close()
        else
            string = "No COM Connected"
        end
        return CheckASCII(string)
    end

    -- This handles Bad incoming Data we just print the old
    function CheckASCII(string)
        for i=1, #string do
            if not string:byte(i) or string:byte(i) > 127 then
                print('ERROR in string at: i '..i..' Size '..#string..' charNum '.. string:byte(i))
                string = nil
                return string
            end
        end
        return string
    end
    -- This must be in the Same thread as the read 
    function SendComData(windowsCom, data)
        print('Sending to Com: '..windowsCom..' with data '..data)
        local fileIn = io.open(windowsCom..":","w+b")
        if fileIn then
            fileIn:write(data)
            fileIn:close()
            print('Data Sent')
            return true
        end
        return false
    end

    -- Fix this loop to increase time .. should not use while(true) as you need loop to end 
    for i = 1, 100000 do
        -- if we receive new comPort lets change it, if nil then use old port 
        port = love.thread.getChannel('COM'):pop() or port
        -- Send received string to the main thread
        love.thread.getChannel('info'):push(GetComData(port))
        -- receive main thread string and send to Arduino 
        local sendData = love.thread.getChannel('send'):pop()
        if sendData then
            SendComData(port, sendData)
        end
    end
]]
return serial