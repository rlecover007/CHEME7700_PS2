function compareMetabolites(path_to_atom_file::AbstractString,data_dictionary::Dict{AbstractString,Any})
	  # how many metabolite symbols do we have in *the model*?
	list_of_metabolite_symbols_model = data_dictionary["list_of_metabolite_symbols"]
	number_of_metabolites = length(list_of_metabolite_symbols_model)
	  # initialize -
	atom_names_array = AbstractString[]
	missing_species_array = AbstractString[]
	tmp_array::Array{AbstractString} = AbstractString[]


  # load the atom file -
  try

    open(path_to_atom_file,"r") do model_file
      for line in eachline(model_file)

          if (contains(line,"//") == false && search(line,"\n")[1] != 1)
            push!(tmp_array,chomp(line))
          end
      end
    end

    # build atom_names_array
    for record in tmp_array
	@show record

      # split -
      split_array = split(record,",")

      # get my key -
      key = split_array[1]  # Metabolite symbol -
	@show key
	push!(atom_names_array, key)
    end

  catch err
    showerror(STDOUT, err, backtrace());println()
  end
	#check if specise are in atom_names_array
	for species in list_of_metabolite_symbols_model
		if(!in(species,atom_names_array))
			push!(missing_species_array, species)
		end
	end

  return missing_species_array
end
