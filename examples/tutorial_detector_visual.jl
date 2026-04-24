include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24)
src = base_source()
psf = copy(compute_psf!(tel, src; zero_padding=2))

native = Detector(noise=NoiseNone(), integration_time=1.0, qe=1.0, psf_sampling=1, binning=1)
sampled = Detector(noise=NoiseNone(), integration_time=1.0, qe=1.0, psf_sampling=2, binning=2)

frame_native = copy(capture!(native, psf))
frame_sampled = copy(capture!(sampled, psf))

display(Plots.plot(
    aoplot(psf, PSF(); title="Input PSF"),
    aoplot(frame_native, DetectorFrame(); title="Native Sampling"),
    aoplot(frame_sampled, DetectorFrame(); title="Sampled + Binned"),
    layout=(1, 3),
    size=(1100, 360),
))
