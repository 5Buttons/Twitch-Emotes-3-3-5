local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon = LibStub("LibDBIcon-1.0")

Emoticons_Settings={
	["CHAT_MSG_OFFICER"]=true,		--1
	["CHAT_MSG_GUILD"]=true,		--2
	["CHAT_MSG_PARTY"]=true,		--3
	["CHAT_MSG_PARTY_LEADER"]=true,		--dont count, tie to 3
	["CHAT_MSG_PARTY_GUIDE"]=true,		--dont count, tie to 3
	["CHAT_MSG_RAID"]=true,			--4
	["CHAT_MSG_RAID_LEADER"]=true,		--dont count, tie to 4
	["CHAT_MSG_RAID_WARNING"]=true,		--dont count, tie to 4
	["CHAT_MSG_SAY"]=true,			--5
	["CHAT_MSG_YELL"]=true,			--6
	["CHAT_MSG_WHISPER"]=true,		--7
	["CHAT_MSG_WHISPER_INFORM"]=true,	--dont count, tie to 7
	["CHAT_MSG_CHANNEL"]=true,		--8
--	["CHAT_MSG_BN_WHISPER"]=true,	--9
--	["CHAT_MSG_BN_WHISPER_INFORM"]=true,--dont count, tie to 9
--	["CHAT_MSG_BN_CONVERSATION"]=true,--10
	["CHAT_MSG_BATTLEGROUND"]=true,--11
	["CHAT_MSG_BATTLEGROUND_LEADER"]=true,--dont count, tie to 11
	["MAIL"]=true,
	["TWITCHBUTTON"]=true,
	["sliderX"]=-35,
	["sliderY"]=0,
	["MinimapPos"] = 45,
	["MINIMAPBUTTON"] = true,
	["FAVEMOTES"] = {true,true,true,true,true,true,true,true,true,true,
	true,true,true,true,true,true,true,true,true,true,
	true,true,true,true,true,true,true,true,}
  
  };
  Emoticons_Eyecandy = false;
  
  local origsettings = {
	["CHAT_MSG_OFFICER"]=true,
	["CHAT_MSG_GUILD"]=true,
	["CHAT_MSG_PARTY"]=true,
	["CHAT_MSG_PARTY_LEADER"]=true,
	["CHAT_MSG_PARTY_GUIDE"]=true,
	["CHAT_MSG_RAID"]=true,
	["CHAT_MSG_RAID_LEADER"]=true,
	["CHAT_MSG_RAID_WARNING"]=true,
	["CHAT_MSG_SAY"]=true,
	["CHAT_MSG_YELL"]=true,
	["CHAT_MSG_WHISPER"]=true,
	["CHAT_MSG_WHISPER_INFORM"]=true,
--	["CHAT_MSG_BN_WHISPER"]=true,
--	["CHAT_MSG_BN_WHISPER_INFORM"]=true,
--	["CHAT_MSG_BN_CONVERSATION"]=true,
	["CHAT_MSG_CHANNEL"]=true,
	["CHAT_MSG_INSTANCE_CHAT"]=true,
	["MAIL"]=true,
	["TWITCHBUTTON"]=true,
	["sliderX"]=-35,
	["sliderY"]=0,
	["MinimapPos"] = 45,
	["MINIMAPBUTTON"] = true,
	["FAVEMOTES"] = {true,true,true,true,true,true,true,true,true,true,
	true,true,true,true,true,true,true,true,true,true,
	true,true,true,true,true,true,true,true,}
  };
  
  local dropdown_options={
  
	[01]=  {"Asmongold","asmon1","asmon2","asmon3","asmon4","asmonC","asmonCD","asmonD","asmonDad","asmonDaze","asmonDegen","asmonE","asmonE1","asmonE2","asmonE3","asmonE4","asmonFiend","asmonG","asmonGASM","asmonGet","asmonHide","asmonL","asmonLFR","asmonLove","asmonLong1","asmonLong2","asmonLong3","asmonLong4","asmonM","asmonOcean","asmonOrc","asmonTar","asmonP","asmonPower","asmonPray","asmonPrime","asmonR","asmonREE","asmonSad","asmonStare","asmonTiger","asmonUH","asmonW","asmonWHAT","asmonWHATR","asmonWOW"},
	[02]=  {"Preachlfw","pgeBan","pgeBen","pgeBrian","pgeCheese","pgeChick","pgeClub","pgeCrisp","pgeDrama","pgeEdge","pgeEmma","pgeFish","pgeGhost","pgeHmm","pgeNem","pgeNoob","pgeOhno","pgeOhno2","pgePog","pgePug","pgeRay","pgeScience","pgeShame","pgeSherry"},
	[03]=  {"BTTV+FFZ 1","tooDank","4Head","ANELE","AngelThump","BibleThump","bUrself","BBona","BabyRage","BlessRNG","BloodTrail","ConcernDoge","DogeWitIt","ConcernFroge","cmonBrother","cmonBruh","cmonBrug","HYPERBRUG","WTFF","DansGame","DatSheffy","D:","DD:","FacePalm","EleGiggle","eShrug","FailFish","FrankerZ","GabeN","gachiGASM","gachiHYPER","HandsUp","GivePLZ","TakeNRG","haHAA","HeyGuys","HotPokket","HYPERLUL","LUL","LULW","MegaLUL","MingLUL","MingLee","Jebaited","KKomrade"},
	[04]=  {"BTTV+FFZ 2","Kappa","Kapp","KappaPride","Keepo","Kreygasm","MrDestructoid","NotLikeThis","NickyQ","OhMyDog","OpieOP","smileW","smileC","RSmile","RSmiling","RFrown","RGasp","RCool","RMeh","RWink","RWinkTongue","RTongue","RPatch","o_O","RTired","RHeart","PartyTime","PowerUpL","PowerUpR","ResidentSleeper","SeemsGood","SMOrc","Squid1","Squid2","Squid3","Squid4","SwiftRage","Thonk","HYPERTHONK","WideHard","TriHard","weSmart","WinnerWinner","WutFace","Wut","ZULUL","ZULOL"},
	[05]=  {"Custom 1","peepoVW","NeckBeard","Krug","Depresstiny","DestiSenpaii","Disgustiny","GODSTINY","HmmStiny","Klappa","LeRuse","jerryWhat",":blinking:","NOBULLY","NoTears","OverRustle","PEPE","REE","SURPRISE","SWEATSTINY","YEE","VoHiYo","AYAYA","bjornoVV","bjornoVVona","chupBro","chupDerp","chupHappy","StareBruh","Clap","cptfriHE","Del","ednasly","endANELE","endBomb","AMAZIN","pokiW","ThisIsFine"},
	[06]=  {"Custom 2","ANEBruh","endDawg","endFrench","endHarambe","endKyori","endNotLikeThis","HappyMerchant","HyperAngryMerchant","endRP","endTrump","FlipThis","fruitBug","LaurGasm","lockOmegatayys","marcithDerp","marcithMath","monkeyS","oldmorDim","PogCena","Popoga","mastahFloor","selyihHEY","SuicideThinking","BOGGED","Stonks","DogeKek","Joy2","LOLW","OMEGALOL","ZOINKS"},
	[07]=  {"Greekgodx","greekA","greekBrow","greekDiet","greekGirl","greekGordo","greekGweek","greekHard","greekJoy","greekKek","greekM","greekMlady","greekOi","greekP","greekHYPERP","greekThink","greekPVC","greekSad","greekSheep","greekSleeper","greekSquad","greekT","greekTilt","greekWC","greekWhy","greekWtf","greekYikes"},
	[08]=  {"nymn 1","nymn0","nymn1","nymn2","nymn3","nymn158","nymnA","nymnAww","nymnB","nymnBee","nymnBenis","nymnC","nymnCaptain","nymnCD","nymnCozy","nymnCREB","nymnCringe","nymnDab","nymnDeer","nymnE","nymnEU","nymnEZ","nymnFlag","nymnFlick","nymnG","nymnGasm","nymnGasp","nymnGnome","nymnGold","nymnGolden","nymnGun","nymnH","nymnHammer","nymnHmm","nymnHonk","nymnHydra","nymnJoy","nymnPog","nymnK","nymnKek","nymnKomrade","nymnL","nymnM","nymnNA","nymnNo","nymnNormie","nymnPains","nymnR"},
	[09]=  {"nymn 2","nymnRaffle","nymnSad","nymnScuffed","nymnSmart","nymnSmol","nymnZ","nymnSon","nymnSoy","nymnSpurdo","nymnThink","nymnU","nymnV","nymnW","nymnWhy","nymnXD","nymnY","nymnFEEDME","nymn2x","nymnBiggus","nymnBridge","nymnCC","nymnCry","nymnElf","nymnFood","nymnKing","nymnOkay","nymnP","nymnPuke","nymnRupert","nymnS","nymnSleeper","nymnSmug","nymnStrong","nymnTransparent"},
	[10]=  {"Drainerx","drxBrain","drxCS","drxD","drxSSJ","drxPog","drxDict","drxEyes","drxFE","drxED","drxFE1","drxED2","drxFEED","drxCri","drxGlad","drxGod","drxmonkaEYES","drxR","drxW","drxLit"},
	[11]=  {"Emojis",":poop:",":blush:",":flush:",":door:",":zap:",":gun:",":hand:",":pray:",":joy:",":yum:",":rolling_eyes:",":smiley:",":wink:",":smirk:",":tired:",":weary:",":thinking:",":dragon:",":muscle:",":ok_hand:",":point_right:",":point_left:",":writing_hand:",":book:",":clock:",":crab:",":shrimp:",":rage:",":wheelchair:",":eye:",":eyes:",":eggplant:",":sweat_drops:",":peach:",":tongue:",":heart:",":kiss:",":100:",":oof:",":mega:",":bell:",":crown:",":question:"},
	[12]=  {"Forsen 1","forsen1","forsen2","forsen3","forsen4","forsenAYAYA","forsenAYOYO","forsenBanned","forsenBee","forsenBlob","forsenBoys","forsenC","forsenCD","forsenChamp","forsenClown","forsenConnoisseur","forsenCool","forsenD","forsenDab","forsenDank","forsenDDK","forsenDED","forsenDiglett","forsenE","forsenEcardo","forsenEmote","forsenEmote2","forsenFajita","forsenFeels","forsenFur","forsenG","forsenGa","forsenGASM","forsenGrill","forsenGun","forsenH","forsenHappy","forsenHead","forsenHobo","forsenHorsen"},
	[13]=  {"Forsen 2","forsenIQ","forsenJoy","forsenK","forsenKek","forsenKnife","forsenKraken","forsenL","forsenLewd","forsenLicence","forsenLooted","forsenLUL","forsenM","forsenMald","forsenMoney","forsenMonkey","forsenNam","forsenO","forsenODO","forsenOG","forsenOP","forsenP","forsenPepe","forsenPog","forsenPosture","forsenPosture1","forsenPosture2","forsenPuke","forsenPuke2","forsenPuke3","forsenPuke4","forsenPuke5","forsenR","forsenReally","forsenRedSonic","forsenRP","forsenS","forsenSambool","forsenScoots"},
	[14]=  {"Forsen 3","forsenSheffy","forsenSith","forsenSkip","forsenSleeper","forsenSmile","forsenSS","forsenStein","forsenSwag","forsenT","forsenTILT","forsenTriggered","forsenW","forsenWC","forsenWeird","forsenWeird25","forsenWhat","forsenWhip","forsenWitch","forsenWTF","forsenWut","forsenX","forsenY","forsenYHD"},
	[15]=  {"AdmiralBahroo","rooAww","rooBlank","rooBless","rooBlind","rooBonk","rooBooli","rooBot","rooCarry","rooCop","rooCry","rooCult","rooD","rooDab","rooDerp","rooDevil","rooDisgust","rooEZ","rooGift","rooHappy","rooLick","rooLick2","rooLove","rooMurica","rooNap","rooSleepy","rooNom","rooPog","rooPs","rooREE","rooScheme","rooSellout","rooSmush","rooThink","rooTHIVV","rooVV","rooWhine","rooWut"},
	[16]=  {"VR 1","astrovrCry","astrovrRee","astrovrHi","CuteMelon","DrunkMelon","GaspMelon","HyperHappyMelon","HyperMelon","MelonGun","OwOMelon","RageMelon","ReeMelon","SadMelon","SweatMelon","tyrissBlush","tyrissBoop","tyrissComfy","tyrissDisappointed","tyrissGasp","tyrissGimme","tyrissGlare","tyrissHeadpat","tyrissHeart","tyrissHeartz","tyrissHi","tyrissHug","tyrissHyper","tyrissLul","tyrissLurk","tyrissPout","tyrissRee","tyrissRip","tyrissS","tyrissSad","tyrissSmug","tyrissSmugOwO","tyrissThink","tyrissVictory","ZevvyBlush"},
	[17]=  {"VR 2","radiantAYAYA","radiantBlush","radiantBomb","radiantBoop","radiantComfy","radiantCry","radiantCult","radiantCute","radiantEEEEE","radiantEvil","radiantGimme","radiantGun","radiantHmm","radiantISee","radiantJam","radiantKek","radiantLag","radiantLick","radiantLurk","radiantNom","radiantOmega","radiantOmegaOWO","radiantOwO","radiantPat","radiantPepega","radiantPog","radiantPout","radiantREE","radiantSalute","radiantScared","radiantShrug","radiantSip","radiantSmile","radiantSmug","radiantSnoze","radiantStare","radiantTOS","radiantWave","radiantWeird","02Yum","02Dab","02Stare",":HEH:"},
	[18]=  {"Pepe 1","EZ","FeelsAmazingMan","FeelsIncredibleMan","PepeBlyat","FeelsBetaMan","MALDD","FeelsBlushMan","FeelsTastyMan","FeelsCoolMan","FeelsCopterMan","FeelsCuteMan","FeelsPinkMan","PoggersHype","yikers","FeelsDrunkMan","PepeThumbsUp","FeelsEvilMan","NOP","UHM","YEP","FeelsGamerMan","FeelsSad","SadHug","FeelsMyFingerMan","FeelsStrongMan","monkaVirus",":think:","PepoHide","SMILERS","NOPERS","SMUGGERS","EVILSMILERS"},
	[19]=  {"Pepe 2","FeelsTiredAF","PepeHug","HYPERS","JanCarlo","maximumautism","meAutism","monkaGIGA","monkaThink","monkaYou","monkaHands","monkaMEGA","monkaOMEGA","monkaS","monkaX","monkaT","monkaTOS","NA","nanoMEGA","peep","PepeHands","KEKWHands","PepperHands","PepeL","PepePoint","PepeOK","PepeNotOK","PepoThink","monkaStab","PepoScience","RandomPepe","PepeKMS","FeelsSuicideMan","FeelsDeadMan","SucksMan","WOAW"},
	[20]=  {"Pepe 3","WeirdU","WeirdW","monkaU","monkaW","BadW","GoodW","OkayW","OkayLaugh","CringeW","TiredW","monkaPickle","PepeCozy","POOGERS","POGGIES","PepegaSad","PepegaHands","Weirdga","Okayga","Okayge","PepeFU","PepeCoffee","monkaStare","beanping","PepeScoots","GiggleHands","PepeHammer","PepeWizard","PepeBruh","PepeGang","FeelsRottenMan",":need:",":memes:",":drama:"},
	[21]=  {"Pepe 4","PepePoo","SadPepe","PepeXD","PepeMods","monakHmm","FeelsOakyMan","FeelsWiredMan","PeepHand","monakS","PepeHmm","FeelsBoredMan","PepeCry","PepeJAM","WeirdJAM","FeelsFatMan","FUARK","PepeHeart","PepeCoolStory","FeelsCringeMan","PepePants","PepeM","ppFootbol","PepeAyy","PepeRun","PepeLegs","PepeReach","noClown","LULERS","PepeDisgust","SmugPepe","OMEGAEZ","PepePains"},
	[22]=  {"peepo 1","peepoSalute","peepoCute","peepoLove","peepoPride","peepoWoW","peepoBlanket","peepoSenor","peepoStudy","peepoHmm","peepoSmile","peepoPee","peepoPoo","peepoTired","peepoSad","peepoS","peepoHug","peepoHugged","peepoAP","peepoEZ","peepoCool","peepoBeer","peepoFat","peepoHit","peepoFight","peepoPat","peepoSick","peepoBlush","peepoThink","peepoPlot","peepoWTF","peepoHide","peepoYes","peepoNo","peepoMaybe"},
	[23]=  {"peepo 2","peepoRain","peepoKnight","peepoPeek","peepoShrug","peepoWave","peepoKiss","peepaKiss","peepoHands","peepoSip","peepoPants","peepoNolegs","peepoLip","peepoFA","peepoFH","peepoKEKW","peepoCringe","peepoExit","peepoGun","peepoPoint","peepoNOO","peepoGlad","peepoTeddy","peepoUgh","peepoSuspect","peepoSuspicious","peepoOK","peepoBored","peepoReallyHappy","pillowJammies","peepoFriends"},
	[24]=  {"Suze4Mumes Life P1","beamBrah","beamB","CaptainSuze","peep420","JanCarlo2","mumes","peepoKnife","peepoStab","peepoH","PepeClown","SadHonk","ClownPain","ClownBall","SchubertSmile","PepeKing","peepoKing","peepoCrown","peepoWeirdCrown","PepeScience","peepoCozy","suzeOK","ANELELUL","bubby","FeelsCozyMan","miffs","peepoCheer","peepoCry","peepoDK","peepoMad","PepeBed","PepeChill","PepeCool","EZGiggle"},
	[25]=  {"Suze4Mumes Life P2","FeelsShadowMan","PepeRuski","PepeSoldier","PepeGiggle","PepeKingLove","PepeSpartan","PepeSuspect","peepoChef","peepoChrist","peepoSuze","PepeCop","potter","PepeStudy","suze4animals","PepeGod","PepeWave","PepeHacker","PepeWheels","peepOK","peepKing","PepeSoldier","FeelsDankMan","spit1","spit2","suze4know","GAmer","PepeSmurf","PauseChamp","PogChampius","WeirdChampius","PogO"},
	[26]=  {"Ren Custom P1","FLOPPERS","cmoN","OhISee","Poghurt","KEKW","KEKWeird","KEKSad","KEKL","BroKiss","pOg","Pogey","PogeyU","KKonaW","kkOna","DKKona","cmonEyes","TriKool","5Hard","TriPeek","TriEasy","TriGold","TriHardo","0Head","1Head","2Head","3Head","3Lass","4HEader","4Weird","4Shrug","4Mansion","5Head"},
	[27]=  {"Ren Custom P2","PogWarts","noxSorry","AMAZINGA","BaconEffect",":fluff:",":fluff2:","PATHETIC","TriHardS","HYPERDANSGAMEW","LULWW","MaN","NaM","VaN","WhiteKnight","BlackKnight","PikaWOW","Boomer","WeirdChamp","WutChamp","StareChamp","OkayChamp","MaldChamp","DisappointChamp","SadChamp","OldChamp","SillyChamp","LULChamp","CrazyChamp","WeirdBruh"},
	[28]=  {"Chromie", "Dedge", "CavemanBob","CcKekThas", "CcMile", "GusFring"},
};

  -- Call this in a mod's initialization to move the minimap button to its saved position (also used in its movement)
  -- ** do not call from the mod's OnLoad, VARIABLES_LOADED or later is fine. **
  function stripChars(str)
  local tableAccents = {}
    tableAccents["À"] = "A"
    tableAccents["Á"] = "A"
    tableAccents["Â"] = "A"
    tableAccents["Ã"] = "A"
    tableAccents["Ä"] = "A"
    tableAccents["Å"] = "A"
    tableAccents["Æ"] = "AE"
    tableAccents["Ç"] = "C"
    tableAccents["È"] = "E"
    tableAccents["É"] = "E"
    tableAccents["Ê"] = "E"
    tableAccents["Ë"] = "E"
    tableAccents["Ì"] = "I"
    tableAccents["Í"] = "I"
    tableAccents["Î"] = "I"
    tableAccents["Ï"] = "I"
    tableAccents["Ð"] = "D"
    tableAccents["Ñ"] = "N"
    tableAccents["Ò"] = "O"
    tableAccents["Ó"] = "O"
    tableAccents["Ô"] = "O"
    tableAccents["Õ"] = "O"
    tableAccents["Ö"] = "O"
    tableAccents["Ø"] = "O"
    tableAccents["Ù"] = "U"
    tableAccents["Ú"] = "U"
    tableAccents["Û"] = "U"
    tableAccents["Ü"] = "U"
    tableAccents["Ý"] = "Y"
    tableAccents["Þ"] = "P"
    tableAccents["ß"] = "s"
    tableAccents["à"] = "a"
    tableAccents["á"] = "a"
    tableAccents["â"] = "a"
    tableAccents["ã"] = "a"
    tableAccents["ä"] = "a"
    tableAccents["å"] = "a"
    tableAccents["æ"] = "ae"
    tableAccents["ç"] = "c"
    tableAccents["è"] = "e"
    tableAccents["é"] = "e"
    tableAccents["ê"] = "e"
    tableAccents["ë"] = "e"
    tableAccents["ì"] = "i"
    tableAccents["í"] = "i"
    tableAccents["î"] = "i"
    tableAccents["ï"] = "i"
    tableAccents["ð"] = "eth"
    tableAccents["ñ"] = "n"
    tableAccents["ò"] = "o"
    tableAccents["ó"] = "o"
    tableAccents["ô"] = "o"
    tableAccents["õ"] = "o"
    tableAccents["ö"] = "o"
    tableAccents["ø"] = "o"
    tableAccents["ù"] = "u"
    tableAccents["ú"] = "u"
    tableAccents["û"] = "u"
    tableAccents["ü"] = "u"
    tableAccents["ý"] = "y"
    tableAccents["þ"] = "p"
    tableAccents["ÿ"] = "y"
  local normalisedString = ''
  local normalisedString = str: gsub("[%z\1-\127\194-\244][\128-\191]*", tableAccents)
  return normalisedString
