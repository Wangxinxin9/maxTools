try(destroyDialog boxManRollout )catch()
rollout boxManRollout "Box Man"
(
    --editText batchMax_et "文字: " align:#left
	spinner boxScl_spn "Box缩放系数:"  type:#float range:[0.1, 1.0, 0.95] scale:0.01 align:#left toolTip:"系数越大,Box之间的间隙越小"
    button theBtn "创建" width:150 height:50 toolTip:"选择骨骼创建Box"
	button theBtnDel "删除" width:150 height:25 toolTip:"删除所有Box"
	button theBtnMax "+" width:150 height:25 toolTip:"放大Box"
	button theBtnMin "-" width:150 height:25 toolTip:"缩小Box"


	local newObjs = #()
	fn fnCreateBoxBody =
	(
		local boxObjs = #()
		local bip001s = #(#(),#())
		--local num = 0.9
		local num = boxScl_spn.value
		local sels = for i in selection where ((iskindof i.baseObject Biped_Object or iskindof i.baseObject BoneGeometry) and (findString i.name "Twist" == undefined)) collect i
		undo on(
			for i in sels do
			(
				--bip骨骼设置为标准骨骼
				if iskindof i.baseobject Biped_Object do(
					bip001 = i.controller.rootNode
					if (findItem bip001s[1] bip001) == 0 then(
						append bip001s[1] bip001
						append bip001s[2] bip001.controller.bodyType
						if bip001.controller.bodyType != 3 then(
							bip001.controller.bodyType = 3
						)
					)
				)

				c = snapshot i
				c.transform = matrix3 1
				bb = c.max - c.min

				local boxw = bb[1]
				local boxl = bb[2]
				local boxh = bb[3]
				--b = box width:bb[1] length:bb[2] height:bb[3]
				if iskindof i.baseobject Biped_Object do(
					local nums = #(3,4,7,8)			--手指脚趾link
					local bipLinkID = biped.getIdLink i
					if findItem nums bipLinkID[1] == 0 do(
						boxl = 3.0
						boxh = 3.0
						if bipLinkID == [12,1] do(boxw = 4.12; boxl = 4.12; boxh = 4.12)	--12盆骨
						if bipLinkID == [13,1] do(boxw = 3.12; boxl = 3.12; boxh = 3.12)	--13质心
					)	
				)
				b = box width:boxw length:boxl height:boxh
				b.name = i.name + "_box"
				b.wirecolor = i.wirecolor
				CenterPivot b
				if (boxw != 3.12 and boxw != 4.12) do (
					b.pivot.x = b.pivot.x - b.width/2
					b.width = boxw * num
				)
				b.transform = i.transform
				convertToPoly b
				append boxObjs b
				delete c
				--addmodifier b (Edit_Poly())
			)

			for b in 1 to bip001s[1].count do(
				if bip001s[1][b].controller.bodyType != bip001s[2][b] do(
					bip001s[1][b].controller.bodyType = bip001s[2][b]
				)
			)

			--设置层级
			for i in 1 to boxObjs.count do(
				if isValidNode sels[i].parent do(
					local pItem = findItem sels sels[i].parent
					if pItem != 0 do(
						boxObjs[i].parent = boxObjs[pItem]
						boxObjs[i].skinpose.setSkinPose()
					)
				)
			)

			if boxObjs.count > 0 do(
				if selectionSets["BoxMan"] != undefined then(
					local oldBoxMan = for i in selectionSets["BoxMan"] collect i
					deleteItem selectionSets "BoxMan"
					join oldBoxMan boxObjs
					selectionSets["BoxMan"] = oldBoxMan
				)else(
					selectionSets["BoxMan"] = boxObjs
				)
			)

			select boxObjs
		)
		boxObjs
	)

    on theBtn pressed do
    (
        newObjs = fnCreateBoxBody()
    )

	on theBtnDel pressed do
	(
		if selectionSets["BoxMan"] == undefined do return false
		delete selectionSets["BoxMan"]
		deleteItem  selectionSets "BoxMan"
	)

	on theBtnMax pressed do
    (
		if selectionSets["BoxMan"] == undefined do return false
		local newBoxs = for i in selectionSets["BoxMan"] collect i
		local pObjs = #()
		for i in newBoxs do(
			if isValidNode i do(
				append pObjs i.parent
				i.parent = undefined
			)
		)
        for i in newBoxs do(
			if isValidNode i do(
				in coordsys local scale i [1, 1.1, 1.1]
				resetscale i
			)
		)
		for i in 1 to newBoxs.count do(
			if isValidNode newBoxs[i] do(
				newBoxs[i].parent = pObjs[i]
			)
		)
    )

	on theBtnMin pressed do
    (
		if selectionSets["BoxMan"] == undefined do return false
		local newBoxs = for i in selectionSets["BoxMan"] collect i
		local pObjs = #()
		for i in newBoxs do(
			if isValidNode i do(
				append pObjs i.parent
				i.parent = undefined
			)
		)
        for i in newBoxs do(
			if isValidNode i do(
				in coordsys local scale i [1, .9, .9]
				resetscale i
			)
		)
		for i in 1 to newBoxs.count do(
			if isValidNode newBoxs[i] do(
				newBoxs[i].parent = pObjs[i]
			)
		)
    )
)
createDialog boxManRollout