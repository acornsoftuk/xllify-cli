local xllify = require("./xllify")

xllify.ExcelFunction({
    name = "xllify.Demo.Hello",
    description = "Says hello!",
    category = "xllify Demos",
    parameters = {
        {name="name", description="Name to greet"},
    },
}, function(name: string)
    name = name or "World"
    return "Hello, " .. name .. "!"
end)

xllify.ExcelFunction({
    name = "xllify.Demo.AgeCategory",
    description = "Determines your life stage based on age",
    category = "xllify Demos",
    parameters = {
        {name="age", description="Age in years"},
    },
}, function(age: number)
    if age < 0 then
        return "Baby"
    elseif age < 13 then
        return "Kid"
    elseif age < 20 then
        return "Annoying teenager"
    elseif age < 65 then
        return "Disillusioned adult"
    else
        return "OK boomer"
    end
end)

xllify.ExcelFunction({
    name = "xllify.Demo.Portfolio",
    description = "Generate sample portfolio holdings",
    category = "xllify Demos",
    parameters = {
        {name="num_positions", description="Number of positions to generate in the portfolio"},
        {name="total_value", description="Total portfolio value to distribute across positions"},
        {name="seed", description="Random seed for reproducible portfolio generation"},
    },
}, function(num_positions: number, total_value: number, seed: number)
    num_positions = num_positions or 10
    total_value = total_value or 1000000
    seed = seed or 321

    local rng_state = seed
    local function lcg_random()
        rng_state = (1103515245 * rng_state + 12345) % (2^31)
        return rng_state / (2^31)
    end

    local tickers = {"AAPL", "MSFT", "GOOGL", "AMZN", "META", "TSLA", "NVDA", "JPM", "BAC", "XOM",
                     "WMT", "JNJ", "PG", "V", "MA", "UNH", "HD", "DIS", "NFLX", "ADBE"}

    local portfolio = {}
    local remaining_value = total_value

    for i = 1, num_positions do
        local ticker = tickers[i] or ("TICK" .. i)

        -- Allocate random weight
        local weight
        if i == num_positions then
            weight = 1.0
        else
            weight = 0.3 + lcg_random() * 0.4  -- Between 30-70% of remaining
        end

        local position_value = remaining_value * weight
        remaining_value = remaining_value * (1 - weight)

        -- Generate price and quantity
        local price = 50 + lcg_random() * 200
        local quantity = math.floor(position_value / price)

        table.insert(portfolio, {ticker, quantity, price, quantity * price})
    end

    return portfolio
end)

return xllify