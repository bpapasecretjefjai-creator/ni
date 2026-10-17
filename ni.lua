local TweenService = game:GetService("TweenService")
local LogService = game:GetService("LogService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Cyber / Futuristic Dark Palette
local THEME = {
	Background = Color3.fromRGB(11, 14, 22),
	Header = Color3.fromRGB(18, 22, 34),
	Container = Color3.fromRGB(7, 9, 15),
	AccentNeon = Color3.fromRGB(0, 230, 255),
	AccentGlow = Color3.fromRGB(0, 140, 255),
	TextPrimary = Color3.fromRGB(240, 245, 255),
	TextMuted = Color3.fromRGB(100, 115, 145),
	Border = Color3.fromRGB(30, 42, 62),
	
	-- Action Palette
	PrimaryBtn = Color3.fromRGB(20, 28, 45),
	Close = Color3.fromRGB(255, 65, 85),
	Success = Color3.fromRGB(0, 200, 120)
}

local SAVE_FILE_NAME = "saved_script.lua"
local isInjected = false

-- Cleanup previous instance
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("CyberX_UI") then
	LocalPlayer.PlayerGui.CyberX_UI:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CyberX_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Circular Floating Toggle Button with Pulse Effect
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 30, 0, 30)
ToggleBtn.BackgroundColor3 = THEME.Header
ToggleBtn.BorderSizePixel = 0
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = THEME.AccentNeon
ToggleStroke.Thickness = 2
ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ToggleStroke.Parent = ToggleBtn

local ToggleIcon = Instance.new("TextLabel")
ToggleIcon.Size = UDim2.new(1, 0, 1, 0)
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Text = "⚡"
ToggleIcon.TextColor3 = THEME.AccentNeon
ToggleIcon.TextSize = 22
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.Parent = ToggleBtn

-- Main Frame Setup (Slightly widened to fit all buttons smoothly)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 680, 0, 430)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -215)
MainFrame.BackgroundColor3 = THEME.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = THEME.AccentGlow
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = THEME.Header
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 220, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ CYBER <font color=\"rgb(0,230,255)\">X</font> EXECUTOR"
Title.RichText = true
Title.TextColor3 = THEME.TextPrimary
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = THEME.Close
CloseBtn.BackgroundTransparency = 0.85
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = THEME.Close
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, TextColor3 = THEME.Close}):Play()
end)

-- Content Area
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -28, 1, -60)
Content.Position = UDim2.new(0, 14, 0, 52)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Editor Container
local CodeContainer = Instance.new("Frame")
CodeContainer.Size = UDim2.new(1, 0, 0, 190)
CodeContainer.BackgroundColor3 = THEME.Container
CodeContainer.Parent = Content

local CodeCorner = Instance.new("UICorner")
CodeCorner.CornerRadius = UDim.new(0, 8)
CodeCorner.Parent = CodeContainer

local CodeStroke = Instance.new("UIStroke")
CodeStroke.Color = THEME.Border
CodeStroke.Thickness = 1
CodeStroke.Parent = CodeContainer

local LineNumbers = Instance.new("TextLabel")
LineNumbers.Size = UDim2.new(0, 30, 1, -12)
LineNumbers.Position = UDim2.new(0, 0, 0, 6)
LineNumbers.BackgroundTransparency = 1
LineNumbers.Text = "1"
LineNumbers.TextColor3 = THEME.TextMuted
LineNumbers.TextSize = 12
LineNumbers.Font = Enum.Font.Code
LineNumbers.TextYAlignment = Enum.TextYAlignment.Top
LineNumbers.Parent = CodeContainer

local CodeScroll = Instance.new("ScrollingFrame")
CodeScroll.Size = UDim2.new(1, -38, 1, -12)
CodeScroll.Position = UDim2.new(0, 32, 0, 6)
CodeScroll.BackgroundTransparency = 1
CodeScroll.BorderSizePixel = 0
CodeScroll.ScrollBarThickness = 3
CodeScroll.ScrollBarImageColor3 = THEME.AccentGlow
CodeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
CodeScroll.AutomaticCanvasSize = Enum.AutomaticSize.XY
CodeScroll.Parent = CodeContainer

local CodeInput = Instance.new("TextBox")
CodeInput.Size = UDim2.new(1, 0, 1, 0)
CodeInput.BackgroundTransparency = 1
-- Pre-filled with your loadstring script
CodeInput.Text = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/bpapasecretjefjai-creator/-p/refs/heads/main/%3Ap.lua"))()'
CodeInput.TextColor3 = THEME.TextPrimary
CodeInput.TextSize = 12
CodeInput.Font = Enum.Font.Code
CodeInput.TextXAlignment = Enum.TextXAlignment.Left
CodeInput.TextYAlignment = Enum.TextYAlignment.Top
CodeInput.ClearTextOnFocus = false
CodeInput.MultiLine = true
CodeInput.Parent = CodeScroll

local function UpdateLineNumbers()
	local lines = #CodeInput.Text:split("\n")
	local lineStr = ""
	for i = 1, math.max(lines, 12) do
		lineStr = lineStr .. i .. "\n"
	end
	LineNumbers.Text = lineStr
end
CodeInput:GetPropertyChangedSignal("Text"):Connect(UpdateLineNumbers)
UpdateLineNumbers()

-- Button Toolbar Layout
local ButtonBar = Instance.new("Frame")
ButtonBar.Size = UDim2.new(1, 0, 0, 34)
ButtonBar.Position = UDim2.new(0, 0, 0, 198)
ButtonBar.BackgroundTransparency = 1
ButtonBar.Parent = Content

