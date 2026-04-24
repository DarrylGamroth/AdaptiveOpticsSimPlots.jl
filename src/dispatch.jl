"""
aoplot(obj, selector; kwargs...) -> Plots.Plot

Render an `AdaptiveOpticsSim.jl` object or array using a dispatchable plot
selector such as `Pupil()`, `OPD()`, `PSF()`, `WFSFrame()`, `Commands()`, or
`Signal()`.

`AdaptiveOpticsSimPlots.jl` intentionally exposes this package-owned function
instead of extending `Plots.plot` for simulation types.
"""
function aoplot end

aoplot(tel::AdaptiveOpticsSim.AbstractTelescope, ::Pupil; kwargs...) = _pupil_figure(tel; kwargs...)
aoplot(tel::AdaptiveOpticsSim.AbstractTelescope, ::OPD; kwargs...) = _opd_figure(tel; kwargs...)

aoplot(mask::AbstractMatrix, ::Pupil; kwargs...) = _pupil_figure(mask; kwargs...)
aoplot(opd::AbstractMatrix, ::OPD; kwargs...) = _opd_figure(opd; kwargs...)
aoplot(psf::AbstractMatrix, ::PSF; kwargs...) = _psf_figure(psf; kwargs...)
aoplot(frame::AbstractMatrix, ::ScienceFrame; kwargs...) = _science_frame_figure(frame; kwargs...)
aoplot(frame::AbstractMatrix, ::DetectorFrame; kwargs...) = _detector_frame_figure(frame; kwargs...)
aoplot(frame::AbstractMatrix, ::WFSFrame; kwargs...) = _wfs_frame_figure(frame; kwargs...)

aoplot(det::AdaptiveOpticsSim.AbstractDetector, ::DetectorFrame; kwargs...) = _detector_frame_figure(det; kwargs...)

aoplot(signal::AbstractVector, ::Signal; kwargs...) = _signal_trace_figure(signal; kwargs...)

aoplot(log::NamedTuple, ::RuntimeTimeseries; kwargs...) = _runtime_timeseries_figure(log; kwargs...)
aoplot(log::AbstractVector{<:NamedTuple}, ::RuntimeTimeseries; kwargs...) = _runtime_timeseries_figure(log; kwargs...)

aoplot(wfs::AdaptiveOpticsSim.AbstractWFS, ::WFSFrame; kwargs...) = _wfs_frame_figure(wfs; kwargs...)
aoplot(wfs::AdaptiveOpticsSim.AbstractWFS, ::DetectorFrame; kwargs...) = _wfs_detector_frame_figure(wfs; kwargs...)
aoplot(wfs::AdaptiveOpticsSim.AbstractWFS, ::Signal; kwargs...) =
    _signal_trace_figure(AdaptiveOpticsSim.slopes(wfs); title="WFS Signal", kwargs...)

aoplot(wfs::AdaptiveOpticsSim.ShackHartmann, ::WFSFrame; kwargs...) =
    _shack_hartmann_detector_frame_figure(wfs; kwargs...)
aoplot(wfs::AdaptiveOpticsSim.ShackHartmann, ::DetectorFrame; kwargs...) =
    _shack_hartmann_detector_frame_figure(wfs; kwargs...)
aoplot(wfs::AdaptiveOpticsSim.ShackHartmann, ::ShackHartmannDetectorFrame; kwargs...) =
    _shack_hartmann_detector_frame_figure(wfs; kwargs...)

aoplot(dm::AdaptiveOpticsSim.AbstractDeformableMirror, ::Commands; kwargs...) = _dm_commands_figure(dm; kwargs...)
aoplot(dm::AdaptiveOpticsSim.AbstractDeformableMirror, ::OPD; kwargs...) = _dm_opd_figure(dm; kwargs...)

aoplot(optic::AdaptiveOpticsSim.AbstractControllableOptic, ::Signal; kwargs...) =
    _signal_trace_figure(AdaptiveOpticsSim.command_storage(optic); title="Control Signal", kwargs...)
aoplot(optic::AdaptiveOpticsSim.AbstractControllableOptic, ::OPD; kwargs...) =
    _opd_figure(AdaptiveOpticsSim.surface_opd(optic); title="Controllable Optic OPD", kwargs...)

const _RuntimeLike = Union{
    AdaptiveOpticsSim.AbstractControlSimulation,
    AdaptiveOpticsSim.ClosedLoopRuntime,
    AdaptiveOpticsSim.SimulationInterface,
    AdaptiveOpticsSim.CompositeSimulationInterface,
    AdaptiveOpticsSim.SimulationReadout,
}

aoplot(x::_RuntimeLike, ::WFSFrame; kwargs...) = _wfs_frame_figure(x; kwargs...)
aoplot(x::_RuntimeLike, ::ScienceFrame; kwargs...) = _science_frame_figure(x; kwargs...)
aoplot(x::_RuntimeLike, ::Signal; kwargs...) =
    _signal_trace_figure(AdaptiveOpticsSim.slopes(x); title="Runtime Signal", kwargs...)
