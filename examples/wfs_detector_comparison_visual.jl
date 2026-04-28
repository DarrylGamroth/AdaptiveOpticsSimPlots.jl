include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=64, central_obstruction=0.1)
src = base_source(magnitude=7.0)

zb = ZernikeBasis(tel, 5)
compute_zernike!(zb, tel)
@. tel.state.opd = 3e-8 * zb.modes[:, :, 4] + 2e-8 * zb.modes[:, :, 5]

# These choices target realistic detector-frame sizes for the visual comparison.
# `n_lenslets` is specific to SH-WFS; pupil-plane sensors use `pupil_samples`.
pyramid = PyramidWFS(tel; pupil_samples=32, mode=Diffractive(), modulation=1.0, diffraction_padding=2)
bioedge = BioEdgeWFS(tel; pupil_samples=16, mode=Diffractive(), modulation=1.0, diffraction_padding=2)
zernike = ZernikeWFS(tel; pupil_samples=64, diffraction_padding=2)
curvature = CurvatureWFS(tel; pupil_samples=8, diffraction_padding=2, readout_pixels_per_sample=8)
shack_hartmann = ShackHartmannWFS(tel; n_lenslets=8, mode=Diffractive(), pixel_scale=0.06, n_pix_subap=16)

measure!(pyramid, tel, src)
measure!(bioedge, tel, src)
measure!(zernike, tel, src)
measure!(curvature, tel, src)
prepare_runtime_wfs!(shack_hartmann, tel, src)
measure!(shack_hartmann, tel, src)

display(Plots.plot(
    aoplot(tel, OPD(); title="Input Wavefront"),
    aoplot(pyramid, DetectorFrame(); title="Pyramid Detector"),
    aoplot(bioedge, DetectorFrame(); title="BioEdge Detector"),
    aoplot(zernike, DetectorFrame(); title="Zernike Detector"),
    aoplot(curvature, DetectorFrame(); title="Curvature Detector (2 x 64 x 64)"),
    aoplot(shack_hartmann, DetectorFrame(); title="Shack-Hartmann Detector (128 x 128)"),
    layout=(2, 3),
    size=(1200, 760),
))
