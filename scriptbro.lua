local coreGui = game:GetService("CoreGui")
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")
local localPlayer = players.LocalPlayer

local correctKey = "test-123"
local telegramLink = "https://t.me/everyoneVSkwatro"

if coreGui:FindFirstChild("SourcesHubCore") then
    coreGui.SourcesHubCore:Destroy()
end

local sourcesHubCore = Instance.new("ScreenGui")
sourcesHubCore.Name = "SourcesHubCore"
sourcesHubCore.ResetOnSpawn = false
sourcesHubCore.Parent = coreGui

-- ====================================================================
-- NOTIFICATION UTILITY
-- ====================================================================
local function createFrame(text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 32)
    frame.Position = UDim2.new(1, 10, 1, -45)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BorderSizePixel = 0
    frame.Parent = sourcesHubCore

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = frame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 255, 255) -- White Outline
    uiStroke.Thickness = 1
    uiStroke.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -12, 1, 0)
    textLabel.Position = UDim2.new(0, 6, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
    textLabel.TextSize = 10
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame

    tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = UDim2.new(1, -230, 1, -45) }):Play()

    task.delay(2.5, function()
        local create = tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Position = UDim2.new(1, 10, 1, -45) })
        create:Play()
        create.Completed:Connect(function() frame:Destroy() end)
    end)
end

-- ====================================================================
-- CORE FUNCTIONALITIES (ANTI-LAG)
-- ====================================================================
local iteratePlayers

local function showAntiLagPrompt()
    local promptFrame = Instance.new("Frame")
    promptFrame.Size = UDim2.new(0, 260, 0, 120)
    promptFrame.Position = UDim2.new(0.5, -130, 0.5, -60)
    promptFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    promptFrame.BorderSizePixel = 0
    promptFrame.Parent = sourcesHubCore

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = promptFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = promptFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 0, 50)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Do you want to hide all players to reduce lag?"
    textLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
    textLabel.TextSize = 12
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextWrapped = true
    textLabel.Parent = promptFrame

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 100, 0, 30)
    yesBtn.Position = UDim2.new(0, 20, 1, -40)
    yesBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    yesBtn.Text = "YES"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.TextSize = 11
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Parent = promptFrame

    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    yesBtn.UICorner.Parent = yesBtn
    local yesStroke = Instance.new("UIStroke")
    yesStroke.Color = Color3.fromRGB(255, 255, 255)
    yesStroke.Parent = yesBtn

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 100, 0, 30)
    noBtn.Position = UDim2.new(1, -120, 1, -40)
    noBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    noBtn.Text = "NO"
    noBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    noBtn.TextSize = 11
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = promptFrame

    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    noBtn.UICorner.Parent = noBtn
    local noStroke = Instance.new("UIStroke")
    noStroke.Color = Color3.fromRGB(100, 100, 100)
    noStroke.Parent = noBtn

    yesBtn.MouseButton1Click:Connect(function()
        iteratePlayers()
        promptFrame:Destroy()
    end)
    noBtn.MouseButton1Click:Connect(function() promptFrame:Destroy() end)
end

function iteratePlayers()
    local function hideChar(char)
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
        end
    end
    for _, p in pairs(players:GetPlayers()) do
        if p ~= localPlayer and p.Character then hideChar(p.Character) end
    end
    players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function(c)
            if p ~= localPlayer then task.wait(0.5) hideChar(c) end
        end)
    end)
    createFrame("Other Players Hidden")
end

local function runAntiLag()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        lighting.GlobalShadows = false
        lighting.FogEnd = 999999999
        lighting.Brightness = 1
        for _, v in ipairs(lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") then
                v.Enabled = false
            end
        end
        local function cleanPart(v)
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
        for _, v in ipairs(workspace:GetDescendants()) do cleanPart(v) end
        workspace.DescendantAdded:Connect(function(v) task.wait() cleanPart(v) end)
    end)
    createFrame("Anti-Lag Activated")
