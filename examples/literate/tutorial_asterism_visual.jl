# # Tutorial: Asterism
#
# This plotted counterpart wraps the maintained asterism tutorial and visualizes
# both the source geometry and the combined/per-source PSFs.

isdefined(@__MODULE__, :run_core_tutorial) || include(joinpath(@__DIR__, "common.jl"))

result = run_core_tutorial("asterism.jl")

coords = [(0.0, 0.0), (1.0, 0.0), (1.0, 120.0), (1.0, 240.0)]
θ = deg2rad.([coord[2] for coord in coords])
r = [coord[1] for coord in coords]
x = r .* cos.(θ)
y = r .* sin.(θ)

plt_sources = Plots.scatter(x, y;
    xlabel="arcsec x",
    ylabel="arcsec y",
    title="Asterism Geometry",
    aspect_ratio=:equal,
    label=nothing,
)

plots = Any[plt_sources, plot_psf(result.combined_psf; title="Combined PSF")]
for i in 1:min(size(result.per_source_psf, 3), 4)
    push!(plots, plot_psf(selectdim(result.per_source_psf, 3, i); title="Source $(i) PSF"))
end

display(Plots.plot(plots...; layout=(2, 3), size=(1100, 760)))
