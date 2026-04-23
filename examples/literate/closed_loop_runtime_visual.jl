# # Closed-Loop Runtime Visualization
#
# This example uses the maintained runtime boundary and plots WFS pixels,
# science pixels, and runtime signals.

isdefined(@__MODULE__, :build_visual_optics) || include(joinpath(@__DIR__, "common.jl"))

state = build_visual_runtime()

display(aoplot(state.scenario))
display(aoplot(state.scenario; surface=:science))
display(aoplot(state.scenario; surface=:signal))
