include(joinpath(@__DIR__, "common.jl"))

function run_two_stage_atmosphere_change()
    rng = MersenneTwister(6)
    sim = AdaptiveOpticsSim.initialize_ao_shack_hartmann(
        resolution=32,
        diameter=8.0,
        sampling_time=1e-3,
        r0=0.2,
        L0=25.0,
        fractional_cn2=[1.0],
        wind_speed=[7.0],
        wind_direction=[10.0],
        altitude=[0.0],
        n_act=4,
        n_lenslets=4,
    )
    dm_coarse = DeformableMirror(sim.tel; n_act=2, influence_width=0.6)
    dm_fine = sim.optic
    imat_coarse = interaction_matrix(dm_coarse, sim.wfs, sim.tel; amplitude=0.1)
    imat_fine = interaction_matrix(dm_fine, sim.wfs, sim.tel; amplitude=0.1)
    recon_coarse = ModalReconstructor(imat_coarse; gain=0.3)
    recon_fine = ModalReconstructor(imat_fine; gain=0.5)
    cmd_coarse = similar(dm_coarse.state.coefs)
    cmd_fine = similar(dm_fine.state.coefs)
    residual = zeros(Float64, 6)
    r0_trace = fill(0.2, 6)
    current_atm = sim.atm

    for k in eachindex(residual)
        if k == 4
            current_atm = KolmogorovAtmosphere(sim.tel; r0=0.1, L0=25.0)
            r0_trace[k:end] .= 0.1
        end
        advance!(current_atm, sim.tel; rng=rng)
        propagate!(current_atm, sim.tel)
        apply!(dm_coarse, sim.tel, DMAdditive())
        apply!(dm_fine, sim.tel, DMAdditive())
        measure!(sim.wfs, sim.tel)
        residual[k] = pupil_rms(sim.tel.state.opd, sim.tel.state.pupil)
        reconstruct!(cmd_coarse, recon_coarse, sim.wfs.state.slopes)
        reconstruct!(cmd_fine, recon_fine, sim.wfs.state.slopes)
        dm_coarse.state.coefs .= -cmd_coarse
        dm_fine.state.coefs .= -cmd_fine
    end

    return residual, r0_trace, copy(dm_fine.state.coefs)
end

residual, r0_trace, fine_command = run_two_stage_atmosphere_change()

display(Plots.plot(
    aoplot(residual, Signal(); title="Residual With Atmosphere Change", ylabel="meters"),
    aoplot(r0_trace, Signal(); title="r0 Schedule", ylabel="meters"),
    aoplot(fine_command, Signal(); title="Fine DM Command"),
    layout=(1, 3),
    size=(1300, 360),
))
