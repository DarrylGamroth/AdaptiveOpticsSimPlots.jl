# # Wavefront Sensor Visualization
#
# This example shows both a camera-backed WFS frame and a signal-only WFS
# fallback.

isdefined(@__MODULE__, :build_visual_optics) || include(joinpath(@__DIR__, "common.jl"))

state = build_visual_wfs()

display(plot_wfs_frame(state.pyr))
display(aoplot(state.pyr; kind=:signal))
display(aoplot(state.sh; kind=:signal))
