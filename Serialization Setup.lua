local event = require("event")
local component = require("component")
local modem = component.modem
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

local table = {
