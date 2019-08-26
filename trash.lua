local robot = require("robot")
local component = require("component")
local sides = require("sides")

ic = component.getPrimary("inventory_controller")

--component.getPrimary("generator").insert()


--for k,v in pairs(_G) do
--    print (k,v)
--end






--local database = component.proxy(component.list("database")())
--local meController = component.proxy(component.list("me_controller")())
--local meExportBus = component.proxy(component.list("me_exportbus")())



--local exportBusSide
--for i = 0, 5 do
--  if select(2, meExportBus.getConfiguration(i)) ~= "no export bus" then
--    exportBusSide = i
--    break
--  end
--end