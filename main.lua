local robot = require("robot")
local component = require("component")
local sides = require("sides")

ic = component.getPrimary("inventory_controller")

C = {
    EMPT=nil,
    OVER="ic2:overclocked_heat_vent", -- желтый
    COMP="ic2:component_heat_vent", -- белый
    EXCH="ic2:component_heat_exchanger", --единственный
    PLAT="ic2:plating"
}

-- 9x6
reactorSchema = {
    {C.EMPT, C.COMP, C.OVER, C.EXCH, C.OVER, C.OVER, C.COMP, C.OVER, C.PLAT},
    {C.PLAT, C.COMP, C.OVER, C.OVER, C.COMP, C.OVER, C.OVER, C.EMPT, C.OVER},
    {C.PLAT, C.OVER, C.EMPT, C.OVER, C.OVER, C.EMPT, C.OVER, C.OVER, C.COMP},
    {C.COMP, C.OVER, C.OVER, C.COMP, C.OVER, C.OVER, C.COMP, C.OVER, C.PLAT},
    {C.OVER, C.EMPT, C.OVER, C.OVER, C.EMPT, C.OVER, C.OVER, C.EMPT, C.OVER},
    {C.PLAT, C.OVER, C.COMP, C.PLAT, C.OVER, C.COMP, C.PLAT, C.OVER, C.COMP}
}

expectedInventorySize = 54

function fillReactor()
    if ic.getInventorySize(sides.front) ~= expectedInventorySize then
        print("Reactor inventory should be " + expectedInventorySize)
        return
    end

end

fillReactor()

--function checkDust()
--    top = trans.getInventorySize(chest)
--    for i = 1,top do
--        inventory = trans.getStackInSlot(chest, i)
--        if inventory ~= nil then
--            for k,v in pairs(inventory) do
--                if k == "name" then
--                    if v == "minecraft:cobblestone" then
--                        trans.transferItem(chest, hammer, 1,i, 1)
--                        os.sleep(.5)
--                        trans.transferItem(hammer, chest)
--                    elseif v == "minecraft:gravel" then
--                        trans.transferItem(chest,hammer, 1,i,1)
--                        os.sleep(.5)
--                        trans.transferItem(hammer, chest)
--                    elseif v == "minecraft:sand" then
--                        trans.transferItem(chest, hammer, 1,i, 1)
--                        os.sleep(.5)
--						trans.transferItem(hammer, chest, 1,i,1)
--                    elseif v == "exnihloadscensio:blockDust" then
--						trans.transferItem(chest, siev, 1,i,1)
--					end
--                end
--            end
--        end
--    end
--end


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