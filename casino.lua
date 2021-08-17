config = require("configcasino")

component = require("component")
gpu = component.gpu
redstone = component.redstone
sides = require("sides")
term = require("term")
colors = require("colors")

gpu.setResolution(80, 25)
term.clear()
math.randomseed(os.time())

CREDITS_LABEL = "Credits: "
WON_LABEL = "You won: "
WON_LABEL_Y = 10

CHEST_STACK_SIZE = 64
SCREEN_RESOLUTION_W, SCREEN_RESOLUTION_H = gpu.getResolution()
SCREEN_CENTER_X = SCREEN_RESOLUTION_W / 2

bufferData = {
    creditsX = nil,
}

SLOT_COUNT = 3
SLOT_OPTION_COUNT = 4
SLOT_X_OFFSET = 5
SLOT_Y_OFFSET = 5
SLOT_WIDTH = math.floor(SCREEN_RESOLUTION_W / SLOT_COUNT) - 2 * SLOT_X_OFFSET
SLOT_HEIGHT = math.floor(SCREEN_RESOLUTION_H / SLOT_COUNT)
slotYStart = SCREEN_RESOLUTION_H - SLOT_HEIGHT - SLOT_Y_OFFSET
ROLL_COUNT = 15

INVENTORY_SIZE = 27


SLOT_COLORS = {
    0xFFFFFF,
    0x4F86F7,
    0xA335EE,
    0xFF8000
}

cmps = {}

leftChestAmount = 0
rightChestAmount = 0

credits = 0


function setComponent(obj, keyName, address)
    cmp = component.proxy(component.get(address))

    if cmp ~= nil then
        obj[keyName] = cmp
    else
        print("No component with address: " .. address)
        os.exit()
    end
end

function lines_from(file)
  lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

function saveDataToFile(a, b)
  local f=io.open("data-casino.dat","w")
  f:write(a .. "\n")
  f:write(b)
  f:close()
end

function chestAmount(chest, side)
    chestSize = chest.getInventorySize(side)
    sum = 0

    for i = 1, chestSize do
        sum = sum + chest.getSlotStackSize(side, i)
    end

    return sum
end

function drawCredits(y, text)
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)

    if bufferData.creditsX == nil then
        bufferData.creditsX = math.floor(SCREEN_CENTER_X - #CREDITS_LABEL / 2)
        bufferData.creditsNumberX = bufferData.creditsX + #CREDITS_LABEL
        bufferData.creditsNumberWidth = SCREEN_RESOLUTION_W - bufferData.creditsNumberX
    end

    gpu.fill(bufferData.creditsNumberX, y, bufferData.creditsNumberWidth, 1, " ")
    gpu.set(bufferData.creditsX, y, text)
end

function clearStatus(y)
    gpu.setBackground(0x000000)

    gpu.fill(1, y, SCREEN_RESOLUTION_W, 1, " ")
end

function drawStatus(y, text, color)
    gpu.setBackground(0x000000)
    gpu.setForeground(color)

    clearStatus(y)

    textX = math.floor(SCREEN_CENTER_X - #text / 2)
    gpu.set(textX, y, text)
end

function draw()
    drawCredits(2, CREDITS_LABEL .. math.floor(credits))
end

function drawSlots(slotResults)
    for i = 1, ROLL_COUNT do
        for j = 1, SLOT_COUNT do
            gpu.setBackground(SLOT_COLORS[((i + j) % SLOT_OPTION_COUNT) + 1], false)

            local xCoord = SLOT_X_OFFSET + (j - 1) * 2 * SLOT_X_OFFSET + (j - 1) * SLOT_WIDTH
            gpu.fill(xCoord, slotYStart, SLOT_WIDTH, SLOT_HEIGHT, " ")
        end
        os.sleep(0.2)
    end

    for i = 1, SLOT_COUNT do
        gpu.setBackground(SLOT_COLORS[slotResults[i]], false)

        local xCoord = SLOT_X_OFFSET + (i - 1) * 2 * SLOT_X_OFFSET + (i - 1) * SLOT_WIDTH
        gpu.fill(xCoord, slotYStart, SLOT_WIDTH, SLOT_HEIGHT, " ")
    end
end

function calculateWon(bet, slotResults)
    local a = math.floor(slotResults[1])
    local b = math.floor(slotResults[2])
    local c = math.floor(slotResults[3])

    if a == b and b == c and a == SLOT_OPTION_COUNT then
        return bet * 10
    end

    if a == b and b == c then
        return bet * 5
    end

    if a == c and a > SLOT_OPTION_COUNT - 3  and b == SLOT_OPTION_COUNT then
        return bet * 4
    end

    if a == b then
        return bet * 2
    end

    return 0
end

function payout(amount)
    if amount <= 0 then
        return
    end

    local chest = cmps.rightChest
    local side = config.rightChest.side
    local sinkSide = config.rightChest.sinkSide

    chestSize = chest.getInventorySize(side)

    i = 1

    while amount > 0 do
        local stackSize = chest.getSlotStackSize(side, i)
        local transferCount = math.min(stackSize, amount)

        if stackSize > 0 then
            if chest.transferItem(side, sinkSide, transferCount, i, i) then
                amount = amount - transferCount
            end
        end

        i = i + 1
        if i > INVENTORY_SIZE then
            i = 1
        end
    end


    for i = 1, chestSize do
        sum = sum + chest.getSlotStackSize(side, i)
    end
end

function startRound(bet)
    credits = credits - bet
    draw()
    slotResults = {}
    for i = 1, SLOT_COUNT do
        slotResults[i] = math.random(1, SLOT_OPTION_COUNT)
    end

    drawSlots(slotResults)

    wonAmount = calculateWon(bet, slotResults)

    if wonAmount > 0 then
        wonLabel = WON_LABEL .. math.floor(wonAmount) .. " credits"
        color = 0x00FF00
    else
        wonLabel = "You lose"
        color = 0xFF0000
    end
    drawStatus(WON_LABEL_Y, wonLabel, color)

    payout(wonAmount)

end

-- BODY Begin

setComponent(cmps, "leftChest", config.leftChest.address)
setComponent(cmps, "rightChest", config.rightChest.address)

dataFileLines = lines_from("data-casino.dat")
leftChestAmount = tonumber(dataFileLines[1])
rightChestAmount = tonumber(dataFileLines[2])

isReadyToSpin = true

while true do
    local shouldSave = false
    local newLCA = chestAmount(cmps.leftChest, config.leftChest.side)

    if newLCA ~= leftChestAmount then
        if newLCA < leftChestAmount then
            credits = credits + (leftChestAmount - newLCA)
        end
        leftChestAmount = newLCA
        shouldSave = true
    end

    if shouldSave then
        saveDataToFile(leftChestAmount, rightChestAmount)
    end

    draw()

    leverSignal = redstone.getInput(config.leverSide)
    if isReadyToSpin and leverSignal > 0 and credits > 0 then
        drawStatus(WON_LABEL_Y, "Rolling...", 0xFFFFFF)
        startRound(1)
        isReadyToSpin = false
    elseif isReadyToSpin and leverSignal > 0 and credits <= 0 then
        drawStatus(WON_LABEL_Y, "You have no credits", 0xFF0000)
    elseif isReadyToSpin == false and leverSignal == 0 then
        isReadyToSpin = true
    end

    os.sleep()
end
