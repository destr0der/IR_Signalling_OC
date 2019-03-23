local event = require("event")
local component = require("component")
local modem = component.modem
local detectoraugment = component.list("ir_augment_detector")
local controlaugment = component.list("ir_augment_control")

--opening up ports and setting strenght
modem.setStrength(275)
modem.open(123)
print("port(123) open:", modem.isOpen(123))

--sending connection signal
modem.broadcast(123, "Setting up Signal connection."

--waiting for return signal
local _, current, next, port, _, message = event.pull("modem_message")
print("connection on:", ..current.., "from :", ..next.., "through port:", ..port.., ".Connection made")

