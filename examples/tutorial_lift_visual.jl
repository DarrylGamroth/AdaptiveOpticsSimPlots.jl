include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24, central_obstruction=0.0)
src = base_source()
zb = ZernikeBasis(tel, 6)
compute_zernike!(zb, tel)
basis = zb.modes[:, :, 1:4]
coeffs_true = [25e-9, -10e-9, 5e-9, 0.0]
apply_opd!(tel, combine_modes(basis, coeffs_true))

psf = copy(compute_psf!(tel, src; zero_padding=2))
det = Detector(noise=NoiseNone(), integration_time=1.0, qe=1.0, psf_sampling=2, binning=1)
diversity = zeros(eltype(tel.state.opd), size(tel.state.opd))
lift = LiFT(tel, src, basis, det; diversity_opd=diversity, iterations=3, numerical=false)
coeffs_fit = AdaptiveOpticsSim.reconstruct(lift, psf, collect(1:length(coeffs_true)); coeffs0=zeros(4))

plt_coeffs = Plots.plot(1:length(coeffs_true), coeffs_true .* 1e9; label="true",
    title="LiFT Coefficients", xlabel="mode", ylabel="nm")
Plots.plot!(plt_coeffs, 1:length(coeffs_fit), coeffs_fit .* 1e9; label="fit")

display(Plots.plot(
    aoplot(psf, PSF(); title="Input PSF"),
    plt_coeffs,
    layout=(1, 2),
    size=(900, 380),
))
