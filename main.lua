local threadCode = require "SerialWaitThread"
local serial = require 'serial'

local windowsCom = "COM5"
local windowsBaud = "115200"
local receivedString = ''
local thread

function love.load()
    -- Setup Windows Com in powershell NOTE: This Breaks Console OUTPUT 
    serial.SetupComPortInPowerShell(windowsCom, windowsBaud)
    -- setup thread to send and receive code 
    thread = love.thread.newThread( threadCode )
    thread:start(99, 1000)
    -- send thread windows Com Port 
    love.thread.getChannel('COM'):push(windowsCom)
end

function love.update(dt)
end

function love.draw()
    receivedString = love.thread.getChannel('info'):pop() or receivedString
    love.graphics.print('Com Port Used is '..windowsCom.. ' Buad rate '..windowsBaud..' change in main', 10 , 15)
    -- using Threads the FPS will not change, if we change the rate the Arduino sends data
    love.graphics.print('FPS: '.. love.timer.getFPS(), 10, 30)
    love.graphics.print('Arduino Response: '..receivedString, 10, 45)
    love.graphics.print('Press Enter to Send \"Test Me\\n\": this should turn on LED for 1 second', 10, 60)
end

function love.keypressed(k)
    if k == 'escape' then
        love.event.quit()
    end
    if k == 'return' then 
        love.thread.getChannel('send'):push('Test Me\n')
    end
end