LIB_UIDROPDOWNMENU_MINBUTTONS = 8
LIB_UIDROPDOWNMENU_MAXBUTTONS = 8
LIB_UIDROPDOWNMENU_MAXLEVELS = 2
LIB_UIDROPDOWNMENU_BUTTON_HEIGHT = 16
LIB_UIDROPDOWNMENU_BORDER_HEIGHT = 15
LIB_UIDROPDOWNMENU_OPEN_MENU = nil
LIB_UIDROPDOWNMENU_INIT_MENU = nil
LIB_UIDROPDOWNMENU_MENU_LEVEL = 1
LIB_UIDROPDOWNMENU_MENU_VALUE = nil
LIB_UIDROPDOWNMENU_SHOW_TIME = 2
LIB_UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = nil
LIB_OPEN_DROPDOWNMENUS = {} 

-- Cache frequently used global functions for performance
local _G = _G
local CreateFrame = CreateFrame
local wipe = table.wipe
local max = math.max
local strmatch = string.match
local gsub = string.gsub
local pairs = pairs
local type = type
local GetCursorPosition = GetCursorPosition
local GetCVar = GetCVar
local GetScreenWidth = GetScreenWidth
local GetScreenHeight = GetScreenHeight
local UIParent = UIParent
local PlaySound = PlaySound
local GetTime = GetTime
local tonumber = tonumber
local securecall = securecall

-- Frame pool to avoid creating new frames repeatedly
local framePool = {}

-- Cache for element lookups to reduce _G calls
local elementCache = {}
local function GetElement(name)
    if not elementCache[name] then
        elementCache[name] = _G[name]
    end
    return elementCache[name]
end

local Lib_UIDropDownMenuDelegate = CreateFrame("FRAME")

-- Initialize frame hierarchy only once at startup
for i = 1, LIB_UIDROPDOWNMENU_MAXLEVELS do
    local listFrameName = "Lib_DropDownList"..i
    local f = CreateFrame("Button", listFrameName, nil, "Lib_UIDropDownListTemplate")
    f:SetID(i)
    f:SetSize(180, 10)
    f:SetFrameStrata("FULLSCREEN_DIALOG")
    
    -- Get font measurements once
    if i == 1 then
        local fontName, fontHeight, fontFlags = _G["Lib_DropDownList1Button1NormalText"]:GetFont()
        LIB_UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontHeight
    end
    
    -- Create buttons for this dropdown level
    for j = 1, LIB_UIDROPDOWNMENU_MAXBUTTONS do
        local b = CreateFrame("Button", listFrameName.."Button"..j, f, "Lib_UIDropDownMenuButtonTemplate")
        b:SetID(j)
    end
end

function Lib_UIDropDownMenuDelegate_OnAttributeChanged(self, attribute, value)
    if attribute == "createframes" and value == true then
        Lib_UIDropDownMenu_CreateFrames(self:GetAttribute("createframes-level"), self:GetAttribute("createframes-index"))
    elseif attribute == "initmenu" then
        LIB_UIDROPDOWNMENU_INIT_MENU = value
    elseif attribute == "openmenu" then
        LIB_UIDROPDOWNMENU_OPEN_MENU = value
    end
end

Lib_UIDropDownMenuDelegate:SetScript("OnAttributeChanged", Lib_UIDropDownMenuDelegate_OnAttributeChanged)

-- Reusable info tables to prevent memory churn
local Lib_UIDropDownMenu_ButtonInfo = {}
local Lib_UIDropDownMenu_SecureInfo = {}

function Lib_UIDropDownMenu_CreateInfo()
    -- Reuse the same table to prevent memory churn
    if issecure() then
        securecall(wipe, Lib_UIDropDownMenu_SecureInfo)
        return Lib_UIDropDownMenu_SecureInfo
    else
        return wipe(Lib_UIDropDownMenu_ButtonInfo)
    end
end

