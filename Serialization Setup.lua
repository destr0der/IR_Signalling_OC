local event = require("event")
local component = require("component")
local modem = component.modem
fs = require("filesystem")
serialization = require("serialization")

--Ask for action
while Repeat do
  print("Specify Action:\n\t'Create' for new entry.\n\t'Remove' to delete.\n\t'Save' to serialize.") 
  local input = io.read()
  if input == "Create" then
    --Creating new entry
  elseif input == "Remove" then
    --Removing an entry
  elseif input == "Save" then
    --Serialize table
  else then
    print("Please input a valid action")


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
