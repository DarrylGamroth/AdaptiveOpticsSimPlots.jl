include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24, central_obstruction=0.0)
src = base_source(magnitude=6.0)
model = GaussianDiskSourceModel(sigma_arcsec=0.4, n_side=5)
ext = with_extended_source(src, model)

zb = ZernikeBasis(tel, 5)
compute_zernike!(zb, tel)
@. tel.state.opd = 5e-8 * zb.modes[:, :, 5]

sh_point = ShackHartmannWFS(tel; n_lenslets=6, mode=Diffractive())
sh_ext = ShackHartmannWFS(tel; n_lenslets=6, mode=Diffractive())
point_peak = AdaptiveOpticsSim.sampled_spots_peak!(sh_point, tel, src)
ext_peak = AdaptiveOpticsSim.sampled_spots_peak!(sh_ext, tel, ext)
point_slopes = copy(measure!(sh_point, tel, src))
ext_slopes = copy(measure!(sh_ext, tel, ext))
spot_delta = dropdims(sum(sh_ext.state.spot_cube .- sh_point.state.spot_cube; dims=3), dims=3)

pyr_point = PyramidWFS(tel; pupil_samples=6, mode=Diffractive(), modulation=1.0)
pyr_ext = PyramidWFS(tel; pupil_samples=6, mode=Diffractive(), modulation=1.0)
pyr_point_slopes = copy(measure!(pyr_point, tel, src))
pyr_ext_slopes = copy(measure!(pyr_ext, tel, ext))

display(Plots.plot(
    aoplot(spot_delta, DetectorFrame(); title="SH Spot Delta"),
    aoplot(ext_slopes .- point_slopes, Signal(); title="SH Slope Delta"),
    aoplot(pyr_ext_slopes .- pyr_point_slopes, Signal(); title="Pyramid Signal Delta"),
    layout=(1, 3),
    size=(1300, 360),
))

@info "Extended-source samples" n_samples=length(extended_source_asterism(ext)) point_peak ext_peak