end

-- ====================================================================
-- MAIN HUB INTERFACE ARCHITECTURE
-- ====================================================================
local function buildMainHub()
    runAntiLag()
    showAntiLagPrompt()
    createFrame("Script Executed Successfully")

    local glowFrame = Instance.new("Frame")
    glowFrame.Name = "GlowFrame"
    glowFrame.Size = UDim2.new(0, 340, 0, 340)
    glowFrame.Position = UDim2.new(0.5, -170, 0.5, -170)
    glowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    glowFrame.BorderSizePixel = 0
    glowFrame.Parent = sourcesHubCore

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, -4, 1, -4)
    mainFrame.Position = UDim2.new(0, 2, 0, 2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = glowFrame

    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    glowFrame.UICorner.Parent = glowFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    mainFrame.UICorner.Parent = mainFrame

    local hubStroke = Instance.new("UIStroke")
    hubStroke.Color = Color3.fromRGB(255, 255, 255)
    hubStroke.Thickness = 1.5
    hubStroke.Parent = mainFrame

    -- TOP BAR
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "TEST NI KWATRO"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    local tgBtn = Instance.new("TextButton")
    tgBtn.Size = UDim2.new(0, 32, 0, 24)
    tgBtn.Position = UDim2.new(1, -68, 0.5, -12)
    tgBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tgBtn.Text = "[TG]"
    tgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tgBtn.TextSize = 10
    tgBtn.Font = Enum.Font.GothamBold
    tgBtn.Parent = topBar
    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    tgBtn.UICorner.Parent = tgBtn
    local tgStroke = Instance.new("UIStroke")
    tgStroke.Color = Color3.fromRGB(255, 255, 255)
    tgStroke.Parent = tgBtn

    tgBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(telegramLink)
            createFrame("Telegram Link Copied!")
        else
            createFrame("Clipboard not supported!")
        end
    end)

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 24, 0, 24)
    minBtn.Position = UDim2.new(1, -30, 0.5, -12)
    minBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    minBtn.Text = "_"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 12
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = topBar
    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    minBtn.UICorner.Parent = minBtn

    -- ====================================================================
    -- ROBLOX LIVE PLAYER STATS COMPONENT
    -- ====================================================================
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, -16, 0, 42)
    statsFrame.Position = UDim2.new(0, 8, 0, 44)
    statsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = mainFrame

    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    statsFrame.UICorner.Parent = statsFrame
    local statsStroke = Instance.new("UIStroke")
    statsStroke.Color = Color3.fromRGB(100, 100, 100)
    statsStroke.Thickness = 1
    statsStroke.Parent = statsFrame

    local function createStatLabel(pos, text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.25, -4, 1, 0)
        lbl.Position = pos
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.TextSize = 9
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextWrapped = true
        lbl.Parent = statsFrame
        return lbl
    end

    local userStat = createStatLabel(UDim2.new(0, 2, 0, 0), "User:
" .. localPlayer.Name)
    local ageStat = createStatLabel(UDim2.new(0.25, 2, 0, 0), "Age:
" .. localPlayer.AccountAge .. " Days")
    local fpsStat = createStatLabel(UDim2.new(0.5, 2, 0, 0), "FPS:
0")
    local pingStat = createStatLabel(UDim2.new(0.75, 2, 0, 0), "Ping:
0ms")

    local fpsCount = 0
    runService.RenderStepped:Connect(function(dt)
        fpsCount = math.round(1 / dt)
        fpsStat.Text = "FPS:
" .. fpsCount
        local currentPing = math.round(localPlayer:GetNetworkPing() * 1000)
        pingStat.Text = "Ping:
" .. currentPing .. "ms"
    end)

    -- SEARCH FIELD SYSTEM
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.new(1, -16, 0, 30)
    searchFrame.Position = UDim2.new(0, 8, 0, 92)
    searchFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    searchFrame.Parent = mainFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    searchFrame.UICorner.Parent = searchFrame
    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = Color3.fromRGB(150, 150, 150)
    searchStroke.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -34, 1, 0)
    searchBox.Position = UDim2.new(0, 8, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.PlaceholderText = "Search scripts..."
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    searchBox.TextSize = 10
    searchBox.Font = Enum.Font.GothamSemibold
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchFrame

    local clearSearch = Instance.new("TextButton")
    clearSearch.Size = UDim2.new(0, 24, 0, 24)
    clearSearch.Position = UDim2.new(1, -26, 0.5, -12)
    clearSearch.BackgroundTransparency = 1
    clearSearch.Text = "X"
    clearSearch.TextColor3 = Color3.fromRGB(200, 50, 50)
    clearSearch.TextSize = 11
    clearSearch.Font = Enum.Font.GothamBold
    clearSearch.Parent = searchFrame

    clearSearch.MouseButton1Click:Connect(function()
        searchBox.Text = ""
    end)

    -- CONTAINER LIST
    local scrollContainer = Instance.new("ScrollingFrame")
    scrollContainer.Size = UDim2.new(1, -16, 1, -134)
    scrollContainer.Position = UDim2.new(0, 8, 0, 128)
    scrollContainer.BackgroundTransparency = 1
    scrollContainer.BorderSizePixel = 0
    scrollContainer.ScrollBarThickness = 3
    scrollContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scrollContainer.Parent = mainFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Padding = UDim.new(0, 6)
    uiListLayout.Parent = scrollContainer

    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollContainer.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 8)
    end)

    local kwatroHubList = {
        { Name = "AIRFLOW HUB", Script = "loadstring(game:HttpGet(\"https://airflowscript.com/loader\"))()" },
        { Name = "ANTI HIT", Script = "script_key = \"Trial\"; loadstring(game:HttpGet(\"https://api.getpolsec.com/scripts/hosted/6582551b42d21c6b7eb55f1d76d8d50ce53cb35592093d6615b5e83437594dc0.lua\"))()" },
        { Name = "ASVRA HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/asvraRoblox/stealegg/refs/heads/main/main\"))()" },
        { Name = "AXON HUB", Script = "loadstring(game:HttpGet(\"https://api.luarmor.net/files/element/loaders/97c3f6db55a2cf72141537a85458e5a7.lua\"))()" },
        { Name = "AXONIC HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/Kenniel123/Steal-A-Egg/refs/heads/main/Steal%20A%20Egg\"))()" },
        { Name = "BIGFROOT", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua\"))()" },
        { Name = "BK HUB", Script = "loadstring(game:HttpGet(\"https://api.luarmor.net/files/val5/loaders/9ee4edde227ac85f50872bf9e4226508.lua\"))()" },
        { Name = "BLYXO HUB", Script = "loadstring(game:HttpGet(\"https://flowauth.net/val3/loaders/69d3463240384f3a73fbe32c178093a2.lua\"))()" },
        { Name = "CHILI HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua\"))()" },
        { Name = "CLOVER HUB", Script = "loadstring(game:HttpGet(\"https://rawscripts.net/raw/Steal-An-Egg-Clover-Hub-or-Auto-Steal-Egg-Predictor-Auto-Hatch-and-ESP-226600\"))()" },
        { Name = "DECODE HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/ItzYumi/Decode/refs/heads/main/DE%3ACODE.lua"))()" },
        { Name = "FLOW HUB", Script = "loadstring(game:HttpGet(\"https://api.luarmor.net/files/val5/loaders/5946add9ab91f1e04cb005346a8b1968.lua\"))()" },
        { Name = "FOXNAME HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/Bliqe/Upload/refs/heads/main/Games/RUO/12665928789.lua\"))()" },
        { Name = "FYY HUB", Script = "loadstring(game:HttpGet(\"https://FyyCommunity.my.id\"))()" },
        { Name = "GS HUB", Script = "loadstring(game:HttpGet(\"https://gist.githubusercontent.com/spiritualgaming1123-beep/46ef55c5f8284e076aafc5ebd12233f4/raw/5b24749c3931c1838a76e64c9af508dcdd03700a/gistfile1.lua\"))()" },
        { Name = "HOSHI HUB", Script = "loadstring(game:HttpGet(\"https://hoshihub.site/loader.lua\"))()" },
        { Name = "KEXXE HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/premiumbuddy/kex/refs/heads/main/kexxxx\"))()" },
        { Name = "LENNON HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/lennonxscripts/lennonhubv2/main/stealaneggv2\"))()" },
        { Name = "LEST HUB", Script = "getgenv().SCRIPT_KEY = \"KEYLESS\"; loadstring(game:HttpGet(\"https://api.jnkie.com/api/val3/luascripts/public/c916d48837ab69c48a9b3cafb04b49c8d9253af84cf8e403b19e2be302cbe67a/download\"))()" },
        { Name = "LUMIN HUB", Script = "loadstring(game:HttpGet(\"http://luminon.top/loader.lua\"))()" },
        { Name = "MIRANDA HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/miirandahub/loader/refs/heads/main/stealaeggs\"))()" },
        { Name = "MOSHI HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/moshixzn/ahhagdienavd/refs/heads/main/Loader.lua.txt\"))()" },
        { Name = "NASI HUB PREMIUM", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()" },
        { Name = "NASI RENDANG HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()" },
        { Name = "NEMESIS HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/loader/main/freeloader.lua", true))()" },
        { Name = "NEOX HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/NEOXHUBMAIN/refs/heads/main/loader", true))()" },
        { Name = "NOVA HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua\"))()" },
        { Name = "OBUROSBOS", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))()" },
        { Name = "OMG HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua\"))()" },
        { Name = "ON HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/davizin713/ONhub/refs/heads/main/script.lua\"))()" },
        { Name = "OXIDE HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/xulfo/Oxide-Loader/main/Main.lua"))()" },
        { Name = "PET SPAWNER", Script = "loadstring(game:HttpGet(\"https://scriptversekey.xyz/s/steal-an-egg-pet-spawner\"))()" },
        { Name = "PIG HUB", Script = "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/mopsscript7-gif/steal-an-egg/refs/heads/main/script.lua\"))()" },
        { Name = "PROBEST HUB", Script = "loadstring(game:HttpGet(\"https://api.jnkie.com/api/val3/luascripts/public/0199b576f5c2d5a34159f0f9f4e1de0a566b4d1da5b1cfa5d2f71ade9bdcaa24/download\"))()" },
        { Name = "SAIOPS HUB", Script = "loadstring(game:HttpGet(\"https://api.saiops.cc/scripts/Steal-An-Egg-Script.lua\"))()" },
        { Name = "SCRIPTVERSE HUB", Script = "loadstring(game:HttpGet(\"https://scriptversekey.xyz/s/steal-an-egg\"))()" },
        { Name = "SENA HUB", Script = "loadstring(game:HttpGet('https://raw.githubusercontent.com/senarblx/sena/refs/heads/main/loader'))()" },
        { Name = "SERVER FINDER 1 PEOPLE", Script = "loadstring(game:HttpGet(\"https://api.obscuravm.com/scripts/8232205074136213997\"))()" },
        { Name = "SNOWY HUB", Script = "loadstring(game:HttpGet(\"https://flowauth.net/val3/ui/a87f00d9adf63658655fcd02ab86a4ef.lua\"))()" },
        { Name = "SOLIX HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/bao8jl/solixhub/main/loader"))()" },
        { Name = "SPEED HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()" },
        { Name = "SPORTSCLUB HUB", Script = "loadstring(game:HttpGet("https://loader.sportsclub.fun/loader.luau\"))()" },
        { Name = "STEAL AN EGG", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/Dodoyung24/script-core/main/Steal-An-Egg\"))()" },
        { Name = "UB HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/TeamUBHub/UBLoader/refs/heads/main/Loader.lua\"))()" },
        { Name = "VALINC HUB", Script = "loadstring(game:HttpGet("https://api.valincsyndicate.com/val3/releases/5502cba03703f4a3628d522d396b80d8.lua\"))()" },
        { Name = "VANTAGE HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/MisterNovitski/Vantage/refs/heads/main/mm2.txt", true))()" },
        { Name = "VXEZE HUB", Script = "loadstring(game:HttpGet("https://vxezestudio.online/api/scripts/script_G5CGjqj2X3rOS/stream/init\"))()" },
        { Name = "YURI HUB", Script = "_G.autoExec = false; loadstring(game:HttpGet("https://raw.githubusercontent.com/iLove-yuri/leeeeesbian/refs/heads/main/homumado.lua"))()" },
        { Name = "ZERO HUB", Script = "loadstring(game:HttpGet("https://www.zeroimpact.online/raw/loader\"))()" },
        { Name = "ZERO POINT HUB", Script = "loadstring(game:HttpGet("https://raw.githubusercontent.com/JaxRol/ZeroPoint/refs/heads/main/KeySystem\"))()" },
        { Name = "ZEROIN HUB", Script = "loadstring(game:HttpGet("https://zeroinhub.com/api/script\"))()" },
        { Name = "ZK HUB", Script = "_G.Config = {ApiKey = "ZKCOMMUNITYcfdb742a751aad57d79b375ea6c7cbc7"}; loadstring(game:HttpGet("https://zkcommunity.cloud/loader.lua"))()" }
    }

    table.sort(kwatroHubList, function(a, b) return a.Name:lower() < b.Name:lower() end)

    local renderedItems = {}

    for idx, item in ipairs(kwatroHubList) do
        local row = Instance.new("Frame")
        row.LayoutOrder = idx
        row.Size = UDim2.new(1, -4, 0, 32)
        row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        row.Parent = scrollContainer

        Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
        row.UICorner.Parent = row
        local rowStroke = Instance.new("UIStroke")
        rowStroke.Color = Color3.fromRGB(40, 40, 40)
        rowStroke.Parent = row

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.65, 0, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = item.Name
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextSize = 10
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local execBtn = Instance.new("TextButton")
        execBtn.Size = UDim2.new(0, 75, 0, 22)
        execBtn.Position = UDim2.new(1, -81, 0.5, -11)
        execBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        execBtn.Text = "EXECUTE"
        execBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
        execBtn.TextSize = 9
        execBtn.Font = Enum.Font.GothamBold
        execBtn.Parent = row

        Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
        execBtn.UICorner.Parent = execBtn
        local execStroke = Instance.new("UIStroke")
        execStroke.Color = Color3.fromRGB(150, 150, 150)
        execStroke.Parent = execBtn

        execBtn.MouseButton1Click:Connect(function()
            pcall(function() loadstring(item.Script)() end)
            execBtn.Text = "LOADED"
            execBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            execStroke.Color = Color3.fromRGB(100, 100, 100)
            createFrame("Executed " .. item.Name)
            task.delay(2, function()
                execBtn.Text = "EXECUTE"
                execBtn.TextColor3 = Color3.fromRGB(245, 245, 245)
                execStroke.Color = Color3.fromRGB(150, 150, 150)
            end)
        end)

        renderedItems[item.Name] = row
    end

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchBox.Text:lower()
        for name, instance in pairs(renderedItems) do
            if query == "" or name:lower():find(query) then
                instance.Visible = true
            else
                instance.Visible = false
            end
        end
    end)

    -- DRAGGING LOOPS
    local dragToggle, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = glowFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    userInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
            local delta = input.Position - dragStart
            glowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- MINIMIZE ACTIONS
    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        if isMinimized then
            scrollContainer.Visible = true
            searchFrame.Visible = true
            statsFrame.Visible = true
            minBtn.Text = "_"
            tweenService:Create(glowFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 340, 0, 340) }):Play()
            isMinimized = false
        else
            minBtn.Text = "+"
            local tween = tweenService:Create(glowFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 340, 0, 40) })
            scrollContainer.Visible = false
            searchFrame.Visible = false
            statsFrame.Visible = false
            tween:Play()
            isMinimized = true
        end
    end)

    -- KEYBIND TOGGLE GUI
    userInputService.InputBegan:Connect(function(input, processed)
        if not processed and (input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.Insert) then
            glowFrame.Visible = not glowFrame.Visible
        end
    end)
