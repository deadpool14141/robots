component = require("component")
filesystem = require("filesystem")
computer = require("computer")

redstone = component.redstone
redstone.setWakeThreshold(1)

computer.addUser("deadpool94")

-- if (filesystem.exists(filesystem.concat(os.getenv("PWD"), "casino"))) then
--     os.execute("rm -r casino")
-- end

os.execute("mkdir casino")
os.execute("wget https://raw.githubusercontent.com/deadpool14141/robots/master/casino.lua casino/casino.lua -f")
-- os.execute("wget https://raw.githubusercontent.com/deadpool14141/robots/master/configcasino.lua casino/configcasino.lua -f")
os.execute("wget https://raw.githubusercontent.com/deadpool14141/robots/master/data-casino.dat casino/data-casino.dat -f")
-- os.execute("wget https://raw.githubusercontent.com/deadpool14141/robots/master/shrc shrc -f")
-- os.execute("cp shrc /home/.shrc")

-- if (filesystem.exists("/home/casino")) then
--     filesystem.remove("/home/casino/casino.lua")
-- else
--     os.execute("mkdir /home/casino")
--     os.execute("cp casino/configcasino.lua /home/casino/configcasino.lua")
--     os.execute("cp casino/data-casino.dat /home/casino/data-casino.dat")
-- end

-- os.execute("cp casino/casino.lua /home/casino/casino.lua")
