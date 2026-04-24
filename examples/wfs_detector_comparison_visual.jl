include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=48, central_obstruction=0.1)
src = base_source(magnitude=7.0)

zb = ZernikeBasis(tel, 5)
compute_zernike!(zb, tel)
@. tel.state.opd = 3e-8 * zb.modes[:, :, 4] + 2e-8 * zb.modes[:, :, 5]

n_subap = 6
pyramid = PyramidWFS(tel; n_subap=n_subap, mode=Diffractive(), modulation=1.0, diffraction_padding=2)
bioedge = BioEdgeWFS(tel; n_subap=n_subap, mode=Diffractive(), modulation=1.0, diffraction_padding=2)
zernike = ZernikeWFS(tel; n_subap=n_subap, diffraction_padding=2)
curvature = CurvatureWFS(tel; n_subap=n_subap, diffraction_padding=2)
shack_hartmann = ShackHartmann(tel; n_subap=n_subap, mode=Diffractive(), pixel_scale=0.06, n_pix_subap=8)

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
    aoplot(curvature, DetectorFrame(); title="Curvature Detector"),
    aoplot(shack_hartmann, DetectorFrame(); title="Shack-Hartmann Detector", gap=1),
    layout=(2, 3),
    size=(1200, 760),
))