-- Optimized frame creation with pooling
function Lib_UIDropDownMenu_CreateFrames(level, index)
    local poolKey = level .. "-" .. index
    
    if framePool[poolKey] then
        return framePool[poolKey]
    end
    
    -- Create new levels if needed
    while (level > LIB_UIDROPDOWNMENU_MAXLEVELS) do
        LIB_UIDROPDOWNMENU_MAXLEVELS = LIB_UIDROPDOWNMENU_MAXLEVELS + 1
        local newList = CreateFrame("Button", "Lib_DropDownList"..LIB_UIDROPDOWNMENU_MAXLEVELS, nil, "Lib_UIDropDownListTemplate")
        newList:SetFrameStrata("FULLSCREEN_DIALOG")
        newList:SetToplevel(1)
        newList:Hide()
        newList:SetID(LIB_UIDROPDOWNMENU_MAXLEVELS)
        newList:SetWidth(180)
        newList:SetHeight(10)
        
        -- Create new buttons for this level
        for i=1, LIB_UIDROPDOWNMENU_MAXBUTTONS do
            local newButton = CreateFrame("Button", "Lib_DropDownList"..LIB_UIDROPDOWNMENU_MAXLEVELS.."Button"..i, newList, "Lib_UIDropDownMenuButtonTemplate")
            newButton:SetID(i)
        end
    end

    while (index > LIB_UIDROPDOWNMENU_MAXBUTTONS) do
        LIB_UIDROPDOWNMENU_MAXBUTTONS = LIB_UIDROPDOWNMENU_MAXBUTTONS + 1
        for i=1, LIB_UIDROPDOWNMENU_MAXLEVELS do
            local newButton = CreateFrame("Button", "Lib_DropDownList"..i.."Button"..LIB_UIDROPDOWNMENU_MAXBUTTONS, _G["Lib_DropDownList"..i], "Lib_UIDropDownMenuButtonTemplate")
            newButton:SetID(LIB_UIDROPDOWNMENU_MAXBUTTONS)
        end
    end
    
    -- Store the frame in our pool for future reuse
    framePool[poolKey] = _G["Lib_DropDownList"..level]
    return framePool[poolKey]
end

function Lib_UIDropDownMenuButton_OnEnter(self)
    if self:GetParent().isCounting then
        Lib_UIDropDownMenu_StopCounting(self:GetParent())
    end
    
    if self.disabled then 
        return
    end
    
    GetElement(self:GetName().."Highlight"):Show()
    
    if self.hasArrow then
        local submenuFrame = GetElement("Lib_DropDownList"..(self:GetParent():GetID() + 1))
        if not submenuFrame:IsShown() or submenuFrame.parentID ~= self:GetID() then
            Lib_ToggleDropDownMenu(self:GetParent():GetID() + 1, self.value, nil, nil, nil, nil, self.menuList, self)
        end
    elseif self.menuList then
        Lib_ToggleDropDownMenu(self:GetParent():GetID() + 1, self.value, nil, nil, nil, nil, self.menuList, self)
    end
    
    if self.tooltipTitle and not self.tooltipDisplayed then
        self.tooltipDisplayed = true
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(self.tooltipTitle, 1.0, 1.0, 1.0)
        if self.tooltipText then
            GameTooltip:AddLine(self.tooltipText, nil, nil, nil, true)
        end
        GameTooltip:Show()
    end
end

function Lib_UIDropDownMenuButton_OnLeave(self)
    if self:GetParent().showTimer and not self:GetParent().isCounting then
        Lib_UIDropDownMenu_StartCounting(self:GetParent())
    end
    
    GetElement(self:GetName().."Highlight"):Hide()
    
    if self.tooltipDisplayed then
        self.tooltipDisplayed = nil
        GameTooltip:Hide()
    end
end

function Lib_UIDropDownMenu_OnUpdate(self, elapsed)
    if not (self.showTimer and self.isCounting) then
        return
    end
    
    self.elapsedTime = (self.elapsedTime or 0) + elapsed
    if self.elapsedTime < 0.1 then
        return
    end
    
    self.elapsedTime = 0
    self.showTimer = self.showTimer - 0.1
    
    if self.showTimer < 0 then
        self:Hide()
        self.showTimer = nil
        self.isCounting = nil
    end
end

function Lib_UIDropDownMenu_StartCounting(frame)
    if frame.parent then
        Lib_UIDropDownMenu_StartCounting(frame.parent)
    else
        if not frame.isCounting then
            frame.showTimer = LIB_UIDROPDOWNMENU_SHOW_TIME
            frame.isCounting = 1
            frame.elapsedTime = 0
        end
    end
end

function Lib_UIDropDownMenu_StopCounting(frame)
    if frame.parent then
        Lib_UIDropDownMenu_StopCounting(frame.parent)
    else
        frame.isCounting = nil
    end
end

function Lib_UIDropDownMenu_InitializeHelper(frame)
    -- This deals with the potentially tainted stuff!
    if frame ~= LIB_UIDROPDOWNMENU_OPEN_MENU then
        LIB_UIDROPDOWNMENU_MENU_LEVEL = 1
    end

    Lib_UIDropDownMenuDelegate:SetAttribute("initmenu", frame)
    
    local dropDownList, button
    for i = 1, LIB_UIDROPDOWNMENU_MAXLEVELS, 1 do
        dropDownList = GetElement("Lib_DropDownList"..i)
        if i >= LIB_UIDROPDOWNMENU_MENU_LEVEL or frame ~= LIB_UIDROPDOWNMENU_OPEN_MENU then
            dropDownList.numButtons = 0
            dropDownList.maxWidth = 0
            for j=1, LIB_UIDROPDOWNMENU_MAXBUTTONS, 1 do
                button = GetElement("Lib_DropDownList"..i.."Button"..j)
                button:Hide()
            end
            dropDownList:Hide()
        end
    end
    frame:SetHeight(LIB_UIDROPDOWNMENU_BUTTON_HEIGHT * 2)
