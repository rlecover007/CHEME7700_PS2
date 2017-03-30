function setBounds(data_dictionary, biomass, glucose_available, mode)
	@show biomass
	#biomass given in g dry weight
	#fluxes in mmol per hour
	bounds = data_dictionary["default_flux_bounds_array"]
	species_bound_array = data_dictionary["species_bounds_array"]
	if(mode == "aerobic")
		oxygen_ub = 15.0
		glucose_ub = 10.5
		growth_ub =.68
	elseif(mode =="anaerobic")
		oxygen_ub = 0.0
		glucose_ub = 18.5
		growth_ub =.43
	end
	@show glucose_available
	if(glucose_available>0) #can only grow if there's glucose
		#glucose uptake # 1 R_glk_atp::M_atp_c+M_glc_D_c --> M_adp_c+M_g6p_c
		bounds[1,:] =[0,glucose_ub*biomass] #10.5 mmol of Glc per g [dry weight] per h aerobic, 18.5 anarobic
	
		#oxygen uptake # 84 M_o2_e --> M_o2_c
		bounds[84,:] = [0,oxygen_ub*biomass] #from fig 1, 15 mm O2 per g dry weight per hour-aerobic

		#growth rate# 83
		bounds[83,:] = [0,growth_ub]
		#for anarobic growth #103 R_O2t::M_o2_e --> M_o2_c
		#bounds[103,:] = [0,0]
	else
		bounds[1,:]=[0,0]
		bounds[83,:]=[0,.01]
#		bounds[73,:]=[00,0]
#		bounds[99,:] = [0,0]
		if(mode=="aerbic")
			species_bound_array[58,:]= [-4.0,-4]
		end
	end
	data_dictionary["default_flux_bounds_array"] = bounds
	data_dictionary["species_bounds_array"]=species_bound_array

	return data_dictionary
end