local ButtonLayout = Instance.new("UIListLayout")
ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
ButtonLayout.Padding = UDim.new(0, 5)
ButtonLayout.Parent = ButtonBar

local function CreateBtn(name, text, width)
	local Btn = Instance.new("TextButton")
	Btn.Name = name
	Btn.Size = UDim2.new(0, width or 85, 1, 0)
	Btn.BackgroundColor3 = THEME.PrimaryBtn
	Btn.Text = text
	Btn.TextColor3 = THEME.TextPrimary
	Btn.Font = Enum.Font.GothamBold
	Btn.TextSize = 10
	Btn.AutoButtonColor = false
	Btn.Parent = ButtonBar

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Btn

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = THEME.Border
	Stroke.Thickness = 1
	Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	Stroke.Parent = Btn

	Btn.MouseEnter:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.Header}):Play()
		TweenService:Create(Stroke, TweenInfo.new(0.15), {Color = THEME.AccentNeon}):Play()
	end)
	Btn.MouseLeave:Connect(function()
		TweenService:Create(Btn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.PrimaryBtn}):Play()
		TweenService:Create(Stroke, TweenInfo.new(0.15), {Color = THEME.Border}):Play()
	end)

	return Btn
end

local InjectBtn = CreateBtn("InjectBtn", "🔌 INJECT", 90)
local ExecuteBtn = CreateBtn("ExecuteBtn", "▶ EXECUTE", 90)
local SaveBtn = CreateBtn("SaveBtn", "💾 SAVE", 80)
local LoadBtn = CreateBtn("LoadBtn", "📁 LOAD", 80)
local ClearCodeBtn = CreateBtn("ClearCodeBtn", "CLR CODE", 85)
local ClearLogsBtn = CreateBtn("ClearLogsBtn", "CLR LOGS", 85)

-- Output Console Log
local LogContainer = Instance.new("Frame")
LogContainer.Size = UDim2.new(1, 0, 0, 120)
LogContainer.Position = UDim2.new(0, 0, 0, 240)
LogContainer.BackgroundColor3 = THEME.Container
LogContainer.Parent = Content

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 8)
LogCorner.Parent = LogContainer

local LogStroke = Instance.new("UIStroke")
LogStroke.Color = THEME.Border
LogStroke.Thickness = 1
LogStroke.Parent = LogContainer

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(1, -16, 1, -12)
LogScroll.Position = UDim2.new(0, 8, 0, 6)
LogScroll.BackgroundTransparency = 1
LogScroll.BorderSizePixel = 0
LogScroll.ScrollBarThickness = 3
LogScroll.ScrollBarImageColor3 = THEME.TextMuted
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogScroll.Parent = LogContainer

local LogLayout = Instance.new("UIListLayout")
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 3)
LogLayout.Parent = LogScroll

-- Smooth Window Dragging Logic
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		TweenService:Create(MainFrame, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		}):Play()
	end
end)

-- Toggle & Open Animation
local isOpen = false
local function ToggleUI()
	isOpen = not isOpen
	if isOpen then
		MainFrame.Size = UDim2.new(0, 0, 0, 0)
		MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		MainFrame.Visible = true
		TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 680, 0, 430),
			Position = UDim2.new(0.5, -340, 0.5, -215)
		}):Play()
	else
		local tween = TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		tween:Play()
		tween.Completed:Wait()
		MainFrame.Visible = false
	end
end

ToggleBtn.MouseButton1Click:Connect(ToggleUI)
CloseBtn.MouseButton1Click:Connect(ToggleUI)

-- Console Output Handler
LogService.MessageOut:Connect(function(msg, msgType)
	local color = Color3.fromRGB(200, 205, 215)
	if msgType == Enum.MessageType.MessageWarning then
		color = Color3.fromRGB(255, 180, 50)
	elseif msgType == Enum.MessageType.MessageError then
		color = Color3.fromRGB(255, 80, 80)
	end

	local LogEntry = Instance.new("TextLabel")
	LogEntry.Size = UDim2.new(1, 0, 0, 15)
	LogEntry.BackgroundTransparency = 1
	LogEntry.Text = string.format("<font color=\"rgb(80,100,130)\">[%s]</font> %s", os.date("%X"), msg)
	LogEntry.RichText = true
	LogEntry.TextColor3 = color
	LogEntry.TextSize = 11
	LogEntry.Font = Enum.Font.Code
	LogEntry.TextXAlignment = Enum.TextXAlignment.Left
	LogEntry.Parent = LogScroll

	LogScroll.CanvasPosition = Vector2.new(0, LogScroll.AbsoluteCanvasSize.Y)
end)

-- Button Functionalities
InjectBtn.MouseButton1Click:Connect(function()
	if isInjected then return end
	InjectBtn.Text = "⏳ INJECTING..."
	task.delay(1.5, function()
		isInjected = true
		InjectBtn.Text = "✔ INJECTED"
		InjectBtn.TextColor3 = THEME.Success
		print("Cyber X successfully hooked to client.")
	end)
end)

ExecuteBtn.MouseButton1Click:Connect(function()
	if not isInjected then
		warn("Please inject Cyber X first!")
		return
	end
	local code = CodeInput.Text
	if code == "" then return end
	local fn, err = loadstring(code)
	if not fn then
		warn("Syntax Error: " .. tostring(err))
		return
	end
	pcall(fn)
end)

ClearCodeBtn.MouseButton1Click:Connect(function()
	CodeInput.Text = ""
end)

ClearLogsBtn.MouseButton1Click:Connect(function()
	for _, child in ipairs(LogScroll:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
end)
