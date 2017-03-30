using PyPlot
include("Include.jl")
include("setBounds.jl")

function calculateResidual()
	path_to_atom_file = "Atom.txt"
	data_dictionary =DataDictionary(0,0,0)
	atom_matrix =generate_atom_matrix(path_to_atom_file,data_dictionary)
	stoichiometric_matrix = data_dictionary["stoichiometric_matrix"]
	objective_value, flux_array, dual_array, uptake_array, exit_flag=solve()
	res=transpose(atom_matrix)*stoichiometric_matrix*flux_array
	net_reaction_str = generate_net_reaction_string(uptake_array, .01, data_dictionary)
	@show net_reaction_str
	@show objective_value
	flux_profile = show_flux_profile(flux_array, .01, data_dictionary)
	return res,flux_profile
end

function solve()
	# load the data dictionary -
	data_dictionary = DataDictionary(0,0,0)

	# solve the lp problem -
	(objective_value, flux_array, dual_array, uptake_array, exit_flag) = FluxDriver(data_dictionary)
	return objective_value, flux_array, dual_array, uptake_array, exit_flag
end

function mass_balances(t, y, data_dictionary)
	# load the data dictionary -
	eps = .01
	growth_flux_id = 1
	S = data_dictionary["stoichiometric_matrix"]
	data_dictionary=setBounds(data_dictionary, y[124]) #biomass is species #124
	# solve the lp problem -
	(objective_value, flux_array, dual_array, uptake_array, exit_flag) = FluxDriver(data_dictionary)
	@show flux_array[2] #glucose uptak
	@show flux_array[1] #growth rate
	change =S*flux_array#-flux_array[growth_flux_id]*y
	return change #flux_array[24] is growth rate
end

function calculateAtomsPerReaction(reactions,data_dictionary, local_atom_dictionary)
	list_of_metabolite_symbols_model = data_dictionary["list_of_metabolite_symbols"]
	number_of_metabolites = length(list_of_metabolite_symbols_model)
	tmp_array::Array{AbstractString} = AbstractString[]
  	atom_array = zeros(number_of_metabolites,6)
	for line in reactions
		line=replace(line, r":+", ",")
		#@show line
		split_line = split(line, ",")
		if(size(split_line,1)>2)
			rxn_id=split_line[1]
			name = split_line[2]
			flux = split_line[4]
			rxn = split_line[3]
		else
			name = split_line[1]
			rxn = split_line[2]
		end
		split_rxn = split(strip(rxn), "-->")
		#@show split_rxn
		total_atoms = zeros(6)
		for idx in (1,size(split_rxn,1))
			section = split_rxn[idx]
			#@show section
			species = split(strip(section), "+")
			for item in species
				#@show item
				coeff = 1
				#if we have a coefficent other than 1
				if(searchindex(item, '*')!=0)
					staridx = searchindex(item, '*')
					coeff = parse(item[1:staridx-1])
					item = item[staridx+1:end]
				end
				atoms = local_atom_dictionary[item]
				if(idx == 1) #reactants
					total_atoms = atoms*coeff+total_atoms
				else #products
					total_atoms = -atoms*coeff+total_atoms
				end
			end
		end
		if(maximum(abs(total_atoms))>0) #show unbalanced reactions
			@show name
			@show total_atoms
		end
		
	end

end

