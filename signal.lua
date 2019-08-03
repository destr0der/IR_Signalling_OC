local event = require("event")
local component = require("component")
local modem = component.modem
local detectoraugment = component.list("ir_augment_detector")
local controlaugment = component.list("ir_augment_control")
local rs = component.redstone
local sides = require("sides")
local colors = require("colors")
fs = require("filesystem")
serialization = require("serialization")

--opening up ports and setting strenght:
modem.setStrength(275)
modem.open(123)
print("port(123) open:", modem.isOpen(123))

--sending connection message:
modem.broadcast(123)
print("Setting up connection")

--waiting for return message previous signal:
local _, current, previous, port, _, message = event.pull("modem_message")
print("connection on:", current, "from :", previous, "through port:", port, ".Connection made")

--waiting for connection message next signal:
local _, current, next, port, _, message = event.pull("modem_message")
print("connection on:", current, "from :", next, "through port:", port, "connection made")

--sending return message:
modem.send(next, port)

--[[ messages send
  train in block = 1
  train in next block = 2
  no train = 3
--]]
--Functions:

--Actual Code:
local nsignal = 3
local spd_c = 140
local spd_n = 0
local ToS = 0
--listening for signalupdate of next signalpc
event.listen("modem_message", function(_, _, incoming, _, _, message)
--only for messages from next signalpc
  if incoming == next then
    print("incoming message:", message)
    nsignal = tonumber(string.sub(message, 1, 1))
    ToSn = tonumber(string.sub(message, 2, 2))
    spd_n = tonumber(string.sub(message, 3))
    print(signal,ToSn,spd_n)
--conditions for "orange" signal
    if nsignal == 1 and ToSn == 0 then
      signal = 2
      print("signal = orange")
      rs.setBundledOutput(sides.north,colors.orange,15)
      rs.setBundledOutput(sides.north,colors.red,0)
      rs.setBundledOutput(sides.north,colors.green,0)
      smessage = signal..ToS..spd_c
      send(previous, port, smessage)
--conditions for "green" signal
    elseif nsignal == 2 then
      print("signal = green")
      signal = 3
      rs.setBundledOutput(sides.north,colors.green,15)
      rs.setBundledOutput(sides.north,colors.red,0)
      rs.setBundledOutput(sides.north,colors.orange,0)
    end
  end
end)
--listening for train at signal
event.listen("ir_train_overhead", function(name, address, augment_type, uuid)
--only work for event with name and augment detector
  if name ~= "ir_train_overhead" or augment_type ~= "DETECTOR" then
    return
  end
--Set ToS for train on/off signal
  if uuid ~= nil then
    print("train")
    ToS = 1
    --works
  else
    print("no train")
    ToS = 0
    --doesnt work
  end
--defining detector address
  local detector = component.proxy(address)
--get speed info
  spd_c = detector.info().speed
  spd_M = detector.consist().locomotives[1].max_speed
--changing signallight
  rs.setBundledOutput(sides.north,colors.red,15)
  rs.setBundledOutput(sides.north,colors.green,0)
  rs.setBundledOutput(sides.north,colors.orange,0)
--change speed and update next signal when below treshold
  if nsignal == 1 then
    while spd_c <= (spd_M*.6) do
      spd_c = detector.info().speed
      if spd_c <= (spd_M*0.1) then
        spd_c = 0
        break
      end
      smessage = signal..ToS..spd_c
      modem.send(previous, port, smessage)
      os.sleep(0.5)
    end
  end
--send signal through to previous signalpc
  smessage = signal..ToS..spd_c
  modem.send(previous, port, smessage)
end)
