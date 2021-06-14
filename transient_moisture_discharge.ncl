
	J0 = getenv("ID")
	print(J0)
	J1 = sprinti("%0.3i",stringtointeger(J0))

	IDdqdt = "../Data/JJA_DIF."+J1+"_1990-2005.nc"
	
	ID_index = "/glade/scratch/wliang/Extreme_Precipitation/Global_Europe/data/20th/PRE/JJA/Data/TMP/JJA_PRECT."+J1+"_1990-2004.nc"	

	fdqdt	= addfile(IDdqdt,"r")
	fi	= addfile(ID_index,"r")
	Index0	= fi->Index
	PRECT0	= fi->PRECT
	copy_VarAtts(PRECT0,Index0)
	copy_VarCoords(PRECT0,Index0)
	printVarSummary(Index0)
	
	Index	= Index0(:,{20:80},{85:170})

	dim	= dimsizes(Index)
	print(dim)
	print("11")
	
	DIV = fdqdt->dqdt
	
	;----select the extreme days----------------------
	threshold = dim(0)/5
	print(threshold)
	
	DIVs	= DIV(0:threshold,:,:)	 
	do i=0,threshold
	;print("now is  "+i)
		do j=0, dim(1)-1
			do k=0, dim(2)-1
				index	= Index(i,j,k) 
				print("index is "+index)
				DIVs(i,j,k) = DIV(index,j,k)
			end do
		end do
	end do
	

	Mean	= dim_avg_n_Wrap(DIVs,0)


	newID =  "JJA_dqdt."+J1+"_1990-2005.nc"
	ff	= addfile(newID,"c")
	ff->dqdts	= DIVs
	ff->Mean	= Mean