end

function Lib_UIDropDownMenu_Initialize(frame, initFunction, displayMode, level, menuList)
    frame.menuList = menuList

    securecall("Lib_UIDropDownMenu_InitializeHelper", frame)
    
    if initFunction then
        frame.initialize = initFunction
        initFunction(frame, level, frame.menuList)
    end

    level = level or 1
    GetElement("Lib_DropDownList"..level).dropdown = frame

    if displayMode == "MENU" then
        local name = frame:GetName()
        GetElement(name.."Left"):Hide()
        GetElement(name.."Middle"):Hide()
        GetElement(name.."Right"):Hide()
        GetElement(name.."ButtonNormalTexture"):SetTexture("")
        GetElement(name.."ButtonDisabledTexture"):SetTexture("")
        GetElement(name.."ButtonPushedTexture"):SetTexture("")
        GetElement(name.."ButtonHighlightTexture"):SetTexture("")
        
        local buttonElement = GetElement(name.."Button")
        buttonElement:ClearAllPoints()
        buttonElement:SetPoint("LEFT", name.."Text", "LEFT", -9, 0)
        buttonElement:SetPoint("RIGHT", name.."Text", "RIGHT", 6, 0)
        frame.displayMode = "MENU"
    end
end

function Lib_UIDropDownMenu_AddButton(info, level)
    level = level or 1
    
    local listFrame = GetElement("Lib_DropDownList"..level)
    local index = listFrame and (listFrame.numButtons + 1) or 1
    
    Lib_UIDropDownMenuDelegate:SetAttribute("createframes-level", level)
    Lib_UIDropDownMenuDelegate:SetAttribute("createframes-index", index)
    Lib_UIDropDownMenuDelegate:SetAttribute("createframes", true)
    
    listFrame = listFrame or GetElement("Lib_DropDownList"..level)
    local listFrameName = listFrame:GetName()
    
    listFrame.numButtons = index
    
    local button = GetElement(listFrameName.."Button"..index)
    local normalText = GetElement(button:GetName().."NormalText")
    local icon = GetElement(button:GetName().."Icon")
    local invisibleButton = GetElement(button:GetName().."InvisibleButton")
    
    button:SetDisabledFontObject(GameFontDisableSmallLeft)
    invisibleButton:Hide()
    button:Enable()
    
    if info.notClickable then
        info.disabled = 1
        button:SetDisabledFontObject(GameFontHighlightSmallLeft)
    end

    if info.isTitle then
        info.disabled = 1
        button:SetDisabledFontObject(GameFontNormalSmallLeft)
    end
    
    if info.disabled then
        button:Disable()
        invisibleButton:Show()
        info.colorCode = nil
    end
    
    if info.disablecolor then
        info.colorCode = info.disablecolor
    end

    local width = 0
    if info.text then
        if info.colorCode then
            button:SetText(info.colorCode..info.text.."|r")
        else
            button:SetText(info.text)
        end
        
        width = normalText:GetWidth() + 40
        if info.hasArrow or info.hasColorSwatch then
            width = width + 10
        end
        if info.notCheckable then
            width = width - 30
        end
        
        if info.icon then
            icon:SetSize(16, 16)
            icon:SetTexture(info.icon)
            icon:ClearAllPoints()
            icon:SetPoint("RIGHT")

            if info.tCoordLeft then
                icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom)
            else
                icon:SetTexCoord(0, 1, 0, 1)
            end
            icon:Show()
            width = width + 10
        else
            icon:Hide()
        end
        
        if info.padding then
            width = width + info.padding
        end
        
        width = max(width, info.minWidth or 0)
        
        if width > listFrame.maxWidth then
            listFrame.maxWidth = width
        end
        
        if info.fontObject then
            button:SetNormalFontObject(info.fontObject)
            button:SetHighlightFontObject(info.fontObject)
        else
            button:SetNormalFontObject(GameFontHighlightSmallLeft)
            button:SetHighlightFontObject(GameFontHighlightSmallLeft)
        end
    else
        button:SetText("")
        icon:Hide()
    end
    
    button.iconOnly = nil
    button.icon = nil
    button.iconInfo = nil
    
    if info.iconOnly and info.icon then
        button.iconOnly = true
        button.icon = info.icon
        button.iconInfo = info.iconInfo

        Lib_UIDropDownMenu_SetIconImage(icon, info.icon, info.iconInfo)
        icon:ClearAllPoints()
        icon:SetPoint("LEFT")

        width = icon:GetWidth()
        if info.hasArrow or info.hasColorSwatch then
            width = width + 50 - 30
        end
        if info.notCheckable then
            width = width - 30
        end
        if width > listFrame.maxWidth then
            listFrame.maxWidth = width
        end
    end

    button.func = info.func
    button.owner = info.owner
    button.hasOpacity = info.hasOpacity
    button.opacity = info.opacity
    button.opacityFunc = info.opacityFunc
    button.cancelFunc = info.cancelFunc
    button.swatchFunc = info.swatchFunc
    button.keepShownOnClick = info.keepShownOnClick
    button.tooltipTitle = info.tooltipTitle
    button.tooltipText = info.tooltipText
    button.arg1 = info.arg1
    button.arg2 = info.arg2
    button.hasArrow = info.hasArrow
    button.hasColorSwatch = info.hasColorSwatch
    button.notCheckable = info.notCheckable
    button.menuList = info.menuList
    button.tooltipWhileDisabled = info.tooltipWhileDisabled
    button.tooltipOnButton = info.tooltipOnButton
    button.noClickSound = info.noClickSound
    button.padding = info.padding
    
    if info.value then
        button.value = info.value
    elseif info.text then
        button.value = info.text
    else
        button.value = nil
    end
    
    local expandArrow = GetElement(listFrameName.."Button"..index.."ExpandArrow")
    if info.hasArrow then
        expandArrow:Show()
    else
        expandArrow:Hide()
    end
    
    local xPos = 5
    local yPos = -((button:GetID() - 1) * LIB_UIDROPDOWNMENU_BUTTON_HEIGHT) - LIB_UIDROPDOWNMENU_BORDER_HEIGHT
    local displayInfo = normalText
    
    if info.iconOnly then
        displayInfo = icon
    end
    
    displayInfo:ClearAllPoints()
    if info.notCheckable then
        if info.justifyH and info.justifyH == "CENTER" then
            displayInfo:SetPoint("CENTER", button, "CENTER", -7, 0)
        else
            displayInfo:SetPoint("LEFT", button, "LEFT", 0, 0)
        end
        xPos = xPos + 10
    else
        xPos = xPos + 12
        displayInfo:SetPoint("LEFT", button, "LEFT", 20, 0)
    end

    local frame = LIB_UIDROPDOWNMENU_OPEN_MENU
    if frame and frame.displayMode == "MENU" and not info.notCheckable then
        xPos = xPos - 6
    end
    
    frame = frame or LIB_UIDROPDOWNMENU_INIT_MENU

    if info.leftPadding then
        xPos = xPos + info.leftPadding
    end
    
    button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", xPos, yPos)

    if frame then
        if Lib_UIDropDownMenu_GetSelectedName(frame) then
            if button:GetText() == Lib_UIDropDownMenu_GetSelectedName(frame) then
                info.checked = 1
            end
        elseif Lib_UIDropDownMenu_GetSelectedID(frame) then
            if button:GetID() == Lib_UIDropDownMenu_GetSelectedID(frame) then
                info.checked = 1
            end
        elseif Lib_UIDropDownMenu_GetSelectedValue(frame) then
            if button.value == Lib_UIDropDownMenu_GetSelectedValue(frame) then
                info.checked = 1
            end
        end
    end

    local checkButton = GetElement(listFrameName.."Button"..index.."Check")
    local uncheckButton = GetElement(listFrameName.."Button"..index.."UnCheck")
    
    if not info.notCheckable then 
        if info.isNotRadio then
            checkButton:SetTexCoord(0.0, 0.5, 0.0, 0.5)
            uncheckButton:SetTexCoord(0.5, 1.0, 0.0, 0.5)
        else
            checkButton:SetTexCoord(0.0, 0.5, 0.5, 1.0)
            uncheckButton:SetTexCoord(0.5, 1.0, 0.5, 1.0)
        end
        
        local checked = info.checked
        if type(checked) == "function" then
            checked = checked(button)
        end

        if checked then
            button:LockHighlight()
            checkButton:Show()
            uncheckButton:Hide()
        else
            button:UnlockHighlight()
            checkButton:Hide()
            uncheckButton:Show()
        end
    else
        checkButton:Hide()
        uncheckButton:Hide()
    end
    
    button.checked = info.checked

    local colorSwatch = GetElement(listFrameName.."Button"..index.."ColorSwatch")
    if info.hasColorSwatch then
        GetElement("Lib_DropDownList"..level.."Button"..index.."ColorSwatch".."NormalTexture"):SetVertexColor(info.r, info.g, info.b)
        button.r = info.r
        button.g = info.g
        button.b = info.b
        colorSwatch:Show()
    else
        colorSwatch:Hide()
    end

    listFrame:SetHeight((index * LIB_UIDROPDOWNMENU_BUTTON_HEIGHT) + (LIB_UIDROPDOWNMENU_BORDER_HEIGHT * 2))
    button:Show()