function generate_local_atom_arr(path_to_atom_file::AbstractString,data_dictionary::Dict{AbstractString,Any})


  # how many metabolite symbols do we have in *the model*?
  list_of_metabolite_symbols_model = data_dictionary["list_of_metabolite_symbols"]
  number_of_metabolites = length(list_of_metabolite_symbols_model)

  # initialize -
  tmp_array::Array{AbstractString} = AbstractString[]
  atom_array = zeros(number_of_metabolites,6)

  local_dictionary::Dict{AbstractString,Any} = Dict{AbstractString,Any}()
  # load the atom file -
  try

    open(path_to_atom_file,"r") do model_file
      for line in eachline(model_file)

          if (contains(line,"//") == false && search(line,"\n")[1] != 1)
            push!(tmp_array,chomp(line))
          end
      end
    end

    # ok, create a local dictionary w/the atom records -
    for record in tmp_array

      # split -
      split_array = split(record,",")

      # get my key -
      key = split_array[1]  # Metabolite symbol -

      # local array -
      local_atom_array = zeros(6)
      local_atom_array[1] = parse(Float64,split_array[2]) # C
      local_atom_array[2] = parse(Float64,split_array[3]) # H
      local_atom_array[3] = parse(Float64,split_array[4]) # N
      local_atom_array[4] = parse(Float64,split_array[5]) # O
      local_atom_array[5] = parse(Float64,split_array[6]) # P
      local_atom_array[6] = parse(Float64,split_array[7]) # S

      # store -
      local_dictionary[key] = local_atom_array
    end
	  catch err
    showerror(STDOUT, err, backtrace());println()
  end
	return local_dictionary
end

function checkAllBalances()
	path_to_atom_file = "Atom.txt"
	data_dictionary =DataDictionary(0,0,0)
	local_atom_array=generate_local_atom_arr(path_to_atom_file, data_dictionary)
	calculateAtomsPerReaction(data_dictionary["list_of_reaction_strings"],data_dictionary, local_atom_array)
end

function test_function(t, y)
	return y
end

function eulerIntegration(y0, func, t, data_dictionary)
	num_steps = size(t, 1)
	y = zeros(size(transpose(y0)))
	all_y=y
	for j in collect(1:num_steps-1)
		if(j ==1)
			y=y0+(t[j+1]-t[j])*func(t[j], y0, data_dictionary)
		else
			y=y+(t[j+1]-t[j])*func(t[j], y, data_dictionary)
		end
		@show size(y)
		all_y = vcat(all_y, transpose(y))
	end
	return all_y
end

function plotdFBAResults(t, data_dictionary,res, species_of_interest)
	close("all")
	all_names = data_dictionary["list_of_metabolite_symbols"]
	num_species =size(species_of_interest,1)
	@show num_species
	for j in collect(1:num_species)
		plot(t, res[:, species_of_interest[j]])
	end
	legend(all_names[species_of_interest], loc="best")
end

function plotdFBAResultsAgainstData(t, data_dictionary,res, species_of_interest)
	close("all")
	biomass_data =  readdlm("../data/Figure7Biomass", ',')
	glucose_data = readdlm("../data/Figure7Glucose", ',')
	acetate_data = readdlm("../data/Figure7Acetate", ',')
	all_names = data_dictionary["list_of_metabolite_symbols"]
	num_species =size(species_of_interest,1)
	@show num_species
	colors = ["b", "g", "r"]
	for j in collect(1:num_species)
		plot(t, res[:, species_of_interest[j]], color = colors[j])
	end
	plot(biomass_data[:,1], biomass_data[:,2], color = colors[1], "x")
	plot(acetate_data[:,1], acetate_data[:,1], color = colors[2], "x")
	plot(glucose_data[:,1], glucose_data[:,2], color = colors[3], "x")
	legend(all_names[species_of_interest], loc="best")
	savefig("figures/AttemptToRecrateFig7.pdf")
end

function dFBA()
	tstart = 0.0
	tstep = .1
	tend = 10.0
	time = collect(tstart:tstep:tend)
	data_dictionary =DataDictionary(0,0,0)
	(objective_value, flux_array_ss, dual_array, uptake_array, exit_flag) = FluxDriver(data_dictionary)
	inital_conditions =fill(0.0,size(data_dictionary["list_of_metabolite_symbols"], 1),1)
	#make glucose non zero
	inital_conditions[122]=10.0
	inital_conditions[124] = .1 #make biomass non zero
	res=eulerIntegration(inital_conditions, mass_balances, time, data_dictionary)
	@show size(res)
	#ac_c = 7, ac_b, 73
	#biomass 94
	plotdFBAResultsAgainstData(time, data_dictionary, res, [124,118,122])
	
end