end
  

--Minimap Button
function Emoticons_OnEvent(self, event, ...)
    if (event == "ADDON_LOADED" and select(1, ...) == "TwitchEmotes") then
        if not LDBIcon then
            print("TwitchEmotes Error: LibDBIcon-1.0 not found!")
            return
        end
        
        for k, v in pairs(origsettings) do
            if k ~= "MinimapPos" and Emoticons_Settings[k] == nil then
                Emoticons_Settings[k] = v;
            end
        end
        
        Emoticons_UpdateChatFilters();
        
        -- Create the LDB object first
        local TwitchEmotesLDB = LDB:NewDataObject("TwitchEmotesIcon", {
            type = "launcher", 
            icon = "Interface\\AddOns\\TwitchEmotes\\Emotes\\1337.tga",
            tooltip = "Twitch Emotes",
            OnClick = function(frame, button) 
                if button == "LeftButton" then
                    Lib_ToggleDropDownMenu(1, nil, EmoticonChatFrameDropDown, frame, 0, 0);
                elseif button == "RightButton" then
                    InterfaceOptionsFrame_OpenToCategory(EmoticonsOptionsControlsPanel)
                end
            end,
            OnEnter = function(frame)
                GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMLEFT")
                GameTooltip:AddLine("Twitch Emotes")
                GameTooltip:AddLine("|cffeda55fClick:|r Show Emotes")
                GameTooltip:AddLine("|cffeda55fRight-Click:|r Options") 
                GameTooltip:Show()
            end,
            OnLeave = function(frame)
                GameTooltip:Hide()
            end
        })
        
        -- Then register with LibDBIcon, using Emoticons_Settings as the db
        LDBIcon:Register("TwitchEmotesIcon", TwitchEmotesLDB, Emoticons_Settings)
        
        -- Update visibility based on settings
        if not Emoticons_Settings["MINIMAPBUTTON"] then
            LDBIcon:Hide("TwitchEmotesIcon")
        else
            LDBIcon:Show("TwitchEmotesIcon")
        end
    end