end

function Lib_UIDropDownMenu_Refresh(frame, useValue, dropdownLevel)
    if frame.lastRefreshTime and GetTime() - frame.lastRefreshTime < 0.1 then
        return
    end
    
    frame.lastRefreshTime = GetTime()
    
    local button, checked, checkImage, uncheckImage, normalText
    local maxWidth = 0
    local somethingChecked = nil
    
    dropdownLevel = dropdownLevel or LIB_UIDROPDOWNMENU_MENU_LEVEL
    local listFrame = GetElement("Lib_DropDownList"..dropdownLevel)
    listFrame.numButtons = listFrame.numButtons or 0
    
    local selectedName = Lib_UIDropDownMenu_GetSelectedName(frame)
    local selectedID = Lib_UIDropDownMenu_GetSelectedID(frame)
    local selectedValue = Lib_UIDropDownMenu_GetSelectedValue(frame)
    
    for i=1, listFrame.numButtons do
        button = GetElement("Lib_DropDownList"..dropdownLevel.."Button"..i)
        
        if button:IsShown() then
            checked = nil
            
            if selectedName and button:GetText() == selectedName then
                checked = 1
            elseif selectedID and button:GetID() == selectedID then
                checked = 1
            elseif selectedValue and button.value == selectedValue then
                checked = 1
            end
            
            if button.checked and type(button.checked) == "function" then
                checked = button.checked(button)
            end
            
            if not button.notCheckable then
                checkImage = GetElement("Lib_DropDownList"..dropdownLevel.."Button"..i.."Check")
                uncheckImage = GetElement("Lib_DropDownList"..dropdownLevel.."Button"..i.."UnCheck")
                
                if checked then
                    somethingChecked = true
                    if not checkImage:IsShown() then
                        button:LockHighlight()
                        checkImage:Show()
                        uncheckImage:Hide()
                    end
                else
                    if checkImage:IsShown() then
                        button:UnlockHighlight()
                        checkImage:Hide()
                        uncheckImage:Show()
                    end
                end
            end
            
            if not frame.noResize then
                if button.iconOnly then
                    local icon = GetElement(button:GetName().."Icon")
                    width = icon:GetWidth()
                else
                    normalText = GetElement(button:GetName().."NormalText")
                    width = normalText:GetWidth() + 40
                    
                    if button.hasArrow or button.hasColorSwatch then
                        width = width + 10
                    end
                    if button.notCheckable then
                        width = width - 30
                    end
                    if button.padding then
                        width = width + button.padding
                    end
                end
                
                if width > maxWidth then
                    maxWidth = width
                end
            end
        end
    end

    if somethingChecked == nil then
        Lib_UIDropDownMenu_SetText(frame, VIDEO_QUALITY_LABEL6)
    end

    if not frame.noResize and maxWidth > 0 then
        for i=1, listFrame.numButtons do
            button = GetElement("Lib_DropDownList"..dropdownLevel.."Button"..i)
            if button:GetWidth() ~= maxWidth then
                button:SetWidth(maxWidth)
            end
        end
        
        if listFrame:GetWidth() ~= (maxWidth + 15) then
            listFrame:SetWidth(maxWidth + 15)
        end
    end
