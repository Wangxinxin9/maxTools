/*//////////   SCRIPT:   Store & Restore Views v1.5   //////////*/
/*//////////   WRITTEN BY:   Branko Zivkovic   //////////*/
/*//////////   EMAIL:   barigazy@hotmail.com   //////////*/	
try(destroyDialog ::bga_srvRoll)catch()
rollout bga_srvRoll "视图列表"
(
	global vpData = Dictionary #string
	local views = #(#view_persp_user, #view_iso_user, #view_top, #view_bottom, #view_left, #view_right, #view_front, #view_back, #view_spot, #view_camera)
	struct vpdStruct (vpType = #view_none, vpGroupType = #user, vpStartCoord = [0,0,0], vpEndCoord = [0,0,0], vpVS = [0,0], vpFOV = 0, vpFD = 0, vpTM = undefined, vpNode = undefined)
	fn checkVT views vt = 
	(
		local idx = (findItem views vt)
		case of
		(
			(idx > 0 and idx < 3): #user
			(idx > 2 and idx < 9): #ortho
			(idx > 8): #camlight
			(idx == 0):  undefined
		)
	)
	fn minmaxSwap p3min p3max =
	(
		if p3min.x > p3max.x do swap p3min.x p3max.x
		if p3min.y > p3max.y do swap p3min.y p3max.y
		if p3min.z > p3max.z do swap p3min.z p3max.z
		#(p3min, p3max)
	)
	fn collectVPD supportedViews:views mark: =
	(
		local vpd = vpdStruct()
		local bounds = minmaxSwap ((MapScreenToView [0,0] 0) * Inverse(getViewTM())) ((MapScreenToView (GetViewSize()) 0) * Inverse(getViewTM()))
		vpd.vpType = viewport.getType()
		vpd.vpGroupType = checkVT supportedViews vpd.vpType
		vpd.vpStartCoord = bounds[1] 
		vpd.vpEndCoord = bounds[2] 
		vpd.vpVS = GetViewSize()
		vpd.vpFOV = getViewFOV()
		vpd.vpFD = viewport.getFocalDistance()
		vpd.vpTM = viewport.getTM()
		vpd.vpNode = if (node = viewport.getCamera()) != undefined do (setUserProp node "vpdProp" mark ; node)
		vpd
	)
	fn restoreViewport vpd =
	(
		local deadData = off
		viewport.SetType vpd.vpType
		case vpd.vpGroupType of
		(
			#user:
			(
				viewport.setTM vpd.vpTM
				if vpd.vpType == #view_persp_user then (viewport.SetFOV vpd.vpFOV ; viewport.SetFocalDistance vpd.vpFD)
				else (viewport.ZoomToBounds off vpd.vpStartCoord vpd.vpEndCoord ; viewport.zoom (vpd.vpFOV/(viewport.getFOV())))
			)
			#ortho:
			(
				viewport.ZoomToBounds off vpd.vpStartCoord vpd.vpEndCoord
				viewport.zoom (vpd.vpFOV/(viewport.getFOV()))
			)
			#camlight: (if isValidNode vpd.vpNode and viewport.canSetToViewport vpd.vpNode then viewport.setCamera vpd.vpNode else deadData = on)
		) ; completeredraw() ; deadData
	)
	fn p2Top3 value = (point3 value.x value.y 0)
	fn p3Top2 value = (point2 value.x value.y)
	fn checkRN = isProperty rootNode #vpKeys
	fn checkDICT dict = (dict.keys.count != 0)
	fn loadVPD = if (checkDICT()) then rootNode.vpData.keys else #()
	fn addCA = 
	(
		if not (checkRN()) do 
		(
			local vpdCA = attributes viewportDataAtt version:17 attribID:(genClassID returnValue:on) 
			(
				parameters vdp
				(
					vpRollPos type:#point2 default:[0,0]
					vpKeys type:#stringTab tabSizeVariable:on
					vpTypes type:#stringTab tabSizeVariable:on
					vpGroupTypes type:#stringTab tabSizeVariable:on
					vpStartCoords type:#point3Tab tabSizeVariable:on
					vpEndCoords type:#point3Tab tabSizeVariable:on
					vpVSs type:#point3Tab tabSizeVariable:on
					vpFOVs type:#floatTab tabSizeVariable:on
					vpFDs type:#floatTab tabSizeVariable:on
					vpTMs type:#matrix3Tab tabSizeVariable:on
					vpNodes type:#nodeTab tabSizeVariable:on
				)
			)
			custAttributes.add rootNode vpdCA
		)
	)
	fn deleteCA = if (checkRN()) do
	(
		local caVPD
		if (c = custAttributes.count rootNode) > 0 do (for i = 1 to c where (vpdCA = custAttributes.getdef rootNode i).name == #viewportDataAtt do (caVPD = vpdCA))
		if isKindOf caVPD AttributeDef do custAttributes.delete rootNode caVPD
	)	
	fn findNode nodes ks: = (for n in nodes where (getUserProp n "vpdProp" == ks) collect n)[1]
	fn freeVPData = 
	(
		rootNode.vpKeys = #() ; rootNode.vpTypes = #() ; rootNode.vpGroupTypes = #() ; rootNode.vpStartCoords = #() ; rootNode.vpEndCoords = #()
		rootNode.vpVSs = #() ; rootNode.vpFOVs = #() ; rootNode.vpFDs = #() ; rootNode.vpTMs = #() ; rootNode.vpNodes = #()
	)
	fn getVPData dict =
	(
		free dict
		for k = 1 to rootNode.vpKeys.count do PutDictValue dict rootNode.vpKeys[k] \
		(
			vpd = vpdStruct()
			vpd.vpType = rootNode.vpTypes[k] as name
			vpd.vpGroupType = rootNode.vpGroupTypes[k] as name
			vpd.vpStartCoord = rootNode.vpStartCoords[k] 
			vpd.vpEndCoord = rootNode.vpEndCoords[k] 
			vpd.vpVS = p3TOp2 rootNode.vpVSs[k]
			vpd.vpFOV = rootNode.vpFOVs[k]
			vpd.vpFD = rootNode.vpFDs[k]
			vpd.vpTM = rootNode.vpTMs[k]
			if vpd.vpGroupType == #camlight and isValidNode (node = findNode rootNode.vpNodes ks:rootNode.vpKeys[k]) do (vpd.vpNode = node) ; vpd
		) ; dict
	)
	fn setVPData dict =
	(
		freeVPData() ; rootNode.vpRollPos = getDialogPos bga_srvRoll
		for k in dict.keys do
		(
			vpd = dict[k]
			append rootNode.vpKeys k
			append rootNode.vpTypes (vpd.vpType as string)
			append rootNode.vpGroupTypes (vpd.vpGroupType as string)
			append rootNode.vpStartCoords vpd.vpStartCoord
			append rootNode.vpEndCoords vpd.vpEndCoord
			append rootNode.vpVSs (p2TOp3 vpd.vpVS)
			append rootNode.vpFOVs vpd.vpFOV
			append rootNode.vpFDs vpd.vpFD
			append rootNode.vpTMs vpd.vpTM
			if vpd.vpGroupType == #camlight and isValidNode vpd.vpNode and (getUserProp vpd.vpNode "vpdProp" == k) do append rootNode.vpNodes vpd.vpNode
		)
	)	

	button btn_add "添加" pos:[5,5] width:72 height:21 tooltip:"存储或更新视图"
	button btn_delete "移除" pos:[80,5] width:72 height:21 tooltip:"LMB - 从列表中移除所选视图\nRMB - 移除列表所有视图"
	combobox cbx_views "" pos:[5,30] width:148 height:15 selection:0
	on btn_add pressed do if (vt = viewport.getType()) == undefined then messageBox "不支持此视图" title:"警告" beep:off else
	(
		if cbx_views.text != "" then
		(
			if not (checkRN()) do addCA()
			value = vpData.keys.count
			if (checkVT views vt) != undefined do PutDictValue vpData cbx_views.text (collectVPD mark:cbx_views.text)
			if value < vpData.keys.count do cbx_views.items = sort (GetDictKeys vpData)
			cbx_views.selection = 0 ; setVPData vpData
		)else(messageBox "储存视图名称不能为空!" title:"警告")
	)
	on btn_delete pressed do if (checkDICT vpData and cbx_views.text != "") do
	(
		if (vpd = GetDictValue vpData cbx_views.text).vpGroupType == #camlight do (if isValidNode vpd.vpNode do setUserProp vpd.vpNode "vpdProp" "")
		RemoveDictValue vpData cbx_views.text ; cbx_views.selection = 0
		if (checkDICT vpData) then (cbx_views.items = sort (GetDictKeys vpData) ; setVPData vpData)
		else (freeVPData() ; free vpData ; cbx_views.items = #())
	)
	on btn_delete rightclick do if (checkDICT vpData) do 
	(
		for k in vpData.keys do
		(
			vpd = GetDictValue vpData k
			if vpd.vpGroupType == #camlight and isValidNode vpd.vpNode do setUserProp vpd.vpNode "vpdProp" ""
		)
		freeVPData() ; free vpData ; cbx_views.items = #() ; cbx_views.selection = 0
	)
	on cbx_views doubleClicked idx do if (checkDICT vpData) do
	(
		if (HasDictValue vpData cbx_views.items[idx]) do 
		(
			if restoreViewport (GetDictValue vpData cbx_views.items[idx]) do btn_delete.pressed()
		)
	)
	on bga_srvRoll open do 
	(
		if (checkRN()) do 
		(
			setDialogPos bga_srvRoll rootNode.vpRollPos ; getVPData vpData ; cbx_views.items = sort (GetDictKeys vpData)
		)
	)
	on bga_srvRoll moved pos do if (checkRN()) do rootNode.vpRollPos = pos
)
createDialog bga_srvRoll 158 245 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)