
	J0 = getenv("ID")
	print(J0)
	J1 = sprinti("%0.3i",stringtointeger(J0))
	
	f	= addfile("../Data/JJA_VIQ."+J1+"_1990-2005.nc","r")


	Q	= f->VIQ

	printVarSummary(Q)

	Qm	= dim_avg_n_Wrap(Q,0)

	Qpi	= Qm
	
	Qm2	= Qm^2
	Q2	= Q^2

	Q2m	= dim_avg_n_Wrap(Q2,0)

	Qpi	= Q2m - Qm2

	newID =  "JJA_VIQpi."+J1+"_1990-2005.nc"
	ff	= addfile(newID,"c")
	ff->VIQpi	= Qpi
