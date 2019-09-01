sides = require("sides")

local _M = {}

_M.leftChest= {
    address = "",
    stackSize = 64,
    side = sides.top
}

_M.rightChest = {
    address = "",
    stackSize = 64,
    side = sides.top,
    sinkSide = sides.bottom
}

_M.leverSide = sides.back

return _M