# ----------------------------------------------------------------------------------- #
# Copyright (c) 2017 Varnerlab
# Robert Frederick Smith School of Chemical and Biomolecular Engineering
# Cornell University, Ithaca NY 14850
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# ----------------------------------------------------------------------------------- #
#
# ----------------------------------------------------------------------------------- #
# Function: DataDictionary
# Description: Holds simulation and model parameters as key => value pairs in a Julia Dict()
# Generated on: 2017-03-27T17:50:21.341
#
# Input arguments:
# time_start::Float64 => Simulation start time value (scalar) 
# time_stop::Float64 => Simulation stop time value (scalar) 
# time_step::Float64 => Simulation time step (scalar) 
#
# Output arguments:
# data_dictionary::Dict{AbstractString,Any} => Dictionary holding model and simulation parameters as key => value pairs 
# ----------------------------------------------------------------------------------- #
function DataDictionary(time_start,time_stop,time_step)

	# Load the stoichiometric network from disk - 
	stoichiometric_matrix = readdlm("Network.dat");

	# Setup default flux bounds array - 
	default_bounds_array = [
		0	100.0	;	# 1 M_pep_c+M_glc_D_e --> M_pyr_c+M_g6p_c
		0	100.0	;	# 2 M_atp_c+M_glc_D_c --> M_adp_c+M_g6p_c
		0	100.0	;	# 3 M_g6p_c --> M_f6p_c
		0	100.0	;	# 4 M_f6p_c --> M_g6p_c
		0	100.0	;	# 5 M_atp_c+M_f6p_c --> M_adp_c+M_fdp_c
		0	100.0	;	# 6 M_fdp_c+M_h2o_c --> M_f6p_c+M_pi_c
		0	100.0	;	# 7 M_fdp_c --> M_dhap_c+M_g3p_c
		0	100.0	;	# 8 M_dhap_c+M_g3p_c --> M_fdp_c
		0	100.0	;	# 9 M_dhap_c --> M_g3p_c
		0	100.0	;	# 10 M_g3p_c --> M_dhap_c
		0	100.0	;	# 11 M_g3p_c+M_nad_c+M_pi_c --> M_13dpg_c+M_h_c+M_nadh_c
		0	100.0	;	# 12 M_13dpg_c+M_h_c+M_nadh_c --> M_g3p_c+M_nad_c+M_pi_c
		0	100.0	;	# 13 M_13dpg_c+M_adp_c --> M_3pg_c+M_atp_c
		0	100.0	;	# 14 M_3pg_c+M_atp_c --> M_13dpg_c+M_adp_c
		0	100.0	;	# 15 M_3pg_c --> M_2pg_c
		0	100.0	;	# 16 M_2pg_c --> M_3pg_c
		0	100.0	;	# 17 M_2pg_c --> M_h2o_c+M_pep_c
		0	100.0	;	# 18 M_h2o_c+M_pep_c --> M_2pg_c
		0	100.0	;	# 19 M_adp_c+M_pep_c --> M_atp_c+M_pyr_c
		0	100.0	;	# 20 M_atp_c+M_oaa_c --> M_adp_c+M_co2_c+M_pep_c
		0	100.0	;	# 21 M_co2_c+M_h2o_c+M_pep_c --> M_oaa_c+M_pi_c
		0	100.0	;	# 22 M_coa_c+M_nad_c+M_pyr_c --> M_accoa_c+M_co2_c+M_nadh_c+M_h_c
		0	100.0	;	# 23 M_atp_c+M_h2o_c+M_pyr_c --> M_amp_c+M_pep_c+M_pi_c
		0	100.0	;	# 24 M_g6p_c+M_nadp_c --> M_6pgl_c+M_h_c+M_nadph_c
		0	100.0	;	# 25 M_6pgl_c+M_h_c+M_nadph_c --> M_g6p_c+M_nadp_c
		0	100.0	;	# 26 M_6pgl_c+M_h2o_c --> M_6pgc_c
		0	100.0	;	# 27 M_6pgc_c+M_nadp_c --> M_co2_c+M_nadph_c+M_ru5p_D_c+M_h_c
		0	100.0	;	# 28 M_ru5p_D_c --> M_xu5p_D_c
		0	100.0	;	# 29 M_xu5p_D_c --> M_ru5p_D_c
		0	100.0	;	# 30 M_r5p_c --> M_ru5p_D_c
		0	100.0	;	# 31 M_ru5p_D_c --> M_r5p_c
		0	100.0	;	# 32 M_g3p_c+M_s7p_c --> M_e4p_c+M_f6p_c
		0	100.0	;	# 33 M_e4p_c+M_f6p_c --> M_g3p_c+M_s7p_c
		0	100.0	;	# 34 M_r5p_c+M_xu5p_D_c --> M_g3p_c+M_s7p_c
		0	100.0	;	# 35 M_g3p_c+M_s7p_c --> M_r5p_c+M_xu5p_D_c
		0	100.0	;	# 36 M_e4p_c+M_xu5p_D_c --> M_f6p_c+M_g3p_c
		0	100.0	;	# 37 M_f6p_c+M_g3p_c --> M_e4p_c+M_xu5p_D_c
		0	100.0	;	# 38 M_6pgc_c --> M_2ddg6p_c+M_h2o_c
		0	100.0	;	# 39 M_2ddg6p_c --> M_g3p_c+M_pyr_c
		0	100.0	;	# 40 M_accoa_c+M_h2o_c+M_oaa_c --> M_cit_c+M_coa_c
		0	100.0	;	# 41 M_cit_c --> M_icit_c
		0	100.0	;	# 42 M_icit_c --> M_cit_c
		0	100.0	;	# 43 M_icit_c+M_nadp_c --> M_akg_c+M_co2_c+M_nadph_c+M_h_c
		0	100.0	;	# 44 M_akg_c+M_co2_c+M_nadph_c+M_h_c --> M_icit_c+M_nadp_c
		0	100.0	;	# 45 M_akg_c+M_coa_c+M_nad_c --> M_co2_c+M_nadh_c+M_succoa_c+M_h_c
		0	100.0	;	# 46 M_adp_c+M_pi_c+M_succoa_c --> M_atp_c+M_coa_c+M_succ_c
		0	100.0	;	# 47 M_q8_c+M_succ_c --> M_fum_c+M_q8h2_c
		0	100.0	;	# 48 M_fum_c+M_mql8_c --> M_mqn8_c+M_succ_c
		0	100.0	;	# 49 M_fum_c+M_h2o_c --> M_mal_L_c
		0	100.0	;	# 50 M_mal_L_c --> M_fum_c+M_h2o_c
		0	100.0	;	# 51 M_mal_L_c+M_nad_c --> M_oaa_c+M_h_c+M_nadh_c
		0	100.0	;	# 52 M_oaa_c+M_h_c+M_nadh_c --> M_mal_L_c+M_nad_c
		0	100.0	;	# 53 M_akg_c+M_nadph_c+M_nh3_c+M_h_c --> M_glu_L_c+M_h2o_c+M_nadp_c
		0	100.0	;	# 54 M_glu_L_c+M_h2o_c+M_nadp_c --> M_akg_c+M_nadph_c+M_nh3_c+M_h_c
		0	100.0	;	# 55 M_glu_L_c+M_atp_c+M_nh3_c --> M_gln_L_c+M_adp_c+M_pi_c
		0	100.0	;	# 56 M_gln_L_c+M_akg_c+M_nadph_c+M_h_c --> 2.0*M_glu_L_c+M_nadp_c
		0	100.0	;	# 57 M_gln_L_c+M_h2o_c --> M_nh3_c+M_glu_L_c
		0	100.0	;	# 58 2.0*M_h_c+0.5*M_o2_c+M_q8h2_c --> M_h2o_c+M_q8_c+2.0*M_he_c
		0	100.0	;	# 59 2.0*M_h_c+M_mql8_c+0.5*M_o2_c --> M_h2o_c+M_mqn8_c+2.0*M_he_c
		0	100.0	;	# 60 M_adp_c+M_pi_c+4.0*M_he_c --> M_atp_c+4.0*M_h_c+M_h2o_c
		0	100.0	;	# 61 3.0*M_h_c+M_nadh_c+M_q8_c --> M_nad_c+M_q8h2_c+2.0*M_he_c
		0	100.0	;	# 62 M_nad_c+M_nadph_c --> M_nadh_c+M_nadp_c
		0	100.0	;	# 63 M_nadh_c+M_nadp_c+2.0*M_he_c --> 2.0*M_h_c+M_nad_c+M_nadph_c
		0	100.0	;	# 64 M_h_c+M_nadh_c+M_q8_c --> M_nad_c+M_q8h2_c
		0	100.0	;	# 65 M_h_c+M_mqn8_c+M_nadh_c --> M_mql8_c+M_nad_c
		0	100.0	;	# 66 M_ppi_c+M_h2o_c --> 2.0*M_pi_c
		0	100.0	;	# 67 M_icit_c --> M_glx_c+M_succ_c
		0	100.0	;	# 68 M_accoa_c+M_glx_c+M_h2o_c --> M_coa_c+M_mal_L_c
		0	100.0	;	# 69 M_mal_L_c+M_nad_c --> M_co2_c+M_nadh_c+M_pyr_c+M_h_c
		0	100.0	;	# 70 M_mal_L_c+M_nadp_c --> M_co2_c+M_nadph_c+M_pyr_c+M_h_c
		0	100.0	;	# 71 M_accoa_c+M_pi_c --> M_actp_c+M_coa_c
		0	100.0	;	# 72 M_actp_c+M_coa_c --> M_accoa_c+M_pi_c
		0	100.0	;	# 73 M_actp_c+M_adp_c --> M_ac_c+M_atp_c
		0	100.0	;	# 74 M_ac_c+M_atp_c --> M_actp_c+M_adp_c
		0	100.0	;	# 75 M_ac_c+M_atp_c+M_coa_c --> M_accoa_c+M_amp_c+M_ppi_c
		0	100.0	;	# 76 M_accoa_c+2.0*M_h_c+2.0*M_nadh_c --> M_coa_c+M_etoh_c+2.0*M_nad_c
		0	100.0	;	# 77 M_coa_c+M_etoh_c+2.0*M_nad_c --> M_accoa_c+2.0*M_h_c+2.0*M_nadh_c
		0	100.0	;	# 78 M_pyr_c+M_nadh_c+M_h_c --> M_lac_D_c+M_nad_c
		0	100.0	;	# 79 M_lac_D_c+M_nad_c --> M_pyr_c+M_nadh_c+M_h_c
		0	100.0	;	# 80 M_coa_c+M_pyr_c --> M_accoa_c+M_for_c
		0	100.0	;	# 81 M_atp_c+M_h2o_c --> M_adp_c+M_pi_c
		0	100.0	;	# 82 M_amp_c+M_atp_c --> 2.0*M_adp_c
		0	100.0	;	# 83 1.496*M_3pg_c+3.7478*M_accoa_c+59.81*M_atp_c+0.361*M_e4p_c+0.0709*M_f6p_c+0.129*M_g3p_c+0.205*M_g6p_c+0.2557*M_gln_L_c+4.9414*M_glu_L_c+59.81*M_h2o_c+3.547*M_nad_c+13.0279*M_nadph_c+1.7867*M_oaa_c+0.5191*M_pep_c+2.8328*M_pyr_c+0.8977*M_r5p_c --> 59.81*M_adp_c+4.1182*M_akg_c+3.7478*M_coa_c+59.81*M_h_c+3.547*M_nadh_c+13.0279*M_nadp_c+59.81*M_pi_c+M_bio_c
		0	100.0	;	# 84 M_o2_e --> M_o2_c
		0	100.0	;	# 85 M_co2_c --> M_co2_e
		0	100.0	;	# 86 M_h_c --> M_h_e
		0	100.0	;	# 87 M_h_e --> M_h_c
		0	100.0	;	# 88 M_h2o_e --> M_h2o_c
		0	100.0	;	# 89 M_h2o_c --> M_h2o_e
		0	100.0	;	# 90 M_pi_e --> M_pi_c
		0	100.0	;	# 91 M_pi_c --> M_pi_e
		0	100.0	;	# 92 M_nh3_e --> M_nh3_c
		0	100.0	;	# 93 M_nh3_c --> M_nh3_e
		0	100.0	;	# 94 M_glc_D_e --> []
		0	100.0	;	# 95 M_atp_c+M_gln_L_e+M_h2o_c --> M_adp_c+M_gln_L_c+M_pi_c
		0	100.0	;	# 96 M_glu_L_e --> []
		0	100.0	;	# 97 M_pyr_c --> M_pyr_e
		0	100.0	;	# 98 M_ac_c --> M_ac_e
		0	100.0	;	# 99 M_ac_e --> M_ac_c
		0	100.0	;	# 100 M_ac_e --> []
		0	100.0	;	# 101 M_lac_D_c --> M_lac_D_e
		0	100.0	;	# 102 M_succ_c --> M_succ_e
		0	100.0	;	# 103 M_mal_L_c --> M_mal_L_e
		0	100.0	;	# 104 M_fum_c --> M_fum_e
		0	100.0	;	# 105 M_etoh_c --> M_etoh_e
		0	100.0	;	# 106 M_etoh_e --> []
		0	100.0	;	# 107 M_for_c --> M_for_e
		0	100.0	;	# 108 M_for_e --> []
		0	100.0	;	# 109 M_bio_c --> M_bio_e
		0	100.0	;	# 110 M_bio_e --> []
		0	100.0	;	# 111 M_atp_c --> []
		0	100.0	;	# 112 [] --> M_adp_c
	];

	# Setup default species bounds array - 
	species_bounds_array = [
		0.0	0.0	;	# 1 M_13dpg_c
		0.0	0.0	;	# 2 M_2ddg6p_c
		0.0	0.0	;	# 3 M_2pg_c
		0.0	0.0	;	# 4 M_3pg_c
		0.0	0.0	;	# 5 M_6pgc_c
		0.0	0.0	;	# 6 M_6pgl_c
		0.0	0.0	;	# 7 M_ac_c
		0.0	0.0	;	# 8 M_accoa_c
		0.0	0.0	;	# 9 M_actp_c
		0.0	0.0	;	# 10 M_adp_c
		0.0	0.0	;	# 11 M_akg_c
		0.0	0.0	;	# 12 M_amp_c
		0.0	0.0	;	# 13 M_atp_c
		0.0	0.0	;	# 14 M_bio_c
		0.0	0.0	;	# 15 M_cit_c
		0.0	0.0	;	# 16 M_co2_c
		0.0	0.0	;	# 17 M_coa_c
		0.0	0.0	;	# 18 M_dhap_c
		0.0	0.0	;	# 19 M_e4p_c
		0.0	0.0	;	# 20 M_etoh_c
		0.0	0.0	;	# 21 M_f6p_c
		0.0	0.0	;	# 22 M_fdp_c
		0.0	0.0	;	# 23 M_for_c
		0.0	0.0	;	# 24 M_fum_c
		0.0	0.0	;	# 25 M_g3p_c
		0.0	0.0	;	# 26 M_g6p_c
		0.0	0.0	;	# 27 M_glc_D_c
		0.0	0.0	;	# 28 M_gln_L_c
		0.0	0.0	;	# 29 M_glu_L_c
		0.0	0.0	;	# 30 M_glx_c
		0.0	0.0	;	# 31 M_h2o_c
		0.0	0.0	;	# 32 M_h_c
		0.0	0.0	;	# 33 M_he_c
		0.0	0.0	;	# 34 M_icit_c
		0.0	0.0	;	# 35 M_lac_D_c
		0.0	0.0	;	# 36 M_mal_L_c
		0.0	0.0	;	# 37 M_mql8_c
		0.0	0.0	;	# 38 M_mqn8_c
		0.0	0.0	;	# 39 M_nad_c
		0.0	0.0	;	# 40 M_nadh_c
		0.0	0.0	;	# 41 M_nadp_c
		0.0	0.0	;	# 42 M_nadph_c
		0.0	0.0	;	# 43 M_nh3_c
		0.0	0.0	;	# 44 M_o2_c
		0.0	0.0	;	# 45 M_oaa_c
		0.0	0.0	;	# 46 M_pep_c
		0.0	0.0	;	# 47 M_pi_c
		0.0	0.0	;	# 48 M_ppi_c
		0.0	0.0	;	# 49 M_pyr_c
		0.0	0.0	;	# 50 M_q8_c
		0.0	0.0	;	# 51 M_q8h2_c
		0.0	0.0	;	# 52 M_r5p_c
		0.0	0.0	;	# 53 M_ru5p_D_c
		0.0	0.0	;	# 54 M_s7p_c
		0.0	0.0	;	# 55 M_succ_c
		0.0	0.0	;	# 56 M_succoa_c
		0.0	0.0	;	# 57 M_xu5p_D_c
		0.0	100.0	;	# 58 M_ac_e
		0.0	1.0	;	# 59 M_bio_e
		0.0	100.0	;	# 60 M_co2_e
		0.0	100.0	;	# 61 M_etoh_e
		0.0	100.0	;	# 62 M_for_e
		0.0	100.0	;	# 63 M_fum_e
		-2.5	0.0	;	# 64 M_glc_D_e
		0.0	00.0	;	# 65 M_gln_L_e
		0.0	00.0	;	# 66 M_glu_L_e
		-100.0	100.0	;	# 67 M_h2o_e
		-100.0	100.0	;	# 68 M_h_e
		0.0	100.0	;	# 69 M_lac_D_e
		0.0	100.0	;	# 70 M_mal_L_e
		-100.0	100.0	;	# 71 M_nh3_e
		-100.0	00.0	;	# 72 M_o2_e
		-100.0	100.0	;	# 73 M_pi_e
		0.0	100.0	;	# 74 M_pyr_e
		0.0	100.0	;	# 75 M_succ_e
	];

	# Setup the objective coefficient array - 
	objective_coefficient_array = [
		0.0	;	# 1 R_glk_hex::M_pep_c+M_glc_D_e --> M_pyr_c+M_g6p_c
		0.0	;	# 2 R_glk_atp::M_atp_c+M_glc_D_c --> M_adp_c+M_g6p_c
		0.0	;	# 3 R_pgi::M_g6p_c --> M_f6p_c
		0.0	;	# 4 R_pgi_reverse::M_f6p_c --> M_g6p_c
		0.0	;	# 5 R_pfk::M_atp_c+M_f6p_c --> M_adp_c+M_fdp_c
		0.0	;	# 6 R_fdp::M_fdp_c+M_h2o_c --> M_f6p_c+M_pi_c
		0.0	;	# 7 R_fbaA::M_fdp_c --> M_dhap_c+M_g3p_c
		0.0	;	# 8 R_fbaA_reverse::M_dhap_c+M_g3p_c --> M_fdp_c
		0.0	;	# 9 R_tpiA::M_dhap_c --> M_g3p_c
		0.0	;	# 10 R_tpiA_reverse::M_g3p_c --> M_dhap_c
		0.0	;	# 11 R_gapA::M_g3p_c+M_nad_c+M_pi_c --> M_13dpg_c+M_h_c+M_nadh_c
		0.0	;	# 12 R_gapA_reverse::M_13dpg_c+M_h_c+M_nadh_c --> M_g3p_c+M_nad_c+M_pi_c
		0.0	;	# 13 R_pgk::M_13dpg_c+M_adp_c --> M_3pg_c+M_atp_c
		0.0	;	# 14 R_pgk_reverse::M_3pg_c+M_atp_c --> M_13dpg_c+M_adp_c
		0.0	;	# 15 R_gpm::M_3pg_c --> M_2pg_c
		0.0	;	# 16 R_gpm_reverse::M_2pg_c --> M_3pg_c
		0.0	;	# 17 R_eno::M_2pg_c --> M_h2o_c+M_pep_c
		0.0	;	# 18 R_eno_reverse::M_h2o_c+M_pep_c --> M_2pg_c
		0.0	;	# 19 R_pyk::M_adp_c+M_pep_c --> M_atp_c+M_pyr_c
		0.0	;	# 20 R_pck::M_atp_c+M_oaa_c --> M_adp_c+M_co2_c+M_pep_c
		0.0	;	# 21 R_ppc::M_co2_c+M_h2o_c+M_pep_c --> M_oaa_c+M_pi_c
		0.0	;	# 22 R_pdh::M_coa_c+M_nad_c+M_pyr_c --> M_accoa_c+M_co2_c+M_nadh_c+M_h_c
		0.0	;	# 23 R_pps::M_atp_c+M_h2o_c+M_pyr_c --> M_amp_c+M_pep_c+M_pi_c
		0.0	;	# 24 R_zwf::M_g6p_c+M_nadp_c --> M_6pgl_c+M_h_c+M_nadph_c
		0.0	;	# 25 R_zwf_reverse::M_6pgl_c+M_h_c+M_nadph_c --> M_g6p_c+M_nadp_c
		0.0	;	# 26 R_pgl::M_6pgl_c+M_h2o_c --> M_6pgc_c
		0.0	;	# 27 R_gnd::M_6pgc_c+M_nadp_c --> M_co2_c+M_nadph_c+M_ru5p_D_c+M_h_c
		0.0	;	# 28 R_rpe::M_ru5p_D_c --> M_xu5p_D_c
		0.0	;	# 29 R_rpe_reverse::M_xu5p_D_c --> M_ru5p_D_c
		0.0	;	# 30 R_rpi::M_r5p_c --> M_ru5p_D_c
		0.0	;	# 31 R_rpi_reverse::M_ru5p_D_c --> M_r5p_c
		0.0	;	# 32 R_talAB::M_g3p_c+M_s7p_c --> M_e4p_c+M_f6p_c
		0.0	;	# 33 R_talAB_reverse::M_e4p_c+M_f6p_c --> M_g3p_c+M_s7p_c
		0.0	;	# 34 R_tkt1::M_r5p_c+M_xu5p_D_c --> M_g3p_c+M_s7p_c
		0.0	;	# 35 R_tkt1_reverse::M_g3p_c+M_s7p_c --> M_r5p_c+M_xu5p_D_c
		0.0	;	# 36 R_tkt2::M_e4p_c+M_xu5p_D_c --> M_f6p_c+M_g3p_c
		0.0	;	# 37 R_tkt2_reverse::M_f6p_c+M_g3p_c --> M_e4p_c+M_xu5p_D_c
		0.0	;	# 38 R_edd::M_6pgc_c --> M_2ddg6p_c+M_h2o_c
		0.0	;	# 39 R_eda::M_2ddg6p_c --> M_g3p_c+M_pyr_c
		0.0	;	# 40 R_gltA::M_accoa_c+M_h2o_c+M_oaa_c --> M_cit_c+M_coa_c
		0.0	;	# 41 R_acn::M_cit_c --> M_icit_c
		0.0	;	# 42 R_acn_reverse::M_icit_c --> M_cit_c
		0.0	;	# 43 R_icd::M_icit_c+M_nadp_c --> M_akg_c+M_co2_c+M_nadph_c+M_h_c
		0.0	;	# 44 R_icd_reverse::M_akg_c+M_co2_c+M_nadph_c+M_h_c --> M_icit_c+M_nadp_c
		0.0	;	# 45 R_sucAB::M_akg_c+M_coa_c+M_nad_c --> M_co2_c+M_nadh_c+M_succoa_c+M_h_c
		0.0	;	# 46 R_sucCD::M_adp_c+M_pi_c+M_succoa_c --> M_atp_c+M_coa_c+M_succ_c
		0.0	;	# 47 R_sdh::M_q8_c+M_succ_c --> M_fum_c+M_q8h2_c
		0.0	;	# 48 R_frd::M_fum_c+M_mql8_c --> M_mqn8_c+M_succ_c
		0.0	;	# 49 R_fum::M_fum_c+M_h2o_c --> M_mal_L_c
		0.0	;	# 50 R_fum_reverse::M_mal_L_c --> M_fum_c+M_h2o_c
		0.0	;	# 51 R_mdh::M_mal_L_c+M_nad_c --> M_oaa_c+M_h_c+M_nadh_c
		0.0	;	# 52 R_mdh_reverse::M_oaa_c+M_h_c+M_nadh_c --> M_mal_L_c+M_nad_c
		0.0	;	# 53 R_gdhA::M_akg_c+M_nadph_c+M_nh3_c+M_h_c --> M_glu_L_c+M_h2o_c+M_nadp_c
		0.0	;	# 54 R_gdhA_reverse::M_glu_L_c+M_h2o_c+M_nadp_c --> M_akg_c+M_nadph_c+M_nh3_c+M_h_c
		0.0	;	# 55 R_glnA::M_glu_L_c+M_atp_c+M_nh3_c --> M_gln_L_c+M_adp_c+M_pi_c
		0.0	;	# 56 R_gltBD::M_gln_L_c+M_akg_c+M_nadph_c+M_h_c --> 2.0*M_glu_L_c+M_nadp_c
		0.0	;	# 57 R_gln_deg::M_gln_L_c+M_h2o_c --> M_nh3_c+M_glu_L_c
		0.0	;	# 58 R_cyd::2.0*M_h_c+0.5*M_o2_c+M_q8h2_c --> M_h2o_c+M_q8_c+2.0*M_he_c
		0.0	;	# 59 R_app::2.0*M_h_c+M_mql8_c+0.5*M_o2_c --> M_h2o_c+M_mqn8_c+2.0*M_he_c
		0.0	;	# 60 R_atp::M_adp_c+M_pi_c+4.0*M_he_c --> M_atp_c+4.0*M_h_c+M_h2o_c
		0.0	;	# 61 R_nuo::3.0*M_h_c+M_nadh_c+M_q8_c --> M_nad_c+M_q8h2_c+2.0*M_he_c
		0.0	;	# 62 R_pnt1::M_nad_c+M_nadph_c --> M_nadh_c+M_nadp_c
		0.0	;	# 63 R_pnt2::M_nadh_c+M_nadp_c+2.0*M_he_c --> 2.0*M_h_c+M_nad_c+M_nadph_c
		0.0	;	# 64 R_ndh1::M_h_c+M_nadh_c+M_q8_c --> M_nad_c+M_q8h2_c
		0.0	;	# 65 R_ndh2::M_h_c+M_mqn8_c+M_nadh_c --> M_mql8_c+M_nad_c
		0.0	;	# 66 R_ppa::M_ppi_c+M_h2o_c --> 2.0*M_pi_c
		0.0	;	# 67 R_aceA::M_icit_c --> M_glx_c+M_succ_c
		0.0	;	# 68 R_aceB::M_accoa_c+M_glx_c+M_h2o_c --> M_coa_c+M_mal_L_c
		0.0	;	# 69 R_maeA::M_mal_L_c+M_nad_c --> M_co2_c+M_nadh_c+M_pyr_c+M_h_c
		0.0	;	# 70 R_maeB::M_mal_L_c+M_nadp_c --> M_co2_c+M_nadph_c+M_pyr_c+M_h_c
		0.0	;	# 71 R_pta::M_accoa_c+M_pi_c --> M_actp_c+M_coa_c
		0.0	;	# 72 R_pta_reverse::M_actp_c+M_coa_c --> M_accoa_c+M_pi_c
		0.0	;	# 73 R_ackA::M_actp_c+M_adp_c --> M_ac_c+M_atp_c
		0.0	;	# 74 R_ackA_reverse::M_ac_c+M_atp_c --> M_actp_c+M_adp_c
		0.0	;	# 75 R_acs::M_ac_c+M_atp_c+M_coa_c --> M_accoa_c+M_amp_c+M_ppi_c
		0.0	;	# 76 R_adhE::M_accoa_c+2.0*M_h_c+2.0*M_nadh_c --> M_coa_c+M_etoh_c+2.0*M_nad_c
		0.0	;	# 77 R_adhE_reverse::M_coa_c+M_etoh_c+2.0*M_nad_c --> M_accoa_c+2.0*M_h_c+2.0*M_nadh_c
		0.0	;	# 78 R_ldh::M_pyr_c+M_nadh_c+M_h_c --> M_lac_D_c+M_nad_c
		0.0	;	# 79 R_ldh_reverse::M_lac_D_c+M_nad_c --> M_pyr_c+M_nadh_c+M_h_c
		0.0	;	# 80 R_pflAB::M_coa_c+M_pyr_c --> M_accoa_c+M_for_c
		0.0	;	# 81 R_atp_adp::M_atp_c+M_h2o_c --> M_adp_c+M_pi_c
		0.0	;	# 82 R_adk_atp::M_amp_c+M_atp_c --> 2.0*M_adp_c
		-1.0	;	# 83 R_Biomass_Ecoli_core_w_GAM::1.496*M_3pg_c+3.7478*M_accoa_c+59.81*M_atp_c+0.361*M_e4p_c+0.0709*M_f6p_c+0.129*M_g3p_c+0.205*M_g6p_c+0.2557*M_gln_L_c+4.9414*M_glu_L_c+59.81*M_h2o_c+3.547*M_nad_c+13.0279*M_nadph_c+1.7867*M_oaa_c+0.5191*M_pep_c+2.8328*M_pyr_c+0.8977*M_r5p_c --> 59.81*M_adp_c+4.1182*M_akg_c+3.7478*M_coa_c+59.81*M_h_c+3.547*M_nadh_c+13.0279*M_nadp_c+59.81*M_pi_c+M_bio_c
		0.0	;	# 84 M_o2_c_exchange::M_o2_e --> M_o2_c
		0.0	;	# 85 M_co2_c_exchange::M_co2_c --> M_co2_e
		0.0	;	# 86 M_h_c_exchange::M_h_c --> M_h_e
		0.0	;	# 87 M_h_c_exchange_reverse::M_h_e --> M_h_c
		0.0	;	# 88 M_h2o_c_exchange::M_h2o_e --> M_h2o_c
		0.0	;	# 89 M_h2o_c_exchange_reverse::M_h2o_c --> M_h2o_e
		0.0	;	# 90 M_pi_c_exchange::M_pi_e --> M_pi_c
		0.0	;	# 91 M_pi_c_exchange_reverse::M_pi_c --> M_pi_e
		0.0	;	# 92 M_nh3_c_exchange::M_nh3_e --> M_nh3_c
		0.0	;	# 93 M_nh3_c_exchange_reverse::M_nh3_c --> M_nh3_e
		0.0	;	# 94 M_glc_D_c_exchange::M_glc_D_e --> []
		0.0	;	# 95 M_gln_L_c_exchange::M_atp_c+M_gln_L_e+M_h2o_c --> M_adp_c+M_gln_L_c+M_pi_c
		0.0	;	# 96 M_glu_L_c_exchange::M_glu_L_e --> []
		0.0	;	# 97 M_pyr_c_exchange::M_pyr_c --> M_pyr_e
		0.0	;	# 98 M_ac_c_exchange::M_ac_c --> M_ac_e
		0.0	;	# 99 M_ac_c_exchange_reverse::M_ac_e --> M_ac_c
		0.0	;	# 100 M_ac_e_disappear::M_ac_e --> []
		0.0	;	# 101 M_lac_D_c_exchange::M_lac_D_c --> M_lac_D_e
		0.0	;	# 102 M_succ_c_exchange::M_succ_c --> M_succ_e
		0.0	;	# 103 M_mal_L_c_exchange::M_mal_L_c --> M_mal_L_e
		0.0	;	# 104 M_fum_c_exchange::M_fum_c --> M_fum_e
		0.0	;	# 105 M_etoh_c_exchange::M_etoh_c --> M_etoh_e
		0.0	;	# 106 M_etoh_e_disappear::M_etoh_e --> []
		0.0	;	# 107 M_for_c_exchange::M_for_c --> M_for_e
		0.0	;	# 108 M_for_e_disappear::M_for_e --> []
		0.0	;	# 109 M_bio_exchange::M_bio_c --> M_bio_e
		0.0	;	# 110 M_bio_disappear::M_bio_e --> []
		0.0	;	# 111 M_atp_exchange::M_atp_c --> []
		0.0	;	# 112 M_adp_exchange::[] --> M_adp_c
	];

	# Min/Max flag - default is minimum - 
	is_minimum_flag = true

	# List of reation strings - used to write flux report 
	list_of_reaction_strings = [
		"R_glk_hex::M_pep_c+M_glc_D_e --> M_pyr_c+M_g6p_c"
		"R_glk_atp::M_atp_c+M_glc_D_c --> M_adp_c+M_g6p_c"
		"R_pgi::M_g6p_c --> M_f6p_c"
		"R_pgi_reverse::M_f6p_c --> M_g6p_c"
		"R_pfk::M_atp_c+M_f6p_c --> M_adp_c+M_fdp_c"
		"R_fdp::M_fdp_c+M_h2o_c --> M_f6p_c+M_pi_c"
		"R_fbaA::M_fdp_c --> M_dhap_c+M_g3p_c"
		"R_fbaA_reverse::M_dhap_c+M_g3p_c --> M_fdp_c"
		"R_tpiA::M_dhap_c --> M_g3p_c"
		"R_tpiA_reverse::M_g3p_c --> M_dhap_c"
		"R_gapA::M_g3p_c+M_nad_c+M_pi_c --> M_13dpg_c+M_h_c+M_nadh_c"
		"R_gapA_reverse::M_13dpg_c+M_h_c+M_nadh_c --> M_g3p_c+M_nad_c+M_pi_c"
		"R_pgk::M_13dpg_c+M_adp_c --> M_3pg_c+M_atp_c"
		"R_pgk_reverse::M_3pg_c+M_atp_c --> M_13dpg_c+M_adp_c"
		"R_gpm::M_3pg_c --> M_2pg_c"
		"R_gpm_reverse::M_2pg_c --> M_3pg_c"
		"R_eno::M_2pg_c --> M_h2o_c+M_pep_c"
		"R_eno_reverse::M_h2o_c+M_pep_c --> M_2pg_c"
		"R_pyk::M_adp_c+M_pep_c --> M_atp_c+M_pyr_c"
		"R_pck::M_atp_c+M_oaa_c --> M_adp_c+M_co2_c+M_pep_c"
		"R_ppc::M_co2_c+M_h2o_c+M_pep_c --> M_oaa_c+M_pi_c"
		"R_pdh::M_coa_c+M_nad_c+M_pyr_c --> M_accoa_c+M_co2_c+M_nadh_c+M_h_c"
		"R_pps::M_atp_c+M_h2o_c+M_pyr_c --> M_amp_c+M_pep_c+M_pi_c"
		"R_zwf::M_g6p_c+M_nadp_c --> M_6pgl_c+M_h_c+M_nadph_c"
		"R_zwf_reverse::M_6pgl_c+M_h_c+M_nadph_c --> M_g6p_c+M_nadp_c"
		"R_pgl::M_6pgl_c+M_h2o_c --> M_6pgc_c"
		"R_gnd::M_6pgc_c+M_nadp_c --> M_co2_c+M_nadph_c+M_ru5p_D_c+M_h_c"
		"R_rpe::M_ru5p_D_c --> M_xu5p_D_c"
		"R_rpe_reverse::M_xu5p_D_c --> M_ru5p_D_c"
		"R_rpi::M_r5p_c --> M_ru5p_D_c"
		"R_rpi_reverse::M_ru5p_D_c --> M_r5p_c"
		"R_talAB::M_g3p_c+M_s7p_c --> M_e4p_c+M_f6p_c"
		"R_talAB_reverse::M_e4p_c+M_f6p_c --> M_g3p_c+M_s7p_c"
		"R_tkt1::M_r5p_c+M_xu5p_D_c --> M_g3p_c+M_s7p_c"
		"R_tkt1_reverse::M_g3p_c+M_s7p_c --> M_r5p_c+M_xu5p_D_c"
		"R_tkt2::M_e4p_c+M_xu5p_D_c --> M_f6p_c+M_g3p_c"
		"R_tkt2_reverse::M_f6p_c+M_g3p_c --> M_e4p_c+M_xu5p_D_c"
		"R_edd::M_6pgc_c --> M_2ddg6p_c+M_h2o_c"
		"R_eda::M_2ddg6p_c --> M_g3p_c+M_pyr_c"
		"R_gltA::M_accoa_c+M_h2o_c+M_oaa_c --> M_cit_c+M_coa_c"
		"R_acn::M_cit_c --> M_icit_c"
		"R_acn_reverse::M_icit_c --> M_cit_c"
		"R_icd::M_icit_c+M_nadp_c --> M_akg_c+M_co2_c+M_nadph_c+M_h_c"
		"R_icd_reverse::M_akg_c+M_co2_c+M_nadph_c+M_h_c --> M_icit_c+M_nadp_c"
		"R_sucAB::M_akg_c+M_coa_c+M_nad_c --> M_co2_c+M_nadh_c+M_succoa_c+M_h_c"
		"R_sucCD::M_adp_c+M_pi_c+M_succoa_c --> M_atp_c+M_coa_c+M_succ_c"
		"R_sdh::M_q8_c+M_succ_c --> M_fum_c+M_q8h2_c"
		"R_frd::M_fum_c+M_mql8_c --> M_mqn8_c+M_succ_c"
		"R_fum::M_fum_c+M_h2o_c --> M_mal_L_c"
		"R_fum_reverse::M_mal_L_c --> M_fum_c+M_h2o_c"
		"R_mdh::M_mal_L_c+M_nad_c --> M_oaa_c+M_h_c+M_nadh_c"
		"R_mdh_reverse::M_oaa_c+M_h_c+M_nadh_c --> M_mal_L_c+M_nad_c"
		"R_gdhA::M_akg_c+M_nadph_c+M_nh3_c+M_h_c --> M_glu_L_c+M_h2o_c+M_nadp_c"
		"R_gdhA_reverse::M_glu_L_c+M_h2o_c+M_nadp_c --> M_akg_c+M_nadph_c+M_nh3_c+M_h_c"
		"R_glnA::M_glu_L_c+M_atp_c+M_nh3_c --> M_gln_L_c+M_adp_c+M_pi_c"
		"R_gltBD::M_gln_L_c+M_akg_c+M_nadph_c+M_h_c --> 2.0*M_glu_L_c+M_nadp_c"
		"R_gln_deg::M_gln_L_c+M_h2o_c --> M_nh3_c+M_glu_L_c"
		"R_cyd::2.0*M_h_c+0.5*M_o2_c+M_q8h2_c --> M_h2o_c+M_q8_c+2.0*M_he_c"
		"R_app::2.0*M_h_c+M_mql8_c+0.5*M_o2_c --> M_h2o_c+M_mqn8_c+2.0*M_he_c"
		"R_atp::M_adp_c+M_pi_c+4.0*M_he_c --> M_atp_c+4.0*M_h_c+M_h2o_c"
		"R_nuo::3.0*M_h_c+M_nadh_c+M_q8_c --> M_nad_c+M_q8h2_c+2.0*M_he_c"
		"R_pnt1::M_nad_c+M_nadph_c --> M_nadh_c+M_nadp_c"
		"R_pnt2::M_nadh_c+M_nadp_c+2.0*M_he_c --> 2.0*M_h_c+M_nad_c+M_nadph_c"
		"R_ndh1::M_h_c+M_nadh_c+M_q8_c --> M_nad_c+M_q8h2_c"
		"R_ndh2::M_h_c+M_mqn8_c+M_nadh_c --> M_mql8_c+M_nad_c"
		"R_ppa::M_ppi_c+M_h2o_c --> 2.0*M_pi_c"
		"R_aceA::M_icit_c --> M_glx_c+M_succ_c"
		"R_aceB::M_accoa_c+M_glx_c+M_h2o_c --> M_coa_c+M_mal_L_c"
		"R_maeA::M_mal_L_c+M_nad_c --> M_co2_c+M_nadh_c+M_pyr_c+M_h_c"
		"R_maeB::M_mal_L_c+M_nadp_c --> M_co2_c+M_nadph_c+M_pyr_c+M_h_c"
		"R_pta::M_accoa_c+M_pi_c --> M_actp_c+M_coa_c"
		"R_pta_reverse::M_actp_c+M_coa_c --> M_accoa_c+M_pi_c"
		"R_ackA::M_actp_c+M_adp_c --> M_ac_c+M_atp_c"
		"R_ackA_reverse::M_ac_c+M_atp_c --> M_actp_c+M_adp_c"
		"R_acs::M_ac_c+M_atp_c+M_coa_c --> M_accoa_c+M_amp_c+M_ppi_c"
		"R_adhE::M_accoa_c+2.0*M_h_c+2.0*M_nadh_c --> M_coa_c+M_etoh_c+2.0*M_nad_c"
		"R_adhE_reverse::M_coa_c+M_etoh_c+2.0*M_nad_c --> M_accoa_c+2.0*M_h_c+2.0*M_nadh_c"
		"R_ldh::M_pyr_c+M_nadh_c+M_h_c --> M_lac_D_c+M_nad_c"
		"R_ldh_reverse::M_lac_D_c+M_nad_c --> M_pyr_c+M_nadh_c+M_h_c"
		"R_pflAB::M_coa_c+M_pyr_c --> M_accoa_c+M_for_c"
		"R_atp_adp::M_atp_c+M_h2o_c --> M_adp_c+M_pi_c"
		"R_adk_atp::M_amp_c+M_atp_c --> 2.0*M_adp_c"
		"R_Biomass_Ecoli_core_w_GAM::1.496*M_3pg_c+3.7478*M_accoa_c+59.81*M_atp_c+0.361*M_e4p_c+0.0709*M_f6p_c+0.129*M_g3p_c+0.205*M_g6p_c+0.2557*M_gln_L_c+4.9414*M_glu_L_c+59.81*M_h2o_c+3.547*M_nad_c+13.0279*M_nadph_c+1.7867*M_oaa_c+0.5191*M_pep_c+2.8328*M_pyr_c+0.8977*M_r5p_c --> 59.81*M_adp_c+4.1182*M_akg_c+3.7478*M_coa_c+59.81*M_h_c+3.547*M_nadh_c+13.0279*M_nadp_c+59.81*M_pi_c+M_bio_c"
		"M_o2_c_exchange::M_o2_e --> M_o2_c"
		"M_co2_c_exchange::M_co2_c --> M_co2_e"
		"M_h_c_exchange::M_h_c --> M_h_e"
		"M_h_c_exchange_reverse::M_h_e --> M_h_c"
		"M_h2o_c_exchange::M_h2o_e --> M_h2o_c"
		"M_h2o_c_exchange_reverse::M_h2o_c --> M_h2o_e"
		"M_pi_c_exchange::M_pi_e --> M_pi_c"
		"M_pi_c_exchange_reverse::M_pi_c --> M_pi_e"
		"M_nh3_c_exchange::M_nh3_e --> M_nh3_c"
		"M_nh3_c_exchange_reverse::M_nh3_c --> M_nh3_e"
		"M_glc_D_c_exchange::M_glc_D_e --> []"
		"M_gln_L_c_exchange::M_atp_c+M_gln_L_e+M_h2o_c --> M_adp_c+M_gln_L_c+M_pi_c"
		"M_glu_L_c_exchange::M_glu_L_e --> []"
		"M_pyr_c_exchange::M_pyr_c --> M_pyr_e"
		"M_ac_c_exchange::M_ac_c --> M_ac_e"
		"M_ac_c_exchange_reverse::M_ac_e --> M_ac_c"
		"M_ac_e_disappear::M_ac_e --> []"
		"M_lac_D_c_exchange::M_lac_D_c --> M_lac_D_e"
		"M_succ_c_exchange::M_succ_c --> M_succ_e"
		"M_mal_L_c_exchange::M_mal_L_c --> M_mal_L_e"
		"M_fum_c_exchange::M_fum_c --> M_fum_e"
		"M_etoh_c_exchange::M_etoh_c --> M_etoh_e"
		"M_etoh_e_disappear::M_etoh_e --> []"
		"M_for_c_exchange::M_for_c --> M_for_e"
		"M_for_e_disappear::M_for_e --> []"
		"M_bio_exchange::M_bio_c --> M_bio_e"
		"M_bio_disappear::M_bio_e --> []"
		"M_atp_exchange::M_atp_c --> []"
		"M_adp_exchange::[] --> M_adp_c"
	];

	# List of metabolite strings - used to write flux report 
	list_of_metabolite_symbols = [
		"M_13dpg_c"
		"M_2ddg6p_c"
		"M_2pg_c"
		"M_3pg_c"
		"M_6pgc_c"
		"M_6pgl_c"
		"M_ac_c"
		"M_accoa_c"
		"M_actp_c"
		"M_adp_c"
		"M_akg_c"
		"M_amp_c"
		"M_atp_c"
		"M_bio_c"
		"M_cit_c"
		"M_co2_c"
		"M_coa_c"
		"M_dhap_c"
		"M_e4p_c"
		"M_etoh_c"
		"M_f6p_c"
		"M_fdp_c"
		"M_for_c"
		"M_fum_c"
		"M_g3p_c"
		"M_g6p_c"
		"M_glc_D_c"
		"M_gln_L_c"
		"M_glu_L_c"
		"M_glx_c"
		"M_h2o_c"
		"M_h_c"
		"M_he_c"
		"M_icit_c"
		"M_lac_D_c"
		"M_mal_L_c"
		"M_mql8_c"
		"M_mqn8_c"
		"M_nad_c"
		"M_nadh_c"
		"M_nadp_c"
		"M_nadph_c"
		"M_nh3_c"
		"M_o2_c"
		"M_oaa_c"
		"M_pep_c"
		"M_pi_c"
		"M_ppi_c"
		"M_pyr_c"
		"M_q8_c"
		"M_q8h2_c"
		"M_r5p_c"
		"M_ru5p_D_c"
		"M_s7p_c"
		"M_succ_c"
		"M_succoa_c"
		"M_xu5p_D_c"
		"M_ac_e"
		"M_bio_e"
		"M_co2_e"
		"M_etoh_e"
		"M_for_e"
		"M_fum_e"
		"M_glc_D_e"
		"M_gln_L_e"
		"M_glu_L_e"
		"M_h2o_e"
		"M_h_e"
		"M_lac_D_e"
		"M_mal_L_e"
		"M_nh3_e"
		"M_o2_e"
		"M_pi_e"
		"M_pyr_e"
		"M_succ_e"
	];

	# =============================== DO NOT EDIT BELOW THIS LINE ============================== #
	data_dictionary = Dict{AbstractString,Any}()
	data_dictionary["stoichiometric_matrix"] = stoichiometric_matrix
	data_dictionary["objective_coefficient_array"] = objective_coefficient_array
	data_dictionary["default_flux_bounds_array"] = default_bounds_array;
	data_dictionary["species_bounds_array"] = species_bounds_array
	data_dictionary["list_of_reaction_strings"] = list_of_reaction_strings
	data_dictionary["list_of_metabolite_symbols"] = list_of_metabolite_symbols
	data_dictionary["is_minimum_flag"] = is_minimum_flag
	# =============================== DO NOT EDIT ABOVE THIS LINE ============================== #
	return data_dictionary
end
