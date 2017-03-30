function setBounds(data_dictionary, biomass)
	#biomass given in g dry weight
	#fluxes in mmol per hour
	bounds = data_dictionary["default_flux_bounds_array"]
	#glucose uptake #  76 R_GLCpts::M_glc_D_e+M_pep_c --> M_g6p_c+M_pyr_c
	bounds[76,:] =[0,10.5*biomass] #10.5 mmol of Glc per g [dry weight] per h aerobic, 18.5 anarobic
	
	#oxygen uptake 168 168 [] --> M_o2_c
	bounds[103,:] = [0,15*biomass] #from fig 1, 15 mm O2 per g dry weight per hour-aerobic

	#growth rate #24
	bounds[24,:] = [0.0, .68]
	data_dictionary["default_flux_bounds_array"] = bounds
	#for anarobic growth #103 R_O2t::M_o2_e --> M_o2_c
	#bounds[103,:] = [0,0]

	return data_dictionary
end