end

function Lib_UIDropDownMenuButton_OnClick(self)
    local checked = self.checked
    if type(checked) == "function" then
        checked = checked(self)
    end
    
    if self.keepShownOnClick then
        if not self.notCheckable then
            local checkName = self:GetName().."Check"
            local uncheckName = self:GetName().."UnCheck"
            local checkElement = GetElement(checkName)
            local uncheckElement = GetElement(uncheckName)
            
            if checked then
                checkElement:Hide()
                uncheckElement:Show()
                checked = false
            else
                checkElement:Show()
                uncheckElement:Hide()
                checked = true
            end
        end
    else
        self:GetParent():Hide()
    end
    
    if type(self.checked) ~= "function" then
        self.checked = checked
    end
    

    local playSound = not self.noClickSound
    local func = self.func
    
    if func then
        func(self, self.arg1, self.arg2, checked)
    end
    
    if playSound then
        PlaySound("UChatScrollButton")
    end
end

function Lib_HideDropDownMenu(level)
    GetElement("Lib_DropDownList"..level):Hide()
end

function Lib_UIDropDownMenu_SetSelectedName(frame, name, useValue)
    frame.selectedName = name
    frame.selectedID = nil
    frame.selectedValue = nil
    Lib_UIDropDownMenu_Refresh(frame, useValue)
end

function Lib_UIDropDownMenu_SetSelectedValue(frame, value, useValue)
    frame.selectedName = nil
    frame.selectedID = nil
    frame.selectedValue = value
    Lib_UIDropDownMenu_Refresh(frame, useValue)
end

function Lib_UIDropDownMenu_SetSelectedID(frame, id, useValue)
    frame.selectedID = id;
    frame.selectedName = nil;
    frame.selectedValue = nil;
    Lib_UIDropDownMenu_Refresh(frame, useValue);
end

function Lib_UIDropDownMenu_GetSelectedName(frame)
    return frame.selectedName;
end

function Lib_UIDropDownMenu_GetSelectedValue(frame)
    return frame.selectedValue;
