	I	= getenv("ID")
	print(I)
	ID_U	= "/glade/scratch/wliang/Large_Ensemble_CESM1/JJA/U/U."+I+".JJA_1975-2004.nc" 
	ID_V	= "/glade/scratch/wliang/Large_Ensemble_CESM1/JJA/V/V."+I+".JJA_1975-2004.nc" 
	ID_P	= "/glade/scratch/wliang/Large_Ensemble_CESM1/JJA/PS_to_P/P."+I+".JJA_1975-2004.nc" 
	ID_Q	= "/glade/scratch/wliang/Large_Ensemble_CESM1/JJA/Q/Q."+I+".JJA_1975-2004.nc" 
	new_Q	= "/glade/scratch/wliang/Large_Ensemble_CESM1/JJA/Q/Q."+I+".JJA_2070-2099.nc" 

	fP	= addfile(ID_P,"r")	
	fu	= addfile(ID_U,"r")	
	fv	= addfile(ID_V,"r")	
	fq	= addfile(ID_Q,"r")	
	fnewq	= addfile(new_Q,"r")	
	print("test")	
	
	U	= fu->U
	V	= fv->V
	Q	= fq->Q
	newQ	= fnewq->Q
	p	= doubletofloat(fP->P)
	lat	= fP->lat
	lon	= fP->lon
	g	= 9.8
	;lev	= qu&lev
	;print(lev)	
	;----first calculate the convergence and divergence---------------------
	u	= dim_avg_n_Wrap(U,0)
	v	= dim_avg_n_Wrap(V,0)
	q	= dim_avg_n_Wrap(Q,0)
	new_q	= dim_avg_n_Wrap(newQ,0)
	P	= dim_avg_n_Wrap(p,0)
	dq	= q
	dq	= new_q - q
	
	grad	= grad_latlon_cfd(dq,dq&lat,dq&lon,False,False)
 	q_grad_lat  = doubletofloat(grad[0])    
  	q_grad_lon  = grad[1]
  	delete(grad)
  	
	q_grad_lon@long_name = "longitudinal gradient (derivative)"
  	q_grad_lat@long_name = "latitudinal gradient (derivative)"
	
	
	v_dq	= q
	v_dq	= q_grad_lon*u + q_grad_lat*v
		
	VIvDq	= u(0,:,:)
	VIvDq	= 0.0

	;----for polting--------------------------;	
	qu	= q
	qu	= q*u
	qv	= q
	qv	= q*v
	
	VIqu	= qu(0,:,:)
	VIqu	= 0.0
	VIqv	= qv(0,:,:)
	VIqu	= 0.0
	VIq	= q(0,:,:)
	VIq	= 0.0
	VIdq	= VIq
	;-----dq-------;
	dqu	= dq
	dqu	= dq*u
	dqv	= dq
	dqv	= dq*v
	
	VIdqu	= dqu(0,:,:)
	VIdqu	= 0.0
	VIdqv	= dqv(0,:,:)
	VIdqu	= 0.0
	;-----------------------------------------;
	dims	= dimsizes(u)
	
	do i=0,dims(0)-1
		;print((P(:,i+1,:,:)-P(:,i,:,:))/g)
		VIvDq	= VIvDq	+ v_dq(i,:,:)*(P(i+1,:,:)-P(i,:,:))/g
		VIqu	= VIqu	+ qu(i,:,:)*(P(i+1,:,:)-P(i,:,:))/g
		VIqv	= VIqv	+ qv(i,:,:)*(P(i+1,:,:)-P(i,:,:))/g
		VIq	= VIq	+ q(i,:,:)*(P(i+1,:,:)-P(i,:,:))/g
		
		VIdq	= VIdq	+ dq(i,:,:)*(P(i+1,:,:)-P(i,:,:))/g
		VIdqu	= VIdqu	+ dqu(i,:,:)*(P(i+1,:,:)-P(i,:,:))/g
		VIdqv	= VIdqv	+ dqv(i,:,:)*(P(i+1,:,:)-P(i,:,:))/g
	end do
		
	;printVarSummary(VIvDq)	
	

	newID	= "VI_QV_"+I+".nc"	
	ff	= addfile(newID,"c")
	ff->div	= VIvDq

	ff->VIqu = VIqu
	ff->VIqv = VIqv
	ff->VIq = VIq
	ff->VIdq = VIdq
	ff->VIdqu = VIdqu
	ff->VIdqv = VIdqv
