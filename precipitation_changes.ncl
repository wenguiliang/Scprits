
	f	= addfile("../Ensemble.nc","r")
	ft	= addfile("~/WENGUI_LIANG/Monthly_CMIP6/Amon_CMIP6_TAS/TS_Ensemble/Asia/JJA/Ensemble.nc","r")

	to	= dim_avg_n_Wrap(ft->To(:,{20:80},{85:170}),0)
	tn	= dim_avg_n_Wrap(ft->Tn(:,{20:80},{85:170}),0)
	dt	= tn 
	dt	= tn - to
	;printVarSummary(dt)
	
	;--VIQ change---------------------------------------------;
	fq	= addfile("../../../../../Monthly_CMIP6/Moisture_Budget/JJA/trend/decompose_QV/dq_vhis/VIQV.nc","r")	
	qo	= dim_avg_n_Wrap(fq->VIqo(:,{20:80},{85:170}),0)
	dq	= dim_avg_n_Wrap(fq->VIdq(:,{20:80},{85:170}),0)
	printVarSummary(dq)
	
	Dq	= qo
	Dq	= dq/qo/dt*100.
	Dqm	= avg(dq({20:70},{85:170}))/avg(qo({20:70},{85:170}))/avg(dt({20:70},{85:170}))*100.
	print(avg(Dq({20:70},{85:170})))
	print(Dqm)
	;---------------------------------------------------------;
	PREo	= f->Meano
	Meano	= dim_avg_n_Wrap(PREo,0)
	;printVarSummary(Meano)
		
	PREn	= f->Meann
	Meann	= dim_avg_n_Wrap(PREn,0)
	
	delta	= PREn
	delta	= PREn - PREo
	
	Mean	= Meann
	Mean	= (Meann - Meano)/Meano*100/dt
	dims	= dimsizes(Mean)
	lat	= Mean&lat
	lon	= Mean&lon
	;------------------------------------------

	wks	= gsn_open_wks("png","PRE_Scale_Mean_JJA")
	gsn_define_colormap(wks,"MPL_BrBG")
	;gsn_reverse_colormap(wks)
	
	res	= True
	res@cnFillOn		= True
	res@cnLinesOn		= False
	res@gsnDraw		= False	
	res@gsnFrame		= False	
	res@gsnMaximize			= True

	res@mpMinLatF                   = 20      ; range to zoom in     on
	res@mpMaxLatF                   = 70
	res@mpMinLonF                   = 85
	res@mpMaxLonF                   = 170
	res@mpCenterLonF                = 100
	res@gsnAddCyclic		= False
	
	res@cnLevelSelectionMode        = "ManualLevels"     ; set manual contour levels
        res@cnMinLevelValF              = -8.              ; set min contour level
        res@cnMaxLevelValF              = 8.         ; set max contour level
        res@cnLevelSpacingF             = 1.            ; set contour spacing

	resc				 = True
	resc@cnLevelSelectionMode        = "ExplicitLevels"     ; set manual contour levels
        resc@cnLevels     	         = (/3,4,5,6,7,8/)              ; set min contour level
        resc@cnLineLabelsOn		 = True
	resc@gsnAddCyclic                = False

	resc@cnLineLabelInterval	 = 1
	resc@cnLineLabelPlacementMode 	 = "constant"
	resc@cnLineThicknessF		 = 6
	resc@cnLineColor		 = "red"
	resc@cnLineLabelFontColor	 = "red"
	resc@gsnContourNegLineDashPattern= 2
	resc@cnLineDashSegLenF		 = 0.1
	;---polish the pics-----------------------------------------------------;
	res@gsnLeftString	= " "
	res@gsnRightString	= " "
	res@tiMainString	= " "
	
	res@pmLabelBarWidthF		= 0.7
	res@pmLabelBarHeightF		= 0.15
	res@lbBoxMinorExtentF 		= 0.2 ;-- decrease height of labelbar boxes and vp
	res@lbLabelFontColor 		= "black" ;-- label color
	res@lbLabelFontHeightF 		= 0.018 ;-- label font height
	res@pmLabelBarOrthogonalPosF	= 0.08

	resc@cnInfoLabelOn		= False
	res@tmXBLabelFontHeightF	= 0.018
	res@tmYLLabelFontHeightF	= 0.018
	resc@cnLineLabelFontHeightF	= 0.018
	;-----------------------------------------------------------------------;	

	dt	= runave_n_Wrap(runave_n_Wrap(dt,14,1,0),14,1,1)
	plot	= gsn_csm_contour_map_overlay(wks,Mean,dt,res,resc)

	;---plot the 7% line PRE---------------------------------;
	resc1				 = True
	resc1@gsnFrame		= False
	resc1@gsnDraw		= False
	resc1@gsnLeftString	= " "
	resc1@gsnRightString	= " "
	resc1@tiMainString	= " "
	
	resc1@cnLevelSelectionMode     	 = "ExplicitLevels"     ; set manual contour levels
        resc1@cnLevels     	      	 = (/7.5/)              ; set min contour level
        resc1@cnLineLabelsOn		 = True
	resc1@gsnAddCyclic               = False

	resc1@cnLineLabelInterval	 = 1
	resc1@cnLineLabelPlacementMode 	 = "constant"
	resc1@cnLineThicknessF		 = 10
	resc1@cnLineColor		 = "black"
	resc1@cnLineLabelFontColor	 = "black"
	resc1@gsnContourNegLineDashPattern = 2
	resc1@cnLineDashSegLenF		 = 0.1
	
	resc1@cnLineLabelFontHeightF	 = 0.018
	resc1@cnInfoLabelOn		 = False
	dp	= runave_n_Wrap(runave_n_Wrap(Mean,2,1,0),2,1,1)
	pcon	= gsn_csm_contour(wks,dp,resc1)

	overlay(plot,pcon)
	
	;---------------------------------------------------------;
	draw(plot)
	
	res1				= True
	res1@gsMarkerIndex		= 16
	res1@gsMarkerSizeF		= 0.0015	
	res1@gsMarkerColor		= "grey10"

	do i=0,dims(0)-1
		do j=0, dims(1)-1
			count	= 0
			MASK	= False
			do kk=0,17
				if (ismissing(Mean(i,j)) .eq. False .and. ismissing(delta(kk,i,j)) .eq. False) then
					if(Mean(i,j)*delta(kk,i,j) .gt. 0) then
						count = count + 1
					end if
				end if
				if(count .eq. 14) then
					;MASK	= True
                         	       gsn_polymarker(wks,plot,lon(j),lat(i),res1)
				end if
			end do
		end do
	end do
	frame(wks)




