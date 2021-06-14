
	fq	= addfile("/R2/wengui/WENGUI_LIANG/Monthly_CMIP6/Q/Ensemble_QV/Asia/All_Levels_JJA/Q_Ensemble.nc","r")
	fu	= addfile("/R2/wengui/WENGUI_LIANG/Monthly_CMIP6/U_and_V/R1_temp/Wind_Ensemble/Asia/All_Levels_JJA/U_Ensemble.nc","r")
	fv	= addfile("/R2/wengui/WENGUI_LIANG/Monthly_CMIP6/U_and_V/R1_temp/Wind_Ensemble/Asia/All_Levels_JJA/V_Ensemble.nc","r")
	Uo	= fu->Uo
	Un	= fu->Un
	Vo	= fv->Vo
	Vn	= fv->Vn
	Qo	= fq->Qo;(:,:,{20:80},{85:170})
	Qn	= fq->Qn;(:,:,{20:80},{85:170})

	dq	= Qo	
	dq	= Qn - Qo	
	
	
	grad		= grad_latlon_cfd(dq,dq&lat,dq&lon,False,False)
 	q_grad_lat  	= doubletofloat(grad[0])    
  	q_grad_lon  	= grad[1]
  	delete(grad)
  	
	q_grad_lon@long_name = "longitudinal gradient (derivative)"
  	q_grad_lat@long_name = "latitudinal gradient (derivative)"
	
	
	v_dq	= Qo
	v_dq	= q_grad_lon*Uo + q_grad_lat*Vo

	dims	= dimsizes(v_dq)
	plev	= doubletofloat(fu->plev)

	VIvDq	= Uo(:,10,:,:)
	VIvDq	= 0.
	
	v_dq	= where(ismissing(v_dq) .eq. True, 0, v_dq)

	do i=0,dims(1)-2
		VIvDq	= VIvDq + (v_dq(:,i,:,:)+v_dq(:,i+1,:,:))*0.5*(plev(i)-plev(i+1))/9.8
	end do

	system("rm VIQV.nc")
	ff	= addfile("VIQV.nc","c")
	ff->VIvDq = VIvDq
