(
try (  DestroyDialog Batch_Anim)catch()
try (  DestroyDialog fileIn_Script)catch() 
try (  DestroyDialog tier_parentA)catch() 

global	Thepos=[0,0]
global mousedd=false
global Thepos12=[1300,230]

global Ms_filepath =""--env地址
global Ltier01 =""
global Ltier02 =""
global Ltier03 =""
global Ltier04 =""
global Ltier05 =""
global Ltier06 =""
global Ltier07 =""
global Ltier08 =""

global Rtier01 =""
global Rtier02 =""
global Rtier03 =""
global Rtier04 =""
global Rtier05 =""
global Rtier06 =""
global Rtier07 =""
global Rtier08 =""

rollout Batch_Anim "Batch" width:180 height:360
(
	local files=getfiles (maxfilepath+"*.max")
	local tem_aa=#()
	
	button 'find_files' "Path" pos:[8,10] width:160 height:10 align:#left  toolTip:"选择源文件文件夹"
	edittext 'path_edt1' "" pos:[6,30] width:137 height:19 enabled:true align:#left
	button 'getMAXList' ">>" pos:[148,29] width:20 height:19 align:#left 	toolTip:"打开当前Max文件路径"

	
	checkbutton fileInScript "脚" width:160  toolTip:"批量执行无界面的脚本\n         激活执行"
	checkbutton fileInSon "修改层级" width:72 height:15 across:2 toolTip:"批量修改所选文件层级"
	checkbutton ckbtn_setName "修改命名" width:72 height:15 toolTip:"批量修改所选物体的命名"
	GroupBox 'grp_setName' "修改命名" pos:[190,10]  width:252 height:340

	button selAll_bt "全选"  pos:[10,99] width:40
	button Unsel_bt "反选"  pos:[55,99] width:40

	button 'batchdo_bt' "批量执行" pos:[100,99] width:70 height:21 
	
	editText searchfile_et "筛选:" width:120 height:19  align:#left across:2
	button get_filename "<<"  toolTip:"获取当前文件名" align:#right
	multiListBox 'max_lbx1' "" pos:[5,150] width:170 height:15 align:#left
	--修改命名控件
	label 'la_fromName' "源名字" pos:[240,35] width:50 height:17
	label 'la_ToName' "目标名字" pos:[360,35] width:50 height:17	

	edittext 'Tex_fromName01' "1 "  pos:[200,55] width:110 height:17 fieldwidth:100
	label 'la_To01' "-->" pos:[315,55] width:20 height:17
	edittext 'Tex_toName01' ""  pos:[330,55] width:104 height:17 fieldwidth:100
	
	edittext 'Tex_fromName02' "2 "  pos:[200,80] width:110 height:17 fieldwidth:100
	label 'la_To02' "-->" pos:[315,80] width:20 height:17
	edittext 'Tex_toName02' ""  pos:[330,80] width:104 height:17 fieldwidth:100

	edittext 'Tex_fromName03' "3 "  pos:[200,105] width:110 height:17 fieldwidth:100
	label 'la_To03' "-->" pos:[315,105] width:20 height:17
	edittext 'Tex_toName03' ""  pos:[330,105] width:104 height:17 fieldwidth:100

	edittext 'Tex_fromName04' "4 "  pos:[200,130] width:110 height:17 fieldwidth:100
	label 'la_To04' "-->" pos:[315,130] width:20 height:17
	edittext 'Tex_toName04' ""  pos:[330,130] width:104 height:17 fieldwidth:100

	edittext 'Tex_fromName05' "5 "  pos:[200,155] width:110 height:17 fieldwidth:100
	label 'la_To05' "-->" pos:[315,155] width:20 height:17
	edittext 'Tex_toName05' ""  pos:[330,155] width:104 height:17 fieldwidth:100

	edittext 'Tex_fromName06' "6 "  pos:[200,180] width:110 height:17 fieldwidth:100
	label 'la_To06' "-->" pos:[315,180] width:20 height:17
	edittext 'Tex_toName06' ""  pos:[330,180] width:104 height:17 fieldwidth:100

	edittext 'Tex_fromName07' "7 "  pos:[200,205] width:110 height:17 fieldwidth:100
	label 'la_To07' "-->" pos:[315,205] width:20 height:17
	edittext 'Tex_toName07' ""  pos:[330,205] width:104 height:17 fieldwidth:100

	edittext 'Tex_fromName08' "8 "  pos:[200,230] width:110 height:17 fieldwidth:100
	label 'la_To08' "-->" pos:[315,230] width:20 height:17
	edittext 'Tex_toName08' ""  pos:[330,230] width:104 height:17 fieldwidth:100

	edittext 'Tex_fromName09' "9 "  pos:[200,255] width:110 height:17 fieldwidth:100
	label 'la_To09' "-->" pos:[315,255] width:20 height:17
	edittext 'Tex_toName09' ""  pos:[330,255] width:104 height:17 fieldwidth:100

	edittext 'Tex_fromName10' "10 "  pos:[195,280] width:115 height:17 fieldwidth:100
	label 'la_To10' "-->" pos:[315,280] width:20 height:17
	edittext 'Tex_toName10' ""  pos:[330,280] width:104 height:17 fieldwidth:100

	--执行无界面的脚本
	on fileInScript changed state do
	(
		if state then
		(
			createdialog fileIn_Script
		)
		else
		(
			DestroyDialog fileIn_Script
		)
	)		
	
	------------------------------------------------------------------------------------------------------------------------------
	--指定层级
	on fileInSon changed state do
	(
		if state then
		(
			createdialog tier_parentA pos:(( getDialogPos Batch_Anim )+ [-281,0] ) parent:Batch_Anim.hwnd --style:#( #style_minimizebox)
		)
		else
		(
			DestroyDialog tier_parentA
		)
	)

	------------------------------------------------------------------------------------------------------------------------------
	--修改命名
	on ckbtn_setName changed state do
	(
		if state then
		(
			Batch_Anim.width = 450
		)
		else
		(
			Batch_Anim.width = 180
			Tex_fromName01.text=Tex_fromName02.text=Tex_fromName03.text=Tex_fromName04.text=Tex_fromName05.text=Tex_fromName06.text=""
			Tex_fromName07.text=Tex_fromName08.text=Tex_fromName09.text=Tex_fromName10.text=""
			Tex_toName01.text=Tex_toName02.text=Tex_toName03.text=Tex_toName04.text=Tex_toName05.text=Tex_toName06.text=""
			Tex_toName07.text=Tex_toName08.text=Tex_toName09.text=Tex_toName10.text=""
		)
	)

	------------------------------------------------------------------------------------------------------------------------------

	on getMAXList pressed do
	(
		try(
			tem_aa=#()
			files=getfiles (maxfilepath+"*.max")
			for i in 1 to files.count do
			(
				gg=filenamefrompath(files[i] as string)
				append tem_aa gg
			)	
											----------------读取文档路径里的文件并保存到tem_aa集合中
			max_lbx1.items = tem_aa
			path_edt1.text=maxfilepath
		)catch()
	)
	on max_lbx1 doubleClicked sel do
	(
		loadmaxfile files[sel] quiet:true
	)
	on find_files pressed do
	(
		mfh1 = getSavePath caption:"选择max文件目录:"
			
		if mfh1 != undefined then
		(
			tem_aa=#()
			files=getfiles (mfh1+"\*.max")
			for i in 1 to files.count do
			(
				gg=filenamefrompath(files[i] as string)
				append tem_aa gg
			)
			max_lbx1.items = tem_aa
			path_edt1.text=maxfilepath
		)
	)

	Fn searchMaxFiles_fn fileList str =
	(
		selArray = #()
        numFiles = fileList.items.count
        for x = 1 to numFiles do
        (
			fileName = fileNameFromPath fileList.items[x]
			fileFound = findstring fileName str
			if fileFound != undefined then (append selArray x)
		)
			return selArray
	)
	--------------------------------------------------------------------------------------------------------------------------	
	--Select all
    on selAll_bt pressed do 
	(
       max_lbx1.selection = #{1..max_lbx1.items.count}
    )
		
	Fn UnSelect_fn sel all=
	(
		for i=1 to sel.count do
		(			
			ID_Find = findItem all sel[i]

			deleteItem all ID_Find
			
		)
		
		return all
		
	)
	
	--UnSelect
    on Unsel_bt pressed do 
	(
		list_all = #{1..max_lbx1.items.count} as array
		list_sel = max_lbx1.selection  as array
		
		max_lbx1.selection = UnSelect_fn list_sel list_all
		
    )
	
	--------------------------------------------------------------------------------------------------------------------------
	--以关键词查询
	on searchfile_et entered str do
	(
		if searchfile_et.text != "" then
		(
			max_lbx1.selection = (searchMaxFiles_fn max_lbx1 searchfile_et.text)
		)
	)
	--以关键词查询
	on searchfile_et changed  str do
	(
		if searchfile_et.text != "" then
		(
			max_lbx1.selection = (searchMaxFiles_fn max_lbx1 searchfile_et.text)
		)
		
	)
	
	
	----------------------------------------------------------------------------------------------------------
	--获得当前文件命名
	on get_filename pressed do
	(
		try(
			max_filename = filterString maxFileName "."
					
			searchfile_et.text = max_filename[1]
		)catch()
	)
	
	
	
	on batchdo_bt pressed do
	(
		try(
		if  files != #() then
		(
			for index in max_lbx1.selection do 
			(
				if keyboard.escPressed do (exit)
			
				loadMaxFile files[index] useFileUnits:true quiet:true

				-------------------------------------------------------------------------------------------------------------------------------
				---------------------------------------------------------------------------------------------------------------------
				--执行无界面的脚本启动
				if fileInScript.checked then	
				(
					if keyboard.escPressed do (exit)
					fileIn Ms_filepath
					
				)
				---------------------------------------------------------------------------------------------------------------------	
				--执行层级修改
				if fileInSon.checked then
				(
					try(
						if Ltier01 !="" and Rtier01 !="" then(
							execute ("$"+Ltier01+".parent=$"+Rtier01)
						)
						)catch()
					try(
						if Ltier02 !="" and Rtier02 !="" then(
							execute ("$"+Ltier02+".parent=$"+Rtier02)
						)
						)catch()
					try(
						if Ltier03 !="" and Rtier03 !="" then(
							execute ("$"+Ltier03+".parent=$"+Rtier03)
						)
						)catch()
					try(
						if Ltier04 !="" and Rtier04 !="" then(
							execute ("$"+Ltier04+".parent=$"+Rtier04)
						)
						)catch()
					try(
						if Ltier05 !="" and Rtier05 !="" then(
							execute ("$"+Ltier05+".parent=$"+Rtier05)
						)
						)catch()
					try(
						if Ltier06 !="" and Rtier06 !="" then(
							execute ("$"+Ltier06+".parent=$"+Rtier06)
						)
						)catch()
					try(
						if Ltier07 !="" and Rtier07 !="" then(
							execute ("$"+Ltier07+".parent=$"+Rtier07)
						)
						)catch()
					try(
						if Ltier08 !="" and Rtier08 !="" then(
							execute ("$"+Ltier08+".parent=$"+Rtier08)
						)
						)catch()
				)
				---------------------------------------------------------------------------------------------------------------------	
				--执行命名修改
				if ckbtn_setName.checked then
				(
					try(
						selArray = #()
						if Tex_fromName01.text !="" and Tex_toName01.text !="" then (
							execute ("$"+ Tex_fromName01.text +".name=" + "\"" + Tex_toName01.text + "\"")
							sel01 = execute ( "$"+ Tex_toName01.text )
							append selArray sel01
						)
						if Tex_fromName02.text !="" and Tex_toName02.text !="" then (
							execute ("$"+ Tex_fromName02.text +".name=" + "\"" + Tex_toName02.text + "\"")
							sel02 = execute ( "$"+ Tex_toName02.text )
							append selArray sel02
						)
						if Tex_fromName03.text !="" and Tex_toName03.text !="" then (
							execute ("$"+ Tex_fromName03.text +".name=" + "\"" + Tex_toName03.text + "\"")
							sel03 = execute ( "$"+ Tex_toName03.text )
							append selArray sel03
						)
						if Tex_fromName04.text !="" and Tex_toName04.text !="" then (
							execute ("$"+ Tex_fromName04.text +".name=" + "\"" + Tex_toName04.text + "\"")
							sel04 = execute ( "$"+ Tex_toName04.text )
							append selArray sel04
						)
						if Tex_fromName05.text !="" and Tex_toName05.text !="" then (
							execute ("$"+ Tex_fromName05.text +".name=" + "\"" + Tex_toName05.text + "\"")
							sel05 = execute ( "$"+ Tex_toName05.text )
							append selArray sel05
						)
						if Tex_fromName06.text !="" and Tex_toName06.text !="" then (
							execute ("$"+ Tex_fromName06.text +".name=" + "\"" + Tex_toName06.text + "\"")
							sel06 = execute ( "$"+ Tex_toName06.text )
							append selArray sel06
						)
						if Tex_fromName07.text !="" and Tex_toName07.text !="" then (
							execute ("$"+ Tex_fromName07.text +".name=" + "\"" + Tex_toName07.text + "\"")
							sel07 = execute ( "$"+ Tex_toName07.text )
							append selArray sel07
						)
						if Tex_fromName08.text !="" and Tex_toName08.text !="" then (
							execute ("$"+ Tex_fromName08.text +".name=" + "\"" + Tex_toName08.text + "\"")
							sel08 = execute ( "$"+ Tex_toName08.text )
							append selArray sel08
						)
						if Tex_fromName09.text !="" and Tex_toName09.text !="" then (
							execute ("$"+ Tex_fromName09.text +".name=" + "\"" + Tex_toName09.text + "\"")
							sel09 = execute ( "$"+ Tex_toName09.text )
							append selArray sel09
						)
						if Tex_fromName10.text !="" and Tex_toName10.text !="" then (
							execute ("$"+ Tex_fromName10.text +".name=" + "\"" + Tex_toName10.text + "\"")
							sel10 = execute ( "$"+ Tex_toName10.text )
							append selArray sel10
						)
						try( if selArray[1] != undefined then ( select selArray ))catch()
						)catch()
				)
				saveMaxFile files[index]
			)
		)
		)catch()
	)

	on tier_parentA mouseMove pos do
	(
		if mousedd==true Then
		(
			SetDialogPos tier_parentA  (mouse.screenpos-Thepos)
			Thepos12=mouse.screenpos-Thepos
		)
	)


	on tier_parentA lbuttonup pos do
	(
		mousedd=false
	)

	on tier_parentA lbuttondown pos do
	(
	mousedd=true
	Thepos=pos
		)
)
createdialog  Batch_Anim


-------------------------------------------------------------------------------------------------------------------------------------------------------
rollout fileIn_Script "执行无界面的脚本" width:231 height:60
(
	
	button 'browseMs_bt' "Ms文件:"  width:100 height:21    
    
	edittext 'browseMs_et' ""  width:204 height:17 fieldwidth:200 
	

	on browseMs_bt pressed do
	(
		tmpFilename = getOpenFileName caption:"Env Template File" types:"Env Files (*.ms)|*.ms|" historyCategory:"openfile" initialDir:(getDir #maxroot)
		if tmpFilename != undefined then 
			(
				browseMs_et.text = tmpFilename
				Ms_filepath = tmpFilename
	
			)
			
			
	)
)
rollout tier_parentA "修改层级" width:280 height:260
(
	checkbutton 'onrun' "==>"  pos:[200,230] width:60 height:21 toolTip:"激活该按钮再点批量执行"

	label 'sonObj' "子级" pos:[50,10] width:30 height:17
	label 'parentObj' "父级" pos:[190,10] width:30 height:17
	
	edittext 'son_01' "1 "  pos:[10,30] width:110 height:17 fieldwidth:100
	label 'targetCon01' "-->" pos:[127,30] width:20 height:17
	edittext 'parent_01' ""  pos:[150,30] width:104 height:17 fieldwidth:100 

	edittext 'son_02' "2 "  pos:[10,55] width:110 height:17 fieldwidth:100
	label 'targetCon02' "-->" pos:[127,55] width:20 height:17
	edittext 'parent_02' ""  pos:[150,55] width:104 height:17 fieldwidth:100

	edittext 'son_03' "3 "  pos:[10,80] width:110 height:17 fieldwidth:100
	label 'targetCon03' "-->" pos:[127,80] width:20 height:17
	edittext 'parent_03' ""  pos:[150,80] width:104 height:17 fieldwidth:100

	edittext 'son_04' "4 "  pos:[10,105] width:110 height:17 fieldwidth:100
	label 'targetCon04' "-->" pos:[127,105] width:20 height:17
	edittext 'parent_04' ""  pos:[150,105] width:104 height:17 fieldwidth:100

	edittext 'son_05' "5 "  pos:[10,130] width:110 height:17 fieldwidth:100
	label 'targetCon05' "-->" pos:[127,130] width:20 height:17
	edittext 'parent_05' ""  pos:[150,130] width:104 height:17 fieldwidth:100

	edittext 'son_06' "6 "  pos:[10,155] width:110 height:17 fieldwidth:100
	label 'targetCon06' "-->" pos:[127,155] width:20 height:17
	edittext 'parent_06' ""  pos:[150,155] width:104 height:17 fieldwidth:100

	edittext 'son_07' "7 "  pos:[10,180] width:110 height:17 fieldwidth:100
	label 'targetCon07' "-->" pos:[127,180] width:20 height:17
	edittext 'parent_07' ""  pos:[150,180] width:104 height:17 fieldwidth:100

	edittext 'son_08' "8 "  pos:[10,205] width:110 height:17 fieldwidth:100
	label 'targetCon08' "-->" pos:[127,205] width:20 height:17
	edittext 'parent_08' ""  pos:[150,205] width:104 height:17 fieldwidth:100


	on onrun changed state do
	(
		Ltier01=son_01.text
		Ltier02=son_02.text
		Ltier03=son_03.text
		Ltier04=son_04.text
		Ltier05=son_05.text
		Ltier06=son_06.text
		Ltier07=son_07.text
		Ltier08=son_08.text

		Rtier01=parent_01.text
		Rtier02=parent_02.text
		Rtier03=parent_03.text
		Rtier04=parent_04.text
		Rtier05=parent_05.text
		Rtier06=parent_06.text
		Rtier07=parent_07.text
		Rtier08=parent_08.text

	)
)

)