end

function Lib_UIDropDownMenu_GetSelectedID(frame)
    if frame.selectedID then
        return frame.selectedID;
    elseif LIB_UIDROPDOWNMENU_MENU_LEVEL then
        local dropdownList = _G["Lib_DropDownList"..LIB_UIDROPDOWNMENU_MENU_LEVEL];
        local numButtons = dropdownList and dropdownList.numButtons or 0;
        
        local selectedName = frame.selectedName;
        local selectedValue = frame.selectedValue;
        
        for i=1, numButtons do
            local button = _G["Lib_DropDownList"..LIB_UIDROPDOWNMENU_MENU_LEVEL.."Button"..i];
            
            if selectedName and button:GetText() == selectedName then
                return i;
            elseif selectedValue and button.value == selectedValue then
                return i;
            end
        end
    end
end

function Lib_UIDropDownMenuButton_OnClick(self)
    local checkName = self:GetName().."Check";
    local uncheckName = self:GetName().."UnCheck";
    local checked = self.checked;
    
    if type(checked) == "function" then
        checked = checked(self);
    end
    
    if self.keepShownOnClick then
        if not self.notCheckable then
            if checked then
                _G[checkName]:Hide();
                _G[uncheckName]:Show();
                checked = false;
            else
                _G[checkName]:Show();
                _G[uncheckName]:Hide();
                checked = true;
            end
        end
    else
        self:GetParent():Hide();
    end
    
    if type(self.checked) ~= "function" then
        self.checked = checked;
    end
    
    local func = self.func;
    if func then
        func(self, self.arg1, self.arg2, checked);
    end
    
    if not self.noClickSound then
        PlaySound("UChatScrollButton");
    end
end

function Lib_HideDropDownMenu(level)
    _G["Lib_DropDownList"..level]:Hide();
end

