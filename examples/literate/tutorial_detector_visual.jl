# # Tutorial: Detector
#
# This plotted counterpart wraps the maintained core detector tutorial and
# visualizes the input PSF plus two detector sampling paths.

isdefined(@__MODULE__, :run_core_tutorial) || include(joinpath(@__DIR__, "common.jl"))

result = run_core_tutorial("detector.jl")

display(Plots.plot(
    plot_psf(result.psf; title="Input PSF"),
    plot_detector_frame(result.frame_native; title="Native Sampling"),
    plot_detector_frame(result.frame_sampled; title="Sampled + Binned"),
    layout=(1, 3),
    size=(1100, 360),
))
