function setBounds(data_dictionary, biomass)
	#biomass given in g dry weight
	#fluxes in mmol per hour
	bounds = data_dictionary["default_flux_bounds_array"]
	#glucose uptake # 2# 2 R_glk_atp::M_atp_c+M_glc_D_c --> M_adp_c+M_g6p_c
	bounds[2,:] =[0,10.5*biomass] #10.5 mmol of Glc per g [dry weight] per h aerobic, 18.5 anarobic
	
	#oxygen uptake 168 168 [] --> M_o2_c
	bounds[103,:] = [0,15*biomass] #from fig 1, 15 mm O2 per g dry weight per hour-aerobic

	#growth rate #1
	bounds[1,:] = [0.0, .68]
	data_dictionary["default_flux_bounds_array"] = bounds
	#for anarobic growth #103 R_O2t::M_o2_e --> M_o2_c
	#bounds[103,:] = [0,0]

	return data_dictionary
end
