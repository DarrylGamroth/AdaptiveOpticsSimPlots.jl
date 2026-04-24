include(joinpath(@__DIR__, "common.jl"))

function transfer_functions(freq::AbstractVector{T}, loop_gain::T, Ti::T, Tau::T, Tdm::T) where {T<:AbstractFloat}
    S = complex.(zero(T), T(2π)) .* freq
    H_wfs = exp.(-Ti * S / 2)
    H_rtc = exp.(-Tau * S)
    H_dm = exp.(-Tdm * S)
    H_dac = (one(T) .- exp.(-S * Ti)) ./ (S * Ti)
    CC = loop_gain ./ (one(T) .- exp.(-S * Ti))
    H_ol = H_wfs .* H_rtc .* H_dac .* H_dm .* CC
    H_cl = H_ol ./ (one(T) .+ H_ol)
    H_er = one.(H_ol) ./ (one.(H_ol) .+ H_ol)
    H_n = H_cl ./ H_wfs
    return H_er, H_cl, H_ol, H_n
end

fs = 300.0
n_freq = 512
loop_gains = (0.2, 0.6)
freq = collect(range(fs / n_freq, fs / 2; length=n_freq - 1))
Ti = 1 / fs
Tau = Ti / 2
Tdm = Ti / 2

plt_rej = Plots.plot(; title="Rejection Transfer", xlabel="Hz", ylabel="dB")
plt_cl = Plots.plot(; title="Closed-Loop Transfer", xlabel="Hz", ylabel="dB")
for gain in loop_gains
    H_er, H_cl, _, _ = transfer_functions(freq, Float64(gain), Ti, Tau, Tdm)
    Plots.plot!(plt_rej, freq, 20 .* log10.(abs.(H_er)); label="g=$(gain)")
    Plots.plot!(plt_cl, freq, 20 .* log10.(abs.(H_cl)); label="g=$(gain)")
end

display(Plots.plot(plt_rej, plt_cl; layout=(1, 2), size=(950, 380)))
