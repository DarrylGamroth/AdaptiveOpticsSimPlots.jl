include(joinpath(@__DIR__, "common.jl"))

rng = tutorial_rng(5)
tel = base_telescope(resolution=16, central_obstruction=0.0)
src = base_source()
atm = base_atmosphere(tel)
dm = DeformableMirror(tel; n_act=3, influence_width=0.35)
wfs = ZernikeWFS(tel; pupil_samples=4, diffraction_padding=2)
det = Detector(noise=NoiseNone(), integration_time=1.0, qe=1.0, binning=1)
sim = AOSimulation(tel, src, atm, dm, wfs)
imat = interaction_matrix(dm, wfs, tel, src; amplitude=1e-8)
recon = ModalReconstructor(imat; gain=0.4)
branch = ControlLoopBranch(:main, sim, recon; rng=rng, wfs_detector=det)
cfg = SingleControlLoopConfig(
    name=:tutorial_closed_loop_zernike,
    branch_label=:main,
    outputs=RuntimeOutputRequirements(slopes=true, wfs_pixels=true),
)
scenario = build_control_loop_scenario(cfg, branch)
prepare!(scenario)

n_iter = 6
residual_before = zeros(Float64, n_iter)
residual_after = similar(residual_before)
for k in 1:n_iter
    residual_before[k] = pupil_rms(tel.state.opd, tel.state.pupil)
    step!(scenario)
    residual_after[k] = pupil_rms(tel.state.opd, tel.state.pupil)
end

rt = readout(scenario)
display(Plots.plot(
    aoplot((residual_before=residual_before, residual_after=residual_after), RuntimeTimeseries();
        title="Residual RMS", ylabel="meters"),
    aoplot(wfs_frame(rt), WFSFrame(); title="Zernike WFS Frame"),
    aoplot(slopes(rt), Signal(); title="Zernike WFS Signal"),
    layout=(1, 3),
    size=(1300, 360),
))
