function _signal_trace_figure(signal::AbstractVector; title::AbstractString="Signal Trace",
    xlabel::AbstractString="sample", ylabel::AbstractString="value", label=nothing, kwargs...)
    data = _plot_vector_data(signal)
    series_label = isnothing(label) ? nothing : String(label)
    return Plots.plot(eachindex(data), data;
        title=title,
        xlabel=xlabel,
        ylabel=ylabel,
        label=series_label,
        kwargs...)
end

function _runtime_timeseries_figure(log::NamedTuple; fields=nothing, title::AbstractString="Runtime Timeseries",
    xlabel::AbstractString="sample", ylabel::AbstractString="value", kwargs...)
    names = isnothing(fields) ? propertynames(log) : Tuple(fields)
    plt = Plots.plot(; title=title, xlabel=xlabel, ylabel=ylabel, kwargs...)
    for name in names
        data = _plot_vector_data(getproperty(log, name))
        Plots.plot!(plt, eachindex(data), data; label=String(name))
    end
    return plt
end

function _runtime_timeseries_figure(log::AbstractVector{<:NamedTuple}; fields=nothing, title::AbstractString="Runtime Timeseries",
    xlabel::AbstractString="sample", ylabel::AbstractString="value", kwargs...)
    isempty(log) && throw(ArgumentError("runtime log must not be empty"))
    names = isnothing(fields) ? propertynames(first(log)) : Tuple(fields)
    plt = Plots.plot(; title=title, xlabel=xlabel, ylabel=ylabel, kwargs...)
    for name in names
        data = [getproperty(entry, name) for entry in log]
        Plots.plot!(plt, eachindex(data), data; label=String(name))
    end
    return plt
end
