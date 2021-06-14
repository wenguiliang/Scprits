
	f	= addfile("../../VIQV.nc","r")

	u	= f->VIUo
	v	= f->VIVo
	q	= f->VIdq
	qo	= f->VIqo
	
	qo	= where(qo .eq. 0, 1e-6, qo)
	u	= u/qo
	v	= v/qo
	print(avg(u))
	print(avg(v))
	;printVarSummary(q)	
	MeanU	= dim_avg_n_Wrap(u,0)
	MeanV	= dim_avg_n_Wrap(v,0)
	MeanU	= MeanU
	MeanV	= MeanV
		
	MeanQ	= dim_avg_n_Wrap(q,0)
	Qo	= dim_avg_n_Wrap(qo,0)
		
;--------------------------------------------------------------------
	wks	= gsn_open_wks("png","vDq_JJA")
	gsn_define_colormap(wks,"precip4_diff_19lev")
	gsn_define_colormap(wks,"CBR_wet")
	
	res	= True
	res@cnFillOn		= True
	res@cnLinesOn		= False
	res@gsnDraw			= False
	res@gsnFrame			= False
	res@gsnMaximize			= True
	
	res@gsnLeftString		= " "
	res@gsnRightString		= " "
	res@tiMainString		= " "

	res@mpMinLatF                   = 20      ; range to zoom in     on
        res@mpMaxLatF                   = 70
        res@mpMinLonF                   = 85
        res@mpMaxLonF                   = 170
        res@mpCenterLonF                = 100
        res@gsnAddCyclic                = False

	
	res@cnLevelSelectionMode        = "ManualLevels"     ; set manual contour levels
        res@cnMinLevelValF              = 5.              ; set min contour level
        res@cnMaxLevelValF              = 16.         ; set max contour level
        res@cnLevelSpacingF             = 1.            ; set contour spacing
	
	;---polish the pics--------------------------------;
	res@gsnLeftString	= " "
	res@gsnRightString	= " "
	res@tiMainString	= " "
	
	res@pmLabelBarWidthF	= 0.7
	res@pmLabelBarHeightF	= 0.15
	res@lbBoxMinorExtentF 	= 0.2 ;-- decrease height of labelbar boxes and vp
	;res@lbBoxLinesOn 	= False ;-- don't draw lines around labelbar boxes
	res@lbLabelFontColor 	= "black" ;-- label color
	res@lbLabelFontHeightF 	= 0.018 ;-- label font height
	;res@lbLabelOffsetF 	= 0.07
	res@pmLabelBarOrthogonalPosF	= 0.08

	res@tmXBLabelFontHeightF= 0.018
	res@tmYLLabelFontHeightF= 0.018



	MeanQ     = runave_n_Wrap(runave_n_Wrap(MeanQ,6,2,0),6,2,1)	
	plot	= gsn_csm_contour_map(wks,MeanQ,res)
	print(sum(MeanQ))
	
	res1				= True
	res1@gsnDraw			= False
	res1@gsnFrame			= False
	
	res1@gsnLeftString		= " "
	res1@gsnRightString		= " "
	res1@tiMainString		= " "

	res1@vcRefMagnitudeF         	= 3  
	res1@vcRefLengthF            	= 0.055            ; define length of vec ref
  	res1@vcGlyphStyle            	= "CurlyVector"    ; turn on curly vectors
  	res1@vcMinDistanceF         	= 0.059
	;res@vcGlyphStyle                = "LineArrow"
        res1@vcLineArrowThicknessF       = 10
        res1@vcLineArrowColor       = "Red"
	
	res1@vcRefAnnoOrthogonalPosF 	= -.58	
	;res1@vcRefAnnoParallelPosF 	= 0.187

 	plot1 = gsn_csm_vector(wks,MeanU,MeanV,res1) 	
	
	res2	= True
	res2@cnFillOn		= False
	res2@cnLinesOn		= True
	res2@gsnDraw			= False
	res2@gsnFrame			= False

	res2@gsnLeftString		= " "
	res2@gsnRightString		= " "
	res2@tiMainString		= " "
	
        ;res2@cnLevelSpacingF             = 1.            ; set contour spacing
	res2@cnLevelSelectionMode        = "ExplicitLevels"     ; set manual contour levels
        res2@cnLevels     	         = (/15,20,30,40,50/)              ; set min contour level
	
	res2@cnLineLabelBackgroundColor 	= "Transparent"
	res2@cnLineLabelPlacementMode 	= "constant"
	res2@cnLineLabelInterval		= 1
	;res1@cnLineLabelDensityF		= 1.0	
	res2@cnLineLabelFontHeightF	= 0.018	
	res2@cnLineLabelFontColor	= "Black"
	
	;------------------------------------------;
  	res2@gsnContourNegLineDashPattern = 3 
	res2@cnLineLabelsOn	= True
	res2@cnLineThicknessF	= 10.0
	res2@cnLineColor		= "Black"
		
	res2@cnInfoLabelOn	= False
	
	Qo     = runave_n_Wrap(runave_n_Wrap(Qo,10,2,0),10,2,1)	
	;------------------------------------------
	
	plot2	= gsn_csm_contour(wks,Qo,res2)
	

	overlay(plot,plot2)	
	overlay(plot,plot1)	
	draw(plot)
	frame(wks)