function Lib_ToggleDropDownMenu(level, value, dropDownFrame, anchorName, xOffset, yOffset, menuList, button, autoHideDelay)
    level = level or 1;
    
    local listFrameName = "Lib_DropDownList"..level;
    local listFrame = _G[listFrameName];
    local uiScale;
    local tempFrame;
    
    Lib_UIDropDownMenuDelegate:SetAttribute("createframes-level", level);
    Lib_UIDropDownMenuDelegate:SetAttribute("createframes-index", 0);
    Lib_UIDropDownMenuDelegate:SetAttribute("createframes", true);
    LIB_UIDROPDOWNMENU_MENU_LEVEL = level;
    LIB_UIDROPDOWNMENU_MENU_VALUE = value;
    
    if not dropDownFrame then
        tempFrame = button:GetParent();
    else
        tempFrame = dropDownFrame;
    end
    
    if listFrame:IsShown() and (LIB_UIDROPDOWNMENU_OPEN_MENU == tempFrame) then
        listFrame:Hide();
        return;
    end
    
    local uiParentScale = UIParent:GetScale();
    if GetCVar("useUIScale") == "1" then
        uiScale = tonumber(GetCVar("uiscale"));
        if uiParentScale < uiScale then
            uiScale = uiParentScale;
        end
    else
        uiScale = uiParentScale;
    end
    
    listFrame:SetScale(uiScale);
    listFrame:Hide();
    
    local point, relativePoint, relativeTo;
    local anchorFrame;
    
    if level == 1 then
        Lib_UIDropDownMenuDelegate:SetAttribute("openmenu", dropDownFrame);
        listFrame:ClearAllPoints();
        
        if not anchorName then
            xOffset = dropDownFrame.xOffset or xOffset;
            yOffset = dropDownFrame.yOffset or yOffset;
            point = dropDownFrame.point or point;
            relativeTo = dropDownFrame.relativeTo or (LIB_UIDROPDOWNMENU_OPEN_MENU:GetName().."Left");
            relativePoint = dropDownFrame.relativePoint or relativePoint;
        elseif anchorName == "cursor" then
            relativeTo = nil;
            local cursorX, cursorY = GetCursorPosition();
            cursorX = cursorX/uiScale;
            cursorY = cursorY/uiScale;
            
            xOffset = (xOffset or 0) + cursorX;
            yOffset = (yOffset or 0) + cursorY;
        else
            xOffset = dropDownFrame.xOffset or xOffset;
            yOffset = dropDownFrame.yOffset or yOffset;
            point = dropDownFrame.point or point;
            relativeTo = dropDownFrame.relativeTo or anchorName;
            relativePoint = dropDownFrame.relativePoint or relativePoint;
        end
        
        xOffset = xOffset or 8;
        yOffset = yOffset or 22;
        point = point or "TOPLEFT";
        relativePoint = relativePoint or "BOTTOMLEFT";
        
        listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
    else
        dropDownFrame = dropDownFrame or LIB_UIDROPDOWNMENU_OPEN_MENU;
        listFrame:ClearAllPoints();
        
        local bname = button:GetParent():GetName();
        if bname:match("^Lib_DropDownList%d+$") then
            anchorFrame = button;
        else
            anchorFrame = button:GetParent();
        end
        
        point = "TOPLEFT";
        relativePoint = "TOPRIGHT";
        listFrame:SetPoint(point, anchorFrame, relativePoint, 0, 0);
    end
    
    local backdropFrame = _G[listFrameName.."Backdrop"];
    local menuBackdropFrame = _G[listFrameName.."MenuBackdrop"];
    
    if dropDownFrame and dropDownFrame.displayMode == "MENU" then
        backdropFrame:Hide();
        menuBackdropFrame:Show();
    else
        backdropFrame:Show();
        menuBackdropFrame:Hide();
    end
    
    dropDownFrame.menuList = menuList;
    Lib_UIDropDownMenu_Initialize(dropDownFrame, dropDownFrame.initialize, nil, level, menuList);
    
    if listFrame.numButtons == 0 then
        return;
    end
    
    listFrame:Show();
    local x, y = listFrame:GetCenter();
    
    if not x or not y then
        listFrame:Hide();
        return;
    end
    
    listFrame.onHide = dropDownFrame.onHide;
    
    if level == 1 then
        local offLeft = listFrame:GetLeft()/uiScale;
        local offRight = (GetScreenWidth() - listFrame:GetRight())/uiScale;
        local offTop = (GetScreenHeight() - listFrame:GetTop())/uiScale;
        local offBottom = listFrame:GetBottom()/uiScale;
        
        local xAddOffset, yAddOffset = 0, 0;
        if offLeft < 0 then
            xAddOffset = -offLeft;
        elseif offRight < 0 then
            xAddOffset = offRight;
        end
        
        if offTop < 0 then
            yAddOffset = offTop;
        elseif offBottom < 0 then
            yAddOffset = -offBottom;
        end
        
        listFrame:ClearAllPoints();
        listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset);
    else
        local offscreenY = (y - listFrame:GetHeight()/2) < 0;
        local offscreenX = listFrame:GetRight() > GetScreenWidth();
        local offscreenBottomY = (listFrame:GetBottom() < 0);
        
        if offscreenY and offscreenX then
            point = gsub(point, "TOP(.*)", "BOTTOM%1");
            point = gsub(point, "(.*)LEFT", "%1RIGHT");
            relativePoint = gsub(relativePoint, "TOP(.*)", "BOTTOM%1");
            relativePoint = gsub(relativePoint, "(.*)RIGHT", "%1LEFT");
            xOffset = -11;
            yOffset = -14;
        elseif offscreenBottomY then
            point = "BOTTOMLEFT";
            relativePoint = "BOTTOMRIGHT";
            xOffset = 0;
            yOffset = 14;
        elseif offscreenY then
            point = gsub(point, "TOP(.*)", "BOTTOM%1");
            relativePoint = gsub(relativePoint, "TOP(.*)", "BOTTOM%1");
            xOffset = 0;
            yOffset = -14;
        elseif offscreenX then
            point = gsub(point, "(.*)LEFT", "%1RIGHT");
            relativePoint = gsub(relativePoint, "(.*)RIGHT", "%1LEFT");
            xOffset = -11;
            yOffset = 14;
        else
            point = "TOPLEFT";
            relativePoint = "TOPRIGHT";
            xOffset = 0;
            yOffset = 0;
        end
        
        listFrame:ClearAllPoints();
        listFrame.parentLevel = tonumber(strmatch(anchorFrame:GetName(), "Lib_DropDownList(%d+)"));
        listFrame.parentID = anchorFrame:GetID();
        listFrame:SetPoint(point, anchorFrame, relativePoint, xOffset, yOffset);
    end
    
    if autoHideDelay and tonumber(autoHideDelay) then
        listFrame.showTimer = autoHideDelay;
        listFrame.isCounting = 1;
        listFrame.elapsedTime = 0;
    end
end

function Lib_CloseDropDownMenus(level)
    level = level or 1;
    
    for i=level, LIB_UIDROPDOWNMENU_MAXLEVELS do
        _G["Lib_DropDownList"..i]:Hide();
    end
end

function Lib_UIDropDownMenu_OnHide(self)
    local id = self:GetID();
    
    if self.onHide then
        self.onHide(id+1);
        self.onHide = nil;
    end
    
    Lib_CloseDropDownMenus(id+1);
    LIB_OPEN_DROPDOWNMENUS[id] = nil;
end

function Lib_UIDropDownMenu_SetWidth(frame, width, padding)
    local middleFrame = _G[frame:GetName().."Middle"];
    local textFrame = _G[frame:GetName().."Text"];
    
    middleFrame:SetWidth(width);
    
    local defaultPadding = 25;
    local totalPadding = padding or (defaultPadding * 2);
    
    frame:SetWidth(width + totalPadding);
    
    if padding then
        textFrame:SetWidth(width);
    else
        textFrame:SetWidth(width - defaultPadding);
    end
    
    frame.noResize = 1;
