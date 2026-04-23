# # Tutorial: Spatial Filter
#
# This plotted counterpart wraps the maintained spatial-filter tutorial and
# visualizes the filtered phase and amplitude.

isdefined(@__MODULE__, :run_core_tutorial) || include(joinpath(@__DIR__, "common.jl"))

result = run_core_tutorial("spatial_filter.jl")

display(Plots.plot(
    plot_opd(result.filtered_phase; title="Filtered Phase"),
    plot_pupil(abs2.(result.filtered_amplitude); title="Filtered Amplitude"),
    layout=(1, 2),
    size=(900, 380),
))
