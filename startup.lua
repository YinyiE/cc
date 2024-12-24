local computer = require("computer")
local rednet = require("rednet")
local redstone = require("redstone")
local event = require("event")
local component = require("component")
local gui = require("gui")
local args = {...}

local modemSide = "back" -- 默认modem方向
local modem = component.modem

if not modem then
  error("No modem found")
end

local window = gui.Window("RedNet Receiver")
local channelField = gui.TextField("Channel", "Enter channel number")
local outputSideField = gui.TextField("Output Side", "Enter output side")
local outputSignalField = gui.TextField("Output Signal", "Enter output signal strength")
local receiveButton = gui.Button("Start Receiving")

window:addChild(channelField)
window:addChild(outputSideField)
window:addChild(outputSignalField)
window:addChild(receiveButton)

local channel = tonumber(channelField:text())
local outputSide = outputSideField:text()
local outputSignal = tonumber(outputSignalField:text())

receiveButton.onAction = function()
  rednet.open(modemSide)
  while true do
    local id, message, proto = rednet.receive(channel)
    if message then
      local signal = tonumber(message)
      redstone.setAnalogOutput(outputSide, signal or 0)
    end
  end
  rednet.close(modemSide)
end

computer.pushSignal("gui", window)