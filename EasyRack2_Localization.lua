function EasyRack2_GetLocaleText(locale)
local L
if locale == "koKR" then
--
--	koKR locale text
--
L = {
	["STATUS_STRIP"] = "해제" ,
	["STATUS_EQUIP"] = "장비" ,
	["STATUS_WEAPON"] = "무기" ,

	["BIND_SLIPOFF"] = "장비 해제" ,
	["BIND_EQUIPSET"] = "번 장비" ,
	["DIALOGUE_SET"] = "장비 이름을 입력하세요" ,
	["MENU_SET_TITLE"] = "관리" ,
	["MENU_SET_TOOLTIP_TITLE"] = "장비 관리" ,
	["MENU_SET_TOOLTIP_TEXT"] = "클릭: 등록\nShift + 클릭: 삭제" ,
	["MENU_SET_EMPTYSLOT"] = "새로 등록" ,

	["MENU_SET_SAVE_1"] = "[" ,
	["MENU_SET_SAVE_2"] = "] 셋을 " ,
	["MENU_SET_SAVE_3"] = "번째로 저장합니다." ,
	["MENU_SET_DELETE_1"] = "[" ,
	["MENU_SET_DELETE_2"] = "] 장비를 삭제합니다." ,

	["MENU_EQUIP_TITLE"] = "착용" ,
	["MENU_EQUIP_SLIPOFF"] = "장비 해제" ,
	["MENU_EQUIP_EMPTYSLOT"] = "사용 불가" ,

	["EQUIP_EMPTYSLOT_1"] = "[" ,
	["EQUIP_EMPTYSLOT_2"] = "] 장비 셋이 없습니다." ,
	["EQUIP_EQUIP_1"] = "[" ,
	["EQUIP_EQUIP_2"] = "] 장비로 변경합니다." ,
	["EQUIP_INCOMBAT"] = "" ,
	["EQUIP_FAILED"] = "장비 변경 실패" ,
	["EQUIP_SLIPOFF"] = "내구도가 있는 모든 장비를 해제합니다." ,

	["INCOMBAT_WARN_1"] = "전투중입니다. 전투가 풀리면 시도해 주세요." ,
	["INCOMBAT_WARN_2"] = "그 이후에는 전투중에도 무기해제가 가능합니다." ,
	["SLIPOFF_ONEMORE_1"] = "장비 해제를 한 번 더 하면 [Slip Off] 셋이 생성됩니다." ,
	["SLIPOFF_ONEMORE_2"] = "[Slip Off] 셋은 전투 중 장비 해제를 위해 예약된 셋입니다." ,
	["SLIPOFF_ONEMORE_3"] = "가방에 공간이 충분하지 않으면 오작동할 수 있습니다. (9~11칸 필요)" ,
	["SLIPOFF_RESERVED"] = "장비관리자의 [Slip Off] 셋은 예약됩니다." ,
	["SLIPOFF_RESERVE_FAILED_1"] = "장비관리자가에 빈 공간이 없어서 등록 불가." ,
	["SLIPOFF_RESERVE_FAILED_1"] = "" ,
}
else
--
--	For other locales
--
L = {
	["STATUS_STRIP"] = "Strip" ,
	["STATUS_EQUIP"] = "Equip" ,
	["STATUS_WEAPON"] = "Weapon" ,

	["BIND_SLIPOFF"] = "Slip off" ,
	["BIND_EQUIPSET"] = " SLOT" ,
	["DIALOGUE_SET"] = "Input name of Equipment Set" ,
	["MENU_SET_TITLE"] = "Manage" ,
	["MENU_SET_TOOLTIP_TITLE"] = "Equip Manage" ,
	["MENU_SET_TOOLTIP_TEXT"] = "Click to register\nShift click to remove" ,
	["MENU_SET_EMPTYSLOT"] = "Register" ,

	["DIALOGUE_DELETE_1"] = "Delete equipment set [" ,
	["DIALOGUE_DELETE_2"] = "]" ,
	["MENU_SET_SAVE_1"] = "Saved [" ,
	["MENU_SET_SAVE_2"] = "] set on slot " ,
	["MENU_SET_SAVE_3"] = "" ,

	["MENU_EQUIP_TITLE"] = "Equip" ,
	["MENU_EQUIP_SLIPOFF"] = "Slip off" ,
	["MENU_EQUIP_EMPTYSLOT"] = "Empty" ,

	["EQUIP_EMPTYSLOT_1"] = "Slot [" ,
	["EQUIP_EMPTYSLOT_2"] = "] is Empty" ,
	["EQUIP_EQUIP_1"] = "Equipped Set [" ,
	["EQUIP_EQUIP_2"] = "]" ,
	["EQUIP_INCOMBAT"] = "" ,
	["EQUIP_FAILED"] = "Failed to equip set" ,
	["EQUIP_SLIPOFF"] = "Put off all equipments with durability" ,

	["INCOMBAT_WARN_1"] = "IN COMBAT. Try after combat ends" ,
	["INCOMBAT_WARN_2"] = "And then, you can SLIP OFF during you're in combat" ,
	["SLIPOFF_ONEMORE_1"] = "Do SLIP-OFF 1 more time then [Slip Off] set would be created." ,
	["SLIPOFF_ONEMORE_2"] = "[Slip Off] set is RESERVED to SLIP-OFF during combat." ,
	["SLIPOFF_ONEMORE_3"] = "No guarantee if there aren't enough free slots in your bags (need 9~11slots)" ,
	["SLIPOFF_RESERVED"] = "[Slip Off] set has been RESERVED" ,
	["SLIPOFF_RESERVE_FAILED_1"] = "There is not enough slot in Equipment Manager" ,
	["SLIPOFF_RESERVE_FAILED_1"] = "" ,
}
end
return L

end
