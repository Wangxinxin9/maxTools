--by Mark Blosser mjblosser@gmail.com
--Description:  Will draw a small axis tripod for all visible objects which can be toggled on and off, with option to set the axis size
-- Inspired by scripts from from Borislav 'Bobo' Petrov and Martin Breidt 

try(destroyDialog dialog_showPivots)catch()
rollout dialog_showPivots "显示对象轴"
(
	checkButton cb_pivtoggle "显示切换" checked:false offset:[0,5] width:85 across:2
	checkbox sliptGrptoSel_ck "仅选中" width:50 align:#right offset:[0,8]
	spinner ax_len "轴长:"range:[0.1,9999,3] type:#float  align:#left across:2 offset:[0,3] fieldwidth:50
	button b_reset "R"  tooltip:"重置轴长度为3" offset:[0,0] align:#right

	local len = 3
	fn drawBoneAxis =
	(
		checkObjs = objects
		if sliptGrptoSel_ck.state do
		(
			if selection.count > 0 then
			(
				checkObjs = selection as array
			)else
			(
				gw.updateScreen()
				return false
			)
		)
		gw.setTransform (matrix3 1)
		for obj in checkObjs do
		(
			--仅对可见物体标记编辑
			if obj.isHiddenInVpt == false do
			(	
				--local len = 2
				local m = obj.transform
				local o = m.translation

				local dx = [len,0,0] * m
				local dy = [0,len,0] * m
				local dz = [0,0,len] * m

				gw.setColor #line red
				gw.Polyline #(o,dx) false

				gw.setColor #line green
				gw.Polyline #(o,dy) false

				gw.setColor #line blue
				gw.Polyline #(o,dz) false
			)	
		) -- end: for obj
		
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	)-- end: fn drawLocalAxis 

	on ax_len changed val do
	(
		len =  val --(val as integer)
		max views redraw
		--updatePreview()
	)	

	on b_reset pressed do
	(
		ax_len.value=3
		len = 3
		max views redraw
	)

	on cb_pivtoggle changed state do 
	(
		if state == true then
		(
			registerRedrawViewsCallback drawBoneAxis
		)else
		(
			unregisterRedrawViewsCallback drawBoneAxis
		)
		max views redraw
	)

	on sliptGrptoSel_ck changed state do 
	(
		if not cb_pivtoggle.state do return false
		unregisterRedrawViewsCallback drawBoneAxis
		registerRedrawViewsCallback drawBoneAxis
		max views redraw
	)

	on dialog_showPivots close do
	(
		unregisterRedrawViewsCallback drawBoneAxis
		max views redraw
	)	
)  --end rollout	

createDialog dialog_showPivots 
