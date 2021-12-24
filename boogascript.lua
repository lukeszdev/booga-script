local key = "5jpNXX8YabzFY5se3U5wVzLmnNNNuW"
local keyLukesz = "lucas39630790"

rconsolename("Booga Key System")

rconsoleprint("----------- BOOGA BOOGA KEY SYSTEM ----------- \n\n")
rconsoleprint("Get key: https://up-to-down.net/383901/boogascript-key-system\n")
local userInput = rconsoleinput(rconsoleprint("Input key: "))

while userInput ~= key and userInput ~= keyLukesz do
	rconsoleerr("Invalid Key!")
	userInput = rconsoleinput(rconsoleprint("Input key: "))
end

if userInput == key or userInput == keyLukesz then
	rconsoleclear()
	rconsoleprint("@@GREEN@@")
	rconsoleprint("Script executed!\n")
	rconsoleprint("Closing...")
	wait(3)
	rconsoleclose()

	_G.ToggleColor = Color3.fromRGB(255,0,0)
	_G.ButtonColor = Color3.fromRGB(255,0,0)
	_G.SliderColor = Color3.fromRGB(255,0,0)

	local infJump = false
	local teleportEnabled = false
	local spammerEnabled = false

	local start = tick() -- ESP Function

	_G.TeamLine = true
	_G.autoHeal = false

	local Mouse = game.Players.LocalPlayer:GetMouse()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local localplayer = Players.LocalPlayer
	local cam = workspace.CurrentCamera

	function teleportTo(placeCFrame) -- Tp function
		local plyr = game.Players.LocalPlayer;

		if plyr.Character then
			plyr.Character.HumanoidRootPart.CFrame = placeCFrame;
		end
	end

	local UserInputService = game:GetService("UserInputService")

	local library = loadstring(game:HttpGet(("https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua")))()

	local title = library:CreateWindow("Booga Script") -- Creates the window

	local mainFolder = title:CreateFolder("Main")

	mainFolder:DestroyGui()

	local moveFolder = title:CreateFolder("Movement") -- Movement Menu

	moveFolder:Toggle("Inf. Jump",function(bool)
		infJump = bool
	end)

	moveFolder:Toggle("Click to TP",function(bool)
		teleportEnabled = bool
	end)

	moveFolder:Bind("Click TP Bind",Enum.KeyCode.Q,function()
		if teleportEnabled == true then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.p + Vector3.new(0, 5, 0))
		end
	end)

	moveFolder:Button("Sprint (Hold F)", function()
		down = false
		velocity = Instance.new("BodyVelocity")
		velocity.maxForce = Vector3.new(100000, 0, 100000)
		---vv Use that to change the speed v
		local speed = 150
		gyro = Instance.new("BodyGyro")
		gyro.maxTorque = Vector3.new(100000, 0, 100000)

		local hum = game.Players.LocalPlayer.Character.Humanoid

		function onButton1Down(mouse)
		down = true
		velocity.Parent = game.Players.LocalPlayer.Character.UpperTorso
		velocity.velocity = (hum.MoveDirection) * speed
		gyro.Parent = game.Players.LocalPlayer.Character.UpperTorso
		while down do
		if not down then break end
		velocity.velocity = (hum.MoveDirection) * speed
		local refpos = gyro.Parent.Position + (gyro.Parent.Position - workspace.CurrentCamera.CoordinateFrame.p).unit * 5
		gyro.cframe = CFrame.new(gyro.Parent.Position, Vector3.new(refpos.x, gyro.Parent.Position.y, refpos.z))
		wait(0.1)
		end
		end

		function onButton1Up(mouse)
		velocity.Parent = nil
		gyro.Parent = nil
		down = false
		end
		--To Change the key in those 2 lines, replace the "q" with your desired key
		function onSelected(mouse)
		mouse.KeyDown:connect(function(k) if k:lower()=="f"then onButton1Down(mouse)end end)
		mouse.KeyUp:connect(function(k) if k:lower()=="f"then onButton1Up(mouse)end end)
		end

		onSelected(game.Players.LocalPlayer:GetMouse())
	end)

	local visualsFolder = title:CreateFolder("Visuals") -- Visuals Menu

	visualsFolder:Toggle("Full Bright",function(bool)
		_G.FullBrightEnabled = bool
	end)

	visualsFolder:Button("ESP Enable", function()
		--Settings--
		local ESP = {
			Enabled = true,
			Boxes = true,
			BoxShift = CFrame.new(0,-1.5,0),
			BoxSize = Vector3.new(4,6,0),
			Color = Color3.fromRGB(255, 255, 255),
			FaceCamera = false,
			Names = true,
			TeamColor = true,
			Thickness = 2,
			AttachShift = 1,
			TeamMates = true,
			Players = true,
			
			Objects = setmetatable({}, {__mode="kv"}),
			Overrides = {}
		}

		--Declarations--
		local cam = workspace.CurrentCamera
		local plrs = game:GetService("Players")
		local plr = plrs.LocalPlayer
		local mouse = plr:GetMouse()

		local V3new = Vector3.new
		local WorldToViewportPoint = cam.WorldToViewportPoint

		--Functions--
		local function Draw(obj, props)
			local new = Drawing.new(obj)
			
			props = props or {}
			for i,v in pairs(props) do
				new[i] = v
			end
			return new
		end

		function ESP:GetTeam(p)
			local ov = self.Overrides.GetTeam
			if ov then
				return ov(p)
			end
			
			return p and p.Team
		end

		function ESP:IsTeamMate(p)
			local ov = self.Overrides.IsTeamMate
			if ov then
				return ov(p)
			end
			
			return self:GetTeam(p) == self:GetTeam(plr)
		end

		function ESP:GetColor(obj)
			local ov = self.Overrides.GetColor
			if ov then
				return ov(obj)
			end
			local p = self:GetPlrFromChar(obj)
			return p and self.TeamColor and p.Team and p.Team.TeamColor.Color or self.Color
		end

		function ESP:GetPlrFromChar(char)
			local ov = self.Overrides.GetPlrFromChar
			if ov then
				return ov(char)
			end
			
			return plrs:GetPlayerFromCharacter(char)
		end

		function ESP:Toggle(bool)
			self.Enabled = bool
			if not bool then
				for i,v in pairs(self.Objects) do
					if v.Type == "Box" then --fov circle etc
						if v.Temporary then
							v:Remove()
						else
							for i,v in pairs(v.Components) do
								v.Visible = false
							end
						end
					end
				end
			end
		end

		function ESP:GetBox(obj)
			return self.Objects[obj]
		end

		function ESP:AddObjectListener(parent, options)
			local function NewListener(c)
				if type(options.Type) == "string" and c:IsA(options.Type) or options.Type == nil then
					if type(options.Name) == "string" and c.Name == options.Name or options.Name == nil then
						if not options.Validator or options.Validator(c) then
							local box = ESP:Add(c, {
								PrimaryPart = type(options.PrimaryPart) == "string" and c:WaitForChild(options.PrimaryPart) or type(options.PrimaryPart) == "function" and options.PrimaryPart(c),
								Color = type(options.Color) == "function" and options.Color(c) or options.Color,
								ColorDynamic = options.ColorDynamic,
								Name = type(options.CustomName) == "function" and options.CustomName(c) or options.CustomName,
								IsEnabled = options.IsEnabled,
								RenderInNil = options.RenderInNil
							})
							--TODO: add a better way of passing options
							if options.OnAdded then
								coroutine.wrap(options.OnAdded)(box)
							end
						end
					end
				end
			end

			if options.Recursive then
				parent.DescendantAdded:Connect(NewListener)
				for i,v in pairs(parent:GetDescendants()) do
					coroutine.wrap(NewListener)(v)
				end
			else
				parent.ChildAdded:Connect(NewListener)
				for i,v in pairs(parent:GetChildren()) do
					coroutine.wrap(NewListener)(v)
				end
			end
		end

		local boxBase = {}
		boxBase.__index = boxBase

		function boxBase:Remove()
			ESP.Objects[self.Object] = nil
			for i,v in pairs(self.Components) do
				v.Visible = false
				v:Remove()
				self.Components[i] = nil
			end
		end

		function boxBase:Update()
			if not self.PrimaryPart then
				--warn("not supposed to print", self.Object)
				return self:Remove()
			end

			local color
			if ESP.Highlighted == self.Object then
			color = ESP.HighlightColor
			else
				color = self.Color or self.ColorDynamic and self:ColorDynamic() or ESP:GetColor(self.Object) or ESP.Color
			end

			local allow = true
			if ESP.Overrides.UpdateAllow and not ESP.Overrides.UpdateAllow(self) then
				allow = false
			end
			if self.Player and not ESP.TeamMates and ESP:IsTeamMate(self.Player) then
				allow = false
			end
			if self.Player and not ESP.Players then
				allow = false
			end
			if self.IsEnabled and (type(self.IsEnabled) == "string" and not ESP[self.IsEnabled] or type(self.IsEnabled) == "function" and not self:IsEnabled()) then
				allow = false
			end
			if not workspace:IsAncestorOf(self.PrimaryPart) and not self.RenderInNil then
				allow = false
			end

			if not allow then
				for i,v in pairs(self.Components) do
					v.Visible = false
				end
				return
			end

			if ESP.Highlighted == self.Object then
				color = ESP.HighlightColor
			end

			--calculations--
			local cf = self.PrimaryPart.CFrame
			if ESP.FaceCamera then
				cf = CFrame.new(cf.p, cam.CFrame.p)
			end
			local size = self.Size
			local locs = {
				TopLeft = cf * ESP.BoxShift * CFrame.new(size.X/2,size.Y/2,0),
				TopRight = cf * ESP.BoxShift * CFrame.new(-size.X/2,size.Y/2,0),
				BottomLeft = cf * ESP.BoxShift * CFrame.new(size.X/2,-size.Y/2,0),
				BottomRight = cf * ESP.BoxShift * CFrame.new(-size.X/2,-size.Y/2,0),
				TagPos = cf * ESP.BoxShift * CFrame.new(0,size.Y/2,0),
				Torso = cf * ESP.BoxShift
			}

			if ESP.Boxes then
				local TopLeft, Vis1 = WorldToViewportPoint(cam, locs.TopLeft.p)
				local TopRight, Vis2 = WorldToViewportPoint(cam, locs.TopRight.p)
				local BottomLeft, Vis3 = WorldToViewportPoint(cam, locs.BottomLeft.p)
				local BottomRight, Vis4 = WorldToViewportPoint(cam, locs.BottomRight.p)

				if self.Components.Quad then
					if Vis1 or Vis2 or Vis3 or Vis4 then
						self.Components.Quad.Visible = true
						self.Components.Quad.PointA = Vector2.new(TopRight.X, TopRight.Y)
						self.Components.Quad.PointB = Vector2.new(TopLeft.X, TopLeft.Y)
						self.Components.Quad.PointC = Vector2.new(BottomLeft.X, BottomLeft.Y)
						self.Components.Quad.PointD = Vector2.new(BottomRight.X, BottomRight.Y)
						self.Components.Quad.Color = color
					else
						self.Components.Quad.Visible = false
					end
				end
			else
				self.Components.Quad.Visible = false
			end

			if ESP.Names then
				local TagPos, Vis5 = WorldToViewportPoint(cam, locs.TagPos.p)
				
				if Vis5 then
					self.Components.Name.Visible = true
					self.Components.Name.Position = Vector2.new(TagPos.X, TagPos.Y)
					self.Components.Name.Text = self.Name
					self.Components.Name.Color = color
					
					self.Components.Distance.Visible = true
					self.Components.Distance.Position = Vector2.new(TagPos.X, TagPos.Y + 14)
					self.Components.Distance.Text = math.floor((cam.CFrame.p - cf.p).magnitude) .."m away"
					self.Components.Distance.Color = color
				else
					self.Components.Name.Visible = false
					self.Components.Distance.Visible = false
				end
			else
				self.Components.Name.Visible = false
				self.Components.Distance.Visible = false
			end
			
			if ESP.Tracers then
				local TorsoPos, Vis6 = WorldToViewportPoint(cam, locs.Torso.p)

				if Vis6 then
					self.Components.Tracer.Visible = true
					self.Components.Tracer.From = Vector2.new(TorsoPos.X, TorsoPos.Y)
					self.Components.Tracer.To = Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/ESP.AttachShift)
					self.Components.Tracer.Color = color
				else
					self.Components.Tracer.Visible = false
				end
			else
				self.Components.Tracer.Visible = false
			end
		end

		function ESP:Add(obj, options)
			if not obj.Parent and not options.RenderInNil then
				return warn(obj, "has no parent")
			end

			local box = setmetatable({
				Name = options.Name or obj.Name,
				Type = "Box",
				Color = options.Color --[[or self:GetColor(obj)]],
				Size = options.Size or self.BoxSize,
				Object = obj,
				Player = options.Player or plrs:GetPlayerFromCharacter(obj),
				PrimaryPart = options.PrimaryPart or obj.ClassName == "Model" and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj:IsA("BasePart") and obj,
				Components = {},
				IsEnabled = options.IsEnabled,
				Temporary = options.Temporary,
				ColorDynamic = options.ColorDynamic,
				RenderInNil = options.RenderInNil
			}, boxBase)

			if self:GetBox(obj) then
				self:GetBox(obj):Remove()
			end

			box.Components["Quad"] = Draw("Quad", {
				Thickness = self.Thickness,
				Color = color,
				Transparency = 1,
				Filled = false,
				Visible = self.Enabled and self.Boxes
			})
			box.Components["Name"] = Draw("Text", {
				Text = box.Name,
				Color = box.Color,
				Center = true,
				Outline = true,
				Size = 19,
				Visible = self.Enabled and self.Names
			})
			
			box.Components["Tracer"] = Draw("Line", {
				Thickness = ESP.Thickness,
				Color = box.Color,
				Transparency = 1,
				Visible = self.Enabled and self.Tracers
			})
			self.Objects[obj] = box
			
			obj.AncestryChanged:Connect(function(_, parent)
				if parent == nil and ESP.AutoRemove ~= false then
					box:Remove()
				end
			end)
			obj:GetPropertyChangedSignal("Parent"):Connect(function()
				if obj.Parent == nil and ESP.AutoRemove ~= false then
					box:Remove()
				end
			end)

			local hum = obj:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.Died:Connect(function()
					if ESP.AutoRemove ~= false then
						box:Remove()
					end
				end)
			end

			return box
		end

		local function CharAdded(char)
			local p = plrs:GetPlayerFromCharacter(char)
			if not char:FindFirstChild("HumanoidRootPart") then
				local ev
				ev = char.ChildAdded:Connect(function(c)
					if c.Name == "HumanoidRootPart" then
						ev:Disconnect()
						ESP:Add(char, {
							Name = p.Name,
							Player = p,
							PrimaryPart = c
						})
					end
				end)
			else
				ESP:Add(char, {
					Name = p.Name,
					Player = p,
					PrimaryPart = char.HumanoidRootPart
				})
			end
		end
		local function PlayerAdded(p)
			p.CharacterAdded:Connect(CharAdded)
			if p.Character then
				coroutine.wrap(CharAdded)(p.Character)
			end
		end
		plrs.PlayerAdded:Connect(PlayerAdded)
		for i,v in pairs(plrs:GetPlayers()) do
			if v ~= plr then
				PlayerAdded(v)
			end
		end

		game:GetService("RunService").RenderStepped:Connect(function()
			cam = workspace.CurrentCamera
			for i,v in (ESP.Enabled and pairs or ipairs)(ESP.Objects) do
				if v.Update then
					local s,e = pcall(v.Update, v)
					if not s then warn("[EU]", e, v.Object:GetFullName()) end
				end
			end
		end)

		return ESP
	end)

	visualsFolder:Button("Freecam Enable", function()
		--Converted with ttyyuu12345's model to script plugin v4
	function sandbox(var,func)
		local env = getfenv(func)
		local newenv = setmetatable({},{
		__index = function(self,k)
		if k=="script" then
		return var
		else
		return env[k]
		end
		end,
		})
		setfenv(func,newenv)
		return func
		end
		cors = {}
		mas = Instance.new("Model",game:GetService("Lighting"))
		LocalScript0 = Instance.new("LocalScript")
		LocalScript0.Name = "FreeCamera"
		LocalScript0.Parent = mas
		table.insert(cors,sandbox(LocalScript0,function()
		-----------------------------------------------------------------------
		-- Freecam
		-- Cinematic free camera for spectating and video production.
		------------------------------------------------------------------------
		
		local pi    = math.pi
		local abs   = math.abs
		local clamp = math.clamp
		local exp   = math.exp
		local rad   = math.rad
		local sign  = math.sign
		local sqrt  = math.sqrt
		local tan   = math.tan
		
		local ContextActionService = game:GetService("ContextActionService")
		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local StarterGui = game:GetService("StarterGui")
		local UserInputService = game:GetService("UserInputService")
		
		local LocalPlayer = Players.LocalPlayer
		if not LocalPlayer then
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
		end
		
		local Camera = workspace.CurrentCamera
		workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		local newCamera = workspace.CurrentCamera
		if newCamera then
		Camera = newCamera
		end
		end)
		
		------------------------------------------------------------------------
		
		local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
		local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
		local FREECAM_MACRO_KB = {Enum.KeyCode.LeftShift, Enum.KeyCode.P}
		
		local NAV_GAIN = Vector3.new(1, 1, 1)*64
		local PAN_GAIN = Vector2.new(0.75, 1)*8
		local FOV_GAIN = 300
		
		local PITCH_LIMIT = rad(90)
		
		local VEL_STIFFNESS = 1.5
		local PAN_STIFFNESS = 1.0
		local FOV_STIFFNESS = 4.0
		
		------------------------------------------------------------------------
		
		local Spring = {} do
		Spring.__index = Spring
		
		function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
		end
		
		function Spring:Update(dt, goal)
		local f = self.f*2*pi
		local p0 = self.p
		local v0 = self.v
		
		local offset = goal - p0
		local decay = exp(-f*dt)
		
		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay
		
		self.p = p1
		self.v = v1
		
		return p1
		end
		
		function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
		end
		end
		
		------------------------------------------------------------------------
		
		local cameraPos = Vector3.new()
		local cameraRot = Vector2.new()
		local cameraFov = 0
		
		local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
		local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
		local fovSpring = Spring.new(FOV_STIFFNESS, 0)
		
		------------------------------------------------------------------------
		
		local Input = {} do
		local thumbstickCurve do
		local K_CURVATURE = 2.0
		local K_DEADZONE = 0.15
		
		local function fCurve(x)
		return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
		end
		
		local function fDeadzone(x)
		return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
		end
		
		function thumbstickCurve(x)
		return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
		end
		end
		
		local gamepad = {
		ButtonX = 0,
		ButtonY = 0,
		DPadDown = 0,
		DPadUp = 0,
		ButtonL2 = 0,
		ButtonR2 = 0,
		Thumbstick1 = Vector2.new(),
		Thumbstick2 = Vector2.new(),
		}
		
		local keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		U = 0,
		H = 0,
		J = 0,
		K = 0,
		I = 0,
		Y = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
		RightShift = 0,
		}
		
		local mouse = {
		Delta = Vector2.new(),
		MouseWheel = 0,
		}
		
		local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
		local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
		local PAN_MOUSE_SPEED    = Vector2.new(1, 1)*(pi/64)
		local PAN_GAMEPAD_SPEED  = Vector2.new(1, 1)*(pi/8)
		local FOV_WHEEL_SPEED    = 1.0
		local FOV_GAMEPAD_SPEED  = 0.25
		local NAV_ADJ_SPEED      = 0.75
		local NAV_SHIFT_MUL      = 0.25
		
		local navSpeed = 1
		
		function Input.Vel(dt)
		navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)
		
		local kGamepad = Vector3.new(
		thumbstickCurve(gamepad.Thumbstick1.x),
		thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
		thumbstickCurve(-gamepad.Thumbstick1.y)
		)*NAV_GAMEPAD_SPEED
		
		local kKeyboard = Vector3.new(
		keyboard.D - keyboard.A + keyboard.K - keyboard.H,
		keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
		keyboard.S - keyboard.W + keyboard.J - keyboard.U
		)*NAV_KEYBOARD_SPEED
		
		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		
		return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
		end
		
		function Input.Pan(dt)
		local kGamepad = Vector2.new(
		thumbstickCurve(gamepad.Thumbstick2.y),
		thumbstickCurve(-gamepad.Thumbstick2.x)
		)*PAN_GAMEPAD_SPEED
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kGamepad + kMouse
		end
		
		function Input.Fov(dt)
		local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED
		local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED
		mouse.MouseWheel = 0
		return kGamepad + kMouse
		end
		
		do
		local function Keypress(action, state, input)
		keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
		return Enum.ContextActionResult.Sink
		end
		
		local function GpButton(action, state, input)
		gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
		return Enum.ContextActionResult.Sink
		end
		
		local function MousePan(action, state, input)
		local delta = input.Delta
		mouse.Delta = Vector2.new(-delta.y, -delta.x)
		return Enum.ContextActionResult.Sink
		end
		
		local function Thumb(action, state, input)
		gamepad[input.KeyCode.Name] = input.Position
		return Enum.ContextActionResult.Sink
		end
		
		local function Trigger(action, state, input)
		gamepad[input.KeyCode.Name] = input.Position.z
		return Enum.ContextActionResult.Sink
		end
		
		local function MouseWheel(action, state, input)
		mouse[input.UserInputType.Name] = -input.Position.z
		return Enum.ContextActionResult.Sink
		end
		
		local function Zero(t)
		for k, v in pairs(t) do
		t[k] = v*0
		end
		end
		
		function Input.StartCapture()
		ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
		Enum.KeyCode.W, Enum.KeyCode.U,
		Enum.KeyCode.A, Enum.KeyCode.H,
		Enum.KeyCode.S, Enum.KeyCode.J,
		Enum.KeyCode.D, Enum.KeyCode.K,
		Enum.KeyCode.E, Enum.KeyCode.I,
		Enum.KeyCode.Q, Enum.KeyCode.Y,
		Enum.KeyCode.Up, Enum.KeyCode.Down
		)
		ContextActionService:BindActionAtPriority("FreecamMousePan",          MousePan,   false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
		ContextActionService:BindActionAtPriority("FreecamMouseWheel",        MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
		ContextActionService:BindActionAtPriority("FreecamGamepadButton",     GpButton,   false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
		ContextActionService:BindActionAtPriority("FreecamGamepadTrigger",    Trigger,    false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
		ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb,      false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
		end
		
		function Input.StopCapture()
		navSpeed = 1
		Zero(gamepad)
		Zero(keyboard)
		Zero(mouse)
		ContextActionService:UnbindAction("FreecamKeyboard")
		ContextActionService:UnbindAction("FreecamMousePan")
		ContextActionService:UnbindAction("FreecamMouseWheel")
		ContextActionService:UnbindAction("FreecamGamepadButton")
		ContextActionService:UnbindAction("FreecamGamepadTrigger")
		ContextActionService:UnbindAction("FreecamGamepadThumbstick")
		end
		end
		end
		
		local function GetFocusDistance(cameraFrame)
		local znear = 0.1
		local viewport = Camera.ViewportSize
		local projy = 2*tan(cameraFov/2)
		local projx = viewport.x/viewport.y*projy
		local fx = cameraFrame.rightVector
		local fy = cameraFrame.upVector
		local fz = cameraFrame.lookVector
		
		local minVect = Vector3.new()
		local minDist = 512
		
		for x = 0, 1, 0.5 do
		for y = 0, 1, 0.5 do
		local cx = (x - 0.5)*projx
		local cy = (y - 0.5)*projy
		local offset = fx*cx - fy*cy + fz
		local origin = cameraFrame.p + offset*znear
		local part, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
		local dist = (hit - origin).magnitude
		if minDist > dist then
		minDist = dist
		minVect = offset.unit
		end
		end
		end
		
		return fz:Dot(minVect)*minDist
		end
		
		------------------------------------------------------------------------
		
		local function StepFreecam(dt)
		local vel = velSpring:Update(dt, Input.Vel(dt))
		local pan = panSpring:Update(dt, Input.Pan(dt))
		local fov = fovSpring:Update(dt, Input.Fov(dt))
		
		local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))
		
		cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)
		cameraRot = cameraRot + pan*PAN_GAIN*(dt/zoomFactor)
		cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))
		
		local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*NAV_GAIN*dt)
		cameraPos = cameraCFrame.p
		
		Camera.CFrame = cameraCFrame
		Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
		Camera.FieldOfView = cameraFov
		end
		
		------------------------------------------------------------------------
		
		local PlayerState = {} do
		local mouseIconEnabled
		local cameraSubject
		local cameraType
		local cameraFocus
		local cameraCFrame
		local cameraFieldOfView
		local screenGuis = {}
		local coreGuis = {
		Backpack = true,
		Chat = true,
		Health = true,
		PlayerList = true,
		}
		local setCores = {
		BadgesNotificationsActive = true,
		PointsNotificationsActive = true,
		}
		
		-- Save state and set up for freecam
		function PlayerState.Push()
		for name in pairs(coreGuis) do
		coreGuis[name] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[name])
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
		end
		for name in pairs(setCores) do
		setCores[name] = StarterGui:GetCore(name)
		StarterGui:SetCore(name, false)
		end
		local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
		if playergui then
		for _, gui in pairs(playergui:GetChildren()) do
		if gui:IsA("ScreenGui") and gui.Enabled then
		screenGuis[#screenGuis + 1] = gui
		gui.Enabled = false
		end
		end
		end
		
		cameraFieldOfView = Camera.FieldOfView
		Camera.FieldOfView = 70
		
		cameraType = Camera.CameraType
		Camera.CameraType = Enum.CameraType.Custom
		
		cameraSubject = Camera.CameraSubject
		Camera.CameraSubject = nil
		
		cameraCFrame = Camera.CFrame
		cameraFocus = Camera.Focus
		
		mouseIconEnabled = UserInputService.MouseIconEnabled
		UserInputService.MouseIconEnabled = false
		
		mouseBehavior = UserInputService.MouseBehavior
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
		
		-- Restore state
		function PlayerState.Pop()
		for name, isEnabled in pairs(coreGuis) do
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
		end
		for name, isEnabled in pairs(setCores) do
		StarterGui:SetCore(name, isEnabled)
		end
		for _, gui in pairs(screenGuis) do
		if gui.Parent then
		gui.Enabled = true
		end
		end
		
		Camera.FieldOfView = cameraFieldOfView
		cameraFieldOfView = nil
		
		Camera.CameraType = cameraType
		cameraType = nil
		
		Camera.CameraSubject = cameraSubject
		cameraSubject = nil
		
		Camera.CFrame = cameraCFrame
		cameraCFrame = nil
		
		Camera.Focus = cameraFocus
		cameraFocus = nil
		
		UserInputService.MouseIconEnabled = mouseIconEnabled
		mouseIconEnabled = nil
		
		UserInputService.MouseBehavior = mouseBehavior
		mouseBehavior = nil
		end
		end
		
		local function StartFreecam()
		local cameraCFrame = Camera.CFrame
		cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
		cameraPos = cameraCFrame.p
		cameraFov = Camera.FieldOfView
		
		velSpring:Reset(Vector3.new())
		panSpring:Reset(Vector2.new())
		fovSpring:Reset(0)
		
		PlayerState.Push()
		RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
		Input.StartCapture()
		end
		
		local function StopFreecam()
		Input.StopCapture()
		RunService:UnbindFromRenderStep("Freecam")
		PlayerState.Pop()
		end
		
		------------------------------------------------------------------------
		
		do
		local enabled = false
		
		local function ToggleFreecam()
		if enabled then
		StopFreecam()
		else
		StartFreecam()
		end
		enabled = not enabled
		end
		
		local function CheckMacro(macro)
		for i = 1, #macro - 1 do
		if not UserInputService:IsKeyDown(macro[i]) then
		return
		end
		end
		ToggleFreecam()
		end
		
		local function HandleActivationInput(action, state, input)
		if state == Enum.UserInputState.Begin then
		if input.KeyCode == FREECAM_MACRO_KB[#FREECAM_MACRO_KB] then
		CheckMacro(FREECAM_MACRO_KB)
		end
		end
		return Enum.ContextActionResult.Pass
		end
		
		ContextActionService:BindActionAtPriority("FreecamToggle", HandleActivationInput, false, TOGGLE_INPUT_PRIORITY, FREECAM_MACRO_KB[#FREECAM_MACRO_KB])
		end
		end))
		for i,v in pairs(mas:GetChildren()) do
		v.Parent = game:GetService("Players").LocalPlayer.PlayerGui
		pcall(function() v:MakeJoints() end)
		end
		mas:Destroy()
		for i,v in pairs(cors) do
		spawn(function()
		pcall(v)
		end)
		end
	end)

	local autoFolder = title:CreateFolder("Auto") -- Auto Menu

	autoFolder:Toggle("Auto Heal",function(bool)
		autoHeal = bool
	end)

	autoFolder:Bind("Auto Heal Bind",Enum.KeyCode.R,function()
		if autoHeal then
			autoHealF()
		end
	end)

	autoFolder:Toggle("Spammer Chat",function(bool)
		spammerEnabled = bool
		if spammerEnabled then
			spammerChatF()
		end
	end)

	local teleportsFolder = title:CreateFolder("Teleports") -- Teleports Menu

	teleportsFolder:Button("Old God",function()
		teleportTo(game:GetService("Workspace")["Old God"].Eyes.CFrame)
	end)

	teleportsFolder:Button("Miserable God",function()
		teleportTo(game:GetService("Workspace")["Miserable God"].Moai.CFrame)
	end)

	teleportsFolder:Button("Lonely God",function()
		teleportTo(game:GetService("Workspace")["Lonely God"].Moai.CFrame)
	end)

	teleportsFolder:Button("Wealthy God",function()
		teleportTo(game:GetService("Workspace")["Wealthy God"].LeftEyeForcefield.CFrame)
	end)

	teleportsFolder:Button("Hateful God",function()
		teleportTo(game:GetService("Workspace")["Hateful God"].Moai.CFrame)
	end)

	teleportsFolder:Button("Ancient Tree",function()
		teleportTo(game:GetService("Workspace")["Ancient Tree"].Trunk.CFrame)
	end)

	local creditsFolder = title:CreateFolder("Credits") -- Credits Menu

	creditsFolder:Label("Made by: lukesz",{
		TextSize = 20; -- Self Explaining
		TextColor = Color3.fromRGB(255,255,255);
		BgColor = Color3.fromRGB(0,0,0);
	}) 

	UserInputService.InputBegan:Connect(function(key) -- Infinite Jump function
		if key.KeyCode == Enum.KeyCode.Space then
			if infJump == true then
				game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
				game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				game.Players.LocalPlayer.Character.Humanoid.Jump = true
			end
		end
	end)

	function autoHealF()
		spawn(function()
			while autoHeal == true and game:GetService('Players').LocalPlayer.Character.Humanoid.Health < 100 do
					local args = {
						[1] = "Bloodfruit"
					}
					game:GetService("ReplicatedStorage").Events.UseBagItem:FireServer(unpack(args))
					wait()
				end    
			end)
		end

	if not _G.FullBrightExecuted then -- Full bright function

		_G.FullBrightEnabled = false

		_G.NormalLightingSettings = {
			Brightness = game:GetService("Lighting").Brightness,
			ClockTime = game:GetService("Lighting").ClockTime,
			FogEnd = game:GetService("Lighting").FogEnd,
			GlobalShadows = game:GetService("Lighting").GlobalShadows,
			Ambient = game:GetService("Lighting").Ambient
		}

		game:GetService("Lighting"):GetPropertyChangedSignal("Brightness"):Connect(function()
			if game:GetService("Lighting").Brightness ~= 1 and game:GetService("Lighting").Brightness ~= _G.NormalLightingSettings.Brightness then
				_G.NormalLightingSettings.Brightness = game:GetService("Lighting").Brightness
				if not _G.FullBrightEnabled then
					repeat
						wait()
					until _G.FullBrightEnabled
				end
				game:GetService("Lighting").Brightness = 1
			end
		end)

		game:GetService("Lighting"):GetPropertyChangedSignal("ClockTime"):Connect(function()
			if game:GetService("Lighting").ClockTime ~= 12 and game:GetService("Lighting").ClockTime ~= _G.NormalLightingSettings.ClockTime then
				_G.NormalLightingSettings.ClockTime = game:GetService("Lighting").ClockTime
				if not _G.FullBrightEnabled then
					repeat
						wait()
					until _G.FullBrightEnabled
				end
				game:GetService("Lighting").ClockTime = 12
			end
		end)

		game:GetService("Lighting"):GetPropertyChangedSignal("FogEnd"):Connect(function()
			if game:GetService("Lighting").FogEnd ~= 786543 and game:GetService("Lighting").FogEnd ~= _G.NormalLightingSettings.FogEnd then
				_G.NormalLightingSettings.FogEnd = game:GetService("Lighting").FogEnd
				if not _G.FullBrightEnabled then
					repeat
						wait()
					until _G.FullBrightEnabled
				end
				game:GetService("Lighting").FogEnd = 786543
			end
		end)

		game:GetService("Lighting"):GetPropertyChangedSignal("GlobalShadows"):Connect(function()
			if game:GetService("Lighting").GlobalShadows ~= false and game:GetService("Lighting").GlobalShadows ~= _G.NormalLightingSettings.GlobalShadows then
				_G.NormalLightingSettings.GlobalShadows = game:GetService("Lighting").GlobalShadows
				if not _G.FullBrightEnabled then
					repeat
						wait()
					until _G.FullBrightEnabled
				end
				game:GetService("Lighting").GlobalShadows = false
			end
		end)

		game:GetService("Lighting"):GetPropertyChangedSignal("Ambient"):Connect(function()
			if game:GetService("Lighting").Ambient ~= Color3.fromRGB(178, 178, 178) and game:GetService("Lighting").Ambient ~= _G.NormalLightingSettings.Ambient then
				_G.NormalLightingSettings.Ambient = game:GetService("Lighting").Ambient
				if not _G.FullBrightEnabled then
					repeat
						wait()
					until _G.FullBrightEnabled
				end
				game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
			end
		end)

		game:GetService("Lighting").Brightness = 1
		game:GetService("Lighting").ClockTime = 12
		game:GetService("Lighting").FogEnd = 786543
		game:GetService("Lighting").GlobalShadows = false
		game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)

		local LatestValue = true
		spawn(function()
			repeat
				wait()
			until _G.FullBrightEnabled
			while wait() do
				if _G.FullBrightEnabled ~= LatestValue then
					if not _G.FullBrightEnabled then
						game:GetService("Lighting").Brightness = _G.NormalLightingSettings.Brightness
						game:GetService("Lighting").ClockTime = _G.NormalLightingSettings.ClockTime
						game:GetService("Lighting").FogEnd = _G.NormalLightingSettings.FogEnd
						game:GetService("Lighting").GlobalShadows = _G.NormalLightingSettings.GlobalShadows
						game:GetService("Lighting").Ambient = _G.NormalLightingSettings.Ambient
					else
						game:GetService("Lighting").Brightness = 1
						game:GetService("Lighting").ClockTime = 12
						game:GetService("Lighting").FogEnd = 786543
						game:GetService("Lighting").GlobalShadows = false
						game:GetService("Lighting").Ambient = Color3.fromRGB(178, 178, 178)
					end
					LatestValue = not LatestValue
				end
			end
		end)
	end

	_G.FullBrightExecuted = true
	_G.FullBrightEnabled = not _G.FullBrightEnabled

	function spammerChatF() -- Spammer Function
		spawn(function ()
			while spammerEnabled do
				local args = {
					[1] = "I am GOD",
					[2] = "All"
				}
				
				game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args)) 
				wait()
			end
		end)	
	end
end