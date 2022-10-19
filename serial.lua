local serial = {}
-- You can generate PowerShell script at run-time
-- Now create powershell process and feed your script to its stdin
function serial.SetupComPortInPowerShell(windowsCom, windowsBaud)
    -- create and open com portal for lua 
    os.execute("powershell $port= new-Object System.IO.Ports.SerialPort "..windowsCom..","..windowsBaud..",None,8,one;$port.open();$port.close();")
    -- treat com port as a file and open it in lua 
    local fileIn = io.open(windowsCom..":","r")
    -- check that we created file 
    if fileIn then
        fileIn:close()
        print('Data Startup')
        return true
    end
    return false
end
return serial