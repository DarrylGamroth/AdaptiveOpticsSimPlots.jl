_dm_commands_figure(dm::AdaptiveOpticsSim.AbstractDeformableMirror; kwargs...) =
    _dm_commands_figure(AdaptiveOpticsSim.topology(dm), AdaptiveOpticsSim.command_storage(dm); kwargs...)

function _dm_commands_figure(topology::AdaptiveOpticsSim.ActuatorGridTopology, command::AbstractVector;
    title::AbstractString="DM Commands", kwargs...)
    n = AdaptiveOpticsSim.topology_axis_count(topology)
    full = fill(NaN, n * n)
    full[AdaptiveOpticsSim.active_actuator_indices(topology)] .= _plot_vector_data(command)
    return _heatmap2d(reshape(full, n, n); title=title, kwargs...)
end

function _dm_commands_figure(topology::AdaptiveOpticsSim.SampledActuatorTopology, command::AbstractVector;
    title::AbstractString="DM Commands", kwargs...)
    coords = AdaptiveOpticsSim.actuator_coordinates(topology)
    data = _plot_vector_data(command)
    return Plots.scatter(coords[1, :], coords[2, :];
        marker_z=data,
        xlabel="x",
        ylabel="y",
        title=title,
        aspect_ratio=:equal,
        colorbar=true,
        kwargs...)
end

_dm_opd_figure(dm::AdaptiveOpticsSim.AbstractDeformableMirror; title::AbstractString="DM OPD", kwargs...) =
    _opd_figure(AdaptiveOpticsSim.surface_opd(dm); title=title, kwargs...)

_dm_opd_figure(dm::AdaptiveOpticsSim.AbstractDeformableMirror, ::AdaptiveOpticsSim.AbstractTelescope; kwargs...) =
    _dm_opd_figure(dm; kwargs...)
