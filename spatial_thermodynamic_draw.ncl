	
	ft	= addfile("~/WENGUI_LIANG/Monthly_CMIP6/Amon_CMIP6_TAS/TS_Ensemble/Asia/JJA/Ensemble.nc","r")

	to	= dim_avg_n_Wrap(ft->To(:,{10:90},{80:180}),0)
	tn	= dim_avg_n_Wrap(ft->Tn(:,{10:90},{80:180}),0)
	dt	= tn 
	dt	= tn - to
	printVarSummary(dt)

	fp	= addfile("/R2/wengui/WENGUI_LIANG/Monthly_CMIP6/PRE/Ensemble_PRE/JJA/Ensemble.nc","r")
	
	p	= fp->Ho

	Po	= dim_avg_n_Wrap(p(:,{10:90},{80:180}),0)
	Po	= Po*24*3600
	;printVarSummary(Po)


	f	= addfile("VIQV.nc","r")
	
	QUo	=f->VIvDq(:,{10:90},{80:180})
	lat	=f->lat
	lon	=f->lon
	printVarSummary(QUo)

	DIVo	= QUo
	DIVo	= DIVo*1e5*-1.
	

	DIV	= dim_avg_n_Wrap(DIVo,0)
	DIV	= DIV/Po*100./dt
	DIV	= runave_n_Wrap(runave_n_Wrap(DIV,6,2,0),6,2,1)
	print(avg(DIV))
	
	wks	= gsn_open_wks("png","PC_Trend_grad_dq_vhis_JJA")
	;wks	= gsn_open_wks("eps","Jet_DJF")
	;gsn_define_colormap(wks,"BlAqGrWh2YeOrReVi22")
	gsn_define_colormap(wks,"BlueWhiteOrangeRed")
	gsn_reverse_colormap(wks)
	
	res	= True
	res@gsnFrame	= False
	res@gsnDraw	= False
	res@cnFillOn		= True
	res@cnLinesOn		= False
	res@gsnMaximize			= True
	
	res@mpMinLatF                   = 22      ; range to zoom in     on
        res@mpMaxLatF                   = 70
        res@mpMinLonF                   = 87
        res@mpMaxLonF                   = 168
        res@mpCenterLonF                = 100
        res@gsnAddCyclic                = False
	
	res@cnLevelSelectionMode        = "ManualLevels"     ; set manual contour levels
 	res@cnMinLevelValF              = -5              ; set min contour level
        res@cnMaxLevelValF              = 5         ; set max contour level
        res@cnLevelSpacingF             = .5          ; set contour spacing


	
	;---polish the pics-----------------------------------------------------;
	res@gsnLeftString	= " "
	res@gsnRightString	= " "
	res@tiMainString	= " "
	
	res@pmLabelBarWidthF	= 0.7
	res@pmLabelBarHeightF	= 0.15
	res@lbBoxMinorExtentF 	= 0.2 ;-- decrease height of labelbar boxes and vp
	;res@lbBoxLinesOn 	= False ;-- don't draw lines around labelbar boxes
	res@lbLabelFontColor 	= "black" ;-- label color
	res@lbLabelFontHeightF 	= 0.018 ;-- label font height
	;res@lbLabelFont 	= "helvetica-bold";-- label font
	;res@lbLabelOffsetF 	= 0.07
	res@pmLabelBarOrthogonalPosF	= 0.08

	;res@tmXBLabelFont	= "helvetica-bold"
	res@tmXBLabelFontHeightF= 0.018
	;res@tmYLLabelFont	= "helvetica-bold"
	res@tmYLLabelFontHeightF= 0.018
	
	;-----------------------------------------------------------------------;	


	plot	= gsn_csm_contour_map(wks,DIV,res)
	draw(plot)
	
	res1				= True
	res1@gsMarkerIndex		= 16
	res1@gsMarkerSizeF		= 0.0015	
	res1@gsMarkerColor		= "gray30"

	dims	= dimsizes(DIV)	
	
	do i=0,dims(0)-1
		do j=0, dims(1)-1
			count	= 0
			MASK	= False
			do kk=0,17
				if (ismissing(DIV(i,j)) .eq. False .and. ismissing(DIVo(kk,i,j)) .eq. False) then
					if(DIV(i,j)*DIVo(kk,i,j) .gt. 0) then
						count = count + 1
					end if
				end if
				if(count .eq. 14) then
					;MASK	= True
                         	       gsn_polymarker(wks,plot,lon(j),lat(i),res1)
				end if
			end do
			;if (MASK .eq. False .and. ismissing(Mean(i,j)) .eq. False .and. ismissing(Raw(0,i,j)) .eq. False) then
                         ;       gsn_polymarker(wks,plot,lon(j),lat(i),res1)
                                   ;print("robust")
                        ;end if
		end do
	end do
	frame(wks)

	;system("rm Mean_QV.nc")
	;ff	= addfile("Mean_QV.nc","c")
	;ff->dDIV	= dDIV



