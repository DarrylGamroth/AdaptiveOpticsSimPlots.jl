# # Detector Visualization
#
# This example renders the exported detector frame using the maintained
# detector accessor surface.

isdefined(@__MODULE__, :build_visual_optics) || include(joinpath(@__DIR__, "common.jl"))

state = build_visual_detector()

display(plot_detector_frame(state.det))
display(plot_science_frame(state.frame))