end

-- ====================================================================
-- SYSTEM LOCK & VALIDATION LOOPS (KEY SYSTEM)
-- ====================================================================
local function initKeyVerification()
    -- Check for Save Key File
    if readfile and isfile and isfile("kwatro_key.txt") then
        local saved = readfile("kwatro_key.txt")
        if saved == correctKey then
            buildMainHub()
            return
        end
    end

    local lockFrame = Instance.new("Frame")
    lockFrame.Size = UDim2.new(0, 260, 0, 160)
    lockFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
    lockFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    lockFrame.BorderSizePixel = 0
    lockFrame.Parent = sourcesHubCore

    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    lockFrame.UICorner.Parent = lockFrame
    local lockStroke = Instance.new("UIStroke")
    lockStroke.Color = Color3.fromRGB(255, 255, 255)
    lockStroke.Thickness = 1.5
    lockStroke.Parent = lockFrame

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundTransparency = 1
    header.Text = "KWATRO SYSTEM LOCK"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 11
    header.Font = Enum.Font.GothamBold
    header.Parent = lockFrame

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -32, 0, 32)
    keyInput.Position = UDim2.new(0, 16, 0, 45)
    keyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    keyInput.PlaceholderText = "Enter verification key..."
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 10
    keyInput.Font = Enum.Font.GothamSemibold
    keyInput.Parent = lockFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    keyInput.UICorner.Parent = keyInput
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(100, 100, 100)
    inputStroke.Parent = keyInput

    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0, 105, 0, 32)
    verifyBtn.Position = UDim2.new(0, 16, 0, 95)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    verifyBtn.Text = "VERIFY"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 10
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.Parent = lockFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    verifyBtn.UICorner.Parent = verifyBtn
    local verifyStroke = Instance.new("UIStroke")
    verifyStroke.Color = Color3.fromRGB(255, 255, 255)
    verifyStroke.Parent = verifyBtn

    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0, 105, 0, 32)
    getKeyBtn.Position = UDim2.new(1, -121, 0, 95)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    getKeyBtn.Text = "GET KEY"
    getKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    getKeyBtn.TextSize = 10
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.Parent = lockFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
    getKeyBtn.UICorner.Parent = getKeyBtn
    local getStroke = Instance.new("UIStroke")
    getStroke.Color = Color3.fromRGB(150, 150, 150)
    getStroke.Parent = getKeyBtn

    getKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(telegramLink)
            createFrame("Telegram Link Copied!")
        else
            createFrame("Clipboard error!")
        end
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        if keyInput.Text == correctKey then
            if writefile then
                writefile("kwatro_key.txt", correctKey)
            end
            createFrame("Key Verified Successfully!")
            lockFrame:Destroy()
            buildMainHub()
        else
            verifyBtn.Text = "INVALID KEY"
            verifyStroke.Color = Color3.fromRGB(200, 50, 50)
            task.delay(1.5, function()
                verifyBtn.Text = "VERIFY"
                verifyStroke.Color = Color3.fromRGB(255, 255, 255)
            end)
        end
    end)
end

initKeyVerification()
