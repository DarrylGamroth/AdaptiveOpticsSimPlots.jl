include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=48, central_obstruction=0.1)
src = base_source(magnitude=7.0)

zb = ZernikeBasis(tel, 4)
compute_zernike!(zb, tel)
@. tel.state.opd = 3e-8 * zb.modes[:, :, 4]

sh = ShackHartmannWFS(tel; n_lenslets=6, mode=Diffractive(), pixel_scale=0.06, n_pix_subap=10)
prepare_runtime_wfs!(sh, tel, src)
slopes_data = copy(measure!(sh, tel, src))

display(Plots.plot(
    aoplot(sh, DetectorFrame(); title="Detector Scale", stretch=:linear),
    aoplot(sh, DetectorFrame(); title="Log Diagnostic", stretch=:log10),
    aoplot(slopes_data, Signal(); title="SH Slopes"),
    layout=(1, 3),
    size=(1200, 360),
))
