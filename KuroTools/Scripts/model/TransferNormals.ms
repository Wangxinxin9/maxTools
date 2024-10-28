try(destroyDialog TransferNormalsRol )catch()
rollout TransferNormalsRol "法线传递V2.0" width:225
(
    spinner offset_spn "精度" width:70 pos:[25,5] range:[0.0001,10,0.001] type:#float scale:0.001 toolTip:"面的相对位置精度值"
    checkbox onlySel_chk "只传递选择" pos:[135,5] checked:false toolTip:"只传递修改对象已选择面的法线"
    fn poly_filt obj = iskindof obj.baseobject Editable_Poly
    pickbutton pickS_Btn "拾取源对象" width:205 height:20 filter:poly_filt toolTip:"传出数据的正确的法线的对象"
    pickbutton pickT_Btn "拾取传递对象" width:205 height:20 filter:poly_filt toolTip:"接收数据的要改变法线的对象"
    button theBtn "传递" width:205 height:50 --toolTip:"先选择要传递对象,再选择接收对象(必须拓扑一致)"

    local theSobj
    local theTobj
    local userScriptsPath = getDir #userScripts
    local TransferPoly

    fn haveNormalsData obj =
    (
        iGlobal = (dotnetClass "Autodesk.Max.GlobalInterface").Instance
        ip13 = iGlobal.COREInterface13
        theNode = ip13.GetINodeByHandle obj.handle

        modNum = obj.modifiers.count
        if modNum == 0 then(
            if theNode.ObjectRef.Mesh.SpecifiedNormals == undefined do(
                return false
            )
        )else(
            if theNode.ObjectRef.ObjRef.Mesh.SpecifiedNormals == undefined do(
                return false
            )
        )
        true
    )

    fn TransferNormals sObj tObj offset onlySel =
    (
        if not (iskindof sObj.baseobject Editable_Poly) or not (iskindof tObj.baseobject Editable_Poly) do(
            return (messageBox "请拾取两个多边形   " title:"警告")
        )
        -- if (polyop.getNumVerts sObj) != (polyop.getNumVerts tObj) do(
        --     return (messageBox "源对象与目标对象顶点数不一致   " title:"警告")
        -- )
        -- local sFaceNum = sObj.getNumFaces()
        -- local tFaceNum = tObj.getNumFaces()
        -- if sFaceNum != tFaceNum do(
        --     return (messageBox "源对象与目标对象面数不一致   " title:"警告")
        -- )

        with redraw off
        (
            local sModNum = sObj.modifiers.count
            if not (haveNormalsData sObj) do(
                --添加编辑法线修改器
                mod_sObj = Edit_Normals ()
                addmodifier sObj mod_sObj before:sModNum
                maxOps.CollapseNodeTo sObj (sModNum+1) on
            )
            --如果轴心未归零
            if abs((sObj[3].rotation as eulerangles).x) > 0.001 do(
                --重置变换
                ResetXForm sObj
                addmodifier sObj (copy sObj.modifiers[1]) before:sModNum
                deleteModifier sObj 1
                maxOps.CollapseNodeTo sObj (sModNum+1) on
            )

            local tModNum = tObj.modifiers.count
            if not (haveNormalsData tObj) do(
                --添加编辑法线修改器
                mod_tObj = Edit_Normals ()
                addmodifier tObj mod_tObj before:tModNum
                maxOps.CollapseNodeTo tObj (tModNum+1) on
            )
            --如果轴心未归零
            if abs((tObj[3].rotation as eulerangles).x) > 0.001 do(
                --重置变换
                ResetXForm tObj
                addmodifier tObj (copy tObj.modifiers[1]) before:tModNum
                deleteModifier tObj 1
                maxOps.CollapseNodeTo tObj (sModNum+1) on
            )

            start = timestamp()

            ---开始传递
            local Version_ = 2020 + ((maxVersion())[1] - 22000)/1000
            dllName = "ClassLibrary" + Version_ as string + ".dll"
            local dll_file = userScriptsPath + "\\" + dllName
            if doesFileExist dll_file then(
                if TransferPoly == undefined do(
                    assembly = (dotnetclass "System.Reflection.Assembly").Load ((dotnetclass "System.IO.File").ReadAllBytes dll_file)
                    TransferPoly = assembly.createInstance "ClassLibrary1.TransferPoly"
                )
                TransferPoly.TransferNormal sObj.handle tObj.handle offset onlySel
                update tObj
            )else(
                messageBox "ClassLibrary.dll文件丢失   " title:"警告"
                try(destroyDialog TransferNormalsRol )catch()
            )
        )
        completeredraw()
        format "法线传递耗时 %s\n" ((timestamp()-start)/1000.0)
    )

    on TransferNormalsRol open do
    (
        local Version_ = 2020 + ((maxVersion())[1] - 22000)/1000
        dllName = "ClassLibrary" + Version_ as string + ".dll"
        if doesFileExist (userScriptsPath + "\\" + dllName) do return false

        local thisFileName = getThisScriptFilename()
        if doesFileExist thisFileName then(
            local ClassLibraryFileName = (getFilenamePath thisFileName) + dllName

            if doesFileExist ClassLibraryFileName then(
                if not doesFileExist (userScriptsPath + "\\" + dllName) then(
                    if not copyFile ClassLibraryFileName (userScriptsPath + "\\" + dllName) then(
                        messageBox "ClassLibrary.dll文件配置失败   " title:"警告"
                        try(destroyDialog TransferNormalsRol )catch()
                    )
                )
            )else(
                messageBox "不支持当前Max版本,或ClassLibrary.dll文件丢失   " title:"警告"
                try(destroyDialog TransferNormalsRol )catch()
            )
        )
    )

    on pickS_Btn picked obj do
    (
        if obj != undefined do
        (
            pickS_Btn.text = "S: " + obj.name
            theSobj = pickS_Btn.object
        )
    )

    on pickT_Btn picked obj do
    (
        if obj != undefined do
        (
            pickT_Btn.text = "T: " + obj.name
            theTobj = pickT_Btn.object
        )
    )

    on theBtn pressed do
    (
        if isValidNode theSobj and isValidNode theTobj then(
            --zeroBarVal()
            TransferNormals theSobj theTobj offset_spn.value onlySel_chk.checked
        )else(
            messageBox "请先拾取源对象与传递对象   " title:"警告"
        )
    )
)
createDialog TransferNormalsRol