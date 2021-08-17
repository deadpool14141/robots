sides = require("sides")

local _M = {}

_M.leftChest= {
    address = "6953",
    stackSize = 64,
    side = sides.top
}

_M.rightChest = {
    address = "5e8",
    stackSize = 64,
    side = sides.top,
    sinkSide = "DOWN"
}

_M.leverSide = sides.back

return _M