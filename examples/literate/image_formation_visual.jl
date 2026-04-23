# # Image Formation Visualization
#
# This example shows the basic plotting surface for telescope pupil, OPD, and
# PSF-like image arrays.

isdefined(@__MODULE__, :build_visual_optics) || include(joinpath(@__DIR__, "common.jl"))

state = build_visual_optics()

display(plot_pupil(state.tel))
display(plot_opd(state.tel))
display(plot_psf(fill(1.0, 16, 16)))
