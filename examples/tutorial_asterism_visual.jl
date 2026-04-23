include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24, fov_arcsec=4.0)
sources = (
    base_source(coordinates=(0.0, 0.0)),
    base_source(coordinates=(1.0, 0.0)),
    base_source(coordinates=(1.0, 120.0)),
    base_source(coordinates=(1.0, 240.0)),
)
asterism = Asterism(collect(sources))
combined_psf = copy(compute_psf!(tel, asterism; zero_padding=2))
per_source_psf = copy(tel.state.psf_stack)

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

plots = Any[plt_sources, plot_psf(combined_psf; title="Combined PSF")]
for i in 1:min(size(per_source_psf, 3), 4)
    push!(plots, plot_psf(selectdim(per_source_psf, 3, i); title="Source $(i) PSF"))
end

display(Plots.plot(plots...; layout=(2, 3), size=(1100, 760)))
