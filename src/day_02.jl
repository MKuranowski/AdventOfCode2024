# © Copyright 2024 Mikołaj Kuranowski
# SPDX-License-Identifier: MIT

function parse_report(line)
    [parse(Int, i) for i in split(line)]
end

function is_report_safe(report)
    deltas = Set(b - a for (a, b) in zip(report[1:end-1], report[2:end]))
    return deltas ⊆ [-1 -2 -3] || deltas ⊆ [1 2 3]
end

function is_report_safe_with_dampener(report)
    if is_report_safe(report)
        return true
    end

    for i in 1:length(report)
        report_copy = copy(report)
        deleteat!(report_copy, i)
        if is_report_safe(report_copy)
            return true
        end
    end

    return false
end
