function aoplot end

function aoplot(tel::AdaptiveOpticsSim.AbstractTelescope; surface::Symbol=:pupil, kwargs...)
    if surface === :pupil
        return plot_pupil(tel; kwargs...)
    elseif surface === :opd
        return plot_opd(tel; kwargs...)
    else
        throw(ArgumentError("unsupported telescope surface $(repr(surface)); expected :pupil or :opd"))
    end
end

aoplot(det::AdaptiveOpticsSim.AbstractDetector; kwargs...) = plot_detector_frame(det; kwargs...)
aoplot(signal::AbstractVector; kwargs...) = plot_signal_trace(signal; kwargs...)

function aoplot(wfs::AdaptiveOpticsSim.AbstractWFS; kind::Symbol=:frame, kwargs...)
    if kind === :frame
        return plot_wfs_frame(wfs; kwargs...)
    elseif kind === :signal
        return plot_signal_trace(AdaptiveOpticsSim.slopes(wfs); title="WFS Signal", kwargs...)
    else
        throw(ArgumentError("unsupported WFS kind $(repr(kind)); expected :frame or :signal"))
    end
end

function aoplot(dm::AdaptiveOpticsSim.AbstractDeformableMirror; kind::Symbol=:commands, kwargs...)
    if kind === :commands
        return plot_dm_commands(dm; kwargs...)
    elseif kind === :opd
        return plot_dm_opd(dm; kwargs...)
    else
        throw(ArgumentError("unsupported DM kind $(repr(kind)); expected :commands or :opd"))
    end
end

function aoplot(optic::AdaptiveOpticsSim.AbstractControllableOptic; kind::Symbol=:signal, kwargs...)
    if kind === :signal
        return plot_signal_trace(AdaptiveOpticsSim.command_storage(optic); title="Control Signal", kwargs...)
    elseif kind === :opd
        return plot_opd(AdaptiveOpticsSim.surface_opd(optic); title="Controllable Optic OPD", kwargs...)
    else
        throw(ArgumentError("unsupported controllable-optic kind $(repr(kind)); expected :signal or :opd"))
    end
end

function aoplot(x::Union{
        AdaptiveOpticsSim.AbstractControlSimulation,
        AdaptiveOpticsSim.ClosedLoopRuntime,
        AdaptiveOpticsSim.SimulationInterface,
        AdaptiveOpticsSim.CompositeSimulationInterface,
        AdaptiveOpticsSim.SimulationReadout,
    }; surface::Symbol=:wfs, kwargs...)
    if surface === :wfs
        return plot_wfs_frame(x; kwargs...)
    elseif surface === :science
        return plot_science_frame(x; kwargs...)
    elseif surface === :signal
        return plot_signal_trace(AdaptiveOpticsSim.slopes(x); title="Runtime Signal", kwargs...)
    else
        throw(ArgumentError("unsupported runtime surface $(repr(surface)); expected :wfs, :science, or :signal"))
    end
end
