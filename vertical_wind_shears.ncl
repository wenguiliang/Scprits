	fu	= addfile("../../../../U_and_V/R1_temp/Wind_Ensemble/Asia/All_Levels_JJA/U_Ensemble.nc","r")
	fv	= addfile("../../../../U_and_V/R1_temp/Wind_Ensemble/Asia/All_Levels_JJA/V_Ensemble.nc","r")
	fz	= addfile("../../../../Zg/Zg_Ensemble/Asia/All_Levels_JJA/Z_Ensemble.nc","r")


	u850	= fu->Uo(:,{85000},{10:80},:)
	v850	= fv->Vo(:,{85000},{10:80},:)
	u500	= fu->Uo(:,{30000},{10:80},:)
	v500	= fv->Vo(:,{30000},{10:80},:)

	z850	= fz->Zo(:,{85000},:,:)
	z500	= fz->Zo(:,{30000},:,:)

	print(avg(u850))
	print(avg(v850))
	print(avg(z850))
	print(avg(u500))
	print(avg(v500))
	print(avg(z500))
	;printVarSummary(u850)	
	;printVarSummary(z850)	
	dz	= z500
	dz	= z500 - z850

	du	= u500
	du	= u500 - u850
	dv	= v500
	dv	= v500 - v850

	print(avg(du)+" "+avg(dv))
	dV	= du
	dV	= sqrt(du^2 + dv^2)/dz*1000.


	DU	= du
	DU	= du/dz*1000.
	DV	= dv
	DV	= dv/dz*1000.
	;printVarSummary(dV)	
	

	system("rm Data_20th.nc")
	ff	= addfile("Data_20th.nc","c")
	ff->dvdz = dV
	ff->du	= DU
	ff->dv	= DV

