include(joinpath(@__DIR__, "common.jl"))

result = run_closed_loop_example(
    (tel, n_lenslets) -> ShackHartmann(tel; n_lenslets=n_lenslets, mode=Diffractive(), pixel_scale=0.1, n_pix_subap=6);
    n_iter=8,
)

display(Plots.plot(
    aoplot(
        (residual_before=result.residual_before, residual_after=result.residual_after), RuntimeTimeseries();
        title="Residual RMS",
        ylabel="meters",
    ),
    aoplot(result.final_slopes, Signal(); title="Final SH Slopes", ylabel="signal"),
    aoplot(result.final_psf, PSF(); title="Final PSF"),
    layout=(1, 3),
    size=(1300, 360),
))