end

function Lib_UIDropDownMenu_SetButtonWidth(frame, width)
    if width == "TEXT" then
        width = _G[frame:GetName().."Text"]:GetWidth();
    end
    

    _G[frame:GetName().."Button"]:SetWidth(width);
    frame.noResize = 1;
end

function Lib_UIDropDownMenu_SetText(frame, text)
    _G[frame:GetName().."Text"]:SetText(text);
end

function Lib_UIDropDownMenu_GetText(frame)
    return _G[frame:GetName().."Text"]:GetText();
end

function Lib_UIDropDownMenu_ClearAll(frame)
    frame.selectedID = nil;
    frame.selectedName = nil;
    frame.selectedValue = nil;
    
    Lib_UIDropDownMenu_SetText(frame, "");
    
    local currentLevel = LIB_UIDROPDOWNMENU_MENU_LEVEL;
    
    for i=1, LIB_UIDROPDOWNMENU_MAXBUTTONS do
        local buttonName = "Lib_DropDownList"..currentLevel.."Button"..i;
        local button = _G[buttonName];
        local checkImage = _G[buttonName.."Check"];
        local uncheckImage = _G[buttonName.."UnCheck"];
        
        button:UnlockHighlight();
        checkImage:Hide();
        uncheckImage:Hide();
    end
end

function Lib_UIDropDownMenu_JustifyText(frame, justification)
    local frameName = frame:GetName();
    local text = _G[frameName.."Text"];
    
    text:ClearAllPoints();
    
    if justification == "LEFT" then
        text:SetPoint("LEFT", frameName.."Left", "LEFT", 27, 2);
        text:SetJustifyH("LEFT");
    elseif justification == "RIGHT" then
        text:SetPoint("RIGHT", frameName.."Right", "RIGHT", -43, 2);
        text:SetJustifyH("RIGHT");
    elseif justification == "CENTER" then
        text:SetPoint("CENTER", frameName.."Middle", "CENTER", -5, 2);
        text:SetJustifyH("CENTER");
    end
end

function Lib_UIDropDownMenu_SetAnchor(dropdown, xOffset, yOffset, point, relativeTo, relativePoint)
    dropdown.xOffset = xOffset;
    dropdown.yOffset = yOffset;
    dropdown.point = point;
    dropdown.relativeTo = relativeTo;
    dropdown.relativePoint = relativePoint;
end

function Lib_UIDropDownMenu_GetCurrentDropDown()
    if LIB_UIDROPDOWNMENU_OPEN_MENU then
        return LIB_UIDROPDOWNMENU_OPEN_MENU;
    elseif LIB_UIDROPDOWNMENU_INIT_MENU then
        return LIB_UIDROPDOWNMENU_INIT_MENU;
    end
end

function Lib_UIDropDownMenuButton_GetChecked(self)
    return _G[self:GetName().."Check"]:IsShown();
end

function Lib_UIDropDownMenuButton_GetName(self)
    return _G[self:GetName().."NormalText"]:GetText();
end

function Lib_UIDropDownMenuButton_OpenColorPicker(self, button)
    CloseMenus();
    LIB_UIDROPDOWNMENU_MENU_VALUE = (button or self).value;
    OpenColorPicker(button or self);
end

function Lib_UIDropDownMenu_DisableButton(level, id)
    _G["Lib_DropDownList"..level.."Button"..id]:Disable();
end

function Lib_UIDropDownMenu_EnableButton(level, id)
    _G["Lib_DropDownList"..level.."Button"..id]:Enable();
end

function Lib_UIDropDownMenu_SetButtonText(level, id, text, colorCode)
    local button = _G["Lib_DropDownList"..level.."Button"..id];
    
    if colorCode then
        button:SetText(colorCode..text.."|r");
    else
        button:SetText(text);
    end
end

function Lib_UIDropDownMenu_DisableDropDown(dropDown)
    local frameName = dropDown:GetName();
    local label = _G[frameName.."Label"];
    
    if label then
        label:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
    end
    
    _G[frameName.."Text"]:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
    _G[frameName.."Button"]:Disable();
    dropDown.isDisabled = 1;
end

function Lib_UIDropDownMenu_EnableDropDown(dropDown)
    local frameName = dropDown:GetName();
    local label = _G[frameName.."Label"];
    
    if label then
        label:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
    end
    
    _G[frameName.."Text"]:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
    _G[frameName.."Button"]:Enable();
    dropDown.isDisabled = nil;
end

function Lib_UIDropDownMenu_IsEnabled(dropDown)
    return not dropDown.isDisabled;
end

function Lib_UIDropDownMenu_GetValue(id)
    local button = _G["DropDownList1Button"..id];
    if button then
        return button.value;
    end
    return nil;
end