end
  function ItemTextPageText.SetText(self,msg,...)
	if(Emoticons_Settings["MAIL"] and msg ~= nil) then
	  msg = Emoticons_RunReplacement(msg);
	end
	ItemTextFrameSetText(self,msg,...);
  end
  
  local OpenMailBodyTextSetText = OpenMailBodyText.SetText;
  function OpenMailBodyText.SetText(self,msg,...)
	if(Emoticons_Settings["MAIL"] and msg ~= nil) then
	  msg = Emoticons_RunReplacement(msg);
	end
	OpenMailBodyTextSetText(self,msg,...);
  end
  
  function Emoticons_LoadChatFrameDropdown(self, level, menuList)
	local info          = Lib_UIDropDownMenu_CreateInfo();
	if (level or 1) == 1 then
	  for k,v in ipairs(dropdown_options) do
		if (Emoticons_Settings["FAVEMOTES"][k]) then
		  info.hasArrow = true;
		  info.text = v[1];
		  info.value = false;
		  info.menuList = k;
		  info.notCheckable = true;
		  Lib_UIDropDownMenu_AddButton(info);
		end
	  end
	else
	  first=true;
	  for ke,va in ipairs(dropdown_options[menuList]) do
		if (first) then
		  first = false;
		else
		  --print(ke.." "..va);
		  info.text       = "|T"..defaultpack[va].."|t "..va;
		  info.value      = va;
		  info.func = Emoticons_Dropdown_OnClick;
		  info.notCheckable = true;
		  Lib_UIDropDownMenu_AddButton(info, level);
		end
	  end
  
	end
  end
  
  function Emoticons_Dropdown_OnClick(self,arg1,arg2,arg3)
	if(ACTIVE_CHAT_EDIT_BOX ~= nil) then
	  ACTIVE_CHAT_EDIT_BOX:Insert(self.value);
	end
  end
  
  function Emoticons_MailFrame_OnChar(self)
	local msg = self:GetText();
	if(Emoticons_Eyecandy and Emoticons_Settings["MAIL"] and string.sub(msg,1,1) ~= "/") then
	  self:SetText(Emoticons_RunReplacement(msg));
	end
  end
  
  local sm = SendMail;
  function SendMail(recipient,subject,msg,...)
	if(Emoticons_Eyecandy and Emoticons_Settings["MAIL"]) then
	  msg = Emoticons_Deformat(msg);
	end
	sm(recipient,subject,msg,...);
  end
  
  
  
  local scm = SendChatMessage;
  function SendChatMessage(msg,...)
	if(Emoticons_Eyecandy) then
	  msg = Emoticons_Deformat(msg);
	end
	scm(msg,...);
  end
  
  local bnsw = BNSendWhisper;
  function BNSendWhisper(id,msg,...)
	if(Emoticons_Eyecandy) then
	  msg = Emoticons_Deformat(msg);
	end
	bnsw(id,msg,...);
  end


  
  function Emoticons_UpdateChatFilters()
	for k,v in pairs(Emoticons_Settings) do
	  if(k ~= "MAIL" and k ~= "TWITCHBUTTON" and k ~= "sliderX" and k ~= "sliderY") then
		if(v) then
		  ChatFrame_AddMessageEventFilter(k,Emoticons_MessageFilter)
		else
		  ChatFrame_RemoveMessageEventFilter(k,Emoticons_MessageFilter);
		end
	  end
	end
  end
  
  function Emoticons_MessageFilter(self, event, msg, ...)
  
	msg = Emoticons_RunReplacement(msg);
  
	return false, msg, ...
  end
  
  function Emoticons_OptionsWindow_OnShow(self)
	for k,v in pairs(Emoticons_Settings) do
	  local cb = getglobal("EmoticonsOptionsControlsPanel"..k);
  
	  if(cb ~= nil) then
		cb:SetChecked(Emoticons_Settings[k]);
	  end
	end
	--SliderXText:SetText("Position X: "..Emoticons_Settings["sliderX"]);
	--SliderYText:SetText("Position Y: "..Emoticons_Settings["sliderY"]);
	--EmoticonsOptionsControlsPanelEyecandy:SetChecked(Emoticons_Eyecandy);
  
	favall = CreateFrame("CheckButton","favall_GlobalName",EmoticonsOptionsControlsPanel,"UIRadioButtonTemplate" );
	--getglobal("favall_GlobalName"):SetChecked(false);
	favall:SetPoint("TOPLEFT", 17,-230);
	getglobal(favall:GetName().."Text"):SetText("Check all");
	favall.tooltip = "Check all boxes below.";
	getglobal("favall_GlobalName"):SetScript("OnClick",
	function(self)
--	  if (self:GetChecked()) then
		if (getglobal("favnone_GlobalName"):GetChecked() == true) then
		  getglobal("favnone_GlobalName"):SetChecked(false);
		end
		self:SetChecked(true);
		for n,m in ipairs(Emoticons_Settings["FAVEMOTES"]) do
		  Emoticons_Settings["FAVEMOTES"][n] = true;
		  --print("favCheckButton_"..dropdown_options[n][1]);
		  getglobal("favCheckButton_"..dropdown_options[n][1]):SetChecked(true);
		end
--	  else
		--Emoticons_Settings["FAVEMOTES"][a] = false;
--	  end
	end
	);
  
	favnone = CreateFrame("CheckButton", "favnone_GlobalName", favall_GlobalName,"UIRadioButtonTemplate" );
	--getglobal("favnone_GlobalName"):SetChecked(false);
	favnone:SetPoint("TOPLEFT", 110,0);
	getglobal(favnone:GetName().."Text"):SetText("Uncheck all");
	favnone.tooltip = "Uncheck all boxes below.";
	getglobal("favnone_GlobalName"):SetScript("OnClick",
	function(self)
	  -- Critical fix: Remove self-checking condition which was preventing visual update
	  -- if (self:GetChecked()) then
	  if (getglobal("favall_GlobalName"):GetChecked() == true) then
		getglobal("favall_GlobalName"):SetChecked(false);
	  end
	  self:SetChecked(true);
	  for n,m in ipairs(Emoticons_Settings["FAVEMOTES"]) do
		Emoticons_Settings["FAVEMOTES"][n] = false;
		-- Directly set the visual state without checking current state
		getglobal("favCheckButton_"..dropdown_options[n][1]):SetChecked(false);
	  end
	  -- else
	  --   --Emoticons_Settings["FAVEMOTES"][a] = false;
	  -- end
	end
	);
  
	favframe = CreateFrame("Frame", "favframe_GlobalName", favall_GlobalName);
	favframe:SetPoint("TOPLEFT", 0,-24);
	favframe:SetSize(590,175);
  
	favframe:SetBackdrop({bgFile="Interface\\ChatFrame\\ChatFrameBackground",edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",tile=true,tileSize=5,edgeSize= 2,});
	favframe:SetBackdropColor(0, 0, 0,0.5);
	first=true;
	itemcnt=0
	for a,c in ipairs(dropdown_options) do
  
	  if first then
		favCheckButton = CreateFrame("CheckButton", "favCheckButton_"..c[1], favframe_GlobalName, "ChatConfigCheckButtonTemplate");
		first=false;
		favCheckButton:SetPoint("TOPLEFT", 0, 3);
	  else
		--favbuttonlist=loadstring("favCheckButton_"..anchor);
  
		favCheckButton = CreateFrame("CheckButton", "favCheckButton_"..c[1], favframe_GlobalName, "ChatConfigCheckButtonTemplate");
		favCheckButton:SetParent("favCheckButton_"..anchor);
		if ((itemcnt % 10) ~= 0) then
		  favCheckButton:SetPoint("TOPLEFT", 0, -16);
		else
		  favCheckButton:SetPoint("TOPLEFT", 110, 9*16);
		end
	  end
	  itemcnt=itemcnt+1;
	  anchor=c[1];
  
	  --code=[[print("favCheckButton_"..b[1]..":SetText(b[1])")]];
  
	  getglobal(favCheckButton:GetName().."Text"):SetText(c[1]);
	  if (getglobal("favCheckButton_"..c[1]):GetChecked() ~= Emoticons_Settings["FAVEMOTES"][a]) then
		getglobal("favCheckButton_"..c[1]):SetChecked(Emoticons_Settings["FAVEMOTES"][a]);
	  end
	  favCheckButton.tooltip = "Checked boxes will show in the dropdownlist.";
	  favCheckButton:SetScript("OnClick",
	  function(self)
		if (self:GetChecked()) then
		  Emoticons_Settings["FAVEMOTES"][a] = true;
		else
		  Emoticons_Settings["FAVEMOTES"][a] = false;
		end
	  end
	  );
	end
  end
  
  function Emoticons_Deformat(msg)
	for k,v in pairs(emoticons) do
	  msg=string.gsub(msg,"|T"..defaultpack[k].."%:28%:28|t",v);
	end
	return msg;
  end
  
  function Emoticons_RunReplacement(msg)
  
	--remember to watch out for |H|h|h's
  
	local outstr = "";
	local origlen = string.len(msg);
	local startpos = 1;
	local endpos;
  
	while(startpos <= origlen) do
	  endpos = origlen;
	  local pos = string.find(msg,"|H",startpos,true);
	  if(pos ~= nil) then
		endpos = pos;
	  end
	  outstr = outstr .. Emoticons_InsertEmoticons(string.sub(msg,startpos,endpos)); --run replacement on this bit
	  startpos = endpos + 1;
	  if(pos ~= nil) then
		endpos = string.find(msg,"|h",startpos,true);
		if(endpos == nil) then
		  endpos = origlen;
		end
		if(startpos < endpos) then
		  outstr = outstr .. string.sub(msg,startpos,endpos); --don't run replacement on this bit
		  startpos = endpos + 1;
		end
	  end
	end
  
	return outstr;
  end
  
  function Emoticons_SetEyecandy(state)
	if(state) then
	  Emoticons_Eyecandy = true;
	  if(ACTIVE_CHAT_EDIT_BOX~=nil) then
		ACTIVE_CHAT_EDIT_BOX:SetText(Emoticons_RunReplacement(ACTIVE_CHAT_EDIT_BOX:GetText()));
	  end
	else
	  Emoticons_Eyecandy = false;
	  if(ACTIVE_CHAT_EDIT_BOX~=nil) then
		ACTIVE_CHAT_EDIT_BOX:SetText(Emoticons_Deformat(ACTIVE_CHAT_EDIT_BOX:GetText()));
	  end
	end
  end
  
  function Emoticons_SetMinimapButton(state)
    if state then state = true else state = false end 
    
    Emoticons_Settings["MINIMAPBUTTON"] = state; 

    if LDBIcon then 
        if state then
            LDBIcon:Show("TwitchEmotesIcon")
        else
            LDBIcon:Hide("TwitchEmotesIcon")
        end
    else
        print("TwitchEmotes Error: LibDBIcon not available when trying to set minimap button visibility.")
    end
end
  
  
  function Emoticons_InsertEmoticons(msg)
  	--print(table.getn(words)) ;
	for k,v in pairs(emoticons) do
	  if (string.find(msg,k,1,true)) then
		msg = string.gsub(msg,"(%s)"..k.."(%s)","%1|T"..defaultpack[v].."|t%2");
		msg = string.gsub(msg,"(%s)"..k.."$","%1|T"..defaultpack[v].."|t");
		msg = string.gsub(msg,"^"..k.."(%s)","|T"..defaultpack[v].."|t%1");
		msg = string.gsub(msg,"^"..k.."$","|T"..defaultpack[v].."|t");
		msg = string.gsub(msg,"(%s)"..k.."(%c)","%1|T"..defaultpack[v].."|t%2");
		msg = string.gsub(msg,"(%s)"..k.."(%s)","%1|T"..defaultpack[v].."|t%2");
	  end
	end

	return msg;
  end
  
  function Emoticons_SetType(chattype,state)
	if(state) then
	  state = true;
	else
	  state = false;
	end
	if(chattype == "CHAT_MSG_RAID") then
	  Emoticons_Settings["CHAT_MSG_RAID_LEADER"] = state;
	  Emoticons_Settings["CHAT_MSG_RAID_WARNING"] = state;
	end
	if(chattype == "CHAT_MSG_PARTY") then
	  Emoticons_Settings["CHAT_MSG_PARTY_LEADER"] = state;
	  Emoticons_Settings["CHAT_MSG_PARTY_GUIDE"] = state;
	end
	if(chattype == "CHAT_MSG_WHISPER") then
	  Emoticons_Settings["CHAT_MSG_WHISPER_INFORM"] = state;
	end
	if(chattype == "CHAT_MSG_BATTLEGROUND") then
	  Emoticons_Settings["CHAT_MSG_BATTLEGROUND_LEADER"] = state;
	end
--	if(chattype == "CHAT_MSG_BN_WHISPER") then
--	  Emoticons_Settings["CHAT_MSG_BN_WHISPER_INFORM"] = state;
--	end
  
	Emoticons_Settings[chattype] = state;
	Emoticons_UpdateChatFilters();
  end
  