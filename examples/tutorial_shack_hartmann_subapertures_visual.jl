include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24, central_obstruction=0.1)
src = base_source(magnitude=7.0)

zb = ZernikeBasis(tel, 4)
compute_zernike!(zb, tel)
@. tel.state.opd = 3e-8 * zb.modes[:, :, 4]

sh = ShackHartmann(tel; n_lenslets=6, mode=Diffractive(), pixel_scale=0.06, n_pix_subap=8)
prepare_runtime_wfs!(sh, tel, src)
slopes_data = copy(measure!(sh, tel, src))
detector_image = shack_hartmann_detector_image(sh)

layout = subaperture_layout(sh)
valid = valid_subaperture_indices(layout)
valid_linear = LinearIndices((sh.params.n_lenslets, sh.params.n_lenslets))[valid]

display(Plots.plot(
    aoplot(detector_image, DetectorFrame(); title="SH Detector Mosaic"),
    aoplot(sh, ShackHartmannDetectorFrame(); title="Log Spot Structure", stretch=:log10),
    aoplot(slopes_data, Signal(); title="SH Slopes"),
    aoplot(Float64.(valid_linear), Signal(); title="Valid Subaperture Indices", ylabel="linear index"),
    layout=(1, 4),
    size=(1600, 360),
))
