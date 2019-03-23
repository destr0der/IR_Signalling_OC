local event = require("event")
local component = require("component")
local modem = component.modem
local detectoraugment = component.list("ir_augment_detector")
local controlaugment = component.list("ir_augment_control")

--opening up ports and setting strenght
modem.setStrength(275)
modem.open(123)
print("port(123) open:", modem.isOpen(123))

--sending connection message
modem.broadcast(123)
print("Setting up connection")

--waiting for return message previous signal
local _, current, previous, port, _, message = event.pull("modem_message")
print("connection on:", current, "from :", previous, "through port:", port, ".Connection made")

--waiting for connection message next signal
local _, current, next, port, _, message = event.pull("modem_message")
print("connection on:", current, "from :", next, "through port:", port, "connection made")

--sending return message
modem.send(next, port)

--[[ messages send
  train in block = 1
  train in next block = 2
  no train = 3
--]]
--[[
local signal = 3
local spd_c = 140
event.listen("modem_message", function(_, _, incoming, _, _, message)
  if incoming == next then
    signal = tonumber(string.sub(message, 1, 1))
    spd_n = tonumber(string.sub(message, 2))
    return
  end
event.listen("ir_train_overhead", function(name, address, augment_type, uuid)
  if name ~= "ir_train_overhead" or augment_type ~= "DETECTOR" then
    return
  end
  local detector = component.proxy(address)
  while signal = 3 do
    os.exit(0)
  end
--]]