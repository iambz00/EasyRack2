local L = EasyRack2_GetLocaleText(GetLocale())

BINDING_HEADER_EASYRACK = "EasyRack2"
BINDING_NAME_EASYRACKUNEQUIP = L["BIND_SLIPOFF"]
BINDING_NAME_EASYRACKMODE1 = "1"..L["BIND_EQUIPSET"]
BINDING_NAME_EASYRACKMODE2 = "2"..L["BIND_EQUIPSET"]
BINDING_NAME_EASYRACKMODE3 = "3"..L["BIND_EQUIPSET"]
BINDING_NAME_EASYRACKMODE4 = "4"..L["BIND_EQUIPSET"]
BINDING_NAME_EASYRACKMODE5 = "5"..L["BIND_EQUIPSET"]
BINDING_NAME_EASYRACKMODE6 = "6"..L["BIND_EQUIPSET"]
BINDING_NAME_EASYRACKMODE7 = "7"..L["BIND_EQUIPSET"]
BINDING_NAME_EASYRACKMODE8 = "8"..L["BIND_EQUIPSET"]
BINDING_NAME_EASYRACKMODE9 = "9"..L["BIND_EQUIPSET"]

StaticPopupDialogs["EASYRACK_SETMODE"] = {
	text = L["DIALOGUE_SET"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 12,

	OnHide = function(self)
		getglobal(self:GetName().."EditBox"):SetText("")
	end,
	EditBoxOnEscapePressed = function(self)
		GetParent():Hide()
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,
	oldName = ""
}

StaticPopupDialogs["EASYRACK_DELMODE"] = {
	button1 = ACCEPT,
	button2 = CANCEL,

	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,
	oldName = ""
}

function EasyRack_OnLoad(self)
	self:RegisterForClicks("AnyDown")
	self:RegisterForDrag("LeftButton")
--	self:RegisterEvent("VARIABLES_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

--	self:RegisterEvent("WEAR_EQUIPMENT_SET"); -- 아직 적용이 안된듯
end

function EasyRack_EquipCheckOnLoad()
	local currentSet = L["STATUS_EQUIP"]
	local setName
	local isEquipped

	for i = 1, GetNumEquipmentSets() do
		-- name, icon, setID, isEquipped, numItems, numEquipped, numInventory, numMissing, numIgnored = GetEquipmentSetInfo(index)
		setName, _, _, isEquipped = GetEquipmentSetInfo(i)
		if isEquipped then
			currentSet = setName
			break
		end
	end

	EasyRack2FrameText:SetText(currentSet)
	EasyRack2Frame:SetWidth(EasyRack2FrameText:GetWidth() + 40)
end

function EasyRack_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		if not ER2_Sets then
			ER2_Sets = {}
		end
		EasyRack_EquipCheckOnLoad()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

function EasyRack_OnClick(self, button)
	if IsAltKeyDown() or IsControlKeyDown() then return end

	if button == "RightButton" then
		PlaySound("GAMEDIALOGOPEN")
		ToggleDropDownMenu(1, nil, EasyRack2FrameDropDownSet, self, 0, 0)
	elseif button == "LeftButton" then
		PlaySound("GAMEDIALOGOPEN")
		ToggleDropDownMenu(1, nil, EasyRack2FrameDropDownEquip, self, 0, 0)
	end
end

function EasyRackDropDownSet_OnLoad(self)
	UIDropDownMenu_Initialize(self, EasyRackDropDownSet_Initialize, "MENU")
end

function EasyRackDropDownEquip_OnLoad(self)
	UIDropDownMenu_Initialize(self, EasyRackDropDownEquip_Initialize, "MENU")
end

function EasyRackDropDownSet_Initialize()
	local info = {}

	info.text = L["MENU_SET_TITLE"]
	info.notCheckable = true
	info.isTitle = true

	UIDropDownMenu_AddButton(info)

	info.isTitle = false
	info.disabled = false
	info.func = EasyRackDropDownSet_OnClick
	info.tooltipTitle = L["MENU_SET_TOOLTIP_TITLE"]
	info.tooltipText = L["MENU_SET_TOOLTIP_TEXT"]
	for i = 1, 9 do
		info.value = i
		info.text = i..": "
		if not ER2_Sets or not ER2_Sets[i] then
			info.text = info.text.."|cff10f010"..L["MENU_SET_EMPTYSLOT"].."|r"
		else
			local localSet = ER2_Sets[i]
			if localSet.name then
				info.text = info.text..localSet.name
			else
				info.text = info.text.."    "
			end
		end

		UIDropDownMenu_AddButton(info)
	end
end

function EasyRackDropDownEquip_Initialize(self)
	local info = {}

	info.text = L["MENU_EQUIP_TITLE"]
	info.notCheckable = true
	info.isTitle = true

	UIDropDownMenu_AddButton(info)

	info.isTitle = false

	info.text = "0: |cff9090f0"..L["MENU_EQUIP_SLIPOFF"].."|r"
	info.func = EasyRack_UnEquip
	info.disabled = false
	UIDropDownMenu_AddButton(info)

	info.func = function(self) EasyRack_Equip(self.value); end
	for i = 1, 9 do
		info.value = i
		info.text = i..": "
		if not ER2_Sets or not ER2_Sets[i] then
			info.text = info.text.."|cfff01010"..L["MENU_EQUIP_EMPTYSLOT"] .."|r"
			info.disabled = true
		else
			local localSet = ER2_Sets[i]
			if localSet.name then
				info.text = info.text..localSet.name
			else
				info.text = info.text.."    "
			end
			info.disabled = false
		end

		UIDropDownMenu_AddButton(info)
	end
end

function EasyRackDropDownSet_OnClick(self, button, down)
	local modeNum = self.value
	local editText = nil

	if ER2_Sets[modeNum] then
		editText = ER2_Sets[modeNum].name
	end

	if IsShiftKeyDown() then
		if not editText then
			editText = modeNum
		end

		StaticPopupDialogs["EASYRACK_DELMODE"].text = L["MENU_SET_DELETE_1"]..editText..L["MENU_SET_DELETE_2"]

		StaticPopupDialogs["EASYRACK_DELMODE"].OnAccept = function (self2)
			EasyRack_DelMode(modeNum, getglobal(self2:GetName().."EditBox").oldName)
		end

		StaticPopupDialogs["EASYRACK_DELMODE"].OnShow = function (self2)
			getglobal(self2:GetName().."EditBox").oldName = editText
		end

		StaticPopup_Show("EASYRACK_DELMODE")
	else
		if not editText then
			editText = ""
		end

		StaticPopupDialogs["EASYRACK_SETMODE"].OnAccept = function (self2)
			EasyRack_SetMode(modeNum, getglobal(self2:GetName().."EditBox"):GetText(), getglobal(self2:GetName().."EditBox").oldName)
		end

		StaticPopupDialogs["EASYRACK_SETMODE"].EditBoxOnEnterPressed = function(self2)
			EasyRack_SetMode(modeNum, getglobal(self2:GetParent():GetName().."EditBox"):GetText(), getglobal(self2:GetParent():GetName().."EditBox").oldName)
			self2:GetParent():Hide()
		end

		StaticPopupDialogs["EASYRACK_SETMODE"].OnShow = function (self2)
			getglobal(self2:GetName().."EditBox"):SetText(editText)
			getglobal(self2:GetName().."EditBox"):SetFocus()
			getglobal(self2:GetName().."EditBox").oldName = editText
		end

		StaticPopup_Show("EASYRACK_SETMODE")
	end
end

function EasyRack_SetMode(mode, name, oldName)
	local localSet = {}
	local setName = mode

	if name and name ~= "" then
		setName = name
		localSet.name = name
	end

	for i=INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do EquipmentManagerUnignoreSlotForSave(i) end
	EquipmentManagerIgnoreSlotForSave(INVSLOT_BODY)	-- 속옷무시
	EquipmentManagerIgnoreSlotForSave(INVSLOT_TABARD)	-- 휘장무시

	-- 이름 변경한 경우
	if oldName and oldName ~= "" then
		if oldName ~= setName then
			--RenameEquipmentSet(oldName, setName)
			ModifyEquipmentSet(oldName, setName)
			print("EasyRack2: ["..oldName.."] -> ["..setName.."]")
		end
	end

	--SaveEquipmentSet(setName, -2) -- 기본으로 목걸이 아이콘 사용
	SaveEquipmentSet(setName, string.gsub(GetInventoryItemTexture("player", INVSLOT_NECK), "[^\\]*\\", ""))
	for i=1, 19 do EquipmentManagerUnignoreSlotForSave(i) end

	print("EasyRack2: "..L["MENU_SET_SAVE_1"]..setName..L["MENU_SET_SAVE_2"]..mode..L["MENU_SET_SAVE_3"])

	ER2_Sets[mode] = localSet

	EasyRack2FrameText:SetText(setName)
	EasyRack2Frame:SetWidth(EasyRack2FrameText:GetWidth() + 40)
end

function EasyRack_DelMode(mode, oldName)
	ER2_Sets[mode] = nil
	DeleteEquipmentSet(oldName)	-- index가 아닌 name. 바뀔 소지 있다고 생각됨
	print("|cfff01010EasyRack2: "..L["MENU_SET_DELETE_1"]..oldName..L["MENU_SET_DELETE_2"].."|r")
end

function EasyRack_Equip(mode)

	if InCombatLockdown() then
		print("EasyRack2: "..L["INCOMBAT_WARN_1"])
		return
	end

	local localSet = nil
	local setName = mode

	localSet = ER2_Sets[mode]

	if localSet == nil then
		print("|cfff01010EasyRack2: "..L["EQUIP_EMPTYSLOT_1"]..setName..L["EQUIP_EMPTYSLOT_2"].."|r")
		return
	end

	if localSet.name then
		setName = localSet.name
	end

	local ok = UseEquipmentSet(setName)

	if ok then
		EasyRack2FrameText:SetText(setName)
		EasyRack2Frame:SetWidth(EasyRack2FrameText:GetWidth() + 40)
		print("EasyRack2: "..L["EQUIP_EQUIP_1"]..setName..L["EQUIP_EQUIP_2"])

		PlaySound("SPELLBOOKOPEN")
	else
		print("|cfff01010EasyRack2: "..L["EQUIP_FAILED"].."|r")
	end
end

function EasyRack_UnEquip()
	--local dontSlipOff = { 2, 4, 11, 12, 13, 14, 15, 19 }
	local dontSlipOff = {
		INVSLOT_NECK,
		INVSLOT_BODY,
		INVSLOT_FINGER1,
		INVSLOT_FINGER2,
		INVSLOT_TRINKET1,
		INVSLOT_TRINKET2,
		INVSLOT_BACK,
		INVSLOT_TABARD
	 }
	local isSlipOffSet = GetEquipmentSetInfoByName("Slip Off")
	if isSlipOffSet then
		UseEquipmentSet("Slip Off")
		print("EasyRack2: "..L["EQUIP_SLIPOFF"])
		if UnitAffectingCombat("player") then
			EasyRack2FrameText:SetText("|cfff01010"..L["STATUS_WEAPON"].."|r")
			EasyRack2Frame:SetWidth(EasyRack2FrameText:GetWidth() + 40)
		else
			EasyRack2FrameText:SetText("|cfff01010"..L["STATUS_STRIP"].."|r")
			EasyRack2Frame:SetWidth(EasyRack2FrameText:GetWidth() + 40)
		end
	else
		if UnitAffectingCombat("player") then
			print("EasyRack2: "..L["INCOMBAT_WARN_1"])
			print("EasyRack2: "..L["INCOMBAT_WARN_2"])
		else
			--local invSlots = {1, 3, 5, 6, 7, 8, 9, 10, 18, 17, 16}
			local invSlots = {
				INVSLOT_HEAD,
				INVSLOT_SHOULDER,
				INVSLOT_CHEST,
				INVSLOT_WAIST,
				INVSLOT_LEGS,
				INVSLOT_FEET,
				INVSLOT_WRIST,
				INVSLOT_HAND,
				INVSLOT_RANGED,
				INVSLOT_OFFHAND,
				INVSLOT_MAINHAND
			}
			local nInvSlots

			for i=1, 11 do
				if not GetInventoryItemLink("player", invSlots[12 - i]) then
					tremove(invSlots, 12 - i)
				end
			end

			nInvSlots = #invSlots

			if ( nInvSlots > 0 ) then
				print("EasyRack2: "..L["EQUIP_SLIPOFF"])
				print("EasyRack2: "..L["SLIPOFF_ONEMORE_1"])
				print("EasyRack2: "..L["SLIPOFF_ONEMORE_2"])
				print("EasyRack2: "..L["SLIPOFF_ONEMORE_3"])

				PlaySound("SPELLBOOKOPEN")

				EasyRack2FrameText:SetText("|cfff01010"..L["STATUS_STRIP"].."|r")
				EasyRack2Frame:SetWidth(EasyRack2FrameText:GetWidth() + 40)

				for i=0, NUM_BAG_FRAMES do
					contOffset = 0
					for j=1, GetContainerNumSlots(i) do
						local link = GetContainerItemLink(i, j)
						if not link then
							PickupInventoryItem(invSlots[nInvSlots])
							PickupContainerItem(i, j)
							nInvSlots = nInvSlots - 1
							if nInvSlots <= 0 then return end
						end
					end
				end
			else
				if GetNumEquipmentSets() < 10 then
					for i=1, 19 do EquipmentManagerUnignoreSlotForSave(i) end
					for _, i in pairs(dontSlipOff) do
						EquipmentManagerIgnoreSlotForSave(i)
					end
					SaveEquipmentSet("Slip Off", -15)
					print("EasyRack2: "..L["SLIPOFF_RESERVED"])
					for i=1, 19 do EquipmentManagerUnignoreSlotForSave(i) end
				else
					print("|cfff01010EasyRack2: "..L["SLIPOFF_RESERVE_FAILED_1"].."|r")
				end
			end
		end
	end
end

function EasyRack_AnchorPlayerFrame()
	local playerFrameName = ""
	local playerFrame
	local unitFrames = {
		"PlayerFrame",
		"InvenUnitFramePlayer",
		"XPerl_Player"
	}
	for _, unitFrameName in pairs(unitFrames) do
		if _G[unitFrameName] and _G[unitFrameName]:IsVisible() then
			playerFrameName = unitFrameName
--			print(playerFrameName)
			break
		end
	end

	if playerFrameName == "" then
		print("Not supported PlayerFrame")
		-- 
		return
	end

	playerFrame = _G[playerFrameName]

	local xpos = GetCursorPosition()
	local xmin = 0 - playerFrame:GetWidth()

	xpos = xpos / GetCVar("uiScale")
	xpos = xpos - playerFrame:GetRight() + 150
	if xpos > 0 then xpos = 0 end
	if xpos < xmin then xpos = xmin end
	EasyRack2Frame:ClearAllPoints()
	EasyRack2Frame:SetPoint("BOTTOMRIGHT", playerFrame, "TOPRIGHT", xpos, 0)
end
