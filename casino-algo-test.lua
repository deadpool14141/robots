math.randomseed(os.time())

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

SLOT_OPTION_COUNT = 4
SLOT_COUNT = 3

bet = 1
slotResults = {}
for i = 1, SLOT_COUNT do
    slotResults[i] = math.random(1, SLOT_OPTION_COUNT)
end

wonAmount = calculateWon(bet, slotResults)

print(wonAmount)




win_sum = 0

for i = 1, 1000000 do
    slotResults = {}
    for j = 1, SLOT_COUNT do
        slotResults[j] = math.random(1, SLOT_OPTION_COUNT)
    end

    win = calculateWon(1, slotResults)
    --print(win)
    win_sum = win_sum + win
end

print(win_sum)