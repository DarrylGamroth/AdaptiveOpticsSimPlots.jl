include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=32)
src = base_source()
psf_nominal = copy(compute_psf!(tel, src; zero_padding=2))

zb = ZernikeBasis(tel, 12)
compute_zernike!(zb, tel)
apply_opd!(tel, zb.modes[:, :, 6] .* 80e-9)
psf_aberrated = copy(compute_psf!(tel, src; zero_padding=2))

display(Plots.plot(
    plot_psf(psf_nominal; title="Nominal PSF"),
    plot_psf(psf_aberrated; title="Aberrated PSF"),
    layout=(1, 2),
    size=(900, 380),
))
