plot_dm_commands(dm::AdaptiveOpticsSim.AbstractDeformableMirror; kwargs...) =
    plot_dm_commands(AdaptiveOpticsSim.topology(dm), AdaptiveOpticsSim.command_storage(dm); kwargs...)

function plot_dm_commands(topology::AdaptiveOpticsSim.ActuatorGridTopology, command::AbstractVector;
    title::AbstractString="DM Commands", kwargs...)
    n = AdaptiveOpticsSim.topology_axis_count(topology)
    full = fill(NaN, n * n)
    full[AdaptiveOpticsSim.active_actuator_indices(topology)] .= _plot_vector_data(command)
    return _heatmap2d(reshape(full, n, n); title=title, kwargs...)
end

function plot_dm_commands(topology::AdaptiveOpticsSim.SampledActuatorTopology, command::AbstractVector;
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

plot_dm_opd(dm::AdaptiveOpticsSim.AbstractDeformableMirror; title::AbstractString="DM OPD", kwargs...) =
    plot_opd(AdaptiveOpticsSim.surface_opd(dm); title=title, kwargs...)

plot_dm_opd(dm::AdaptiveOpticsSim.AbstractDeformableMirror, ::AdaptiveOpticsSim.AbstractTelescope; kwargs...) =
    plot_dm_opd(dm; kwargs...)
