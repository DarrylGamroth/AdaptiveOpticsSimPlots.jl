# # Tutorial: Image Formation
#
# This plotted counterpart wraps the maintained core tutorial and visualizes the
# nominal and aberrated PSFs side by side.

isdefined(@__MODULE__, :run_core_tutorial) || include(joinpath(@__DIR__, "common.jl"))

result = run_core_tutorial("image_formation.jl")

display(Plots.plot(
    plot_psf(result.psf_nominal; title="Nominal PSF"),
    plot_psf(result.psf_aberrated; title="Aberrated PSF"),
    layout=(1, 2),
    size=(900, 380),
))
