component = require("component")
filesystem = require("filesystem")
os = requrie("os")

redstone = component.redstone
redstone.setWakeThreshold(1)

if (filesystem.exists("/home/casino")) then
    filesystem.remove("/home/casino/casino.lua")
else
    os.execute("mkdir /home/casino")
    os.execute("cp casino/configcasino.lua /home/casino/configcasino.lua")
    os.execute("cp casino/data-casino.dat /home/casino/data-casino.dat")
end

os.execute("cp casino/casino.lua /home/casino/casino.lua")