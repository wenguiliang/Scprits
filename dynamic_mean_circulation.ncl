
	fq	= addfile("/R2/wengui/WENGUI_LIANG/Monthly_CMIP6/Q/Ensemble_QV/Asia/All_Levels_JJA/Q_Ensemble.nc","r")
	fu	= addfile("/R2/wengui/WENGUI_LIANG/Monthly_CMIP6/U_and_V/R1_temp/Wind_Ensemble/Asia/All_Levels_JJA/U_Ensemble.nc","r")
	fv	= addfile("/R2/wengui/WENGUI_LIANG/Monthly_CMIP6/U_and_V/R1_temp/Wind_Ensemble/Asia/All_Levels_JJA/V_Ensemble.nc","r")
	Uo	= fu->Uo
	Un	= fu->Un
	Vo	= fv->Vo
	Vn	= fv->Vn
	Qo	= fq->Qo;(:,:,{20:80},{85:170})
	Qn	= fq->Qn;(:,:,{20:80},{85:170})

	dU	= Uo	
	dU	= Un - Uo	
	dV	= Vo	
	dV	= Vn - Vo	
	

	divV	= Uo
	divV	= uv2dv_cfd(dU,dV,Uo&lat,Uo&lon,2)	
	

	dims	= dimsizes(Uo)
	plev	= doubletofloat(fu->plev)

	VIUo	= Uo(:,10,:,:)
	VIUo	= 0.
	
	divV	= where(ismissing(divV) .eq. True, 0, divV)
	Qo	= where(ismissing(Qo) .eq. True, 0, Qo)

	do i=0,dims(1)-2
		VIUo	= VIUo + (divV(:,i,:,:)*Qo(:,i,:,:)+divV(:,i+1,:,:)*Qo(:,i+1,:,:))*0.5*(plev(i)-plev(i+1))/9.8
	end do

	system("rm VIQV.nc")
	ff	= addfile("VIQV.nc","c")
	ff->VIUo = VIUo
