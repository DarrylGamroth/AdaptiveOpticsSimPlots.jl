ENV["GKSwstype"] = get(ENV, "GKSwstype", "100")

using Test
using AdaptiveOpticsSim
using AdaptiveOpticsSimPlots
using Plots

@testset "AdaptiveOpticsSimPlots" begin
    tel = Telescope(resolution=16, diameter=8.0, sampling_time=1e-3, central_obstruction=0.0)
    tel.state.opd .= reshape(range(-1.0, 1.0; length=16 * 16), 16, 16)
    src = Source(band=:I, magnitude=0.0)
    dm = DeformableMirror(tel; n_act=4, influence_width=0.3)
    dm.state.coefs .= range(-0.2, 0.2; length=length(dm.state.coefs))
    apply_opd!(dm, tel)

    det = Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1)
    det_frame = capture!(det, fill(1.0, 8, 8))
    @test size(det_frame) == (8, 8)

    pyr = PyramidWFS(tel; n_subap=4, mode=Diffractive(), modulation=1.0)
    measure!(pyr, tel, src)

    plt_pupil = plot_pupil(tel)
    plt_opd = plot_opd(tel)
    plt_psf = plot_psf(fill(1.0, 8, 8))
    plt_science = plot_science_frame(fill(1.0, 8, 8))
    plt_detector = plot_detector_frame(det)
    plt_wfs = plot_wfs_frame(pyr)
    plt_dm = plot_dm_commands(dm)
    plt_dm_opd = plot_dm_opd(dm)
    plt_signal = plot_signal_trace(collect(1.0:8.0))
    plt_runtime_named = plot_runtime_timeseries((residual=collect(1.0:5.0), strehl=collect(5.0:-1.0:1.0)))
    plt_runtime_log = plot_runtime_timeseries([(residual=i, strehl=6 - i) for i in 1:5])

    @test plt_pupil isa Plots.Plot
    @test plt_opd isa Plots.Plot
    @test plt_psf isa Plots.Plot
    @test plt_science isa Plots.Plot
    @test plt_detector isa Plots.Plot
    @test plt_wfs isa Plots.Plot
    @test plt_dm isa Plots.Plot
    @test plt_dm_opd isa Plots.Plot
    @test plt_signal isa Plots.Plot
    @test plt_runtime_named isa Plots.Plot
    @test plt_runtime_log isa Plots.Plot

    @test aoplot(tel) isa Plots.Plot
    @test aoplot(tel; surface=:opd) isa Plots.Plot
    @test aoplot(det) isa Plots.Plot
    @test aoplot(pyr) isa Plots.Plot
    @test aoplot(pyr; kind=:signal) isa Plots.Plot
    @test aoplot(dm) isa Plots.Plot
    @test aoplot(dm; kind=:opd) isa Plots.Plot
    @test aoplot(collect(1.0:4.0)) isa Plots.Plot

    sampled_topology = SampledActuatorTopology(actuator_coordinates(dm)[:, 1:4];
        metadata=(manufacturer=:alpao,))
    measured_modes = Array(dm.state.modes[:, 1:4])
    sampled_dm = DeformableMirror(tel; topology=sampled_topology,
        influence_model=MeasuredInfluenceFunctions(measured_modes))
    sampled_dm.state.coefs .= [0.1, -0.2, 0.3, -0.4]
    @test plot_dm_commands(sampled_dm) isa Plots.Plot

    atm = KolmogorovAtmosphere(tel; r0=0.2, L0=25.0)
    runtime_sim = AOSimulation(tel, src, atm, dm, pyr)
    runtime_branch = RuntimeBranch(
        :main,
        runtime_sim,
        NullReconstructor();
        wfs_detector=Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1),
        science_detector=Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1),
    )
    runtime_cfg = SingleRuntimeConfig(products=RuntimeProductRequirements(
        slopes=true,
        wfs_pixels=true,
        science_pixels=true,
    ))
    runtime_scenario = build_runtime_scenario(runtime_cfg, runtime_branch)
    prepare!(runtime_scenario)
    @test aoplot(runtime_scenario) isa Plots.Plot
    @test aoplot(runtime_scenario; surface=:science) isa Plots.Plot
    @test aoplot(runtime_scenario; surface=:signal) isa Plots.Plot

    @test_throws ArgumentError plot_wfs_frame(ShackHartmann(tel; n_subap=4))
    @test_throws ArgumentError aoplot(tel; surface=:bad)
    @test_throws ArgumentError aoplot(dm; kind=:bad)
end
