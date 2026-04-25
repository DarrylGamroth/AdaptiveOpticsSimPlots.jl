include(joinpath(@__DIR__, "common.jl"))

function cartesian_basis(tel::Telescope, n_modes::Int)
    n = tel.params.resolution
    basis = zeros(Float64, n, n, n_modes)
    x = collect(range(-1.0, 1.0; length=n + 1))[1:n]
    y = collect(range(-1.0, 1.0; length=n + 1))[1:n]
    @inbounds for j in 1:n, i in 1:n
        px = x[i]
        py = y[j]
        pupil = tel.state.pupil[i, j] ? 1.0 : 0.0
        if n_modes >= 1
            basis[i, j, 1] = pupil * px
        end
        if n_modes >= 2
            basis[i, j, 2] = pupil * py
        end
        if n_modes >= 3
            basis[i, j, 3] = pupil * px * py
        end
        if n_modes >= 4
            basis[i, j, 4] = pupil * (px * px - py * py)
        end
    end
    return basis
end

tel = base_telescope(resolution=24, central_obstruction=0.0)
src = base_source(band=:R, magnitude=8.0)
wfs = PyramidWFS(tel; pupil_samples=4, mode=Diffractive(), threshold=0.5, modulation=3.0,
    normalization=IncidenceFluxNormalization(),
    modulation_points=8, diffraction_padding=2, n_pix_separation=2, n_pix_edge=1)
basis = cartesian_basis(tel, 4)
gsc = GainSensingCamera(wfs.state.pyramid_mask, basis)

calibration_frame = similar(wfs.state.intensity)
reset_opd!(tel)
pyramid_modulation_frame!(calibration_frame, wfs, tel, src)
calibrate!(gsc, calibration_frame)

coeffs = [20e-9, -12e-9, 8e-9, 0.0]
apply_opd!(tel, combine_modes(basis, coeffs))
frame = similar(calibration_frame)
pyramid_modulation_frame!(frame, wfs, tel, src)
optical_gains = copy(compute_optical_gains!(gsc, frame))

display(Plots.plot(
    aoplot(calibration_frame, WFSFrame(); title="Calibration Frame"),
    aoplot(frame, WFSFrame(); title="Aberrated Frame"),
    aoplot(optical_gains, Signal(); title="Optical Gains", ylabel="gain"),
    layout=(1, 3),
    size=(1300, 360),
))
