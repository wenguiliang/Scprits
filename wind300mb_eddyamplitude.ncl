
	J0 = getenv("ID")
	print(J0)
	J1 = sprinti("%0.3i",stringtointeger(J0))
	
	f	= addfile("../Data/JJA_Wind300."+J1+"_1990-2005.nc","r")


	U	= f->U300
	V	= f->V300

	printVarSummary(U)

	Um	= dim_avg_n_Wrap(U,0)
	Vm	= dim_avg_n_Wrap(V,0)

	Upi	= Um
	Vpi	= Vm
	
	Um2	= Um^2
	Vm2	= Vm^2
	U2	= U^2
	V2	= V^2

	U2m	= dim_avg_n_Wrap(U2,0)
	V2m	= dim_avg_n_Wrap(V2,0)

	Upi	= U2m - Um2
	Vpi	= V2m - Vm2
	

	total	= Upi
	total	= Upi + Vpi
	

	newID =  "JJA_V300pi."+J1+"_1990-2005.nc"
	ff	= addfile(newID,"c")
	ff->V300pi	= total
