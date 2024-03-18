function normalizedVec = normalizeVector(vec, lowerBound, upperBound)
    % 检查输入是否有效
    if lowerBound >= upperBound
        error('下界必须小于上界');
    end
    if ~isvector(vec)
        error('输入必须是一维向量');
    end

    % 计算原始向量的最小值和最大值
    minVec = min(vec);
    maxVec = max(vec);

    % 归一化向量
    % 首先将向量转换到 0-1 范围
    normalizedVec = (vec - minVec) / (maxVec - minVec);

    % 然后将向量转换到 lowerBound 和 upperBound 范围
    normalizedVec = normalizedVec * (upperBound - lowerBound) + lowerBound;
end
